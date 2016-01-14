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
 When providing sizes to test your view on, you may want to test the view on different widths, heights or both. This object let's you specify sizes
 like this. Both width and height are optional. So, if you specify a width and no height, then the library will resize your view's width, but not edit the height.
 
 For example, let's say you're testing a UITableViewCell subclass with a dynamic height. You want to test it on different devices, so you return

 @code
 @[ [[LYTViewSize alloc] initWithWidth:@(LYTDeviceConstants.LYTiPhone4Width)], [[LYTViewSize alloc] initWithWidth:@(LYTDeviceConstants.LYTiPhone6PlusWidth)] ]
 @endcode

 This will test the view on multiple different widths, but not change the height. If you need to manually set the height based on the data being set,
 then you should implement adjustViewSize:data:size:context:.

 
 You can utitilize predefined constants or enter a custom value.
 */
@interface LYTViewSize : NSObject

/**
 The width for the view. If nil, do not edit the width.
 */
@property (nonatomic, strong, readonly, nullable) NSNumber *width;
/**
 The height for the view. If nil, do not edit the height.
 */
@property (nonatomic, strong, readonly, nullable) NSNumber *height;

/**
 Creates a view size which will change both the width and the height of the view.
 */
- (instancetype)initWithWidth:(nullable NSNumber *)width height:(nullable NSNumber *)height;

/**
 Creates a view size which will only change the width of the view.
 */
- (instancetype)initWithWidth:(NSNumber *)width;

/**
 Creates a view size which will only change the height of the view.
 */

- (instancetype)initWithHeight:(NSNumber *)height;

@end

NS_ASSUME_NONNULL_END
