//
//  LayoutReportSnapshotLocations.m
//  LayoutTest
//
//  Created by Jock Findlay on 09/02/2016.
//  Copyright © 2016 LinkedIn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LYTLayoutTestCase.h"
#import "LYTLayoutFailingTestSnapshotRecorder.h"

@interface LYTLayoutFailingTestSnapshotRecorder ()
@property (nonatomic) NSMutableSet *failingTestsSnapshotFolders;
- (void)testCase:(XCTestCase *)testCase didFailWithDescription:(NSString *)description inFile:(nullable NSString *)filePath atLine:(NSUInteger)lineNumber;
@end

@interface LayoutReportSnapshotLocationsTests : LYTLayoutTestCase
@end

@implementation LayoutReportSnapshotLocationsTests

- (void)testAllLocationsOfReportsAreLoggedToConsoleAtTheEnd {
    [[LYTLayoutFailingTestSnapshotRecorder sharedInstance] testCase:self didFailWithDescription:@"" inFile:@"File1" atLine:0];
    NSString *expectedPathContaining = @"LayoutTestImages/LayoutReportSnapshotLocationsTests/index.html";
    NSString *actualPath = [LYTLayoutFailingTestSnapshotRecorder sharedInstance].failingTestsSnapshotFolders.anyObject;
    XCTAssertTrue([actualPath containsString:expectedPathContaining]);
}

@end
