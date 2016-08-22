//
//  UMComViewController.m
//  UMCommunity
//
//  Created by umeng on 15/9/14.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComViewController.h"
#import "UMComTools.h"
#import "UMComSession.h"
#import "UIViewController+UMComAddition.h"

@interface UMComViewController ()

@end

@implementation UMComViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.doNotShowBackButton == NO) {
        [self setForumUIBackButton];  
    }
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(communityInvalidErrorNotitficationAlert) name:kUMComCommunityInvalidErrorNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUMComCommunityInvalidErrorNotification object:nil];
}


- (void)communityInvalidErrorNotitficationAlert
{
    [[UMComSession sharedInstance] userLogout];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUMComCommunityInvalidErrorNotification object:nil];
    [[[UIAlertView alloc]initWithTitle:nil message:@"社区已经被强制关闭，暂时无法访问请见谅。" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil] show];
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
