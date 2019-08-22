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
    [LYTConfig sharedInstance].maxNumberOfCombinations = @(10);
    [LYTConfig sharedInstance].viewOverlapTestsEnabled = NO;
    [LYTConfig sharedInstance].viewWithinSuperviewTestsEnabled = NO;
    [LYTConfig sharedInstance].ambiguousAutolayoutTestsEnabled = NO;
    [LYTConfig sharedInstance].interceptsAutolayoutErrors = NO;
    [LYTConfig sharedInstance].accessibilityTestsEnabled = NO;
    [LYTConfig sharedInstance].failingTestSnapshotsEnabled = NO;
    [LYTConfig sharedInstance].viewClassesAllowingSubviewErrors = [NSSet set];
    [LYTConfig sharedInstance].viewClassesRequiringAccessibilityLabels = [NSSet set];

    LYTLayoutTestCase *testCase = [[LYTLayoutTestCase alloc] init];

    [testCase setUp];
    XCTAssertEqual(testCase.maxNumberOfCombinations, @(10));
    XCTAssertEqual(testCase.viewOverlapTestsEnabled, [LYTConfig sharedInstance].viewOverlapTestsEnabled);
    XCTAssertEqual(testCase.viewWithinSuperviewTestsEnabled, [LYTConfig sharedInstance].viewWithinSuperviewTestsEnabled);
    XCTAssertEqual(testCase.ambiguousAutolayoutTestsEnabled, [LYTConfig sharedInstance].ambiguousAutolayoutTestsEnabled);
    XCTAssertEqual(testCase.interceptsAutolayoutErrors, [LYTConfig sharedInstance].interceptsAutolayoutErrors);
    XCTAssertEqual(testCase.accessibilityTestsEnabled, [LYTConfig sharedInstance].accessibilityTestsEnabled);
    XCTAssertEqual(testCase.failingTestSnapshotsEnabled, [LYTConfig sharedInstance].failingTestSnapshotsEnabled);
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
    XCTAssertEqual(testCase.failingTestSnapshotsEnabled, [LYTConfig sharedInstance].failingTestSnapshotsEnabled);
    XCTAssertEqual(testCase.viewClassesAllowingSubviewErrors, [LYTConfig sharedInstance].viewClassesAllowingSubviewErrors);
    XCTAssertEqual(testCase.viewClassesRequiringAccessibilityLabels, [LYTConfig sharedInstance].viewClassesRequiringAccessibilityLabels);
}

- (void)testResetDefaultsResetsToExpectedValues {
    [LYTConfig sharedInstance].maxNumberOfCombinations = @(100);
    [LYTConfig sharedInstance].viewOverlapTestsEnabled = NO;
    [LYTConfig sharedInstance].viewWithinSuperviewTestsEnabled = NO;
    [LYTConfig sharedInstance].ambiguousAutolayoutTestsEnabled = NO;
    [LYTConfig sharedInstance].interceptsAutolayoutErrors = NO;
    [LYTConfig sharedInstance].accessibilityTestsEnabled = NO;
    [LYTConfig sharedInstance].failingTestSnapshotsEnabled = NO;
    [LYTConfig sharedInstance].viewClassesAllowingSubviewErrors = [NSSet setWithObjects:self.class, nil];
    [LYTConfig sharedInstance].viewClassesRequiringAccessibilityLabels = [NSSet setWithObjects:self.class, nil];
    [LYTConfig sharedInstance].cgFloatEpsilon = 100;
    [LYTConfig sharedInstance].snapshotsToSavePerMethod = 100;
    
    [[LYTConfig sharedInstance] resetDefaults];

    XCTAssertNil([LYTConfig sharedInstance].maxNumberOfCombinations);
    XCTAssertEqual(YES, [LYTConfig sharedInstance].viewOverlapTestsEnabled);
    XCTAssertEqual(YES, [LYTConfig sharedInstance].viewWithinSuperviewTestsEnabled);
    XCTAssertEqual(YES, [LYTConfig sharedInstance].ambiguousAutolayoutTestsEnabled);
    XCTAssertEqual(YES, [LYTConfig sharedInstance].interceptsAutolayoutErrors);
    XCTAssertEqual(YES, [LYTConfig sharedInstance].accessibilityTestsEnabled);
    XCTAssertEqual(YES, [LYTConfig sharedInstance].failingTestSnapshotsEnabled);

    NSSet *viewClassesAllowingSubviewErrorsSet = [NSSet setWithObjects:[UITextView class], [UISwitch class], [UIButton class], nil];
    NSSet *viewClassesRequiringAccessibilityLabelsSets = [NSSet setWithObjects:[UIControl class], nil];
    XCTAssertEqualObjects(viewClassesAllowingSubviewErrorsSet, [LYTConfig sharedInstance].viewClassesAllowingSubviewErrors);
    XCTAssertEqualObjects(viewClassesRequiringAccessibilityLabelsSets, [LYTConfig sharedInstance].viewClassesRequiringAccessibilityLabels);
    // Testing epsilon values is naturally difficult. This failed on iOS 8 if you do XCTAssertEqual, but this works
    XCTAssertTrue([LYTConfig sharedInstance].cgFloatEpsilon > 0.0000099 && [LYTConfig sharedInstance].cgFloatEpsilon < 0.0000101);
    XCTAssertEqual(-1, [LYTConfig sharedInstance].snapshotsToSavePerMethod);
}

@end
