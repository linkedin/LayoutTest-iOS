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
    [self createDirectoryForInvocationIfNeeded:invocation];
    UIImage *viewImage = [self renderLayer:self.viewUnderTest.layer];
    [UIImagePNGRepresentation(viewImage) writeToFile:[self pathForImage:viewImage withInovation:invocation] atomically:YES];
    [self appendToLog:failureDescription imagePath:[self pathForImage:viewImage withInovation:invocation]];
}

- (void)createIndexHTMLFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *classNameDirectory = [self commonRootPath];
    NSString *filePath = [self indexHTMLFilePath];
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
    NSString *filePath = [self indexHTMLFilePath];
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

- (void)appendToLog:(NSString *)description imagePath:(NSString *)imagePath {
    if (!description) {
        description = @"";
    }
    
    NSString *filePath = [self indexHTMLFilePath];
    NSString *errorHTML = [NSString stringWithFormat:@"<TR><TD>%@</TD><TD><IMG src='%@' alt='No Image'></TD><TD>%@</TD></TR>", description, imagePath, self.dataForViewUnderTest.description];
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

/**
 Returns the full path to the image with the given file name and the iamge size and width appended to it.
 e.g. {DIRECTORY_PATH}/SamepleTableViewCellLayoutTests/testSampleTableViewCell/{FILE_NAME}_{IMAGE_WIDTH}_{IMAGE_HEIGHT}.png
 */
- (NSString *)pathForImage:(UIImage *)image withInovation:(NSInvocation *)invocation {
    NSString *directoryPath = [self directoryPathForCurrentInvocation:invocation];
    NSString *imageName = [NSString stringWithFormat:@"Width-%.2f_Height-%.2f_Data-%lu", image.size.width, image.size.height, (unsigned long)self.dataForViewUnderTest.description.hash];
    imageName = [imageName stringByAppendingPathExtension:@"png"];
    return [directoryPath stringByAppendingPathComponent:imageName];
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
