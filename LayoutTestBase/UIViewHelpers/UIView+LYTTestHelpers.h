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

@interface UIView (LYTTestHelpers)

/**
 Useful helper for writing tests. Ensures that all the subviews of the view are within the bounds of their superviews. If this condition breaks, it 
 calls the error block. This is not recursive.
 
 When comparing CGFloats, (x > y) if and only if (x > y + epsilon). This epsilon value is defined in LYTConfig.

 \discussion

 When calling this on UITableViewCells, you should probably call it on cell.contentView because it sometimes fails for the contentView in it's superview
 due to some UIKit weirdness.
 */
- (void)lyt_assertViewWithinSuperViewBounds:(void(^)(NSString *error, UIView *view))errorBlock;

/**
 Useful helper for writing tests. Ensures recursively that all the subviews of the view are within the bounds of their superviews. If this condition breaks,
 it calls the error block.
 
 When comparing CGFloats, (x > y) if and only if (x > y + epsilon). This epsilon value is defined in LYTConfig.

 \discussion

 When calling this on UITableViewCells, you should probably call it on cell.contentView because it sometimes fails for the contentView in it's superview
 due to some UIKit weirdness.
 */
- (void)lyt_recursivelyAssertViewWithinSuperViewBounds:(void(^)(NSString *error, UIView *view))errorBlock;

/**
 Useful helper for writing tests. Ensures that none of the subviews of this view overlap.
 
 When comparing CGFloats, (x > y) if and only if (x > y + epsilon). This epsilon value is defined in LYTConfig.
 */
- (void)lyt_assertNoSubviewsOverlap:(void(^)(NSString *error, UIView *view1, UIView *view2))errorBlock;

/**
 Useful helper for writing tests. Ensures that none of the subviews of this view overlap. It calls this recursively on subviews, but does not test all 
 combinations of subviews (ie. one subview from view tree A and a subview from view tree B). It only tests all combinations of immediate subviews. 
 However, if you combine this with lyt_recursivelyAssertViewWithinSuperViewBounds: then you can be sure that no subviews from different trees will overlap.
 
 When comparing CGFloats, (x > y) if and only if (x > y + epsilon). This epsilon value is defined in LYTConfig.
 */
- (void)lyt_recursivelyAssertNoSubviewsOverlap:(void(^)(NSString *error, UIView *view1, UIView *view2))errorBlock;

/**
 This method first returns the current view, then traverses the view hierarchy.
 */
- (void)lyt_recursivelyTraverseViewHierarchy:(void(^)(UIView *subview))subviewBlock;

/**
 This method first returns the current view, then traverses the view hierarchy.

 It also provides a stop parameter. If you set this to true, then the method will stop recursing on this branch only.
 */
- (void)lyt_recursivelyTraverseViewHierarchyWithStop:(void(^)(UIView *subview, BOOL *stopBranch))subviewBlock;

@end

NS_ASSUME_NONNULL_END
