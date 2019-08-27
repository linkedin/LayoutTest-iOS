// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 This file exposes some useful helpers for testing views.
 */
@interface UIView (LYTHelpers)

/**
 Returns .frame.origin.y

 When setting, it will keep the height and width constant and change frame.origin.y
 */
@property (nonatomic) CGFloat lyt_top;

/**
 Returns .frame.origin.x

 When setting, it will keep the height and width constant and change frame.origin.x
 */
@property (nonatomic) CGFloat lyt_left;

/**
 Returns .frame.origin.x + .frame.size.width

 When setting, it will keep the height and width constant and change frame.origin.x
 */
@property (nonatomic) CGFloat lyt_right;

/**
 Returns .frame.origin.y + .frame.size.height

 When setting, it will keep the height and width constant and change frame.origin.y
 */
@property (nonatomic) CGFloat lyt_bottom;

/**
 Returns the width of the view
 */
@property (nonatomic) CGFloat lyt_width;

/**
 Returns the height of the view
 */
@property (nonatomic) CGFloat lyt_height;

@end

NS_ASSUME_NONNULL_END
