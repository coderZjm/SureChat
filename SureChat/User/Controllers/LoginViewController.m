//
//  LoginViewController.m
//  HXChatProj
//
//  Created by yangyang on 16/5/20.
//  Copyright © 2016年 杨阳. All rights reserved.
//

#import "LoginViewController.h"
#import "UIImage+GIF.h"
#import "MainViewController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)tapClick:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}
- (IBAction)registerClick:(id)sender {
    if ([_usernameTextField.text isEqualToString:@""]||[_passwordTextField.text isEqualToString:@""]) {
        SURE_ALERT(@"账号或密码不能为空");
    }else if (_passwordTextField.text.length < 3){
        SURE_ALERT(@"密码不可少于3位");
    }else{
        [SVProgressHUD show];
        [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:_usernameTextField.text password:_passwordTextField.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
            if (!error) {
                SURE_ALERT(@"注册成功");
            }else{
                NSLog(@"%@",error);
                SURE_ALERT(error.description);
            }
            [SVProgressHUD dismiss];
        } onQueue:nil];
    }
}
- (IBAction)loginClick:(id)sender {
    if ([_usernameTextField.text isEqualToString:@""]||[_passwordTextField.text isEqualToString:@""]) {
        SURE_ALERT(@"账号或密码不能为空");
    }else{
        [SVProgressHUD show];
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:_usernameTextField.text password:_passwordTextField.text completion:^(NSDictionary *loginInfo, EMError *error) {
            if (!error) {
                NSLog(@"登录成功");
                //保存本人名称
                [UDS setObject:_usernameTextField.text forKey:USER_NAME];
                //跳转主页面 重置根视图
                MainViewController * main = [[MainViewController alloc]init];
                self.view.window.rootViewController = main;
                //设置自动登录
                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            }else{
                NSLog(@"%@",error);
                SURE_ALERT(error.description);
            }
            [SVProgressHUD dismiss];
        } onQueue:nil];
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
