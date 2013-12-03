//
//  QARListCell.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/04.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARListCell.h"

@implementation QARListCell

- (void)awakeFromNib {
    _todayLabel.layer.cornerRadius = 2.0f;
    _todayLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsToday:(BOOL)isToday {
    _isToday = isToday;
    
    if (_isToday) {
        _todayLabel.hidden = NO;
        _dateLabel.textColor = [UIColor orangeColor];
    }
    else {
        _todayLabel.hidden = YES;
        _dateLabel.textColor = [UIColor lightGrayColor];
    }
}

@end
