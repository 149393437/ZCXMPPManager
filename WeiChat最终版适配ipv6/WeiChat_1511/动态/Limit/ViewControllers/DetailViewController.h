//
//  DetailViewController.h
//  爱限免
//
//  Created by zhangcheng on 16/2/17.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *appScrollerView;

@property (weak, nonatomic) IBOutlet UIScrollView *findScorllView;

@property (nonatomic,copy)NSString *appID;
@property (nonatomic,copy)NSString*itunesUrl;

@end
