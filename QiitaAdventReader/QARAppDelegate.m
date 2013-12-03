//
//  QARAppDelegate.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/04.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARAppDelegate.h"
#import "IIViewDeckController.h"

@implementation QARAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // ViewDeck用
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [self generateControllerStack];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (IIViewDeckController*)generateControllerStack
{
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *menuController = [mystoryboard instantiateViewControllerWithIdentifier:@"Menu"];
    UIViewController *centerController = [mystoryboard instantiateViewControllerWithIdentifier:@"Main"];
    
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:centerController leftViewController:menuController                                                                               rightViewController:nil];
    deckController.rightSize = 100;
    
//    [deckController disablePanOverViewsOfClass:NSClassFromString(@"_UITableViewHeaderFooterContentView")];
    return deckController;
}


@end
