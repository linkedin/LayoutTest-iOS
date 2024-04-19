// © 2016 LinkedIn Corp. All rights reserved.
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


@interface LayoutTestCaseMissingLabelTests : LYTLayoutTestCase <LYTViewProvider>

@property (nonatomic) NSInteger testFailures;

@end

@implementation LayoutTestCaseMissingLabelTests

- (void)testFails {
    __block NSInteger timesCalled = 0;
    [self runLayoutTestsWithViewProvider:[self class] validation:^(__unused UIView * view, __unused NSDictionary * data, __unused id context) {
        timesCalled++;
    }];

    XCTAssertEqual(timesCalled, 2);
    XCTAssertEqual(self.testFailures, 1);
}

- (void)testNoFailWithAllowErrors {
    __block NSInteger timesCalled = 0;
    [self runLayoutTestsWithViewProvider:[self class] validation:^(UIView *view, __unused NSDictionary * data, __unused id context) {
        timesCalled++;

        [self.viewsAllowingAccessibilityErrors addObject:view.subviews[0]];
    }];

    XCTAssertEqual(timesCalled, 2);
    XCTAssertEqual(self.testFailures, 0);

    self.interceptsAutolayoutErrors = YES;
}

- (void)testNoFailWithAccessibilityOff {
    self.accessibilityTestsEnabled = NO;

    __block NSInteger timesCalled = 0;
    [self runLayoutTestsWithViewProvider:[self class] validation:^(__unused UIView * view, __unused NSDictionary * data, __unused id context) {
        timesCalled++;
    }];

    XCTAssertEqual(timesCalled, 2);
    XCTAssertEqual(self.testFailures, 0);

    self.accessibilityTestsEnabled = YES;
}

#pragma mark - Override

- (void)failTest:(__unused NSString *)errorMessage view:(__unused UIView *)view {
    self.testFailures++;
}

#pragma mark - LYTViewProvider

+ (nullable NSDictionary *)dataSpecForTestWithError:(__unused NSError * _Nullable __autoreleasing *)error {
    // Return 3 views to test. One correct view, on view with overlapping subviews and one view with a switch subview.
    return @{
        @"view": [[LYTDataValues alloc] initWithValues:@[
            [UnitTestViews viewWithNoProblems],
            [UnitTestViews viewWithAccessibilityIDButNoLabel]
        ]]
    };
}

+ (UIView *)viewForData:(NSDictionary *)data
              reuseView:(__unused UIView *)view
                   size:(__unused LYTViewSize *)size
                context:(__unused id __autoreleasing *)context
                  error:(__unused NSError * _Nullable __autoreleasing * _Nullable)error {
    return (UIView *)data[@"view"];
}

@end
