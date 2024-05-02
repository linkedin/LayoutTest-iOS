// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <XCTest/XCTest.h>
// Test Class
#import "LYTLayoutPropertyTester.h"
// Helpers
#import "LYTDataValues.h"
#import "LYTViewProvider.h"


@interface NullIteratorTests : XCTestCase <LYTViewProvider>

@end

@interface NullDataValues: LYTDataValues

@end

@implementation NullIteratorTests

static NSDictionary *testData = nil;

- (void)setUp {
    [super setUp];
    testData = nil;
}

- (void)tearDown {
    [super tearDown];
    testData = nil;
}

- (void)testNullInDictionary
{
    testData = @{
        @"null": [[NullDataValues alloc] init]
    };
    __block NSUInteger numberTimesCalled = 0;
    [LYTLayoutPropertyTester runPropertyTestsWithViewProvider:[self class]
                                                       validation:^(__unused UIView *view, NSDictionary *data, __unused id context) {
                                                           id object = data[@"null"];
                                                           if (numberTimesCalled < 2) {
                                                               XCTAssertEqual([object unsignedIntegerValue], numberTimesCalled, @"Should be equal");
                                                           } else {
                                                               XCTAssertNil(object, @"Object should be nil");
                                                           }
                                                           numberTimesCalled++;
                                                       }];
    XCTAssertEqual(numberTimesCalled, 3, @"Should have been called three times");
}

- (void)testNullInArray
{
    testData = @{
        @"array": @[@"0", [[NullDataValues alloc] init], @(2)]
    };
    __block NSUInteger numberTimesCalled = 0;
    [LYTLayoutPropertyTester runPropertyTestsWithViewProvider:[self class]
                                                       validation:^(__unused UIView *view, NSDictionary *data, __unused id context) {
                                                           id object = data[@"array"][1];
                                                           // if it's null, it should be @(2)
                                                           XCTAssertEqual([object unsignedIntegerValue], numberTimesCalled, @"Should be equal");
                                                           numberTimesCalled++;
                                                       }];
    XCTAssertEqual(numberTimesCalled, 3, @"Should have been called three times");
}

// Helpers

- (void)validateGenerators:(NSArray *)values context:(NSMutableSet *)context {
    for (NSNumber *number in values) {
        XCTAssert([number integerValue] >= 0, @"Number must be greater than 0");
        XCTAssert([number integerValue] < 4, @"Number must be less than 4");
    }
    if ([context containsObject:values]) {
        XCTFail(@"We've got a duplicate set of values.\nDuplication: %@\nContext: %@", values, context);
    }
    [context addObject:values];
}

// View Provider Protocol

+ (nullable NSDictionary *)dataSpecForTestWithError:(__unused NSError * _Nullable __autoreleasing *)error {
    return testData;
}

+ (UIView *)viewForData:(__unused NSDictionary *)data
              reuseView:(__unused UIView *)view
                   size:(__unused LYTViewSize *)size
                context:(__unused id __autoreleasing *)context
                  error:(__unused NSError * _Nullable __autoreleasing * _Nullable)error {
    return nil;
}

@end

@implementation NullDataValues

- (NSArray *)values {
    return @[@(0), @(1), [NSNull null]];
}

@end
