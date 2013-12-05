//
//  QARFeedDataSource.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/05.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARFeedDataSource.h"

@interface QARFeedDataSource ()
{
    configureCell _configureCellBlock;
}

@end

@implementation QARFeedDataSource

- (id)initWithItems:(NSArray *)feeds configureCellBlock:(configureCell)configureCellBlock {
    self = [super init];
    if (self) {
        self.feeds = feeds;
        _configureCellBlock = configureCellBlock;
    }
    return self;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MAX([_feeds count], 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_feeds count] == 0) {
        NSString *cellIdentifier;
        if (_currentStatus == QAR_CONNECTION_STATUS_NORMAL) {
            cellIdentifier = @"NoEntryCell";
        }
        else if (_currentStatus == QAR_CONNECTION_STATUS_LOADING) {
            cellIdentifier = @"LoadingCell";
        }
        else if (_currentStatus == QAR_CONNECTION_STATUS_ERROR) {
            cellIdentifier = @"ErrorCell";
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        return cell;
    }

    QARListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSString *dayStr = [NSString stringWithFormat:@"%.2d", [_feeds count] - indexPath.row];
    _configureCellBlock (cell, _feeds[indexPath.row], dayStr, indexPath.row);
    
    return cell;
}


@end
