//
//  UMComForuUserTableViewCell.m
//  UMCommunity
//
//  Created by umeng on 15/11/29.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComCommonUserTableViewCell.h"
#import "UMComImageView.h"
#import "UMComTools.h"
#import "UMComUser.h"
#import "UMComImageUrl.h"
#import "UMComSession.h"
#import "UMComClickActionDelegate.h"

#pragma mark - Font size
const int UMCom_NameLabel_FontSize = 17;
const int UMCom_FeedCountLabel_FontSize = 13;
const int UMCom_FansCountLabel_FontSize = 13;
const int UMCom_FocusButton_FontSize = 14;

#pragma mark - view size
NSString  * const  UMCom_Forum_User_Name_TextColor = @"#333333";
NSString  * const UMCom_Forum_User_Detail_TextColor = @"#999999";
const CGFloat UMCom_Forum_User_Icon_LeftEdge = 10;
const CGFloat UMCom_Forum_User_Icon_RightEdge = 10;
const CGFloat UMCom_Forum_User_Icon_TopEdge = 10;
const CGFloat UMCom_Forum_User_Icon_Width = 45;
const CGFloat UMCom_Forum_User_focuseButton_Width = 80;
const CGFloat UMCom_forum_UserName_TopEdge = 5;

const CGFloat UMCom_Forum_User_genderIcon_Width = 10;//性别的图片宽度

static UIImage* g_maleImage = nil;
static UIImage* g_femaleImage = nil;

@interface UMComCommonUserTableViewCell ()
{
    CGSize _cellSize;
}

@property (nonatomic, strong) UMComUser *user;


@end

@implementation UMComCommonUserTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarImageView = [[[UMComImageView imageViewClassName] alloc]init];
//        self.avatarImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.avatarImageView];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickOnUser)];
//        [self.avatarImageView addGestureRecognizer:tap];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = UMComFontNotoSansLightWithSafeSize(UMCom_NameLabel_FontSize);
        self.nameLabel.textColor = UMComColorWithColorValueString(UMCom_Forum_User_Name_TextColor);
        [self.contentView addSubview:self.nameLabel];
        
        self.genderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(-8, 3, 10, 10)];
        [self.contentView addSubview:self.genderImageView];
        
        self.feedCountLabel = [[UILabel alloc]init];
        self.feedCountLabel.font = UMComFontNotoSansLightWithSafeSize(UMCom_FeedCountLabel_FontSize);
        self.feedCountLabel.textColor = UMComColorWithColorValueString(UMCom_Forum_User_Detail_TextColor);
        [self.contentView addSubview:self.feedCountLabel];
        
        self.fansCountLabel = [[UILabel alloc]init];
        self.fansCountLabel.font = UMComFontNotoSansLightWithSafeSize(UMCom_FansCountLabel_FontSize);
        self.fansCountLabel.textColor = UMComColorWithColorValueString(UMCom_Forum_User_Detail_TextColor);
        [self.contentView addSubview:self.fansCountLabel];
        
        self.focuseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.focuseButton addTarget:self action:@selector(didClickOnFocusButton) forControlEvents:UIControlEventTouchUpInside];
        self.focuseButton.titleLabel.font = UMComFontNotoSansLightWithSafeSize(UMCom_FocusButton_FontSize);
        [self.contentView addSubview:self.focuseButton];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                     cellSize:(CGSize)size
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _cellSize = size;
        
        CGFloat iconLeftEdge = UMCom_Forum_User_Icon_LeftEdge;
        CGFloat iconWidth = UMCom_Forum_User_Icon_Width;
        CGFloat focuseButtonWith = UMCom_Forum_User_focuseButton_Width;
        self.avatarImageView.frame = CGRectMake(iconLeftEdge, UMCom_Forum_User_Icon_TopEdge, iconWidth, iconWidth);
        self.avatarImageView.layer.cornerRadius = iconWidth/2;
        self.avatarImageView.clipsToBounds = YES;
        
        CGRect nameFrame;
        nameFrame.origin.x = iconLeftEdge*2+iconWidth;
        nameFrame.size.width = size.width-iconWidth-iconLeftEdge*2 - focuseButtonWith - UMCom_Forum_User_Icon_RightEdge - UMCom_Forum_User_genderIcon_Width;
        nameFrame.size.height = size.height/2;
        nameFrame.origin.y = UMCom_forum_UserName_TopEdge;
        self.nameLabel.frame = nameFrame;//CGRectMake(imageStart*2+imageWidth, 0, size.width-imageWidth-imageStart*2, size.height/2);
        
        CGRect genderImageViewFrame;
        genderImageViewFrame.origin.x = nameFrame.origin.x + nameFrame.size.width;
        genderImageViewFrame.origin.y = nameFrame.origin.y + UMCom_forum_UserName_TopEdge;
        genderImageViewFrame.size.width = UMCom_Forum_User_genderIcon_Width;
        genderImageViewFrame.size.height = UMCom_Forum_User_genderIcon_Width;
        self.genderImageView.frame = genderImageViewFrame;
        self.genderImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        CGRect feedCountFrame = nameFrame;
        feedCountFrame.origin.y = size.height/2-UMCom_forum_UserName_TopEdge;
        feedCountFrame.size.width = nameFrame.size.width/2;
        self.feedCountLabel.frame = feedCountFrame;
        
        CGRect fansCountFrame = feedCountFrame;
        fansCountFrame.origin.x = feedCountFrame.origin.x + feedCountFrame.size.width;
        self.fansCountLabel.frame = fansCountFrame;
        
        CGRect buttonFrame = nameFrame;
        UIImage *image = UMComImageWithImageName(@"um_forum_user_focuse");
        buttonFrame.origin.x = size.width - focuseButtonWith - UMCom_Forum_User_Icon_RightEdge;
        buttonFrame.size.width = focuseButtonWith;
        buttonFrame.size.height = image.size.height * focuseButtonWith / image.size.width;
        buttonFrame.origin.y = (size.height - buttonFrame.size.height)/2;
        self.focuseButton.frame = buttonFrame;
        
        
