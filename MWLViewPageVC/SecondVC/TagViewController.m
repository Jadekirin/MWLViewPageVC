//
//  TagViewController.m
//  MWLViewPageVC
//
//  Created by maweilong-PC on 2017/4/13.
//  Copyright © 2017年 maweilong. All rights reserved.
//

#import "TagViewController.h"
#import "PageViewHeader.h"
static CGFloat const ClVHeaderHeigth = 40; //头视图高度
//#import "ChannelViewCell.h"
@interface TagViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSIndexPath *_IndexPath;
    NSIndexPath *_targetIndexPath;
}
@property (nonatomic) BOOL IsEidt;
@property (nonatomic,strong) NSArray *headerArr;
@property (nonatomic,strong) NSMutableArray *selectedArr;
@property (nonatomic,strong) NSMutableArray *recommendArr;
@property (nonatomic,strong) UICollectionView *CollectionView;
@property (nonatomic,strong) ChannelViewCell *dragItem;

//@property (nonatomic,strong) UICollectionViewCell *ChannelViewCell;

@end

@implementation TagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"标签";
//    self.IsEidt = NO;
    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    _headerArr = @[@[@"切换频道",@"点击添加更多频道"],@[@"长按拖动排序",@"点击添加更多频道"]];
    _selectedArr = [NSMutableArray arrayWithObjects:@"推荐",@"河北",@"财经",@"娱乐",@"体育",@"社会",@"NBA",@"视频",@"汽车",@"图片",@"科技",@"军事",@"国际",@"数码",@"星座",@"电影",@"时尚",@"文化",@"游戏",@"教育",@"动漫",@"政务",@"纪录片",@"房产",@"佛学",@"股票",@"理财", nil];
    
    _recommendArr = [NSMutableArray arrayWithObjects:@"有声",@"家居",@"电竞",@"美容",@"电视剧",@"搏击",@"健康",@"摄影",@"生活",@"旅游",@"韩流",@"探索",@"综艺",@"美食",@"育儿",nil];
    
    [self initUpCollcentionView];
}

- (void)viewWillDisappear:(BOOL)animated{
    //回传数组
    if (self.SenderBlock) {
        self.SenderBlock(self.selectedArr);
    }
}

- (void)initUpCollcentionView{
    UICollectionViewFlowLayout *Layout = [[UICollectionViewFlowLayout alloc] init];
//    Layout.itemSize = CGSizeMake(self.view.width, self.view.height);
    Layout.minimumLineSpacing = 10;
    
    self.automaticallyAdjustsScrollViewInsets=YES;
    _CollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:Layout];
    _CollectionView.bounces = NO;
    _CollectionView.delegate = self;
    _CollectionView.dataSource = self;
    _CollectionView.backgroundColor = [UIColor whiteColor];
    [_CollectionView registerClass:[ChannelViewCell class] forCellWithReuseIdentifier:@"ChannelCellId"];
    [_CollectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderView"];
    
    self.dragItem = (ChannelViewCell *)[[ChannelViewCell alloc] initWithFrame:CGRectMake(0, 0,(self.view.frame.size.width - 60)/5 , 30)];
    self.dragItem.hidden = YES;
    [self.view addSubview:_CollectionView];
    [self.CollectionView addSubview:self.dragItem];
    
    UILongPressGestureRecognizer *Gap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(PressGesture:)];
    [self.CollectionView addGestureRecognizer:Gap];
}


- (void)PressGesture:(UILongPressGestureRecognizer *)tap{
//    _IndexPath = [_CollectionView indexPathForItemAtPoint:<#(CGPoint)#>];
    if (!self.IsEidt) {
        self.IsEidt = !self.IsEidt;
        [_CollectionView reloadData];
        return;
    }
    CGPoint point = [tap locationInView:_CollectionView];
    
    //根据手势的状态判断
    switch (tap.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegan:point];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragChanged:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragEnd:point];
            break;
        case UIGestureRecognizerStateCancelled:
            [self dragEnd:point];
            break;
        default:
            break;
    }
}

