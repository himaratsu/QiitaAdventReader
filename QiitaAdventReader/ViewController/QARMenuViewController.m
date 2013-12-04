//
//  QARMenuViewController.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/04.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARMenuViewController.h"
#import "QARThemeManager.h"
#import "IIViewDeckController.h"

@interface QARMenuViewController ()
<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray *themeList;

@end

@implementation QARMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self reloadData];
}

- (void)reloadData {
    self.themeList = [[QARThemeManager sharedManager] themeList];
    [_tableView reloadData];
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
        return [_themeList count];
    }
    else if (section == 2) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeHeader"];
        return cell.frame.size.height;

    }
    else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeHeader"];
        return cell;
    }
    else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
    if (indexPath.section == 0) {
        cellIdentifier = @"SettingCell";
    }
    else if (indexPath.section == 1) {
        cellIdentifier = @"ThemeCell";
    }
    else if (indexPath.section == 2) {
        cellIdentifier = @"GoTopCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
        return cell;
    }
    else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeCell"];
        cell.textLabel.text = _themeList[indexPath.row][@"title"];
        return cell;
    }
    else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoTopCell"];
        return cell;
    }
    
    return nil;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        // TODO: 設定画面へ
        [self.viewDeckController closeLeftViewAnimated:YES];
    }
    else if (indexPath.section == 1) {
        // set selected theme
        [[QARThemeManager sharedManager] setCurrentTheme:_themeList[indexPath.row]];
        [self.viewDeckController closeLeftViewAnimated:YES];
    }
    else if (indexPath.section == 2) {
        // go to top
        [_tableView scrollRectToVisible:CGRectMake(0, 0, 10, 10) animated:YES];
    }
}


@end
