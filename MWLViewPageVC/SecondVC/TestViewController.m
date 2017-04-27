//
//  TestViewController.m
//  MWLViewPageVC
//
//  Created by maweilong-PC on 2017/4/12.
//  Copyright © 2017年 maweilong. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:0.8];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
    label.text = [NSString stringWithFormat:@"%ld",self.index];
    label.textColor = [UIColor redColor];
    
    NSLog(@"%ld",self.index);
    
    [self.view addSubview:label];
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
