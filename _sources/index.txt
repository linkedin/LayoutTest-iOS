.. Layout Testing Library documentation master file, created by
   sphinx-quickstart on Wed Jan 21 10:16:33 2015.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to Layout Testing Library's documentation!
==================================================

Contents:

.. toctree::
   :maxdepth: 1
   :glob:

   pages/*

This library enables you to write unit tests which test the layout of a view in multiple configurations. It tests the view with different data combinations and different view sizes. The library works in both Objective-C and Swift.

The syntax is also light allowing you to add these tests easily. This test automatically verifies no views are overlapping, verifies Autolayout doesn't throw and runs some sanity accessibility tests.

.. code-block:: objective-c

  @interface SampleTableViewCellLayoutTests : LYTLayoutTestCase
  @end

  @implementation LayoutTestCaseMissingLabelTests

  - (void)testSampleTableViewCellLayout {
    [self runLayoutTestsWithViewProvider:[SampleTableViewCell class]
                              validation:^(UIView * view, NSDictionary * data, id context) {
      // Add your custom tests here.
    }];
  }

  @end

  @implementation SampleTableViewCell (LayoutTesting)
    + (NSDictionary *)dataSpecForTest {
      return @{
        @"text": [[LYTStringValues alloc] init],
        @"showButton": [[LYTBoolValues alloc] init]
      }
    }
    + (UIView *)viewForData:(NSDictionary *)data
                  reuseView:(nullable UIView *)reuseView
                       size:(nullable LYTViewSize *)size
                    context:(id _Nullable * _Nullable)context {
      SampleTableViewCell *view = (SampleTableViewCell *)reuseView ?: [SampleTableViewCell viewFromNib];
      [view setupWithJSON:data];
      return view;
    }
  @end

These docs do not try to give API level documentation. Instead, they try to outline at a higher level the purpose and motivation for this library. These docs should give you a good overview of what the library does, how to set it up, an overview of the API, etc. To get the API level documentation, you should checkout the headers in the code.
