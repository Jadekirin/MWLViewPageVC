//
//  TagViewController.h
//  MWLViewPageVC
//
//  Created by maweilong-PC on 2017/4/13.
//  Copyright © 2017年 maweilong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SenderSelectedArraryBlock)(NSMutableArray *selectedArrary);

@interface TagViewController : UIViewController

@property (nonatomic,strong) SenderSelectedArraryBlock SenderBlock;

- (void)initSenderBlock:(SenderSelectedArraryBlock)block;

@end


//自定义头视图
typedef void(^HeaderBtnIdClickBlock)(BOOL IsEidt);
@interface CollectionHeaderView : UICollectionReusableView

@property (nonatomic,strong) UIButton *EidtButton;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic) BOOL IsSelected;
@property (nonatomic,strong) HeaderBtnIdClickBlock IsEidtBlock;
- (void)initUpHeaderWithTitle:(NSString *)title;

- (void)HeaderBtnIsClickBlock:(HeaderBtnIdClickBlock)block;
@end



//自定义cell
@interface ChannelViewCell : UICollectionViewCell


@property (nonatomic) BOOL IsHidden;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *ImageView;
- (void)initCellWithTitle:(NSString *)title;

@end
