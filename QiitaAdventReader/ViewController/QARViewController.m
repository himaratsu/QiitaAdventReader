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

@property (nonatomic) NSMutableArray *feeds;
@property (nonatomic) NSDictionary *currentTheme;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation QARViewController

// convert xml -> json
static NSString * const kApiBaseFormat = @"https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=%@&num=25";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.feeds = [NSMutableArray array];
    
    // KVO
    [[QARThemeManager sharedManager] addObserver:self
                                      forKeyPath:@"currentTheme"
                                         options:NSKeyValueObservingOptionNew
                                         context:nil];
    
    self.currentTheme = [[QARThemeManager sharedManager] currentTheme];
    
    [self reloadData];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentTheme"]) {
        self.currentTheme = change[@"new"];
        [self reloadData];
    }
}

- (void)reloadData {
    if (_currentTheme == nil) {
        return ;
    }
    NSString *url = [NSString stringWithFormat:kApiBaseFormat, _currentTheme[@"feed_url"]];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.feeds = responseObject[@"responseData"][@"feed"][@"entries"];
        
        self.title = _currentTheme[@"title"];
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QARListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.titleLabel.text = _feeds[indexPath.row][@"title"];
    cell.dateLabel.text = [NSString stringWithFormat:@"%d", [_feeds count] - indexPath.row];
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
