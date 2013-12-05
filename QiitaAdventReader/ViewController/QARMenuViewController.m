//
//  QARMenuViewController.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/04.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARMenuViewController.h"
#import "QARSettingViewController.h"
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
        return 2;
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
    if (indexPath.section == 0 || indexPath.section == 1) {
        cellIdentifier = @"Cell";
    }
    else if (indexPath.section == 2) {
        cellIdentifier = @"GoTopCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"設定";
        }
        else if (indexPath.row == 1){
            cell.textLabel.text = @"お気に入り";
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
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
        NSString *storyboardId;
        if (indexPath.row == 0) {
            storyboardId = @"Setting";
        }
        else if (indexPath.row == 1) {
            storyboardId = @"Fav";
        }
        // show target viewcontroller
        UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *targetViewController = [mystoryboard instantiateViewControllerWithIdentifier:storyboardId];
        self.viewDeckController.centerController = targetViewController;
        [self.viewDeckController closeLeftViewAnimated:YES];
    }
    else if (indexPath.section == 1) {
        // set selected theme
        [[QARThemeManager sharedManager] setCurrentTheme:_themeList[indexPath.row]];
        
        UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *mainViewController = [mystoryboard instantiateViewControllerWithIdentifier:@"Main"];
        
        self.viewDeckController.centerController = mainViewController;
        [self.viewDeckController closeLeftViewAnimated:YES];
    }
    else if (indexPath.section == 2) {
        // go to top
        [_tableView scrollRectToVisible:CGRectMake(0, 0, 10, 10) animated:YES];
    }
}


@end
