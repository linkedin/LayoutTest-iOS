// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LYTMutableCopier.h"

@implementation NSDictionary (LYTMutableCopier)

- (NSDictionary *)lyt_mutableDeepCopyWithReplaceBlock:(id(^)(id object))replacementBlock {
    NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];
    for (id key in [self allKeys]) {
        id object = [self objectForKey:key];
        // Default is just to set it to the same value
        id newObject = object;
        if ([object isKindOfClass:[NSDictionary class]] ||
            [object isKindOfClass:[NSArray class]]) {
            newObject = [object lyt_mutableDeepCopyWithReplaceBlock:replacementBlock];
        } else if (replacementBlock) {
            newObject = replacementBlock(object);
        }
        if (newObject) {
            // New object can be nil. If so, we'll just leave it out.
            [newDictionary setObject:newObject forKey:key];
        }
    }
    return newDictionary;
}

@end

@implementation NSArray (LYTMutableCopier)

- (NSArray *)lyt_mutableDeepCopyWithReplaceBlock:(id(^)(id object))replacementBlock {
    NSMutableArray *newArray = [NSMutableArray array];
    for (id object in self) {
        // Default is just to set it to the same value
        id newObject = object;
        if ([object isKindOfClass:[NSDictionary class]] ||
            [object isKindOfClass:[NSArray class]]) {
            newObject = [object lyt_mutableDeepCopyWithReplaceBlock:replacementBlock];
        } else if (replacementBlock) {
            newObject = replacementBlock(object);
        }
        if (newObject) {
            // New object can be nil. If so, we'll just leave it out.
            [newArray addObject:newObject];
        }
    }
    return newArray;
}

@end
