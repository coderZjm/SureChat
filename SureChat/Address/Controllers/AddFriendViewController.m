//
//  AddFriendViewController.m
//  HXChatProj
//
//  Created by yangyang on 16/3/1.
//  Copyright © 2016年 杨阳. All rights reserved.
//

#import "AddFriendViewController.h"
#import "MainViewController.h"
#import "AddressTableViewController.h"
@interface AddFriendViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view from its nib.
}
- (void)createUI{
    self.title = @"添加好友";
}
- (IBAction)addFriendClick:(id)sender {
    if ([_textField.text isEqualToString:@""]) {
        SURE_ALERT(@"好友名称不能为空");
    }else{
        BOOL isSuc = [[EaseMob sharedInstance].chatManager addBuddy:_textField.text message:@"是否可以添加你为好友" error:nil];
        if (isSuc) {
            SURE_ALERT(@"发送好友申请成功");
            _textField.text = @"";
            MainViewController * main = (MainViewController*)self.view.window.rootViewController;
            UINavigationController * addressNav = main.viewControllers[1];
            AddressTableViewController * addressVC = addressNav.viewControllers.firstObject;
            [addressVC loadAllFriendAndGroup];
        }
    }
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
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
