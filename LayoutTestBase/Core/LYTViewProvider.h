// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <UIKit/UIKit.h>


@class LYTViewSize;

NS_ASSUME_NONNULL_BEGIN

@protocol LYTViewProvider <NSObject>

#pragma mark - Main Methods

/**
 This is the template for the dictionary that will be passed to the viewForData:reuseView: method. You can insert LYTDataValues subclasses as values in this dictionary for generating different combinations of data. For example, the dictionary:

 @{ @"key": [[LYTStringValues alloc] init] }

 Will produce a bunch of dictionaries:

 @{ @"key": @"Normal length string" },
 @{ @"key": @"" },
 @{ }, etc.

 \returns Template for the data to test on.
 */
@required
+ (NSDictionary *)dataSpecForTest;

/**
 This method should return a view to run your tests on. You should always use the reuse view if you can, and if not, should recreate a view with the same size as the reuseView. You should then inflate the view with your data and return it.

 You may optionally set some context. This can be anything and will be passed back to you in the completion block of the test. You should first check that context is not nil before trying to set it.

 \param data Data to inflate int the view. This data will not contain any LYTDataValues subclasses. It is nonoptional and will never be nil.
 \param view Reuse view to reinflate with new data. It may be nil.
 \param context You can set this to anything and it will be returned to you in the completion block of the test. Could be nil.
 \returns View inflated with data
 */
@required
+ (UIView *)viewForData:(NSDictionary *)data reuseView:(nullable UIView *)reuseView size:(nullable LYTViewSize *)size context:(id _Nullable * _Nullable)context;

/**
 Returns an array of NSValue objects which wrap a CGSize struct. These are all the sizes that we should test on. The way this works is a little tricky though. It will return a reuse view of this specific size to viewForData:reuseView:. So if that method resizes the view or recreates the view, then this data will be lost.

 The data will first be tested on the 'default size' of the view or whatever is returned by viewForData:, then iterate through each of these sizes. First it will resize the view, then pass it to viewForData:reuseView:

 \returns NSArray of NSValues which encapsulate an CGSize
 */
@optional
+ (NSArray<LYTViewSize *> *)sizesForView;

/**
 This is called after viewForData:reuseView:size:context: and after the view has been resized using the sizes provided. This gives you the opportunity to make any final changes to the view based on the size of the view before any assertions are made.
 
 For example, if you use multiple different widths to test your view, you may want to adjust the height in this method.
 
 \param view The view which we are about to test. This is already setup with data.
 \param data The data used to layout the view.
 \param size This size used to resize the view. This size has already been applied.
 \param context If a context was set in viewForData:reuseView:size:context:, it will be passed back to you here.
 */
@optional
+ (void)adjustViewSize:(UIView *)view data:(NSDictionary *)data size:(nullable LYTViewSize *)size context:(nullable id)context;

@end

NS_ASSUME_NONNULL_END
