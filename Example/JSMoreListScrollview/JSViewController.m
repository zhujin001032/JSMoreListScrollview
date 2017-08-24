//
//  JSViewController.m
//  JSMoreListScrollview
//
//  Created by jasonhe on 08/24/2017.
//  Copyright (c) 2017 jasonhe. All rights reserved.
//

#import "JSViewController.h"
#import <JSMoreListScrollview/MoreList.h>
#import "JSDemoCategory.h"
#define kCurrentCategory @"CurrentCategory"
#define kHexRGBAlpha(rgbValue,a)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:(a)]

@interface JSViewController ()
@property (nonatomic,strong) NSMutableArray *dataArr;//API 返回数据
@property (nonatomic,strong) MoreListScrollview *moreListView;
@end

@implementation JSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadListView];
}

- (void)loadListView
{
//    与本地存储的比较
    NSArray *userChooseArr = [[NSUserDefaults standardUserDefaults] arrayForKey:@"CurrentCategory"];
    NSMutableArray *unseletcArr = [NSMutableArray array];
    NSMutableArray *allModelIdArr = [NSMutableArray array];
    NSMutableDictionary *idForModel = [NSMutableDictionary dictionary];


    for (JSBaseCategoryModel *model in _dataArr) {
        [allModelIdArr addObject:@(model.id)];
        [idForModel setObject:model forKey:@(model.id)];
    }
    
    
    if (!userChooseArr) {
        userChooseArr = allModelIdArr;
        [[NSUserDefaults standardUserDefaults] setObject:userChooseArr forKey:kCurrentCategory];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{
        //1.移除没有用的
        NSMutableArray *selectArr = [NSMutableArray arrayWithArray:userChooseArr];
        for(NSNumber *modelId in userChooseArr){
            if (![allModelIdArr containsObject:modelId]) {
                [selectArr removeObject:modelId];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:selectArr forKey:kCurrentCategory];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //2.用户没有选择的设置为unselectArr
        for (NSNumber *modelId in allModelIdArr) {
            if (![selectArr containsObject:modelId]) {
                [unseletcArr addObject:modelId];
            }
        }
    }
//
    //根据id 转化为model
    NSMutableArray *selectModelArray = [NSMutableArray array];
    NSMutableArray *unSelectModelArray = [NSMutableArray array];
//
    for (NSNumber *num in [[NSUserDefaults standardUserDefaults] arrayForKey:kCurrentCategory]) {
        JSDemoCategory *catModel = [idForModel objectForKey:num];
        [selectModelArray addObject:catModel];
    }
    
    for (NSNumber *num in  unseletcArr) {
        JSDemoCategory *catModel = [idForModel objectForKey:num];
        [unSelectModelArray addObject:catModel];
        
    }

    for (NSInteger i = 0; i < 5; i ++) {
        JSDemoCategory *ct = [[JSDemoCategory alloc]init];
        ct.id = i;
        ct.name = [NSString stringWithFormat:@"分类-%@",@(i)];
        [selectModelArray addObject:ct];
    }
    
    
    MoreListScrollview *moreListView = [[MoreListScrollview alloc] initWithFrame:CGRectMake(0,
                                                                                            20,
                                                                                            kDeviceWidth,
                                                                                            kDeviceHeight-20)
                                                                  withTitleArray:selectModelArray
                                                                   withDataArray:unSelectModelArray
                                                                       withOwner:self
                                                                          canAdd:YES];
    
    __weak MoreListScrollview *weakListView = moreListView;
    
    moreListView.selectedColor = [UIColor redColor];
    
    //渐变色背景
    UIView *toolbgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    toolbgView.backgroundColor = kHexRGB(0xB71C26);

    [moreListView addSubview:toolbgView];
    [moreListView sendSubviewToBack:toolbgView];
    [self addColorLayrAtView:toolbgView];
    
    [moreListView setSelectedAtIndexblock:^(NSInteger index, id obj) {
        // 点选择或滑动选择 block
//TODO:UITableView 替换成自定义tbaleView 必须有属性.owner = self
        UITableView *newsTabelView = (UITableView *)obj;
        
        if ([newsTabelView isKindOfClass:[UITableView class]]) {
            if (index == 0) {
                //              首頁固定位置
//                newsTabelView.newsCatID = _dataArr[0].id;
//                newsTabelView.bannerSpace = _dataArr[0].banner_spacing;
                
            }else{
//                newsTabelView.newsType = NewsType_List;
//                
//                if(!(newsTabelView.newsCatID>0)){
                    for (JSDemoCategory *model in _dataArr) {
                        JSDemoCategory *model_select = (JSDemoCategory *)weakListView.selectedArray[index];
                        if (model.id == model_select.id){
                            
//                            newsTabelView.newsCatID = model.id;
                            NSLog(@"选中modelId = %@",@(model.id));

                        }
                    }
//
//                }
            }
//
//            if(newsTabelView.currentIndex == -1) {
//                [newsTabelView fetchHomeInfo:newsTabelView.newsType pageIndex:1];
//            }
        }
    }];
    
    //for edit items
    [moreListView setEditBlock:^{
        //   NewsTagViewController *tagVC = [[NewsTagViewController alloc]init];
        //    [tagVC.selectedArray addObjectsFromArray: _selectedArray];
        //
        //    [tagVC.unselectedArray addObjectsFromArray: _unselectedArray];
        //    __weak MoreListScrollview *weakListView = moreListView;

        //    [tagVC setNewsTagEditBlock:^(NSArray *selectedArr, NSArray *unSelectedArr) {
        //        [weakListView.selectedArray removeAllObjects];
        //        [weakListView.unselectedArray removeAllObjects];
        //
        //
        //        NSMutableArray *arr = [NSMutableArray array];
        //
        //        [arr addObjectsFromArray:ws.selectedArray];
        //        [arr addObjectsFromArray:selectedArr];
        //
        //        [weakListView.selectedArray addObjectsFromArray: selectedArr];
        //        [weakListView.unselectedArray addObjectsFromArray: unSelectedArr];
        //
        //        weakListView.titleArray = selectedArr;
        //        [weakListView updateListViewWithTitleArray:selectedArr];
        //        NSMutableArray *tempArr = [NSMutableArray array];
        //
        //        //save model id
        //        for (NewsCategoryModel *model in weakListView.selectedArray) {
        //            [tempArr addObject: @(model.id)];
        //            [UDf setObject:tempArr forKey:kCurrentChannelCN];
        //            [UDf synchronize];
        //        }
        //
        //
        //    }];
        
        //    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tagVC];
        //    [self.navigationController presentViewController:nav animated:YES completion:^{
        //        
        //    }];

        
    }];
    
    moreListView.tag = 6789;
    [self.view addSubview:moreListView];
    _moreListView = moreListView;
    
    [self createListViewsWithTitleArray:selectModelArray];
}


- (void)createListViewsWithTitleArray:(NSArray < id>*)titleArray
{
    //TODO:UITableView 替换成自定义tbaleView

    for (int i = 0; i < titleArray.count; ++i) {
        UITableView *newsTableView = nil;
        newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(i*kDeviceWidth,
                                                                      0,
                                                                      kDeviceWidth,
                                                                      _moreListView.bounds.size.height-SliderViewH)
                                                     style:UITableViewStylePlain];
        newsTableView.tag = i + 10000;
        //        newsTableView.owner = self.owner;
        
        
        //        // 加载首个页面
        //
        if (i == 0) {
            //            newsTableView.newsType = NewsType_Main;
            //            newsTableView.newsCatID = [[MSCoreManager sharedManager].settingModel.cat_option.home integerValue];
            //            [newsTableView fetchHomeInfo:NewsType_Main pageIndex:1];
        }else{
            //            newsTableView.newsType = NewsType_List;
            //            newsTableView.newsCatID = titleArray[i].id;
        }
        
        [_moreListView.rootScrollView addSubview:newsTableView];
    }
}


- (void)updateListViewWithTitleArray:(NSArray <JSBaseCategoryModel * >*)newTitleArr{
    
    [_moreListView.selectedArray removeAllObjects];
    [_moreListView.selectedArray addObjectsFromArray:newTitleArr];
    [_moreListView.sliderView updateViewWithTitleArr:newTitleArr];
    
    for (NSInteger i = 0; i < _moreListView.lastTitleArray.count; i++) {
        //1.移除不需要的
        if(![newTitleArr containsObject:_moreListView.lastTitleArray[i]]){
            UITableView *tableView = [_moreListView.rootScrollView viewWithTag:i + 10000];
            if (tableView) {
                [tableView removeFromSuperview];
            }
            
        }
    }
    
    for (NSInteger i = 0; i < newTitleArr.count; i++) {
        // 2.保留且設置好位置
        if ([_moreListView.lastTitleArray containsObject: newTitleArr[i]]) {
            NSInteger index = [_moreListView.lastTitleArray indexOfObject:newTitleArr[i]];
            UITableView *tableView = [_moreListView.rootScrollView viewWithTag:index + 10000];
            tableView.tag = i+10000;
            tableView.frame = CGRectMake(i*kDeviceWidth,
                                         0,
                                         kDeviceWidth,
                                         _moreListView.bounds.size.height-SliderViewH);
        }else{
            
            
        }
    }
    
    
    //TODO:UITableView 替换成自定义tbaleView

    for (NSInteger i = 0; i < newTitleArr.count; i++) {
        //3.創建新的
        if (![_moreListView.lastTitleArray containsObject:newTitleArr[i]]) {
            UITableView *newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(i*kDeviceWidth,
                                                                                       0,
                                                                                       kDeviceWidth,
                                                                                       _moreListView.bounds.size.height-SliderViewH)
                                                                      style:UITableViewStylePlain];
            newsTableView.tag = i + 10000;
            //            newsTableView.owner = self.owner;
            
            //        // 加载首个页面
            //
            if (i == 0) {
                //                newsTableView.newsType = NewsType_Main;
                //                newsTableView.newsCatID = newTitleArr[i].id;
                //                [newsTableView fetchHomeInfo:NewsType_Main pageIndex:0];
            }
            else{
                //                newsTableView.newsType = NewsType_List;
                //                newsTableView.newsCatID = newTitleArr[i].id;
            }
            
            [_moreListView.rootScrollView addSubview:newsTableView];
        }
    }
    
    
    _moreListView.lastTitleArray = newTitleArr;
    
    //改变视图的frame， contentsize
    _moreListView.rootScrollView.frame = CGRectMake(0, SliderViewH, kDeviceWidth, _moreListView.bounds.size.height-SliderViewH);
    _moreListView.rootScrollView.contentSize = CGSizeMake(kDeviceWidth*newTitleArr.count, _moreListView.bounds.size.height-SliderViewH);
    _moreListView.rootScrollView.contentOffset = CGPointMake(0, _moreListView.rootScrollView.frame.origin.y);
    //设置选中最后item
    [_moreListView sliderMenuSelectedAtIndex:newTitleArr.count-1 sliderView:_moreListView.sliderView];
}

