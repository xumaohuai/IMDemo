//
//  DialogBoxView.h
//  基于环信的即时通讯
//
//  Created by 徐茂怀 on 16/1/4.
//  Copyright © 2016年 徐茂怀. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonClicked)(NSString * draftText);
@interface DialogBoxView : UIView
@property (nonatomic, copy) ButtonClicked buttonClicked;
@end
