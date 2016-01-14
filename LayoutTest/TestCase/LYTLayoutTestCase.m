// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LYTLayoutTestCase.h"
#import "LYTConfig.h"
#import "LYTLayoutPropertyTester.h"
#import "UIView+LYTTestHelpers.h"
#import "LYTAutolayoutFailureIntercepter.h"


NS_ASSUME_NONNULL_BEGIN

@interface LYTLayoutTestCase ()

@property (nonatomic, strong) NSMutableSet *viewsAllowingOverlap;
@property (nonatomic, strong) NSMutableSet *viewsAllowingAccessibilityErrors;

@end

@implementation LYTLayoutTestCase

#pragma mark - Public

#pragma mark - Running Tests

- (void)runLayoutTestsWithViewProvider:(Class)viewProvider
                                validation:(void(^)(id, NSDictionary *, id _Nullable))validation {
    [self runLayoutTestsWithViewProvider:viewProvider
                                limitResults:LYTTesterLimitResultsNone
                                  validation:validation];
}

- (void)runLayoutTestsWithViewProvider:(Class)viewProvider
                              limitResults:(LYTTesterLimitResults)limitResults
                                validation:(void(^)(id view, NSDictionary *data, id _Nullable context))validation {
    // It's too early to do this in setUp because they may override this property in setUp. So, let's do it here. It's ok if we call this multiple times per test. We'll just clean up in tearDown.
    if (self.interceptsAutolayoutErrors) {
        [LYTAutolayoutFailureIntercepter interceptAutolayoutFailuresWithBlock:^{
            [self failTest:@"Failing test due to autolayout failure." view:nil];
        }];
    }

    [LYTLayoutPropertyTester runPropertyTestsWithViewProvider:viewProvider
                                                     limitResults:limitResults
                                                       validation:^(id view, NSDictionary *data, id _Nullable context) {

                                                           // We must run this first to give the user a chance to add to viewsAllowingOverlap
                                                           validation(view, data, context);

                                                           // Now, let's run our tests
                                                           [self runBasicRecursiveViewTests:view];

                                                           // Now, let's reset these for the next run
                                                           self.viewsAllowingOverlap = [NSMutableSet set];
                                                           self.viewsAllowingAccessibilityErrors = [NSMutableSet set];
                                                       }];
}

#pragma mark - Test Lifecycle

- (void)setUp {
    [super setUp];

    // Config

    self.viewOverlapTestsEnabled = [LYTConfig sharedInstance].viewOverlapTestsEnabled;
    self.viewWithinSuperviewTestsEnabled = [LYTConfig sharedInstance].viewWithinSuperviewTestsEnabled;
    self.ambiguousAutolayoutTestsEnabled = [LYTConfig sharedInstance].ambiguousAutolayoutTestsEnabled;
    self.interceptsAutolayoutErrors = [LYTConfig sharedInstance].interceptsAutolayoutErrors;
    self.accessibilityTestsEnabled = [LYTConfig sharedInstance].accessibilityTestsEnabled;
    self.viewClassesRequiringAccessibilityLabels = [LYTConfig sharedInstance].viewClassesRequiringAccessibilityLabels;
    self.viewClassesAllowingSubviewErrors = [LYTConfig sharedInstance].viewClassesAllowingSubviewErrors;

    // Initialize

    self.viewsAllowingOverlap = [NSMutableSet set];
    self.viewsAllowingAccessibilityErrors = [NSMutableSet set];
}

- (void)tearDown {
    if (self.interceptsAutolayoutErrors) {
        [LYTAutolayoutFailureIntercepter stopInterceptingAutolayoutFailures];
    }

    [super tearDown];
}

#pragma mark - Helpers

- (void)recursivelyIgnoreOverlappingSubviewsOnView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        [self.viewsAllowingOverlap addObject:subview];
        [self recursivelyIgnoreOverlappingSubviewsOnView:subview];
    }
}

#pragma mark - Private

#pragma mark - Basic View Tests

/**
 This method runs all the basic recursive tests that we run automatically. We want to lump these tests together because we only want to recurse the view hierarchy once (for performance reasons).
 */
- (void)runBasicRecursiveViewTests:(UIView *)view {
    view = [LYTLayoutTestCase viewForSubviewTesting:view];

    [view lyt_recursivelyTraverseViewHierarchyWithStop:^(UIView *subview, BOOL *stopBranch) {
        if ([LYTLayoutTestCase class:[subview class] includedInSet:self.viewClassesAllowingSubviewErrors]) {
            *stopBranch = YES;
        } else {
            [self runSubviewsOverlapTestsWithSubview:subview view:view];
            [self runSubviewWithSuperviewTestsWithSubview:subview view:view];
            [self runAccessibilityTestsWithSubview:subview view:view];
            [self runAmbiguousLayoutTestsWithSubview:subview view:view];
        }
    }];
}

