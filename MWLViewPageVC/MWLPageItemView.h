//
//  MWLPageItemView.h
//  MWLViewPageVC
//
//  Created by maweilong-PC on 2017/4/10.
//  Copyright © 2017年 maweilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageViewHeader.h"

typedef void(^ItemTagBlock)(NSInteger index);

@interface MWLPageItemView : UIView
@property (nonatomic,strong) ItemTagBlock Selectedblock;
- (void)renderData:(NSString *)titleStr;
- (void)getItemTagBlock:(ItemTagBlock)block;


@end
