//
//  QARFeedDataSource.h
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/05.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QARListCell.h"

typedef enum QAR_CONNECTION_STATUS {
    QAR_CONNECTION_STATUS_NORMAL,
    QAR_CONNECTION_STATUS_LOADING,
    QAR_CONNECTION_STATUS_ERROR
} QAR_CONNECTION_STATUS;

typedef void (^configureCell)(QARListCell*, NSMutableDictionary*, NSString*, NSInteger);

@interface QARFeedDataSource : NSObject
<UITableViewDataSource>

@property (nonatomic) QAR_CONNECTION_STATUS currentStatus;
@property (nonatomic) NSArray *feeds;

- (id)initWithItems:(NSArray *)feeds configureCellBlock:(configureCell)configureCellBlock;


@end
