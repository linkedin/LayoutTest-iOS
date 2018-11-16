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


@interface LayoutTestCaseViewMaxNumberOfCombinationsConfigTests : LYTLayoutTestCase <LYTViewProvider>

@property (nonatomic) NSInteger testFailures;
@property (nonatomic, strong) NSString *lastTestFailureMessage;

@end

@implementation LayoutTestCaseViewMaxNumberOfCombinationsConfigTests

- (void)setUp {
    [super setUp];
    self.testFailures = 0;
    self.lastTestFailureMessage = nil;
}

- (void)testThatTestDoesNotFailIfMaxNumberOfCombinationsNilBeforeRunningTests {
    self.maxNumberOfCombinations = nil;
    [self runLayoutTestsWithViewProvider:[self class] limitResults:LYTTesterLimitResultsNone validation:^(UIView * view, NSDictionary * data, id context) { }];

    XCTAssertEqual(self.testFailures, 0);
}

- (void)testThatTestDoesNotFailIfMaxNumberOfCombinationsSetToNilInValidationBlock {
    [self runLayoutTestsWithViewProvider:[self class] limitResults:LYTTesterLimitResultsNone validation:^(UIView * view, NSDictionary * data, id context) {
        self.maxNumberOfCombinations = nil;
    }];

    XCTAssertEqual(self.testFailures, 0);
}

- (void)testThatTestFailsIfMaxNumberOfCombinationsSetToZeroBeforeRunningTests {
    self.maxNumberOfCombinations = @(0);
    [self runLayoutTestsWithViewProvider:[self class] limitResults:LYTTesterLimitResultsNone validation:^(UIView * view, NSDictionary * data, id context) { }];

    XCTAssertEqual(self.testFailures, 9);
}

- (void)testThatTestFailsIfMaxNumberOfCombinationsSetToZeroInValidationBlock {
    [self runLayoutTestsWithViewProvider:[self class] limitResults:LYTTesterLimitResultsNone validation:^(UIView * view, NSDictionary * data, id context) {
        self.maxNumberOfCombinations = @(0);
    }];

    XCTAssertEqual(self.testFailures, 9);
}

- (void)testThatTestFailsIfNumberOfCombinationsExceedesMaxNumberOfCombinationsSetBeforeRunningTests {
    self.maxNumberOfCombinations = @(1);
    [self runLayoutTestsWithViewProvider:[self class] limitResults:LYTTesterLimitResultsNone validation:^(UIView * view, NSDictionary * data, id context) { }];

    XCTAssertEqual(self.testFailures, 8);
}

- (void)testThatTestFailsIfNumberOfCombinationsExceedesMaxNumberOfCombinationsSetInValidationBlock {
    [self runLayoutTestsWithViewProvider:[self class] limitResults:LYTTesterLimitResultsNone validation:^(UIView * view, NSDictionary * data, id context) {
        self.maxNumberOfCombinations = @(3);
    }];

    XCTAssertEqual(self.testFailures, 6);
}

- (void)testThatTestSucceedsIfNumberOfCombinationsDoesNotExceedesMaxNumberOfCombinationsSetBeforeRunningTests {
    self.maxNumberOfCombinations = @(4);
    [self runLayoutTestsWithViewProvider:[self class] limitResults:LYTTesterLimitResultsNone validation:^(UIView * view, NSDictionary * data, id context) { }];

    XCTAssertEqual(self.testFailures, 5);
}

- (void)testThatTestSucceedsIfNumberOfCombinationsDoesNotExceedesMaxNumberOfCombinationsSetInValidationBlock {
    [self runLayoutTestsWithViewProvider:[self class] limitResults:LYTTesterLimitResultsNone validation:^(UIView * view, NSDictionary * data, id context) {
        self.maxNumberOfCombinations = @(5);
    }];

    XCTAssertEqual(self.testFailures, 4);
}

- (void)testThatTestFailureMessageIndicatesMaxNumberOfCombinations {
    [self runLayoutTestsWithViewProvider:[self class] limitResults:LYTTesterLimitResultsNone validation:^(UIView * view, NSDictionary * data, id context) {
        self.maxNumberOfCombinations = @(5);
    }];

    XCTAssertEqualObjects(self.lastTestFailureMessage, @"Max number of layout combinations (5) exceeded.");
}

- (void)failTest:(NSString *)errorMessage view:(UIView *)view {
    self.testFailures++;
    self.lastTestFailureMessage = errorMessage;
}

#pragma mark - LYTViewProvider

+ (NSDictionary *)dataSpecForTest {
    return @{
             @"someValues": [[LYTDataValues alloc] initWithValues:@[@(1), @(2), @(3)]]
             };
}

+ (UIView *)viewForData:(NSDictionary *)data reuseView:(UIView *)view size:(LYTViewSize *)size context:(id *)context {
    return view ?: [UnitTestViews viewWithNoProblems];
}

+ (NSArray<LYTViewSize *> *)sizesForView {
    return @[
             [[LYTViewSize alloc] initWithWidth:@(100) height:@(100)],
              [[LYTViewSize alloc] initWithWidth:@(200) height:@(200)],
              [[LYTViewSize alloc] initWithWidth:@(300) height:@(300)],
             ];
}

@end
