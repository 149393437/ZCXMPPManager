//
//  UMComChatRecodTableViewCell.h
//  UMCommunity
//
//  Created by umeng on 16/3/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComTableViewCell.h"

#define UMCom_Forum_Chat_Icon_Width 45
#define UMCom_Forum_Chat_Icon_Edge 10
#define UMCom_Forum_Chat_Message_ShortEdge  15 //聊天内容到背景图片边框的距离
#define UMCom_Forum_Chat_Message_LongEdge  47 //背景图片到Cell边框的距离
#define UMCom_Forum_Chat_DateMessage_Space  0
#define UMCom_Forum_Chat_DateLabel_Height  30
#define UMCom_Forum_Chat_Cell_Space  25
#define UMCom_Forum_Chat_DateString_Font  11
#define UMCom_Forum_Chat_Message_Font  15

#define UMCom_Forum_Chat_Date_TextColor @"#A5A5A5"
#define UMCom_Forum_Chat_Cell_BgColor  @"#F5F6FA"
#define UMCom_Forum_Chat_ReceivedMsg_TextColor @"#333333"
#define UMCom_Forum_Chat_SendFrame_LineColor  @"#DEDEDE"
#define UMCom_Forum_Chat_SendFrame_bgColor  @"#F5F6FA"
#define UMCom_Forum_Chat_SendFrame_TextColor @"#333333"
#define UMCom_Forum_Chat_SendFrame_ViewsSpace 10
#define UMCom_Forum_Chat_SendFrame_Heigt 50
#define UMCom_Forum_Chat_SendButton_Width 70
#define UMCom_Forum_Chat_SendButton_TitleFont 15
#define UMCom_Forum_Chat_SendButton_HighLightColor @"#C7C7C7"
#define UMCom_Forum_Chat_SendButton_NomalColor  @"#008BEA"

@class  UMComImageView,UMComPrivateMessage,UMComMutiText,UMComMutiStyleTextView;
@interface UMComChatRecodTableViewCell :UITableViewCell

@property (nonatomic, strong) UMComImageView *iconImaeView;

@property (nonatomic, strong) UMComMutiStyleTextView *chatContentView;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, copy) void (^clickOnUser)();

@property (nonatomic, copy) void (^clickOnCell)();

- (void)reloadTabelViewCellWithMessage:(UMComPrivateMessage *)privateMessage mutiText:(UMComMutiText *)mutiText cellSize:(CGSize)size;


@end


@interface UMComChatReceivedTableViewCell : UMComChatRecodTableViewCell

@end

@interface UMComChatSendTableViewCell : UMComChatRecodTableViewCell

@end