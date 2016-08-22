//
//  TopAppView.m
//  LimitFreeProject
//
//  Created by zhangcheng on 16/2/18.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "TopAppView.h"
#import "TopViewController.h"
#import "DetailViewController.h"
@implementation TopAppView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI{
    appNameImageView=[LFZCControl createImageViewWithFrame:CGRectMake(0, 0, 30, 30) ImageName:@"icon"];
    appNameImageView.layer.cornerRadius=5;
    appNameImageView.layer.masksToBounds=YES;
    [self addSubview:appNameImageView];
    
    appLabel=[LFZCControl createLabelWithFrame:CGRectMake(50, 0, 100, 10) Font:10 Text:nil];
    [self addSubview:appLabel];
    
    commentImageView=[LFZCControl createImageViewWithFrame:CGRectMake(50, 10, 5, 5) ImageName:@"topic_Comment"];
    [self addSubview:commentImageView];
    
    commentLabel=[LFZCControl createLabelWithFrame:CGRectMake(55, 10, 30, 5) Font:5 Text:nil];
    [self addSubview:commentLabel];
    
    downImageView=[LFZCControl createImageViewWithFrame:CGRectMake(85, 10, 5, 5) ImageName:@"topic_Download"];
    [self addSubview:downImageView];
    
    downLabel=[LFZCControl createLabelWithFrame:CGRectMake(90, 10, 30, 5) Font:5 Text:nil];
    [self addSubview:downLabel];
    
    starView=[[StarView alloc]initWithFrame:CGRectMake(40, 15, 65, 23)];
    [self addSubview:starView];
    
    
    UIControl*control=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    
    [control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];

}
-(void)controlClick{
    NSLog(@"controlClick");
    
    
    DetailViewController*vc=[[DetailViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    vc.appID=self.appid;
    [self.vc.navigationController pushViewController:vc animated:YES];

}
-(void)configModel:(AppModel *)model
{
    appLabel.text=model.name;
    
    [appNameImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:[UIImage imageNamed:@"account_candou"]];
//    commentLabel.text=model.
    
    downLabel.text=model.downloads;
    
    [starView configStarNum:[model.starOverall floatValue]];
    

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
