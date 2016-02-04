//
//  LYTLayoutFailingTestSnapshotRecorder.m
//  LayoutTest
//
//  Created by Liam Douglas on 04/02/2016.
//  Copyright © 2016 LinkedIn. All rights reserved.
//

#import "LYTLayoutFailingTestSnapshotRecorder.h"

@interface LYTLayoutFailingTestSnapshotRecorder ()

@property (nonatomic) Class invocationClass;

@end

@implementation LYTLayoutFailingTestSnapshotRecorder

- (void)startNewLogForClass:(Class)invocationClass {
    self.invocationClass = invocationClass;
    [self deleteCurrentFailingSnapshots];
    [self createIndexHTMLFile];
    
}
- (void)deleteCurrentFailingSnapshots {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self commonRootPath] error:nil];
    
}

- (void)createIndexHTMLFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *classNameDirectory = [self commonRootPath];
    NSString *filePath = [classNameDirectory stringByAppendingPathComponent:@"index.html"];
    NSError *error;
    
    NSString *header = @"<HTML>\
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
    
    [fileManager createDirectoryAtPath:classNameDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    
    // Write to the file
    [header writeToFile:filePath atomically:YES
               encoding:NSUTF8StringEncoding error:&error];
}

- (void)finishLog {
    NSString *documentsDirectory = [self commonRootPath];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"index.html"];
    NSString *footer = @"</TABLE>\
    \
    </BODY>\
    </HTML>\
    ";
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    [fileHandler seekToEndOfFile];
    [fileHandler writeData:[footer dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandler closeFile];
}

- (void)saveImageOfCurrentViewWithInvocation:(NSInvocation *)invocation {
    [self createDirectoryForInvocationIfNeeded:invocation];
}

- (void)createDirectoryForInvocationIfNeeded:(NSInvocation *)invocation {
    NSString *directoryPath = [self directoryPathForCurrentInvocation:invocation];
    BOOL isDirectory = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

/**
 Returns the path to the directory to save snapshots of the current failing test. Path includes class and method name
 e.g. {FULL_PATH}/SamepleTableViewCellLayoutTests/testSampleTableViewCell
 */
- (NSString *)directoryPathForCurrentInvocation:(NSInvocation *)invocation {
    NSString *documentsDirectory = [self commonRootPath];
    NSString *methodName = NSStringFromSelector((SEL)[invocation selector]);
    
    NSString *directoryPath = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@", methodName]];
    return directoryPath;
}

- (NSString *)commonRootPath {
    NSString *currentDirectory = [[NSBundle bundleForClass:self.invocationClass] bundlePath];
    NSString *className = NSStringFromClass(self.invocationClass);
    //Check incase the class name includes a ".", if so we the actual class name will be everything after the "."
    if ([className containsString:@"."]) {
        className = [className componentsSeparatedByString:@"."].lastObject;
    }
    
    return [currentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"LayoutTestImages/%@", className]];
}

@end
