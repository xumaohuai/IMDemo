//
//  ChatViewController.m
//  基于环信的即时通讯
//
//  Created by 徐茂怀 on 16/1/4.
//  Copyright © 2016年 徐茂怀. All rights reserved.
//

#import "ChatViewController.h"
#import "DialogBoxView.h"
#import <EaseMob.h>

@interface ChatViewController ()<EMChatManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)EMConversation *conversation;
@property(nonatomic, strong)DialogBoxView *dialogBoxView;
@end

@implementation ChatViewController

-(void)loadView
{
    [super loadView];
    self.title = _name;
    self.navigationController.navigationBar.translucent = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [_tableView setAllowsSelection:NO];
    
    [self registerForKeyboardNotifications];
    
    _dialogBoxView = [[DialogBoxView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 114, self.view.frame.size.width, 50)];
    
    __weak typeof(self) weakSelf = self;
    
    _dialogBoxView.buttonClicked = ^(NSString * draftText){
        
        [weakSelf sendMessageWithDraftText:draftText];
    };
    
    [self.view addSubview:_dialogBoxView];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self reloadChatRecords];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // 移除通知中心
    [self removeForKeyboardNotifications];
    
    // 移除代理
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

# pragma mark - Send Message
/**
 *  使用草稿发送一条信息
 *
 *  @param draftText 草稿
 */
- (void)sendMessageWithDraftText:(NSString *)draftText {
    
    EMChatText * chatText = [[EMChatText alloc] initWithText:draftText];
    EMTextMessageBody * body = [[EMTextMessageBody alloc] initWithChatObject:chatText];
    
    // 生成message
    EMMessage * message = [[EMMessage alloc] initWithReceiver:self.name bodies:@[body]];
    message.messageType = eMessageTypeChat; // 设置为单聊消息
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:^(EMMessage *message, EMError *error) {
        
        // 准备发送
    } onQueue:dispatch_get_main_queue() completion:^(EMMessage *message, EMError *error) {
        
        [self reloadChatRecords];
        // 发送完成
    } onQueue:dispatch_get_main_queue()];
}

# pragma mark - Receive Message
/**
 *  当收到了一条消息时
 *
 *  @param message 消息构造体
 */
- (void)didReceiveMessage:(EMMessage *)message {
    
    [self reloadChatRecords];
}

# pragma mark - Reload Chat Records
/**
 *  重新加载TableView上面显示的聊天信息, 并移动到最后一行
 */
- (void)reloadChatRecords {
    
    _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.name conversationType:eConversationTypeChat];
    
    [_tableView reloadData];
    
    if ([_conversation loadAllMessages].count > 0) {
        
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_conversation loadAllMessages].count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
    }
}

# pragma mark - Keyboard Method
/**
 *  注册通知中心
 */
- (void)registerForKeyboardNotifications
{
    // 使用NSNotificationCenter 注册观察当键盘要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // 使用NSNotificationCenter 注册观察当键盘要隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  移除通知中心
 */
- (void)removeForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  键盘将要弹出
 *
 *  @param notification 通知
 */
- (void)didKeyboardWillShow:(NSNotification *)notification {
    
    NSDictionary * info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSLog(@"%f", keyboardSize.height);
    
    //输入框位置动画加载
    [self begainMoveUpAnimation:keyboardSize.height];
}

/**
 *  键盘将要隐藏
 *
 *  @param notification 通知
 */
- (void)didKeyboardWillHide:(NSNotification *)notification {
    
    [self begainMoveUpAnimation:0];
}

/**
 *  开始执行键盘改变后对应视图的变化
 *
 *  @param height 键盘的高度
 */
- (void)begainMoveUpAnimation:(CGFloat)height {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [_dialogBoxView setFrame:CGRectMake(0, self.view.frame.size.height - (height + 40), _dialogBoxView.frame.size.width, _dialogBoxView.frame.size.height)];
    }];
    
    
    [_tableView layoutIfNeeded];
    
    if ([_conversation loadAllMessages].count > 1) {
        
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_conversation.loadAllMessages.count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
    }
}

# pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _conversation.loadAllMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    EMMessage * message = _conversation.loadAllMessages[indexPath.row];
    
    EMTextMessageBody * body = [message.messageBodies lastObject];
    
    //判断发送的人是否是当前聊天的人,左边是对面发过来的,右边是自己发过去的
    if ([message.to isEqualToString:self.name]) {
        
        cell.detailTextLabel.text = body.text;
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.textLabel.text = @"";
        cell.textLabel.textColor = [UIColor blueColor];
        
    } else {
        
        cell.detailTextLabel.text = @"";
        cell.textLabel.text = body.text;
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.textLabel.textColor = [UIColor blueColor];
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
