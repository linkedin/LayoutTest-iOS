// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/**
 This enum is a bit mask (aka NS_OPTIONS/OptionSet) which you can use to limit results.
 
 LYTTesterLimitResultsNone - Default value. No options are set.
 LYTTesterLimitResultsLimitDataCombinations - Usually, we do all possible combinations of the data. However, if you set this flag, we will do a polynomial
 set of options instead of exponential. Every value in the data set will be run at least once, but not all possible combinations will be run.
 LYTTesterLimitResultsNoSizes - This will ignore any view sizes that are set in the LYTViewProvider or the LYTConfig.
 */
typedef NS_OPTIONS(NSInteger, LYTTesterLimitResults) {
    LYTTesterLimitResultsNone                   = 0,
    LYTTesterLimitResultsLimitDataCombinations  = 1 << 0,
    LYTTesterLimitResultsNoSizes                = 1 << 1
};

@interface LYTLayoutPropertyTester : NSObject

/**
 Runs a suite of tests on a given viewProvider. This is the main method to be used for your unit tests.
 
 Instead of calling this directly, it's more common to subclass the more powerful LYTLayoutTestCase.

 \param viewProvider Class to test. Must conform to LYTViewProvider.
 \param validation Block to validate the view given the data. The data here will not contain any LYTDataValues subclasses and both the view and data
 will never be nil. Here you should assert on the properties of the view. If you set a context in your viewForData: method, it will be passed back here.
 */
+ (void)runPropertyTestsWithViewProvider:(Class)viewProvider validation:(void(^)(id view, NSDictionary *data, _Nullable id context))validation;

/**
 Runs a suite of tests on a given viewProvider. This is the main method to be used for your unit tests.
 
 Instead of calling this directly, it's more common to subclass the more powerful LYTLayoutTestCase.

 \param viewProvider Class to test. Must conform to LYTViewProvider.
 \param validation Block to validate the view given the data. The data here will not contain any LYTDataValues subclasses and both the view and data 
 will never be nil. Here you should assert on the properties of the view. If you set a context in your viewForData: method, it will be passed back here.
 \param limitResults Use this parameter to run less combinations. This is useful if you're running into performance problems. See LYTTesterLimitResults 
 docs for more info.
 */
+ (void)runPropertyTestsWithViewProvider:(Class)viewProvider limitResults:(LYTTesterLimitResults)limitResults validation:(void(^)(id view, NSDictionary *data, id _Nullable context))validation;

@end

NS_ASSUME_NONNULL_END
