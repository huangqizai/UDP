//
//  SFSegmentedControl.h
//  SanKit
//
//  Created by Shelley Shyan on 14-9-7.
//  Copyright (c) 2014年 Sanfriend Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef SFSegmentedControlHeight
  #define SFSegmentedControlHeight 40.0
  #define SFSegmentedControlMinButtonWidth 80.0
  #define SFSegmentedControlStartTag 991000
#endif

@protocol SFSegmentedControlDelegate <NSObject>

@required
- (void)sfSegmentedControlDidSelectIndex:(NSInteger)index;

@end




@interface SFSegmentedControl : UIView

@property (assign, nonatomic) id<SFSegmentedControlDelegate>delegate;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) BOOL showSeperator;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat bottomLinePadding;
@property (nonatomic, strong) UIColor *colorSelectedIndex;
@property (nonatomic, strong) UIColor *colorUnselectedIndex;
@property (nonatomic, strong) UIColor *colorBottomLine;
@property (nonatomic, strong) UIColor *colorSeperator;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) CGFloat heightSeperator;



- (id) initWithFrame:(CGRect)frame delegate:(id)delegate;
- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles delegate:(id)delegate;
- (id)initWithOriginY:(CGFloat)y titles:(NSArray *)titles delegate:(id)delegate;

- (void)didSelectedIndex:(NSInteger)index;
- (void) updateParameters;

@end
