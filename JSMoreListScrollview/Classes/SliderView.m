//
//  SliderView.m
//  Created by 何助金 on 15/4/25.
//  Copyright (c) 2015年 何助金. All rights reserved.
//

#import "SliderView.h"
#import "JSBaseCategoryModel.h"
#define WIDTH kDeviceWidth
#define BUTTONID (sender.tag-100)

//滑动id
#define BUTTONSELECTEDID (scrollViewSelectedChannelID - 100)
#define FlagH 2.0

@interface SliderView ()
{
    NSInteger _lastSelectedIndex;
    BOOL _canAdd;
}

@end

@implementation SliderView

@synthesize scrollViewSelectedChannelID;


- (void)dealloc{
    [_buttonOriginXArray removeAllObjects];
    _buttonOriginXArray = nil;
    [_buttonWithArray removeAllObjects];
    _buttonWithArray = nil;
    
    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
    _sliderFlag = nil;
}

- (void)setFontSize:(UIFont *)fontSize{
    _fontSize = fontSize;
    [self updateViewWithTitleArr:_titlesArray];
}

- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    [self updateViewWithTitleArr:_titlesArray];
}

- (void)setSelectedColor:(UIColor *)selectedColor{
    _selectedColor = selectedColor;
    [self updateViewWithTitleArr:_titlesArray];
}

- (id)initWithFrame:(CGRect)frame titles:(NSArray*)titles canAdd:(BOOL)canAdd
{
    self = [super initWithFrame:frame];
    
    if (self) {

        _fontSize = [UIFont systemFontOfSize:20];
        //文字颜色
        _normalColor = kHexRGB(0xDF9980);
        _selectedColor = kHexRGB(0xFFFFFF);

        //self.delegate = self;
        _canAdd = canAdd;
        _titlesArray = titles;
        self.backgroundColor = [UIColor clearColor];
//        kHexRGB(0xB71C26);//color_RGB(233, 232, 240, 1);
        self.pagingEnabled = NO;
        self.clipsToBounds = YES;
        self.directionalLockEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        _userSelectedID = 100;
        _scrollViewSelectedID = 100;
        scrollViewSelectedChannelID = 100;
        _lastSelectedIndex = 0;
        
        self.buttonOriginXArray = [NSMutableArray array];
        self.buttonWithArray = [NSMutableArray array];
        
        UIView *horLine = [[UIView alloc]initWithFrame:CGRectMake(0,frame.size.height-0.5, frame.size.width, 0.5)];
        horLine.tag = 97;
        horLine.backgroundColor = kHexRGB(0xe2e2e2);//color_RGB(207, 207, 213, 1);
//        [self addSubview:horLine];
        [self _initScrollView:titles];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIView *horLine = [self viewWithTag:97];
    if (horLine != nil && _moreThanFour) {
        horLine.frame = CGRectMake(0,self.frame.size.height-1, self.contentSize.width, 1);
    }
}

static   float BUTTON_GAP = 30.0;

- (void)_initScrollView:(NSArray<JSBaseCategoryModel *>*)titles{
   
    _sliderFlag = [[UIImageView alloc]initWithFrame:CGRectMake(25, SliderViewH-FlagH, 25, FlagH)];
    //可以外部設置
    NSBundle *mainBundle = [NSBundle bundleForClass:[SliderView class]];
    
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"JSMoreListScrollview" ofType:@"bundle"]];
    
    if (resourcesBundle == nil) {
        resourcesBundle = mainBundle;
    }
    
    UIImage * flagImage = [UIImage imageNamed:@"slider_flag" inBundle:resourcesBundle compatibleWithTraitCollection:nil];
    _sliderFlag.image = flagImage;
    [self addSubview:_sliderFlag];

    float xPos = 0.0;
    float totalW = 0.0;

    for(int i = 0; i < titles.count; ++i){
//        NSString *titleString = [titles objectAtIndex:i];
        NSString *titleString =[titles objectAtIndex:i].name;
        CGFloat buttonWidth = [titleString boundingRectWithSize:CGSizeMake(150, 30) options:(NSStringDrawingTruncatesLastVisibleLine) attributes:@{NSFontAttributeName :_fontSize} context:nil].size.width;
        totalW += buttonWidth;
    }
    
