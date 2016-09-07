//
//  SettingTableViewController.m
//  SureChat
//
//  Created by yangyang on 16/5/20.
//  Copyright © 2016年 杨阳. All rights reserved.
//
#import "SettingTableViewController.h"
#import "LoginViewController.h"
@interface SettingTableViewController ()


@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createLogoutButton];
}

- (void)createLogoutButton{
    UIButton * logoutButton = [FactoryClass createButtonWithType:UIButtonTypeRoundedRect AndFrame:CGRectMake(0, 0, WIDTH, 44) AndTitle:@"切换账号" AndImageNamed:nil WithState:UIControlStateNormal AndAddTarget:self action:@selector(logOffClick:) forControlEvents:UIControlEventTouchUpInside AndParentView:self.view];
    logoutButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logoutButton.backgroundColor = [UIColor orangeColor];
    self.tableView.tableFooterView = logoutButton;
}
- (void)logOffClick:(UIButton*)button{
    [SVProgressHUD show];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            NSLog(@"退出登录");
            LoginViewController * login = [[LoginViewController alloc]init];
            self.view.window.rootViewController = login;
        }else{
            NSLog(@"%@",error);
        }
        [SVProgressHUD dismiss];
    } onQueue:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"当前用户";
        cell.detailTextLabel.text = [UDS objectForKey:USER_NAME];
    } else if (indexPath.row == 1){
        cell.textLabel.text = @"消息免打扰";
        UISwitch * mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH - 60, 6.5, 51, 31)];
        [mySwitch addTarget:self action:@selector(doNotDisturb:) forControlEvents:UIControlEventValueChanged];
        mySwitch.on = NO;
        [cell.contentView addSubview:mySwitch];
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"自动登录";
        UISwitch * mySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(WIDTH - 60, 6.5, 51, 31)];
        [mySwitch addTarget:self action:@selector(mySwitchChange:) forControlEvents:UIControlEventValueChanged];
        mySwitch.on = YES;
        [cell.contentView addSubview:mySwitch];
    } else{
        cell.textLabel.text = @"清空聊天列表";
        cell.detailTextLabel.text = @"该操作不会清空聊天记录";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 3) {
        // deleteMessage,是否删除会话中的message，YES为删除
        [[EaseMob sharedInstance].chatManager removeAllConversationsWithDeleteMessages:NO append2Chat:YES];
        SURE_ALERT(@"聊天列表已清空");
    }
}

- (void)dayAndNight:(UISwitch*)mySwitch{
    if (mySwitch.on) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DayOrNight" object:@"1"];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DayOrNight" object:@"2"];
    }
}

- (void)doNotDisturb:(UISwitch*)mySwitch{
    // 设置全天免打扰，设置后，您将收不到任何推送
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    if (mySwitch.on) {
        options.noDisturbStatus = ePushNotificationNoDisturbStatusDay;
    }else{
        options.noDisturbStatus = ePushNotificationNoDisturbStatusClose;
    }
    [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options];
}

- (void)mySwitchChange:(UISwitch*)mySwitch{
    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:mySwitch.on];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
