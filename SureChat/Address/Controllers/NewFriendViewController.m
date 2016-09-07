//
//  NewFriendViewController.m
//  SureChat
//
//  Created by yangyang on 16/5/20.
//  Copyright © 2016年 杨阳. All rights reserved.
//

#import "NewFriendViewController.h"
#import "AddressTableViewCell.h"
#import "MainViewController.h"
#import "AddressTableViewController.h"
@interface NewFriendViewController ()

@property (nonatomic,strong) NSMutableArray * dataArr;

@end

@implementation NewFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArr = [[UDS objectForKey:NEW_FRIEND] mutableCopy];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"Address"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.navigationItem.title = @"新的好友";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return _dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Address" forIndexPath:indexPath];
    
    cell.label.text = _dataArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction * agree = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"同意" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //同意
        BOOL isSuc = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:_dataArr[indexPath.row] error:nil];
        if (isSuc) {
            NSString * alert = [NSString stringWithFormat:@"同意添加%@为好友",_dataArr[indexPath.row]];
            SURE_ALERT(alert);
            [_dataArr removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            [UDS setObject:_dataArr forKey:NEW_FRIEND];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"BuddyRequest" object:_dataArr];
            MainViewController * main = (MainViewController*)self.view.window.rootViewController;
            UINavigationController * addressNav = main.viewControllers[1];
            AddressTableViewController * addressVC = addressNav.viewControllers.firstObject;
            [addressVC loadAllFriendAndGroup];
        }
    }];
    UITableViewRowAction * refuse = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"拒绝" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        BOOL isSuc = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:_dataArr[indexPath.row] reason:nil error:nil];
        if (isSuc) {
            NSString * alert = [NSString stringWithFormat:@"拒绝添加%@为好友",_dataArr[indexPath.row]];
            SURE_ALERT(alert);
            [_dataArr removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            [UDS setObject:_dataArr forKey:NEW_FRIEND];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"BuddyRequest" object:_dataArr];
        }

    }];
    
    return @[refuse,agree];
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
