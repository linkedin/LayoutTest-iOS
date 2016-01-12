// © 2015 LinkedIn Corp. All rights reserved.
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


@interface IteratorTests : XCTestCase <LYTViewProvider>

@end

@interface SampleGenerator: LYTDataValues

@end

@implementation IteratorTests

static NSDictionary *testData = nil;

- (void)setUp {
    [super setUp];
    testData = nil;
}

- (void)tearDown {
    [super tearDown];
    testData = nil;
}

- (void)testNoGenerators
{
    testData = @{
                 @"array": @[@"a1", @"a2"],
                 @"dict": @{@"dk1": @"dv1"},
                 @"key": @"value"
                 };
    __block NSUInteger numberTimesCalled = 0;
    [LYTLayoutPropertyTester runPropertyTestsWithViewProvider:[self class]
                                                       validation:^(UIView *view, NSDictionary *data, id context) {
                                                           numberTimesCalled++;
                                                           XCTAssertEqualObjects([testData objectForKey:@"key"], [data objectForKey:@"key"], @"Object should match test data");
                                                           XCTAssertEqualObjects([[testData objectForKey:@"array"] objectAtIndex:0], [[data objectForKey:@"array"] objectAtIndex:0], @"Object should match test data");
                                                           XCTAssertEqualObjects([[testData objectForKey:@"array"] objectAtIndex:1], [[data objectForKey:@"array"] objectAtIndex:1], @"Object should match test data");
                                                           XCTAssertEqualObjects([[testData objectForKey:@"dict"] objectForKey:@"dk1"], [[data objectForKey:@"dict"] objectForKey:@"dk1"], @"Object should match test data");
                                                       }];
    XCTAssertEqual(numberTimesCalled, 1, @"Should have been called exactly once");

    // Limited
    testData = @{
                 @"array": @[@"a1", @"a2"],
                 @"dict": @{@"dk1": @"dv1"},
                 @"key": @"value"
                 };
    numberTimesCalled = 0;
    [LYTLayoutPropertyTester runPropertyTestsWithViewProvider:[self class]
                                                     limitResults:LYTTesterLimitResultsLimitDataCombinations
                                                       validation:^(UIView *view, NSDictionary *data, id context) {
                                                           numberTimesCalled++;
                                                           XCTAssertEqualObjects([testData objectForKey:@"key"], [data objectForKey:@"key"], @"Object should match test data");
                                                           XCTAssertEqualObjects([[testData objectForKey:@"array"] objectAtIndex:0], [[data objectForKey:@"array"] objectAtIndex:0], @"Object should match test data");
                                                           XCTAssertEqualObjects([[testData objectForKey:@"array"] objectAtIndex:1], [[data objectForKey:@"array"] objectAtIndex:1], @"Object should match test data");
                                                           XCTAssertEqualObjects([[testData objectForKey:@"dict"] objectForKey:@"dk1"], [[data objectForKey:@"dict"] objectForKey:@"dk1"], @"Object should match test data");
                                                       }];
    XCTAssertEqual(numberTimesCalled, 1, @"Should have been called exactly once");
}

- (void)testOneGeneratorSimple {
    testData = @{
                 @"gen": [[SampleGenerator alloc] init]
                 };
    __block NSUInteger numberTimesCalled = 0;
    [LYTLayoutPropertyTester runPropertyTestsWithViewProvider:[self class]
                                                       validation:^(UIView *view, NSDictionary *data, id context) {
                                                           XCTAssertEqualObjects([data objectForKey:@"gen"], @(numberTimesCalled), @"Generator should iterate through all values in order");
                                                           numberTimesCalled++;
                                                       }];
    XCTAssertEqual(numberTimesCalled, 4, @"Should have been called 4 times");

    // Limited

    testData = @{
                 @"gen": [[SampleGenerator alloc] init]
                 };
    numberTimesCalled = 0;
    [LYTLayoutPropertyTester runPropertyTestsWithViewProvider:[self class]
                                                     limitResults:LYTTesterLimitResultsLimitDataCombinations
                                                       validation:^(UIView *view, NSDictionary *data, id context) {
                                                           XCTAssertEqualObjects([data objectForKey:@"gen"], @(numberTimesCalled), @"Generator should iterate through all values in order");
                                                           numberTimesCalled++;
                                                       }];
    XCTAssertEqual(numberTimesCalled, 4, @"Should have been called 4 times");
}

