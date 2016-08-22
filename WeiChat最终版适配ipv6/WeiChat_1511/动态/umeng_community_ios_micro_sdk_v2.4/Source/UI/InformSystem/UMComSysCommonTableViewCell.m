//
//  UMComSysCommnTableViewCell.m
//  UMCommunity
//
//  Created by umeng on 15/12/27.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComSysCommonTableViewCell.h"
#import "UMComComment.h"
#import "UMComUser+UMComManagedObject.h"
#import "UMComImageView.h"
#import "UMComMutiStyleTextView.h"
#import "UMComTools.h"
#import "UMComFeed+UMComManagedObject.h"
#import "UMComClickActionDelegate.h"



@interface UMComSysCommonTableViewCell () <UMComClickActionDelegate>

@property (nonatomic, strong) UMComComment *comment;

@property(nonatomic,strong)UITapGestureRecognizer *bgimageViewTapGesture;
-(void)handleGesture:(UIGestureRecognizer*)gestureRecognizer;


@end

@implementation UMComSysCommonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)cellSize
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat textOriginX = UMCom_SysCommonCell_SubViews_LeftEdge;
        CGFloat textOriginY = UMCom_SysCommonCell_Content_TopEdge;
        self.customSpace = 2.0f;
        self.portrait = [[[UMComImageView imageViewClassName] alloc]initWithFrame:CGRectMake(10, textOriginY, 30, 30)];
        self.portrait.userInteractionEnabled = YES;
        self.portrait.layer.cornerRadius = self.portrait.frame.size.width/2;
        self.portrait.clipsToBounds = YES;
        [self.contentView addSubview:self.portrait];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectedUser)];
        [self.portrait addGestureRecognizer:tap];
        
        self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(textOriginX, textOriginY, cellSize.width-textOriginX-10-120, UMCom_SysCommonCell_NameLabel_Height)];
        self.userNameLabel.font = UMComFontNotoSansLightWithSafeSize(14);
        self.userNameLabel.textColor = UMComColorWithColorValueString(@"#333333");
        [self.contentView addSubview:self.userNameLabel];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(textOriginX+self.userNameLabel.frame.size.width, textOriginY, 120, UMCom_SysCommonCell_NameLabel_Height)];
        self.timeLabel.textColor = UMComColorWithColorValueString(@"#A5A5A5");
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.font = UMComFontNotoSansLightWithSafeSize(10);
        [self.contentView addSubview:self.timeLabel];
        
        self.bgimageView = [[UIImageView alloc]initWithFrame:CGRectMake(textOriginX, self.userNameLabel.frame.origin.y+self.userNameLabel.frame.size.height, cellSize.width-60, 100)];
        //设置背景可点击事件--begin
        self.bgimageView.userInteractionEnabled = YES;
        self.bgimageViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self.bgimageView addGestureRecognizer:self.bgimageViewTapGesture];
        //设置背景可点击事件--end
//        UIImage *resizableImage = [UMComImageWithImageName(@"origin_image_bg") resizableImageWithCapInsets:UIEdgeInsetsMake(20, 50, 0, 0)];
//        self.bgimageView.image = resizableImage;
        self.bgimageView.backgroundColor = [UMComTools colorWithHexString:@"#F5F6FA"];
        [self.contentView addSubview:self.bgimageView];
        
        self.feedTextView = [[UMComMutiStyleTextView alloc] initWithFrame:CGRectMake(textOriginX, self.bgimageView.frame.origin.y+10, cellSize.width-60, 80)];
        self.feedTextView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.feedTextView];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)reloadCellWithObj:(id)obj
               timeString:(NSString *)timeString
                 mutiText:(UMComMutiText *)commentMutiText
             feedMutiText:(UMComMutiText *)feedMutiText
{

}

-(void)dealloc
{
    [self.bgimageView removeGestureRecognizer:self.bgimageViewTapGesture];
}

#pragma mark - action

-(void)handleGesture:(UIGestureRecognizer*)gestureRecognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnFeedText:)]) {
        [self.delegate customObj:self clickOnFeedText:self.comment.feed];
    }
}

- (void)didSelectedUser
{
    [self turnToUserCenterWithUser:self.comment.creator];
}

- (void)turnToUserCenterWithUser:(UMComUser *)user
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnUser:)]) {
        [self.delegate customObj:self clickOnUser:user];
    }
}

- (void)turnToTopicViewWithTopic:(UMComTopic *)topic
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnTopic:)]) {
        [self.delegate customObj:self clickOnTopic:topic];
    }
}

- (void)turnToWebViewWithUrlString:(NSString *)urlString
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnURL:)]) {
        [self.delegate customObj:self clickOnURL:urlString];
    }
}

@end
