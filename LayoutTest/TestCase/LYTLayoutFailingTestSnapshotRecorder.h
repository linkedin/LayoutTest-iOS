//
//  LYTLayoutFailingTestSnapshotRecorder.h
//  LayoutTest
//
//  Created by Liam Douglas on 04/02/2016.
//  Copyright © 2016 LinkedIn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface LYTLayoutFailingTestSnapshotRecorder : NSObject<XCTestObservation>

@property (nonatomic, strong) UIView *viewUnderTest;
@property (nonatomic, strong) NSDictionary *dataForViewUnderTest;

+ (instancetype)sharedInstance;

- (void)startNewLogForClass:(Class)invocationClass;

- (void)finishLog;

- (void)saveImageOfCurrentViewWithInvocation:(NSInvocation *)invocation failureDescription:(NSString *)failureDescription;

@end
