//
//  UMComSysLikeTableViewCell.m
//  UMCommunity
//
//  Created by umeng on 15/12/28.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComSysLikeTableViewCell.h"
#import "UMComLike.h"
#import "UMComUser+UMComManagedObject.h"
#import "UMComMutiStyleTextView.h"
#import "UMComImageView.h"
#import "UMComTools.h"
#import "UMComFeed+UMComManagedObject.h"
#import "UMComClickActionDelegate.h"

@interface UMComSysLikeTableViewCell ()

@property (nonatomic, strong) UMComLike *like;

@property (nonatomic, strong) UILabel *commentTextView;

@property (nonatomic, assign) CGSize cellSize;

@property (nonatomic, strong) UMComMutiStyleTextView *feedCreatorView;

@property (nonatomic, strong) UMImageView *feedImgView;

@end

@implementation UMComSysLikeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)cellSize
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier cellSize:cellSize];
    if (self) {
        _cellSize = cellSize;
        
        self.commentTextView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.contentView addSubview:self.commentTextView];
    
        //创建在feed下面有图片的时候单独创建feed作者控件
        self.feedCreatorView = [[UMComMutiStyleTextView alloc] initWithFrame:CGRectMake(UMCom_SysCommonCell_SubViews_LeftEdge, UMCom_SysCommonCell_Content_TopEdge + self.userNameLabel.frame.size.height+10, cellSize.width-80, 50)];
        self.feedCreatorView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.feedCreatorView];
        
        self.feedImgView = [[UMImageView alloc]initWithFrame: CGRectMake(68, 188, UMCom_SysCommonCell_Feed_IMGHeight, UMCom_SysCommonCell_Feed_IMGHeight)];
        self.feedImgView.hidden = YES;
        [self.contentView addSubview:self.feedImgView];
    }
    
    return self;
}


//- (void)reloadCellWithObj:(id)obj
//               timeString:(NSString *)timeString
//                 mutiText:(UMComMutiText *)commentMutiText
//             feedMutiText:(UMComMutiText *)feedMutiText
//{
//    self.like = (UMComLike *)obj;
//    UMComUser *user = _like.creator;
//    NSString *iconUrl = [user iconUrlStrWithType:UMComIconSmallType];
//    [self.portrait setImageURL:iconUrl placeHolderImage:[UMComImageView placeHolderImageGender:user.gender.integerValue]];
//    
//    self.userNameLabel.text = [NSString stringWithFormat:@"%@ 赞了你",user.name];;
//    self.timeLabel.text = timeString;
//
//    CGRect bgImageFrame = self.bgimageView.frame;
//    bgImageFrame.origin.y = self.userNameLabel.frame.origin.y + self.userNameLabel.frame.size.height;
//    bgImageFrame.size.height = feedMutiText.textSize.height+UMCom_SysCommonCell_FeedText_TopEdge + UMCom_SysCommonCell_FeedText_BottomEdge;
//    self.bgimageView.frame = bgImageFrame;
//    //
//    CGRect feedTextFrame = self.feedTextView.frame;
//    feedTextFrame.origin.y = bgImageFrame.origin.y + UMCom_SysCommonCell_FeedText_TopEdge;
//    feedTextFrame.size.height = feedMutiText.textSize.height;
//    self.feedTextView.frame = feedTextFrame;
//    [self.feedTextView setMutiStyleTextViewWithMutiText:feedMutiText];
//    __weak typeof(self) weakSelf = self;
//    self.feedTextView.clickOnlinkText = ^(UMComMutiStyleTextView *styleView,UMComMutiTextRun *run){
//        if ([run isKindOfClass:[UMComMutiTextRunClickUser class]]) {
//            UMComMutiTextRunClickUser *userRun = (UMComMutiTextRunClickUser *)run;
//            UMComUser *user = [weakSelf.like.feed relatedUserWithUserName:userRun.text];
//            [weakSelf turnToUserCenterWithUser:user];
//        }else if ([run isKindOfClass:[UMComMutiTextRunTopic class]])
//        {
//            UMComMutiTextRunTopic *topicRun = (UMComMutiTextRunTopic *)run;
//            UMComTopic *topic = [weakSelf.like.feed relatedTopicWithTopicName:topicRun.text];
//            [weakSelf turnToTopicViewWithTopic:topic];
//        }else{
//            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customObj:clickOnFeedText:)]) {
//                __strong typeof(weakSelf)strongSelf = weakSelf;
//                [weakSelf.delegate customObj:strongSelf clickOnFeedText:weakSelf.like.feed];
//            }
//        }
//    };
//}

