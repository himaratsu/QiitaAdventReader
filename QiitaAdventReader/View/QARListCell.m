//
//  QARListCell.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/04.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARListCell.h"

@implementation QARListCell

- (IBAction)favBtnTouched:(id)sender {
    if ([_delegate respondsToSelector:@selector(didTapFavBtn:)]) {
        [_delegate didTapFavBtn:_index];
    }
}

@end
