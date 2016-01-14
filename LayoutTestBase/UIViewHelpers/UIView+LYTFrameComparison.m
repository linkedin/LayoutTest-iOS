// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "UIView+LYTFrameComparison.h"
#import "UIView+LYTHelpers.h"
#import "LYTConfig.h"


@implementation UIView (LYTFrameComparison)

#pragma mark - Frames

- (BOOL)lyt_before:(UIView *)otherView {
    CGRect otherViewBounds = [self convertRect:otherView.bounds fromView:otherView];
    CGFloat epsilon = [LYTConfig sharedInstance].cgFloatEpsilon;

    if ([self lyt_leftToRight]) {
        return self.bounds.size.width <= otherViewBounds.origin.x + epsilon;
    } else {
        return self.bounds.origin.x + epsilon >= otherViewBounds.origin.x + otherViewBounds.size.width;
    }
}

- (BOOL)lyt_after:(UIView *)otherView {
    return [otherView lyt_before:self];
}

- (BOOL)lyt_above:(UIView *)otherView {
    CGRect otherViewBounds = [self convertRect:otherView.bounds fromView:otherView];
    CGFloat epsilon = [LYTConfig sharedInstance].cgFloatEpsilon;

    return self.bounds.size.height <= otherViewBounds.origin.y + epsilon;
}

- (BOOL)lyt_below:(UIView *)otherView {
    return [otherView lyt_above:self];
}

#pragma mark - Alignment

- (BOOL)lyt_leadingAligned:(UIView *)otherView {
    CGRect otherViewBounds = [self convertRect:otherView.bounds fromView:otherView];
    if ([self lyt_leftToRight]) {
        return LYTEpsilonEqual(self.bounds.origin.x, otherViewBounds.origin.x);
    } else {
        return LYTEpsilonEqual(self.bounds.origin.x + self.bounds.size.width, otherViewBounds.origin.x + otherViewBounds.size.width);
    }
}

- (BOOL)lyt_trailingAligned:(UIView *)otherView {
    CGRect otherViewBounds = [self convertRect:otherView.bounds fromView:otherView];
    if ([self lyt_leftToRight]) {
        return LYTEpsilonEqual(self.bounds.origin.x + self.bounds.size.width, otherViewBounds.origin.x + otherViewBounds.size.width);
    } else {
        return LYTEpsilonEqual(self.bounds.origin.x, otherViewBounds.origin.x);
    }
}

- (BOOL)lyt_topAligned:(UIView *)otherView {
    CGRect otherViewBounds = [self convertRect:otherView.bounds fromView:otherView];
    return LYTEpsilonEqual(self.bounds.origin.y, otherViewBounds.origin.y);
}

- (BOOL)lyt_bottomAligned:(UIView *)otherView {
    CGRect otherViewBounds = [self convertRect:otherView.bounds fromView:otherView];
    return LYTEpsilonEqual(self.bounds.origin.y + self.bounds.size.height, otherViewBounds.origin.y + otherViewBounds.size.height);
}

#pragma mark - Private Helpers

- (BOOL)lyt_leftToRight {
    switch ([UIApplication sharedApplication].userInterfaceLayoutDirection) {
        case UIUserInterfaceLayoutDirectionLeftToRight:
            return YES;
        case UIUserInterfaceLayoutDirectionRightToLeft:
            return NO;
    }
}

@end
