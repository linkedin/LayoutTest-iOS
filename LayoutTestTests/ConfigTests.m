// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <XCTest/XCTest.h>
#import "LYTConfig.h"
#import "LYTLayoutTestCase.h"

@interface ConfigTests : XCTestCase

@end

@implementation ConfigTests

- (void)tearDown {
    [[LYTConfig sharedInstance] resetDefaults];

    [super tearDown];
}

- (void)testConfigEditsLayoutTest {
    [LYTConfig sharedInstance].viewOverlapTestsEnabled = NO;
    [LYTConfig sharedInstance].viewWithinSuperviewTestsEnabled = NO;
    [LYTConfig sharedInstance].ambiguousAutolayoutTestsEnabled = NO;
    [LYTConfig sharedInstance].interceptsAutolayoutErrors = NO;
    [LYTConfig sharedInstance].accessibilityTestsEnabled = NO;
    [LYTConfig sharedInstance].viewClassesAllowingSubviewErrors = [NSSet set];
    [LYTConfig sharedInstance].viewClassesRequiringAccessibilityLabels = [NSSet set];

    LYTLayoutTestCase *testCase = [[LYTLayoutTestCase alloc] init];
    [testCase setUp];
    XCTAssertEqual(testCase.viewOverlapTestsEnabled, [LYTConfig sharedInstance].viewOverlapTestsEnabled);
    XCTAssertEqual(testCase.viewWithinSuperviewTestsEnabled, [LYTConfig sharedInstance].viewWithinSuperviewTestsEnabled);
    XCTAssertEqual(testCase.ambiguousAutolayoutTestsEnabled, [LYTConfig sharedInstance].ambiguousAutolayoutTestsEnabled);
    XCTAssertEqual(testCase.interceptsAutolayoutErrors, [LYTConfig sharedInstance].interceptsAutolayoutErrors);
    XCTAssertEqual(testCase.accessibilityTestsEnabled, [LYTConfig sharedInstance].accessibilityTestsEnabled);
    XCTAssertEqual(testCase.viewClassesAllowingSubviewErrors, [LYTConfig sharedInstance].viewClassesAllowingSubviewErrors);
    XCTAssertEqual(testCase.viewClassesRequiringAccessibilityLabels, [LYTConfig sharedInstance].viewClassesRequiringAccessibilityLabels);
}

- (void)testConfigDefaultLayoutTest {
    LYTLayoutTestCase *testCase = [[LYTLayoutTestCase alloc] init];
    [testCase setUp];
    XCTAssertEqual(testCase.viewOverlapTestsEnabled, [LYTConfig sharedInstance].viewOverlapTestsEnabled);
    XCTAssertEqual(testCase.viewWithinSuperviewTestsEnabled, [LYTConfig sharedInstance].viewWithinSuperviewTestsEnabled);
    XCTAssertEqual(testCase.ambiguousAutolayoutTestsEnabled, [LYTConfig sharedInstance].ambiguousAutolayoutTestsEnabled);
    XCTAssertEqual(testCase.interceptsAutolayoutErrors, [LYTConfig sharedInstance].interceptsAutolayoutErrors);
    XCTAssertEqual(testCase.accessibilityTestsEnabled, [LYTConfig sharedInstance].accessibilityTestsEnabled);
    XCTAssertEqual(testCase.viewClassesAllowingSubviewErrors, [LYTConfig sharedInstance].viewClassesAllowingSubviewErrors);
    XCTAssertEqual(testCase.viewClassesRequiringAccessibilityLabels, [LYTConfig sharedInstance].viewClassesRequiringAccessibilityLabels);
}

@end
