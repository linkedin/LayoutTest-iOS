// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <LayoutTestBase/LYTConfig.h>
#import "LYTLayoutFailingTestSnapshotRecorder.h"
#import "LYTLayoutTestCase.h"

void SimpleLog(NSString *format, ...) {
    // Log to the console without timestamp that NSLog gives us
    va_list args;
    va_start(args, format);
    NSString *formattedString = [[NSString alloc] initWithFormat:format
                                                       arguments:args];
    va_end(args);

    NSData *data = [formattedString dataUsingEncoding:NSNEXTSTEPStringEncoding];
    if (data) {
        [[NSFileHandle fileHandleWithStandardOutput] writeData:data];
    }
}

@interface NSString (XMLEscape)

- (NSString *)lyt_stringByAddingXMLEscaping;

@end

@implementation NSString (XMLEscape)

- (NSString *)lyt_stringByAddingXMLEscaping {
    NSString *string = [self stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"&#39;"];
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    return string;
}

@end


@interface LYTLayoutFailingTestSnapshotRecorder ()

@property (nonatomic) Class invocationClass;
@property (nonatomic) NSMutableSet *failingTestsSnapshotFolders;
@property (nonatomic) NSInteger failedTestsDuringTestSuite;

@end

@implementation LYTLayoutFailingTestSnapshotRecorder

+ (void)initialize {
    [LYTLayoutFailingTestSnapshotRecorder sharedInstance];
}

+ (instancetype)sharedInstance {
    static LYTLayoutFailingTestSnapshotRecorder *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LYTLayoutFailingTestSnapshotRecorder alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.failingTestsSnapshotFolders = [NSMutableSet set];
        XCTestObservationCenter *observationCenter = [XCTestObservationCenter sharedTestObservationCenter];
        [observationCenter addTestObserver:self];
    }
    return self;
}

- (void)testSuiteWillStart:(__unused XCTestSuite *)testSuite {
    self.failedTestsDuringTestSuite = 0;
}

- (void)testSuiteDidFinish:(__unused XCTestSuite *)testSuite {
    if (self.failedTestsDuringTestSuite > 0 && self.failingTestsSnapshotFolders.count > 0) {
        SimpleLog(@"\nSnapshots of failing tests can be found in:\n");
        for (NSString *path in self.failingTestsSnapshotFolders) {
            SimpleLog(@"%@\n", path);
        }
        SimpleLog(@"\n");
    }
}

- (void)testBundleDidFinish:(__unused NSBundle *)testBundle {
    // NOTE: For some reason, this never gets called
    // See #28 on Github
    if (self.failingTestsSnapshotFolders.count > 0) {
        SimpleLog(@"\nSnapshots of failing tests can be found in:\n");
        for (NSString *path in self.failingTestsSnapshotFolders) {
            SimpleLog(@"%@\n", path);
        }
        SimpleLog(@"\n");
        [self.failingTestsSnapshotFolders removeAllObjects];
    }
}

- (void)testCase:(XCTestCase *)testCase didFailWithDescription:(__unused NSString *)description inFile:(nullable __unused NSString *)filePath atLine:(__unused NSUInteger)lineNumber {
    if ([testCase isKindOfClass:[LYTLayoutTestCase class]]) {
        NSString *pathForSnapshots = [self commonRootPathForInvocationClass:[testCase class]];
        pathForSnapshots = [pathForSnapshots stringByAppendingString:@"/index.html"];
        [self.failingTestsSnapshotFolders addObject:pathForSnapshots];
        self.failedTestsDuringTestSuite += 1;
    }
}

- (void)startNewLogForClass:(Class)invocationClass {
    self.invocationClass = invocationClass;
    [self deleteCurrentFailingSnapshotsForInvocationClass:invocationClass];
    [self createIndexHTMLFile];
}

- (void)saveImageOfView:(UIView *)view withData:(NSDictionary *)data fromInvocation:(NSInvocation *)invocation failureDescription:(NSString *)failureDescription {
    NSString *imagePath = [self pathForImageWithWidth:view.frame.size.width height:view.frame.size.height data:data invocation:invocation];
    if ([self shouldSaveImageOfViewAtPath:imagePath withInvocation:invocation]) {
        [self createDirectoryForInvocationIfNeeded:invocation];
        UIImage *viewImage = [self renderLayer:view.layer];
        [UIImagePNGRepresentation(viewImage) writeToFile:imagePath atomically:YES];
        [self appendViewWithWidth:view.frame.size.width
                           height:view.frame.size.height
                         viewData:data
      toLogWithFailureDescription:failureDescription
                   withInvocation:invocation];
    }
}

- (BOOL)shouldSaveImageOfViewAtPath:(NSString *)imagePath withInvocation:(NSInvocation *)invocation {
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        return NO;
    } else if ([LYTConfig sharedInstance].snapshotsToSavePerMethod >= 0 &&
               [self numberOfImagesSavedForInvocation:invocation] >= [LYTConfig sharedInstance].snapshotsToSavePerMethod) {
        return NO;
    }
    
    return YES;
}

- (NSUInteger)numberOfImagesSavedForInvocation:(NSInvocation *)invocation {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self directoryPathForCurrentInvocation:invocation] error:nil].count;
}

