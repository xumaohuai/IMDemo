//
//  ViewController.m
//  基于环信的即时通讯
//
//  Created by 徐茂怀 on 16/1/4.
//  Copyright © 2016年 徐茂怀. All rights reserved.
//

#import "ViewController.h"
#import "RegisterViewController.h"
#import "FriendListViewController.h"
#import <EaseMob.h>
@interface ViewController ()
@property(nonatomic, strong)UITextField *userNameTextField;//用户名
@property(nonatomic, strong)UITextField *passwordTextField;//密码
@property(nonatomic, strong)UIButton *loginButton;          //登陆按钮
@property(nonatomic, strong)UIButton *registerButton;      //注册按钮
@end

@implementation ViewController

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
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _loginButton.frame = CGRectMake(170, 300, 50, 50);
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:25];
    [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(didClickLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _registerButton.frame = CGRectMake(170, 410, 50, 50);
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:25];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registerButton addTarget:self action:@selector(jumpToRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
}

-(void)didClickLoginButton
{
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:_userNameTextField.text password:_passwordTextField.text completion:^(NSDictionary *loginInfo, EMError *error) {
        
        if (!error) {
            
            [self.navigationController pushViewController:[[FriendListViewController alloc]init] animated:YES];
            
        } else {
            
            // 显示错误信息的警告
            NSLog(@"%@",error);
        }
    } onQueue:dispatch_get_main_queue()];

}

-(void)jumpToRegister
{
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self.navigationController presentViewController:registerVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