- (void)reloadCellWithObj:(id)obj
               timeString:(NSString *)timeString
                 mutiText:(UMComMutiText *)commentMutiText
             feedMutiText:(UMComMutiText *)feedMutiText
{
    self.like = (UMComLike *)obj;
    UMComUser *user = _like.creator;
    NSString *iconUrl = [user iconUrlStrWithType:UMComIconSmallType];
    
    [self.portrait setImageURL:iconUrl placeHolderImage:[UMComImageView placeHolderImageGender:user.gender.integerValue]];
    //计算头像的位置
    self.portrait.frame = CGRectMake(UMCom_SysCommonCell_Comment_LeftMargin, UMCom_SysCommonCell_Comment_UserImgTopMargin, UMCom_SysCommonCell_Comment_UserImgWidth, UMCom_SysCommonCell_Comment_UserImgHeight);
    self.portrait.layer.cornerRadius = self.portrait.frame.size.width/2;
    
    //设置timeLabel
    self.timeLabel.textColor = [UMComTools colorWithHexString:@"#A5A5A5"];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.font = UMComFontNotoSansLightWithSafeSize(10);
    self.timeLabel.text = timeString;
    CGSize timeStringSize = [timeString sizeWithFont:UMComFontNotoSansLightWithSafeSize(10)];
    CGFloat timeLabelHeight = 0;
    if (timeStringSize.height > UMCom_SysCommonCell_Comment_TimerHeight) {
        timeLabelHeight = timeStringSize.height + 5;//加5个像素的上下margin
    }
    else
    {
        timeLabelHeight = UMCom_SysCommonCell_Comment_TimerHeight + 5;//加5个像素的上下margin
    }
    
    self.timeLabel.frame = CGRectMake(_cellSize.width-timeStringSize.width - UMCom_SysCommonCell_Comment_RightMargin, UMCom_SysCommonCell_Comment_TimerTopMargin, timeStringSize.width, timeLabelHeight);
    //self.timeLabel.backgroundColor = [UIColor redColor];
    
    //设置用户的名字
    self.userNameLabel.font = UMComFontNotoSansLightWithSafeSize(14);
    self.userNameLabel.text = self.like.creator.name;
    CGFloat userNameWidth = _cellSize.width - UMCom_SysCommonCell_Comment_LeftMargin - UMCom_SysCommonCell_Comment_UserImgWidth - UMCom_SysCommonCell_Comment_SpaceBetweenUserImgAndUserName - UMCom_SysCommonCell_Comment_RightMargin - self.timeLabel.bounds.size.width;
    CGFloat userNameHeight = UMCom_SysCommonCell_Comment_UserNameHeight + 5;
    self.userNameLabel.frame =CGRectMake(UMCom_SysCommonCell_Comment_LeftMargin + UMCom_SysCommonCell_Comment_UserImgWidth + UMCom_SysCommonCell_Comment_SpaceBetweenUserImgAndUserName, UMCom_SysCommonCell_Comment_UserNameTopMargin, userNameWidth, userNameHeight);
    
    //self.userNameLabel.backgroundColor = [UIColor grayColor];
    
    //设置评论内容
    //self.commentTextView.backgroundColor = [UIColor purpleColor];
    CGRect commentFrame = self.commentTextView.frame;
    commentFrame.size.height = UMCom_SysCommonCell_Comment_CommentDefaultHeight;

    commentFrame.size.width = _cellSize.width - self.userNameLabel.frame.origin.x - UMCom_SysCommonCell_Comment_RightMargin;


    commentFrame.origin.x = self.userNameLabel.frame.origin.x;
    commentFrame.origin.y = self.userNameLabel.frame.origin.y + self.userNameLabel.frame.size.height + UMCom_SysCommonCell_Comment_SpaceBetweenUserNameAndComment;
    
    self.commentTextView.frame = commentFrame;
    self.commentTextView.text = @"赞了这条评论";
    self.commentTextView.textColor = [UMComTools colorWithHexString:@"#A5A5A5"];
    self.commentTextView.font = UMComFontNotoSansLightWithSafeSize(14);
    
    //设置feed的背景区域
    UMComFeed *feed = self.like.feed;
    CGFloat bgimageViewHeight = 0;
    if (feed.image_urls && [feed.image_urls count] > 0) {
        //有图片的布局
        if ([feed.status integerValue] < FeedStatusDeleted)
        {
            bgimageViewHeight = UMCom_SysCommonCell_FeedWithIMG_Height;
        }
        else
        {
            bgimageViewHeight = UMCom_SysCommonCell_FeedWithoutIMG_Height;
        }
    }
    else{
        //无图片的布局
        bgimageViewHeight = UMCom_SysCommonCell_FeedWithoutIMG_Height;
    }
    
    self.bgimageView.frame = CGRectMake(self.userNameLabel.frame.origin.x, self.commentTextView.frame.origin.y + self.commentTextView.frame.size.height + UMCom_SysCommonCell_Comment_CommentBotoom, _cellSize.width - self.userNameLabel.frame.origin.x - UMCom_SysCommonCell_Comment_RightMargin, bgimageViewHeight);
    
    CGRect bgImageFrame = self.bgimageView.frame;
    
    //设置背景中的feed
    CGSize userNameSize;
    NSString* userName = feed.creator.name;
    if (feed.image_urls && [feed.image_urls count] > 0)
    {
        if ([feed.status integerValue] < FeedStatusDeleted)
        {
            userName = [NSString stringWithFormat:@"@%@",userName];
            userNameSize = [userName sizeWithFont:UMComFontNotoSansLightWithSafeSize(14)];
            
            //有图片，显示图片，feed的用户，和feedTextView
            self.feedImgView.hidden = NO;
            self.feedImgView.frame = CGRectMake(bgImageFrame.origin.x + UMCom_SysCommonCell_Feed_IMGLeftMargin, bgImageFrame.origin.y + UMCom_SysCommonCell_Feed_IMGTopMargin, UMCom_SysCommonCell_Feed_IMGWidth, UMCom_SysCommonCell_Feed_IMGHeight);
            NSString*  urlString = [[feed.image_urls firstObject] valueForKey:@"small_url_string"];
            if (urlString) {
                self.feedImgView.isAutoStart = YES;
                [self.feedImgView setImageURL:[NSURL URLWithString:urlString] placeholderImage:UMComImageWithImageName(@"photox")];
            }
            
            //布局有图片的的feedCreatorView
            //设置feedCreatorView的位置
            CGFloat userNamelHeight = 0;
            if (userNameSize.height > UMCom_SysCommonCell_FeedCreator_DefaultHeight) {
                userNamelHeight = userNameSize.height + 5;//加5个margin的距离
            }
            else
            {
                userNamelHeight = UMCom_SysCommonCell_FeedCreator_DefaultHeight + 5;//加5个margin的距离
            }
            
            self.feedCreatorView.hidden = NO;
            self.feedCreatorView.frame = CGRectMake(bgImageFrame.origin.x+UMCom_SysCommonCell_FeedCreatorWithImg_LeftMargin, bgImageFrame.origin.y+UMCom_SysCommonCell_FeedCreatorWithImg_TopMargin, userNameSize.width, userNamelHeight);
            
            //布局有图片的的feedTextView
            //self.feedTextView.backgroundColor = [UIColor brownColor];
            self.feedTextView.frame = CGRectMake( self.feedCreatorView.frame.origin.x, self.feedCreatorView.frame.origin.y + self.feedCreatorView.frame.size.height + UMCom_SysCommonCell_SpaceBetweenFeedTextWithIMGAndFeedCreator, bgImageFrame.size.width - (self.feedCreatorView.frame.origin.x -bgImageFrame.origin.x), UMCom_SysCommonCell_FeedTextWithIMG_DefaultHeight);
        }
        else
        {
            self.feedCreatorView.hidden = YES;
            //self.feedTextView.backgroundColor = [UIColor brownColor];
            self.feedTextView.frame = CGRectMake(bgImageFrame.origin.x+UMCom_SysCommonCell_FeedCreator_LeftMargin, bgImageFrame.origin.y+UMCom_SysCommonCell_FeedCreator_TopMargin, bgImageFrame.size.width - UMCom_SysCommonCell_FeedCreator_LeftMargin, bgImageFrame.size.height -UMCom_SysCommonCell_FeedCreator_TopMargin);
        }
        
    }
    else
    {
        if ([feed.status integerValue] < FeedStatusDeleted)
        {
            userName = [NSString stringWithFormat:@"@%@:",userName];
            userNameSize = [userName sizeWithFont:UMComFontNotoSansLightWithSafeSize(14)];
            
            self.feedImgView.hidden = YES;
            self.feedCreatorView.hidden = NO;
            
            //设置feedCreatorView的位置
            CGFloat userNamelHeight = 0;
            if (userNameSize.height > UMCom_SysCommonCell_FeedCreator_DefaultHeight) {
                userNamelHeight = userNameSize.height + 5;//加5个margin的距离
            }
            else
            {
                userNamelHeight = UMCom_SysCommonCell_FeedCreator_DefaultHeight + 5;//加5个margin的距离
            }
            
            //self.feedCreatorView.backgroundColor = [UIColor orangeColor];
            self.feedCreatorView.frame = CGRectMake(bgImageFrame.origin.x+UMCom_SysCommonCell_FeedCreator_LeftMargin, bgImageFrame.origin.y+UMCom_SysCommonCell_FeedCreator_TopMargin, userNameSize.width, userNamelHeight);
            
            //设置feedTextView的位置
            //self.feedTextView.backgroundColor = [UIColor brownColor];
            self.feedTextView.frame = CGRectMake(self.feedCreatorView.frame.origin.x + self.feedCreatorView.frame.size.width, bgImageFrame.origin.y+UMCom_SysCommonCell_FeedTextWithoutIMG_TopMargin, bgImageFrame.size.width - (self.feedCreatorView.frame.origin.x-bgImageFrame.origin.x + self.feedCreatorView.frame.size.width), userNamelHeight);//此处的高度用feedCreatorView的默认高度来保持和feedCreatorView的高度一致
            
        }
        else
        {
            self.feedImgView.hidden = YES;
            self.feedCreatorView.hidden = YES;
            //self.feedTextView.backgroundColor = [UIColor brownColor];
            self.feedTextView.frame = CGRectMake(bgImageFrame.origin.x+UMCom_SysCommonCell_FeedCreator_LeftMargin, bgImageFrame.origin.y+UMCom_SysCommonCell_FeedCreator_TopMargin, bgImageFrame.size.width - UMCom_SysCommonCell_FeedCreator_LeftMargin, bgImageFrame.size.height -UMCom_SysCommonCell_FeedCreator_TopMargin);
        }
    }
    
    //设置feedCreatorView的富文本
    __weak typeof(self) weakSelf = self;
    NSMutableArray* feedCheckWords = [NSMutableArray array];
    if(feed.creator.name){
        NSString *checkuserName = [NSString stringWithFormat:UserNameString,feed.creator.name];
        [feedCheckWords addObject:checkuserName];
    }
    
    UMComMutiText *feedCreatorText = [UMComMutiText mutiTextWithSize:CGSizeMake(userNameSize.width, MAXFLOAT) font:UMComFontNotoSansLightWithSafeSize(14) string:userName lineSpace:2 checkWords:feedCheckWords];
    [self.feedCreatorView setMutiStyleTextViewWithMutiText:feedCreatorText];
    self.feedCreatorView.clickOnlinkText = ^(UMComMutiStyleTextView *styleView,UMComMutiTextRun *run){
        UMComMutiTextRunClickUser *userRun = (UMComMutiTextRunClickUser *)run;
        UMComUser *user = [weakSelf.like.feed relatedUserWithUserName:userRun.text];
        if (!user) {
            //如果为空直接到当前feed的个人中心
            user = weakSelf.like.feed.creator;
        }
        [weakSelf turnToUserCenterWithUser:user];
    };
    
    //设置feedTextView的富文本
    [self.feedTextView setMutiStyleTextViewWithMutiText:feedMutiText];
    self.feedTextView.clickOnlinkText = ^(UMComMutiStyleTextView *styleView,UMComMutiTextRun *run){
        if ([run isKindOfClass:[UMComMutiTextRunClickUser class]]) {
            UMComMutiTextRunClickUser *userRun = (UMComMutiTextRunClickUser *)run;
            UMComUser *user = [weakSelf.like.feed relatedUserWithUserName:userRun.text];
            if (!user) {
                //如果为空直接到当前feed的个人中心
                user = weakSelf.like.feed.creator;
            }
            [weakSelf turnToUserCenterWithUser:user];
        }else if ([run isKindOfClass:[UMComMutiTextRunTopic class]])
        {
            UMComMutiTextRunTopic *topicRun = (UMComMutiTextRunTopic *)run;
            UMComTopic *topic = [weakSelf.like.feed relatedTopicWithTopicName:topicRun.text];
            [weakSelf turnToTopicViewWithTopic:topic];
        }else{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customObj:clickOnFeedText:)]) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                [weakSelf.delegate customObj:strongSelf clickOnFeedText:weakSelf.like.feed];
            }
        }
    };

}

@end
