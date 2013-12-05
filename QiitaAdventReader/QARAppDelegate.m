//
//  QARAppDelegate.m
//  QiitaAdventReader
//
//  Created by rhiramat on 2013/12/04.
//  Copyright (c) 2013年 Ryosuke Hiramatsu. All rights reserved.
//

#import "QARAppDelegate.h"
#import "IIViewDeckController.h"

#import "Const.h"
#import <PocketAPI.h>
#import <Parse/Parse.h>

@implementation QARAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[PocketAPI sharedAPI] setConsumerKey:POCKET_API_KEY];
    [Parse setApplicationId:PARSE_API_KEY
                  clientKey:PARSE_CLIENT_KEY];
    
    // push notif.
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    // ViewDeck用
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [self generateControllerStack];
    [self.window makeKeyAndVisible];
    
    // Appearance
    //ナビゲーションバーのタイトルの色
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0],UITextAttributeTextColor, nil]];
    

    //ナビゲーションバー内のコントロールの色
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    
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
    [PFPush handlePush:userInfo];
}


@end