- (void)createIndexHTMLFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *classNameDirectory = [self commonRootPathForInvocationClass:self.invocationClass];
    NSString *filePath = [self indexHTMLFilePath];
    
    NSString *header = @"<HTML><HEAD></HEAD><BODY><TABLE style='width:100%'><TR><TH>Description</TH><TH>Image</TH><TH>Input Data</TH></TR>";
    
    [fileManager createDirectoryAtPath:classNameDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    
    // Write to the file
    [header writeToFile:filePath atomically:YES
               encoding:NSUTF8StringEncoding error:nil];
}

- (void)finishLog {
    NSString *filePath = [self indexHTMLFilePath];
    NSString *footer = @"</TABLE></BODY></HTML>";
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    [fileHandler seekToEndOfFile];
    NSData *footerData = [footer dataUsingEncoding:NSUTF8StringEncoding];
    if (footerData) {
        [fileHandler writeData:footerData];
    }
    [fileHandler closeFile];
}

- (void)appendViewWithWidth:(CGFloat)width
                     height:(CGFloat)height
                   viewData:(NSDictionary *)data
            toLogWithFailureDescription:(NSString *)description
             withInvocation:(NSInvocation *)invocation {
    if (!description) {
        description = @"";
    }
    
    NSString *filePath = [self indexHTMLFilePath];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", [self methodNameForInvocation:invocation], [self nameForImageWithWidth:width height:height data:data]];
    NSString *dataDescription = nil;
    if (data) {
        if ([NSJSONSerialization isValidJSONObject:data])  {
            NSData *serializedJSON = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
            if (serializedJSON) {
                dataDescription = [[NSString alloc] initWithData:serializedJSON encoding:NSUTF8StringEncoding];
            }
        } else {
            dataDescription = [data description];
        }
    }
    NSString *errorHTML = [NSString stringWithFormat:@"<TR><TD>%@</TD><TD><IMG src='%@' alt='No Image'></TD><TD>%@</TD></TR>", [description lyt_stringByAddingXMLEscaping], imagePath, dataDescription];
    errorHTML = [errorHTML stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    [fileHandler seekToEndOfFile];
    NSData *errorData = [errorHTML dataUsingEncoding:NSUTF8StringEncoding];
    if (errorData) {
        [fileHandler writeData:errorData];
    }
    [fileHandler closeFile];
}

- (NSString *)indexHTMLFilePath {
    NSString *documentsDirectory = [self commonRootPathForInvocationClass:self.invocationClass];
    return [documentsDirectory stringByAppendingPathComponent:@"index.html"];
}

- (void)deleteCurrentFailingSnapshotsForInvocationClass:(Class)invocationClass {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self commonRootPathForInvocationClass:invocationClass] error:nil];
}

- (void)createDirectoryForInvocationIfNeeded:(NSInvocation *)invocation {
    NSString *directoryPath = [self directoryPathForCurrentInvocation:invocation];
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

/**
 Returns the path to the directory to save snapshots of the current failing test. Path includes class and method name
 e.g. {FULL_PATH}/SamepleTableViewCellLayoutTests/testSampleTableViewCell
 */
- (NSString *)directoryPathForCurrentInvocation:(NSInvocation *)invocation {
    NSString *documentsDirectory = [self commonRootPathForInvocationClass:self.invocationClass];
    
    NSString *directoryPath = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@", [self methodNameForInvocation:invocation]]];
    return directoryPath;
}

- (NSString *)methodNameForInvocation:(NSInvocation *)invocation {
    return NSStringFromSelector((SEL)[invocation selector]);
}

- (NSString *)commonRootPathForInvocationClass:(Class)classForRoot {
    NSString *currentDirectory = [NSProcessInfo processInfo].environment[@"LYT_FAILING_TEST_SNAPSHOT_DIR"];
    if (!currentDirectory) {
        currentDirectory = [[NSBundle bundleForClass:classForRoot] bundlePath];
    }
    NSString *className = NSStringFromClass(classForRoot);
    //Check incase the class name includes a ".", if so we the actual class name will be everything after the "."
    if ([className containsString:@"."]) {
        className = [className componentsSeparatedByString:@"."].lastObject;
    }
    
    return [currentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"LayoutTestImages/%@", className]];
}

/**
 Returns the full path to the image with the given file name and the iamge size and width appended to it.
 e.g. {DIRECTORY_PATH}/SamepleTableViewCellLayoutTests/testSampleTableViewCell/{FILE_NAME}_{IMAGE_WIDTH}_{IMAGE_HEIGHT}.png
 */
- (NSString *)pathForImageWithWidth:(CGFloat)width height:(CGFloat)height data:(NSDictionary *)data invocation:(NSInvocation *)invocation {
    NSString *directoryPath = [self directoryPathForCurrentInvocation:invocation];
    NSString *imageName = [self nameForImageWithWidth:width height:height data:data];
    return [directoryPath stringByAppendingPathComponent:imageName];
}

- (NSString *)nameForImageWithWidth:(CGFloat)width height:(CGFloat)height data:(NSDictionary *)data {
    NSString *imageName = [NSString stringWithFormat:@"Width-%.2f_Height-%.2f_Data-%lu", width, height, (unsigned long)data.description.hash];
    return [imageName stringByAppendingString:@".png"];
}

- (UIImage *)renderLayer:(CALayer *)layer {
    UIImage *snapshot = nil;
    CGRect bounds = layer.bounds;
    if (CGRectGetWidth(bounds) > 0 && CGRectGetHeight(bounds) > 0) {
        UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextSaveGState(context);
        [layer renderInContext:context];
        CGContextRestoreGState(context);
        
        snapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return snapshot;
}

@end
