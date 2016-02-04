//
//  LYTLayoutFailingTestSnapshotRecorder.m
//  LayoutTest
//
//  Created by Liam Douglas on 04/02/2016.
//  Copyright © 2016 LinkedIn. All rights reserved.
//

#import "LYTLayoutFailingTestSnapshotRecorder.h"

@implementation LYTLayoutFailingTestSnapshotRecorder


- (void)startNewLog {
    [self deleteCurrentFailingSnapshots];
    
}

- (void)deleteCurrentFailingSnapshots {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self commonRootPath] error:nil];
}

- (NSString *)commonRootPath {
    NSString *currentDirectory = [[NSBundle bundleForClass:[self class]] bundlePath];
    NSString *className = NSStringFromClass(self.class);
    //Check incase the class name includes a ".", if so we the actual class name will be everything after the "."
    if ([className containsString:@"."]) {
        className = [className componentsSeparatedByString:@"."].lastObject;
    }
    return [currentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"LayoutTestImages/%@", className]];
}

@end
