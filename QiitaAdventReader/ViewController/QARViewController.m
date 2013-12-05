//
//  QARViewController.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/04.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARViewController.h"
#import "QARListCell.h"
#import "QARWebViewController.h"
#import "QARThemeManager.h"
#import "QARFavManager.h"
#import "QARFeedDataSource.h"

#import "IIViewDeckController.h"
#import <AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>



@interface QARViewController ()
<UITableViewDelegate, QARListCellDelegate>
{
    UIRefreshControl *_refresh;
}

@property (nonatomic) NSMutableArray *feeds;
@property (nonatomic) NSDictionary *currentTheme;
@property (nonatomic) QARFeedDataSource *myDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation QARViewController

// convert xml -> json
static NSString * const kApiBaseFormat = @"https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=%@&num=-1";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // init propery
    self.feeds = [NSMutableArray array];
    self.currentTheme = [[QARThemeManager sharedManager] currentTheme];
    
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
    
    self.myDataSource = [[QARFeedDataSource alloc] initWithItems:_feeds
                                                          configureCellBlock:blocks];
    _myDataSource.currentStatus = QAR_CONNECTION_STATUS_NORMAL;
    self.tableView.dataSource = _myDataSource;
    
    // refresh setting
    _refresh = [[UIRefreshControl alloc] init];
    [_refresh addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refresh];
    
    // KVO
    [[QARThemeManager sharedManager] addObserver:self
                                      forKeyPath:@"currentTheme"
                                         options:NSKeyValueObservingOptionNew
                                         context:nil];
    
    [self reloadData];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentTheme"]) {
        self.currentTheme = change[@"new"];
        
        // clear feeds
        self.feeds = [NSMutableArray array];
        [_tableView reloadData];
        
        [self reloadData];
    }
}

- (void)dealloc {
    [[QARThemeManager sharedManager] removeObserver:self forKeyPath:@"currentTheme"];
}

- (void)reloadData {
    if (_currentTheme == nil) {
        return ;
    }
    
    [_refresh beginRefreshing];
    self.title = @"loading...";
    _myDataSource.currentStatus = QAR_CONNECTION_STATUS_LOADING;
    
    NSString *url = [NSString stringWithFormat:kApiBaseFormat, _currentTheme[@"feed_url"]];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.operationQueue cancelAllOperations];
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if ([responseObject[@"responseStatus"] intValue] == 200) {
            _myDataSource.currentStatus = QAR_CONNECTION_STATUS_NORMAL;
            self.feeds = responseObject[@"responseData"][@"feed"][@"entries"];
            self.title = _currentTheme[@"title"];
        }
        
        // reload on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // error
        self.title = @"Sorry.";
        _myDataSource.currentStatus = QAR_CONNECTION_STATUS_ERROR;
        
        // reload on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    }];
    
    [_refresh endRefreshing];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
    if ([_feeds count] == 0) {
        if (_myDataSource.currentStatus == QAR_CONNECTION_STATUS_NORMAL) {
            cellIdentifier = @"NoEntryCell";
        }
        else if (_myDataSource.currentStatus == QAR_CONNECTION_STATUS_LOADING) {
            cellIdentifier = @"LoadingCell";
        }
        else if (_myDataSource.currentStatus == QAR_CONNECTION_STATUS_ERROR) {
            cellIdentifier = @"ErrorCell";
        }
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


#pragma mark - QARListCellDelegate

- (void)didTapFavBtn:(NSInteger)index {
    NSDictionary *feed = _feeds[index];
    
    // fav/unfav
    [[QARFavManager sharedManager] fetchEntry:feed];
    
    [_tableView reloadData];
}


#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    QARWebViewController *webVC = (QARWebViewController *)segue.destinationViewController;
    
    QARListCell *cell = (QARListCell *)sender;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    webVC.loadUrl = _feeds[indexPath.row][@"link"];
}


#pragma mark - IBAction

- (IBAction)menuBtnTouched:(id)sender {
    [self.viewDeckController toggleLeftViewAnimated:YES];
}


#pragma mark - Getter / Setter

- (void)setFeeds:(NSMutableArray *)feeds {
    _feeds = feeds;
    _myDataSource.feeds = _feeds;
}

@end
