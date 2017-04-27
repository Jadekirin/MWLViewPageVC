//
//  MWLTabBarView.m
//  MWLViewPageVC
//
//  Created by maweilong-PC on 2017/4/12.
//  Copyright © 2017年 maweilong. All rights reserved.
//

#import "MWLTabBarView.h"
#import "PageViewHeader.h"
#import "MWLTabBarCollectionCell.h"

#define HYScreenW [UIScreen mainScreen].bounds.size.width
#define HYScreenH [UIScreen mainScreen].bounds.size.height
static CGFloat const topBarItemMargin = 15; ///标题之间的间距
static CGFloat const topbarHeight = 40 ;//标签栏的高度

@interface MWLTabBarView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic) NSInteger topBarWidth;//标签栏的宽度
@property (nonatomic) NSInteger selectedIndex;//选中的item
@property (nonatomic) NSInteger preSelectedindex;//上次选中的item
@property (nonatomic,strong) UIScrollView *tabbarScroll;
@property (nonatomic,strong) UICollectionView *contentView;
@property (nonatomic,strong) NSMutableArray *subControllers;

@property (nonatomic,strong) NSMutableArray *tabBarTitleArr;

@end

@implementation MWLTabBarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _selectedIndex = 0;
        _preSelectedindex = 0;
        
//        _topBarWidth = topBarItemMargin;
        [self initUpSubView];
    }
    return self;
}

- (NSMutableArray *)subControllers{
    if (!_subControllers) {
        _subControllers = [[NSMutableArray alloc] init];
    }
    return _subControllers;
}

- (NSMutableArray *)tabBarTitleArr{
    if (!_tabBarTitleArr) {
        _tabBarTitleArr = [[NSMutableArray alloc] init];
    }
    return _tabBarTitleArr;
}

//添加子控件
- (void)initUpSubView{
    
    _tabbarScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _tabbarScroll.backgroundColor = [UIColor lightGrayColor];
    _tabbarScroll.bounces = NO;
    _tabbarScroll.showsHorizontalScrollIndicator = NO;
    [self addSubview:_tabbarScroll];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = (CGSize){self.frame.size.width,(self.frame.size.height - topbarHeight)};
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    
    _contentView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self addSubview:_contentView];
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.pagingEnabled = YES;
    _contentView.bounces = NO;
    _contentView.delegate = self;
    _contentView.dataSource = self;
    _contentView.backgroundColor = [UIColor redColor];
    
    [_contentView registerClass:[MWLTabBarCollectionCell class] forCellWithReuseIdentifier:@"MWLTabBarCollectionCell"];
//    [_contentView registerNib:[UINib nibWithNibName:@"MWLTabBarCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"MWLTabBarCollectionCell"];
    
    
    //添加监听
    [self addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionOld |NSKeyValueObservingOptionNew context:@"scrollToNextItem"];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    UIViewController * vc = [self getViewController];
    vc.automaticallyAdjustsScrollViewInsets = NO;
    
    //重写各控件的frame
    self.tabbarScroll.frame = CGRectMake(0, 0, self.bounds.size.width, topbarHeight);
    self.tabbarScroll.contentSize = CGSizeMake(_topBarWidth, 0);
    
    self.contentView.frame = CGRectMake(0, CGRectGetMaxY(self.tabbarScroll.frame), self.bounds.size.width, self.bounds.size.height - topbarHeight);
    
    CGFloat btnX = topBarItemMargin;
    for ( int index = 0; index < self.tabBarTitleArr.count; index++) {
        UIButton *btn = self.tabbarScroll.subviews[index];
        btn.frame = CGRectMake(btnX, 0, btn.width, topbarHeight);
        btnX += btn.width + topBarItemMargin;
    }
    [self itemSelectedIndex:0];
    
}

- (void)itemSelectedIndex:(NSInteger)index{
    UIButton *prebtn = self.tabBarTitleArr[_preSelectedindex];
    prebtn.selected = NO;
    _selectedIndex = index;
    _preSelectedindex = _selectedIndex;
    UIButton *selectBtn = self.tabBarTitleArr[_selectedIndex];
    selectBtn.selected = YES;
    [UIView animateWithDuration:0.5 animations:^{
            
        prebtn.titleLabel.font = [UIFont systemFontOfSize:15];
        selectBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    }];
    
}

#pragma mark  - UICollectionView 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.subControllers.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MWLTabBarCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MWLTabBarCollectionCell" forIndexPath:indexPath];
    cell.SubView = self.subControllers[indexPath.row];
    return cell;
}

// scroll 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if(self.selectedIndex != (scrollView.contentOffset.x + HYScreenW * 0.5) / HYScreenW){
        
    self.selectedIndex = (scrollView.contentOffset.x + HYScreenW * 0.5) / HYScreenW;
    }
}
//item 点击事件
- (void)ItemClick:(UIButton *)btn{
    NSInteger index = [self.tabBarTitleArr indexOfObject:btn];
    _selectedIndex = index;
    
    [self itemSelectedIndex:_selectedIndex];
    //下面的cell移动
    self.contentView.contentOffset = CGPointMake(index * self.width, 0);
    [_contentView reloadData];
}

#pragma mark - KVO监听方法

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if (context == @"scrollToNextItem") {
        [self itemSelectedIndex:self.selectedIndex];
        UIButton *btn = self.tabBarTitleArr[self.selectedIndex];
        
        //计算偏移量
        CGFloat offset = btn.center.x - self.width/2;
        if (offset < 0) {
            offset = 0;
        }
        
        //获取最大滚动范围
        CGFloat MaxOffset = self.tabbarScroll.contentSize.width - self.width;
        if (offset > MaxOffset) {
            offset = MaxOffset;
        }
        [self.tabbarScroll setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
}

#pragma mark - 创建Controller
- (UIViewController *)getViewController{
    
    for (UIView *next = [self superview]; next; next = next.superview) {
        //相应器
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
        
    }
    return nil;
}

#pragma mark - 对外接口
- (void)addSubItemWithControllers:(UIViewController *)controller{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tabbarScroll addSubview:btn];
    [self.tabBarTitleArr addObject:btn];
    [self setUpButton:btn title:controller.title];
    [btn addTarget:self action:@selector(ItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.subControllers addObject:controller];
    
}
- (void)setUpButton:(UIButton *)btn title:(NSString *)title{
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateSelected];
    
    [btn sizeToFit];
    _topBarWidth += btn.frame.size.width + topBarItemMargin;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
}
- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"selectedIndex"];

}
@end
