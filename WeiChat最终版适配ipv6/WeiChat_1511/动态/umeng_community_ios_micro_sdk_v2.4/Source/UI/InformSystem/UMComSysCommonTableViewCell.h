//
//  UMComSysCommnTableViewCell.h
//  UMCommunity
//
//  Created by umeng on 15/12/27.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComTableViewCell.h"

#define UMCom_SysCommonCell_SubViews_LeftEdge 50
#define UMCom_SysCommonCell_SubViews_RightEdge 10
#define UMCom_SysCommonCell_FeedText_HorizonEdge 2
#define UMCom_SysCommonCell_FeedText_TopEdge 10
#define UMCom_SysCommonCell_FeedText_BottomEdge 3
#define UMCom_SysCommonCell_NameLabel_Height 30
#define UMCom_SysCommonCell_Content_TopEdge 10
#define UMCom_SysCommonCell_Cell_BottomEdge 25


//评论相关的参数---begin
//#define UMCom_SysCommonCell_Comment_Height          66        //评论的高度(目前不固定，由评论的内容的高度动态变化)
#define UMCom_SysCommonCell_Comment_LeftMargin      10        //评论的左间距
#define UMCom_SysCommonCell_Comment_RightMargin     11        //评论的右间距

#define UMCom_SysCommonCell_Comment_UserImgTopMargin      12  //头像的上间距
#define UMCom_SysCommonCell_Comment_UserImgWidth    38        //评论头像的宽
#define UMCom_SysCommonCell_Comment_UserImgHeight   38        //评论头像的高

#define UMCom_SysCommonCell_Comment_UserNameHeight  14        //评论者的名字
#define UMCom_SysCommonCell_Comment_UserNameTopMargin  17     //评论者的名字到上边缘的距离
#define UMCom_SysCommonCell_Comment_SpaceBetweenUserNameAndComment  10     //评论者的名字和评论内容之间的距离

#define UMCom_SysCommonCell_Comment_TimerHeight 9 //时间的高度
#define UMCom_SysCommonCell_Comment_TimerTopMargin  19 //时间的上边距

#define UMCom_SysCommonCell_Comment_ReplyBtnWidth  12 //回复btn的宽度
#define UMCom_SysCommonCell_Comment_ReplyBtnHeight 12 //回复btn的高度
#define UMCom_SysCommonCell_Comment_ReplyBtnRightMargin 15 //回复btn右边距
#define UMCom_SysCommonCell_Comment_SpaceBetweenReplyBtnAndTimer 14 //回复btn和时间的间距

#define UMCom_SysCommonCell_Comment_CommentDefaultHeight  14     //评论内容的默认高度
#define UMCom_SysCommonCell_Comment_CommentBotoom  11     //评论内容到底部的位置

#define UMCom_SysCommonCell_Comment_SpaceBetweenUserImgAndUserName  10        //评论头像和评论名字之间的间距

#define UMCom_SysCommonCell_Comment_replyBtnWidth   12        //回复评论的按钮宽度
#define UMCom_SysCommonCell_Comment_replyBtnHeight  12        //回复评论的按钮高度



//评论相关的参数---end

//feed相关的参数---begin
#define UMCom_SysCommonCell_FeedWithIMG_Height 92             //评论的带图片feed的高度
#define UMCom_SysCommonCell_FeedWithoutIMG_Height 37          //评论不带图片feed的高度

#define UMCom_SysCommonCell_Feed_IMGHeight 70          //feed的图片的高度
#define UMCom_SysCommonCell_Feed_IMGWidth  70          //feed的图片的宽度
#define UMCom_SysCommonCell_Feed_IMGLeftMargin 11          //feed的图片相对背景的左边距
#define UMCom_SysCommonCell_Feed_IMGTopMargin 11          //feed的图片的相对背景的上边距

#define UMCom_SysCommonCell_Feed_IMGMargin 11        //feed图片的上下左右的margin

#define UMCom_SysCommonCell_FeedCreator_DefaultHeight 15 //feed作者的默认高度
#define UMCom_SysCommonCell_FeedCreator_LeftMargin 11 //feed作者的相对于背景的左边距
#define UMCom_SysCommonCell_FeedCreator_TopMargin 12 //feed作者的相对于背景的上边距

#define UMCom_SysCommonCell_FeedCreatorWithImg_LeftMargin 92 //feed作者的相对于背景的左边距(有图片)
#define UMCom_SysCommonCell_FeedCreatorWithImg_TopMargin 21 //feed作者的相对于背景的上边距(有图片)

#define UMCom_SysCommonCell_FeedTextWithoutIMG_DefaultHeight 12 //feed内容的默认高度(没有图片)
#define UMCom_SysCommonCell_FeedTextWithoutIMG_TopMargin 14  //feed内容的相对于背景的上边距
#define UMCom_SysCommonCell_FeedTextWithIMG_DefaultHeight 28 //feed内容的默认高度(没有图片)
#define UMCom_SysCommonCell_SpaceBetweenFeedTextWithIMGAndFeedCreator 10 //feed内容和FeedCreator的间距

//feed相关的参数---end
#define UMCom_SysCommonCell_BottomMargin 10        //最下面的margin

@class UMComMutiStyleTextView, UMComImageView, UMComMutiText, UMComUser, UMComTopic;

@protocol UMComClickActionDelegate;

@interface UMComSysCommonTableViewCell :UMComTableViewCell

@property (nonatomic, strong) UMComImageView *portrait;

@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, weak) id<UMComClickActionDelegate> delegate;

@property (nonatomic, strong) UMComMutiStyleTextView *feedTextView;

@property (nonatomic, strong) UIImageView *bgimageView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     cellSize:(CGSize)cellSize;

- (void)reloadCellWithObj:(id)obj
               timeString:(NSString *)timeString
                 mutiText:(UMComMutiText *)commentMutiText
             feedMutiText:(UMComMutiText *)feedMutiText;

- (void)didSelectedUser;

- (void)turnToUserCenterWithUser:(UMComUser *)user;

- (void)turnToTopicViewWithTopic:(UMComTopic *)topic;

- (void)turnToWebViewWithUrlString:(NSString *)urlString;

@end
