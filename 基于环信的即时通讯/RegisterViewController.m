//
//  RegisterViewController.m
//  基于环信的即时通讯
//
//  Created by 徐茂怀 on 16/1/4.
//  Copyright © 2016年 徐茂怀. All rights reserved.
//

#import "RegisterViewController.h"
#import <EaseMob.h>
@interface RegisterViewController ()
@property(nonatomic, strong)UITextField *userNameTextField;//用户名
@property(nonatomic, strong)UITextField *passwordTextField;//密码
@property(nonatomic, strong)UIButton *registerButton;      //注册按钮
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"登陆界面";
    
    UILabel *usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 80, 50)];
    usernameLabel.text = @"用户名";
    usernameLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:usernameLabel];
    
    _userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(usernameLabel.frame.origin.x + usernameLabel.frame.size.width + 10, usernameLabel.frame.origin.y, 250, 50)];
    _userNameTextField.borderStyle = 3;
    _userNameTextField.placeholder = @"请输入用户名";
    [self.view addSubview:_userNameTextField];
    
    UILabel *passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(usernameLabel.frame.origin.x, usernameLabel.frame.origin.y + usernameLabel.frame.size.height + 10, usernameLabel.frame.size.width, usernameLabel.frame.size.height)];
    passwordLabel.text = @"密码";
    passwordLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:passwordLabel];
    
    _passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(_userNameTextField.frame.origin.x, passwordLabel.frame.origin.y, _userNameTextField.frame.size.width, _userNameTextField.frame.size.height)];
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.borderStyle = 3;
    [self.view addSubview:_passwordTextField];
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _registerButton.frame = CGRectMake(170, 330, 50, 50);
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:25];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registerButton addTarget:self action:@selector(didClickedRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(170, 280, 50, 50);
    backButton.titleLabel.font = [UIFont systemFontOfSize:25];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_passwordTextField resignFirstResponder];
    [_userNameTextField resignFirstResponder];
}

-(void)didClickedRegisterButton:(id)sender
{
//  登陆和注册有3种方法: 1. 同步方法 2. 通过delegate回调的异步方法。3.block异步方法
    //其中官方推荐使用block异步方法,所以我这里就用block异步方法

    //开始注册
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:_userNameTextField.text password:_passwordTextField.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            NSLog(@"注册成功");
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            NSLog(@"%@",error);
        }
    } onQueue:dispatch_get_main_queue()];
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
