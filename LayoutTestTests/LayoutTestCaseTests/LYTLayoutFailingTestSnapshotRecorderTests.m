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
    
    [self.recorder saveImageOfCurrentViewWithInvocation:self.invocation failureDescription:@""];
    
    NSString *directoryPath = [self pathForCurrentInvocation];
    BOOL isDirectory = NO;
    BOOL fileExisits = [[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    XCTAssertTrue(fileExisits);
    XCTAssertTrue(isDirectory);
}

- (void)testSaveImageOfCurrentViewSavesImageToDisk {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 100, 100}];
    self.recorder.viewUnderTest = testView;
    self.recorder.dataForViewUnderTest = @{@"key" : @"value"};
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfCurrentViewWithInvocation:self.invocation failureDescription:@""];
    
    NSString *imagePath = [[self pathForCurrentInvocation] stringByAppendingString:@"/Width-100.00_Height-100.00_Data-19920687747319.png"];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:imagePath]);
}

- (void)testSaveImageOfCurrentViewWhenViewHasWidthOfZeroDoesNotSaveImage {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 0, 100}];
    self.recorder.viewUnderTest = testView;
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfCurrentViewWithInvocation:self.invocation failureDescription:@""];
    
    NSArray *filelist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self pathForCurrentInvocation] error:nil];
    XCTAssertFalse(filelist.count == 1);
}

- (void)testSaveImageOfCurrentViewWhenViewHasHeightOfZeroDoesNotSaveImage {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 100, 0}];
    self.recorder.viewUnderTest = testView;
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfCurrentViewWithInvocation:self.invocation failureDescription:@""];
    
    NSArray *filelist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self pathForCurrentInvocation] error:nil];
    XCTAssertEqual(0, filelist.count);
}

- (void)testSaveImageOfCurrentViewWhenDataHasSpecialCharactersImageSavedWithExpectedName {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 100, 100}];
    self.recorder.viewUnderTest = testView;
    self.recorder.dataForViewUnderTest = @{@"key" : @"漢語 ♔ 🚂 ☎ Here are some more special characters ˆ™£‡‹·Ú‹˜ƒª•"};
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfCurrentViewWithInvocation:self.invocation failureDescription:@""];
    
    NSString*expectedImageName = @"/Width-100.00_Height-100.00_Data-15534241200359575295.png";
    NSString *imagePath = [[self pathForCurrentInvocation] stringByAppendingString:expectedImageName];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:imagePath]);
}

- (void)testSaveImageOfCurrentViewWhenDataDescriptionIsOverTwoHunderedCharactersImageSavedWithExpectedName {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 100, 100}];
    self.recorder.viewUnderTest = testView;
    self.recorder.dataForViewUnderTest = @{@"key" : [self threeHunderedAndSixtyFourCharacterString]};
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfCurrentViewWithInvocation:self.invocation failureDescription:@""];
    
    NSString*expectedImageName = @"/Width-100.00_Height-100.00_Data-4096502861068069301.png";
    NSString *imagePath = [[self pathForCurrentInvocation] stringByAppendingString:expectedImageName];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:imagePath]);
}

- (void)testSaveImageOfCurrentViewWhenCalledTwiceWithSlightlyDifferentDataSavesTwoImages {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 100, 100}];
    self.recorder.viewUnderTest = testView;
    self.recorder.dataForViewUnderTest = @{@"key" : @"value"};
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfCurrentViewWithInvocation:self.invocation failureDescription:@""];
    self.recorder.dataForViewUnderTest = @{@"key" : @"value1"};
    [self.recorder saveImageOfCurrentViewWithInvocation:self.invocation failureDescription:@""];
    
    NSString*expectedFirstImageName = @"/Width-100.00_Height-100.00_Data-10365719165069801.png";
    NSString *firstImagePath = [[self pathForCurrentInvocation] stringByAppendingString:expectedFirstImageName];
    NSString*expectedSecondImageName = @"/Width-100.00_Height-100.00_Data-19920687747319.png";
    NSString *secondImagePath = [[self pathForCurrentInvocation] stringByAppendingString:expectedSecondImageName];
    
    NSArray *filelist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self pathForCurrentInvocation] error:nil];
    XCTAssertEqual(2, filelist.count);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:firstImagePath]);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:secondImagePath]);
}

- (void)testSaveImageOfCurrentViewAddsFailureDescriptionImageAndDataToIndexFile {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 100, 100}];
    self.recorder.viewUnderTest = testView;
    self.recorder.dataForViewUnderTest = @{@"key" : @"value"};
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfCurrentViewWithInvocation:self.invocation failureDescription:@"This is a test failure description"];
    [self.recorder finishLog];
    
    NSString *actualHTML = [self indexHTMLFile];
    NSString *expectedBodyHTML = @"<TR><TD>This is a test failure description</TD><TD><IMG src='/Users/liamdouglas/Library/Developer/Xcode/DerivedData/LayoutTest-cgmqhbwpcfxotbbipumzghiiiwok/Build/Products/Debug-iphonesimulator/LayoutTestTests.xctest/LayoutTestImages/LYTLayoutFailingTestSnapshotRecorderTests/testSaveImageOfCurrentViewAddsFailureDescriptionImageAndDataToIndexFile/Width-100.00_Height-100.00_Data-19920687747319.png' alt='No Image'></TD><TD>{\n\
    key = value;\n\
}</TD></TR>";
    NSString *expectedHTML = [NSString stringWithFormat:@"%@%@%@", [self expectedStartOfFileHTML], expectedBodyHTML, [self expectedEndOfFileHTML]];
    XCTAssertEqualObjects(expectedHTML, actualHTML);
}

- (void)testSaveImageOfCurrentViewWithNilFailureDescriptionAddsBlankDescriptionToIndexFile {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 1000, 100}];
    self.recorder.viewUnderTest = testView;
    self.recorder.dataForViewUnderTest = @{@"key" : @"value"};
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfCurrentViewWithInvocation:self.invocation failureDescription:nil];
    [self.recorder finishLog];
    
    NSString *actualHTML = [self indexHTMLFile];
    NSString *expectedBodyHTML = @"<TR><TD></TD><TD><IMG src='/Users/liamdouglas/Library/Developer/Xcode/DerivedData/LayoutTest-cgmqhbwpcfxotbbipumzghiiiwok/Build/Products/Debug-iphonesimulator/LayoutTestTests.xctest/LayoutTestImages/LYTLayoutFailingTestSnapshotRecorderTests/testSaveImageOfCurrentViewWithNilFailureDescriptionAddsBlankDescriptionToIndexFile/Width-1000.00_Height-100.00_Data-19920687747319.png' alt='No Image'></TD><TD>{\n\
    key = value;\n\
}</TD></TR>";
    NSString *expectedHTML = [NSString stringWithFormat:@"%@%@%@", [self expectedStartOfFileHTML], expectedBodyHTML, [self expectedEndOfFileHTML]];
    XCTAssertEqualObjects(expectedHTML, actualHTML);
}

- (NSString *)indexHTMLFile {
    NSString *indexFilePath = [[self classDirectoryPath] stringByAppendingPathComponent:@"index.html"];
    return [NSString stringWithContentsOfFile:indexFilePath encoding:NSUTF8StringEncoding error:nil];
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

- (NSString *)threeHunderedAndSixtyFourCharacterString {
    return @"Very long string. This string is so long that it's longer than I want it to be. Just a really really long string. In fact, it's just long as long can be. I'm just lengthening the longest string by making it longer with more characters. Do you think this is long enough yet? I think so, so I'm going to stop making this long string longer by adding more characters.";
}

@end
