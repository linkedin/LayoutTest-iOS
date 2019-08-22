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

NS_SWIFT_NAME(Config)
@interface LYTConfig : NSObject

/**
 If set, when running a LYTLayoutTestCase, it will fail the test if there are more combinations than this value.

 Default: nil
 */
@property (nonatomic, nullable) NSNumber *maxNumberOfCombinations;

/**
 An NSArray of LYTViewSizes. If a test does not specify any view sizes with sizesForView in the LYTViewProvider it will instead use these sizes.
 */
@property (nonatomic, strong, nullable) NSArray *viewSizesToTest;

/**
 If on, when running a LYTLayoutTestCase, it will automatically check to make sure subviews don't overlap.

 This property can also be turned on/off on each LayoutTestCase.

 Default: true
 */
@property (nonatomic) BOOL viewOverlapTestsEnabled;

/**
 If on, when running a LYTLayoutTestCase, it will automatically check to make sure each view is within the bounds of it's superview.

 This property can also be turned on/off on each LayoutTestCase.

 Default: true
 */
@property (nonatomic) BOOL viewWithinSuperviewTestsEnabled;

/**
 If on, when running a LYTLayoutTestCase, it will automatically check to make sure each view doesn't have ambiguous layout.

 This property can also be turned on/off on each LayoutTestCase.

 Default: true
 */
@property (nonatomic) BOOL ambiguousAutolayoutTestsEnabled;

/**
 If on, when running every LYTLayoutTestCase, the LYTAutolayoutFailureIntercepter will be turned on and off for every test. If it fails, it will fail the
 test. Specifically, this is lazily turned on whenever you call runLayoutTestsWithViewProvider: and turned off in tearDown.

 This property can also be turned on/off on each LayoutTestCase.
 
 Default: true
 */
@property (nonatomic) BOOL interceptsAutolayoutErrors;

/**
 If on, it will run a few accessibility tests. These include:

 - If an element has an accessibility label, then no parent view should have an accessibility label. This will make the current element unusable for 
 accessibility users.
 - If an element is included in viewClassesRequiringAccessibilityLabels it should have an accessibility label.
 - If a view has an accessibility identifier, then it should always have a label. Otherwise, the accessibility identifier will be read out by voice over.

 This property can also be turned on/off on each LayoutTestCase.

 Default: true
 */
@property (nonatomic) BOOL accessibilityTestsEnabled;

/**
 If on, a snapshot of the view for the current failing test will be saved to the derived data folder. The data for the failing test is also logged in the index.html file for each LYTLayoutTestCase sub class. The path to the folder is logged after the test suite has finished.
 
 This property can also be turned on/off on each LayoutTestCase.
 
 Default: true
 */
@property (nonatomic) BOOL failingTestSnapshotsEnabled;

/**
 When we traverse the view hierarchy, we expect some elements to always have accessibility labels. For instance, UIControls should have accessibility
 labels or they won't be useable by accessibility users. Any element which subclasses one of these classes should have an accessibility label.

 This property can also be turned on/off on each LayoutTestCase.

 Defaults:
 - UIControl
 */
@property (nonatomic) NSSet<Class> *viewClassesRequiringAccessibilityLabels;

/**
 When we traverse the view hierarchy looking for overlapping and out of bounds views, we sometimes hit a class which knowingly allows this behavior.
 For instance, UISwitch internally has overlapping subviews. We want to make sure that none of our views overlap the UISwitch, but don't care about
 anything internally in UISwitch. Anything that is a class from this set will ignore all automatic tests for its subviews.

 @b IMPORTANT @@b

 There are some default UIKit views in this set. If you want to add to the set, it's recommended to create a mutable copy and then add your views.

 This property can also be turned on/off on each LayoutTestCase.

 Defaults:
 - UISwitch
 - UITextView
 - UIButton
 */
@property (nonatomic, strong) NSSet<Class> *viewClassesAllowingSubviewErrors;

/**
 When comparing CGFloats, sometimes 'equal' floats can differ very slightly. This can cause x > y to return true, even though they are effectively 
 equal. When testing for overlapping views, we don't consider a right view with bounds at 5.000000001 to overlap with a left view of 5.
 
 This property can only be set in the config.
 
 Default: 1e-5
 */
@property (nonatomic) CGFloat cgFloatEpsilon;


/**
 Default snapshots to save per method.
 */
extern NSInteger const LYTSaveUnlimitedSnapshotsPerMethod;

/**
 Limits the number of snapshots that will be saved for each method in a LYTLayoutTestCase. If a test has multiple XCTAsserts which can fail for each size/data iteration there is the possiblity that hundreds of snapshots will be produced. Setting this to a value of 0 or greater will limit the number of images saved.
 
 This property can only be set in the config.
 
 Default: SaveUnlimitedSnapshotsPerMethod(-1) (Representing unlimited)
 */
@property (nonatomic) NSInteger snapshotsToSavePerMethod;

/**
 Singleton accessor.
 */
+ (instancetype)sharedInstance;

/**
 Reset the config to the defaults.
 */
- (void)resetDefaults;

@end

/**
 Convenience function for comparing equality of CGFloats using the epsilon value defined in LYTConfig.
 */
BOOL LYTEpsilonEqual(CGFloat x, CGFloat y);

NS_ASSUME_NONNULL_END
