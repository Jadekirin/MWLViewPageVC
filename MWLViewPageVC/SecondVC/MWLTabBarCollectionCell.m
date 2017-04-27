//
//  MWLTabBarCollectionCell.m
//  MWLViewPageVC
//
//  Created by maweilong-PC on 2017/4/12.
//  Copyright © 2017年 maweilong. All rights reserved.
//

#import "MWLTabBarCollectionCell.h"



@implementation MWLTabBarCollectionCell


-(void)setSubView:(UIViewController *)SubView{
    
    _SubView = SubView;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:_SubView.view];
}
@end
