// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <XCTest/XCTest.h>
#import "LYTLayoutFailingTestSnapshotRecorder.h"
#import "LYTConfig.h"

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
    
    [self.recorder saveImageOfView:nil withData:nil fromInvocation:self.invocation failureDescription:@""];
    
    NSString *directoryPath = [self pathForCurrentInvocation];
    BOOL isDirectory = NO;
    BOOL fileExisits = [[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    XCTAssertTrue(fileExisits);
    XCTAssertTrue(isDirectory);
}

- (void)testSaveImageOfCurrentViewSavesImageToDisk {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 100, 100}];
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfView:testView withData:@{@"key" : @"value"} fromInvocation:self.invocation failureDescription:@""];
    
    NSString *dataHash = @"";
#ifdef __LP64__
    dataHash = @"11921695704359177406";
#else
    dataHash = @"1252068542";
#endif
    NSString *imageName = [NSString stringWithFormat:@"/Width-100.00_Height-100.00_Data-%@.png", dataHash];
    NSString *imagePath = [[self pathForCurrentInvocation] stringByAppendingString:imageName];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:imagePath]);
}

- (void)testSaveImageOfCurrentViewWhenViewHasWidthOfZeroDoesNotSaveImage {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 0, 100}];
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfView:testView withData:nil fromInvocation:self.invocation failureDescription:@""];
    
    NSArray *filelist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self pathForCurrentInvocation] error:nil];
    XCTAssertFalse(filelist.count == 1);
}

- (void)testSaveImageOfCurrentViewWhenViewHasHeightOfZeroDoesNotSaveImage {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 100, 0}];
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfView:testView withData:nil fromInvocation:self.invocation failureDescription:@""];
    
    NSArray *filelist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self pathForCurrentInvocation] error:nil];
    XCTAssertEqual(0, filelist.count);
}

- (void)testSaveImageOfCurrentViewWhenDataHasSpecialCharactersImageSavedWithExpectedName {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 100, 100}];
    NSDictionary *data = @{@"key" : @"漢語 ♔ 🚂 ☎ Here are some more special characters ˆ™£‡‹·Ú‹˜ƒª•"};
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfView:testView withData:data fromInvocation:self.invocation failureDescription:@""];
    
    NSString *dataHash = @"";
#ifdef __LP64__
    dataHash = @"7040999336831705875";
#else
    dataHash = @"2409456403";
#endif
    NSString*expectedImageName = [NSString stringWithFormat:@"/Width-100.00_Height-100.00_Data-%@.png", dataHash];
    NSString *imagePath = [[self pathForCurrentInvocation] stringByAppendingString:expectedImageName];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:imagePath]);
}

- (void)testSaveImageOfCurrentViewWhenDataDescriptionIsOverTwoHunderedCharactersImageSavedWithExpectedName {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 100, 100}];
    NSDictionary *data = @{@"key" : [self threeHunderedAndSixtyFourCharacterString]};
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfView:testView withData:data fromInvocation:self.invocation failureDescription:@""];
    
    NSString *dataHash = @"";
#ifdef __LP64__
    dataHash = @"18202946166865061037";
#else
    dataHash = @"1837950125";
#endif
    NSString*expectedImageName = [NSString stringWithFormat:@"/Width-100.00_Height-100.00_Data-%@.png", dataHash];
    NSString *imagePath = [[self pathForCurrentInvocation] stringByAppendingString:expectedImageName];
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:imagePath]);
}

- (void)testSaveImageOfCurrentViewWhenCalledTwiceWithSlightlyDifferentDataSavesTwoImages {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 100, 100}];
    NSDictionary *data = @{@"key" : @"value"};
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfView:testView withData:data fromInvocation:self.invocation failureDescription:@""];
    data = @{@"key" : @"value1"};
    [self.recorder saveImageOfView:testView withData:data fromInvocation:self.invocation failureDescription:@""];
    
    
    NSString *expectedFirstDataHash = @"";
    NSString *expectedSecondDataHash = @"";
#ifdef __LP64__
    expectedFirstDataHash = @"11921695704359177406";
    expectedSecondDataHash = @"3294889149843288304";
#else
    expectedFirstDataHash = @"1252068542";
    expectedSecondDataHash = @"2259857648";
#endif
    NSString*expectedFirstImageName = [NSString stringWithFormat:@"/Width-100.00_Height-100.00_Data-%@.png", expectedFirstDataHash];
    NSString *firstImagePath = [[self pathForCurrentInvocation] stringByAppendingString:expectedFirstImageName];
    NSString*expectedSecondImageName = [NSString stringWithFormat:@"/Width-100.00_Height-100.00_Data-%@.png", expectedSecondDataHash];
    NSString *secondImagePath = [[self pathForCurrentInvocation] stringByAppendingString:expectedSecondImageName];
    
    NSArray *filelist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self pathForCurrentInvocation] error:nil];
    XCTAssertEqual(2, filelist.count);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:firstImagePath]);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:secondImagePath]);
}

- (void)testSaveImageWhenConfigHasNumberOfImagesToSaveSetToZeroDoesNotSaveImage {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 100, 100}];
    NSDictionary *data = @{@"key" : @"value"};
    [self.recorder startNewLogForClass:self.class];
    [LYTConfig sharedInstance].snapshotsToSavePerMethod = 0;
    
    [self.recorder saveImageOfView:testView withData:data fromInvocation:self.invocation failureDescription:@""];
    
    NSArray *filelist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self pathForCurrentInvocation] error:nil];
    XCTAssertEqual(0, filelist.count);
}

