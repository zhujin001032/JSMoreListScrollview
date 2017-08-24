//
//  SliderView.h
//
//  Created by 何助金 on 15/4/25.
//  Copyright (c) 2015年 何助金. All rights reserved.

//

#import <UIKit/UIKit.h>
#define SliderViewH 40
#define ADD_BTN_WIDTH 38
#define color_RGB(r,g,b,al) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:al/1.0]
#define kHexRGB(rgbValue)         [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define kDeviceWidth    ([UIScreen mainScreen].bounds.size.width)
#define kDeviceHeight   ([UIScreen mainScreen].bounds.size.height)

#define kNoticeSortStatusChanged  @"kNoticeSortStatusChanged"
//选中后
@class SliderView;

@protocol SliderDelegate <NSObject>

@optional
- (void)sliderMenuSelectedAtIndex:(NSInteger)index sliderView:(SliderView*)slider;

@end

@interface SliderView : UIScrollView{

    NSInteger _userSelectedID;        //点击按钮选择名字ID
    NSInteger _scrollViewSelectedID;  //滑动列表选择名字ID
    
    CGFloat _sliderWidth;
    BOOL     _isUp;
    BOOL _moreThanFour;//当前条目个数是否是大于4
    NSInteger  _totalOffButton;
    NSArray *_titlesArray;
}
@property (nonatomic, strong) UIImageView *sliderFlag;
@property (nonatomic, assign) id <SliderDelegate> sliderDelegate;
@property (nonatomic, assign) BOOL  isImage;
@property (nonatomic, assign) NSInteger imageId;

@property (nonatomic, strong) NSMutableArray *buttonOriginXArray;
@property (nonatomic, strong) NSMutableArray *buttonWithArray;
@property (nonatomic, assign) NSInteger scrollViewSelectedChannelID;
@property (nonatomic, assign) BOOL  onTop;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL selected;

@property (nonatomic,strong) UIFont *fontSize;
@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIColor *selectedColor;



- (id)initWithFrame:(CGRect)frame titles:(NSArray*)titles canAdd:(BOOL)canAdd;
- (void)updateViewWithTitleArr:(NSArray *)titleArr;
- (void)setButtonSelect;//设置按钮选中
- (void)setButtonUnSelect;//取消按钮选中

- (void)clickedButtonAtIndex:(NSInteger)index;

//更新当前选中的按钮
- (void)updateViewWithID:(NSInteger)sender;

//更新复选按钮图片 （排序）
- (void)layoutViewsWithID:(NSInteger)tag;

//多于4个的时候采用
- (void)relayoutViewsWithID:(NSInteger)index;

//当有多个选项（大于3个时）同步移动flag
- (void)moveFlagImageWith:(CGPoint)currentPoint allSize:(CGSize)size;

//小于等于3个选项卡的时候
- (void)adjustFlagImageWith:(CGPoint)currentPoint items:(int)item;

@end
