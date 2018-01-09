// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <XCTest/XCTest.h>
#import "UIView+LYTTestHelpers.h"
#import "UIView+LYTHelpers.h"
#import "LYTConfig.h"


/**
 These tests all use a common setup.
 
 Super view is 10x10 with one subview.
 This subview is 10x10 with two subviews.
 These subviews are both 5x10 and laid out next to each other.
 */
@interface TestHelpersTests : XCTestCase

@property (nonatomic, strong) UIView *superview;
@property (nonatomic, strong) UIView *subview;
@property (nonatomic, strong) UIView *innerSubview1;
@property (nonatomic, strong) UIView *innerSubview2;

@end

@implementation TestHelpersTests

- (void)setUp {
    [super setUp];

    self.superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.innerSubview1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
    self.innerSubview2 = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 5, 10)];
    [self.superview addSubview:self.subview];
    [self.subview addSubview:self.innerSubview1];
    [self.subview addSubview:self.innerSubview2];
}

#pragma mark - No errors

- (void)testNoErrorsByDefault {
    __block NSInteger numberOfErrors = 0;
    void(^block)(NSString *error, UIView *view1, UIView *view2) = ^void(NSString *error, UIView *view1, UIView *view2) {
        numberOfErrors++;
    };
    void(^block2)(NSString *error, UIView *view1) = ^void(NSString *error, UIView *view1) {
        numberOfErrors++;
    };

    [self.superview lyt_recursivelyAssertNoSubviewsOverlap:block];
    [self.superview lyt_recursivelyAssertViewWithinSuperViewBounds:block2];

    XCTAssertEqual(numberOfErrors, 0);
}

#pragma mark - Assert within superview bounds

