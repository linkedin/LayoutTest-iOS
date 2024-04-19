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
@end

@interface LayoutReportSnapshotLocationsTests : LYTLayoutTestCase
@end

@implementation LayoutReportSnapshotLocationsTests

- (void)testAllLocationsOfReportsAreLoggedToConsoleAtTheEnd {
    XCTIssue *issue = [[XCTIssue alloc] initWithType:XCTIssueTypeAssertionFailure compactDescription:@""];
    [[LYTLayoutFailingTestSnapshotRecorder sharedInstance] testCase:self didRecordIssue:issue];
    NSString *expectedPathContaining = @"LayoutTestImages/LayoutReportSnapshotLocationsTests/index.html";
    NSString *actualPath = [LYTLayoutFailingTestSnapshotRecorder sharedInstance].failingTestsSnapshotFolders.anyObject;
    XCTAssertTrue([actualPath containsString:expectedPathContaining]);
}

@end
