// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

/**
 This file is included in cocoapods because without it, Xcode refuses to build the project. It shouldn't cause any harm.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//! Project version number for LayoutTest.
FOUNDATION_EXPORT double LayoutTestBaseVersionNumber;

//! Project version string for LayoutTest.
FOUNDATION_EXPORT const unsigned char LayoutTestBaseVersionString[];

#pragma mark Main Classes

#import "LYTViewProvider.h"
#import "LYTViewCatalogProvider.h"
#import "LYTConfig.h"
#import "LYTLayoutPropertyTester.h"

#pragma mark View Sizing

#import "LYTViewSize.h"
#import "UIView+LYTViewSize.h"
#import "LYTDeviceConstants.h"

#pragma mark Auto Layout

#import "LYTAutolayoutFailureIntercepter.h"

#pragma mark Data Values

#import "LYTDataValues.h"
#import "LYTBoolValues.h"
#import "LYTFloatValues.h"
#import "LYTIntegerValues.h"
#import "LYTStringValues.h"

#pragma mark Test Helpers

#import "UIView+LYTHelpers.h"
#import "UIView+LYTTestHelpers.h"
#import "UIView+LYTFrameComparison.h"

#pragma mark Catalog

#import "LYTCatalogCollectionViewController.h"
#import "LYTCatalogTableViewController.h"
