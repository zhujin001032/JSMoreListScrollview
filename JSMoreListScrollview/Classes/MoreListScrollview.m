//
//  MoreListScrollview.m
//
//  Created by 何助金 on 15/4/25.
//  Copyright (c) 2015年 何助金. All rights reserved.
//
#import "MoreListScrollview.h"

@interface MoreListScrollview ()
@property (nonatomic,assign) BOOL canAdd;


@end

@implementation MoreListScrollview

- (void)dealloc
{
    [_sliderView removeFromSuperview];
    _sliderView = nil;
    
    [_rootScrollView removeFromSuperview];
    _rootScrollView = nil;
    
    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
}
- (void)setFontSize:(UIFont *)fontSize{
    _fontSize = fontSize;
    _sliderView.fontSize = fontSize;
    
}

- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    _sliderView.normalColor = normalColor;
}

- (void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor = selectedColor;
    _sliderView.selectedColor = selectedColor;
}

- (void)setEditBlock:(EditBlock)editBlock{
    _editBlock = editBlock;
}
- (instancetype)initWithFrame:(CGRect)frame
               withTitleArray:(NSArray *)titleArray
                withDataArray:(NSArray *)dataArray
                    withOwner:(UIViewController *)owner
                       canAdd:(BOOL)canAdd
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setBackgroundColor:BK_COMMON_COLOR];
        _selectedArray = [NSMutableArray array];
        _unselectedArray = [NSMutableArray array];
        [_selectedArray  addObjectsFromArray: titleArray];
        [_unselectedArray addObjectsFromArray:dataArray];
        _canAdd = canAdd;
        _titleArray = _selectedArray;
        _owner = owner;
        [self _initViews];
        [self _initSliderViewWithTitleArray:_selectedArray canAdd:_canAdd];
    }
    
    return self;
}

- (void)_initViews
{
    _rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _rootScrollView.backgroundColor = self.backgroundColor;
    _rootScrollView.bounces = YES;
    _rootScrollView.delegate = self;
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.clipsToBounds = YES;
    _rootScrollView.directionalLockEnabled = YES;
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.showsVerticalScrollIndicator = YES;
    [self addSubview:_rootScrollView];
}

//- (void)addColorLayrAtView:(UIView *)baseView{
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = baseView.bounds;
//    gradient.colors = [NSArray arrayWithObjects:
//                       (id)kHexRGBAlpha(0xDF9980, 0.8).CGColor,
//                       (id)kHexRGBAlpha(0xDF9980, 0.5).CGColor,
//                       (id)kHexRGBAlpha(0xffffff, 0.9).CGColor,
//                       nil];
//    gradient.startPoint = CGPointMake(0, 0.5);
//    gradient.endPoint = CGPointMake(1, 0.5);
//    [baseView.layer addSublayer:gradient];
////    gradient.opaque = YES;
//}

//
- (void)_initSliderViewWithTitleArray:(NSArray <JSBaseCategoryModel * >*)titleArray canAdd:(BOOL)canAdd
{
    _lastTitleArray = [titleArray copy];
    
    
    if (titleArray.count > 0) {
        if (_sliderView == nil) {
            _sliderView = [[SliderView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       _canAdd?kDeviceWidth-ADD_BTN_WIDTH:kDeviceWidth,
                                                                       SliderViewH)
                                                     titles:titleArray
                                                     canAdd:_canAdd];
            _sliderView.sliderDelegate = self;
            _sliderView.currentIndex = 0;
            [self addSubview:_sliderView];
          
            if (_canAdd) {
                
                NSBundle *mainBundle = [NSBundle bundleForClass:[SliderView class]];
                
                NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"JSMoreListScrollview" ofType:@"bundle"]];
                
                if (resourcesBundle == nil) {
                    resourcesBundle = mainBundle;
                }
                
                UIImage * addImage = [UIImage imageNamed:@"add" inBundle:resourcesBundle compatibleWithTraitCollection:nil];
                
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-ADD_BTN_WIDTH+2,
                                                                          0,
                                                                          ADD_BTN_WIDTH-2,
                                                                          SliderViewH)];
                
                
                [btn setImage:addImage
                     forState:UIControlStateNormal];
                [btn setBackgroundColor:kHexRGB(0xf1d9cf)];
                [btn addTarget:self action:@selector(editItems:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
//                [self addColorLayrAtView:btn];
            }

        }
        

        //改变视图的frame， contentsize
        _rootScrollView.frame = CGRectMake(0, SliderViewH, kDeviceWidth, self.bounds.size.height-SliderViewH);
        _rootScrollView.contentSize = CGSizeMake(kDeviceWidth*titleArray.count, self.bounds.size.height-SliderViewH);
    }
    
    for (UIView *v in [_rootScrollView subviews]) {
        if (v != nil) {
            [v removeFromSuperview];
        }
    }
    
