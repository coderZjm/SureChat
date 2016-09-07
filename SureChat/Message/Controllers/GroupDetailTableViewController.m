//
//  GroupDetailTableViewController.m
//  SureChat
//
//  Created by yangyang on 16/5/20.
//  Copyright © 2016年 杨阳. All rights reserved.
//

#import "GroupDetailTableViewController.h"
#import "MainViewController.h"
#import "MessageTableViewController.h"
#import "AddressTableViewController.h"
#import "GroupDetailModel.h"
#import "AddGroupMemberViewController.h"
@interface GroupDetailTableViewController ()

@property (nonatomic,strong) NSMutableArray * dataArr;

@property (nonatomic,strong) NSMutableArray * friendArr;

@end

@implementation GroupDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initdData];
    [self createUI];
}

- (void)initdData{
    //群详情
    [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:_groupID completion:^(EMGroup *group, EMError *error) {
        _dataArr = [[NSMutableArray alloc]init];
        GroupDetailModel * model = [[GroupDetailModel alloc]init];
        model.owner = group.owner;
        model.groupOnlineOccupantsCount = group.groupOnlineOccupantsCount;
        [_dataArr addObject:model];
        [self.tableView reloadData];
    } onQueue:nil];
    
    [[EaseMob sharedInstance].chatManager asyncFetchOccupantList:_groupID completion:^(NSArray *occupantsList, EMError *error) {
        _friendArr = [[NSMutableArray alloc]init];
        [_friendArr addObjectsFromArray:occupantsList];
        [self.tableView reloadData];
    } onQueue:nil];
}

- (void)createUI{
    self.navigationItem.title = @"群详情";
    UIButton * signOutButton = [FactoryClass createButtonWithType:UIButtonTypeRoundedRect AndFrame:CGRectMake(0, 0, WIDTH, 44) AndTitle:@"退出群组" AndImageNamed:nil WithState:UIControlStateNormal AndAddTarget:self action:@selector(signOutClick:) forControlEvents:UIControlEventTouchUpInside AndParentView:self.view];
    signOutButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [signOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signOutButton.backgroundColor = [UIColor orangeColor];
    self.tableView.tableFooterView = signOutButton;
    
    UIBarButtonItem * addItem = [[UIBarButtonItem alloc]initWithTitle:@"添加成员" style:UIBarButtonItemStylePlain target:self action:@selector(addItemClick:)];
    self.navigationItem.rightBarButtonItem = addItem;
}

- (void)addItemClick:(UIBarButtonItem*)item{
    AddGroupMemberViewController * addGroupMember = [[AddGroupMemberViewController alloc]init];
    addGroupMember.groupID = _groupID;
    [self.navigationController pushViewController:addGroupMember animated:YES];
}

- (void)signOutClick:(UIButton*)button{
    [[EaseMob sharedInstance].chatManager asyncLeaveGroup:_groupID
                                               completion:
     ^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
         if (!error) {
             [self.navigationController popToRootViewControllerAnimated:YES];
             MainViewController * main = (MainViewController*)self.view.window.rootViewController;
             UINavigationController * messageNav = main.viewControllers.firstObject;
             MessageTableViewController * messageVC = messageNav.viewControllers.firstObject;
             [messageVC loadAllConversations];
             UINavigationController * addressNav = main.viewControllers[1];
             AddressTableViewController * addressVC = addressNav.viewControllers.firstObject;
             [addressVC loadAllFriendAndGroup];
             SURE_ALERT(@"退出成功");
         }else{
             NSString * alert = [NSString stringWithFormat:@"%@",error];
             SURE_ALERT(alert);
         }
     } onQueue:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _dataArr.count;
    }else{
        return _friendArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    if (indexPath.section == 0) {
        GroupDetailModel * model = _dataArr[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"群主:%@",model.owner];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"在线人数:%ld",model.groupOnlineOccupantsCount];
    }else{
        cell.textLabel.text = _friendArr[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray * titleArr = @[@"群详情",@"群成员"];
    return titleArr[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
