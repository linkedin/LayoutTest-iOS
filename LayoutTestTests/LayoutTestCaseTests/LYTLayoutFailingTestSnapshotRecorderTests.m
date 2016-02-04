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

- (void)testSaveImageOfCurrentViewCreatesDirectoryFromInvocationSelectorName {
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfCurrentViewWithInvocation:self.invocation];
    
    NSString *directoryPath = [self pathForCurrentInvocation];
    BOOL isDirectory = NO;
    BOOL fileExisits = [[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    XCTAssertTrue(fileExisits);
    XCTAssertTrue(isDirectory);
}

- (NSString *)indexHTMLFile {
    NSString *indexFilePath = [[self classDirectoryPath] stringByAppendingPathComponent:@"index.html"];
    return [NSString stringWithContentsOfFile:indexFilePath encoding:NSUTF8StringEncoding error:nil];
}

- (void)testSaveImageOfCurrentViewSavesImageToDisk {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 100, 100}];
    self.recorder.viewUnderTest = testView;
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfCurrentViewWithInvocation:self.invocation];
    
    NSString *imagePath = [[self pathForCurrentInvocation] stringByAppendingString:@"/TestImage.png"];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:imagePath]);
}

- (void)testSaveImageOfCurrentViewWhenViewHasWidthOfZeroDoesNotSaveImage {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 0, 100}];
    self.recorder.viewUnderTest = testView;
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfCurrentViewWithInvocation:self.invocation];
    
    NSString *imagePath = [[self pathForCurrentInvocation] stringByAppendingString:@"/TestImage.png"];
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:imagePath]);
}

- (void)testSaveImageOfCurrentViewWhenViewHasHeightOfZeroDoesNotSaveImage {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 100, 0}];
    self.recorder.viewUnderTest = testView;
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfCurrentViewWithInvocation:self.invocation];
    
    NSString *imagePath = [[self pathForCurrentInvocation] stringByAppendingString:@"/TestImage.png"];
    XCTAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:imagePath]);
}

- (NSString *)classDirectoryPath {
    NSString *currentDirectory = [[NSBundle bundleForClass:self.class] bundlePath];
    return [currentDirectory stringByAppendingPathComponent:@"LayoutTestImages/LYTLayoutFailingTestSnapshotRecorderTests"];
}

- (NSString *)pathForCurrentInvocation {
    NSString *directoryPath = [self classDirectoryPath];
    NSString *methodName = NSStringFromSelector((SEL)[self.invocation selector]);
    return [directoryPath stringByAppendingPathComponent:methodName];
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
