// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "UIView+LYTTestHelpers.h"
#import "UIView+LYTHelpers.h"
#import "LYTConfig.h"


NS_ASSUME_NONNULL_BEGIN

@implementation UIView (LYTTestHelpers)

- (void)lyt_assertViewWithinSuperViewBounds:(void(^)(NSString *error, UIView *view))errorBlock {
    if (!self.superview) {
        return;
    }

    CGFloat epsilon = [LYTConfig sharedInstance].cgFloatEpsilon;

    NSString *viewName = [NSString stringWithFormat:@"%@ (superview: %@)", self, self.superview];

    if (self.lyt_left < -epsilon) {
        errorBlock([NSString stringWithFormat:@"X location is less than zero for %@", viewName], self);
    }
    if (self.lyt_top < -epsilon) {
        errorBlock([NSString stringWithFormat:@"Y location is less than zero for %@", viewName], self);
    }
    if (self.lyt_right > self.superview.lyt_width + epsilon) {
        errorBlock([NSString stringWithFormat:@"Right side extends past superview for %@", viewName], self);
    }
    if (self.lyt_bottom > self.superview.lyt_height + epsilon) {
        errorBlock([NSString stringWithFormat:@"Bottom side extends past superview for %@", viewName], self);
    }
}

- (void)lyt_assertNoSubviewsOverlap:(void(^)(NSString *error, UIView *view1, UIView *view2))errorBlock {
    NSInteger subviewsCount = [self.subviews count];

    CGFloat epsilon = [LYTConfig sharedInstance].cgFloatEpsilon;

    // Using indexes to remove half of the checks
    for (NSInteger i = 0; i < subviewsCount - 1; ++i) {
        UIView *subview1 = [self.subviews objectAtIndex:i];
        for (NSInteger j = i + 1; j < subviewsCount; ++j) {
            UIView *subview2 = [self.subviews objectAtIndex:j];
            // The check ensures two views intersect
            // Evading false positives due to computation tolerance
            if (subview1.lyt_bottom > subview2.lyt_top + epsilon &&
                subview1.lyt_right > subview2.lyt_left + epsilon &&
                subview2.lyt_bottom > subview1.lyt_top + epsilon &&
                subview2.lyt_right > subview1.lyt_left + epsilon) {

                // Sorting subview1 and subview2 so subview1 is on the left.
                UIView *sortedSubview1 = nil;
                UIView *sortedSubview2 = nil;
                if (subview1.lyt_left > subview2.lyt_left) {
                    sortedSubview1 = subview2;
                    sortedSubview2 = subview1;
                } else {
                    sortedSubview1 = subview1;
                    sortedSubview2 = subview2;
                }
                errorBlock([NSString stringWithFormat:@"%@ right corner of %@ overlaps %@ left corner of %@.",
                            sortedSubview1.lyt_top > sortedSubview2.lyt_top ? @"Upper" : @"Bottom",
                            sortedSubview1,
                            sortedSubview1.lyt_top > sortedSubview2.lyt_top ? @"bottom" : @"upper",
                            sortedSubview2],
                           sortedSubview1, sortedSubview2);
            }
        }
    }
}

- (void)lyt_recursivelyAssertViewWithinSuperViewBounds:(void(^)(NSString *error, UIView *view))errorBlock {
    [self lyt_recursivelyTraverseViewHierarchy:^(UIView *subview) {
        [subview lyt_assertViewWithinSuperViewBounds:errorBlock];
    }];
}

- (void)lyt_recursivelyAssertNoSubviewsOverlap:(void(^)(NSString *error, UIView *view1, UIView *view2))errorBlock {
    [self lyt_recursivelyTraverseViewHierarchy:^(UIView *subview) {
        [subview lyt_assertNoSubviewsOverlap:errorBlock];
    }];
}

- (void)lyt_recursivelyTraverseViewHierarchy:(void(^)(UIView *))subviewBlock {
    [self lyt_recursivelyTraverseViewHierarchyWithStop:^(UIView *subview, BOOL *stopBranch) {
        subviewBlock(subview);
    }];
}

- (void)lyt_recursivelyTraverseViewHierarchyWithStop:(void(^)(UIView *subview, BOOL *stopBranch))subviewBlock {
    BOOL stopRecursing = NO;
    subviewBlock(self, &stopRecursing);

    if (!stopRecursing) {
        for (UIView *subview in self.subviews) {
            [subview lyt_recursivelyTraverseViewHierarchyWithStop:subviewBlock];
        }
    }
}

@end

NS_ASSUME_NONNULL_END
