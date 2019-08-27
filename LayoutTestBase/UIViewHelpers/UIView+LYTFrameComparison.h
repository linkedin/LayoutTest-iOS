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

@interface UIView (LYTFrameComparison)

/**
 Returns whether a view is before another view on the horizontal axis. It returns false if they are overlapping in any way.
 It uses [UIApplication sharedApplication].userInterfaceLayoutDirection to determine what before means. If we are in a right-to-left language (such as 
 Arabic), then before means it must be on the right hand side. Therefore, you can use this to verify your right-to-left behavior.
 
 It uses an epsilon value for float comparison defined in LYTConfig.
 
 \param otherView The view you want to compare to. It does not need to have the same superview, but MUST share some ancestor view.
 \returns True if the view is laid out before another view.
 */
- (BOOL)lyt_before:(UIView *)otherView NS_SWIFT_NAME(lyt_before(_:));

/**
 Version of lyt_before that takes a fromCenter param. If fromCenter is YES, the comparison starts from the center of the view rather than the
 edge, allowing an overlap of up to half of the view. So for example, if this view is at x=0 with a width=10, and another view is at x=6, width=10,
 the function will return YES if fromCenter==YES, NO otherwise. The function honors the epsilon value and right-to-left.
 
 \param otherView The view you want to compare to. It does not need to have the same superview, but MUST share some ancestor view.
 \param fromCenter If YES, allow an overlap up to the center of otherView. If NO, behavior is the same as without the param
 \returns True if the view is laid out before another view, allowing for an overlap up to the center if fromCenter is YES.
 */
- (BOOL)lyt_before:(UIView *)otherView fromCenter:(BOOL)fromCenter NS_SWIFT_NAME(lyt_before(_:fromCenter:));

/**
 Returns whether a view is after another view on the horizontal axis. It returns false if they are overlapping in any way.
 It uses [UIApplication sharedApplication].userInterfaceLayoutDirection to determine what after means. If we are in a right-to-left language (such as 
 Arabic), then after means it must be on the left hand side. Therefore, you can use this to verify your right-to-left behavior.

 It uses an epsilon value for float comparison defined in LYTConfig.

 \param otherView The view you want to compare to. It does not need to have the same superview, but MUST share some ancestor view.
 \returns True if the view is laid out after another view.
 */
- (BOOL)lyt_after:(UIView *)otherView NS_SWIFT_NAME(lyt_after(_:));

/**
 Version of lyt_after that takes a fromCenter param. If fromCenter is YES, the comparison starts from the center of the view rather than the
 edge, allowing an overlap of up to half of the view. So for example, if this view is at x=6 with a width=10, and another view is at x=0, width=10,
 the function will return YES if fromCenter==YES, NO otherwise. The function honors the epsilon value and right-to-left.
 
 \param otherView The view you want to compare to. It does not need to have the same superview, but MUST share some ancestor view.
 \param fromCenter If YES, allow an overlap up to the center of otherView. If NO, behavior is the same as without the param
 \returns True if the view is laid out before another view, allowing for an overlap up to the center if fromCenter is YES.
 */
- (BOOL)lyt_after:(UIView *)otherView fromCenter:(BOOL)fromCenter NS_SWIFT_NAME(lyt_after(_:fromCenter:));

/**
 Returns whether a view is above another view on the vertical axis. It returns false if they are overlapping in any way.

 It uses an epsilon value for float comparison defined in LYTConfig.

 \param otherView The view you want to compare to. It does not need to have the same superview, but MUST share some ancestor view.
 \returns True if the view is laid out above another view.
 */
- (BOOL)lyt_above:(UIView *)otherView NS_SWIFT_NAME(lyt_above(_:));

/**
 Returns whether a view is below another view on the vertical axis. It returns false if they are overlapping in any way.

 It uses an epsilon value for float comparison defined in LYTConfig.

 \param otherView The view you want to compare to. It does not need to have the same superview, but MUST share some ancestor view.
 \returns True if the view is laid out below another view.
 */
- (BOOL)lyt_below:(UIView *)otherView NS_SWIFT_NAME(lyt_below(_:));

/**
 Returns whether the start of a view is aligned with another view on the horizontal axis. It allows views to overlap.
 It uses [UIApplication sharedApplication].userInterfaceLayoutDirection to determine what start means. If we are in a right-to-left language (such as 
 Arabic), then after means it must align the right side of the view. Therefore, you can use this to verify your right-to-left behavior.

 It uses an epsilon value for float comparison defined in LYTConfig.

 \param otherView The view you want to compare to. It does not need to have the same superview, but MUST share some ancestor view.
 \returns True if the view is start aligned with another view.
 */
- (BOOL)lyt_leadingAligned:(UIView *)otherView NS_SWIFT_NAME(lyt_leadingAligned(_:));

/**
 Returns whether the end of a view is aligned with another view on the horizontal axis. It allows views to overlap.
 It uses [UIApplication sharedApplication].userInterfaceLayoutDirection to determine what start means. If we are in a right-to-left language (such as 
 Arabic), then after means it must align the left side of the view. Therefore, you can use this to verify your right-to-left behavior.

 It uses an epsilon value for float comparison defined in LYTConfig.

 \param otherView The view you want to compare to. It does not need to have the same superview, but MUST share some ancestor view.
 \returns True if the view is end aligned with another view.
 */
- (BOOL)lyt_trailingAligned:(UIView *)otherView NS_SWIFT_NAME(lyt_trailingAligned(_:));

/**
 Returns whether the top of a view is aligned with another view on the vertical axis. It allows views to overlap.

 It uses an epsilon value for float comparison defined in LYTConfig.

 \param otherView The view you want to compare to. It does not need to have the same superview, but MUST share some ancestor view.
 \returns True if the view is top aligned with another view.
 */
- (BOOL)lyt_topAligned:(UIView *)otherView NS_SWIFT_NAME(lyt_topAligned(_:));

/**
 Returns whether the bottom of a view is aligned with another view on the vertical axis. It allows views to overlap.

 It uses an epsilon value for float comparison defined in LYTConfig.

 \param otherView The view you want to compare to. It does not need to have the same superview, but MUST share some ancestor view.
 \returns True if the view is bottom aligned with another view.
 */
- (BOOL)lyt_bottomAligned:(UIView *)otherView NS_SWIFT_NAME(lyt_bottomAligned(_:));

@end

NS_ASSUME_NONNULL_END
