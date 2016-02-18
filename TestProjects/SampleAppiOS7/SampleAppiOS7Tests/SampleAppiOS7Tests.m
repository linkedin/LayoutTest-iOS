//
//  SampleAppiOS7Tests.m
//  SampleAppiOS7Tests
//
//  Created by Peter Livesey on 2/18/16.
//  Copyright © 2016 LinkedIn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "LayoutTest.h"
#import "LYTViewProvider.h"


@interface ViewController () <LYTViewProvider>

@end

@implementation ViewController

+ (NSDictionary *)dataSpecForTest {
    return @{};
}

+ (UIView *)viewForData:(NSDictionary *)data reuseView:(nullable UIView *)reuseView size:(nullable LYTViewSize *)size context:(id _Nullable * _Nullable)context {
    ViewController *controller = [[ViewController alloc] init];
    *context = controller;
    return controller.view;
}

@end

@interface SampleAppiOS7Tests : LYTLayoutTestCase

@end

@implementation SampleAppiOS7Tests

- (void)testExample {
    [self runLayoutTestsWithViewProvider:[ViewController class] validation:^(id view, NSDictionary *data, id context) {
        // Run no extra tests
    }];
}

@end
