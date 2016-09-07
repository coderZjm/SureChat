//
//  FactoryClass.h
//  MVVM
//
//  Created by yangyang on 16/4/5.
//  Copyright © 2016年 杨阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FactoryClass : NSObject

+ (UIView*)createViewWithFrame:(CGRect)frame AndBackgroundColor:(UIColor*)color AndParentView:(UIView*)parentView;

+ (UILabel*)createLableWithFrame:(CGRect)frame AndText:(NSString*)text AndFont:(UIFont*)font AndTextAligment:(NSTextAlignment)alignment AndNumberOfLines:(NSInteger)number AndParentView:(UIView*)parentView;

+ (UIImageView*)createImageViewWithFrame:(CGRect)frame AndImageNamed:(NSString*)imageName AndParentView:(UIView*)parentView;

+ (UITextField*)createTextFieldWithFrame:(CGRect)frame AndBorderStyle:(UITextBorderStyle)borderstyle AndPlaceholder:(NSString*)placeholder AndTextAlignment:(NSTextAlignment)textAligment AndDelegate:(id<UITextFieldDelegate>)delegate AndParentView:(UIView*)view;

+ (UITextView*)createTextViewWithFrame:(CGRect)frame AndDelegate:(id<UITextViewDelegate>)delegate AndParentView:(UIView*)view;

+ (UIButton*)createButtonWithType:(UIButtonType)buttonType AndFrame:(CGRect)frame AndTitle:(NSString*)title AndImageNamed:(NSString*)imageName WithState:(UIControlState)state AndAddTarget:(id)objc action:(SEL)seletor forControlEvents:(UIControlEvents)controlEvents AndParentView:(UIView*)parentView;

+ (UITableView*)createTableViewWithFrame:(CGRect)frame AndStyle:(UITableViewStyle)style AndDelegate:(id<UITableViewDelegate,UITableViewDataSource>)viewController;

+ (UICollectionView*)createCollectionViewWithFrame:(CGRect)frame AndCollectionViewLayout:(UICollectionViewLayout*)collentionViewLayout AndDelegate:(id<UICollectionViewDelegate,UICollectionViewDataSource>)viewController;



@end