- (void)editItems:(id)sender{
    // to do add / del items
    
    //    NewsTagViewController *tagVC = [[NewsTagViewController alloc]init];
    //    [tagVC.selectedArray addObjectsFromArray: _selectedArray];
    //
    //    [tagVC.unselectedArray addObjectsFromArray: _unselectedArray];
    //    WS(ws)
    //    [tagVC setNewsTagEditBlock:^(NSArray *selectedArr, NSArray *unSelectedArr) {
    //        [ws.selectedArray removeAllObjects];
    //        [ws.unselectedArray removeAllObjects];
    //
    //
    //        NSMutableArray *arr = [NSMutableArray array];
    //
    //        [arr addObjectsFromArray:ws.selectedArray];
    //        [arr addObjectsFromArray:selectedArr];
    //
    //        [ws.selectedArray addObjectsFromArray: selectedArr];
    //        [ws.unselectedArray addObjectsFromArray: unSelectedArr];
    //
    //        ws.titleArray = selectedArr;
    //        [ws updateListViewWithTitleArray:selectedArr];
    //        NSMutableArray *tempArr = [NSMutableArray array];
    //
    //        //save model id
    //        for (NewsCategoryModel *model in ws.selectedArray) {
    //            [tempArr addObject: @(model.id)];
    //            [UDf setObject:tempArr forKey:kCurrentChannelCN];
    //            [UDf synchronize];
    //        }
    //
    //
    //    }];
    
    //    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tagVC];
    //    [self.owner.navigationController presentViewController:nav animated:YES completion:^{
    //        
    //    }];
}


- (void)addColorLayrAtView:(UIView *)baseView{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = baseView.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)kHexRGBAlpha(0xffffff, 0.8).CGColor,
                       (id)kHexRGBAlpha(0xDF9980, 0.5).CGColor,
                       (id)kHexRGBAlpha(0xffffff, 0.9).CGColor,
                       nil];
    gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(1, 0.5);
    [baseView.layer addSublayer:gradient];
    //    gradient.opaque = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
