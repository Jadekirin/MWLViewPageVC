//
//  MWLPageTopVeiw.h
//  MWLViewPageVC
//
//  Created by maweilong-PC on 2017/4/7.
//  Copyright © 2017年 maweilong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MWLPageItemView.h"
#import "PageViewHeader.h"
typedef enum : NSUInteger {
    MWLPageTopVeiwForNoScroll = 0,//default 总宽度为屏幕宽度，不可滚动，每个item的宽度，根据item的个数确定。适合item数比较少的情况
    MWLPageTopVeiwForCAnScroll = 1,//总宽度超过屏幕宽度，可滚动，每个item的宽度，适合item数比较多的情况
} MWLPageTopVeiwType;//判断topview能不能滚动

typedef void(^ClickPageItemViewBlock)(NSInteger index);

@interface MWLPageTopVeiw : UIView 

@property (nonatomic,assign) MWLPageTopVeiwType type;
@property (nonatomic,strong) NSArray *dataArray;//item数据数组
@property (nonatomic,assign) CGFloat itemWidth;//item的宽度
@property (nonatomic,assign) CGFloat itemHeigth;//item的宽度
@property (nonatomic,assign) CGFloat spaceWidth;//item间隔的宽度

@property (nonatomic,strong) MWLPageItemView *itemView;
@property (nonatomic,strong) ClickPageItemViewBlock SelectItemClickBlock;

@property (nonatomic,strong) UIScrollView *TopScrollView;
@property (nonatomic,strong) UIView *markView;//移动的背景view

-(instancetype)initWithFrame:(CGRect)frame;
- (void)renderUIWithArray:(NSArray *)dataArray;
- (void)addSelectItemClickBlock:(ClickPageItemViewBlock)objects;

@end
