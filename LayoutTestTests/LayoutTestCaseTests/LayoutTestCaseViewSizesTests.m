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


/**
 These tests assume we are testing on:
 (w: 100, h: 100), (w: 300, h:200), (w: 200, h: 300)
 using both the LYTViewSizes and the adjust view methods.
 */
@interface LayoutTestCaseViewSizesTests : LYTLayoutTestCase <LYTViewProvider>

@end

@implementation LayoutTestCaseViewSizesTests

- (void)testNoOptions {
    __block NSInteger timesCalled = 0;
    [self runLayoutTestsWithViewProvider:[self class] validation:^(UIView * view, NSDictionary * data, id context) {
        switch (timesCalled) {
            case 0:
                XCTAssertEqual(view.lyt_width, 100);
                XCTAssertEqual(view.lyt_height, 100);
                break;
            case 1:
                XCTAssertEqual(view.lyt_width, 300);
                XCTAssertEqual(view.lyt_height, 200);
                break;
            case 2:
                XCTAssertEqual(view.lyt_width, 200);
                XCTAssertEqual(view.lyt_height, 300);
                break;
            default:
                XCTFail();
        }
        timesCalled++;
    }];

    XCTAssertEqual(timesCalled, 3);
}

- (void)testNoViewSizes {
    __block NSInteger timesCalled = 0;
    [self runLayoutTestsWithViewProvider:[self class] limitResults:LYTTesterLimitResultsNoSizes validation:^(UIView * view, NSDictionary * data, id context) {
        XCTAssertEqual(view.lyt_width, 300);
        XCTAssertEqual(view.lyt_height, 300);
        timesCalled++;
    }];

    XCTAssertEqual(timesCalled, 1);
}

#pragma mark - LYTViewProvider

+ (NSDictionary *)dataSpecForTest {
    return @{
             // Empty data
             };
}

+ (UIView *)viewForData:(NSDictionary *)data reuseView:(UIView *)view size:(LYTViewSize *)size context:(id *)context {
    return view ?: [UnitTestViews viewWithNoProblems];
}

+ (NSArray<LYTViewSize *> *)sizesForView {
    return @[
             [[LYTViewSize alloc] initWithWidth:@(100) height:@(100)],
             [[LYTViewSize alloc] initWithHeight:@(200)],
             [[LYTViewSize alloc] initWithWidth:@(200)] ];
}

+ (void)adjustViewSize:(UIView *)view data:(NSDictionary *)data size:(LYTViewSize *)size context:(id)context {
    if (!size.width) {
        view.lyt_width = 300;
    }
    if (!size.height) {
        view.lyt_height = 300;
    }
}

@end
