//
//  MoreListScrollview.h
//
//  Created by 何助金 on 15/4/25.
//  Copyright (c) 2015年 何助金. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderView.h"
#import "JSBaseCategoryModel.h"
typedef void (^SelectedAtIndexBlock)(NSInteger index,id obj);
typedef void (^EditBlock)();

@interface MoreListScrollview : UIView<SliderDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *rootScrollView;
@property (nonatomic, strong) SliderView *sliderView;
@property (nonatomic, weak)  UIViewController *owner;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSArray <JSBaseCategoryModel *>*titleArray;
//for edit
@property (strong,nonatomic)NSArray<JSBaseCategoryModel * > *lastTitleArray;
@property (strong,nonatomic)NSMutableArray <JSBaseCategoryModel * >*selectedArray;
@property (strong,nonatomic)NSMutableArray <JSBaseCategoryModel * >*unselectedArray;

@property (nonatomic,copy)   SelectedAtIndexBlock selectedAtIndexblock;
@property (nonatomic,copy)   EditBlock editBlock;


//for coustom
@property (nonatomic,strong) UIFont *fontSize;
@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIColor *selectedColor;

#pragma mark -
//方便设置选择栏目
- (void)sliderMenuSelectedAtIndex:(NSInteger)index sliderView:(SliderView*)slider;

- (void)setSelectedAtIndexblock:(SelectedAtIndexBlock)selectedAtIndexblock;

- (void)setEditBlock:(EditBlock)editBlock;

- (instancetype)initWithFrame:(CGRect)frame
               withTitleArray:(NSArray *)titleArray
                withDataArray:(NSArray *)dataArray
                    withOwner:(UIViewController *)owner
                    canAdd:(BOOL)canAdd;
- (void)updateListViewWithTitleArray:(NSArray *)newTitleArr;

@end