//        [self.focuseButton setImage:UMComImageWithImageName(@"male") forState:UIControlStateNormal];
       
//        CGFloat commonEdge = buttonFrame.size.height/4;
//        self.focuseButton.imageEdgeInsets = UIEdgeInsetsMake(commonEdge, commonEdge/2, commonEdge, buttonFrame.size.width - buttonFrame.size.height + commonEdge*3/2);
//        self.focuseButton.titleEdgeInsets = UIEdgeInsetsMake(0, - commonEdge*3/2, 0, 0);
    }
    return self;
}

- (void)reloadCellWithUser:(UMComUser *)user
{
    _user = user;
    [self.avatarImageView setImageURL:user.icon_url.small_url_string placeHolderImage:UMComImageWithImageName(@"um_forum_user_smile_gray")];
    self.nameLabel.text = user.name;
    self.feedCountLabel.text = [NSString stringWithFormat:@"发表动态：%@",countString(user.feed_count)];
    self.fansCountLabel.text = [NSString stringWithFormat:@"粉丝数：%@",countString(user.fans_count)];
    if ([user.uid isEqualToString:[UMComSession sharedInstance].uid] || [user.atype integerValue] == 3) {
        self.focuseButton.hidden = YES;
    }else{
        self.focuseButton.hidden = NO;
        if ([user.has_followed boolValue] && [user.be_followed boolValue]) {
            [self.focuseButton setBackgroundImage:UMComImageWithImageName(@"um_forum_user_interfocuse") forState:UIControlStateNormal];
        }else if ([user.has_followed boolValue]){
            [self.focuseButton setBackgroundImage:UMComImageWithImageName(@"um_forum_user_hasfocused") forState:UIControlStateNormal];
        }else{
            [self.focuseButton setBackgroundImage:UMComImageWithImageName(@"um_forum_user_focuse") forState:UIControlStateNormal];
        }
    }
    
    
    CGFloat iconLeftEdge = UMCom_Forum_User_Icon_LeftEdge;
    CGFloat iconWidth = UMCom_Forum_User_Icon_Width;
    CGFloat focuseButtonWith = UMCom_Forum_User_focuseButton_Width;
    CGFloat maxNameLabelWidth = _cellSize.width-iconWidth-iconLeftEdge*2 - focuseButtonWith - UMCom_Forum_User_Icon_RightEdge - UMCom_Forum_User_genderIcon_Width -5 ;
    
    CGSize textSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font constrainedToSize:CGSizeMake(self.frame.size.width, self.nameLabel.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    CGRect nameLabelFrame = self.nameLabel.frame;
    CGFloat nameLabelWidth = self.nameLabel.frame.size.width;
    if (textSize.width >=  maxNameLabelWidth) {
        nameLabelWidth = maxNameLabelWidth;
    }
    else
    {
        nameLabelWidth = textSize.width;
    }
    
    nameLabelFrame.size.width = nameLabelWidth;
    self.nameLabel.frame = nameLabelFrame;
    
    
    CGRect genderImageViewFrame = self.genderImageView.frame;
    genderImageViewFrame.origin.x = self.nameLabel.frame.origin.x +  self.nameLabel.frame.size.width;
    self.genderImageView.frame = genderImageViewFrame;
    
    if ([self.user.gender intValue] == 0) {
            if(!g_maleImage)
            {
                g_maleImage = UMComImageWithImageName(@"♀.png");
            }
            self.genderImageView.image = g_maleImage;

        }else{
            if (!g_femaleImage) {
                g_femaleImage = UMComImageWithImageName(@"♂.png");
            }
            self.genderImageView.image = g_femaleImage;
        }
}

- (void)didClickOnFocusButton
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnFollowUser:)]) {
        [self.delegate customObj:self clickOnFollowUser:self.user];
    }
}

- (void)drawRect:(CGRect)rect
{
    UIColor *color = UMComTableViewSeparatorColor;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeRect(context, CGRectMake(UMCom_Forum_User_Icon_Width + UMCom_Forum_User_Icon_LeftEdge*2, rect.size.height - TableViewCellSpace, rect.size.width - UMCom_Forum_User_Icon_Width + UMCom_Forum_User_Icon_LeftEdge*2, TableViewCellSpace));
}

//- (void)didClickOnUser
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnUser:)]) {
//        [self.delegate customObj:self clickOnUser:self.user];
//    }
//}

@end
