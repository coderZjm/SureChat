//
//  ChatTableViewCell.h
//  BubbleChat
//
//  Created by yangyang on 16/4/5.
//  Copyright © 2016年 杨阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"
@interface ChatTableViewCell : UITableViewCell
//左头像
@property (nonatomic,strong) UIImageView * leftIconImageView;
//右头像
@property (nonatomic,strong) UIImageView * rightIconImageView;
//左昵称
@property (nonatomic,strong) UILabel * leftName;
//右昵称
@property (nonatomic,strong) UILabel * rightName;
//左气泡
@property (nonatomic,strong) UIImageView * leftBubble;
//右气泡
@property (nonatomic,strong) UIImageView * rightBubble;
//左label
@property (nonatomic,strong) UILabel * leftLabel;
//右label
@property (nonatomic,strong) UILabel * rightLabel;

- (void)loadDataFromModel:(ChatModel*)model;
@end
