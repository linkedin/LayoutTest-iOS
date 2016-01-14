// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <XCTest/XCTest.h>
@import LayoutTestBase;


NS_ASSUME_NONNULL_BEGIN

/**
 This class defines a basic XCTestCase subclass which implements multiple layout test helpers. It's recommended that your layout tests subclass this class.
 
 The basic test will just call one of the methods starting with runLayoutTestsWithViewProvider:. The rest of the class provides helpers to configure 
 your tests futher.
 
 Subclassing Notes
 
 It's also recommended that you create your own subclass of this for your own project, and have all your other tests subclass this class. This allows you to
 add and remove features in the future. There is a category which lists some methods you may want to consider overriding.
 */
@interface LYTLayoutTestCase : XCTestCase

/**
 If you have a view which purposefully overlaps another view, you can add that view to this set to avoid failing the test. You should do this in the 
 validation block of runLayoutTestsWithViewProvider:validation:. Adding a view to this set will avoid failures for overlapping a sibling view and 
 being out of bounds of the parent view.
 
 This is reset on every iteration of the tests, so you must keep adding views in the validation block.
 
 One example is having a background image view which you know will overlap with many other views. In this case, you should only add the background
 image view to this set (and not the other overlapping views).
 */
@property (nonatomic, readonly, strong) NSMutableSet *viewsAllowingOverlap;

/**
 Views in this set will ignore common accessibility errors and not fail the test.
 */
@property (nonatomic, readonly, strong) NSMutableSet *viewsAllowingAccessibilityErrors;

/**
 This is the main method that runs your tests. You pass in a class that conforms to LYTViewProvider and it will run multiple combinations 
 of data on your view. It will call the validation block with each combination and allow you to run asserts on your view.
 
 It also runs a few tests automatically:
 
 - Tests that that no sibling subviews are overlapping.
 - Tests that that no subview is out of the bounds of its parent view.
 - Tests that that autolayout is not ambiguous.
 - Tests that autolayout doesn't throw any errors.
 - Performs some accessibility sanity checks.
   - Verifies that all UIControl elements have an accessibilityLabel.
   - Verifies that no accessibility elements are nested (otherwise they aren't available to accessibility users).
   - Verifies that all views with accessibility identifiers have accessibility labels. If a view has an identifier and does not have a label, voice 
 over will read out the identifier to the user.
 
 All of these automatic tests can be turned off using the properties in this class of this test or globally with LYTConfig.
 
 By default, limitResults is set to false.

 \param viewProvider Class to test. Must conform to LYTViewProvider.
 \param validation (view, data, context) Block to validate the view given the data. The data here will not contain any LYTDataValues subclasses and 
 both the view and data will never be nil. Here you should assert on the properties of the view. If you set a context in your viewForData: method, 
 it will be passed back here.
 */
- (void)runLayoutTestsWithViewProvider:(Class)viewProvider
                            validation:(void(^)(id view, NSDictionary *data, id _Nullable context))validation;

/**
 This is the main method that runs your tests. You pass in a class that conforms to LYTViewProvider and it will run multiple combinations 
 of data on your view. It will call the validation block with each combination and allow you to run asserts on your view.

 It also runs a few tests automatically:

 - Tests that that no sibling subviews are overlapping.
 - Tests that that no subview is out of the bounds of its parent view.
 - Tests that that autolayout is not ambiguous.
 - Tests that autolayout doesn't throw any errors.
 - Performs some accessibility sanity checks.
   - Verifies that all UIControl elements have an accessibilityLabel.
   - Verifies that no accessibility elements are nested (otherwise they aren't available to accessibility users).
   - Verifies that all views with accessibility identifiers have accessibility labels. If a view has an identifier and does not have a label, 
 voice over will read out the identifier to the user.

 All of these automatic tests can be turned off using the properties in this class or globally with LYTConfig.

 \param viewProvider Class to test. Must conform to LYTViewProvider.
 \param limitResults Use this parameter to run less combinations. This is useful if you're running into performance problems. See LYTTesterLimitResults
 docs for more info.
 \param validation (view, data, context) Block to validate the view given the data. The data here will not contain any LYTDataValues subclasses and both
 the view and data will never be nil. Here you should assert on the properties of the view. If you set a context in your viewForData: method, it 
 will be passed back here.
 */
