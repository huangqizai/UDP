//
//  SFCodeConvention.h
//  SanKit
//
//  Created by Shelley Shyan on 14-11-13.
//  Copyright (c) 2014年 Sanfriend Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

// 外部变量
extern NSString *const sfMyConstant;
extern NSString *MyExternString;
static NSString *const sfMyStaticConstant;
static NSString *staticString;

// 枚举
typedef NS_ENUM(NSUInteger, GIGAdRequestState) {
    GIGAdRequestStateInactive,
    GIGAdRequestStateLoading
};

typedef enum {
    SSHUDViewStyleLight = 7,
    SSHUDViewStyleDark = 12
} SSHUDViewStyle;


//头文件中尽量用 @class，少引用文件

// 类名首字母大写, S开头
@interface SFCodeConvention : NSObject

// 顺序: nonatomic, retain/assign, readonly, getter
@property (nonatomic, retain) UIColor *topColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, retain, readonly) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign, getter=isLoading) BOOL loading;

@end
