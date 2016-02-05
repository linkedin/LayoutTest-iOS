// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LYTLayoutPropertyTester.h"
// Protocols
#import "LYTViewProvider.h"
// Classes
#import "LYTDataValues.h"
#import "LYTValuesIterator.h"
#import "LYTViewSize.h"
// Helpers
#import "LYTMutableCopier.h"
#import "UIView+LYTViewSize.h"
// Config
#import "LYTConfig.h"


@implementation LYTLayoutPropertyTester

#pragma mark - Public

+ (void)runPropertyTestsWithViewProvider:(Class)viewProvider validation:(void(^)(id view, NSDictionary *data, id context))validation {
    [self runPropertyTestsWithViewProvider:viewProvider
                                  limitResults:LYTTesterLimitResultsNone
                                    validation:validation];
}

+ (void)runPropertyTestsWithViewProvider:(Class)viewProvider limitResults:(LYTTesterLimitResults)limitResults validation:(void(^)(id view, NSDictionary *data, id context))validation {
    NSAssert([viewProvider conformsToProtocol:@protocol(LYTViewProvider)], @"You must pass in a class which conforms to LYTViewProvider");
    NSAssert(validation, @"You must pass in a validation block");

    NSDictionary *mutatingData = [viewProvider dataSpecForTest];
    NSMutableArray *iterators = [NSMutableArray array];
    NSDictionary *dataWithIterators = [mutatingData lyt_mutableDeepCopyWithReplaceBlock:^id(id object) {
        if ([object isKindOfClass:[LYTDataValues class]]) {
            LYTValuesIterator *iterator = [[LYTValuesIterator alloc] init];
            iterator.dataValues = object;
            iterator.index = 0;
            [iterators addObject:iterator];
            return iterator;
        }
        return object;
    }];

    // Run all the combinations of the iterators and create dictionaries will all the possible values

    // Save this view for reuse
    __block UIView *reuseView = nil;

    if (limitResults & LYTTesterLimitResultsLimitDataCombinations) {
        // Run each generator against only the default values of every other generator
        // This is O(n*m) where n is number of LYTDataValues subclasses and m is the length of the LYTDataValues subclasses

        // First, run it with everything set to 0
        NSDictionary *actualData = [self dataFromDataWithIterators:dataWithIterators];
        // Finally, let's run the test
        reuseView = [self validateViewWithProviderProtocol:viewProvider
                                                      data:actualData
                                                 reuseView:reuseView
                                              limitResults:limitResults
                                                     block:validation];

        // Now, let's run it for each iterator on all of its options
        // Every other iterator will be set to zero for this iteration
        // We'll start at 1 so we don't replicate everything at 0
        for (LYTValuesIterator *iterator in iterators) {
            // Remember, start at 1
            for (iterator.index = 1; iterator.index < iterator.dataValues.numberOfValues; iterator.index++) {
                NSDictionary *actualData = [self dataFromDataWithIterators:dataWithIterators];
                reuseView = [self validateViewWithProviderProtocol:viewProvider
                                                              data:actualData
                                                         reuseView:reuseView
                                                      limitResults:limitResults
                                                             block:validation];
            }
            // Reset after the last one
            iterator.index = 0;
        }
    } else {
        // Run every combination of values in the LYTDataValues subclasses
        // This is O(m^n) where n is number of LYTDataValues subclasses and m is the length of the LYTDataValues subclasses
        [self runCombinationOfIterators:iterators
                           withCallback:^(NSArray *iterators) {

                               NSDictionary *actualData = [self dataFromDataWithIterators:dataWithIterators];

                               // Finally, let's run the test
                               reuseView = [self validateViewWithProviderProtocol:viewProvider
                                                                             data:actualData
                                                                        reuseView:reuseView
                                                                     limitResults:limitResults
                                                                            block:validation];
                           }];
    }
}

#pragma mark - Run Tests

/**
 This method takes some data from an iterator (no LYTDataValues subclasses) and a view provider protocol and runs all the tests we should. This includes running on all sizes and will run the validation block.
 
 It returns the last view it ran a test on so the reuse view can be set to this.
 */
