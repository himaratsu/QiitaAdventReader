//
//  QARAppDelegate.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/04.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARAppDelegate.h"
#import "IIViewDeckController.h"
#import "QARWebViewController.h"

#import "Const.h"
#import <PocketAPI.h>
#import <Parse/Parse.h>
#import "Crittercism.h"
#import "UIAlertView+Blocks.h"

@implementation QARAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[PocketAPI sharedAPI] setConsumerKey:POCKET_API_KEY];
    [Parse setApplicationId:PARSE_API_KEY
                  clientKey:PARSE_CLIENT_KEY];
    [Crittercism enableWithAppID:CRITTERCISM_API_KEY];
    
    // push notif. setting
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    // ViewDeck用
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [self generateControllerStack];
    [self.window makeKeyAndVisible];
    
    // Appearance
    // navigation title
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0],UITextAttributeTextColor, nil]];
    
    // navigation control
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    
    // handle push notif.
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != nil) {
        // open entry
        NSDictionary *entry = userInfo[@"entry"];
        [self openUrl:entry[@"url"]];
    }
    
    // reset badge number
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    return YES;
}

- (IIViewDeckController*)generateControllerStack
{
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *menuController = [mystoryboard instantiateViewControllerWithIdentifier:@"Menu"];
    UIViewController *centerController = [mystoryboard instantiateViewControllerWithIdentifier:@"Main"];
    
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:centerController leftViewController:menuController                                                                               rightViewController:nil];
    deckController.rightSize = 90;
    deckController.openSlideAnimationDuration = 0.15;
    deckController.closeSlideAnimationDuration = 0.25;
    
    return deckController;
}


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([[PocketAPI sharedAPI] handleOpenURL:url]) {
        return YES;
    }
    else{
        // if you handle your own custom url-schemes, do it here
        return NO;
    }
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // on foreground
    if (application.applicationState == UIApplicationStateActive) {
        if ([[userInfo allKeys] containsObject:@"entry"]) {
            // open
            RIButtonItem *openItem = [RIButtonItem itemWithLabel:@"開く" action:^{
                NSDictionary *entry = userInfo[@"entry"];
                [self openUrl:entry[@"url"]];
            }];
            
            // close
            RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"キャンセル"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"お知らせ"
                                                            message:userInfo[@"aps"][@"alert"]
                                                   cancelButtonItem:cancelItem
                                                   otherButtonItems:openItem, nil];
            [alert show];
        }
    }
    // from background
    else {
        NSDictionary *entry = userInfo[@"entry"];
        [self openUrl:entry[@"url"]];
    }
    
}


- (void)openUrl:(NSString *)url {
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QARWebViewController *webVC = [mystoryboard instantiateViewControllerWithIdentifier:@"WebView"];
    webVC.loadUrl = url;
    
    IIViewDeckController *viewDeckController = (IIViewDeckController *)self.window.rootViewController;
    [((UINavigationController *)viewDeckController.centerController)
     pushViewController:webVC
     animated:YES];
}


@end
