Testing Other Objects
---------------------

Usually, you want to test a UIView subclass, but sometimes, you need to track other objects as well. For instance, you may want to test the view of a UIViewController subclass. To test this, you need to have a reference to the UIViewController in your tests (to access IBOutlets and other things). To do this, you can use the context parameter. This can be used for many other things but testing UIViewControllers serves as a good example.

Sample Code
===========

.. code-block:: objective-c

  // Objective-C
  // LYTViewProvider
  + (nullable UIView *)viewForData:(NSDictionary *)data
                reuseView:(nullable UIView *)reuseView
                     size:(nullable LYTViewSize *)size
                  context:(id _Nullable * _Nullable)context
                  error:(__unused NSError * _Nullable __autoreleasing *)error {
    // Ignoring reuse because it doesn't make sense for testing UIViewController subclasses
    SampleViewController *controller = [[SampleViewController alloc] init];
    [controller setupWithDictionary:data];
    *context = controller;
    return controller.view;
  }

  // LYTLayoutTest
  - (void)testViewController {
    [self runLayoutTestsWithViewProvider:[SampleViewController class]
                              validation:^(UIView * view, NSDictionary * data, id context) {
      SampleViewController *controller = context;
      // Rest of your test goes here
    }
  }

.. code-block:: objective-c

  // Swift
  // LYTViewProvider
  class func viewForData(data: [NSObject: AnyObject],
                    reuseView: UIView?,
                         size: LYTViewSize?,
                      context: AutoreleasingUnsafeMutablePointer<AnyObject?>) throws -> UIView {
    // Ignoring reuse because it doesn't make sense for testing UIViewController subclasses
    let controller = SampleViewController()
    controller.setupWithData(data)
    context.memory = controller
    return controller.view
  }

  // LayoutTest
  func testViewController() {
    runLayoutTestsWithViewProvider(SampleViewController.self) { (view: UIView, data: [NSObject: AnyObject], context: Any?) in
      let controller = context as! SampleViewController
      // Rest of your test goes here
    }
  }
