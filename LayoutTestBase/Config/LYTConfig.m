// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <UIKit/UIKit.h>
#import "LYTConfig.h"

@implementation LYTConfig

NSInteger const LYTSaveUnlimitedSnapshotsPerMethod = -1;

+ (instancetype)sharedInstance {
    static LYTConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LYTConfig alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    [self resetDefaults];
    return self;
}

- (void)resetDefaults {
    self.maxNumberOfCombinations = nil;
    self.viewSizesToTest = nil;
    self.viewOverlapTestsEnabled = YES;
    self.viewWithinSuperviewTestsEnabled = YES;
    self.ambiguousAutolayoutTestsEnabled = YES;
    self.interceptsAutolayoutErrors = YES;
    self.accessibilityTestsEnabled = YES;
    self.failingTestSnapshotsEnabled = YES;
    /*
     UISwitch - This is a known class which has internal overlapping subviews.
     UITextView - If you use attributed text, UIKit may add UIImage views which can overlap with the internal text containers.
     UIButton - If you set a background image, then this will overlap with other internal views.
     */
    self.viewClassesAllowingSubviewErrors = [NSSet setWithObjects:[UISwitch class], [UITextView class], [UIButton class], nil];
    /*
     UIControl - Subclasses of UIControl should all have accessibility labels.
     */
    self.viewClassesRequiringAccessibilityLabels = [NSSet setWithObjects:[UIControl class], nil];
    self.cgFloatEpsilon = 1e-5f;
    self.snapshotsToSavePerMethod = LYTSaveUnlimitedSnapshotsPerMethod;
}

@end

BOOL LYTEpsilonEqual(CGFloat x, CGFloat y) {
    CGFloat epsilon = [LYTConfig sharedInstance].cgFloatEpsilon;
    return fabs(x - y) < epsilon;
}
