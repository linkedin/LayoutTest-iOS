// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LYTCatalogCollectionViewController.h"
// View Provider Protocol
#import "LYTViewProvider.h"
#import "LYTViewCatalogProvider.h"
// Test runner
#import "LYTLayoutPropertyTester.h"


@interface LYTCatalogCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation LYTCatalogCollectionViewController

- (instancetype)init {
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    self = [super initWithCollectionViewLayout:flowLayout];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    Class<LYTViewCatalogProvider> viewProviderClass = self.ViewProviderClass;
    if (!viewProviderClass) {
        NSAssert(NO, @"No ViewProviderClass set");
        return;
    }

    [viewProviderClass registerClassOnCollectionView:self.collectionView];

    NSMutableArray *dataArray = [NSMutableArray array];

    LYTTesterLimitResults limitResults = LYTTesterLimitResultsNoSizes;
    if ([viewProviderClass respondsToSelector:@selector(limitResultsForCatalogByAssumingDataValueIndependence)]) {
        if ([viewProviderClass limitResultsForCatalogByAssumingDataValueIndependence]) {
            limitResults &= LYTTesterLimitResultsLimitDataCombinations;
        }
    }
    [LYTLayoutPropertyTester runPropertyTestsWithViewProvider:viewProviderClass
                                                 limitResults:limitResults
                                                   validation:^(__unused UIView *view, NSDictionary *data, __unused id context) {
                                                       [dataArray addObject:data];
                                                   }];
    self.dataArray = dataArray;
}

#pragma mark - Table view data source

- (CGSize)collectionView:(__unused UICollectionView *)collectionView
                  layout:(__unused UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.ViewProviderClass sizeForCollectionViewCellForCatalogFromData:self.dataArray[(NSUInteger)indexPath.row] viewWidth:self.view.frame.size.width];
}

- (NSInteger)collectionView:(__unused UICollectionView *)collectionView
     numberOfItemsInSection:(__unused NSInteger)section {
    return (NSInteger)self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(__unused UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:[self.ViewProviderClass reuseIdentifier] forIndexPath:indexPath];

    id context = nil;
    cell = (UICollectionViewCell *)[self.ViewProviderClass viewForData:self.dataArray[(NSUInteger)indexPath.row] reuseView:cell size:nil context:&context];
    
    return cell;
}

@end
