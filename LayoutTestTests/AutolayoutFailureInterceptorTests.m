// © 2015 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <XCTest/XCTest.h>
#import "LYTAutolayoutFailureIntercepter.h"
// Helpers
#import "UnitTestViews.h"


@interface AutolayoutFailureInterceptorTests : XCTestCase

@end

@implementation AutolayoutFailureInterceptorTests

- (void)tearDown {
    [LYTAutolayoutFailureIntercepter stopInterceptingAutolayoutFailures];
    [super tearDown];
}

- (void)testAutolayoutFail {
    __block BOOL autolayoutFailed = NO;
    [LYTAutolayoutFailureIntercepter interceptAutolayoutFailuresWithBlock:^{
        autolayoutFailed = YES;
    }];

    UIView *view = [UnitTestViews viewWithIncorrectAutolayout];
    [view layoutIfNeeded];

    XCTAssertTrue(autolayoutFailed);
}

- (void)testAutolayoutSuccess {
    __block BOOL autolayoutFailed = NO;
    [LYTAutolayoutFailureIntercepter interceptAutolayoutFailuresWithBlock:^{
        autolayoutFailed = YES;
    }];

    UIView *view = [UnitTestViews viewWithNoProblems];
    [view layoutIfNeeded];

    XCTAssertFalse(autolayoutFailed);
}

- (void)testTurningOffIntercepter {
    __block BOOL autolayoutFailed = NO;
    [LYTAutolayoutFailureIntercepter interceptAutolayoutFailuresWithBlock:^{
        autolayoutFailed = YES;
    }];

    [LYTAutolayoutFailureIntercepter stopInterceptingAutolayoutFailures];

    UIView *view = [UnitTestViews viewWithIncorrectAutolayout];
    [view layoutIfNeeded];

    XCTAssertFalse(autolayoutFailed);
}

- (void)testTurningOnIntercepterTwice {
    __block BOOL autolayoutFailed = NO;
    [LYTAutolayoutFailureIntercepter interceptAutolayoutFailuresWithBlock:^{
        autolayoutFailed = YES;
    }];
    [LYTAutolayoutFailureIntercepter interceptAutolayoutFailuresWithBlock:^{
        autolayoutFailed = YES;
    }];

    UIView *view = [UnitTestViews viewWithIncorrectAutolayout];
    [view layoutIfNeeded];

    XCTAssertTrue(autolayoutFailed);
}

- (void)testTurningOffIntercepterTwice {
    __block BOOL autolayoutFailed = NO;
    [LYTAutolayoutFailureIntercepter interceptAutolayoutFailuresWithBlock:^{
        autolayoutFailed = YES;
    }];

    [LYTAutolayoutFailureIntercepter stopInterceptingAutolayoutFailures];
    [LYTAutolayoutFailureIntercepter stopInterceptingAutolayoutFailures];

    UIView *view = [UnitTestViews viewWithIncorrectAutolayout];
    [view layoutIfNeeded];

    XCTAssertFalse(autolayoutFailed);
}

@end