+ (UIView *)validateViewWithProviderProtocol:(Class)viewProvider
                                        data:(NSDictionary *)data
                                   reuseView:(nullable UIView *)reuseView
                                limitResults:(LYTTesterLimitResults)limitResults
                                       block:(void(^)(UIView *view, NSDictionary *data, id context))validation {
    NSArray *sizes = [self viewSizesForProviderProtocol:viewProvider limitResults:limitResults];
    if (sizes) {
        for (LYTViewSize *size in sizes) {
            reuseView = [self runSingleTestWithProviderProtocol:viewProvider
                                                           data:data
                                                      reuseView:reuseView
                                                           size:size
                                                          block:validation];
        }
    } else {
        reuseView = [self runSingleTestWithProviderProtocol:viewProvider
                                                       data:data
                                                  reuseView:reuseView
                                                       size:nil
                                                      block:validation];
    }
    return reuseView;
}

/**
 This method takes a specific size (can be nil) and runs the validation block once on one view. It returns this view so it can be used for reuse.
 */
+ (UIView *)runSingleTestWithProviderProtocol:(Class)viewProvider
                                         data:(NSDictionary *)data
                                    reuseView:(nullable UIView *)reuseView
                                         size:(nullable LYTViewSize *)size
                                        block:(void(^)(UIView *view, NSDictionary *data, id context))validation {
    id context = nil;
    UIView *view = [viewProvider viewForData:data reuseView:reuseView size:size context:&context];
    [view lyt_setSize:size];
    if ([(id)viewProvider respondsToSelector:@selector(adjustViewSize:data:size:context:)]) {
        [viewProvider adjustViewSize:view data:data size:size context:context];
    }
    [view setNeedsLayout];
    [view layoutIfNeeded];
    validation(view, data, context);
    return view;
}

#pragma mark - Iterators

/**
 This method takes a dictionary of iterators and returns the data that is currently associated with these iterators.
 */
+ (NSDictionary *)dataFromDataWithIterators:(NSDictionary *)dataWithIterators {
    NSDictionary *actualData = [dataWithIterators lyt_mutableDeepCopyWithReplaceBlock:^id(id object) {
        if ([object isKindOfClass:[LYTValuesIterator class]]) {
            LYTValuesIterator *iterator = (LYTValuesIterator *)object;
            id value = [iterator.dataValues valueAtIndex:iterator.index];
            if ([value isKindOfClass:[NSNull class]]) {
                return nil;
            } else {
                return value;
            }
        }
        return object;
    }];
    return actualData;
}

/**
 This takes an array of iterators and runs each of these iterators through all possible combinations. It's exponential in runtime with the number of iterators.
 */
+ (void)runCombinationOfIterators:(NSArray *)iterators
                     withCallback:(void(^)(NSArray *iterators))callback {
    NSMutableArray *mutableIterators = [iterators mutableCopy];
    [self runCombinationOfIterators:mutableIterators
                 completedIterators:[NSMutableArray array]
                       withCallback:callback];
}

/**
 This is the recursive helper function and should not be called directly. You should always use runCombinationOfIterators:withCallback: directly.
 */
+ (void)runCombinationOfIterators:(NSMutableArray *)iterators
               completedIterators:(NSMutableArray *)completed
                     withCallback:(void(^)(NSArray *iterators))callback {
    if ([iterators count] == 0) {
        callback(completed);
    } else {
        // Setup
        LYTValuesIterator *currentIterator = [iterators lastObject];
        [iterators removeObject:currentIterator];
        [completed addObject:currentIterator];

        NSAssert([currentIterator.dataValues numberOfValues] > 0, @"One of your LYTDataValues subclasses has no values. This will mean that no tests will be run (probably not what you intend)");

        // Run combination
        for (NSUInteger i = 0; i<[currentIterator.dataValues numberOfValues]; i++) {
            currentIterator.index = i;
            [self runCombinationOfIterators:iterators
                         completedIterators:completed
                               withCallback:callback];
        }
        // Clean up
        [completed removeObject:currentIterator];
        [iterators addObject:currentIterator];
    }
}

#pragma mark - Helpers

/**
 This returns all the view sizes to use for a specific protocol. It uses both the protocol and the config to determine this.
 */
+ (NSArray *)viewSizesForProviderProtocol:(Class)viewProvider limitResults:(LYTTesterLimitResults)limitResults {
    if (limitResults & LYTTesterLimitResultsNoSizes) {
        return nil;
    }
    NSArray *sizes = nil;
    if ([(id)viewProvider respondsToSelector:@selector(sizesForView)]) {
        sizes = [viewProvider sizesForView];
    } else {
        sizes = [LYTConfig sharedInstance].viewSizesToTest;
    }
    return sizes;
}

@end
