# Overview

This library enables you to write unit tests which test the layout of a view in multiple configurations. It tests the view with different data combinations and different view sizes. The library works in both Objective-C and Swift.

## Docs

To get started, you should take a look at the docs: 

http://linkedin.github.io/LayoutTest-iOS

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

```objective-c
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
``` 

