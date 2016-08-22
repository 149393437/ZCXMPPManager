//
//  UMComFeedStyle.m
//  UMCommunity
//
//  Created by Gavin Ye on 4/27/15.
//  Copyright (c) 2015 Umeng. All rights reserved.
//

#import "UMComFeedStyle.h"
#import "UMComSession.h"
#import "UMComTools.h"
#import "UMComMutiStyleTextView.h"
#import "UMComFeed.h"
#import "UMComTopic.h"
#import "UMComFeed+UMComManagedObject.h"
#import "UMComLocationModel.h"
#import "UMComPullRequest.h"

NSInteger const UMCom_Micro_FeedContentLength = 300;

@implementation UMComFeedStyle

- (instancetype)initWithFeed:(UMComFeed *)feed viewWidth:(float)viewWidth
{
    self = [super init];
    if (self) {
        self.subViewDeltalWidth = UMCom_Micro_FeedContent_LeftEdge;
        self.subViewOriginX = UMCom_Micro_FeedContent_LeftEdge;
        self.nameLabelWidth = viewWidth-self.subViewOriginX-UMCom_Micro_Feed_More_ButtonWidth;
        self.subViewWidth = viewWidth - self.subViewDeltalWidth - UMCom_Micro_Feed_CellBg_Edge*2 - UMCom_Micro_FeedContent_RightEdge;
    }
    return self;
}

+ (UMComFeedStyle *)feedStyleWithFeed:(UMComFeed *)feed viewWidth:(float)viewWidth
{
    UMComFeedStyle *feedStyle = [[UMComFeedStyle alloc]initWithFeed:feed viewWidth:viewWidth];
    [feedStyle resetWithFeed:feed];
    return feedStyle;
}

