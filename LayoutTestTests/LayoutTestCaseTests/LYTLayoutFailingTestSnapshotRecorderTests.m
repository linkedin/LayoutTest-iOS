//
//  LYTLayoutFailingTestSnapshotRecorderTests.m
//  LayoutTest
//
//  Created by Liam Douglas on 04/02/2016.
//  Copyright © 2016 LinkedIn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LYTLayoutFailingTestSnapshotRecorder.h"

@interface LYTLayoutFailingTestSnapshotRecorderTests : XCTestCase

@property (nonatomic) LYTLayoutFailingTestSnapshotRecorder *recorder;

@end

@implementation LYTLayoutFailingTestSnapshotRecorderTests

- (void)setUp {
    [super setUp];
    self.recorder = [[LYTLayoutFailingTestSnapshotRecorder alloc] init];
}

- (void)tearDown {
    self.recorder = nil;
    [super tearDown];
}

-(void)testCanSetViewUnderTest {
    LYTLayoutFailingTestSnapshotRecorder *recorder = [[LYTLayoutFailingTestSnapshotRecorder alloc] init];
    XCTAssertTrue([recorder respondsToSelector:@selector(setViewUnderTest:)]);
}

- (void)testCanSetDataForViewUnderTest {
    LYTLayoutFailingTestSnapshotRecorder *recorder = [[LYTLayoutFailingTestSnapshotRecorder alloc] init];
    XCTAssertTrue([recorder respondsToSelector:@selector(setDataForViewUnderTest:)]);
}

- (void)testStartNewLogDeletesExisitingClassSnapshotDirectory {
    //Setup directory and file to make sure file is deleted when we start a new log.
    NSString *currentDirectory = [[NSBundle bundleForClass:self.class] bundlePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *classDirectory = [currentDirectory stringByAppendingPathComponent:@"LayoutTestImages/LYTLayoutFailingTestSnapshotRecorderTests"];
    NSString *testFilePath = [classDirectory stringByAppendingPathComponent:@"testFile.html"];
    [fileManager createDirectoryAtPath:classDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:testFilePath contents:nil attributes:nil];

    [self.recorder startNewLogForClass:self.class];
    
    XCTAssertFalse([fileManager fileExistsAtPath:testFilePath]);
}

- (void)testStartNewLogCreatesIndexHTMLFileWithExpectedContent {
    [self.recorder startNewLogForClass:self.class];
    
    NSString *actualHTML = [self indexHTMLFile];
    XCTAssertEqualObjects([self expectedStartOfFileHTML], actualHTML);
}

- (void)testFinishLogAddsExpectedHTMLToIndexFile {
    [self.recorder startNewLogForClass:self.class];
    [self.recorder finishLog];
    
    NSString *actualHTML = [self indexHTMLFile];
    NSString *expectedHTML = [NSString stringWithFormat:@"%@%@", [self expectedStartOfFileHTML], [self expectedEndOfFileHTML]];
    XCTAssertEqualObjects(expectedHTML, actualHTML);
}

- (NSString *)indexHTMLFile {
    NSString *currentDirectory = [[NSBundle bundleForClass:self.class] bundlePath];
    NSString *classDirectory = [currentDirectory stringByAppendingPathComponent:@"LayoutTestImages/LYTLayoutFailingTestSnapshotRecorderTests"];
    NSString *indexFilePath = [classDirectory stringByAppendingPathComponent:@"index.html"];
    return [NSString stringWithContentsOfFile:indexFilePath encoding:NSUTF8StringEncoding error:nil];
}

- (NSString *)expectedStartOfFileHTML {
    return @"<HTML>\
    <HEAD>\
    </HEAD>\
    <BODY>\
    \
    <TABLE style='width:100%'>\
    \
    <TR>\
    <TH>Description</TH>\
    <TH>Image</TH>\
    <TH>Input Data</TH>\
    </TR>";
}

- (NSString *)expectedEndOfFileHTML {
    return @"</TABLE>\
    \
    </BODY>\
    </HTML>\
    ";
}

@end
