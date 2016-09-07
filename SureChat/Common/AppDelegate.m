//
//  AppDelegate.m
//  SureChat
//
//  Created by yangyang on 16/4/5.
//  Copyright © 2016年 杨阳. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "MessageTableViewController.h"
#import "AddressTableViewController.h"
@interface AppDelegate ()<EMChatManagerDelegate>

@property (nonatomic,strong) NSMutableArray * buddyArr;
@property (nonatomic,strong) UIView * bgView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"sure#sure" apnsCertName:@"SureChat" otherConfig:@{kSDKConfigEnableConsoleLogger:@NO}];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    if ([[EaseMob sharedInstance].chatManager isAutoLoginEnabled]) {
        MainViewController * main = [[MainViewController alloc]init];
        self.window.rootViewController = main;
    }else{
        self.window.rootViewController = [[LoginViewController alloc]init];
    }
    _buddyArr = [[NSMutableArray alloc]init];
    
    [[UINavigationBar appearance]setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearance]setBarTintColor:[UIColor orangeColor]];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    [self.window makeKeyAndVisible];
    return YES;
}
// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    NSLog(@"error -- %@",error);
}

- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message{
    [_buddyArr addObject:username];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"BuddyRequest" object:_buddyArr];
    [UDS setObject:_buddyArr forKey:NEW_FRIEND];
    [UDS synchronize];
}

- (void)didReceiveMessage:(EMMessage *)message{
    MainViewController * main = (MainViewController*)self.window.rootViewController;
    UINavigationController * messageNav = main.viewControllers.firstObject;
    MessageTableViewController * messageVC = messageNav.viewControllers.firstObject;
    [messageVC loadAllConversations];
}

- (void)didAcceptedByBuddy:(NSString *)username{
    NSString * alert = [NSString stringWithFormat:@"%@同意了你的好友请求，快去和她(他)聊天吧",username];
    SURE_ALERT(alert);
    MainViewController * main = (MainViewController*)self.window.rootViewController;
    UINavigationController * addressNav = main.viewControllers[1];
    AddressTableViewController * addressVC = addressNav.viewControllers.firstObject;
    [addressVC loadAllFriendAndGroup];
}

- (void)didRejectedByBuddy:(NSString *)username{
    NSString * alert = [NSString stringWithFormat:@"%@拒绝了你的好友请求",username];
    SURE_ALERT(alert);
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages{
    MainViewController * main = (MainViewController*)self.window.rootViewController;
    UINavigationController * messageNav = main.viewControllers.firstObject;
    MessageTableViewController * messageVC = messageNav.viewControllers.firstObject;
    [messageVC loadAllConversations];
}

- (void)didLoginFromOtherDevice{
    SURE_ALERT(@"您的账号在其它设备登录");
}

- (void)willAutoReconnect{
    
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    
}

- (void)didAcceptInvitationFromGroup:(EMGroup *)group error:(EMError *)error{
    if (!error) {
        NSLog(@"进群成功");
    }
}

- (void)groupDidUpdateInfo:(EMGroup *)group error:(EMError *)error{
    if (!error) {
        NSLog(@"更新群组信息");
        MainViewController * main = (MainViewController*)self.window.rootViewController;
        UINavigationController * addressNav = main.viewControllers[1];
        AddressTableViewController * addressVC = addressNav.viewControllers.firstObject;
        [addressVC loadAllFriendAndGroup];

    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
