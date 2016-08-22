//
//  RadarErrorViewController.m
//  weiChat
//
//  Created by zhangcheng on 14-7-22.
//  Copyright (c) 2014年 张诚. All rights reserved.
//

#import "RadarErrorViewController.h"

@interface RadarErrorViewController ()

@end

@implementation RadarErrorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"设置蓝牙说明";
    
    UIImageView*errorImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 64, WIDTH, self.view.frame.size.height-64) ImageName:@"teach_bluetooth_interface.png"];
    [self.view addSubview:errorImageView];
}

-(void)backClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