//    放到外出方便使用自定义tableview
//    [self createListViewsWithTitleArray:titleArray];
}


- (void)editItems:(id)sender{
// to do add / del items
    
    if (self.editBlock) {
        self.editBlock();
    }
}

//- (void)createListViewsWithTitleArray:(NSArray < id>*)titleArray
//{
//    for (int i = 0; i < titleArray.count; ++i) {
//        UITableView *newsTableView = nil;
//        newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(i*kDeviceWidth,
//                                                                                0,
//                                                                                kDeviceWidth,
//                                                                                self.bounds.size.height-SliderViewH)
//                                                               style:UITableViewStylePlain];
//        newsTableView.tag = i + 10000;
////        newsTableView.owner = self.owner;
//        
//        
////        // 加载首个页面
////
//        if (i == 0) {
////            newsTableView.newsType = NewsType_Main;
////            newsTableView.newsCatID = [[MSCoreManager sharedManager].settingModel.cat_option.home integerValue];
////            [newsTableView fetchHomeInfo:NewsType_Main pageIndex:1];
//        }else{
////            newsTableView.newsType = NewsType_List;
////            newsTableView.newsCatID = titleArray[i].id;
//        }
//        
//        [_rootScrollView addSubview:newsTableView];
//    }
//}
//
//
//- (void)updateListViewWithTitleArray:(NSArray <JSBaseCategoryModel * >*)newTitleArr{
//
//    [_selectedArray removeAllObjects];
//    [_selectedArray addObjectsFromArray:newTitleArr];
//    [_sliderView updateViewWithTitleArr:newTitleArr];
//
//    for (NSInteger i = 0; i < _lastTitleArray.count; i++) {
//        //1.移除不需要的
//        if(![newTitleArr containsObject:_lastTitleArray[i]]){
//            UITableView *tableView = [_rootScrollView viewWithTag:i + 10000];
//            if (tableView) {
//                [tableView removeFromSuperview];
//            }
//
//        }
//    }
//    
//    for (NSInteger i = 0; i < newTitleArr.count; i++) {
//        // 2.保留且設置好位置
//        if ([_lastTitleArray containsObject: newTitleArr[i]]) {
//            NSInteger index = [_lastTitleArray indexOfObject:newTitleArr[i]];
//            UITableView *tableView = [_rootScrollView viewWithTag:index + 10000];
//            tableView.tag = i+10000;
//            tableView.frame = CGRectMake(i*kDeviceWidth,
//                                         0,
//                                         kDeviceWidth,
//                                         self.bounds.size.height-SliderViewH);
//        }else{
//            
//            
//        }
//    }
//
//    
//    for (NSInteger i = 0; i < newTitleArr.count; i++) {
//        //3.創建新的
//        if (![_lastTitleArray containsObject:newTitleArr[i]]) {
//            UITableView *newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(i*kDeviceWidth,
//                                                                            0,
//                                                                            kDeviceWidth,
//                                                                            self.bounds.size.height-SliderViewH)
//                                                           style:UITableViewStylePlain];
//            newsTableView.tag = i + 10000;
////            newsTableView.owner = self.owner;
//            
//            //        // 加载首个页面
//            //
//            if (i == 0) {
////                newsTableView.newsType = NewsType_Main;
////                newsTableView.newsCatID = newTitleArr[i].id;
////                [newsTableView fetchHomeInfo:NewsType_Main pageIndex:0];
//            }
//            else{
////                newsTableView.newsType = NewsType_List;
////                newsTableView.newsCatID = newTitleArr[i].id;
//            }
//            
//            [_rootScrollView addSubview:newsTableView];
//        }
//    }
//    
//    
//    _lastTitleArray = newTitleArr;
//
//    //改变视图的frame， contentsize
//    _rootScrollView.frame = CGRectMake(0, SliderViewH, kDeviceWidth, self.bounds.size.height-SliderViewH);
//    _rootScrollView.contentSize = CGSizeMake(kDeviceWidth*newTitleArr.count, self.bounds.size.height-SliderViewH);
//    _rootScrollView.contentOffset = CGPointMake(0, _rootScrollView.frame.origin.y);
//    [self sliderMenuSelectedAtIndex:newTitleArr.count-1 sliderView:_sliderView];
//}
static  BOOL finish = YES;
#pragma  mark --- slider delegate ----

