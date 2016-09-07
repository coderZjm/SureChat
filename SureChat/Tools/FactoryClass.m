//
//  FactoryClass.m
//  MVVM
//
//  Created by yangyang on 16/5/20.
//  Copyright © 2016年 杨阳. All rights reserved.
//

#import "FactoryClass.h"

@interface FactoryClass ()
@property (nonatomic,strong)UITableView * tableView;
@end

@implementation FactoryClass

+ (UIView*)createViewWithFrame:(CGRect)frame AndBackgroundColor:(UIColor*)color AndParentView:(UIView*)parentView{
    UIView * view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = color;
    [parentView addSubview:view];
    return view;
}

+ (UILabel*)createLableWithFrame:(CGRect)frame AndText:(NSString*)text AndFont:(UIFont*)font AndTextAligment:(NSTextAlignment)alignment AndNumberOfLines:(NSInteger)number AndParentView:(UIView*)parentView{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textAlignment = alignment;
    label.numberOfLines = number;
    [parentView addSubview:label];
    return label;
}

+ (UIImageView*)createImageViewWithFrame:(CGRect)frame AndImageNamed:(NSString*)imageName AndParentView:(UIView*)parentView{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    [parentView addSubview:parentView];
    return imageView;
}

+ (UITextField*)createTextFieldWithFrame:(CGRect)frame AndBorderStyle:(UITextBorderStyle)borderstyle AndPlaceholder:(NSString *)placeholder AndTextAlignment:(NSTextAlignment)textAligment AndDelegate:(id<UITextFieldDelegate>)delegate AndParentView:(UIView *)view{
    UITextField * textField = [[UITextField alloc]initWithFrame:frame];
    textField.borderStyle = borderstyle;
    textField.placeholder = placeholder;
    textField.textAlignment = textAligment;
    textField.delegate = delegate;
    [view addSubview:textField];
    return textField;
}

+ (UITextView*)createTextViewWithFrame:(CGRect)frame AndDelegate:(id<UITextViewDelegate>)delegate AndParentView:(UIView *)view{
    UITextView * textView = [[UITextView alloc]initWithFrame:frame];
    textView.delegate = delegate;
    [view addSubview:textView];
    return textView;
}

+ (UIButton*)createButtonWithType:(UIButtonType)buttonType AndFrame:(CGRect)frame AndTitle:(NSString*)title AndImageNamed:(NSString*)imageName WithState:(UIControlState)state AndAddTarget:(id)objc action:(SEL)seletor forControlEvents:(UIControlEvents)controlEvents AndParentView:(UIView*)parentView{
    UIButton * button = [UIButton buttonWithType:buttonType];
    button.frame = frame;
    [button setTitle:title forState:state];
    [button setImage:[UIImage imageNamed:imageName] forState:state];
    [button addTarget:objc action:seletor forControlEvents:controlEvents];
    [parentView addSubview:button];
    return button;
}

+ (UITableView*)createTableViewWithFrame:(CGRect)frame AndStyle:(UITableViewStyle)style AndDelegate:(id<UITableViewDelegate,UITableViewDataSource>)viewController{
    UITableView * tableView = [[UITableView alloc]initWithFrame:frame style:style];
    tableView.delegate = viewController;
    tableView.dataSource = viewController;
    UIViewController * vc = (UIViewController*)viewController;
    [vc.view addSubview:tableView];
    return tableView;
}

+ (UICollectionView*)createCollectionViewWithFrame:(CGRect)frame AndCollectionViewLayout:(UICollectionViewLayout*)collentionViewLayout AndDelegate:(id<UICollectionViewDelegate,UICollectionViewDataSource>)viewController{
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:collentionViewLayout];
    collectionView.delegate = viewController;
    collectionView.dataSource = viewController;
    UIViewController * vc = (UIViewController*)viewController;
    [vc.view addSubview:collectionView];
    return collectionView;
}

@end
