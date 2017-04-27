//
//  ViewController.m
//  MWLViewPageVC
//
//  Created by maweilong-PC on 2017/4/7.
//  Copyright © 2017年 maweilong. All rights reserved.
//

#import "ViewController.h"
#import "MWLViewPageVC.h"
#import "SecondViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray *Arr = @[@"点击进入FirstViewPage",@"点击进入SecondViewPage"];
    for (int index = 0; index < Arr.count; index++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100, 100*(index+1), 200, 100);
        [btn setTitle:Arr[index] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.tag = index;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    
}

- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 0) {
        MWLViewPageVC *VC = [MWLViewPageVC new];
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (btn.tag == 1) {
        SecondViewController *VC = [SecondViewController new];
        [self.navigationController pushViewController:VC animated:YES];
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
