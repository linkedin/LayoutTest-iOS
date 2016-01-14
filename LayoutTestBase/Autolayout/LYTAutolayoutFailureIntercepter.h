// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 This class intercepts autolayout failures. It's useful for testing to ensure that we don't break any constraints.
 
 It should NOT ever be used in prod. This is because it relies on Apple's private methods which is brittle. Your app will also possibly be rejected 
 from the App Store because of using private APIs.
 It swizzles a private method on a private class (NSISEngine) and runs a block whenever this method is run. This method always gets run when there 
 is a layout failure (handleUnsatisfiableRowWithHead:body:usingInfeasibilityHandlingBehavior:mutuallyExclusiveConstraints:).
 
 If Apple updates their implementation, this class will need to be changed.
 */
@interface LYTAutolayoutFailureIntercepter : NSObject

/**
 Start intecerpting autolayout failures and run a block whenever you find one. This block is strongly retained, so be careful of retain cycles.
 
 Calling this method multiple times will cause the block to be reset.
 */
+ (void)interceptAutolayoutFailuresWithBlock:(void(^)())block;

/**
 Stops intercepting autolayout failures and nils out the current block (releasing it from memory).
 */
+ (void)stopInterceptingAutolayoutFailures;

@end

NS_ASSUME_NONNULL_END
