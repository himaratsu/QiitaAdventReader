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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
        return [_themeList count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeHeader"];
        return cell.frame.size.height;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeHeader"];
        return cell;
    }
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
    
    return nil;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // TODO: 選択されたテーマをセット
    [[QARThemeManager sharedManager] setCurrentTheme:_themeList[indexPath.row]];
    
    [self.viewDeckController closeLeftViewAnimated:YES];
}


@end
