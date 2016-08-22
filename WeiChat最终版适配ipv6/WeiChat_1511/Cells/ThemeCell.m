//
//  ThemeCell.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/9.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "ThemeCell.h"
#import "UIButton+WebCache.h"
#import "ThemeManager.h"
@implementation ThemeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建6个button 循环3次
        //80*120
        //间隔
        CGFloat s=(WIDTH-240)/4;
        for (int i=0; i<3; i++) {
            UIButton*button=[ZCControl createButtonWithFrame:CGRectMake(s+(80+s)*i, 10, 80, 120) ImageName:@"watermark template.png" Target:self Action:@selector(buttonClick:) Title:nil];
           
            button.tag=100+i;
            [self.contentView addSubview:button];
            
            UILabel*label=[ZCControl createLabelWithFrame:CGRectMake(0, 120, 80, 20) Font:10 Text:nil];
            label.textAlignment=NSTextAlignmentCenter;
            label.textColor=[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal];
            label.tag=200+i;
            [button addSubview:label];
            
            //添加下载按钮
            UIButton*downButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 20, 10) ImageName:@"logo_bg_2.png" Target:self Action:@selector(buttonClick:) Title:nil];
            
            downButton.titleLabel.font=[UIFont systemFontOfSize:5];
           
            [downButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            downButton.layer.cornerRadius=2;
            downButton.layer.masksToBounds=YES;
            
            downButton.center=CGPointMake(button.center.x, button.center.y+85);
            downButton.tag=300+i;
            [self.contentView addSubview:downButton];
            selectImageView=[ZCControl createImageViewWithFrame:CGRectMake(10, 10, 10, 10) ImageName:@"device_bind_success.png"];
            selectImageView.tag=1000;
            selectImageView.hidden=YES;
            [self.contentView addSubview:selectImageView];
            
            
        }
        
        
    }
    return self;
}
#pragma mark点击下载
-(void)buttonClick:(UIButton*)button{
//是第几个  对tag100求余
    
    
    NSDictionary*dic=self.dataArray[button.tag%100];
    if (_isBgViewCell) {
        [[ThemeManager shareManager]downLoadChatBgWithDic:dic];
    }else{
        //开始进行下载主题
        [[ThemeManager shareManager]downLoadThemeWithDic:dic];
    
    }
   
    

}

-(void)configWithArray:(NSArray*)array{
    selectImageView.hidden=YES;

    self.dataArray=array;
    NSInteger num=0;
  
    for (NSDictionary*dic in self.dataArray) {
        
        NSDictionary*dataDic=dic[@"baseInfo"];
       //赋值图片
        UIButton*button= [self.contentView viewWithTag:100+num];
        
        [button sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://i.gtimg.cn/qqshow/admindata/comdata/vipThemeNew_item_%@/a.jpg",dataDic[@"id"]]] forState:UIControlStateNormal];
 
        UILabel*label=[button viewWithTag:200+num];
        label.text=dataDic[@"name"];
        NSString*themeName=[[NSUserDefaults standardUserDefaults] objectForKey:THEME];
            if ([themeName isEqualToString:label.text]) {
                selectImageView.hidden=NO;
                selectImageView.frame=CGRectMake(button.frame.origin.x+button.frame.size.width-10, button.frame.origin.y+button.frame.size.height-10, 10, 10);
                
            }
        
        UIButton*downButton=[self.contentView viewWithTag:300+num];
        NSInteger type=[dataDic[@"feeType"]integerValue];
        NSString*str;
        switch (type) {
            case 1:
                str=@"免费";
                break;
            case 6:
                str=@"活动";
                break;
            
            case 4:
                str=@"VIP";
                break;
                
            case 5:
                str=@"SVIP";
                break;
            default:
                str=@"限免";
                break;
        }
        [downButton setTitle:str forState:UIControlStateNormal];
        num++;
    }
   
 
        NSArray*array1=self.contentView.subviews;
   
        for (UIView*view in array1) {
            if (view.tag%100>(num-1)) {
                view.hidden=YES;
            }else{
                if (view.tag!=1000) {
                    view.hidden=NO;
                }
            }
        }
    
    

}
-(void)configChatBgViewWithArray:(NSArray*)array{
    _isBgViewCell=YES;
    selectImageView.hidden=YES;
    self.dataArray=array;
    NSInteger num=0;
    
    for (NSDictionary*dic in self.dataArray) {
        
        //赋值图片
        UIButton*button= [self.contentView viewWithTag:100+num];
        
        [button sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://i.gtimg.cn/qqshow/admindata/comdata/vipChatBg_item_%@/%@",dic[@"id"],dic[@"smallImage"]]] forState:UIControlStateNormal];
        
        UILabel*label=[button viewWithTag:200+num];
        label.text=dic[@"name"];
        NSString*themeName=[[NSUserDefaults standardUserDefaults] objectForKey:CHATBGNAME];
        if ([themeName isEqualToString:label.text]) {
            selectImageView.hidden=NO;
            selectImageView.frame=CGRectMake(button.frame.origin.x+button.frame.size.width-10, button.frame.origin.y+button.frame.size.height-10, 10, 10);
            
        }

        
        UIButton*downButton=[self.contentView viewWithTag:300+num];
        NSInteger type=[dic[@"feeType"]integerValue];
        NSString*str;
        switch (type) {
            case 1:
                str=@"免费";
                break;
            case 6:
                str=@"活动";
                break;
                
            case 4:
                str=@"VIP";
                break;
                
            case 5:
                str=@"SVIP";
                break;
            default:
                str=@"限免";
                break;
        }
        [downButton setTitle:str forState:UIControlStateNormal];
        num++;
    }
    
    
    NSArray*array1=self.contentView.subviews;
    
    for (UIView*view in array1) {
        if (view.tag%100>(num-1)) {
            view.hidden=YES;
        }else{
            if (view.tag!=1000) {
                view.hidden=NO;

            }
        }
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
