//
//  CustomView.m
//  BuDeJie_1511
//
//  Created by zhangcheng on 16/2/15.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView
//重写init方法
-(instancetype)initWithFrame:(CGRect)frame Block:(void (^)())a
{
    if (self =[self initWithFrame:frame]) {
        self.myBlock=a;
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        //创建UI
        [self makeUI];
    }
    return self;
}
-(void)makeUI{
    //模糊的处理方法 至少3种方法可以做到 1.一张毛玻璃的图片 2.coreimage进行对图片模糊处理 3.iOS8的新方法进行处理
    UIImageView*imageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) ImageName:nil];
    [self addSubview:imageView];
    
//    //iOS8的毛玻璃效果
    [CustomView iOS8NewApi:imageView];
//    imageView.image=[UIImage imageNamed:@"shareBottomBackground.png"];
    
    //创建文字的imageView
    UIImageView*titleImageView=[ZCControl createImageViewWithFrame:CGRectMake((WIDTH-202)/2, 100, 202, 20) ImageName:@"app_slogan.png"];
    [imageView addSubview:titleImageView];
    
    NSArray*array=@[@"publish-video.png",@"publish-picture.png",@"publish-text.png",@"publish-audio.png",@"publish-review.png",@"publish-review.png"];
    //创建三组
    for (int i=0; i<2; i++) {
        //第一个和第四个
        UIButton*button1=[LFZCControl createButtonWithFrame:CGRectMake(20, 200+i*100, 60, 60) Target:self Method:@selector(buttonClick:) Title:nil ImageName:array[i+i*2] BgImageName:nil];
        button1.tag=100+i+i*2;
        [imageView addSubview:button1];
        //第二个和第五个
        UIButton*button2=[LFZCControl createButtonWithFrame:CGRectMake(WIDTH/2-30, 200+i*100, 60, 60) Target:self Method:@selector(buttonClick:) Title:nil ImageName:array[i+1+i*2] BgImageName:nil];
        button2.tag=100+i+1+i*2;
        
        [imageView addSubview:button2];
        //第三个和第六个
        UIButton*button3=[LFZCControl createButtonWithFrame:CGRectMake(WIDTH-80, 200+i*100, 60, 60) Target:self Method:@selector(buttonClick:) Title:nil ImageName:array[i+2+i*2] BgImageName:nil];
        button3.tag=100+i+2+i*2;
        [imageView addSubview:button3];

    }
    
    //添加取消
    UIButton*cancelButton=[LFZCControl createButtonWithFrame:CGRectMake(0, HEIGHT-44, WIDTH, 44) Target:self Method:@selector(cancelButtonClick) Title:nil ImageName:nil BgImageName:@"shareButtonCancel.png"];
    cancelButton.backgroundColor=[UIColor whiteColor];
    [imageView addSubview:cancelButton];
    

}
#pragma mark 取消按钮
-(void)cancelButtonClick{
    [self removeFromSuperview];
}
#pragma mark 按钮点击方法
-(void)buttonClick:(UIButton*)button{
        
    //可以使用代理 也可以使用block进行传值
    if (self.myBlock) {
        self.myBlock((int)button.tag);
    }

}

#pragma mark iOS8的方法
+(void)iOS8NewApi:(UIImageView*)imageView{
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame=imageView.frame;
    [imageView addSubview:effectview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
