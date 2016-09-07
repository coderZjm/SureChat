//
//  ChatViewController.m
//  SureChat
//
//  Created by yangyang on 16/4/5.
//  Copyright © 2016年 杨阳. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewCell.h"
#import "ChatModel.h"
#import "MainViewController.h"
#import "MessageTableViewController.h"
#import "GroupDetailTableViewController.h"
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,EMChatManagerDelegate>
//列表
@property (nonatomic,strong)UITableView * tableView;
//下方视图
@property (nonatomic,strong)UIView * chatView;
//文本输入框(UITextFiled\UITextView)
@property (nonatomic,strong)UITextView * textView;
//发送按钮
@property (nonatomic,strong)UIButton * sendButton;
//自定义键盘
@property (nonatomic,strong)UIButton * customButton;
@property (nonatomic,strong)UIView * customKeyBoradView;
//语音按钮
@property (nonatomic,strong)UIButton * voiceButton;
//数据源
@property (nonatomic,strong)NSMutableArray * dataArray;
//会话
@property (nonatomic,strong) EMConversation * conversation;
//时间
@property (nonatomic,assign) NSTimeInterval time;

@end

@implementation ChatViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BOOL isAllRead = [_conversation markAllMessagesAsRead:YES];
    if (isAllRead) {
        
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    BOOL isAllRead = [_conversation markAllMessagesAsRead:YES];
    if (isAllRead) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self loadMessage];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)loadMessage{
    if (_friendname) {
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:_friendname conversationType:eConversationTypeChat];
    }else{
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:_groupID conversationType:eConversationTypeGroupChat];
    }
    NSArray * array = [_conversation loadAllMessages];
    for (EMMessage * message in array) {
        id <IEMMessageBody> body = message.messageBodies.firstObject;
        NSString * content = ((EMTextMessageBody*)body).text;
        ChatModel * model = [[ChatModel alloc]init];
        if ([message.from isEqualToString:[UDS objectForKey:USER_NAME]]) {
            model.isSelf = YES;
        }else{
            model.isSelf = NO;
        }
        if (_friendname) {
            model.fromUser = message.from;
        }else{
            model.fromUser = message.groupSenderName;
        }
        model.context = content;
        [self.dataArray addObject:model];
        //UI操作
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)createUI{
    if (_friendname) {
        self.navigationItem.title = _friendname;
    }else{
        self.navigationItem.title = [UDS objectForKey:_groupID];
    }
    _dataArray = [[NSMutableArray alloc]init];
    //聊天页面
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64 - 50) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //去除间隔线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    //注册Cell
    [_tableView registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"ID"];
    //下方文本输入
    _chatView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 50, WIDTH, 50)];
    _chatView.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1];
    [self.view addSubview:_chatView];
    //文本输入框
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, WIDTH - 100, 40)];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:18];
    [_chatView addSubview:_textView];
    //发送按钮
    _sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sendButton.backgroundColor = [UIColor orangeColor];
    _sendButton.frame = CGRectMake(WIDTH - 80, 5, 70, 40);
    [_sendButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    [_chatView addSubview:_sendButton];
    //获取群详情
    if (_groupID) {
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setImage:[UIImage imageNamed:@"AlbumShare"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"AlbumShareHL"] forState:UIControlStateHighlighted];
        rightButton.frame = CGRectMake(0, 0, 30, 30);
        [rightButton addTarget:self action:@selector(groupDetail:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    }
    //键盘显隐监听事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //添加手势收起键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenTap:)];
    [_tableView addGestureRecognizer:tap];
}

- (void)groupDetail:(UIButton*)button{
    GroupDetailTableViewController * groupDetail = [[GroupDetailTableViewController alloc]init];
    groupDetail.groupID = _groupID;
    [self.navigationController pushViewController:groupDetail animated:YES];
}

- (void)customKeyBoradShow:(UIButton*)button{
    if (!_customKeyBoradView) {
        _customKeyBoradView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 216)];
        _customKeyBoradView.backgroundColor = [UIColor lightGrayColor];
        _textView.inputView = _customKeyBoradView;
    }
    _customKeyBoradView.hidden = NO;
}
- (void)screenTap:(UITapGestureRecognizer*)tap{
    //取消当前屏幕所有第一响应
    [self.view endEditing:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //CMD
    [self sendInputMsg:INPUT_FLAG];
    return YES;
}

- (void)keyboardWillShow:(NSNotification*)noti{
    //通过代码获取键盘大小
    CGSize keyBoardSize = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    //坐标改变
    [UIView animateWithDuration:1 animations:^{
        _customKeyBoradView.hidden = YES;
        //下方视图
        _chatView.frame = CGRectMake(0, HEIGHT - keyBoardSize.height - 50, WIDTH, 50);
        //列表
        _tableView.frame = CGRectMake(0, 64, WIDTH, HEIGHT - 64 - 50 - keyBoardSize.height);
    }];
}
- (void)keyboardWillHide:(NSNotification*)noti{
    //回归原坐标
    [UIView animateWithDuration:1 animations:^{
        _chatView.frame = CGRectMake(0, HEIGHT - 50, WIDTH, 50);
        _tableView.frame = CGRectMake(0, 64, WIDTH, HEIGHT - 64 - 50);
    }];
}
#pragma mark 发送
- (void)sendClick:(UIButton*)button{
    if ([_textView.text isEqualToString:@""]) {
        SURE_ALERT(@"输入文字不能为空");
    }else{
        EMChatText * text = [[EMChatText alloc]initWithText:_textView.text];
        EMTextMessageBody * body = [[EMTextMessageBody alloc]initWithChatObject:text];
        //生成具体消息
        EMMessage * message;
        if (_friendname) {
            message = [[EMMessage alloc]initWithReceiver:_friendname bodies:@[body]];
            message.messageType = eMessageTypeChat;
        }else{
            message = [[EMMessage alloc]initWithReceiver:_groupID bodies:@[body]];
            message.messageType = eMessageTypeGroupChat;
        }
        //发送消息
        [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:^(EMMessage *message, EMError *error) {
            NSLog(@"准备发送");
        } onQueue:nil completion:^(EMMessage *message, EMError *error) {
            if (!error) {
                NSLog(@"成功发送");
                ChatModel * model = [[ChatModel alloc]init];
                model.fromUser = message.from;
                model.context = _textView.text;
                model.isSelf = YES;
                [_dataArray addObject:model];
                //UI操作
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0];
                [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                _textView.text = @"";
                [self sendInputMsg:END_FLAG];
            }else{
                
            }
        } onQueue:nil];
    }
}
#pragma mark 接收消息
- (void)didReceiveMessage:(EMMessage *)message{
    //来自
    NSString * from = message.from;
    //获得消息体
    id <IEMMessageBody> body = message.messageBodies.firstObject;
    //获取到的文字
    NSString *txt = ((EMTextMessageBody *)body).text;
    //加入判断 只显示与当前会话用户的聊天信息
    if ([from isEqualToString:_friendname] ||[from isEqualToString:_groupID]) {
        ChatModel * model = [[ChatModel alloc]init];
        model.fromUser = message.from;
        model.isSelf = NO;
        model.context = txt;
        [_dataArray addObject:model];
        //UI操作
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (void)sendInputMsg:(NSString*)flag{
    if ([self isCanSendInputMsg]) {
        EMChatCommand *inputCommand = [[EMChatCommand alloc] init];
        inputCommand.cmd = flag;
        EMCommandMessageBody *inputMsgBody = [[EMCommandMessageBody alloc] initWithChatObject:inputCommand];
        EMMessage * message;
        if (_friendname) {
            message = [[EMMessage alloc]initWithReceiver:_friendname bodies:@[inputMsgBody]];
            message.messageType = eMessageTypeChat;
        }else{
            message = [[EMMessage alloc]initWithReceiver:_groupID bodies:@[inputMsgBody]];
            message.messageType = eMessageTypeGroupChat;
        }
        [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil];
    }
}
- (BOOL)isCanSendInputMsg{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // _time 全局变量，记录时间
    if (currentTime - _time > TIME_FLAG) {
        _time = [[NSDate date] timeIntervalSince1970];
        return YES;
    }
    return NO;
}

- (void)didReceiveCmdMessage:(EMMessage *)cmdMessage{
    EMCommandMessageBody *body = cmdMessage.messageBodies.firstObject;
    if ([body.action isEqualToString:INPUT_FLAG]) {
        // update ui
        if (_friendname) {
            self.navigationItem.title = @"对方正在输入...";
        }else{
        self.navigationItem.title = @"群成员发言中...";
        }
    }else{
        if (_friendname) {
            self.navigationItem.title = _friendname;
        }else{
            self.navigationItem.title = [UDS objectForKey:_groupID];
        }
    }
}

#pragma mark TableViewDel
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID" forIndexPath:indexPath];
    //取数据
    ChatModel * model = _dataArray[indexPath.row];
    
    [cell loadDataFromModel:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取数据
    ChatModel * model = _dataArray[indexPath.row];
    //根据文字确定显示大小
    CGSize size = [model.context boundingRectWithSize:CGSizeMake(160, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} context:nil].size;
    return size.height + 40;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
