//
//  UMComFeedStyle.h
//  UMCommunity
//
//  Created by Gavin Ye on 4/27/15.
//  Copyright (c) 2015 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


//#define DeltaHeight 10
#define OriginUserNameString @"@%@：%@"

#define LocationBackgroundViewHeight 21
#define UserNameLabelViewHeight      29

#define UMCom_Micro_Feed_CellBgCollor @"#F5F6FA"
#define UMCom_Micro_Feed_ForwardBgCollor @"#F5F6FA"
#define UMCom_Micro_Feed_NameCollor @"#333333"
#define UMCom_Micro_Feed_ContentCollor @"#666666"
#define UMCom_Micro_Feed_LocationCollor @"#A5A5A5"
#define UMCom_Micro_Feed_ForwardNameCollor @"#507DAF"
#define UMCom_Micro_Feed_ForwardContentCollor @"#7D7D7D"
#define UMCom_Micro_Feed_ButtonTitleCollor @"#A5A5A5"
#define UMCom_Micro_Feed_DateColor @"#A5A5A5"

#define UMCom_Micro_FeedContent_FontSize 15
#define UMCom_Micro_FeedName_FontSize 14
#define UMCom_Micro_FeedForward_FontSize 14
#define UMCom_Micro_FeedLocation_FontSize 12
#define UMCom_Micro_FeedButton_FontSize 10
#define UMCom_Micro_FeedTime_FontSize 10

#define UMCom_Micro_Feed_Avata_Width 39
#define UMCom_Micro_Feed_Avata_Space 2
#define UMCom_Micro_Feed_Avata_LeftEdge  11
#define UMCom_Micro_Feed_Avata_TopEdge  16
#define UMCom_Micro_Feed_Image_Space 2
#define UMCom_Micro_FeedContent_LeftEdge 60
#define UMCom_Micro_FeedContent_RightEdge 19
#define UMCom_Micro_FeedContent_LineSpace 4
#define UMCom_Micro_FeedForwardText_TopEdge 11
#define UMCom_Micro_FeedForwardText_LeftEdge 5
#define UMCom_Micro_Feed_CellBg_Edge 5
#define UMCom_Micro_FeedCellItem_Vertical_Space 10
#define UMCom_Micro_Feed_Cell_Space 5
#define UMCom_Micro_Feed_More_ButtonWidth  30

#define FeedFont UMComFontNotoSansLightWithSafeSize(UMCom_Micro_FeedContent_FontSize)


//typedef enum {
//    feedDefaultType = 0,
//    feedDetailType = 1,
//    feedFavourateType = 2,
//    feedDistanceType = 3,
//    feedFocusType = 4,
//    feedUserType = 5,
//    feedTopicType = 6
//}UMComFeedType;


@class UMComFeed, UMComMutiText, UMComLocationModel;

@interface UMComFeedStyle : NSObject

@property (nonatomic, strong) UMComMutiText * feedStyleTextModel;
@property (nonatomic, strong) UMComMutiText * originFeedStyleTextModel;
@property (nonatomic) float totalHeight;
@property (nonatomic, assign) int commentsCount;
@property (nonatomic, assign) int likeCount;
@property (nonatomic, assign) int forwordCount;
@property (nonatomic, strong) UMComFeed *feed;
@property (nonatomic, strong) UMComFeed *originFeed;

@property (nonatomic, assign) CGFloat subViewDeltalWidth;
@property (nonatomic, assign) CGFloat subViewOriginX;
@property (nonatomic, assign) CGFloat subViewWidth;
@property (nonatomic, assign) CGFloat imagesViewHeight;
@property (nonatomic, assign) CGFloat locationBgViewHeight;
@property (nonatomic, assign) CGFloat nameLabelWidth;
@property (nonatomic, assign) CGFloat imageGridViewOriginX;
@property (nonatomic, strong) NSArray *imageModels;
@property (nonatomic, copy)   NSString *dateString;
@property (nonatomic, strong) UMComLocationModel *locationModel;
@property (nonatomic, assign) BOOL isShowTopIamge;
@property (nonatomic, assign) BOOL isDisplayAllContent;

- (instancetype)initWithFeed:(UMComFeed *)feed viewWidth:(float)viewWidth;

+ (UMComFeedStyle *)feedStyleWithFeed:(UMComFeed *)feed viewWidth:(float)viewWidth;

- (void)resetWithFeed:(UMComFeed *)feed;
@end
