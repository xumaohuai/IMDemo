//
//  DialogBoxView.m
//  基于环信的即时通讯
//
//  Created by 徐茂怀 on 16/1/4.
//  Copyright © 2016年 徐茂怀. All rights reserved.
//

#import "DialogBoxView.h"

@interface DialogBoxView ()
@property (nonatomic, strong) UITextField * draftTextField;
@property (nonatomic, strong) UIButton * sendButton;

@end

@implementation DialogBoxView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
    }
    return self;
}

- (void)initView{
    
    [self setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    
    _draftTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 100, self.frame.size.height - 10)];
    [_draftTextField setBorderStyle:(UITextBorderStyleRoundedRect)];
    [_draftTextField setPlaceholder:@"说点什么呢"];
    [_draftTextField setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:_draftTextField];
    
    _sendButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_sendButton setFrame:CGRectMake(self.frame.size.width - 90, 5, 85, self.frame.size.height - 10)];
    [_sendButton setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:128 / 255.0 alpha:1]];
    [_sendButton setTitle:@"发送" forState:(UIControlStateNormal)];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [_sendButton.layer setMasksToBounds:YES];
    [_sendButton.layer setCornerRadius:4];
    [_sendButton addTarget:self action:@selector(didSendButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_sendButton];
}

- (void)didSendButtonClicked:(UIButton *)sender {
    
    if (self.buttonClicked) {
        self.buttonClicked(_draftTextField.text);
    }
    _draftTextField.text = @"";
}

- (NSString *)draftText {
    
    return _draftTextField.text;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end