- (void)resetWithFeed:(UMComFeed *)feed
{
    NSInteger resultTopType = feed.is_topType.integerValue | EUMTopFeedType_Mask;
    if (resultTopType == EUMTopFeedType_None) {
        self.isShowTopIamge = NO;
    }
    else{
        self.isShowTopIamge = YES;
    }
    
    self.likeCount = [feed.likes_count intValue];
    self.commentsCount = [feed.comments_count intValue];
    self.forwordCount = 0;
    float totalHeight = UserNameLabelViewHeight + UMCom_Micro_Feed_Avata_TopEdge;
    self.feed = feed;
    NSString * feedSting = @"";
    if (feed.text && [feed.status intValue] < FeedStatusDeleted) {
        NSInteger feedTextLength = [UMComTools getStringLengthWithString:self.feed.text];
        if (feedTextLength > UMCom_Micro_FeedContentLength && self.isDisplayAllContent == NO) {
            feedSting = [feed.text substringWithRange:NSMakeRange(0, UMCom_Micro_FeedContentLength)];
        }
        else
        {
            feedSting = feed.text;
        }
                
        NSMutableArray *feedCheckWords = [NSMutableArray array];
        for (UMComTopic *topic in feed.topics) {
            NSString *topicName = [NSString stringWithFormat:TopicString,topic.name];
            [feedCheckWords addObject:topicName];
        }
        for (UMComUser *user in feed.related_user) {
            NSString *userName = [NSString stringWithFormat:UserNameString,user.name];
            [feedCheckWords addObject:userName];
        }
        UMComMutiText *mutitext = [UMComMutiText mutiTextWithSize:CGSizeMake(self.subViewWidth, MAXFLOAT) font:FeedFont string:feedSting lineSpace:UMCom_Micro_FeedContent_LineSpace checkWords:feedCheckWords textColor:UMComColorWithColorValueString(UMCom_Micro_Feed_ContentCollor)];
        self.feedStyleTextModel = mutitext;
        totalHeight += mutitext.textSize.height;
        //此处是为了字数过多时进行高度纠偏而用的
        if (feedTextLength > UMCom_Micro_FeedContentLength && self.isDisplayAllContent) {
            mutitext.textSize = CGSizeMake(mutitext.textSize.width, mutitext.textSize.height + 10);
        }
    }
    totalHeight += UMCom_Micro_FeedCellItem_Vertical_Space;
    UMComFeed *origin_feed = feed.origin_feed;
    if ([feed.status integerValue] >= FeedStatusDeleted) {
        origin_feed = feed;
        origin_feed.image_urls = nil;
    }
    self.originFeed = origin_feed;
    if (origin_feed) {
        NSMutableString *oringFeedString = [NSMutableString stringWithString:@""];
        NSString *originUserName = origin_feed.creator.name? origin_feed.creator.name : @"";
        if ([feed.status intValue] >= FeedStatusDeleted ) {
            origin_feed.text = UMComLocalizedString(@"Delete Content", @"该内容已被删除");
        }
        else if ([origin_feed.status intValue] >= FeedStatusDeleted) {
            origin_feed.text = UMComLocalizedString(@"Delete Content", @"该内容已被删除");
            origin_feed.image_urls = nil;
        }
        //若把当前feed当成原feed显示的话，不需要显示@用户：
        if ([feed.status intValue] >= FeedStatusDeleted) {
            [oringFeedString appendString:origin_feed.text];
        } else {
            if (feed.origin_feed.text && [feed.origin_feed.text isEqualToString:@""] && (feed.origin_feed.image_urls.count > 0)) {
                //源feed无内容有图片，显示 @creator:分享图片
                [oringFeedString appendFormat:OriginUserNameString,originUserName,@"分享图片"];
            }
            else if(feed.origin_feed.text && feed.origin_feed.text.length > 0)
            {
                //如果无图片，并且无图片的话，显示@creator:content
                [oringFeedString appendFormat:OriginUserNameString,originUserName,feed.origin_feed.text];
            }
            else{
                //如果无图片，并且无图片的话，显示@creator:
                [oringFeedString appendFormat:OriginUserNameString,originUserName,@""];
            }

        }
        NSString *originFeedStr = oringFeedString;
        
        if ([UMComTools getStringLengthWithString:oringFeedString] > UMCom_Micro_FeedContentLength && self.isDisplayAllContent == NO) {
            originFeedStr = [originFeedStr substringWithRange:NSMakeRange(0, UMCom_Micro_FeedContentLength)];
        }
        NSMutableArray *originFeedCheckWords = [NSMutableArray array];
        for (UMComTopic *topic in origin_feed.topics) {
            NSString *topicName = [NSString stringWithFormat:TopicString,topic.name];
            [originFeedCheckWords addObject:topicName];
        }
        for (UMComUser *user in origin_feed.related_user) {
            NSString *userName = [NSString stringWithFormat:UserNameString,user.name];
            [originFeedCheckWords addObject:userName];
        }
        if (origin_feed.creator) {
            [originFeedCheckWords addObject:[NSString stringWithFormat:UserNameString,origin_feed.creator.name]];
        }
        UMComMutiText *originMutitext = [UMComMutiText mutiTextWithSize:CGSizeMake(self.subViewWidth-UMCom_Micro_FeedForwardText_LeftEdge*2, MAXFLOAT) font:UMComFontNotoSansLightWithSafeSize(UMCom_Micro_FeedForward_FontSize) string:originFeedStr lineSpace:UMCom_Micro_FeedContent_LineSpace checkWords:originFeedCheckWords textColor:UMComColorWithColorValueString(UMCom_Micro_Feed_ForwardContentCollor)];
        self.originFeedStyleTextModel = originMutitext;
        totalHeight += originMutitext.textSize.height;
        totalHeight += UMCom_Micro_FeedForwardText_TopEdge;
        
        if (origin_feed.location) {
            self.locationModel = [origin_feed locationModel];
        }
        self.imageModels = origin_feed.image_urls.array;
        self.imageGridViewOriginX = 5;
        if (self.imageModels.count > 0) {
            totalHeight += UMCom_Micro_FeedContent_LineSpace;
        }
    }else{
        if (feed.location) {
            self.locationModel = [feed locationModel];
        }
        self.imageGridViewOriginX = 0;
        self.imageModels = feed.image_urls.array;
        if (self.imageModels.count > 0) {
            if (self.locationModel) {
                totalHeight -= UMCom_Micro_FeedContent_LineSpace;
            }
        }
    }
    if (self.locationModel) {
        totalHeight += LocationBackgroundViewHeight;
        totalHeight += UMCom_Micro_FeedCellItem_Vertical_Space;
    }

    if(self.imageModels.count > 0) {
        CGFloat imagesViewHeight = (self.subViewWidth - self.imageGridViewOriginX*2-UMCom_Micro_Feed_Image_Space*2)/3;
        self.imagesViewHeight = imagesViewHeight+self.imageGridViewOriginX;
        if (self.imageModels.count > 3) {
            self.imagesViewHeight += (imagesViewHeight + UMCom_Micro_Feed_Image_Space);
            if (self.imageModels.count > 6) {
                self.imagesViewHeight += (imagesViewHeight + UMCom_Micro_Feed_Image_Space);
            }
        }
        totalHeight += self.imagesViewHeight;
//        totalHeight += UMCom_Micro_FeedCellItem_Vertical_Space;
    }else{
        totalHeight -= UMCom_Micro_FeedCellItem_Vertical_Space;
    }
    totalHeight += 45;
    self.totalHeight = totalHeight;
    self.dateString = createTimeString(feed.create_time);
}

@end
