//
//  CommentCell.h
//  BuDeJie_1511
//
//  Created by zhangcheng on 16/2/2.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
@interface CommentCell : UITableViewCell
{
    UIImageView*headerImageView;
    UILabel*userNameLabel;
    UIImageView*sexImageView;
    UILabel*connectLabel;
    UIImageView*zanImageView;
    UILabel*zanLabel;
    

}
-(void)config:(CommentModel*)model;
@end
