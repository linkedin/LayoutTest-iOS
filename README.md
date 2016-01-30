# Overview

This library enables you to write unit tests which test the layout of a view in multiple configurations. It tests the view with different data combinations and different view sizes. The library works in both Objective-C and Swift.

## Motivation

When creating views, apps often have conditional logic which depends on the data used to setup the view. LayoutTest provides an easy way to define a data spec (a dictionary) which is then used to generate many different combinations of data. The library then uses this data to layout your view multiple times. For example, this is a small portion of the tests ran in our sample app:

<div align="center"><img src="https://raw.githubusercontent.com/linkedin/LayoutTest-iOS/master/docs/images/catalog.png" height="400px" /></div>

In just one test, your view will be laid out multiple times with different data. You can then run test assertions on these views to verify that the layout and view content is correct. Also, the library will run a few tests automatically such as checking for Autolayout errors, missing accessibility, and overlapping views.
Finally, the library makes it easy to test each view with different sizes so you can verify the view will work on different devices.

## Docs

To get started, you should take a look at the docs: 

https://linkedin.github.io/LayoutTest-iOS

## Installation

Add to your unit test target:

```
pod 'LayoutTest'
```

or

```
pod 'LayoutTest/Swift'
```

## Example

A simple test would look something like this. Check the docs for more detailed information and examples.

Objective-C:
```objective-c
@interface SampleTableViewCellLayoutTests : LYTLayoutTestCase
@end

@implementation SampleTableViewCellLayoutTests
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
``` 
Swift:

```swift
class SampleTableViewCellLayoutTests {
  func testSampleTableViewCell() {
    runLayoutTests() { (view: SampleTableViewCell, data: [NSObject: AnyObject], context: Any?) in
      // Add your custom tests here.
    }
  }
}

extension SampleTableViewCell: LYTViewProvider {
  class func dataSpecForTest() -> [NSObject: AnyObject] {
    return [
      "text": LYTStringValues(),
      "showButton": LYTBoolValues()
    ]
  }
  class func viewForData(data: [NSObject: AnyObject],
                    reuseView: UIView?,
                         size: LYTViewSize?,
                      context: AutoreleasingUnsafeMutablePointer<AnyObject?>) -> UIView {
    let cell = reuseView as? SampleTableViewCell ?? SampleTableViewCell.loadFromNib()
    cell.setupWithDictionary(data)
    return cell
  }
} 
```