- (void)runSubviewsOverlapTestsWithSubview:(UIView *)subview view:(UIView *)view {
    if (self.viewOverlapTestsEnabled) {
        [subview lyt_assertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
            if (![self.viewsAllowingOverlap containsObject:view1] &&
                ![self.viewsAllowingOverlap containsObject:view2] &&
                !view1.hidden &&
                !view2.hidden) {
                NSString *errorMessage = [NSString stringWithFormat:@"%@ If this is intentional, you should add one of the views to viewsAllowingOverlap.", error];
                [self failTest:errorMessage view:view];
            }
        }];
    }
}

- (void)runSubviewWithSuperviewTestsWithSubview:(UIView *)subview view:(UIView *)view {
    if (self.viewWithinSuperviewTestsEnabled) {
        [subview lyt_assertViewWithinSuperViewBounds:^(NSString *error, UIView *view1) {
            if (![self.viewsAllowingOverlap containsObject:view1] &&
                !view1.hidden) {
                NSString *errorMessage = [NSString stringWithFormat:@"%@ If this is intentional, you should add the subview to viewsAllowingOverlap.", error];
                [self failTest:errorMessage view:view];
            }
        }];
    }
}

- (void)runAccessibilityTestsWithSubview:(UIView *)subview view:(UIView *)view {
    if (self.accessibilityTestsEnabled) {
        if (![self.viewsAllowingAccessibilityErrors containsObject:subview]) {
            if (subview.accessibilityLabel != nil) {
                UIView *superviewWithaccessibility = [LYTLayoutTestCase firstSuperviewWithAccessibilityLabel:subview];
                if (superviewWithaccessibility) {
                    NSString *message = [NSString stringWithFormat:@"Subview has an accessibility label, but one of it's superviews also has an accessibility label. You cannot nest elements with accessibility labels because nested elements won't be reachable for accessibility users. Consider adding this subview to viewsAllowingAccessibilityErrors if this is intentional. Subview: %@ Superview: %@", subview, superviewWithaccessibility];
                    [self failTest:message view:view];
                }
            }
            if ([LYTLayoutTestCase class:[subview class] includedInSet:self.viewClassesRequiringAccessibilityLabels] &&
                subview.accessibilityLabel == nil &&
                !subview.hidden) {
                NSString *message = [NSString stringWithFormat:@"Subview has class %@ but has no accessibility label. This will make it impossible for accessibility users to interact with this element. Consider adding this view to viewsAllowingAccessibilityErrors if this is intentional.\n%@", NSStringFromClass([subview class]), subview];
                [self failTest:message view:view];
            }
            if (subview.accessibilityIdentifier && !subview.accessibilityLabel) {
                NSString *message = [NSString stringWithFormat:@"Subview has an accessibility identifier, but doesn't have an accessibility label. This means that the voice over will read the accessibility identifier instead of the label! You should always add an accessibility label if it has an identifier. Consider adding this view to viewsAllowingAccessibilityErrors if this is intentional.\n%@", subview];
                [self failTest:message view:view];
            }
        }
    }
}

- (void)runAmbiguousLayoutTestsWithSubview:(UIView *)subview view:(UIView *)view {
    if (self.ambiguousAutolayoutTestsEnabled) {
        if ([subview hasAmbiguousLayout]) {
            NSString *errorMessage = [NSString stringWithFormat:@"View has ambiguous layout. This probably means you have not added enough constraints to your view. View: %@", subview];
            [self failTest:errorMessage view:view];
        }
    }
}

#pragma mark - Testing

- (void)failTest:(NSString *)errorMessage view:(nullable UIView *)view {
    XCTFail(@"%@", errorMessage);
}

#pragma mark - Private Functional (Class) Methods

/**
 This method takes a view and returns a view for doing bounds and overlap testing. For table view cells and collection view cells, we want to use the contentView, because UIKit has some overlapping views internally on the cells.
 */
+ (UIView *)viewForSubviewTesting:(UIView *)view {
    if ([view isKindOfClass:[UITableViewCell class]]) {
        return ((UITableViewCell *)view).contentView;
    } else if ([view isKindOfClass:[UICollectionViewCell class]]) {
        return ((UICollectionViewCell *)view).contentView;
    } else {
        return view;
    }
}

+ (BOOL)class:(Class)aClass includedInSet:(NSSet *)set {
    for (Class compareClass in set) {
        if ([aClass isSubclassOfClass:compareClass]) {
            return YES;
        }
    }
    return NO;
}

+ (UIView *)firstSuperviewWithAccessibilityLabel:(UIView *)view {
    if (view.superview == nil) {
        return nil;
    } else if (view.superview.accessibilityLabel != nil) {
        return view.superview;
    } else {
        return [self firstSuperviewWithAccessibilityLabel:view.superview];
    }
}

@end

NS_ASSUME_NONNULL_END
