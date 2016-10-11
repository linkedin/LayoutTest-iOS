// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

NS_SWIFT_NAME(LayoutFailingTestSnapshotRecorder)
@interface LYTLayoutFailingTestSnapshotRecorder : NSObject<XCTestObservation>

/**
 Singleton accessor.
 */
+ (instancetype)sharedInstance;

/**
 Creates the new folder structure and starts index.html file for the given class. If a folder already exists for the class it will be deleted first to clear any images previously saved for failing tests in that class.
 
 Folder structure for images follows the pattern: {DERIVED_DATA}/LayoutTestImages/{CLASS_NAME}/index.html
 Index.html file includes tables with failure description, image and the data that the image failed with.
 
  \param invocationClass The class to start a new log for, class name is used in the directory structure to save the snapshots.
 */
- (void)startNewLogForClass:(Class)invocationClass;

/**
 Finishes the index.html log for the current invocation class by adding closing html tags.
 Can be called safely without calling startNewLogForClass: as no index.html file for the class with exists so nothing will happen.
 
 Then file path to the index.html file for the current class is saved after all of the tests in the test class finish running. Once all test classes in  have finished all saved failing test index.html file paths are logged to the console.
 */
- (void)finishLog;

/**
 Renders the view passed as a png and saves it. The failure description, image and data are added to the index.html file for the current test class.
 The invocation is used to create a folder for the invocations method name and the failing views for that invocation are saved within. Folder structure for invocation follows the pattern: {DERIVED_DATA}/LayoutTestImages/{CLASS_NAME}/{METHOD_NAME}/
 Images sare saved with the file name format: Width-{VIEW_WIDTH}_Height-{VIEW_HEIGHT}_Data-{DATA_DESCRIPTION_HASH}.png
 
 \param view The view to save a image of.
 \param data The data that was used to poulate the view
 \param invocation The invocation for the current test. When used from a XCTestCase subclass the invocation will include the name of the test method currently being run.
 \param failureDescription The description of why the view that is being saved failed its layout tests.
 */
- (void)saveImageOfView:(UIView *)view withData:(NSDictionary *)data fromInvocation:(NSInvocation *)invocation failureDescription:(NSString *)failureDescription;

@end
