// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LYTViewSize.h"


@interface LYTViewSize ()

@property (nonatomic, strong, nullable) NSNumber *width;
@property (nonatomic, strong, nullable) NSNumber *height;

@end

@implementation LYTViewSize

- (id)initWithWidth:(NSNumber *)width height:(NSNumber *)height {
    self = [super init];
    self.width = width;
    self.height = height;
    return self;
}

- (instancetype)initWithWidth:(NSNumber *)width {
    return [self initWithWidth:width height:nil];
}

- (instancetype)initWithHeight:(NSNumber *)height {
    return [self initWithWidth:nil height:height];
}

@end
