//
//  MWLViewPageBaseSubVC.m
//  MWLViewPageVC
//
//  Created by maweilong-PC on 2017/4/10.
//  Copyright © 2017年 maweilong. All rights reserved.
//

#import "MWLViewPageBaseSubVC.h"

@interface MWLViewPageBaseSubVC ()

@end

@implementation MWLViewPageBaseSubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
    label.text = [NSString stringWithFormat:@"%ld",self.index];
    label.textColor = [UIColor redColor];
    
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
