// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LYTLayoutFailingTestSnapshotRecorder.h"
#import "LYTConfig.h"

@interface LYTLayoutFailingTestSnapshotRecorder ()

@property (nonatomic) Class invocationClass;

@end

@implementation LYTLayoutFailingTestSnapshotRecorder

+ (instancetype)sharedInstance {
    static LYTLayoutFailingTestSnapshotRecorder *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LYTLayoutFailingTestSnapshotRecorder alloc] init];
    });
    return sharedInstance;
}

- (void)startNewLogForClass:(Class)invocationClass {
    self.invocationClass = invocationClass;
    [self deleteCurrentFailingSnapshots];
    [self createIndexHTMLFile];
}

- (void)saveImageOfCurrentViewWithInvocation:(NSInvocation *)invocation failureDescription:(NSString *)failureDescription {
    if ([self shouldSaveImageWithInvocation:invocation]) {
        NSString *imagePath = [self pathForImageWithWidth:self.viewUnderTest.frame.size.width height:self.viewUnderTest.frame.size.height withInovation:invocation];
        [self createDirectoryForInvocationIfNeeded:invocation];
        UIImage *viewImage = [self renderLayer:self.viewUnderTest.layer];
        [UIImagePNGRepresentation(viewImage) writeToFile:imagePath atomically:YES];
        [self appendToLog:failureDescription withInvocation:invocation];
    }
}

- (BOOL)shouldSaveImageWithInvocation:(NSInvocation *)invocation {
    NSString *imagePath = [self pathForImageWithWidth:self.viewUnderTest.frame.size.width height:self.viewUnderTest.frame.size.height withInovation:invocation];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        return NO;
    } else if ([LYTConfig sharedInstance].snapshotsToSavePerMethod != -1 &&
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
    NSString *classNameDirectory = [self commonRootPath];
    NSString *filePath = [self indexHTMLFilePath];
    NSError *error;
    
    NSString *header = @"<HTML><HEAD></HEAD><BODY><TABLE style='width:100%'><TR><TH>Description</TH><TH>Image</TH><TH>Input Data</TH></TR>";
    
    [fileManager createDirectoryAtPath:classNameDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    
    // Write to the file
    [header writeToFile:filePath atomically:YES
               encoding:NSUTF8StringEncoding error:&error];
}

- (void)finishLog {
    NSString *filePath = [self indexHTMLFilePath];
    NSString *footer = @"</TABLE></BODY></HTML>";
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    [fileHandler seekToEndOfFile];
    [fileHandler writeData:[footer dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandler closeFile];
}

- (void)appendToLog:(NSString *)description withInvocation:(NSInvocation *)invocation {
    if (!description) {
        description = @"";
    }
    
    NSString *filePath = [self indexHTMLFilePath];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", [self methodNameForInvocation:invocation], [self nameForImageWithWidth:self.viewUnderTest.frame.size.width height:self.viewUnderTest.frame.size.height]];
    NSString *errorHTML = [NSString stringWithFormat:@"<TR><TD>%@</TD><TD><IMG src='%@' alt='No Image'></TD><TD>%@</TD></TR>", description, imagePath, self.dataForViewUnderTest.description];
    errorHTML = [errorHTML stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    [fileHandler seekToEndOfFile];
    [fileHandler writeData:[errorHTML dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandler closeFile];
}

- (NSString *)indexHTMLFilePath {
    NSString *documentsDirectory = [self commonRootPath];
    return [documentsDirectory stringByAppendingPathComponent:@"index.html"];
}

- (void)deleteCurrentFailingSnapshots {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self commonRootPath] error:nil];
    
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
    
    NSString *directoryPath = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@", [self methodNameForInvocation:invocation]]];
    return directoryPath;
}

- (NSString *)methodNameForInvocation:(NSInvocation *)invocation {
    return NSStringFromSelector((SEL)[invocation selector]);
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

/**
 Returns the full path to the image with the given file name and the iamge size and width appended to it.
 e.g. {DIRECTORY_PATH}/SamepleTableViewCellLayoutTests/testSampleTableViewCell/{FILE_NAME}_{IMAGE_WIDTH}_{IMAGE_HEIGHT}.png
 */
- (NSString *)pathForImageWithWidth:(CGFloat)width height:(CGFloat)height withInovation:(NSInvocation *)invocation {
    NSString *directoryPath = [self directoryPathForCurrentInvocation:invocation];
    NSString *imageName = [self nameForImageWithWidth:width height:height];
    return [directoryPath stringByAppendingPathComponent:imageName];
}

- (NSString *)nameForImageWithWidth:(CGFloat)width height:(CGFloat)height {
    NSString *imageName = [NSString stringWithFormat:@"Width-%.2f_Height-%.2f_Data-%lu", width, height, (unsigned long)self.dataForViewUnderTest.description.hash];
    return [imageName stringByAppendingString:@".png"];
}

- (UIImage *)renderLayer:(CALayer *)layer {
    UIImage *snapshot = nil;
        CGRect bounds = layer.bounds;
    if (CGRectGetWidth(bounds) > 0 && CGRectGetHeight(bounds) > 0) {
        UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSaveGState(context);
        {
            [layer renderInContext:context];
        }
        CGContextRestoreGState(context);
        
        snapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return snapshot;
}

@end
