// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "UIView+LYTViewSize.h"


NS_ASSUME_NONNULL_BEGIN

@implementation UIView (LYTViewSize)

- (void)lyt_setSize:(nullable LYTViewSize *)size {
    CGFloat height = self.bounds.size.height;
    if (size.height) {
        height = size.height.floatValue;
    }
    CGFloat width = self.bounds.size.width;
    if (size.width) {
        width = size.width.floatValue;
    }

    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, width, height);
}

@end

NS_ASSUME_NONNULL_END