//    if (totalW < (_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth)) {
//        BUTTON_GAP = ((_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth) - totalW)/(titles.count);
//    }

    
    
    for(int i = 0; i < titles.count; ++i){
        
//        NSString *titleString = [titles objectAtIndex:i];
        NSString *titleString =  [titles objectAtIndex:i].name;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i+100;
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = _fontSize;
        
        
        [button setTitleColor:_normalColor forState:UIControlStateNormal];
        [button setTitleColor:_selectedColor forState:UIControlStateSelected];
        [button setTitle:titleString forState:UIControlStateNormal];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
       
        int buttonWidth = 0;
        buttonWidth = [titleString boundingRectWithSize:CGSizeMake(150, 30) options:(NSStringDrawingTruncatesLastVisibleLine) attributes:@{NSFontAttributeName :_fontSize} context:nil].size.width;
 
        
        if (titles.count > 0) {
            
            _moreThanFour = YES;
            
            button.frame = CGRectMake(xPos, 0, buttonWidth+BUTTON_GAP, SliderViewH - FlagH);
            
            [_buttonOriginXArray addObject:@(xPos)];
            
            xPos += (buttonWidth+BUTTON_GAP);
            
            [_buttonWithArray addObject:@(button.frame.size.width)];
            
        }else{
            _moreThanFour = NO;
            _sliderWidth = (_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth)/(titles.count);
            _sliderFlag.frame = CGRectMake(0, SliderViewH-FlagH, _sliderWidth, FlagH);

            button.frame = CGRectMake(i*_sliderWidth, 0, _sliderWidth, SliderViewH-FlagH);
            //修改为_sliderFlag 与文字同宽，须存储其宽度
            [_buttonWithArray addObject:@(buttonWidth)];

        }
        
        [button addTarget:self action:@selector(sliderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        if(i == 0){
            button.selected = YES;
            float x = BUTTON_GAP*0.5;
            [_sliderFlag setFrame:CGRectMake(x, SliderViewH - FlagH, buttonWidth, FlagH)];
        }
    }
    self.contentSize = CGSizeMake(xPos, SliderViewH);
}
- (void)updateViewWithTitleArr:(NSArray <JSBaseCategoryModel *>*)titles{
    _sliderFlag.frame = CGRectMake(25, SliderViewH-FlagH, 25, FlagH);

    [_buttonOriginXArray removeAllObjects];
    [_buttonWithArray removeAllObjects];
    
    _titlesArray = [titles copy];
    _userSelectedID = 100;
    _scrollViewSelectedID = 100;
    scrollViewSelectedChannelID = 100;
    _lastSelectedIndex = 0;
    _currentIndex = 0;

    
    for (UIView *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn removeFromSuperview];
        }
    }
    
    float xPos = 0.0;
    float totalW = 0.0;
    
    for(int i = 0; i < titles.count; ++i){
        
//        NSString *titleString = [titles objectAtIndex:i];
        NSString *titleString = [titles objectAtIndex:i].name;

        CGFloat buttonWidth = [titleString boundingRectWithSize:CGSizeMake(150, 30) options:(NSStringDrawingTruncatesLastVisibleLine) attributes:@{NSFontAttributeName :_fontSize} context:nil].size.width;
        totalW += buttonWidth;
    }
    
