//
//  QARLoadingCell.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/05.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARLoadingCell.h"

@interface QARLoadingCell ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation QARLoadingCell

- (void)awakeFromNib {
    [_indicatorView startAnimating];
}

- (void)dealloc {
    [_indicatorView stopAnimating];
}

@end