- (void)testTwoGeneratorsSimple {
    testData = @{
                 @"gen1": [[SampleGenerator alloc] init],
                 @"gen2": [[SampleGenerator alloc] init]
                 };

    __block NSUInteger numberTimesCalled = 0;
    NSMutableSet *context = [NSMutableSet set];
    [LYTLayoutPropertyTester runPropertyTestsWithViewProvider:[self class]
                                                       validation:^(UIView *view, NSDictionary *data, id context) {
                                                           NSArray *dataValues = @[
                                                                                   [data objectForKey:@"gen1"],
                                                                                   [data objectForKey:@"gen2"]
                                                                                   ];
                                                           [self validateGenerators:dataValues context:context];
                                                           numberTimesCalled++;
                                                       }];
    XCTAssertEqual(numberTimesCalled, 16, @"Should have been called 16 times");

    // Limited
    testData = @{
                 @"gen1": [[SampleGenerator alloc] init],
                 @"gen2": [[SampleGenerator alloc] init]
                 };

    numberTimesCalled = 0;
    context = [NSMutableSet set];
    [LYTLayoutPropertyTester runPropertyTestsWithViewProvider:[self class]
                                                     limitResults:LYTTesterLimitResultsLimitDataCombinations
                                                       validation:^(UIView *view, NSDictionary *data, id context) {
                                                           NSArray *dataValues = @[
                                                                                   [data objectForKey:@"gen1"],
                                                                                   [data objectForKey:@"gen2"]
                                                                                   ];
                                                           [self validateGenerators:dataValues context:context];
                                                           numberTimesCalled++;
                                                       }];
    XCTAssertEqual(numberTimesCalled, 7, @"Should have been called 7 times (4 times each mins 1 for the duplicate 0-0)");
}

- (void)testNestedThreeIterators {
    testData = @{
                 @"gen1": [[SampleGenerator alloc] init],
                 @"array": @[@"test", [[SampleGenerator alloc] init]],
                 @"dict": @{@"test": [[SampleGenerator alloc] init]}
                 };

    __block NSUInteger numberTimesCalled = 0;
    NSMutableSet *context = [NSMutableSet set];
    [LYTLayoutPropertyTester runPropertyTestsWithViewProvider:[self class]
                                                       validation:^(UIView *view, NSDictionary *data, id context) {

                                                           NSArray *dataValues = @[
                                                                                   [data objectForKey:@"gen1"],
                                                                                   [[data objectForKey:@"array"] objectAtIndex:1],
                                                                                   [[data objectForKey:@"dict"] objectForKey:@"test"]
                                                                                   ];
                                                           [self validateGenerators:dataValues context:context];
                                                           numberTimesCalled++;
                                                       }];
    XCTAssertEqual(numberTimesCalled, 64, @"Should have been called 64 times");

    // Limited
    testData = @{
                 @"gen1": [[SampleGenerator alloc] init],
                 @"array": @[@"test", [[SampleGenerator alloc] init]],
                 @"dict": @{@"test": [[SampleGenerator alloc] init]}
                 };

    numberTimesCalled = 0;
    context = [NSMutableSet set];
    [LYTLayoutPropertyTester runPropertyTestsWithViewProvider:[self class]
                                                     limitResults:LYTTesterLimitResultsLimitDataCombinations
                                                       validation:^(UIView *view, NSDictionary *data, id context) {

                                                           NSArray *dataValues = @[
                                                                                   [data objectForKey:@"gen1"],
                                                                                   [[data objectForKey:@"array"] objectAtIndex:1],
                                                                                   [[data objectForKey:@"dict"] objectForKey:@"test"]
                                                                                   ];
                                                           [self validateGenerators:dataValues context:context];
                                                           numberTimesCalled++;
                                                       }];
    XCTAssertEqual(numberTimesCalled, 10, @"Should have been called 10 times (4 times each minus 2 for the 0-0-0 duplicates)");
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

+ (NSDictionary *)dataSpecForTest {
    return testData;
}

+ (UIView *)viewForData:(NSDictionary *)data reuseView:(UIView *)view size:(LYTViewSize *)size context:(id *)context {
    return nil;
}

@end

@implementation SampleGenerator

- (NSArray *)values {
    return @[@(0), @(1), @(2), @(3)];
}

@end
