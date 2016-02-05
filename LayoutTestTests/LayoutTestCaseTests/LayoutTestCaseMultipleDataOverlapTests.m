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
#import "UIViewWithLabel.h"

@interface LayoutTestCaseMultipleDataOverlapTests : LYTLayoutTestCase <LYTViewProvider>

@property (nonatomic) NSInteger testFailures;

@end

@implementation LayoutTestCaseMultipleDataOverlapTests

- (void)testPassWithoutOverlappingTextAndFailWithOverlappingText {
    __block NSInteger timesCalled = 0;
    
    [self runLayoutTestsWithViewProvider:[self class] validation:^(UIView * view, NSDictionary * data, id context) {
        timesCalled++;
    }];
    
    XCTAssertEqual(timesCalled, 2);
    XCTAssertEqual(self.testFailures, 1);
}

#pragma mark - Override

- (void)failTest:(NSString *)errorMessage view:(UIView *)view {
    self.testFailures++;
}

#pragma mark - LYTViewProvider

+ (NSDictionary *)dataSpecForTest {
    return @{
             @"view": [UnitTestViews viewWithLongStringOverlappingLabel],
             @"text": [[LYTStringValues alloc] initWithValues:@[@"X", @"A long string that will cause overlap"]]
             };
}

+ (UIView *)viewForData:(NSDictionary *)data reuseView:(UIView *)view size:(LYTViewSize *)size context:(id *)context {
    UIViewWithLabel *reuseView = (UIViewWithLabel *)(view ? view : data[@"view"]);
    reuseView.label.text = data[@"text"];
    return reuseView;
}

@end
