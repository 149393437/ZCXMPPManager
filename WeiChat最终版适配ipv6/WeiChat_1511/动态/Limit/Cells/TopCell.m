//
//  TopCell.m
//  LimitFreeProject
//
//  Created by zhangcheng on 16/2/18.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "TopCell.h"
#import "TopAppView.h"
@implementation TopCell

- (void)awakeFromNib {
    // Initialization code
    _desImageView.layer.cornerRadius=15;
    _desImageView.layer.masksToBounds=YES;
}
-(void)configDic:(NSDictionary*)dic
{
    _topTitleLabel.text=dic[@"title"];
    
    [_topImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]] placeholderImage:[UIImage imageNamed:@"topic_TopicImage_Default"]];
    
    [_desImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"desc_img"]] placeholderImage:[UIImage imageNamed:@"account_candou"]];
    _desLabel.text=dic[@"desc"];
    
    
    //右边建立我们需要的专题类的标签
    NSArray*array=dic[@"applications"];
    for (int i=0; i<array.count; i++) {
        TopAppView*app=[self.contentView viewWithTag:200+i];
        if (app==nil) {
             app=[[TopAppView alloc]initWithFrame:CGRectMake(120, 50+40*i, 150, 30)];
            app.tag=200+i;
             [self.contentView addSubview:app];
        }
        
      
        
        NSDictionary*dicx=array[i];
        
        AppModel*model=[[AppModel alloc]init];
        [model setValuesForKeysWithDictionary:dicx];
        [app configModel:model];
        //把viewController指针传递给topAppView
        app.vc=self.vc;
        app.appid=model.applicationId;
        
       
    }
    
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
