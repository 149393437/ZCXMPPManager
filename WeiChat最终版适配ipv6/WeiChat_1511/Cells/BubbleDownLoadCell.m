//
//  BubbleDownLoadCell.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/4/1.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "BubbleDownLoadCell.h"
#import "UIButton+WebCache.h"
#import "ThemeManager.h"
@implementation BubbleDownLoadCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI{
    leftButton=[ZCControl createButtonWithFrame:CGRectMake(15, 5, WIDTH/2-20, 70) ImageName:@"logo_bg_2.png" Target:self Action:@selector(leftButtonClick) Title:nil];
    [self.contentView addSubview:leftButton];
  
    rightButton=[ZCControl createButtonWithFrame:CGRectMake(WIDTH/2+5, 5, WIDTH/2-20, 70) ImageName:@"logo_bg_2.png" Target:self Action:@selector(rightButtonClick) Title:nil];
    [self.contentView addSubview:rightButton];
    
    selectImageView=[ZCControl createImageViewWithFrame:CGRectMake(10, 10, 10, 10) ImageName:@"device_bind_success.png"];
    [self.contentView addSubview:selectImageView];
    

}
-(void)configFontWithArray:(NSMutableArray*)array
{
    _isFont=YES;
    self.dataArray=array;
    
    NSDictionary*dic=[self.dataArray firstObject];
    
    NSDictionary*dic1=[self.dataArray lastObject];
    
    //对比当前这个是不是选中的标题
    selectImageView.hidden=YES;
    
    //读取标题
    NSString*str=dic[@"baseInfo"][@"id"];
    
    NSString*str1=dic1[@"baseInfo"][@"id"];
    
    //读取目前选中的标题
    NSString*str2=[[NSUserDefaults standardUserDefaults]objectForKey:FONT];
    if (str2) {
        if ([str isEqualToString:str2]) {
            //左边
            selectImageView.hidden=NO;
            selectImageView.frame=CGRectMake(15+WIDTH/2-30, 65, 10, 10);
        }
        if ([str1 isEqualToString:str2]) {
            //右边
            selectImageView.hidden=NO;
            selectImageView.frame=CGRectMake(WIDTH/2+5+WIDTH/2-30, 65, 10, 10);
        }
        
        
        
    }
    
    
    [leftButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://i.gtimg.cn/qqshow/admindata/comdata/vipfont_%@/list_new.png",dic[@"baseInfo"][@"id"]]] forState:UIControlStateNormal];
    
    [rightButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://i.gtimg.cn/qqshow/admindata/comdata/vipfont_%@/list_new.png",dic1[@"baseInfo"][@"id"]]] forState:UIControlStateNormal];
    
    
    if (self.dataArray.count<2) {
        rightButton.hidden=YES;
    }else{
        rightButton.hidden=NO;
    }
    
    
}

-(void)configWithArray:(NSMutableArray*)array
{
    self.dataArray=array;
    
    NSDictionary*dic=[self.dataArray firstObject];
    
    NSDictionary*dic1=[self.dataArray lastObject];
    
    //对比当前这个是不是选中的标题
    selectImageView.hidden=YES;
    
    //读取标题
    NSString*str=dic[@"baseInfo"][@"name"];
    
    NSString*str1=dic1[@"baseInfo"][@"name"];
    
    //读取目前选中的标题
    NSString*str2=[[NSUserDefaults standardUserDefaults]objectForKey:BUBBLE];
    if (str2) {
        if ([str isEqualToString:str2]) {
            //左边
            selectImageView.hidden=NO;
            selectImageView.frame=CGRectMake(15+WIDTH/2-30, 65, 10, 10);
        }
        if ([str1 isEqualToString:str2]) {
            //右边
            selectImageView.hidden=NO;
            selectImageView.frame=CGRectMake(WIDTH/2+5+WIDTH/2-30, 65, 10, 10);
        }
        
        
        
    }
    
    
    [leftButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://i.gtimg.cn/qqshow/admindata/comdata/vipBubble_item_%@/mobile_list.jpg",dic[@"baseInfo"][@"id"]]] forState:UIControlStateNormal];
    
    [rightButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://i.gtimg.cn/qqshow/admindata/comdata/vipBubble_item_%@/mobile_list.jpg",dic1[@"baseInfo"][@"id"]]] forState:UIControlStateNormal];
    
    
    if (self.dataArray.count<2) {
        rightButton.hidden=YES;
    }else{
        rightButton.hidden=NO;
    }
    

}

-(void)leftButtonClick{
    NSDictionary*dic=[self.dataArray firstObject];

    if (_isFont) {
        [[ThemeManager shareManager]downLoadFontWithDic:dic];
    }else{
        //进行气泡下载
        [[ThemeManager shareManager]downLoadBubbleWithDic:dic];
    }
  

}
-(void)rightButtonClick{
    NSDictionary*dic1=[self.dataArray lastObject];

    if (_isFont) {
        [[ThemeManager shareManager]downLoadFontWithDic:dic1];

    }else{
        //进行气泡下载
        [[ThemeManager shareManager]downLoadBubbleWithDic:dic1];
    }
  
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
