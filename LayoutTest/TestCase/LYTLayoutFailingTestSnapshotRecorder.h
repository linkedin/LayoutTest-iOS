//
//  LYTLayoutFailingTestSnapshotRecorder.h
//  LayoutTest
//
//  Created by Liam Douglas on 04/02/2016.
//  Copyright © 2016 LinkedIn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LYTLayoutFailingTestSnapshotRecorder : NSObject

@property (nonatomic, strong) UIView *viewUnderTest;
@property (nonatomic, strong) NSDictionary *dataForViewUnderTest;

- (instancetype)initWithInvocationClass:(Class)invocationClass;

- (void)startNewLog;

- (void)finishLog;

- (void)saveImageOfCurrentViewWithInvocation:(NSInvocation *)invocation failureDescription:(NSString *)failureDescription;

@end
