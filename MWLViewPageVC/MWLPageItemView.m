//
//  MWLPageItemView.m
//  MWLViewPageVC
//
//  Created by maweilong-PC on 2017/4/10.
//  Copyright © 2017年 maweilong. All rights reserved.
//

#import "MWLPageItemView.h"
@interface MWLPageItemView ()

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation MWLPageItemView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initItemView];
    }
    return self;
}


- (void)initItemView{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor blackColor];
    
    [self addSubview:_titleLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick:)];
    [self addGestureRecognizer:tap];
}

- (void)renderData:(NSString *)titleStr{
   
    _titleLabel.text = titleStr;
}

- (void)getItemTagBlock:(ItemTagBlock)block{
    _Selectedblock = block;
}

- (void)itemClick:(UITapGestureRecognizer *)tap{
//    NSLog(@"=======%ld======",self.tag);
    if (_Selectedblock) {
        _Selectedblock(self.tag);
    }
}
@end
