//
//  NewsReplyViewController.m
//  BaseProject
//
//  Created by apple-jd03 on 15/11/23.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "NewsReplyViewController.h"
@interface NewsReplyViewController ()
@property (nonatomic, strong)NSString * type;
@end

@implementation NewsReplyViewController
- (id)initWithType:(NSString *)type{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if ([self.type isEqualToString:@"pic"]) {
        [Factory addBackItemToVCHasColor:self];
    }else{
        [Factory addBackItemToVC:self];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
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