- (void)runLayoutTestsWithViewProvider:(Class)viewProvider
                          limitResults:(LYTTesterLimitResults)limitResults
                            validation:(void(^)(id view, NSDictionary *data, id _Nullable context))validation;

/**
 This method recusively adds all of the subviews of a view to viewsAllowingOverlap. It does NOT add the view you pass in. This is useful if a 
 view has a complex layout internally and you don't want to fail if one of the subviews is overlapping, but you do want to test that this
 view does not overlap with another view.
 
 If this view is a specific class which commonly has this problem, you may want to consider using viewClassesAllowingSubviewErrors on this 
 test or in the global config (LYTConfig).
 
 \param view View to recursively add all the subviews to viewsAllowingOverlap
 */
- (void)recursivelyIgnoreOverlappingSubviewsOnView:(UIView *)view;

#pragma mark - Config

/**
 If on, when running a LYTLayoutTestCase, it will automatically check to make sure subviews don't overlap.

 You can also globally set this as a default in LYTConfig.

 Default: true
 */
@property (nonatomic) BOOL viewOverlapTestsEnabled;

/**
 If on, when running a LYTLayoutTestCase, it will automatically check to make sure each view is within the bounds of it's superview.

 You can also globally set this as a default in LYTConfig.

 Default: true
 */
@property (nonatomic) BOOL viewWithinSuperviewTestsEnabled;

/**
 If on, when running a LYTLayoutTestCase, it will automatically check to make sure each view doesn't have ambiguous layout.

 You can also globally set this as a default in LYTConfig.

 Default: true
 */
@property (nonatomic) BOOL ambiguousAutolayoutTestsEnabled;

/**
 If on, when running this LYTLayoutTestCase, the LYTAutolayoutFailureIntercepter will be turned on and then off. If it fails, it will
 fail the test. Specifically, this is lazily turned on whenever you call runLayoutTestsWithViewProvider: and turned off in tearDown.

 You can also globally set this as a default in LYTConfig.

 Default: true
 */
@property (nonatomic) BOOL interceptsAutolayoutErrors;

/**
 If on, it will run a few accessibility tests. These include:
 
 - If an element has an accessibility label, then no parent view should have an accessibility label. This will make the current element unusable for
 accessibility users.
 - If an element is included in viewClassesRequiringAccessibilityLabels it should have an accessibility label.
 - If a view has an accessibility identifier, then it should always have a label. Otherwise, the accessibility identifier will be read out by voice over.
 
 You can also globally set this as a default in LYTConfig.
 
 Default: true
 */
@property (nonatomic) BOOL accessibilityTestsEnabled;

/**
 When we traverse the view hierarchy, we expect some elements to always have accessibility labels. For instance, UIControls should have accessibility
 labels or they won't be useable by accessibility users. Any element which subclasses one of these classes should have an accessibility label.
 
 You can also globally set this as a default in LYTConfig.
 
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

 You can also globally set this as a default in LYTConfig.

 Defaults:
 - UISwitch
 */
@property (nonatomic, strong) NSSet<Class> *viewClassesAllowingSubviewErrors;

@end

/**
 These methods are helpful when subclassing this class. Overriding these methods could be helpful.
 */
@interface LYTLayoutTestCase (SubclassingOverrides)

/**
 This is called whenever something happens which should fail the test. Our implementation calls XCTFail(...). Therefore, you MUST call super or add your 
 own XCTFail if you want this to fail the test.
 
 NOTE: This only is called for failures to the automatic tests. If you call XCTAssert methods in your validation block, we don't intercept those in any
 way so this method will not be called.
 
 \param errorMessage The error message to present to the user.
 \param view The view which failed one of the tests. Will be null for autolayout failures.
 */
- (void)failTest:(NSString *)errorMessage view:(nullable UIView *)view;

@end

NS_ASSUME_NONNULL_END
