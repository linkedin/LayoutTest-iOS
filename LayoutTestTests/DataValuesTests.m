// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LYTStringValues.h"


@interface DataValuesTests : XCTestCase

@end

@implementation DataValuesTests

- (void)testRequiredGeneratorTrue {
    LYTDataValues *generator = [[LYTStringValues alloc] initWithRequired:YES];
    for (NSUInteger i = 0; i<[generator numberOfValues]; i++) {
        XCTAssertNotEqualObjects([NSNull null], [generator valueAtIndex:i]);
    }
}

- (void)testRequiredGeneratorFalse {
    LYTDataValues *generator = [[LYTStringValues alloc] initWithRequired:NO];
    BOOL foundNull = false;
    for (NSUInteger i = 0; i<[generator numberOfValues]; i++) {
        foundNull = foundNull || [[generator valueAtIndex:i] isEqual:[NSNull null]];
    }
    XCTAssertTrue(foundNull);
}

@end
