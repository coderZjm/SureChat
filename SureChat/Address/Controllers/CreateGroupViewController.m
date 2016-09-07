//
//  CreateGroupViewController.m
//  SureChat
//
//  Created by yangyang on 16/4/5.
//  Copyright © 2016年 杨阳. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "AddressTableViewCell.h"
#import "MainViewController.h"
#import "AddressTableViewController.h"
@interface CreateGroupViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray * friendArr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *groupTextField;

@property (nonatomic,strong) NSMutableArray * selectArray;
@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createRightItem];
    [self createTableView];
    [self loadAllFriend];
    // Do any additional setup after loading the view from its nib.
}

- (void)createRightItem{
    UIBarButtonItem * createItem = [[UIBarButtonItem alloc]initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(createGroupClick:)];
    self.navigationItem.rightBarButtonItem = createItem;
}

- (void)createTableView{
    self.title = @"创建群聊";
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"Address"];
    _tableView.editing = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    _groupTextField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)loadAllFriend{
    _friendArr = [[NSMutableArray alloc]init];
    _selectArray = [[NSMutableArray alloc]init];
    //获取真实好友列表
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        [_friendArr removeAllObjects];
        for (EMBuddy * buddy in buddyList) {
            [_friendArr addObject:buddy.username];
            [self.tableView reloadData];
        }
    } onQueue:nil];
}

- (void)createGroupClick:(UIBarButtonItem*)item{
    if (_selectArray.count == 0) {
        SURE_ALERT(@"您没有选择好友");
    }else if ([_groupTextField.text isEqualToString:@""]){
        SURE_ALERT(@"群名称不能为空");
    }else{
        NSLog(@"%@",_selectArray);
        [SVProgressHUD showWithStatus:@"正在配置组内成员..."];
        EMGroupStyleSetting *groupStyleSetting = [[EMGroupStyleSetting alloc] init];
        groupStyleSetting.groupMaxUsersCount = 500; // 创建500人的群，如果不设置，默认是200人。
        groupStyleSetting.groupStyle = eGroupStyle_PublicOpenJoin; // 创建不同类型的群组，这里需要才传入不同的类型
        [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:_groupTextField.text
                                                              description:nil
                                                                 invitees:_selectArray
                                                    initialWelcomeMessage:@"邀请您加入群组"
                                                             styleSetting:groupStyleSetting
                                                               completion:^(EMGroup *group, EMError *error) {
                                                                   if(!error){
                                                                       NSLog(@"创建成功 -- %@",group);
                                                                       MainViewController * main = (MainViewController*)self.view.window.rootViewController;
                                                                       UINavigationController * addressNav = main.viewControllers[1];
                                                                       AddressTableViewController * addressVC = addressNav.viewControllers.firstObject;
                                                                       [addressVC loadAllFriendAndGroup];
                                                                       [self.navigationController popViewControllerAnimated:YES];
                                                                   }
                                                                   [SVProgressHUD dismiss];
                                                               } onQueue:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _friendArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Address" forIndexPath:indexPath];
    cell.label.text = _friendArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark 多选相关
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    //多选形式需返回的类型
}
//在TableView被选中的方法中获取选中的数据
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断 只有在可编辑的状态下才可以进行选中数据源
    if (tableView.editing == YES) {
        //寻找选中的数据
        NSString * selectStr = [self.friendArr objectAtIndex:indexPath.row];
        //将所选中数据统一存在存放在一个数组中
        [self.selectArray addObject:selectStr];
    }
}
//TableVie取消选中会调用的方法
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //从选中的数据源中将取消选中的数据移除
    //找到取消选中的数据
    //在dataArray中进行查找
    NSString * deSelectStr = [self.friendArr objectAtIndex:indexPath.row];
    
    //判断
    if ([self.selectArray containsObject:deSelectStr]) {
        //如果被选中的数据源中确实有取消选中的这个数据 进行移除
        [self.selectArray removeObject:deSelectStr];
    }
    
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
