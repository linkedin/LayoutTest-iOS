// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import Foundation
import LayoutTestBase

/**
This class defines a basic XCTestCase subclass which implements multiple layout test helpers. It's recommended that your layout tests subclass this class.

The basic test will just call one of the methods starting with runLayoutTests. The rest of the class provides helpers to configure your tests futher.

** Subclassing Notes **

It's also recommended that you create your own subclass of this for your own project, and have all your other tests subclass this class. This allows you to add
 and remove features in the future. There is a category in the superclass which lists some methods you may want to consider overriding.
*/
open class LayoutTestCase: LYTLayoutTestCase {

    /**
    This is the main method that runs your tests. It is a more Swift friendly version than its Objective-C counterparts. This method assumes your view 
     class implements the LYTViewProvider. Often, it's easy to do this by providing an extension on your view in your tests. You therefore MUST 
     declare an explicit type for the first parameter of the validation closure and this type must be a subclass of UIView and implement 
     LYTViewProvider.

    It also runs a few tests automatically:

    - Tests that that no sibling subviews are overlapping.
    - Tests that that no subview is out of the bounds of its parent view.
    - Tests that that autolayout is not ambiguous.
    - Tests that autolayout doesn't throw any errors.
    - Performs some accessibility sanity checks.
      - Verifies that all UIControl elements have an accessibilityLabel.
      - Verifies that no accessibility elements are nested (otherwise they aren't available to accessibility users).
      - Verifies that all views with accessibility identifiers have accessibility labels. If a view has an identifier and does not have a label, voice over 
     will read out the identifier to the user.

    All of these automatic tests can be turned off using the properties in LYTLayoutTestCase or globally with LYTConfig.

    - Parameter limitResults: Use this parameter to run less combinations. This is useful if you're running into performance problems. See 
     LYTTesterLimitResults docs for more info.
    - Parameter validation: (view, data, context) Closure to validate the view given the data. The data here will not contain any LYTDataValues subclasses. 
     Here you should assert on the properties of the view. If you set a context in your viewForData: method, it will be passed back here.
    */
    open func runLayoutTests<TestableView: ViewProvider>(limitResults: LYTTesterLimitResults = LYTTesterLimitResults(),
                             validation: (TestableView, [AnyHashable: Any], Any?) -> Void) where TestableView: UIView {
        self.runLayoutTests(withViewProvider: TestableView.self, limitResults: limitResults) { (view, data, context) in
            if let view = view as? TestableView {
                validation(view, data, context)
            } else {
                self.failTest("The view wasn't of the expected type. Change your method signature to declare the view in the validation closure " +
                    "of the correct type. Expected: \(TestableView.self) Actual: \(type(of: (view) as AnyObject))", view: view as? UIView)
            }
        }
    }

    /**
    This is the main method that runs your tests. It is a more Swift friendly version than its Objective-C counterparts. This method makes the same assumptions
     as it's Objective-C version, but enforces them with the compiler. Tests that that the class you pass implements LYTViewProvider and checks that
     the view you return in the completion block is a UIView.
    In Objective-C, it allows you to cast easily from id to a specific class, but this doesn't exist in Swift. So using generics, we can do the cast for the
     user of the method.

    It also runs a few tests automatically:

    - Tests that that no sibling subviews are overlapping.
    - Tests that that no subview is out of the bounds of its parent view.
    - Tests that that autolayout is not ambiguous.
     - Tests that autolayout doesn't throw any errors.
     - Performs some accessibility sanity checks.
     - Verifies that all UIControl elements have an accessibilityLabel.
     - Verifies that no accessibility elements are nested (otherwise they aren't available to accessibility users).
     - Verifies that all views with accessibility identifiers have accessibility labels. If a view has an identifier and does not have a label, voice over
     will read out the identifier to the user.

     All of these automatic tests can be turned off using the properties in LYTLayoutTestCase or globally with LYTConfig.

     - Parameter viewProvider: Class to test. Must conform to LYTViewProvider.
     - Parameter limitResults: Use this parameter to run less combinations. This is useful if you're running into performance problems. See
     LYTTesterLimitResults docs for more info.
     - Parameter validation: (view, data, context) Block to validate the view given the data. The data here will not contain any LYTDataValues subclasses.
     Here you should assert on the properties of the view. If you set a context in your viewForData: method, it will be passed back here.
     */
    open func runLayoutTests<TestableView: UIView, ViewProviderType: ViewProvider>(withViewProvider viewProvider: ViewProviderType.Type,
                             limitResults: LYTTesterLimitResults = LYTTesterLimitResults(),
                             validation: (TestableView, [AnyHashable: Any], Any?) -> Void) {
        self.runLayoutTests(withViewProvider: viewProvider, limitResults: limitResults) { (view: Any, data, context) in
            if let view = view as? TestableView {
                validation(view, data, context)
            } else {
                self.failTest("The view wasn't of the expected type. Change your method signature to declare the view in the validation closure " +
                    "of the correct type. Expected: \(TestableView.self) Actual: \(type(of: view))", view: view as? UIView)
            }
        }
    }
}
