//
//  StarView.h
//  LimitFreeProject
//
//  Created by zhangcheng on 16/2/16.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StarView : UIView
{
    UIImageView*bgImageView;
    UIImageView*starImageView;

}
-(void)configStarNum:(float)num;
@end
