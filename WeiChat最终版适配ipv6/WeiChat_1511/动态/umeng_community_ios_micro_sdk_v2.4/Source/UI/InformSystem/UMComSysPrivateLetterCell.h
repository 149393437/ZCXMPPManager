//
//  UMComSysPrivateLetterCell.h
//  UMCommunity
//
//  Created by umeng on 16/3/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComTableViewCell.h"

#define UMCom_Forum_LetterList_Cell_Height 64
#define UMCom_Forum_LetterList_IconName_Space 10
#define UMCom_Forum_LetterList_Icon_TopEdge 10
#define UMCom_Forum_LetterList_Icon_LeftEdge 10
#define UMCom_Forum_LetterList_Name_TextFont 16
#define UMCom_Forum_LetterList_Name_TextColor @"#333333"
#define UMCom_Forum_LetterList_Message_TextFont 13
#define UMCom_Forum_LetterList_Message_TextColor @"#999999"
#define UMCom_Forum_LetterList_Date_TextFont 12
#define UMCom_Forum_LetterList_Date_TextColor @"#A5A5A5"
#define UMCom_Forum_LetterList_DateLabel_Width 100
#define UMCom_Forum_LetterList_RedDot_Diameter 20
#define UMCom_Forum_LetterList_RedDot_TextFont 11
#define UMCom_Forum_letterList_RedDot_TextColor @"#FFFFFF"
#define UMCom_Forum_letterList_CellItems_RightEdge 10

@class UMComImageView,UMComPrivateLetter;

@interface UMComSysPrivateLetterCell : UMComTableViewCell

@property (nonatomic, strong) UMComImageView *iconImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UILabel *redDotLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellSize:(CGSize)size;

- (void)reloadCellWithPrivateLetter:(UMComPrivateLetter *)privateLetter;

@end
