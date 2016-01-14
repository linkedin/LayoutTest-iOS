// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "UIView+LYTHelpers.h"

@implementation UIView (LYTHelpers)

- (CGFloat)lyt_left {
    return self.frame.origin.x;
}

- (void)setLyt_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)lyt_top {
    return self.frame.origin.y;
}

- (void)setLyt_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)lyt_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setLyt_right:(CGFloat)right {
    self.lyt_left = right - self.lyt_width;
}

- (CGFloat)lyt_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setLyt_bottom:(CGFloat)bottom {
    self.lyt_top = bottom - self.lyt_height;
}

- (CGFloat)lyt_width {
    return self.frame.size.width;
}

- (void)setLyt_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)lyt_height {
    return self.frame.size.height;
}

- (void)setLyt_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

@end
