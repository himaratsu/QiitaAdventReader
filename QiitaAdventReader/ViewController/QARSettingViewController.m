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
#import <Parse/Parse.h>

@interface QARSettingViewController ()
<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation QARSettingViewController

static NSString * const kQiitaAdventUrl = @"http://qiita.com/advent-calendar/2013";
static NSString * const kAppStoreUrl = @"itms-apps://itunes.apple.com/jp/app/id775411001";
static NSString * const kGHIssueUrl = @"https://github.com/himaratsu/QiitaAdventReader/issues";
static NSString * const kLicenseFileName = @"license.html";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 1;
    }
    else if (section == 2){
        return 4;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"設定";
    }
    else if (section == 1) {
        return @"PC版";
    }
    else if (section == 2) {
        return @"このアプリについて";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UILabel *mymNoticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        mymNoticeLabel.text = @"ON なのに通知を受け取れない場合、\n設定 > 通知センター を確認してください";
        mymNoticeLabel.textAlignment = NSTextAlignmentCenter;
        mymNoticeLabel.numberOfLines = 0;
        mymNoticeLabel.textColor = [UIColor lightGrayColor];
        mymNoticeLabel.font = [UIFont systemFontOfSize:13.0];
        return mymNoticeLabel;
    }
    
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.detailTextLabel.textColor = [UIColor colorWithRed:41/255.0 green:128/255.0 blue:185/255.0 alpha:1.0];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"通知を受け取る";
        cell.detailTextLabel.text = @"";
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *pushStatus = [defaults objectForKey:@"PushSetting"];
        UISwitch *sw = [[UISwitch alloc] init];
        sw.on = [pushStatus boolValue];
        [sw addTarget:self action:@selector(pushSettingChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
    }
    else if (indexPath.section == 1) {
        cell.textLabel.text = @"Qiita";
        cell.detailTextLabel.text = @"Advent Calendar 2013";
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"バージョン";
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            cell.detailTextLabel.text = version;
            cell.detailTextLabel.textColor = [UIColor grayColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if (indexPath.row == 1) {
            cell.textLabel.text = @"レビューを書く";
            cell.detailTextLabel.text = @"AppStore";
        }
        else if (indexPath.row == 2) {
            cell.textLabel.text = @"お問い合わせ";
            cell.detailTextLabel.text = @"GitHub";
        }
        else if (indexPath.row == 3) {
            cell.textLabel.text = @"オープンソースライセンス";
            cell.detailTextLabel.text = @"";
        }
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewDeckController closeLeftView];
    
    if (indexPath.section == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kQiitaAdventUrl]];
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreUrl]];
        }
        else if (indexPath.row == 2) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kGHIssueUrl]];
        }
        else if (indexPath.row == 3) {
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

- (void)pushSettingChanged:(UISwitch *)sender {
    NSString *pushStatus = [NSString stringWithFormat:@"%d", sender.on];
    
    // set push setting
    PFInstallation *installation = [PFInstallation currentInstallation];
    [installation setObject:pushStatus forKey:@"Accept"];
    [installation saveInBackground];
    
    // save
    [[NSUserDefaults standardUserDefaults] setObject:pushStatus forKey:@"PushSetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // alert
    NSString *pushStatusStr = [pushStatus boolValue] ? @"ON" : @"OFF";
    
    [[[UIAlertView alloc] initWithTitle:@"設定変更"
                                message:[NSString stringWithFormat:@"通知設定を %@ にしました",
                                         pushStatusStr]
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil]
     show];;
}

@end
