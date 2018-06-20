//
//  UIAlertView+Sankit.h
//  SanKit
//
//  Created by Shelley Shyan on 14-11-25.
//  Copyright (c) 2014年 Sanfriend Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIAlertViewBlock) (UIAlertView *alertView);
typedef void (^UIAlertViewCompletionBlock) (UIAlertView *alertView, NSInteger buttonIndex);


@interface UIAlertView (Sankit)

+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message
                        style:(UIAlertViewStyle)style
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                     tapBlock:(UIAlertViewCompletionBlock)tapBlock;

+ (instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                     tapBlock:(UIAlertViewCompletionBlock)tapBlock;

@property (nonatomic, copy) UIAlertViewCompletionBlock tapBlock;
@property (nonatomic, copy) UIAlertViewCompletionBlock willDismissBlock;
@property (nonatomic, copy) UIAlertViewCompletionBlock didDismissBlock;

@property (nonatomic, copy) UIAlertViewBlock willPresentBlock;
@property (nonatomic, copy) UIAlertViewBlock didPresentBlock;
@property (nonatomic, copy) UIAlertViewBlock cancelBlock;

@property (nonatomic, copy) BOOL(^shouldEnableFirstOtherButtonBlock)(UIAlertView *alertView);

@end