//    BUTTON_GAP = 30;
//    if (totalW < (_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth)) {
//        BUTTON_GAP = ((_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth) - totalW)/(titles.count);
//    }

    
    for(int i = 0; i < titles.count; ++i){
        
//        NSString *titleString = [titles objectAtIndex:i];
        NSString *titleString = [titles objectAtIndex:i].name;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i+100;
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = _fontSize;
        
        
        [button setTitleColor:_normalColor forState:UIControlStateNormal];
        [button setTitleColor:_selectedColor forState:UIControlStateSelected];
        [button setTitle:titleString forState:UIControlStateNormal];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        int buttonWidth = 0;
        buttonWidth = [titleString boundingRectWithSize:CGSizeMake(150, 30) options:(NSStringDrawingTruncatesLastVisibleLine) attributes:@{NSFontAttributeName :_fontSize} context:nil].size.width;
        
        
        if (titles.count > 0) {
            
            _moreThanFour = YES;
            
            button.frame = CGRectMake(xPos, 0, buttonWidth+BUTTON_GAP, SliderViewH - FlagH);
            
            [_buttonOriginXArray addObject:@(xPos)];
            
            xPos += (buttonWidth+BUTTON_GAP);
            
            [_buttonWithArray addObject:@(button.frame.size.width)];
            
        }else{
            _moreThanFour = NO;
            _sliderWidth = (_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth)/(titles.count);
            _sliderFlag.frame = CGRectMake(0, SliderViewH-FlagH, _sliderWidth, FlagH);
            
            button.frame = CGRectMake(i*_sliderWidth, 0, _sliderWidth, SliderViewH-FlagH);
            //修改为_sliderFlag 与文字同宽，须存储其宽度
            [_buttonWithArray addObject:@(buttonWidth)];
        }
        
        [button addTarget:self action:@selector(sliderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        

        if(i == 0){
            button.selected = YES;
            float x = BUTTON_GAP*0.5;
            [_sliderFlag setFrame:CGRectMake(x, SliderViewH - FlagH, buttonWidth, FlagH)];
        }

    }
    self.contentSize = CGSizeMake(xPos, SliderViewH);
    
}
- (void)clickedButtonAtIndex:(NSInteger)index{
    UIButton *button = [self viewWithTag:100+index];
    [self sliderButtonClicked:button];
}

- (void)sliderButtonClicked:(UIButton*)sender{
    
    //选中时
    self.selected = YES;
    
//    if(_moreThanFour){
//        [self adjustScrollViewContentX:sender];
//    }
    
    //如果更换按钮
    if (sender.tag != _userSelectedID) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[self viewWithTag:_userSelectedID];
        lastButton.selected = NO;
        //赋值按钮ID
        _userSelectedID = sender.tag;
    }
    
    //按钮选中状态
    if (!sender.selected) {
        sender.selected = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [_sliderFlag setFrame:CGRectMake(sender.frame.origin.x+BUTTON_GAP*0.5,
                                             SliderViewH-FlagH,
                                             sender.frame.size.width-BUTTON_GAP,
                                             FlagH)];
        
        } completion:^(BOOL finished) {
            if (finished) {
                //赋值滑动列表选择频道ID
                _scrollViewSelectedID = sender.tag;
            }
        }];
//        NSLog(@"%ld",sender.tag);
        if(_sliderDelegate != nil && [_sliderDelegate respondsToSelector:@selector(sliderMenuSelectedAtIndex:sliderView:)]){
    
            [_sliderDelegate sliderMenuSelectedAtIndex:BUTTONID sliderView:self];
        }
    }else{
        //选中状态下进行排序
        if (sender.tag == (self.imageId+100) && self.isImage) {
            if (_isUp) {
                [sender setImage:[UIImage imageNamed:@"price_sort_up"] forState:UIControlStateNormal];
                _isUp = NO;
            }else{
                _isUp = YES;
                [sender setImage:[UIImage imageNamed:@"price_sort_down"] forState:UIControlStateNormal];
            }
            [sender setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -60)];
            [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];

            [[NSNotificationCenter defaultCenter]postNotificationName:kNoticeSortStatusChanged object:[NSNumber numberWithBool:_isUp]];
        }
    }
}

