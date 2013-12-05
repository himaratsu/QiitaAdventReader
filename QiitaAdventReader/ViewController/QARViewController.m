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

#import "IIViewDeckController.h"
#import <AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>

@interface QARViewController ()
<UITableViewDataSource, UITableViewDelegate>
{
    UIRefreshControl *_refresh;
}

@property (nonatomic) NSMutableArray *feeds;
@property (nonatomic) NSDictionary *currentTheme;
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
        self.title = @"loading...";
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
    
    NSString *url = [NSString stringWithFormat:kApiBaseFormat, _currentTheme[@"feed_url"]];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.operationQueue cancelAllOperations];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if ([responseObject[@"responseStatus"] intValue] == 200) {
            self.feeds = responseObject[@"responseData"][@"feed"][@"entries"];
            self.title = _currentTheme[@"title"];
            
            // reload on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        }
        else {
            // TODO: エラー処理
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // TODO: エラー処理
        NSLog(@"Error: %@", error);
    }];
    
    [_refresh endRefreshing];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MAX([_feeds count], 1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
    if ([_feeds count] == 0) {
        cellIdentifier = @"LoadingCell";
    }
    else {
        cellIdentifier = @"Cell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_feeds count] == 0) {
        // 読みこみ中セルの表示
        UITableViewCell *loadCell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
        return loadCell;
    }
    
    
    NSString *dayStr = [NSString stringWithFormat:@"%.2d", [_feeds count] - indexPath.row];
    
    QARListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.titleLabel.text = _feeds[indexPath.row][@"title"];
    cell.dateLabel.text = dayStr;
    cell.authorLabel.text = _feeds[indexPath.row][@"author"];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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


@end
