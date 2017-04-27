//
//  MWLViewPageVC.m
//  MWLViewPageVC
//
//  Created by maweilong-PC on 2017/4/7.
//  Copyright © 2017年 maweilong. All rights reserved.
//

#import "MWLViewPageVC.h"
#import "MWLPageTopVeiw.h"
#import "MWLViewPageBaseSubVC.h"
#import "PageViewHeader.h"
@interface MWLViewPageVC () <UIScrollViewDelegate>

@property (nonatomic) NSInteger CurrentIndex;
@property (nonatomic,strong) MWLPageTopVeiw *topView;
@property (nonatomic,strong) UIScrollView *contentScroller;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation MWLViewPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    UIView *statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, -20,    self.view.bounds.size.width, 20)];
    statusBarView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:statusBarView];
    _dataArray = @[@"有声",@"家居",@"电竞",@"美容",@"电视剧",@"搏击",@"健康",@"摄影",@"生活",@"旅游"];
    self.navigationController.navigationBar.translucent = NO;
    [self initTopView];
    [self initContentScroller];
    [self initSubController];
    [self TopItemSelected:0];
    
}



- (void)initTopView{
    
    _topView = [[MWLPageTopVeiw alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kItemHeigth)];
    [_topView renderUIWithArray:_dataArray];
    _topView.itemWidth = kItemWidth;
    _topView.itemHeigth = kItemHeigth;
    _topView.spaceWidth = kItemSpace;
    __block typeof(self) weakSelf = self;
    
    [_topView addSelectItemClickBlock:^(NSInteger index) {
        NSLog(@"-----0------");
        [weakSelf TopItemSelected:index];
    }];
    [self.view addSubview:_topView];
    
}

- (void)initContentScroller{
    _contentScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topView.bottom, self.view.width, self.view.height - _topView.bottom)];
    _contentScroller.showsHorizontalScrollIndicator = NO;
    _contentScroller.delegate = self;
    _contentScroller.bounces = NO;
    _contentScroller.pagingEnabled = YES;
    _contentScroller.contentSize = CGSizeMake(_contentScroller.width * _dataArray.count, _contentScroller.height);
    [self.view addSubview:_contentScroller];
}
//创建移动的controller
- (void)initSubController{
     NSLog(@"-----2------");
    NSLog(@"====yx======%zi",_CurrentIndex);
    MWLViewPageBaseSubVC *vc = [self getSubController];
    if (vc) {
        UIView *contentView = vc.view;
        contentView.frame = CGRectMake(_CurrentIndex * _contentScroller.width, 0, _contentScroller.width, _contentScroller.height);
        [_contentScroller addSubview:contentView];
    }
    
}

//选中的头部item
- (void)TopItemSelected:(NSInteger)index{
    [self TopItemSelected:index needAnimation:YES];
}

- (void)TopItemSelected:(NSInteger)index needAnimation:(BOOL)needAnimation{
    NSLog(@"-----1------");
    if (_CurrentIndex == index) {
        [UIView animateWithDuration:0.5 animations:^{
            _topView.itemView.backgroundColor = [UIColor redColor];
        }];
    }else{
        _CurrentIndex = index;
        _topView.itemView.backgroundColor = [UIColor whiteColor];
    }
    [_contentScroller setContentOffset:CGPointMake(index * _contentScroller.width, 0) animated:YES];
    
    [self initSubController];
    
}

//初始化MWLViewPageBaseSubVC 视图
- (MWLViewPageBaseSubVC *)getSubController{
    MWLViewPageBaseSubVC *VC = [[MWLViewPageBaseSubVC alloc] init];
    [self addChildViewController:VC];
    VC.index = _CurrentIndex;
    [VC didMoveToParentViewController:self];
    return VC;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

    CGFloat pageRate = scrollView.contentOffset.x / scrollView.contentSize.width;
    NSLog(@"-----3------");
    if (((int)(pageRate*1000))%1000<1) {
        int page = (int)pageRate;//当前获取的page
        if (_CurrentIndex != page) {
            _CurrentIndex = page;
            [self TopItemSelected:page];
        }
    }
    
    CGFloat rate = scrollView.contentOffset.x/scrollView.contentSize.width;
    CGFloat TopWidth = _topView.TopScrollView.contentSize.width;
    CGFloat markwidth = _topView.markView.width;
    UIView *markView = _topView.markView;
    
    //当前item的位置中心X
    CGFloat centerX = TopWidth * rate + (markwidth + kItemSpace)/2 ;
    if (centerX <= self.view.width/2) {
        _topView.TopScrollView.contentOffset = CGPointMake(0, 0);
        markView.frame = CGRectMake((_CurrentIndex)*(kItemWidth+kItemSpace), markView.top, markView.width, markView.height);
    }
//    NSLog(@"===%f======%f====%f===%f===%f====%f=== ",scrollView.contentOffset.x,scrollView.contentSize.width,rate,centerX,TopWidth,TopWidth - self.view.width/2);
    if (centerX > self.view.width/2 && centerX < TopWidth - self.view.width/2) {
        _topView.TopScrollView.contentOffset = CGPointMake(centerX - self.view.width/2, 0);
        markView.frame = CGRectMake(self.view.width/2-(markwidth+kItemSpace)/2, markView.top, markView.width, markView.height);
        
    }
    
    if (centerX >= TopWidth - self.view.width/2) {
        _topView.TopScrollView.contentOffset = CGPointMake(TopWidth -self.view.width, 0);
        markView.frame = CGRectMake(self.view.width/2+TopWidth*rate-(TopWidth-self.view.width/2), markView.top, markView.width, markView.height);
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