- (void)testSaveImageWhenConfigHasNumberOfImagesToSaveSetToFourOnlySavesFourImages {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 100, 100}];
    NSDictionary *data = @{@"key" : @"value"};
    [self.recorder startNewLogForClass:self.class];
    [LYTConfig sharedInstance].snapshotsToSavePerMethod = 4;
    
    //Should be saved
    [self.recorder saveImageOfView:testView withData:data fromInvocation:self.invocation failureDescription:@""];
    data = @{@"key1" : @"value"};
    [self.recorder saveImageOfView:testView withData:data fromInvocation:self.invocation failureDescription:@""];
    data = @{@"key2" : @"value"};
    [self.recorder saveImageOfView:testView withData:data fromInvocation:self.invocation failureDescription:@""];
    data = @{@"key3" : @"value"};
    [self.recorder saveImageOfView:testView withData:data fromInvocation:self.invocation failureDescription:@""];
    //
    
    //Shoudln't be saved
    data = @{@"key4" : @"value"};
    [self.recorder saveImageOfView:testView withData:data fromInvocation:self.invocation failureDescription:@""];
    //
    
    NSArray *filelist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self pathForCurrentInvocation] error:nil];
    XCTAssertEqual(4, filelist.count);
}

- (void)testSaveImageOfCurrentViewAddsFailureDescriptionImageAndDataToIndexFile {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 100, 100}];
    NSDictionary *data = @{@"key" : @"value"};
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfView:testView withData:data fromInvocation:self.invocation failureDescription:@"This is a test failure description"];
    [self.recorder finishLog];
    
    NSString *dataHash = @"";
#ifdef __LP64__
    dataHash = @"11921695704359177406";
#else
    dataHash = @"1252068542";
#endif
    NSString *actualHTML = [self indexHTMLFile];
    NSString *expectedBodyHTML = [NSString stringWithFormat:@"<TR><TD>This is a test failure description</TD><TD><IMG src='testSaveImageOfCurrentViewAddsFailureDescriptionImageAndDataToIndexFile/Width-100.00_Height-100.00_Data-%@.png' alt='No Image'></TD><TD>{    key = value;}</TD></TR>", dataHash];
    NSString *expectedHTML = [NSString stringWithFormat:@"%@%@%@", [self expectedStartOfFileHTML], expectedBodyHTML, [self expectedEndOfFileHTML]];
    XCTAssertEqualObjects(expectedHTML, actualHTML);
}

- (void)testSaveImageOfCurrentViewWhenViewAndDataAlreadySavedDoesNotReaddFailureDescriptionImageAndDataToIndexFile {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 100, 1000}];
    NSDictionary *data = @{@"key" : @"value"};
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfView:testView withData:data fromInvocation:self.invocation failureDescription:@"This is a test failure description"];
    [self.recorder saveImageOfView:testView withData:data fromInvocation:self.invocation failureDescription:@"This is a test failure description"];
    [self.recorder finishLog];
    
    NSString *dataHash = @"";
#ifdef __LP64__
    dataHash = @"11921695704359177406";
#else
    dataHash = @"1252068542";
#endif
    NSString *actualHTML = [self indexHTMLFile];
    NSString *expectedBodyHTML = [NSString stringWithFormat:@"<TR><TD>This is a test failure description</TD><TD><IMG src='testSaveImageOfCurrentViewWhenViewAndDataAlreadySavedDoesNotReaddFailureDescriptionImageAndDataToIndexFile/Width-100.00_Height-1000.00_Data-%@.png' alt='No Image'></TD><TD>{    key = value;}</TD></TR>", dataHash];
    NSString *expectedHTML = [NSString stringWithFormat:@"%@%@%@", [self expectedStartOfFileHTML], expectedBodyHTML, [self expectedEndOfFileHTML]];
    XCTAssertEqualObjects(expectedHTML, actualHTML);
}

- (void)testSaveImageOfCurrentViewWithNilFailureDescriptionAddsBlankDescriptionToIndexFile {
    UIView *testView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 1000, 100}];
    NSDictionary *data = @{@"key" : @"value"};
    [self.recorder startNewLogForClass:self.class];
    
    [self.recorder saveImageOfView:testView withData:data fromInvocation:self.invocation failureDescription:nil];
    [self.recorder finishLog];
    
    NSString *dataHash = @"";
#ifdef __LP64__
    dataHash = @"11921695704359177406";
#else
    dataHash = @"1252068542";
#endif
    NSString *actualHTML = [self indexHTMLFile];
    NSString *expectedBodyHTML = [NSString stringWithFormat:@"<TR><TD></TD><TD><IMG src='testSaveImageOfCurrentViewWithNilFailureDescriptionAddsBlankDescriptionToIndexFile/Width-1000.00_Height-100.00_Data-%@.png' alt='No Image'></TD><TD>{    key = value;}</TD></TR>", dataHash];
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
    return @"<HTML><HEAD></HEAD><BODY><TABLE style='width:100%'><TR><TH>Description</TH><TH>Image</TH><TH>Input Data</TH></TR>";
}

- (NSString *)expectedEndOfFileHTML {
    return @"</TABLE></BODY></HTML>";
}

- (NSString *)threeHunderedAndSixtyFourCharacterString {
    return @"Very long string. This string is so long that it's longer than I want it to be. Just a really really long string. In fact, it's just long as long can be. I'm just lengthening the longest string by making it longer with more characters. Do you think this is long enough yet? I think so, so I'm going to stop making this long string longer by adding more characters.";
}

@end
