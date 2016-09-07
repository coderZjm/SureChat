//
//  ChatTableViewCell.m
//  BubbleChat
//
//  Created by yangyang on 16/4/5.
//  Copyright © 2016年 杨阳. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithRed:231 / 255.0 green:231 / 255.0 blue:231 / 255.0 alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //左头像
        _leftIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
        _leftIconImageView.image = [UIImage imageNamed:@"watch-tips-avatar2~iphone"];
        _leftIconImageView.layer.cornerRadius = 5;
        _leftIconImageView.clipsToBounds = YES;
        [self.contentView addSubview:_leftIconImageView];
        
        //右头像
        _rightIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 45, 5, 40, 40)];
        _rightIconImageView.image = [UIImage imageNamed:@"watch-tips-avatar~iphone"];
        _rightIconImageView.layer.cornerRadius = 5;
        _rightIconImageView.clipsToBounds = YES;
        [self.contentView addSubview:_rightIconImageView];
        
        //左名字
        _leftName = [[UILabel alloc]initWithFrame:CGRectMake(5, 46, 40, 10)];
        _leftName.text = @"左用户";
        _leftName.textAlignment = NSTextAlignmentCenter;
        _leftName.font = [UIFont systemFontOfSize:8];
        _leftName.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_leftName];
        
        //右名字
        _rightName = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 45, 46, 40, 10)];
        _rightName.text = @"右用户";
        _rightName.textAlignment = NSTextAlignmentCenter;
        _rightName.font = [UIFont systemFontOfSize:8];
        _rightName.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_rightName];
        
        //1、得到图片信息
        UIImage * leftImage = [UIImage imageNamed:@"Private letter_List_1"];
        UIImage * rightImage = [UIImage imageNamed:@"Private letter_List_2"];
        //2、抓取像素拉伸
        leftImage = [leftImage stretchableImageWithLeftCapWidth:10 topCapHeight:20];
        rightImage = [rightImage stretchableImageWithLeftCapWidth:10 topCapHeight:20];
        
        //左气泡
        _leftBubble = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 180, 40)];
        _leftBubble.image = leftImage;
        [self.contentView addSubview:_leftBubble];
        //有气泡
        _rightBubble = [[UIImageView alloc]initWithFrame:CGRectMake(190, 5, 180, 40)];
        _rightBubble.image = rightImage;
        [self.contentView addSubview:_rightBubble];
        
        //气泡上的文字
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 160, 30)];
        _leftLabel.text = @"犯我德邦者，虽远必诛！";
        _leftLabel.numberOfLines = 0;
        [_leftBubble addSubview:_leftLabel];
        
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 160, 30)];
        _rightLabel.text = @"你的剑就是我的剑";
        _rightLabel.numberOfLines = 0;
        [_rightBubble addSubview:_rightLabel];
    }
    return self;
}

- (void)loadDataFromModel:(ChatModel *)model{
    //根据文字确定显示大小
    CGSize size = [model.context boundingRectWithSize:CGSizeMake(160, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} context:nil].size;
    if (model.isSelf) {
        //只显示右侧气泡
        self.leftBubble.hidden = YES;
        self.rightBubble.hidden = NO;
        self.leftIconImageView.hidden = YES;
        self.rightIconImageView.hidden = NO;
        self.leftName.hidden = YES;
        self.rightName.hidden = NO;
        self.rightLabel.text = model.context;
        self.rightName.text = model.fromUser;
        //调整坐标 根据label文字自适应
        self.rightLabel.frame = CGRectMake(10, 15, size.width, size.height);
        self.rightBubble.frame = CGRectMake(WIDTH - size.width - 30 - 50, 0, size.width + 30, size.height + 30);
    }else{
        //只显示左侧气泡
        self.leftBubble.hidden = NO;
        self.rightBubble.hidden = YES;
        self.leftIconImageView.hidden = NO;
        self.rightIconImageView.hidden = YES;
        self.leftName.hidden = NO;
        self.rightName.hidden = YES;
        self.leftLabel.text = model.context;
        self.leftName.text = model.fromUser;
        self.leftLabel.frame = CGRectMake(15, 15, size.width, size.height);
        self.leftBubble.frame = CGRectMake(50, 0, size.width + 30, size.height + 30);
    }

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
