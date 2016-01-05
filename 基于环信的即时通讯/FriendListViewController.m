//
//  FriendListViewController.m
//  基于环信的即时通讯
//
//  Created by 徐茂怀 on 16/1/4.
//  Copyright © 2016年 徐茂怀. All rights reserved.
//

#import "FriendListViewController.h"
#import "AddFriendViewController.h"
#import "ChatViewController.h"
#import <EaseMob.h>
@interface FriendListViewController ()<UITableViewDataSource,UITableViewDelegate,EMChatManagerDelegate,EMChatManagerBuddyDelegate>
@property(nonatomic, strong)NSMutableArray *listArray;
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation FriendListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    }
-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    //左侧注销按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(didClickedCancelButton)];
    self.title = @"好友";
    
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        
        if (!error) {
            NSLog(@"获取成功 -- %@", buddyList);
            
            [_listArray removeAllObjects];
            [_listArray addObjectsFromArray:buddyList];
            [_tableView reloadData];
        }
    } onQueue:dispatch_get_main_queue()];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _listArray = [NSMutableArray new];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addbuttonAction)];
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    //签协议
    [ [EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

-(void)didClickedCancelButton
{
    //注销用户
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addbuttonAction
{
    //跳转到添加好友界面
    [self.navigationController pushViewController:[[AddFriendViewController alloc]init] animated:YES];
}

# pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    EMBuddy * buddy = _listArray[indexPath.row];
    
    cell.textLabel.text = buddy.username;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatViewController * chatVC = [[ChatViewController alloc]init];
    
    EMBuddy * buddy = _listArray[indexPath.row];
    
    chatVC.name = buddy.username;
    
    [self.navigationController pushViewController:chatVC animated:YES];
}
-(void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"收到来自%@的请求", username] message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction * acceptAction = [UIAlertAction actionWithTitle:@"好" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *  action) {
        EMError * error;
        // 同意好友请求的方法
        if ([[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error] && !error) {
            NSLog(@"发送同意成功");
                [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
                    
                    if (!error) {
                        NSLog(@"获取成功 -- %@", buddyList);
                        
                        [_listArray removeAllObjects];
                        [_listArray addObjectsFromArray:buddyList];
                        [_tableView reloadData];
                    }
                } onQueue:dispatch_get_main_queue()];
        
        }
    }];
    UIAlertAction * rejectAction = [UIAlertAction actionWithTitle:@"滚" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        EMError * error;
        // 拒绝好友请求的方法
        if ([[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:@"滚, 快滚!" error:&error] && !error) {
            NSLog(@"发送拒绝成功");
        }
    }];
    [alertController addAction:acceptAction];
    [alertController addAction:rejectAction];
    [self showDetailViewController:alertController sender:nil];
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
