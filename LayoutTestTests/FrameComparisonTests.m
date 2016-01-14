// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <XCTest/XCTest.h>
#import "UIView+LYTFrameComparison.h"
#import "UIView+LYTHelpers.h"


@interface LanguageChangingView : UIView

@end

@interface FrameComparisonTests : XCTestCase

@property (nonatomic, strong) LanguageChangingView *superview;
@property (nonatomic, strong) LanguageChangingView *innerSubview1;
@property (nonatomic, strong) LanguageChangingView *innerSubview2;

@end

static BOOL isLeftToRight = YES;

@implementation FrameComparisonTests

- (void)setUp {
    [super setUp];

    self.superview = [[LanguageChangingView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.innerSubview1 = [[LanguageChangingView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.innerSubview2 = [[LanguageChangingView alloc] initWithFrame:CGRectMake(5, 5, 5, 5)];
    [self.superview addSubview:self.innerSubview1];
    [self.superview addSubview:self.innerSubview2];

    // Default
    isLeftToRight = YES;
}

#pragma mark - Before

- (void)testBeforeLeftToRight {

    // Success expected

    XCTAssertTrue([self.innerSubview1 lyt_before:self.innerSubview2]);
    self.innerSubview1.lyt_left = -1;
    XCTAssertTrue([self.innerSubview1 lyt_before:self.innerSubview2]);
    self.innerSubview1.lyt_left = 0.0000001;
    XCTAssertTrue([self.innerSubview1 lyt_before:self.innerSubview2]);

    // Failure expected

    self.innerSubview1.lyt_left = 1;
    XCTAssertFalse([self.innerSubview1 lyt_before:self.innerSubview2]);
    self.innerSubview1.lyt_left = 0;
    XCTAssertFalse([self.innerSubview2 lyt_before:self.innerSubview1]);
}

- (void)testBeforeRightToLeft {

    isLeftToRight = NO;

    // Success expected

    XCTAssertTrue([self.innerSubview2 lyt_before:self.innerSubview1]);
    self.innerSubview2.lyt_left = 6;
    XCTAssertTrue([self.innerSubview2 lyt_before:self.innerSubview1]);
    self.innerSubview2.lyt_left = 4.999999;
    XCTAssertTrue([self.innerSubview2 lyt_before:self.innerSubview1]);

    // Failure expected

    self.innerSubview2.lyt_left = 4;
    XCTAssertFalse([self.innerSubview1 lyt_before:self.innerSubview2]);
    self.innerSubview2.lyt_left = 5;
    XCTAssertFalse([self.innerSubview1 lyt_before:self.innerSubview2]);
}

#pragma mark - After

- (void)testAfterLeftToRight {

    // Success expected

    XCTAssertTrue([self.innerSubview2 lyt_after:self.innerSubview1]);
    self.innerSubview2.lyt_left = 6;
    XCTAssertTrue([self.innerSubview2 lyt_after:self.innerSubview1]);
    self.innerSubview2.lyt_left = 4.999999;
    XCTAssertTrue([self.innerSubview2 lyt_after:self.innerSubview1]);

    // Failure expected

    self.innerSubview2.lyt_left = 4;
    XCTAssertFalse([self.innerSubview1 lyt_after:self.innerSubview2]);
    self.innerSubview2.lyt_left = 5;
    XCTAssertFalse([self.innerSubview1 lyt_after:self.innerSubview2]);
}

- (void)testAfterRightToLeft {

    isLeftToRight = NO;

    // Success expected

    XCTAssertTrue([self.innerSubview1 lyt_after:self.innerSubview2]);
    self.innerSubview1.lyt_left = -1;
    XCTAssertTrue([self.innerSubview1 lyt_after:self.innerSubview2]);
    self.innerSubview1.lyt_left = 0.0000001;
    XCTAssertTrue([self.innerSubview1 lyt_after:self.innerSubview2]);

    // Failure expected

    self.innerSubview1.lyt_left = 1;
    XCTAssertFalse([self.innerSubview1 lyt_after:self.innerSubview2]);
    self.innerSubview1.lyt_left = 0;
    XCTAssertFalse([self.innerSubview2 lyt_after:self.innerSubview1]);
}

#pragma mark - Above

- (void)testAbove {

    // Success expected

    XCTAssertTrue([self.innerSubview1 lyt_above:self.innerSubview2]);
    self.innerSubview1.lyt_top = -1;
    XCTAssertTrue([self.innerSubview1 lyt_above:self.innerSubview2]);
    self.innerSubview1.lyt_top = 0.000001;
    XCTAssertTrue([self.innerSubview1 lyt_above:self.innerSubview2]);

    // Failure expected

    self.innerSubview1.lyt_top = 1;
    XCTAssertFalse([self.innerSubview1 lyt_above:self.innerSubview2]);
    self.innerSubview1.lyt_top = 0;
    XCTAssertFalse([self.innerSubview2 lyt_above:self.innerSubview1]);
}

#pragma mark - Below

- (void)testBelow {

    // Success expected

    XCTAssertTrue([self.innerSubview2 lyt_below:self.innerSubview1]);
    self.innerSubview2.lyt_top = 6;
    XCTAssertTrue([self.innerSubview2 lyt_below:self.innerSubview1]);
    self.innerSubview2.lyt_top = 4.999999;
    XCTAssertTrue([self.innerSubview2 lyt_below:self.innerSubview1]);

    // Failure expected

    self.innerSubview2.lyt_top = 4;
    XCTAssertFalse([self.innerSubview2 lyt_below:self.innerSubview1]);
    self.innerSubview2.lyt_top = 5;
    XCTAssertFalse([self.innerSubview1 lyt_below:self.innerSubview2]);
}

#pragma mark - Align Start

- (void)testAlignStartLeftToRight {

    // Make it so it isn't right aligned
    self.innerSubview2.lyt_width = 3;

    // Success expected

    self.innerSubview2.lyt_left = 0;
    XCTAssertTrue([self.innerSubview1 lyt_leadingAligned:self.innerSubview2]);
    XCTAssertTrue([self.innerSubview2 lyt_leadingAligned:self.innerSubview1]);
    self.innerSubview2.lyt_left = 0.000001;
    XCTAssertTrue([self.innerSubview1 lyt_leadingAligned:self.innerSubview2]);
    XCTAssertTrue([self.innerSubview2 lyt_leadingAligned:self.innerSubview1]);
    self.innerSubview2.lyt_left = -0.000001;
    XCTAssertTrue([self.innerSubview1 lyt_leadingAligned:self.innerSubview2]);
    XCTAssertTrue([self.innerSubview2 lyt_leadingAligned:self.innerSubview1]);

    // Failure expected
    self.innerSubview2.lyt_left = 1;
    XCTAssertFalse([self.innerSubview1 lyt_leadingAligned:self.innerSubview2]);
    XCTAssertFalse([self.innerSubview2 lyt_leadingAligned:self.innerSubview1]);
    self.innerSubview2.lyt_left = -1;
    XCTAssertFalse([self.innerSubview1 lyt_leadingAligned:self.innerSubview2]);
    XCTAssertFalse([self.innerSubview2 lyt_leadingAligned:self.innerSubview1]);
}

- (void)testAlignStartRightToLeft {

    isLeftToRight = NO;

    // Make it so it isn't left aligned
    self.innerSubview2.lyt_width = 3;

    // Success expected

    self.innerSubview2.lyt_right = 5;
    XCTAssertTrue([self.innerSubview1 lyt_leadingAligned:self.innerSubview2]);
    XCTAssertTrue([self.innerSubview2 lyt_leadingAligned:self.innerSubview1]);
    self.innerSubview2.lyt_right = 5.000001;
    XCTAssertTrue([self.innerSubview1 lyt_leadingAligned:self.innerSubview2]);
    XCTAssertTrue([self.innerSubview2 lyt_leadingAligned:self.innerSubview1]);
    self.innerSubview2.lyt_right = 4.999999;
    XCTAssertTrue([self.innerSubview1 lyt_leadingAligned:self.innerSubview2]);
    XCTAssertTrue([self.innerSubview2 lyt_leadingAligned:self.innerSubview1]);

    // Failure expected
    self.innerSubview2.lyt_right = 6;
    XCTAssertFalse([self.innerSubview1 lyt_leadingAligned:self.innerSubview2]);
    XCTAssertFalse([self.innerSubview2 lyt_leadingAligned:self.innerSubview1]);
    self.innerSubview2.lyt_right = 4;
    XCTAssertFalse([self.innerSubview1 lyt_leadingAligned:self.innerSubview2]);
    XCTAssertFalse([self.innerSubview2 lyt_leadingAligned:self.innerSubview1]);
}

#pragma mark - Align End

- (void)testAlignEnd {

    // Make it so it isn't left aligned
    self.innerSubview2.lyt_width = 3;

    // Success expected

    self.innerSubview2.lyt_right = 5;
    XCTAssertTrue([self.innerSubview1 lyt_trailingAligned:self.innerSubview2]);
    XCTAssertTrue([self.innerSubview2 lyt_trailingAligned:self.innerSubview1]);
    self.innerSubview2.lyt_right = 5.000001;
    XCTAssertTrue([self.innerSubview1 lyt_trailingAligned:self.innerSubview2]);
    XCTAssertTrue([self.innerSubview2 lyt_trailingAligned:self.innerSubview1]);
    self.innerSubview2.lyt_right = 4.999999;
    XCTAssertTrue([self.innerSubview1 lyt_trailingAligned:self.innerSubview2]);
    XCTAssertTrue([self.innerSubview2 lyt_trailingAligned:self.innerSubview1]);

    // Failure expected
    self.innerSubview2.lyt_right = 6;
    XCTAssertFalse([self.innerSubview1 lyt_trailingAligned:self.innerSubview2]);
    XCTAssertFalse([self.innerSubview2 lyt_trailingAligned:self.innerSubview1]);
    self.innerSubview2.lyt_right = 4;
    XCTAssertFalse([self.innerSubview1 lyt_trailingAligned:self.innerSubview2]);
    XCTAssertFalse([self.innerSubview2 lyt_trailingAligned:self.innerSubview1]);
}

- (void)testAlignEndRightToLeft {

    isLeftToRight = NO;

    // Make it so it isn't right aligned
    self.innerSubview2.lyt_width = 3;

    // Success expected

    self.innerSubview2.lyt_left = 0;
    XCTAssertTrue([self.innerSubview1 lyt_trailingAligned:self.innerSubview2]);
    XCTAssertTrue([self.innerSubview2 lyt_trailingAligned:self.innerSubview1]);
    self.innerSubview2.lyt_left = 0.000001;
    XCTAssertTrue([self.innerSubview1 lyt_trailingAligned:self.innerSubview2]);
    XCTAssertTrue([self.innerSubview2 lyt_trailingAligned:self.innerSubview1]);
    self.innerSubview2.lyt_left = -0.000001;
    XCTAssertTrue([self.innerSubview1 lyt_trailingAligned:self.innerSubview2]);
    XCTAssertTrue([self.innerSubview2 lyt_trailingAligned:self.innerSubview1]);

    // Failure expected
    self.innerSubview2.lyt_left = 1;
    XCTAssertFalse([self.innerSubview1 lyt_trailingAligned:self.innerSubview2]);
    XCTAssertFalse([self.innerSubview2 lyt_trailingAligned:self.innerSubview1]);
    self.innerSubview2.lyt_left = -1;
    XCTAssertFalse([self.innerSubview1 lyt_trailingAligned:self.innerSubview2]);
    XCTAssertFalse([self.innerSubview2 lyt_trailingAligned:self.innerSubview1]);
}

#pragma mark - Align Top

- (void)testAlignTop {

    // Make it so it isn't bottom aligned
    self.innerSubview2.lyt_height = 3;

    // Success expected

    self.innerSubview2.lyt_top = 0;
    XCTAssertTrue([self.innerSubview1 lyt_topAligned:self.innerSubview2]);
    XCTAssertTrue([self.innerSubview2 lyt_topAligned:self.innerSubview1]);
    self.innerSubview2.lyt_top = 0.000001;
    XCTAssertTrue([self.innerSubview1 lyt_topAligned:self.innerSubview2]);
    XCTAssertTrue([self.innerSubview2 lyt_topAligned:self.innerSubview1]);
    self.innerSubview2.lyt_top = -0.000001;
    XCTAssertTrue([self.innerSubview1 lyt_topAligned:self.innerSubview2]);
    XCTAssertTrue([self.innerSubview2 lyt_topAligned:self.innerSubview1]);

    // Failure expected
    self.innerSubview2.lyt_top = 1;
    XCTAssertFalse([self.innerSubview1 lyt_topAligned:self.innerSubview2]);
    XCTAssertFalse([self.innerSubview2 lyt_topAligned:self.innerSubview1]);
    self.innerSubview2.lyt_top = -1;
    XCTAssertFalse([self.innerSubview1 lyt_topAligned:self.innerSubview2]);
    XCTAssertFalse([self.innerSubview2 lyt_topAligned:self.innerSubview1]);
}

#pragma mark - Align Bottom

- (void)testAlignBottom {
    // Make it so it isn't top aligned
    self.innerSubview2.lyt_height = 3;

    // Success expected

    self.innerSubview2.lyt_bottom = 5;
    XCTAssertTrue([self.innerSubview1 lyt_bottomAligned:self.innerSubview2]);
    XCTAssertTrue([self.innerSubview2 lyt_bottomAligned:self.innerSubview1]);
    self.innerSubview2.lyt_bottom = 5.000001;
    XCTAssertTrue([self.innerSubview1 lyt_bottomAligned:self.innerSubview2]);
    XCTAssertTrue([self.innerSubview2 lyt_bottomAligned:self.innerSubview1]);
    self.innerSubview2.lyt_bottom = 4.999999;
    XCTAssertTrue([self.innerSubview1 lyt_bottomAligned:self.innerSubview2]);
    XCTAssertTrue([self.innerSubview2 lyt_bottomAligned:self.innerSubview1]);

    // Failure expected
    self.innerSubview2.lyt_bottom = 6;
    XCTAssertFalse([self.innerSubview1 lyt_bottomAligned:self.innerSubview2]);
    XCTAssertFalse([self.innerSubview2 lyt_bottomAligned:self.innerSubview1]);
    self.innerSubview2.lyt_bottom = 4;
    XCTAssertFalse([self.innerSubview1 lyt_bottomAligned:self.innerSubview2]);
    XCTAssertFalse([self.innerSubview2 lyt_bottomAligned:self.innerSubview1]);
}

@end

@implementation LanguageChangingView

// This method overrides the private helper in the category
- (BOOL)lyt_leftToRight {
    return isLeftToRight;
}

@end
