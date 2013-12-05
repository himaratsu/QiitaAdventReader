//
//  QARSettingViewController.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/04.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARSettingViewController.h"
#import "QARWebViewController.h"

@interface QARSettingViewController ()
<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation QARSettingViewController

static NSString * const kOwnerTwUrl = @"https://twitter.com/himara2";
static NSString * const kGHIssueUrl = @"https://twitter.com/himara2";
static NSString * const kLicenseFileName = @"https://twitter.com/himara2";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"開発者";
        cell.detailTextLabel.text = @"@himara2";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"お問い合わせ";
        cell.detailTextLabel.text = @"GitHub";
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"LISENCES";
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kOwnerTwUrl]];
    }
    else if (indexPath.row == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kGHIssueUrl]];
    }
    else if (indexPath.row == 2) {
        // TODO: ライセンス表記htmlを表示
        [self performSegueWithIdentifier:@"showWeb" sender:nil];
    }
}


#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showWeb"]) {
        QARWebViewController *webVC = (QARWebViewController *)segue.destinationViewController;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:kLicenseFileName ofType:nil];
        webVC.loadUrl = filePath;
        webVC.isShowToolBar = NO;
    }
}


@end
