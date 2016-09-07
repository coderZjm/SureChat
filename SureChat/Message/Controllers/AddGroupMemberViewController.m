//
//  AddGroupMemberViewController.m
//  SureChat
//
//  Created by yangyang on 16/3/1.
//  Copyright © 2016年 杨阳. All rights reserved.
//

#import "AddGroupMemberViewController.h"
#import "AddressTableViewCell.h"
@interface AddGroupMemberViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * friendArr;
@property (nonatomic,strong) NSMutableArray * selectArray;
@end

@implementation AddGroupMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    [self loadAllFriend];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadAllFriend{
    _friendArr = [[NSMutableArray alloc]init];
    _selectArray = [[NSMutableArray alloc]init];
    
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        [_friendArr removeAllObjects];
        for (EMBuddy * buddy in buddyList) {
            [_friendArr addObject:buddy.username];
            [self.tableView reloadData];
        }
    } onQueue:nil];
}

- (void)createTableView{
    self.navigationItem.title = @"选择好友";
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"Address"];
    _tableView.editing = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    UIBarButtonItem * addItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addItemClick:)];
    self.navigationItem.rightBarButtonItem = addItem;
}

- (void)addItemClick:(UIBarButtonItem*)item{
    [[EaseMob sharedInstance].chatManager asyncAddOccupants:_selectArray toGroup:_groupID welcomeMessage:@"邀请信息"  completion:^(NSArray *occupants, EMGroup *group, NSString *welcomeMessage, EMError *error) {
        if (!error) {
            NSLog(@"添加成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    } onQueue:nil];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
