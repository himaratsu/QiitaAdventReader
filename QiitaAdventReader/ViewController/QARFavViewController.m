//
//  QARFavViewController.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/05.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARFavViewController.h"
#import "QARFavManager.h"
#import "QARListCell.h"
#import "QARFeedDataSource.h"
#import "QARWebViewController.h"

#import "IIViewDeckController.h"

@interface QARFavViewController ()
<UITableViewDelegate, QARListCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *favList;
@property (nonatomic) QARFeedDataSource *myDataSource;

@end

@implementation QARFavViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set table data source
    configureCell blocks = ^(QARListCell *cell, NSDictionary *dict, NSString *dayStr, NSInteger indexRow) {
        cell.titleLabel.text = dict[@"title"];
        cell.dateLabel.text = dayStr;
        cell.authorLabel.text = dict[@"author"];
        cell.index = indexRow;
        cell.delegate = self;
        
        if ([[QARFavManager sharedManager] isFavEntry:dict]) {
            cell.favButton.selected = YES;
        }
        else {
            cell.favButton.selected = NO;
        }
    };
    
    self.favList = [[QARFavManager sharedManager] favList];
    self.myDataSource = [[QARFeedDataSource alloc] initWithItems:_favList
                                              configureCellBlock:blocks];
    _myDataSource.currentStatus = QAR_CONNECTION_STATUS_NORMAL;
    self.tableView.dataSource = _myDataSource;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData {
    self.favList = [[QARFavManager sharedManager] favList];
    
    [_tableView reloadData];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
    if ([_favList count] == 0) {
        cellIdentifier = @"NoEntryCell";
    }
    else {
        cellIdentifier = @"Cell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    QARWebViewController *webVC = (QARWebViewController *)segue.destinationViewController;
    
    QARListCell *cell = (QARListCell *)sender;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    webVC.loadUrl = _favList[indexPath.row][@"link"];
}


#pragma mark - QARListCellDelegate

- (void)didTapFavBtn:(NSInteger)index {
    NSDictionary *feed = _favList[index];
    
    // fav/unfav
    [[QARFavManager sharedManager] fetchEntry:feed];
    
    [_tableView reloadData];
}


#pragma mark - IBAction

- (IBAction)menuBtnTouched:(id)sender {
    [self.viewDeckController toggleLeftViewAnimated:YES];
}


#pragma mark - Getter / Setter

- (void)setFavList:(NSMutableArray *)favList {
    _favList = favList;
    _myDataSource.feeds = _favList;
}



@end
