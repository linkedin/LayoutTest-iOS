Testing Different View Sizes
----------------------------

Often, it's useful to test your view on different sizes. For instance, when testing a UITableViewCell subclass, you may want to test on iPhone 5, iPhone 6, iPad, etc.

First, you need to implement sizesForView:

.. code-block:: objective-c

  // Objective-C
  + (NSArray<LYTViewSize *> *)sizesForView {
    return @[
      [[LYTViewSize alloc] initWithWidth:@(LYTiPhone4Width)],
      [[LYTViewSize alloc] initWithWidth:@(LYTiPadWidth)]
    ]
  }

.. code-block:: objective-c

  // Swift
  class func sizesForView() -> [LYTViewSize] {
    return [
      LYTViewSize(width: LYTiPhone4Width),
      LYTViewSize(width: LYTiPadWidth)
    ]
  }

This will now run your tests twice - once on either size. Note that the tests will only edit the width of the view, not the height. This is likely what you want, but you can choose to edit the height instead or as well as the width.

If you need to dynamically set the height of the view, you can also implement ``+ (void)adjustViewSize:data:size:context:`` which gives you one last chance to change the height of the view before the test is run. See the in code docs for more information.

.. NOTE::
  These tests don't actually run on these devices. They will always just run the tests on the target device. These are just constants which define a certain width and it will resize the view to this width while running tests.

These sizes can also be set in the config so they are globally set for all tests.