#pragma mark - 手势状态事件的响应
- (void)dragBegan:(CGPoint)point{
    //长按开始
    //获取当前点击cell的 IndexPath
    _IndexPath = [_CollectionView indexPathForItemAtPoint:point];
    
    //判断不能响应长按手势的cell
    if (_IndexPath == nil || _IndexPath.section > 0 || _IndexPath.item == 0) {
        return;
    }
    
    ChannelViewCell *cell = (ChannelViewCell *)[_CollectionView cellForItemAtIndexPath:_IndexPath];
    cell.hidden = YES;
    self.dragItem.frame = cell.frame;
    self.dragItem.hidden = NO;
    [self.dragItem initCellWithTitle:cell.titleLabel.text];
    self.dragItem.transform = CGAffineTransformMakeScale(1.2, 1.2);
    
    
}
- (void)dragChanged:(CGPoint)point{
    //长按过程
    
    //判断不能响应长按手势的cell
    if (_IndexPath == nil || _IndexPath.section > 0 || _IndexPath.item == 0) {
        return;
    }
    _dragItem.center = point;
    //获取目标IndexPath
    _targetIndexPath = [_CollectionView indexPathForItemAtPoint:point];
    if (_targetIndexPath == nil || _targetIndexPath.section > 0 || _IndexPath == _targetIndexPath || _targetIndexPath.item == 0) {
        return;
    }
    
    //更新数据
    NSString *obj = _selectedArr[_IndexPath.item];
    [_selectedArr removeObject:obj];
    [_selectedArr insertObject:obj atIndex:_targetIndexPath.item];
    //交换位置
    [_CollectionView moveItemAtIndexPath:_IndexPath toIndexPath:_targetIndexPath];
    _IndexPath = _targetIndexPath;
    
}
- (void)dragEnd:(CGPoint)point{
    //长按结束
    if (_IndexPath == nil || _IndexPath.section > 0 || _IndexPath.item == 0) {
        return;
    }
    ChannelViewCell *endCell = (ChannelViewCell *)[_CollectionView cellForItemAtIndexPath:_IndexPath];
    [UIView animateWithDuration:0.25 animations:^{
        self.dragItem.transform = CGAffineTransformIdentity;
        self.dragItem.center = endCell.center;
    } completion:^(BOOL finished) {
        endCell.hidden = NO;
        self.dragItem.hidden = YES;
        _IndexPath = nil;
    }];
}


#pragma mark - collection delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  section == 0 ? _selectedArr.count : _recommendArr.count;//
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ChannelViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChannelCellId" forIndexPath:indexPath];
    
    NSString *Title = indexPath.section == 0 ? self.selectedArr[indexPath.item] : self.recommendArr[indexPath.row];//
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.IsHidden = YES;
    }else{
        cell.IsHidden = !_IsEidt ;
    }
     [cell initCellWithTitle:Title];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    CollectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderView" forIndexPath:indexPath];
    header.backgroundColor = [UIColor lightGrayColor];
    NSArray *arr =  self.IsEidt == NO ? self.headerArr[0] : self.headerArr[1];
    header.IsSelected = self.IsEidt;
    [header initUpHeaderWithTitle:arr[indexPath.section]];
    [header.EidtButton setHidden:indexPath.section == 0 ? NO : YES];
    [header HeaderBtnIsClickBlock:^(BOOL IsEidt) {
        self.IsEidt = IsEidt;

        [_CollectionView reloadData];
    }];
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.IsEidt ) {
        if (indexPath.section == 0 && indexPath.row != 0) {
            NSString *obj = _selectedArr[indexPath.row];
            [_selectedArr removeObject:obj];
            [_recommendArr insertObject:obj atIndex:0];
        }else if (indexPath.section == 1){
            NSString *obj = _recommendArr[indexPath.row];
            [_recommendArr removeObject:obj];
            [_selectedArr addObject:obj];
        }
        [_CollectionView reloadData];
    }else{
        //回传数组
        if (self.SenderBlock) {
            self.SenderBlock(self.selectedArr);
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.width, ClVHeaderHeigth);
}



- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect offset =[UIScreen mainScreen].bounds;
    return CGSizeMake((offset.size.width - 60)/5, 30);
    
}

#pragma mark - block
- (void)initSenderBlock:(SenderSelectedArraryBlock)block{
    self.SenderBlock = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



#pragma mark - 自定义cell
@interface ChannelViewCell ()

@end

@implementation ChannelViewCell
//
- (void)initCellWithTitle:(NSString *)title{
    
//    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [_titleLabel removeFromSuperview];
    _titleLabel = [[UILabel alloc] initWithFrame:self.bounds]
    ;
    _titleLabel.text = title;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    [_ImageView removeFromSuperview];
    _ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 10, 10)];
    
    _ImageView.image = [UIImage imageNamed:@"close"];
//    [_ImageView setHidden:_IsHidden];
    _ImageView.hidden = _IsHidden;
    [self addSubview:_ImageView];
    
    
}

@end


#pragma mark - 自定义HeaderView

@interface CollectionHeaderView ()

@end

@implementation CollectionHeaderView

- (void)initUpHeaderWithTitle:(NSString *)title{
    [_label removeFromSuperview];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.width - 60,ClVHeaderHeigth)];
    _label.text = title;
    [self addSubview:_label];
    
    [self.EidtButton removeFromSuperview];
    self.EidtButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.EidtButton.frame = CGRectMake(CGRectGetMaxX(_label.frame), 0, 60, ClVHeaderHeigth);
    self.EidtButton.selected = self.IsSelected;
    [self.EidtButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.EidtButton setTitle:@"完成" forState:UIControlStateSelected];
    [self.EidtButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.EidtButton addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.EidtButton];
}

- (void)BtnClick:(UIButton *)button{
    button.selected = !button.selected;
    if (_IsEidtBlock) {
        BOOL IsEidt = button.selected;
        _IsEidtBlock(IsEidt);
    }
}

- (void)HeaderBtnIsClickBlock:(HeaderBtnIdClickBlock)block{
    _IsEidtBlock = block;
}

@end




