//
//  ChatModel.h
//  BubbleChat
//
//  Created by yangyang on 16/4/5.
//  Copyright © 2016年 杨阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject

@property (nonatomic,copy) NSString * fromUser;

@property (nonatomic,copy) NSString * context;

@property (nonatomic,assign) BOOL isSelf;

@end
