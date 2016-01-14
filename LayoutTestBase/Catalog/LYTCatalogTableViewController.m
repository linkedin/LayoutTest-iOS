// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LYTCatalogTableViewController.h"
// View Provider Protocol
#import "LYTViewProvider.h"
#import "LYTViewCatalogProvider.h"
// Test runner
#import "LYTLayoutPropertyTester.h"


@interface LYTCatalogTableViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation LYTCatalogTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.ViewProviderClass registerClassOnTableView:self.tableView];

    NSMutableArray *dataArray = [NSMutableArray array];

    LYTTesterLimitResults limitResults = LYTTesterLimitResultsNoSizes;
    if ([(id)self.ViewProviderClass respondsToSelector:@selector(limitResultsForCatalogByAssumingDataValueIndependence)]) {
        if ([self.ViewProviderClass limitResultsForCatalogByAssumingDataValueIndependence]) {
            limitResults &= LYTTesterLimitResultsLimitDataCombinations;
        }
    }
    [LYTLayoutPropertyTester runPropertyTestsWithViewProvider:self.ViewProviderClass
                                                     limitResults:limitResults
                                                       validation:^(UIView *view, NSDictionary *data, id context) {
                                                           [dataArray addObject:data];
                                                       }];
    self.dataArray = dataArray;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.ViewProviderClass heightForTableViewCellForCatalogFromData:self.dataArray[indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[self.ViewProviderClass reuseIdentifier] forIndexPath:indexPath];

    if ([(id)self.ViewProviderClass respondsToSelector:@selector(tableViewCellForCatalogFromData:reuseCell:)]) {
        cell = [self.ViewProviderClass tableViewCellForCatalogFromData:self.dataArray[indexPath.row] reuseCell:cell];
    } else {
        cell = (UITableViewCell *)[self.ViewProviderClass viewForData:self.dataArray[indexPath.row] reuseView:cell size:nil context:nil];
        NSAssert([cell isKindOfClass:[UITableViewCell class]], @"If your view is not a UITableViewCell, you must implement cellForCatalogFromData:reuseCell:");
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
