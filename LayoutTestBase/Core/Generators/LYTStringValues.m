// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LYTStringValues.h"

@implementation LYTStringValues

- (NSArray *)values {
    return @[
             @"Normal length string",
             @"",
             [NSNull null],
             @"Very long string. This string is so long that it's longer than I want it to be. Just a really really long string. In fact, it's just long as long can be. I'm just lengthening the longest string by making it longer with more characters. Do you think this is long enough yet? I think so, so I'm going to stop making this long string longer by adding more characters.",
             @"漢語 ♔ 🚂 ☎ ‰ 🚀 Here are some more special characters ˆ™£‡‹·Ú‹›`å∑œ´®∆ƒ∆√˜Ω≥µ˜ƒª•"
             ];
}

@end
