//
//  MessageTableViewCell.m
//  SureChat
//
//  Created by yangyang on 16/5/20.
//  Copyright © 2016年 杨阳. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _headImageView.layer.cornerRadius = 5;
    _headImageView.clipsToBounds = YES;
    _messageNumLabel.layer.cornerRadius = 12.5;
    _messageNumLabel.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
