//
//  AddressTableViewController.m
//  HXChatProj
//
//  Created by yangyang on 16/3/1.
//  Copyright © 2016年 杨阳. All rights reserved.
//

#import "AddressTableViewController.h"
#import "ChatViewController.h"
#import "AddFriendViewController.h"
#import "AddressTableViewCell.h"
#import "NewFriendViewController.h"
#import "CreateGroupViewController.h"
@interface AddressTableViewController ()

@property (nonatomic,strong) NSMutableArray * friendArr;

@property (nonatomic,strong) NSMutableArray * groupArr;

@property (nonatomic,strong) NSMutableArray * groupIDArr;

@end

@implementation AddressTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self createUI];
    [self loadAllFriendAndGroup];
}

- (void)loadAllFriendAndGroup{
    //获取真实好友列表
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        [_friendArr removeAllObjects];
        for (EMBuddy * buddy in buddyList) {
            [_friendArr addObject:buddy.username];
            [self.tableView reloadData];
        }
        
    } onQueue:nil];
    
    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
        [_groupArr removeAllObjects];
        for (EMGroup * group in groups) {
            [_groupArr addObject:group.groupSubject];
            [_groupIDArr addObject:group.groupId];
            [UDS setObject:group.groupSubject forKey:group.groupId];
            [UDS synchronize];
            //获取群成员
            //            [[EaseMob sharedInstance].chatManager asyncFetchOccupantList:group.groupId completion:^(NSArray *occupantsList, EMError *error) {
            //            } onQueue:nil];
        }
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } onQueue:nil];
}

- (void)initData{
    //初始化
    _friendArr = [[NSMutableArray alloc]init];
    _groupArr = [[NSMutableArray alloc]init];
    _groupIDArr = [[NSMutableArray alloc]init];
}

- (void)createUI{
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"Address"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    //添加好友按钮
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend:)];
    self.navigationItem.rightBarButtonItem = item;
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = [UIColor orangeColor];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
}
- (void)refresh:(UIRefreshControl*)control{
    [self loadAllFriendAndGroup];
}

- (void)addFriend:(UIBarButtonItem*)item{
    AddFriendViewController * add = [[AddFriendViewController alloc]init];
    add.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:add animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return _groupArr.count;
    }else{
        return _friendArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Address" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.label.text = @"新的好友";
            cell.iconImageView.image = [UIImage imageNamed:@"plugins_FriendNotify~iphone"];
        }else{
            cell.label.text = @"群聊";
            cell.iconImageView.image = [UIImage imageNamed:@"add_friend_icon_addgroup~iphone"];
        }
    }else if (indexPath.section == 1){
        cell.label.text = _groupArr[indexPath.row];
        cell.iconImageView.image = [UIImage imageNamed:@"watch-tips-avatar~iphone"];
    }else{
        cell.label.text = _friendArr[indexPath.row];
        cell.iconImageView.image = [UIImage imageNamed:@"watch-tips-avatar2"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NewFriendViewController * newFriend = [[NewFriendViewController alloc]init];
            newFriend.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newFriend animated:YES];
        }else{
            CreateGroupViewController * group = [[CreateGroupViewController alloc]init];
            group.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:group animated:YES];
        }
    }else if (indexPath.section == 1){
        ChatViewController * chat = [[ChatViewController alloc]init];
        chat.groupID = _groupIDArr[indexPath.row];
        chat.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chat animated:YES];
    }else{
        ChatViewController * chat = [[ChatViewController alloc]init];
        chat.friendname = _friendArr[indexPath.row];
        chat.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chat animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray * titleArr = @[@"常用功能",@"群组",@"好友"];
    return titleArr[section];
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        UITableViewRowAction * action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"解散群组" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            [[EaseMob sharedInstance].chatManager asyncDestroyGroup:_groupIDArr[indexPath.row] completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
                if (!error) {
                    SURE_ALERT(@"解散成功");
                    [self loadAllFriendAndGroup];
                }else{
                    NSString * alert = [NSString stringWithFormat:@"%@",error];
                    SURE_ALERT(alert);
                }
            } onQueue:nil];
        }];
        return @[action];
    }
    if (indexPath.section == 2) {
        UITableViewRowAction * action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除好友" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            EMError *error = nil;
            // 删除好友
            BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeBuddy:_friendArr[indexPath.row] removeFromRemote:YES error:&error];
            if (isSuccess && !error) {
                SURE_ALERT(@"删除成功");
                [self loadAllFriendAndGroup];
            }
        }];
        return @[action];
    }
    return @[];
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
