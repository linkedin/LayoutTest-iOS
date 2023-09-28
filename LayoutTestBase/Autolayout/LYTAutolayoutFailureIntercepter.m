// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LYTAutolayoutFailureIntercepter.h"
#import <objc/runtime.h>


#define NSStringViewClassName @"UIView"
#define CStringViewClassName "UIView"

@implementation LYTAutolayoutFailureIntercepter

+ (void)interceptAutolayoutFailuresWithBlock:(void(^)(void))block {
    Class class = NSClassFromString(NSStringViewClassName);
    [self validateAutolayoutInterceptionForClass:class];
    [class interceptAutolayoutFailuresWithBlock:block];
}

+ (void)stopInterceptingAutolayoutFailures {
    Class class = NSClassFromString(NSStringViewClassName);
    [self validateAutolayoutInterceptionForClass:class];
    [class stopInterceptingAutolayoutFailures];
}

+ (void)validateAutolayoutInterceptionForClass:(Class)class {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if (class && [class instancesRespondToSelector:@selector(engine:willBreakConstraint:dueToMutuallyExclusiveConstraints:)]) {
        return;
    }
#pragma clang diagnostic pop
    NSAssert(false, @"This class no longer exists or it no longer implements the method we swizzle. This means that Apple has changed their implementation of Auto Layout and this code needs to be updated. Please file a bug with this information.");
}

@end

static void(^savedBlock)(void);
static BOOL swizzledAutolayout = false;

@interface NSObject (Private)
@end

@implementation NSObject (Private)

/**
 This method will run a block whenever there are autolayout failures. Running it multiple times will remove the old block and add a new block.
 */
+ (void)interceptAutolayoutFailuresWithBlock:(void(^)(void))block {
    savedBlock = block;

    if (!swizzledAutolayout) {
        swizzledAutolayout = YES;

        [self swizzleAutolayoutMethod];
    }
}

+ (void)stopInterceptingAutolayoutFailures {
    savedBlock = nil;

    if (swizzledAutolayout) {
        swizzledAutolayout = NO;

        [self swizzleAutolayoutMethod];
    }
}

+ (void)swizzleAutolayoutMethod {
    // Here we switch the implementations of our method and the actual method
    // This will either turn on or turn off the feature
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    Method original = class_getInstanceMethod(objc_getClass(CStringViewClassName), @selector(engine:willBreakConstraint:dueToMutuallyExclusiveConstraints:));
#pragma clang diagnostic pop

    Method swizzled = class_getInstanceMethod(self, @selector(swizzle_engine:willBreakConstraint:dueToMutuallyExclusiveConstraints:));
    method_exchangeImplementations(original, swizzled);
}

- (id)swizzle_engine:(void *)engine willBreakConstraint:(void *)constraints dueToMutuallyExclusiveConstraints:(void *)mutuallyExclusiveConstraints {
    savedBlock();

    // After running our block, we call the original implementation
    // This looks like an infinite loop, but it isn't because we switched the implementations. So now, this goes to the original method.
    return [self swizzle_engine:engine willBreakConstraint:constraints dueToMutuallyExclusiveConstraints:mutuallyExclusiveConstraints];
}

@end
