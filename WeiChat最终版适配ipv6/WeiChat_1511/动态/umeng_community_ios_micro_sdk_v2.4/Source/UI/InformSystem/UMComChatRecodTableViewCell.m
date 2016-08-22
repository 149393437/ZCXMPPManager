//
//  UMComChatRecodTableViewCell.m
//  UMCommunity
//
//  Created by umeng on 16/3/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComChatRecodTableViewCell.h"
#import "UMComPullRequest.h"
#import "UMComUser.h"
#import "UMComCommentEditView.h"
#import "UMComPushRequest.h"
#import "UMComSession.h"
#import "UMComImageView.h"
#import "UMComMutiStyleTextView.h"
#import "UMComTools.h"
#import "UMComImageUrl.h"
#import "UMComPrivateMessage.h"

@implementation UMComChatRecodTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.bgImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.bgImageView];
        
        self.iconImaeView = [[[UMComImageView imageViewClassName] alloc]init];
        self.iconImaeView.userInteractionEnabled = YES;
        self.iconImaeView.clipsToBounds = YES;
        [self.contentView addSubview:self.iconImaeView];
        
        self.chatContentView = [[UMComMutiStyleTextView alloc]init];
        self.chatContentView.backgroundColor = [UIColor clearColor];
        [self.bgImageView addSubview:self.chatContentView];
        
        self.dateLabel = [[UILabel alloc]init];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.font = UMComFontNotoSansLightWithSafeSize(UMCom_Forum_Chat_DateString_Font);
        self.dateLabel.textColor = UMComColorWithColorValueString(UMCom_Forum_Chat_Date_TextColor);
        [self.contentView addSubview:self.dateLabel];
        self.contentView.backgroundColor = UMComColorWithColorValueString(UMCom_Forum_Chat_Cell_BgColor);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickOnUser:)];
        [self.iconImaeView addGestureRecognizer:tap];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)clickOnUser:(id)sender
{
    if (_clickOnUser) {
        _clickOnUser();
    }
}

//- (void)clickOnCell:()

- (void)reloadTabelViewCellWithMessage:(UMComPrivateMessage *)privateMessage mutiText:(UMComMutiText *)mutiText cellSize:(CGSize)size
{
    [self.iconImaeView setImageURL:privateMessage.creator.icon_url.small_url_string placeHolderImage:UMComImageWithImageName(@"um_forum_user_smile_gray")];
    if (privateMessage.create_time) {
        self.dateLabel.text = createTimeString(privateMessage.create_time);
    }else{
        self.dateLabel.text = [[NSDate date] description];
    }
    [self.chatContentView setMutiStyleTextViewWithMutiText:mutiText];
    
}

@end


@implementation UMComChatReceivedTableViewCell
{
    CGFloat imageLeft;
    CGFloat imageWidth;
    CGFloat dateLabelHeight;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageLeft = UMCom_Forum_Chat_Icon_Edge;
        imageWidth = UMCom_Forum_Chat_Icon_Width;
        dateLabelHeight = UMCom_Forum_Chat_DateLabel_Height;
        UIImage *resizableImage = [UMComImageWithImageName(@"um_forum_chat_bg_white") resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 5, 20) resizingMode:UIImageResizingModeStretch];
        self.bgImageView.image = resizableImage;
        self.dateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (void)reloadTabelViewCellWithMessage:(UMComPrivateMessage *)privateMessage mutiText:(UMComMutiText *)mutiText cellSize:(CGSize)size
{
    [super reloadTabelViewCellWithMessage:privateMessage mutiText:mutiText cellSize:size];
    self.iconImaeView.frame = CGRectMake(imageLeft, imageLeft, imageWidth, imageWidth);
    self.iconImaeView.layer.cornerRadius = self.iconImaeView.bounds.size.height/2;
    CGFloat commonOriginX = imageLeft + imageLeft/2 + imageWidth;
    CGFloat bgChatImageWidth = mutiText.textSize.width + UMCom_Forum_Chat_Message_ShortEdge * 2 + 2;
    CGFloat bgImageHeight = mutiText.textSize.height + UMCom_Forum_Chat_Message_ShortEdge * 2;
    self.bgImageView.frame = CGRectMake(commonOriginX, imageLeft, bgChatImageWidth, bgImageHeight);
    self.chatContentView.frame = CGRectMake(UMCom_Forum_Chat_Message_ShortEdge+3, UMCom_Forum_Chat_Message_ShortEdge, mutiText.textSize.width, mutiText.textSize.height);
    self.dateLabel.frame = CGRectMake(self.bgImageView.frame.origin.x + UMCom_Forum_Chat_Message_ShortEdge, self.bgImageView.frame.origin.y + bgImageHeight + UMCom_Forum_Chat_DateMessage_Space, size.width-commonOriginX, dateLabelHeight);
}

@end


@implementation UMComChatSendTableViewCell
{
    CGFloat imageRight;
    CGFloat imageWidth;
    CGFloat dateLabelHeight;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageRight = UMCom_Forum_Chat_Icon_Edge;
        imageWidth = UMCom_Forum_Chat_Icon_Width;
        dateLabelHeight = UMCom_Forum_Chat_DateLabel_Height;
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        UIImage *resizableImage = [UMComImageWithImageName(@"um_forum_chat_bg_blue") resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 5, 20) resizingMode:UIImageResizingModeStretch];
        self.bgImageView.image = resizableImage;
        self.dateLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)reloadTabelViewCellWithMessage:(UMComPrivateMessage *)privateMessage mutiText:(UMComMutiText *)mutiText cellSize:(CGSize)size
{
    [super reloadTabelViewCellWithMessage:privateMessage mutiText:mutiText cellSize:size];
    self.iconImaeView.frame = CGRectMake(size.width-imageRight-imageWidth, imageRight, imageWidth, imageWidth);
    self.iconImaeView.layer.cornerRadius = self.iconImaeView.bounds.size.height/2;
    CGFloat bgChatImageWidth = mutiText.textSize.width + UMCom_Forum_Chat_Message_ShortEdge*2 + 2;
    CGFloat bgImageHeight = mutiText.textSize.height + UMCom_Forum_Chat_Message_ShortEdge * 2;
    CGFloat bgImageRigtEdge = imageRight+ imageRight/2 + imageWidth;
    self.bgImageView.frame = CGRectMake(size.width - bgChatImageWidth - bgImageRigtEdge, UMCom_Forum_Chat_Icon_Edge, bgChatImageWidth, bgImageHeight);
    self.chatContentView.frame = CGRectMake(UMCom_Forum_Chat_Message_ShortEdge, UMCom_Forum_Chat_Message_ShortEdge, mutiText.textSize.width, mutiText.textSize.height);
    
    CGRect dateFrame = self.dateLabel.frame;
    CGFloat rightEdge = UMCom_Forum_Chat_Message_ShortEdge + self.iconImaeView.frame.size.width + imageRight*2;
    dateFrame.size.width = size.width - UMCom_Forum_Chat_Message_LongEdge - rightEdge;
    dateFrame.origin.x = size.width - rightEdge - dateFrame.size.width;
    dateFrame.size.height = UMCom_Forum_Chat_DateLabel_Height;
    dateFrame.origin.y = self.bgImageView.frame.origin.y + bgImageHeight + UMCom_Forum_Chat_DateMessage_Space;
    self.dateLabel.frame = dateFrame;
}
@end
