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
    
    [self runLayoutTestsWithViewProvider:[self class] validation:^(__unused UIView * view, __unused NSDictionary * data, __unused id context) {
        timesCalled++;
    }];
    
    XCTAssertEqual(timesCalled, 2);
    XCTAssertEqual(self.testFailures, 1);
}

#pragma mark - Override

- (void)failTest:(__unused NSString *)errorMessage view:(__unused UIView *)view {
    self.testFailures++;
}

#pragma mark - LYTViewProvider

+ (nullable NSDictionary *)dataSpecForTestWithError:(__unused NSError * _Nullable __autoreleasing *)error {
    return @{
             @"view": [UnitTestViews viewWithLongStringOverlappingLabel],
             @"text": [[LYTStringValues alloc] initWithValues:@[@"X", @"A long string that will cause overlap"]]
             };
}

+ (UIView *)viewForData:(NSDictionary *)data
              reuseView:(UIView *)view
                   size:(__unused LYTViewSize *)size
                context:(__unused id __autoreleasing *)context
                  error:(__unused NSError * _Nullable __autoreleasing * _Nullable)error {
    UIViewWithLabel *reuseView = (UIViewWithLabel *)(view ? view : data[@"view"]);
    reuseView.label.text = data[@"text"];
    return reuseView;
}

@end