- (void)layoutViewsWithID:(NSInteger)tag{

    UIButton *button = (UIButton*)[self viewWithTag:(tag+100)];
    
    if (button != nil) {
        _isUp = YES;
        [button setImage:[UIImage imageNamed:@"price_sort_up"] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -60)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    }
}

- (void)adjustScrollViewContentX:(UIButton *)sender
{
   // MSLog(@"%f,%f",sender.frame.origin.x,self.contentOffset.x);
    
    NSInteger index = BUTTONID;
    float buttonOriginX = [[_buttonOriginXArray objectAtIndex:index]floatValue];
    
    if (index > _lastSelectedIndex) {
        if ((self.contentSize.width - buttonOriginX) >= (_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth)) {
            [self setContentOffset:CGPointMake( buttonOriginX, 0) animated:YES];
        }else {
            [self setContentOffset:CGPointMake(self.contentSize.width-(_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth), 0) animated:YES];
        }
    }else{
       
//        if (((index - 1)<= 0) && (sender.frame.origin.x - self.contentOffset.x) < [[_buttonOriginXArray objectAtIndex:index-1]floatValue]) {
//            [self setContentOffset:CGPointMake([[_buttonOriginXArray objectAtIndex:index-1]floatValue], 0) animated:YES];
//        }
    }
    
    _lastSelectedIndex = index;
    
//    if (self.contentOffset.x < (self.contentSize.width-WIDTH) && (index != 0)) {
//        [self setContentOffset:CGPointMake((index-1)*_sliderWidth, 0) animated:YES];
//    }
    
//    float originX = [[_buttonOriginXArray objectAtIndex:BUTTONID] floatValue];
//    float width = [[_buttonWithArray objectAtIndex:BUTTONID] floatValue];
//    
//    if ((sender.frame.origin.x - self.contentOffset.x) > (WIDTH-width)) {
//        [self setContentOffset:CGPointMake(originX - 30, 0)  animated:YES];
//    }
//    
//    if (sender.frame.origin.x - self.contentOffset.x < 5) {
//        [self setContentOffset:CGPointMake(originX,0)  animated:YES];
//    }

}


- (void)setButtonUnSelect
{
    //滑动撤销选中按钮
    UIButton *lastButton = (UIButton *)[self viewWithTag:_scrollViewSelectedID];
    lastButton.selected = NO;
}

- (void)setButtonSelect
{
    //滑动选中按钮
    UIButton *button = (UIButton *)[self viewWithTag:_scrollViewSelectedID];
    
    if (button != nil) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [_sliderFlag setFrame:CGRectMake(button.frame.origin.x+BUTTON_GAP*0.5,
                                             SliderViewH-FlagH,
                                             button.frame.size.width-BUTTON_GAP,
                                             FlagH)];
            
        } completion:^(BOOL finished) {
            if (finished) {
                if (!button.selected) {
                    button.selected = YES;
                    _userSelectedID = button.tag;
                }
            }
        }];
    }
}

- (void)updateViewWithID:(NSInteger)sender{
    [self setButtonUnSelect];
    _scrollViewSelectedID = sender+100;
    [self setButtonSelect];
}


