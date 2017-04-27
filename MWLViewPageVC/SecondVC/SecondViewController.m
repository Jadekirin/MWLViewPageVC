//
//  SecondViewController.m
//  MWLViewPageVC
//
//  Created by maweilong-PC on 2017/4/12.
//  Copyright © 2017年 maweilong. All rights reserved.
//

#import "SecondViewController.h"
#import "MWLTabBarView.h"
#import "TestViewController.h"
#import "TagViewController.h"
@interface SecondViewController ()
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) MWLTabBarView *tabBarView;

@end

@implementation SecondViewController


- (void)viewWillAppear:(BOOL)animated{
    [self initTabBarView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.tabBarView];
//    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    UIButton *RightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    RightBtn.frame = CGRectMake(0, 0, 40, 20);
    [RightBtn setTitle:@"添加" forState:UIControlStateNormal];
    [RightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [RightBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:RightBtn];
    self.navigationItem.rightBarButtonItem = right;
    if (!_dataArray) {
        _dataArray = @[@"有声",@"家居",@"电竞",@"美容",@"电视剧",@"搏击",@"健康",@"摄影",@"生活",@"旅游"];
    }
    [self initTabBarView];
}


- (void)BtnClick:(UIButton*)btn{
    //进入标签页
    TagViewController *VC = [[TagViewController alloc] init];
    
    [VC initSenderBlock:^(NSMutableArray *selectedArrary) {
        self.dataArray = selectedArrary;
    }];
    
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)initTabBarView{
    [_tabBarView removeFromSuperview];
    _tabBarView = [[MWLTabBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height )];
    int m = 0;
    for (NSString *title in _dataArray) {
        TestViewController *VC = [[TestViewController alloc] init];
        VC.title = title;
        m +=1;
        VC.index = m;
        [_tabBarView addSubItemWithControllers:VC];
    }
    [self.view addSubview:_tabBarView];
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
