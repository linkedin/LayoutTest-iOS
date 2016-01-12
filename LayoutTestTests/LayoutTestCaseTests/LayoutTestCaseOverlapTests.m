// © 2015 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LayoutTest.h"
#import "LayoutTestBase.h"
#import "UnitTestViews.h"


@interface LayoutTestCaseOverlapTests : LYTLayoutTestCase <LYTViewProvider>

@property (nonatomic) NSInteger testFailures;

@end

@implementation LayoutTestCaseOverlapTests

- (void)testFails {
    __block NSInteger timesCalled = 0;
    [self runLayoutTestsWithViewProvider:[self class] validation:^(UIView * view, NSDictionary * data, id context) {
        timesCalled++;
    }];

    XCTAssertEqual(timesCalled, 3);
    // We should have failed once for the view that overlaps
    XCTAssertEqual(self.testFailures, 1);
}

- (void)testPassesWhenHidden {
    __block NSInteger timesCalled = 0;
    [self runLayoutTestsWithViewProvider:[self class] validation:^(UIView * view, NSDictionary * data, id context) {
        timesCalled++;
        // Let's hide one of the subviews. Now, nothing should be wrong.
        view.subviews[0].hidden = YES;
    }];

    XCTAssertEqual(timesCalled, 3);
    XCTAssertEqual(self.testFailures, 0);
}

- (void)testNoFailWithAllowsOverlap {
    __block NSInteger timesCalled = 0;
    [self runLayoutTestsWithViewProvider:[self class] validation:^(UIView *view, NSDictionary * data, id context) {
        timesCalled++;

        [self.viewsAllowingOverlap addObject:view.subviews[0]];
    }];

    XCTAssertEqual(timesCalled, 3);
    XCTAssertEqual(self.testFailures, 0);
}

- (void)testviewClassesAllowingSubviewErrorsOff {
    // Remove the UISwitch class from classes allowing overlap
    self.viewClassesAllowingSubviewErrors = [NSSet set];

    __block NSInteger timesCalled = 0;
    [self runLayoutTestsWithViewProvider:[self class] validation:^(UIView *view, NSDictionary * data, id context) {
        timesCalled++;

        UIView *subview = view.subviews[0];
        if (![subview isKindOfClass:[UISwitch class]]) {
            [self.viewsAllowingOverlap addObject:subview];
        }
    }];

    XCTAssertEqual(timesCalled, 3);
    // This will fail multiple times for a UISwitch because it has many overlapping subviews
    XCTAssertTrue(self.testFailures > 0);

    // Reset this now
    self.viewClassesAllowingSubviewErrors = [LYTConfig sharedInstance].viewClassesAllowingSubviewErrors;
}

#pragma mark - Override

- (void)failTest:(NSString *)errorMessage view:(UIView *)view {
    self.testFailures++;
}

#pragma mark - LYTViewProvider

+ (NSDictionary *)dataSpecForTest {
    // Return 3 views to test. One correct view, on view with overlapping subviews and one view with a switch subview.
    return @{
             @"view": [[LYTDataValues alloc] initWithValues:@[
                                                                   [UnitTestViews viewWithNoProblems],
                                                                   [UnitTestViews viewWithOverlappingViews],
                                                                   [UnitTestViews viewWithUISwitchSubview]
                                                                   ]]
             };
}

+ (UIView *)viewForData:(NSDictionary *)data reuseView:(UIView *)view size:(LYTViewSize *)size context:(id *)context {
    return data[@"view"];
}

@end
