//
//  QARSettingViewController.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/04.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARSettingViewController.h"
#import "QARSimpleWebViewController.h"

#import "IIViewDeckController.h"

@interface QARSettingViewController ()
<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation QARSettingViewController

static NSString * const kQiitaAdventUrl = @"http://qiita.com/advent-calendar/2013";
static NSString * const kOwnerTwUrl = @"https://twitter.com/himara2";
static NSString * const kGHIssueUrl = @"https://github.com/himaratsu/QiitaAdventReader/issues";
static NSString * const kLicenseFileName = @"license.html";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
        return 3;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"一般";
    }
    else if (section == 1) {
        return @"お問い合わせ";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Qiita";
        cell.detailTextLabel.text = @"Advent Calendar 2013";
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"開発者";
            cell.detailTextLabel.text = @"@himara2";
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"お問い合わせ";
            cell.detailTextLabel.text = @"GitHub";
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = @"オープンソースライセンス";
            cell.detailTextLabel.text = @"";
        }
    }
    
    cell.detailTextLabel.textColor = [UIColor colorWithRed:41/255.0 green:128/255.0 blue:185/255.0 alpha:1.0];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kQiitaAdventUrl]];
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kOwnerTwUrl]];
        }
        else if (indexPath.row == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kGHIssueUrl]];
        }
        else if (indexPath.row == 2) {
            // show license
            [self performSegueWithIdentifier:@"showWeb" sender:nil];
        }
    }
}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showWeb"]) {
        QARSimpleWebViewController *webVC = (QARSimpleWebViewController *)segue.destinationViewController;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:kLicenseFileName ofType:nil];
        webVC.title = @"オープンソースライセンス";
        webVC.loadFilePath = filePath;
    }
}


#pragma mark -IBAction

- (IBAction)menuBtnTouched:(id)sender {
    [self.viewDeckController toggleLeftViewAnimated:YES];
}



@end
