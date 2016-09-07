//
//  MessageTableViewController.m
//  HXChatProj
//
//  Created by yangyang on 16/5/20.
//  Copyright © 2016年 杨阳. All rights reserved.
//

#import "MessageTableViewController.h"
#import "ChatViewController.h"
#import "MessageTableViewCell.h"
#import "MessageModel.h"
@interface MessageTableViewController ()

@property (nonatomic,strong) NSMutableArray * dataArr;

@property (nonatomic,assign) NSInteger allNoReadMessageNum;

@end

@implementation MessageTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadAllConversations];
}

- (void)loadAllConversations{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _allNoReadMessageNum = 0;
        [_dataArr removeAllObjects];
        NSArray * conversationArr = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
        for (EMConversation * conversation in conversationArr) {
            MessageModel * model = [[MessageModel alloc]init];
            if (conversation.conversationType == eConversationTypeGroupChat) {
                model.groupID = conversation.chatter;
            }else{
                model.friendName = conversation.chatter;
            }
            EMMessage * message = conversation.latestMessage;
            id <IEMMessageBody> body = message.messageBodies.firstObject;
            NSString * txt = ((EMTextMessageBody *)body).text;
            model.latestMessage = txt;
            model.unReadMessageNum = conversation.unreadMessagesCount;
            [_dataArr addObject:model];
            _allNoReadMessageNum += model.unReadMessageNum;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ALLNOREAD" object:[NSNumber numberWithInteger:_allNoReadMessageNum]];
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
}

- (void)createTableView{
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"Message"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    _dataArr = [[NSMutableArray alloc]init];
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
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Message" forIndexPath:indexPath];
    MessageModel * model = _dataArr[indexPath.row];
    if (model.friendName) {
        cell.nameLabel.text = model.friendName;
        cell.isGroupImageView.hidden = YES;
    }else{
        if ([UDS objectForKey:model.groupID]) {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",[UDS objectForKey:model.groupID]];
        }else{
            cell.nameLabel.text = model.groupID;
        }
        cell.isGroupImageView.hidden = NO;
    }
    cell.lastMessageLabel.text = model.latestMessage;
    if (model.unReadMessageNum == 0) {
        cell.messageNumLabel.hidden = YES;
    }else{
        cell.messageNumLabel.hidden = NO;
        cell.messageNumLabel.text = [NSString stringWithFormat:@"%ld",model.unReadMessageNum];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatViewController * chat = [[ChatViewController alloc]init];
    MessageModel * model = _dataArr[indexPath.row];
    chat.friendname = model.friendName;
    chat.groupID = model.groupID;
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction * action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        MessageModel * model = _dataArr[indexPath.row];
        if (model.friendName) {
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:model.friendName deleteMessages:NO append2Chat:YES];
        }else{
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:model.groupID deleteMessages:NO append2Chat:YES];
        }
        [self loadAllConversations];
    }];
    return @[action];
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
