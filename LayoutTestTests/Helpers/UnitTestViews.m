// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "UnitTestViews.h"
#import "UIViewWithLabel.h"

@interface AmbiguousLayoutView : UIView

@end

@implementation UnitTestViews

+ (UIView *)viewWithNoProblems {
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 10, 10)];
    UIView *superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    [superview addSubview:view1];
    [superview addSubview:view2];

    view1.autoresizingMask = UIViewAutoresizingNone;
    view2.autoresizingMask = UIViewAutoresizingNone;

    return superview;
}

+ (UIView *)viewWithIncorrectAutolayout {
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 10, 10)];
    UIView *superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    [superview addSubview:view1];
    [superview addSubview:view2];

    NSDictionary *viewsDictionary = @{
                                      @"view1": view1,
                                      @"view2": view2
                                      };
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[view1]-0-[view2]" options:0 metrics:nil views:viewsDictionary]];
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[view1]-10-[view2]" options:0 metrics:nil views:viewsDictionary]];

    return superview;
}

+ (UIView *)viewWithOverlappingViews {
    // This view is too wide, so will overlap with the second view
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 11, 5)];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, 4, 10, 5)];
    UIView *superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    [superview addSubview:view1];
    [superview addSubview:view2];

    view1.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    view2.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    return superview;
}

+ (UIView *)viewWithUISwitchSubview {
    UIView *view1 = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    UIView *superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    [superview addSubview:view1];

    view1.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    return superview;
}

+ (UIView *)viewWithSubviewOutOfSuperview {
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, 10, 10)];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 10, 10)];
    UIView *superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    [superview addSubview:view1];
    [superview addSubview:view2];

    view1.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    view2.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    return superview;
}

+ (UIView *)viewWithAmbiguousLayout {
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    UIView *view2 = [[AmbiguousLayoutView alloc] initWithFrame:CGRectMake(10, 0, 5, 5)];
    UIView *superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];

    superview.translatesAutoresizingMaskIntoConstraints = NO;
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    view2.translatesAutoresizingMaskIntoConstraints = NO;

    [superview addSubview:view1];
    [superview addSubview:view2];

    return superview;
}

+ (UIView *)viewWithButtonAndAccessibility {
    UIView *view1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIView *view2 = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 10, 10)];
    UIView *superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    [superview addSubview:view1];
    [superview addSubview:view2];

    view1.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    view2.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    view1.accessibilityLabel = @"View 1";
    view2.accessibilityLabel = @"View 2";

    return superview;
}

+ (UIView *)viewWithButtonAndNoAccessibility {
    UIView *view1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIView *superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    [superview addSubview:view1];

    view1.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    return superview;
}

+ (UIView *)viewWithNestedAccessibility {
    UIView *view1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIView *superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    [superview addSubview:view1];

    view1.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    view1.accessibilityLabel = @"View 1";
    superview.accessibilityLabel = @"Super view label which hides my subview's label";

    return superview;
}

+ (UIView *)viewWithAccessibilityIDButNoLabel {
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 10, 10)];
    UIView *superview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
    [superview addSubview:view1];
    [superview addSubview:view2];

    view1.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    view2.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    view1.accessibilityIdentifier = @"ID but no label?";

    return superview;
}

+ (UIViewWithLabel *)viewWithLongStringOverlappingLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 10)];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(23, 0, 10, 10)];
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(label, view2);
    UIViewWithLabel *superview = [[UIViewWithLabel alloc] initWithFrame:CGRectMake(0, 0, 272, 22)];
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = @"X";
    
    view2.translatesAutoresizingMaskIntoConstraints = NO;
    
    [superview addSubview:label];
    [superview addSubview:view2];
    superview.label = label;
    superview.translatesAutoresizingMaskIntoConstraints = NO;
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[label]" options:NSLayoutFormatAlignAllTop metrics:nil views:viewsDictionary]];
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view2(10)]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:viewsDictionary]];
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[label]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:viewsDictionary]];
    [superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view2]-0-|" options:NSLayoutFormatAlignAllTop metrics:nil views:viewsDictionary]];
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:superview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:272]];
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:superview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:22]];
    
    return superview;
}

@end

/**
 I have so far been unable to reproduce a view which has ambiguous layout in unit tests.
 I'm not sure why this is, but it seems to suggest that my code may not be working. However, for now, I'll just test using a view which overrides this property to be true.

 TODO: Try to investigate why everything returns false for hasAmbiguousLayout (https://github.com/linkedin/LayoutTest-iOS/issues/2)
 */
@implementation AmbiguousLayoutView

- (BOOL)hasAmbiguousLayout {
    return YES;
}

@end
