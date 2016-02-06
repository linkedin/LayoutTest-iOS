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
#import "LYTLayoutFailingTestSnapshotRecorder.h"

NS_ASSUME_NONNULL_BEGIN

@interface LayoutSnapshotObserver : NSObject<XCTestObservation>

@end

@implementation LayoutSnapshotObserver {
    NSMutableSet *failingTestsSnapshotFolder;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        failingTestsSnapshotFolder = [NSMutableSet set];
    }
    return self;
}

- (void)testBundleDidFinish:(NSBundle *)testBundle {
    if (failingTestsSnapshotFolder.count > 0) {
        MyLog(@"\nSnapshots of failing tests can be found in:\n");
        for (NSString *path in failingTestsSnapshotFolder) {
            MyLog(@"%@\n", path);
        }
    }
}

- (void)testCase:(XCTestCase *)testCase didFailWithDescription:(NSString *)description inFile:(nullable NSString *)filePath atLine:(NSUInteger)lineNumber {
    if (![testCase isKindOfClass:[LYTLayoutTestCase class]]) {
        return;
    }
    NSString *pathForSnapshots = [testCase.class performSelector:@selector(commonRootPath)];
    pathForSnapshots = [pathForSnapshots stringByAppendingString:@"/index.html"];
    [failingTestsSnapshotFolder addObject:pathForSnapshots];
}

void MyLog(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *formattedString = [[NSString alloc] initWithFormat:format
                                                       arguments:args];
    va_end(args);
    [[NSFileHandle fileHandleWithStandardOutput] writeData:[formattedString dataUsingEncoding:NSNEXTSTEPStringEncoding]];
}

@end

@interface LYTLayoutTestCase ()

@property (nonatomic, strong) NSMutableSet *viewsAllowingOverlap;
@property (nonatomic, strong) NSMutableSet *viewsAllowingAccessibilityErrors;
@property (nonatomic, strong) UIView *viewUnderTest;
@property (nonatomic, strong) NSDictionary *dataForViewUnderTest;

@end

@implementation LYTLayoutTestCase

#pragma mark - Public

#pragma mark - Running Tests

+ (void)initialize {
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        XCTestObservationCenter *observationCenter = [XCTestObservationCenter sharedTestObservationCenter];
        LayoutSnapshotObserver *testObserver = [LayoutSnapshotObserver new];
        [observationCenter addTestObserver:testObserver];
    });
}

+ (void)setUp {
    [super setUp];
    [[LYTLayoutFailingTestSnapshotRecorder sharedInstance] startNewLogForClass:self.class];
}

+ (void)tearDown {
    [super tearDown];
    [[LYTLayoutFailingTestSnapshotRecorder sharedInstance] finishLog];
}

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

                                                           self.viewUnderTest = view;
                                                           self.dataForViewUnderTest = data;
                                                           
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
    self.enableFailingTestSnapshots = [LYTConfig sharedInstance].enableFailingTestSnapshots;
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

#pragma mark Failing Test Snapshots

- (void)recordFailureWithDescription:(NSString *)description inFile:(NSString *)filePath atLine:(NSUInteger)lineNumber expected:(BOOL)expected {
    [super recordFailureWithDescription:description inFile:filePath atLine:lineNumber expected:expected];
    if (self.enableFailingTestSnapshots) {
        [[LYTLayoutFailingTestSnapshotRecorder sharedInstance] saveImageOfCurrentViewWithInvocation:self.invocation failureDescription:description];
    }
}

+ (NSString *)commonRootPath {
    NSString *currentDirectory = [[NSBundle bundleForClass:[self class]] bundlePath];
    NSString *className = NSStringFromClass(self.class);
    //Check incase the class name includes a ".", if so we the actual class name will be everything after the "."
    if ([className containsString:@"."]) {
        className = [className componentsSeparatedByString:@"."].lastObject;
    }
    
    return [currentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"LayoutTestImages/%@", className]];
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
