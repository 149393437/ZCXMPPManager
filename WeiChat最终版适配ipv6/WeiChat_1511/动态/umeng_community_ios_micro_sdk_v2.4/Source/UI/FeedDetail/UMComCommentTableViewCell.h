//
//  UMComCommentTableViewCell.h
//  UMCommunity
//
//  Created by umeng on 15/5/22.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComTableViewCell.h"

#define UMCom_Micro_Comment_LeftEdge 60
#define UMCom_Micro_Comment_RightEdge 10
#define UMCom_Micro_Comment_TopEdge 10
#define UMCom_Micro_Portrait_LeftEdge 10
#define UMCom_Micro_Portrait_Width   39

#define UMCom_Micro_Comment_NameHeight 16
#define UMCom_Micro_Comment_TimeHeight 16

#define UMCom_Micro_Comment_TextFontSize 14
#define UMCom_Micro_Comment_NameFontSize 14
#define UMCom_Micro_Comment_TimeFontSize 9
#define UMCom_Micro_Comment_LikeFontSize 9

#define UMCom_Micro_Comment_TextCollor @"#666666"
#define UMCom_Micro_Comment_ReplyTextCollor @"#507DAF"
#define UMCom_Micro_Comment_NameTextCollor @"#999999"
#define UMCom_Micro_Comment_TimeTextCollor @"#A5A5A5"
#define UMCom_Micro_Comment_LikeTextCollor @"#008BEA"//#A5A5A5


@protocol UMComClickActionDelegate;

@class UMComMutiStyleTextView,UMComImageView,UMComComment, UMComMutiText, UMComGridView;


@interface UMComCommentTableViewCell : UMComTableViewCell

@property (nonatomic, strong) UMComImageView *portrait;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UMComMutiStyleTextView *commentTextView;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@property (weak, nonatomic) IBOutlet UMComGridView *commentImageView;

@property (nonatomic, copy) void (^clickOnUserportrait)(UMComComment *comment);
@property (nonatomic, copy) void (^clickOnCommentContent)(UMComComment *comment);

@property (nonatomic, weak) id<UMComClickActionDelegate> delegate;

- (IBAction)onClickLikeButton:(id)sender;

- (void)reloadWithComment:(UMComComment *)comment commentStyleView:(UMComMutiText *)mutiText;

@end