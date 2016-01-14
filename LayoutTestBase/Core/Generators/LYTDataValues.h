// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

/**
 This is the base class for all LYTDataValues subclasses used by the testing library. You can use these LYTDataValues subclasses as values in the 
 dictionary returned by (NSDictionary *)dataSpecForTest and it will be converted into many different specific values by the library. There are three 
 main ways you can use this class:

 - Use one of the built in LYTDataValues subclasses (LYTStringValues, LYTFloatValues, etc.)
 - Create a one time use object with - (id)initWithValues:(NSArray *)values;
 - Create your own subclasses

 To create your own subclass, the only method you need to override is the - (NSArray *)values. Simple return all the values you want the LYTDataValues 
 subclass to return.

 NSNull

 If you put NSNull into the values array, it will be converted to nil (as in, remove the key from the final JSON).
 */
@interface LYTDataValues : NSObject

/**
 Returns all the possible replacement values for this LYTDataValues class. This is the only method you should override when subclassing.
 
 \warning You should not use this to access the values that the generator represents. You should only use this for subclassing.
 */
@property (nonatomic, readonly) NSArray *values;

/**
 Returns LYTDataValues with all values.
 */
- (id)init;

/**
 Returns LYTDataValues with all values except nil. Use this for required fields.
 */
- (id)initWithRequired:(BOOL)required;

/**
 Returns LYTDataValues with these specific values and overrides any subclass's behavior.
 */
- (id)initWithValues:(NSArray *)values;

/**
 Returns LYTDataValues with all the values that return true from the filter block.
 */
- (id)initWithFilter:(BOOL(^ _Nullable)(id value))filter;

/**
 Returns the number of values this object contains.
 */
- (NSInteger)numberOfValues;

/**
 Returns a value for a certain index. If out of range, it will throw and exception.
 */
- (id)valueAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