- (void)testWithinSuperviewBoundsUpper {
    self.subview.lyt_top = -1;

    __block NSInteger numberOfErrors = 0;
    [self.subview lyt_assertViewWithinSuperViewBounds:^(NSString *error, UIView *view) {
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);

    numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertViewWithinSuperViewBounds:^(NSString *error, UIView *view) {
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);
}

- (void)testWithinSuperviewBoundsLeft {
    self.subview.lyt_left = -1;

    __block NSInteger numberOfErrors = 0;
    [self.subview lyt_assertViewWithinSuperViewBounds:^(NSString *error, UIView *view) {
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);

    numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertViewWithinSuperViewBounds:^(NSString *error, UIView *view) {
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);
}

- (void)testWithinSuperviewBoundsRight {
    self.subview.lyt_left = 1;

    __block NSInteger numberOfErrors = 0;
    [self.subview lyt_assertViewWithinSuperViewBounds:^(NSString *error, UIView *view) {
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);

    numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertViewWithinSuperViewBounds:^(NSString *error, UIView *view) {
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);
}

- (void)testWithinSuperviewBoundsBottom {
    self.subview.lyt_top = 1;

    __block NSInteger numberOfErrors = 0;
    [self.subview lyt_assertViewWithinSuperViewBounds:^(NSString *error, UIView *view) {
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);

    numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertViewWithinSuperViewBounds:^(NSString *error, UIView *view) {
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);
}

- (void)testWithinSuperviewBoundsUpperEpsilon {
    self.subview.lyt_top = -0.0000001;

    __block NSInteger numberOfErrors = 0;
    [self.subview lyt_assertViewWithinSuperViewBounds:^(NSString *error, UIView *view) {
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 0);

    numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertViewWithinSuperViewBounds:^(NSString *error, UIView *view) {
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 0);
}

- (void)testWithinSuperviewBoundsLeftEpsilon {
    self.subview.lyt_left = -0.0000001;

    __block NSInteger numberOfErrors = 0;
    [self.subview lyt_assertViewWithinSuperViewBounds:^(NSString *error, UIView *view) {
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 0);

    numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertViewWithinSuperViewBounds:^(NSString *error, UIView *view) {
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 0);
}

- (void)testWithinSuperviewBoundsRightEpsilon {
    self.subview.lyt_left = 0.0000001;

    __block NSInteger numberOfErrors = 0;
    [self.subview lyt_assertViewWithinSuperViewBounds:^(NSString *error, UIView *view) {
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 0);

    numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertViewWithinSuperViewBounds:^(NSString *error, UIView *view) {
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 0);
}

- (void)testWithinSuperviewBoundsBottomEpsilon {
    self.subview.lyt_top = 0.0000001;

    __block NSInteger numberOfErrors = 0;
    [self.subview lyt_assertViewWithinSuperViewBounds:^(NSString *error, UIView *view) {
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 0);

    numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertViewWithinSuperViewBounds:^(NSString *error, UIView *view) {
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 0);
}

#pragma mark - lyt_assertNoSubviewsOverlap

- (void)testOverlapTopRight {
    self.innerSubview1.frame = CGRectMake(0, 5, 6, 5);
    self.innerSubview2.frame = CGRectMake(5, 0, 5, 6);

    __block NSInteger numberOfErrors = 0;
    [self.subview lyt_assertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        XCTAssertEqual(view1, self.innerSubview1);
        XCTAssertEqual(view2, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);

    numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        XCTAssertEqual(view1, self.innerSubview1);
        XCTAssertEqual(view2, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);
}

- (void)testOverlapTopLeft {
    self.innerSubview1.frame = CGRectMake(5, 5, 5, 5);
    self.innerSubview2.frame = CGRectMake(0, 0, 6, 6);

    __block NSInteger numberOfErrors = 0;
    [self.subview lyt_assertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        // View one is always on the left
        XCTAssertEqual(view2, self.innerSubview1);
        XCTAssertEqual(view1, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);

    numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        // View one is always on the left
        XCTAssertEqual(view2, self.innerSubview1);
        XCTAssertEqual(view1, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);
}

- (void)testOverlapBottomRight {
    self.innerSubview1.frame = CGRectMake(0, 0, 6, 6);
    self.innerSubview2.frame = CGRectMake(5, 5, 5, 5);

    __block NSInteger numberOfErrors = 0;
    [self.subview lyt_assertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        XCTAssertEqual(view1, self.innerSubview1);
        XCTAssertEqual(view2, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);

    numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        XCTAssertEqual(view1, self.innerSubview1);
        XCTAssertEqual(view2, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);
}

- (void)testOverlapBottomLeft {
    self.innerSubview1.frame = CGRectMake(5, 0, 5, 6);
    self.innerSubview2.frame = CGRectMake(0, 5, 6, 5);

    __block NSInteger numberOfErrors = 0;
    [self.subview lyt_assertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        XCTAssertEqual(view2, self.innerSubview1);
        XCTAssertEqual(view1, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);

    numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        // View one is always on the left
        XCTAssertEqual(view2, self.innerSubview1);
        XCTAssertEqual(view1, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);
}

- (void)testOverlapTopRightEpsilon {
    self.innerSubview1.frame = CGRectMake(0, 5, 5.0000001, 5);
    self.innerSubview2.frame = CGRectMake(5, 0, 5, 5.0000001);

    __block NSInteger numberOfErrors = 0;
    [self.subview lyt_assertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        XCTAssertEqual(view1, self.innerSubview1);
        XCTAssertEqual(view2, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 0);

    numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        XCTAssertEqual(view1, self.innerSubview1);
        XCTAssertEqual(view2, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 0);
}

- (void)testOverlapTopLeftEpsilon {
    self.innerSubview1.frame = CGRectMake(5, 5, 5, 5);
    self.innerSubview2.frame = CGRectMake(0, 0, 5.0000001, 5.0000001);

    __block NSInteger numberOfErrors = 0;
    [self.subview lyt_assertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        // View one is always on the left
        XCTAssertEqual(view2, self.innerSubview1);
        XCTAssertEqual(view1, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 0);

    numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        XCTAssertEqual(view1, self.innerSubview1);
        XCTAssertEqual(view2, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 0);
}

- (void)testOverlapBottomRightEpsilon {
    self.innerSubview1.frame = CGRectMake(0, 0, 5.0000001, 5.0000001);
    self.innerSubview2.frame = CGRectMake(5, 5, 5, 5);

    __block NSInteger numberOfErrors = 0;
    [self.subview lyt_assertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        XCTAssertEqual(view1, self.innerSubview1);
        XCTAssertEqual(view2, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 0);

    numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        XCTAssertEqual(view1, self.innerSubview1);
        XCTAssertEqual(view2, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 0);
}

- (void)testOverlapBottomLeftEpsilon {
    self.innerSubview1.frame = CGRectMake(5, 0, 5, 5.0000001);
    self.innerSubview2.frame = CGRectMake(0, 5, 5.0000001, 5);

    __block NSInteger numberOfErrors = 0;
    [self.subview lyt_assertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        XCTAssertEqual(view2, self.innerSubview1);
        XCTAssertEqual(view1, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 0);

    numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        XCTAssertEqual(view1, self.innerSubview1);
        XCTAssertEqual(view2, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 0);
}

#pragma mark - lyt_assertNoSubviewsOverlap

- (void)testRecursiveOverlapTopRight {
    self.innerSubview1.frame = CGRectMake(0, 5, 6, 5);
    self.innerSubview2.frame = CGRectMake(5, 0, 5, 6);

    __block NSInteger numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        XCTAssertEqual(view1, self.innerSubview1);
        XCTAssertEqual(view2, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);
}

- (void)testRecursiveOverlapTopLeft {
    self.innerSubview1.frame = CGRectMake(5, 5, 5, 5);
    self.innerSubview2.frame = CGRectMake(0, 0, 6, 6);

    __block NSInteger numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        // View one is always on the left
        XCTAssertEqual(view2, self.innerSubview1);
        XCTAssertEqual(view1, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);
}

- (void)testRecursiveOverlapBottomRight {
    self.innerSubview1.frame = CGRectMake(0, 0, 6, 6);
    self.innerSubview2.frame = CGRectMake(5, 5, 5, 5);

    __block NSInteger numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        XCTAssertEqual(view1, self.innerSubview1);
        XCTAssertEqual(view2, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);
}

- (void)testRecursiveOverlapBottomLeft {
    self.innerSubview1.frame = CGRectMake(5, 0, 5, 6);
    self.innerSubview2.frame = CGRectMake(0, 5, 6, 5);

    __block NSInteger numberOfErrors = 0;
    [self.superview lyt_recursivelyAssertNoSubviewsOverlap:^(NSString *error, UIView *view1, UIView *view2) {
        XCTAssertEqual(view2, self.innerSubview1);
        XCTAssertEqual(view1, self.innerSubview2);
        numberOfErrors++;
    }];

    XCTAssertEqual(numberOfErrors, 1);
}

#pragma mark - Traverse Hierarchy

- (void)testRecursiveTraverse {
    NSMutableSet *views = [NSMutableSet set];
    [self.superview lyt_recursivelyTraverseViewHierarchy:^(UIView *subview) {
        XCTAssertFalse([views containsObject:subview]);
        [views addObject:subview];
    }];

    XCTAssertTrue([views containsObject:self.superview]);
    XCTAssertTrue([views containsObject:self.subview]);
    XCTAssertTrue([views containsObject:self.innerSubview1]);
    XCTAssertTrue([views containsObject:self.innerSubview2]);
    XCTAssertEqual(views.count, 4);
}

- (void)testRecursiveTraverseWithStop {
    NSMutableSet *views = [NSMutableSet set];
    [self.superview lyt_recursivelyTraverseViewHierarchyWithStop:^(UIView *subview, BOOL *stopBranch) {
        XCTAssertFalse([views containsObject:subview]);
        [views addObject:subview];

        if (subview == self.subview) {
            *stopBranch = YES;
        }
    }];

    XCTAssertTrue([views containsObject:self.superview]);
    XCTAssertTrue([views containsObject:self.subview]);
    XCTAssertEqual(views.count, 2);
}

- (void)testRecursiveTraverseWithStopInner {
    NSMutableSet *views = [NSMutableSet set];
    [self.superview lyt_recursivelyTraverseViewHierarchyWithStop:^(UIView *subview, BOOL *stopBranch) {
        XCTAssertFalse([views containsObject:subview]);
        [views addObject:subview];

        if (subview == self.innerSubview1) {
            *stopBranch = YES;
        }
    }];

    // Even though we stopped on innerSubview1, we should still get all the views because it has no subview
    XCTAssertTrue([views containsObject:self.superview]);
    XCTAssertTrue([views containsObject:self.subview]);
    XCTAssertTrue([views containsObject:self.innerSubview1]);
    XCTAssertTrue([views containsObject:self.innerSubview2]);
    XCTAssertEqual(views.count, 4);
}

@end
