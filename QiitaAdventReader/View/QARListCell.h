//
//  QARListCell.h
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/04.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QARListCellDelegate <NSObject>

- (void)didTapFavBtn:(NSInteger)index;

@end

@interface QARListCell : UITableViewCell

@property (nonatomic) NSInteger index;
@property (nonatomic, assign) id<QARListCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIButton *favButton;

@end