- (void)sliderMenuSelectedAtIndex:(NSInteger)index sliderView:(SliderView*)slider
{
    if (!finish) {
        NSLog(@"return............\n");
        return;
    }
    
    NSLog(@"click choose at %@", @(index));
    if (self.selectedAtIndexblock) {
        self.selectedAtIndexblock(index ,[_rootScrollView viewWithTag:10000+index]);
    }

    [_sliderView relayoutViewsWithID:index];
    
    if (index > _sliderView.currentIndex + 1) {
        finish = NO;
        UIView *viewWillShow = (UIView *)[_rootScrollView viewWithTag:10000+index];
        UIView *viewWillChange = (UIView *)[_rootScrollView viewWithTag:10000+_sliderView.currentIndex + 1];
        CGRect tempFrame = viewWillShow.frame;
        viewWillShow.frame = viewWillChange.frame;
        viewWillChange.frame = tempFrame;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [_rootScrollView setContentOffset:CGPointMake(_rootScrollView.contentOffset.x + kDeviceWidth, 0)animated:NO];
            
        } completion:^(BOOL finished) {
            
            CGRect tempFrame = viewWillShow.frame;
            viewWillShow.frame = viewWillChange.frame;
            viewWillChange.frame = tempFrame;
            
            [_rootScrollView setContentOffset:CGPointMake(_rootScrollView.contentOffset.x + kDeviceWidth*(index-_sliderView.currentIndex-1), 0)animated:NO];
            _sliderView.currentIndex = index;
            finish = YES;
        }];
        
        
    }else if (index <_sliderView.currentIndex - 1)
    {
        finish = NO;
        UIView *viewWillShow = (UIView *)[_rootScrollView viewWithTag:10000+index];
        UIView *viewWillChange = (UIView *)[_rootScrollView viewWithTag:10000+_sliderView.currentIndex - 1];
        CGRect tempFrame = viewWillShow.frame;
        viewWillShow.frame = viewWillChange.frame;
        viewWillChange.frame = tempFrame;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [_rootScrollView setContentOffset:CGPointMake(_rootScrollView.contentOffset.x - kDeviceWidth, 0)animated:NO];
            
        } completion:^(BOOL finished) {
            
            CGRect tempFrame = viewWillShow.frame;
            viewWillShow.frame = viewWillChange.frame;
            viewWillChange.frame = tempFrame;
            
            [_rootScrollView setContentOffset:CGPointMake(_rootScrollView.contentOffset.x- kDeviceWidth*(_sliderView.currentIndex - index - 1), 0)animated:NO];
            _sliderView.currentIndex = index;
            finish = YES;

        }];
        
    }else if (index == _sliderView.currentIndex + 1)
    {
        finish = NO;
        [UIView animateWithDuration:0.25 animations:^{
            [_rootScrollView setContentOffset:CGPointMake(_rootScrollView.contentOffset.x + kDeviceWidth, 0)animated:NO];
            
        } completion:^(BOOL finished) {
            _sliderView.currentIndex = index;
            finish = YES;
        }];
        

    }else if (index == _sliderView.currentIndex - 1)
    {
        finish = NO;
        [UIView animateWithDuration:0.25 animations:^{
            [_rootScrollView setContentOffset:CGPointMake(_rootScrollView.contentOffset.x - kDeviceWidth, 0)animated:NO];
            
        } completion:^(BOOL finished) {
            _sliderView.currentIndex = index;
            finish = YES;
        }];
        

    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView) {
        _sliderView.selected = NO;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView) {
        if (scrollView.contentOffset.x < scrollView.contentSize.width && scrollView.contentOffset.x >= 0 ) {
            NSInteger num = scrollView.contentOffset.x/kDeviceWidth;
            _sliderView.currentIndex = num;
            [_sliderView updateViewWithID:num];
            [_sliderView relayoutViewsWithID:num];

            if (self.selectedAtIndexblock) {
                self.selectedAtIndexblock(num,[_rootScrollView viewWithTag:10000+num]);
            }
        }
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _rootScrollView && !_sliderView.selected) {
        if (_titleArray.count > 3) {
        
            [_sliderView moveFlagImageWith:scrollView.contentOffset allSize:scrollView.contentSize];
        }else
        {
//            [_sliderView adjustFlagImageWith:scrollView.contentOffset items:(int)_titleArray.count];
            [_sliderView moveFlagImageWith:scrollView.contentOffset allSize:scrollView.contentSize];

        }
        
    }
}

@end
