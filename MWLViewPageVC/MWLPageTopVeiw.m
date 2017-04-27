//
//  MWLPageTopVeiw.m
//  MWLViewPageVC
//
//  Created by maweilong-PC on 2017/4/7.
//  Copyright © 2017年 maweilong. All rights reserved.
//

#import "MWLPageTopVeiw.h"
@interface MWLPageTopVeiw() <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation MWLPageTopVeiw 

- (instancetype)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
    if (self) {
        
        [self initMarkView];
        [self initScrollView];
    }
    return self;
}
- (void)setDataArray:(NSArray *)dataArray{
    if (dataArray == nil) {
        self.dataArray = [[NSArray alloc] init];
    }
}

- (void)initMarkView{
    _markView = [[UIView alloc] initWithFrame:CGRectZero];
//    _markView.backgroundColor = [UIColor redColor];
    [self addSubview:_markView];
    
}
- (void)initScrollView{
    self.TopScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.TopScrollView.showsHorizontalScrollIndicator = NO;
    self.TopScrollView.backgroundColor = [UIColor clearColor];
    
    self.TopScrollView.delegate = self;
    [self addSubview:self.TopScrollView];
}

- (void)renderUIWithArray:(NSArray *)dataArray{
    CGFloat offset = 0;
    _markView.frame = CGRectMake(0, 0, kItemWidth, kItemHeigth);
    for (int index = 0; index < dataArray.count; index++) {
        CGRect frame = CGRectMake(offset, 0, kItemWidth, kItemHeigth);
        _itemView = [[MWLPageItemView alloc] initWithFrame:frame];
//
        
        
        _itemView.userInteractionEnabled = YES;
        [_itemView renderData: dataArray[index]];
        _itemView.tag = index;
        [_itemView getItemTagBlock:^(NSInteger index) {
            _currentIndex = index;
            
            if (_SelectItemClickBlock) {
                _SelectItemClickBlock(index);
            }
        }];
        offset +=  (kItemSpace + kItemWidth);
        [_TopScrollView addSubview:_itemView];
    }
    self.TopScrollView.contentSize = CGSizeMake(offset, 0);
}


- (void)addSelectItemClickBlock:(ClickPageItemViewBlock)objects{
    self.SelectItemClickBlock = objects;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    _markView.frame = CGRectMake(_currentIndex * (kItemWidth+kItemSpace) - offset, 0, kItemWidth, kItemHeigth);
}

@end



