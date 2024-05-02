Writing Tests
-------------

To test your view, there are two steps:

  1. Make your view implement LYTViewProvider.
  2. Write your unit test and pass in your view's class.

.. NOTE::
  This page describes how to create a test for a UIView subclass. If you want to test another object (like a UIViewController), see :doc:`090_testingOtherObjects`.

LYTViewProvider
=======================

This protocol dictates how the view is created and inflated with data. There are two methods that are required to implement. One easy way to implement it is to add an extension to the view your are trying to test.

----------------------------------
+ (nullable NSDictionary *)dataSpecForTestWithError:(__unused NSError * _Nullable __autoreleasing *)error;
----------------------------------

This method defines the mock data we will use for the test. It should return an NSDictionary of any format (usually JSON), but can also include LYTDataValues subclasses. These data values are the key to writing property tests and allow the library to create many combinations of this data to inflate your view with. For instance, you can return the dictionary:

.. code-block:: objective-c

  // Objective-C
  @{ @"string": [[LYTStringValues alloc] init], @"int": [[LYTIntegerValues alloc] init] }

.. code-block:: objective-c

  // Swift
  [ "string": LYTStringValues(), "int": LYTIntegerValues() ]

Given this, the library will inflate your view with a different NSDictionary each time. It will produce all the combinations of strings and ints in the generators.

.. code-block:: json

  {"string": "Normal length string", "int": 42},
  {"string": "", "int": 42},
  {"int": 42},
  {"string": "Normal length string", "int": 0},
  {"string": "", "int": 0},
  {"int": 0}, etc.

There are actually more strings and ints in the default data values and this code will produce 30 different dictionaries.

This API makes it easy for you to write tests which will be ran on many different inputs. It's also easy for you to make your own LYTDataValues subclasses (see the LYTDataValues class for more info).

--------------------------------------------------------------------------------------------------------------------------
+ (nullable UIView *)viewForData:(NSDictionary *)data reuseView:(UIView *)reuseView size:(LYTViewSize *)size context:(id *)context error:(NSError **)error;
--------------------------------------------------------------------------------------------------------------------------

This method should inflate your view with data for the test. This data will NOT contain LYTDataValues subclasses, but instead be the output of the LYTDataValues code. A reuse view is provided if you want to reuse views for the test (recommended if you are testing cells). Size and context are additional helpers (see :doc:`030_viewSizes` and :doc:`090_testingOtherObjects`). This method should be simple to implement and look something like this:

.. code-block:: objective-c

  // Objective-C
  #import "LayoutTestBase.h"

  + (nullable UIView *)viewForData:(NSDictionary *)data
                reuseView:(nullable UIView *)reuseView
                     size:(nullable LYTViewSize *)size
                  context:(id _Nullable * _Nullable)context
                  error:(__unused NSError * _Nullable __autoreleasing *)error {
    SimpleTableViewCell *cell = (SimpleTableViewCell *)reuseView ?: [SimpleTableViewCell loadFromNib];
    [cell prepareForReuse];
    [cell setupWithDictionary:data];
    return cell;
  }

.. code-block:: objective-c

  // Swift
  import LayoutTestBase

  class func viewForData(data: [NSObject: AnyObject],
                    reuseView: UIView?,
                         size: LYTViewSize?,
                      context: AutoreleasingUnsafeMutablePointer<AnyObject?>) throws -> UIView {
    let cell = reuseView as? SampleTableViewCell ?? SampleTableViewCell.loadFromNib()
    cell.prepareForReuse()
    cell.setupWithDictionary(data)
    return cell
  }

Writing Your Unit Test
======================

Now, you just need to add a test case which subclasses LYTLayoutTestCase (Objective-C) or LayoutTestCase (Swift) and call runLayoutTests.

.. code-block:: objective-c

  // Objective-C
  #import "LayoutTest.h"
  #import "LayoutTestBase.h"

  - (void)testSampleTableViewCellLayout {
    [self runLayoutTestsWithViewProvider:[SampleTableViewCell class]
                          validation:^(UIView * view, NSDictionary * data, id context) {
      // Add your custom tests here.
    }];
  }

.. code-block:: objective-c

  // Swift
  import LayoutTest
  import LayoutTestBase

  func testSampleTableViewCell() {
    runLayoutTests() { (view: SampleTableViewCell, data: [NSObject: AnyObject], context: Any?) in
      // Add your custom tests here.
    }
  }

This example is taken from the sample project unit tests. You can view a more complete example there.

Testing Different View Sizes
============================

See :doc:`030_viewSizes`
