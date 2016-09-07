//
//  MessageModel.h
//  SureChat
//
//  Created by yangyang on 16/5/20.
//  Copyright © 2016年 杨阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic,copy) NSString * groupID;

@property (nonatomic,copy) NSString * friendName;

@property (nonatomic,assign) NSInteger unReadMessageNum;

@property (nonatomic,copy) NSString * latestMessage;

@end
