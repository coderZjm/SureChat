//
//  MainViewController.m
//  HXChatProj
//
//  Created by yangyang on 16/5/20.
//  Copyright © 2016年 杨阳. All rights reserved.
//

#import "MainViewController.h"
#import "MessageTableViewController.h"
#import "AddressTableViewController.h"
#import "SettingTableViewController.h"
@interface MainViewController ()
@property (nonatomic,strong) MessageTableViewController * message;
@property (nonatomic,strong) AddressTableViewController * address;
@property (nonatomic,strong) SettingTableViewController * settings;
@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buddyRequestNoti:) name:@"BuddyRequest" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(allNoReadMessageNoti:) name:@"ALLNOREAD" object:nil];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}

- (void)allNoReadMessageNoti:(NSNotification*)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumber * number = noti.object;
        UITabBarItem * item = [self.tabBar.items objectAtIndex:0];
        if (![number isEqualToNumber:@0]) {
            item.badgeValue = [NSString stringWithFormat:@"%ld",[number integerValue]];
        }else{
            item.badgeValue = nil;
        }
    });
}

- (void)buddyRequestNoti:(NSNotification*)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray * arr = (NSArray*)noti.object;
        UITabBarItem * item = [self.tabBar.items objectAtIndex:1];
        if (arr.count != 0) {
            item.badgeValue = [NSString stringWithFormat:@"%ld",arr.count];
        }else{
            item.badgeValue = nil;
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTabBar];
    [self createRemoteNoti];
    // Do any additional setup after loading the view.
}

- (void)createTabBar{
    [self.tabBar setShadowImage:[UIImage new]];
    _message = [[MessageTableViewController alloc]init];
    _address = [[AddressTableViewController alloc]init];
    _settings = [[SettingTableViewController alloc]init];
    NSMutableArray * array = [NSMutableArray arrayWithObjects:_message,_address,_settings, nil];
    NSArray * normalArr = @[@"global_btn_bottom_play~iphone",@"global_btn_bottom_friend~iphone",@"global_btn_bottom_my~iphone"];
    NSArray * selectedArr = @[@"global_btn_bottom_play_press~iphone",@"global_btn_bottom_friend_press~iphone",@"global_btn_bottom_my_press~iphone"];
    NSArray * titleArr = @[@"消息",@"通讯录",@"我"];
    for (int i = 0; i < array.count; i++) {
        UIViewController * vc = array[i];
        UINavigationController * nc = [[UINavigationController alloc]initWithRootViewController:vc];
        vc.title = titleArr[i];
        [array replaceObjectAtIndex:i withObject:nc];
        UIImage* image = [UIImage imageNamed:normalArr[i]];
        UIImage* selectImage = [UIImage imageNamed:selectedArr[i]];
        nc.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nc.tabBarItem.selectedImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [nc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:255 / 255.0 green:75 / 255.0 blue:70 / 255.0 alpha:1]} forState:UIControlStateSelected];
    }
    self.viewControllers = array;
}
- (void)createRemoteNoti{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    options.displayStyle = ePushNotificationDisplayStyle_messageSummary;
    [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options completion:^(EMPushNotificationOptions *options, EMError *error) {
        if (!error) {
            
        }
    } onQueue:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
