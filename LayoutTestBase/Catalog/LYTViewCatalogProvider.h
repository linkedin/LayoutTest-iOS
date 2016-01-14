// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>
#import "LYTViewProvider.h"


NS_ASSUME_NONNULL_BEGIN

@protocol LYTViewCatalogProvider <LYTViewProvider>

/**
 This method is only needed for creating a LYTCatalog for your views and is only required if viewForData:reuseView: does not return a UITableViewCell. 
 You should add your view to a UITableViewCell and return it.

 \param data Data for the view.
 \param reuseCell Reuse cell. May be nil.
 \returns UITableViewCell with the view inside.
 */
@optional
+ (UITableViewCell *)tableViewCellForCatalogFromData:(NSDictionary *)data reuseCell:(UITableViewCell * _Nullable)reuseCell;

/**
 Specifies the height of the cells given data. You only need this if you are using the UITableViewCell catalog.

 \param data Data for the cell.
 \returns Height for the UITableViewCell.
 */
@optional
+ (CGFloat)heightForTableViewCellForCatalogFromData:(NSDictionary *)data;

/**
 Specifies the height of the cells given data. You only need this if you are using the UICollectionViewCell catalog.

 \param data Data for the cell.
 \param viewWidth The current width of the view presenting the data.
 \returns Size for the UICollectionViewCell.
 */
@optional
+ (CGSize)sizeForCollectionViewCellForCatalogFromData:(NSDictionary *)data viewWidth:(CGFloat)viewWidth;

/**
 Needed for creating a collection view catalog. This method should register either your nib or class with the collection view.

 \param collectionView The collection view you should register with.
 */
@optional
+ (void)registerClassOnCollectionView:(UICollectionView *)collectionView;

/**
 Needed for creating a table view catalog. This method should register either your nib or class with the table view.

 \param tableView The table view you should register with.
 */
@optional
+ (void)registerClassOnTableView:(UITableView *)tableView;

/**
 Reuse identifier to use on the cell.
 */
@optional
+ (NSString *)reuseIdentifier;

/**
 The property tests test a lot of different combinations. Often this is too many to contain in a catalog. Usually, given a LYTDataValues subclass 
 that outputs 1, 2 and another which outputs a, b, c you'd get the following pairs of data:

 (1, a), (2, a), (1, b), (2, b), (1, c), (2, c)

 If this method returns true, it will not do all combinations, but keep all other fields static while iterating through one field. So you'll get:

 (1, a), (2, a), (1, b), (1, c)

 In this way, we're assuming that the parameters are independent so you don't need to test every combination. In most cases, this provides wide coverage.

 \returns Whether we should limit the results for the LYTCatalog
 */
@optional
+ (BOOL)limitResultsForCatalogByAssumingDataValueIndependence;

@end

NS_ASSUME_NONNULL_END
