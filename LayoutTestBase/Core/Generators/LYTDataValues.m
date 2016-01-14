// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LYTDataValues.h"

@interface LYTDataValues ()

@property (nonatomic, strong) NSArray *filteredValues;

@end

@implementation LYTDataValues

- (id)init {
    return [self initWithFilter:nil];
}

- (id)initWithRequired:(BOOL)required {
    return [self initWithFilter:^BOOL(id value) {
        return (value != nil) || !required;
    }];
}

- (id)initWithValues:(NSArray *)values {
    self = [super init];
    if (self) {
        self.filteredValues = values;
    }
    return self;
}

- (id)initWithFilter:(BOOL(^)(id value))filter {
    self = [super init];
    if (self) {
        if (filter) {
            NSMutableArray *filteredValues = [NSMutableArray array];
            for (id object in self.values) {
                id reportedObject = object;
                if ([object isKindOfClass:[NSNull class]]) {
                    reportedObject = nil;
                }
                if (filter(reportedObject)) {
                    [filteredValues addObject:object];
                }
            }
            self.filteredValues = filteredValues;
        } else {
            self.filteredValues = self.values;
        }

        NSAssert([self.filteredValues count] > 0, @"After filtering the values, there must be at least one value for the LYTDataValues subclass.");
    }

    return self;
}

- (NSInteger)numberOfValues {
    return [self.filteredValues count];
}

- (id)valueAtIndex:(NSInteger)index {
    return [self.filteredValues objectAtIndex:index];
}

@end
