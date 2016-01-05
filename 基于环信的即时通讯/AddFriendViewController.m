//
//  AddFriendViewController.m
//  基于环信的即时通讯
//
//  Created by 徐茂怀 on 16/1/4.
//  Copyright © 2016年 徐茂怀. All rights reserved.
//

#import "AddFriendViewController.h"
#import <EaseMob.h>
@interface AddFriendViewController ()
@property(nonatomic, strong)UITextField *userNameTextField;//用户名
@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *usernameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 80, 50)];
    usernameLabel.text = @"用户名";
    usernameLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:usernameLabel];
    
    _userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(usernameLabel.frame.origin.x + usernameLabel.frame.size.width + 10, usernameLabel.frame.origin.y, 250, 50)];
    _userNameTextField.borderStyle = 3;
    _userNameTextField.placeholder = @"请输入用户名";
    [self.view addSubview:_userNameTextField];

    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(170, 300, 50, 50);
    addButton.titleLabel.font = [UIFont systemFontOfSize:25];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(didClickAddButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];

}

-(void)didClickAddButton
{
    EMError * error;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:_userNameTextField.text message:@"我想加您为好友" error:&error];
    if (isSuccess && !error) {
        NSLog(@"添加成功");
    }
    else
    {
        NSLog(@"%@",error);
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