- (void)relayoutViewsWithID:(NSInteger)index
{
    if (_moreThanFour) {
        [self updateViewWithID:index];
        
        float buttonOriginX = 0;
        float buttonW = 0;
        
        if (index < _buttonOriginXArray.count) {
            buttonOriginX = [[_buttonOriginXArray objectAtIndex:index]floatValue];
            buttonW = [[_buttonWithArray objectAtIndex:index]floatValue];
        }
        
        if (self.contentOffset.x + (_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth) < self.contentSize.width && (buttonOriginX + buttonW/2.0 - self.contentOffset.x) > (_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth)/2.0 ){
            //往右滑动满足居中
            if ((self.contentOffset.x +  (buttonOriginX + buttonW/2.0 - self.contentOffset.x)-(_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth)/2.0) + (_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth) < self.contentSize.width) {
                [self setContentOffset:CGPointMake(self.contentOffset.x +  (buttonOriginX + buttonW/2.0 - self.contentOffset.x)-(_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth)/2.0, 0)animated:YES];
            }else
            {
                //不满足居中-到边界
                [self setContentOffset:CGPointMake(self.contentOffset.x + (self.contentSize.width - self.contentOffset.x - (_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth)),0)animated:YES];
            }
            
            
        }else if (self.contentOffset.x > 0 && self.contentOffset.x + (_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth) <= self.contentSize.width && (buttonOriginX + buttonW/2.0 - self.contentOffset.x) < (_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth)/2.0  ) {
            
            if (self.contentOffset.x -((_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth)/2.0 - (buttonOriginX + buttonW/2.0 - self.contentOffset.x))>= 0) {
                [self setContentOffset:CGPointMake(self.contentOffset.x -((_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth)/2.0 - (buttonOriginX + buttonW/2.0 - self.contentOffset.x)) , 0)animated:YES];
            }else
            {
                [self setContentOffset:CGPointMake(0 , 0)animated:YES];
            }
        }
        
    }else {
        
        [self adjustFlagImageWith:CGPointMake(index*(kDeviceWidth), 0) items:(int)_titlesArray.count];
    }
}


-(void)setScrollViewContentOffset
{
    float originX = [[_buttonOriginXArray objectAtIndex:BUTTONSELECTEDID] floatValue];
    float width = [[_buttonWithArray objectAtIndex:BUTTONSELECTEDID] floatValue];
    
    if (originX - self.contentOffset.x > ((_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth)-width)) {
        [self setContentOffset:CGPointMake(originX - BUTTON_GAP, 0)  animated:YES];
    }
    
    if (originX - self.contentOffset.x < 5) {
        [self setContentOffset:CGPointMake(originX,0)  animated:YES];
    }
}

#pragma mark - 当有多个选项（大于3个时）同步移动flag

- (void)moveFlagImageWith:(CGPoint)currentPoint allSize:(CGSize)size
{
    int index = (int)(currentPoint.x/ kDeviceWidth);
   
    int next = 0;
    
    if (index+1 >= _buttonWithArray.count) {
        next = index;
    }else{
        next = index + 1;
    }
    
    float width = [[_buttonWithArray objectAtIndex:next] floatValue]-BUTTON_GAP;
    
    float currentWidth = [[_buttonWithArray objectAtIndex:index] floatValue]-BUTTON_GAP;
    
    CGRect frame = _sliderFlag.frame;
    
    float buttonOrigin = [[_buttonOriginXArray objectAtIndex:index]floatValue]+BUTTON_GAP*0.5;
    
    int x = (int)currentPoint.x;
    
    int num = x % (int)kDeviceWidth ;
    
    float offset = width - currentWidth;
    
    frame.size.width = currentWidth + offset*num/kDeviceWidth;
    
    frame.origin.x = buttonOrigin + ((BUTTON_GAP + currentWidth)*num / kDeviceWidth);
    
    _sliderFlag.frame = frame;
}


#pragma mark - 当选项小于3个时同步移动flag

- (void)adjustFlagImageWith:(CGPoint)currentPoint items:(int)item
{
    int index = (int)(currentPoint.x/(kDeviceWidth));
    
    int x = (int)currentPoint.x;

    int num = x % (int)(kDeviceWidth);
    
    float currentWidth = (kDeviceWidth) / item;
    
    CGRect frame = _sliderFlag.frame;
    
//    frame.origin.x = index * currentWidth + (currentWidth*num / kDeviceWidth);
//    修改为下划线与文字同宽度 调整_sliderFlag x坐标
    frame.origin.x = index * currentWidth + (currentWidth*num / (_canAdd ? kDeviceWidth - ADD_BTN_WIDTH : kDeviceWidth)) + (currentWidth-[_buttonWithArray[num] floatValue])/2.0;
    
    _sliderFlag.frame = frame;
}


@end
