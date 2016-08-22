//
//  UMComUserDetaiView.m
//  UMCommunity
//
//  Created by umeng on 16/2/2.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComUserProfileDetailView.h"
#import "UMComImageView.h"
#import "UMComTools.h"
#import "UMComUser.h"
#import "UMComImageUrl.h"
#import "UMComHorizonCollectionView.h"
#import "UMComMedal.h"
#import "UMComSession.h"
#import "UMComMedalImageView.h"

//detailView
#define UMCom_Forum_UserCenter_ButtonHeight 30
#define UMCom_Forum_UserCenter_ButtonWidth 70
#define UMCom_Forum_UserCenter_ButtonSpace 38
#define UMCom_Forum_UserCenter_AvatarWidth 75
#define UMCom_Forum_UserCenter_AvatarTopEdge 25
#define UMCom_Forum_UserCenter_AvatarNameSpace 8
#define UMCom_Forum_UserCenter_NameButtonSpace 0
#define UMCom_Forum_UserCenter_ProfileButtonFont 13
#define UMCom_Forum_UserCenter_NameFont 14
#define UMCom_Forum_UserCenter_ButtonTitleColor  @"#9CD0F3"
#define UMCom_Forum_UserCenter_DetailViewBgColor  @"#FAFBFD"


//menuview
#define UMCom_Forum_UserCenter_DetailMenuSpace 15

#define UMCom_Forum_UserCenter_MenuTitleFont 16
#define UMCom_Forum_UserCenter_MenuCountFont 12
#define UMCom_Forum_UserCenter_MenuViewHeight 48
#define UMCom_Forum_UserCenter_MenuEdgeLineConlor  @"#EEEFF3"
#define UMCom_Forum_UserCenter_MenuBgColor  @"#9CD0F3"
#define UMCom_Forum_UserCenter_MenuTitleColor  @"#A5A5A5"
#define UMCom_Forum_UserCenter_MenuTitleHighLightColor  @"#008BEA"


@interface UMComUserProfileDetailView ()<UMComHorizonCollectionViewDelegate,UMComImageViewDelegate>

@property (nonatomic,readwrite,strong) UIButton *albumButton;
@property (nonatomic,readwrite,strong) UIButton *topicButton;
@property (nonatomic, strong) UIButton *focuseButton;

@property (nonatomic, strong) UIButton *scoreButton;

@property (nonatomic, strong) UIImageView *genderView;

@property (nonatomic, strong) UMComImageView *medal_icon;

@property (nonatomic, strong) UMComHorizonCollectionView *menuView;

@property (nonatomic, strong) NSArray *countLabelList;

//单个勋章UI布局
//@property(nonatomic,strong)UMComMedalImageView* medalView;
//-(void) relayoutMedalView;
//-(void) doRelayoutMedalView;

//多勋章布局
@property(nonatomic,assign)NSInteger curMedalCount;//勋章的数量(最大5个)
@property(nonatomic,strong)NSMutableArray* medalViewArray;//包含勋章控件(UMComMedalImageView)
-(void) createMedalViews;
-(void) requestIMGForMedalViews:(UMComUser*)user;
-(void) clearRequestForMedalViews;
-(CGSize)computeMedalViewSize:(UMComMedalImageView*)medalView;
-(void) layoutMedalViews;




@end

@implementation UMComUserProfileDetailView

- (instancetype)initWithFrame:(CGRect)frame user:(UMComUser *)user
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat avatarWidth = UMCom_Forum_UserCenter_AvatarWidth;
        CGFloat image_top_edge = UMCom_Forum_UserCenter_AvatarTopEdge;
        UMComImageView *avatar = [[[UMComImageView imageViewClassName] alloc]initWithFrame:CGRectMake(frame.size.width/2-avatarWidth/2, image_top_edge, avatarWidth, avatarWidth)];
        [self addSubview:avatar];
        avatar.clipsToBounds = YES;
        avatar.userInteractionEnabled = YES;
        avatar.layer.cornerRadius = avatarWidth/2;
        self.avatarImageView = avatar;
       
        /*
         //屏蔽头像右下角勋章的创建
        self.medal_icon = [[[UMComImageView imageViewClassName] alloc] init];
        CGFloat medel_icon_width = 16;
        self.medal_icon.backgroundColor = [UIColor clearColor];
        CGRect imageFrame = CGRectMake(0, 0, medel_icon_width, medel_icon_width);
        imageFrame.origin.x = avatarWidth - medel_icon_width-2 + avatar.frame.origin.x;
        imageFrame.origin.y = avatarWidth - medel_icon_width-2 + avatar.frame.origin.y;
        self.medal_icon.frame = imageFrame;
        [self addSubview:_medal_icon];
         */
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnAvatar:)];
        [self.avatarImageView addGestureRecognizer:tap];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.avatarImageView.frame.size.height + self.avatarImageView.frame.origin.y + UMCom_Forum_UserCenter_AvatarNameSpace, 80, 30)];
        self.nameLabel.font = UMComFontNotoSansLightWithSafeSize(UMCom_Forum_UserCenter_NameFont);
        self.nameLabel.center = CGPointMake(self.frame.size.width/2, self.nameLabel.center.y);
        [self addSubview:self.nameLabel];
        
        self.genderView = [[UIImageView alloc]initWithFrame:CGRectMake(self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width + 10, self.nameLabel.frame.origin.y, 20, 20)];
        [self addSubview:self.genderView];
        
        //创建勋章控件
        /*
        self.medalView = [[UMComMedalImageView alloc] initWithFrame:CGRectMake(0, 0, [UMComMedalImageView defaultWidth], self.nameLabel.bounds.size.height)];
        self.medalView.contentMode =  UIViewContentModeScaleAspectFit;
        [self addSubview:self.medalView];
         */
        
        //创建多勋章控件
        [self createMedalViews];
        
        CGFloat buttonWidth = UMCom_Forum_UserCenter_ButtonWidth;
        CGRect buttonFrame;
        CGFloat buttonSpace = UMCom_Forum_UserCenter_ButtonSpace;
        buttonFrame.origin.x = self.frame.size.width/2 - buttonWidth - buttonSpace - buttonWidth/2;
        buttonFrame.origin.y = self.nameLabel.frame.size.height + self.nameLabel.frame.origin.y + UMCom_Forum_UserCenter_NameButtonSpace;
        buttonFrame.size.width = buttonWidth;
        buttonFrame.size.height = UMCom_Forum_UserCenter_ButtonHeight;
        UIButton *album =  [self createNewButtonWithImageName:@"um_forum_user_album" title:UMComLocalizedString(@"um_forum_user_album", @"相册") action:@selector(clickOnAlbumButton:) frame:buttonFrame];
        [self addSubview:album];
        self.albumButton = album;
        
        buttonFrame.origin.x = buttonFrame.origin.x + buttonWidth + buttonSpace;
        UIButton *topic = [self createNewButtonWithImageName:@"um_forum_user_topic" title:UMComLocalizedString(@"um_forum_user_topic", @"话题") action:@selector(clickOnTopicButton:) frame:buttonFrame];
        [self addSubview:topic];
        self.topicButton = topic;
        
        buttonFrame.origin.x = buttonFrame.origin.x + buttonWidth + buttonSpace;
        buttonFrame.size.width = buttonFrame.size.width;
        
        NSString *pointStr = [NSString stringWithFormat:@"%ld",(long)countString(user.point)];
        UIButton *point = [self createNewButtonWithImageName:@"um_forum_user_score" title:[NSString stringWithFormat:@"积分%@",pointStr] action:@selector(clickOnScoreButton:) frame:buttonFrame];
        [self addSubview:point];
        point.enabled = NO;
        _scoreButton = point;
        
        buttonFrame.size.width = buttonFrame.size.width;
        buttonFrame.origin.x = self.avatarImageView.frame.origin.x + avatarWidth + 26;
        buttonFrame.origin.y = self.avatarImageView.frame.origin.y + self.avatarImageView.frame.size.height/2 - buttonFrame.size.height/2;
        buttonFrame.size.width = 80;
        UIButton * focuseButton = [self createNewButtonWithImageName:nil title:nil action:@selector(clickOnFocuseButton:) frame:buttonFrame];
        [focuseButton setBackgroundImage:UMComImageWithImageName(@"um_forum_user_focuse") forState:UIControlStateNormal];
        [self addSubview:focuseButton];
        _focuseButton = focuseButton;
        [self reloadSubViewsWithUser:user];
        self.backgroundColor = UMComColorWithColorValueString(UMCom_Forum_UserCenter_DetailViewBgColor);
        
        UMComHorizonCollectionView *collectionView = [[UMComHorizonCollectionView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-UMCom_Forum_UserCenter_MenuViewHeight, self.frame.size.width, UMCom_Forum_UserCenter_MenuViewHeight) itemCount:3];
        collectionView.cellDelegate = self;
        collectionView.itemSpace = 0;
        collectionView.bottomLineHeight = 1;
        collectionView.topLine.backgroundColor = UMComColorWithColorValueString(@"#EEEFF3");
        collectionView.bottomLine.backgroundColor = UMComColorWithColorValueString(@"#EEEFF3");
        collectionView.indicatorLineHeight = 3;
        collectionView.scrollIndicatorView.backgroundColor = UMComColorWithColorValueString(@"#008BEA");
        collectionView.indicatorLineWidth = UMComWidthScaleBetweenCurentScreenAndiPhone6Screen(32);
        collectionView.indicatorLineLeftEdge = UMComWidthScaleBetweenCurentScreenAndiPhone6Screen(47);
        collectionView.scrollEnabled = NO;
        [self addSubview:collectionView];
        self.menuView = collectionView;
        self.countLabelList = [self createLabelList];
        //重新布局
//        [self relayoutMedalView];
        //单勋章布局
        //[self relayoutMedalView];
        
        //多勋章布局
        [self clearRequestForMedalViews];
        [self requestIMGForMedalViews:user];
    }
    return self;
}


- (UIButton *)createNewButtonWithImageName:(NSString *)imageName
                                     title:(NSString *)title
                                    action:(SEL)action
                                     frame:(CGRect)frame;
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = UMComFontNotoSansLightWithSafeSize(UMCom_Forum_UserCenter_ProfileButtonFont);
    [button setTitleColor:UMComColorWithColorValueString(UMCom_Forum_UserCenter_ButtonTitleColor) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:UMComImageWithImageName(imageName) forState:UIControlStateNormal];
    CGFloat imageWidth = 20;
    CGFloat imageEdge = 5;
    [button setImageEdgeInsets:UIEdgeInsetsMake(imageEdge, imageEdge, imageEdge, frame.size.width - imageWidth*2)];
    return button;
}


- (void)clickOnAlbumButton:(UIButton *)sender
{
    if (self.deleagte && [self.deleagte respondsToSelector:@selector(userProfileDetailView:clickOnAlbum:)]) {
        [self.deleagte userProfileDetailView:self clickOnAlbum:sender];
    }
}

- (void)clickOnTopicButton:(UIButton *)sender
{
    if (self.deleagte && [self.deleagte respondsToSelector:@selector(userProfileDetailView:clickOnFollowTopic:)]) {
        [self.deleagte userProfileDetailView:self clickOnFollowTopic:sender];
    }
}

- (void)clickOnScoreButton:(UIButton *)sender
{
    if (self.deleagte && [self.deleagte respondsToSelector:@selector(userProfileDetailView:clickOnScore:)]) {
        [self.deleagte userProfileDetailView:self clickOnScore:sender];
    }
}

- (void)clickOnFocuseButton:(UIButton *)sender
{
    if (self.deleagte && [self.deleagte respondsToSelector:@selector(userProfileDetailView:clickOnfocuse:)]) {
        [self.deleagte userProfileDetailView:self clickOnfocuse:sender];
    }
}

- (void)tapOnAvatar:(id)sender
{
    if (self.deleagte && [self.deleagte respondsToSelector:@selector(userProfileDetailView:clickOnAvatar:)]) {
        [self.deleagte userProfileDetailView:self clickOnAvatar:self.avatarImageView];
    }
}

- (void)reloadSubViewsWithUser:(UMComUser *)user
{
    NSString *scoreStr = [NSString stringWithFormat:@"%@",countString(user.point)];
//    CGSize titleSize = [scoreStr sizeWithFont:UMComFontNotoSansLightWithSafeSize(UMCom_Forum_UserCenter_ProfileButtonFont) forWidth:100 lineBreakMode:NSLineBreakByTruncatingTail];
    [self.scoreButton setTitle:scoreStr forState:UIControlStateNormal];
//    CGRect buttonFrame = self.scoreButton.frame;
//    buttonFrame.size.width = UMCom_Forum_UserCenter_ButtonWidth + titleSize.width;
//    self.scoreButton.frame = buttonFrame;
    self.user = user;
    [self.avatarImageView setImageURL:self.user.icon_url.small_url_string
                     placeHolderImage:UMComImageWithImageName(@"male")];
    if (self.user.medal_list.count > 0) {
        UMComMedal *medal = self.user.medal_list.firstObject;
        [self.medal_icon setImageURL:medal.icon_url placeHolderImage:nil];
    }
    if ([self.user.uid isEqualToString:[UMComSession sharedInstance].uid]|| [self.user.atype intValue] == 3) {
        _focuseButton.hidden = YES;
    }else{
        _focuseButton.hidden = NO;
        if ([self.user.has_followed boolValue] && [self.user.be_followed boolValue]) {
            [self.focuseButton setBackgroundImage:UMComImageWithImageName(@"um_forum_user_interfocuse") forState:UIControlStateNormal];
        }else if ([self.user.has_followed boolValue]){
            [self.focuseButton setBackgroundImage:UMComImageWithImageName(@"um_forum_user_hasfocused") forState:UIControlStateNormal];
        }else{
            [self.focuseButton setBackgroundImage:UMComImageWithImageName(@"um_forum_user_focuse") forState:UIControlStateNormal];
        }
    }
    self.nameLabel.text = self.user.name;
    CGSize textSize = CGSizeMake(self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
    if (self.user.name && self.user.name.length > 0) {
        textSize = [self.user.name sizeWithFont:self.nameLabel.font constrainedToSize:CGSizeMake(self.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        self.nameLabel.frame = CGRectMake(0, self.nameLabel.frame.origin.y, textSize.width, self.nameLabel.frame.size.height);
        self.nameLabel.center = CGPointMake(self.frame.size.width/2, self.nameLabel.center.y);
        self.genderView.hidden = NO;
    }
    self.genderView.center = CGPointMake(self.genderView.frame.size.width + textSize.width+self.nameLabel.frame.origin.x, self.nameLabel.center.y);
    if ([self.user.gender integerValue] == 0) {
        self.genderView.image = UMComImageWithImageName(@"um_forum_user_ladygender");
    }else{
        self.genderView.image = UMComImageWithImageName(@"um_forum_user_mangender");
    }
    [self.menuView reloadData];
}


#pragma mark - UMComHorizonCollectionViewDelegate
- (void)horizonCollectionView:(UMComHorizonCollectionView *)collectionView
                   reloadCell:(UMComHorizonCollectionCell *)cell
                  atIndexPath:(NSIndexPath *)indexPath
{
    UILabel *countLabel = self.countLabelList[indexPath.row];
    CGRect countLabelFrame = countLabel.frame;
    countLabelFrame.origin.x = cell.label.frame.origin.x;
    countLabelFrame.origin.y = 2;
    countLabel.frame = countLabelFrame;
    if (countLabel.superview != cell.contentView) {
        [cell.contentView addSubview:countLabel];
    }
    
    CGRect titleLabelFrame = cell.label.frame;
    titleLabelFrame.origin.y = countLabel.frame.origin.y + countLabel.frame.size.height;
    titleLabelFrame.size.height = cell.frame.size.height - titleLabelFrame.origin.y-4;
    cell.label.frame = titleLabelFrame;
    if (indexPath.row == 0) {
        countLabel.text = [NSString stringWithFormat:@"%@",countString(self.user.feed_count)];
        cell.label.text = [NSString stringWithFormat:@"%@",UMComLocalizedString(@"User_Feed", @"消息")];
        //        cell.label.text = [NSString stringWithFormat:@"%@\n%@",self.user.feed_count,UMComLocalizedString(@"User_Feed", @"消息")];
    }else if (indexPath.row == 1){
        countLabel.text = [NSString stringWithFormat:@"%@",countString(self.user.following_count)];
        cell.label.text = [NSString stringWithFormat:@"%@",UMComLocalizedString(@"User_Followers", @"关注")];
        //        cell.label.text = [NSString stringWithFormat:@"%@\n%@",self.user.following_count,UMComLocalizedString(@"User_Followers", @"关注")];
    }else if (indexPath.row == 2){
        countLabel.text = [NSString stringWithFormat:@"%@",countString(self.user.fans_count)];
        cell.label.text = [NSString stringWithFormat:@"%@",UMComLocalizedString(@"User_Fans", @"粉丝")];
    }
    if (indexPath.row == collectionView.currentIndex) {
        cell.label.textColor = UMComColorWithColorValueString(UMCom_Forum_UserCenter_MenuTitleHighLightColor);
    }else{
        cell.label.textColor = UMComColorWithColorValueString(UMCom_Forum_UserCenter_MenuTitleColor);
    }
    countLabel.textColor = cell.label.textColor;
    cell.label.font = UMComFontNotoSansLightWithSafeSize(UMCom_Forum_UserCenter_MenuTitleFont);
    cell.label.backgroundColor = [UIColor whiteColor];
    cell.label.textAlignment = NSTextAlignmentCenter;
}

- (NSMutableArray *)createLabelList
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
    CGFloat labelWidth = self.frame.size.width/3;
    CGFloat labelHeight = 20;
    for (int index =0; index < 3; index++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
        label.backgroundColor = [UIColor whiteColor];
        label.font = UMComFontNotoSansLightWithSafeSize(UMCom_Forum_UserCenter_MenuCountFont);
        label.textColor = UMComColorWithColorValueString(UMCom_Forum_UserCenter_MenuTitleColor);
        label.textAlignment = NSTextAlignmentCenter;
        [array addObject:label];
    }
    return array;
}

- (void)horizonCollectionView:(UMComHorizonCollectionView *)collectionView didSelectedColumn:(NSInteger)column
{
    self.lastIndex = collectionView.lastIndex;
    if (self.deleagte && [self.deleagte respondsToSelector:@selector(userProfileDetailView:clickAtIndex:)]) {
        [self.deleagte userProfileDetailView:self clickAtIndex:column];
    }
    [collectionView reloadData];
}
/*
-(void) doRelayoutMedalView
{

    //如果有勋章图片的话，就要修改self.nameLabel下面控件的所有布局
    CGFloat medalWidth = [UMComMedalImageView defaultWidth];
    CGFloat medalHeight = self.nameLabel.bounds.size.height;
    
    CGSize cellSize = self.bounds.size;
    
    CGFloat medalTopMargin = 0;
    CGFloat medalBottomMargin = 0;
    
    //计算勋章宽高
    if (self.medalView.image) {
        
        //根据图片宽高比例确定宽度
       CGSize imgSize =  self.medalView.image.size;
       medalWidth =  medalHeight * imgSize.width /  imgSize.height;
        if (medalWidth >= cellSize.width) {
            //宽度大于cell的宽度，就取nameLabel的宽度
            medalWidth = self.nameLabel.bounds.size.width;
        }
    }
    else{}
    
    //计算勋章坐标位置,使其中心个头像中心一直
    CGFloat orginx = (self.bounds.size.width - medalWidth)/2;
    CGFloat orginy = self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + medalTopMargin;
    self.medalView.frame = CGRectMake(orginx, orginy, medalWidth, medalHeight);
    
    //布局勋章下面的控件
    CGFloat medalViewOffset = self.medalView.frame.origin.y +  self.medalView.frame.size.height + medalBottomMargin;
    CGRect albumButtonFrame  = self.albumButton.frame;
    albumButtonFrame.origin.y = medalViewOffset;
    self.albumButton.frame = albumButtonFrame;
    
    CGRect topicButtonFrame = self.topicButton.frame;
    topicButtonFrame.origin.y = medalViewOffset;
    self.topicButton.frame = topicButtonFrame;
    
    CGRect scoreButtonFrame = self.scoreButton.frame;
    scoreButtonFrame.origin.y = medalViewOffset;
    self.scoreButton.frame = scoreButtonFrame;
    
}

-(void) relayoutMedalView
{
    if (self.user.medal_list.count > 0) {
        UMComMedal *medal = self.user.medal_list.firstObject;
       NSString* icon_url =  medal.icon_url;
        if(icon_url)
        {
            self.medalView.imageLoaderDelegate =  self;
            self.medalView.isAutoStart = YES;
            [self.medalView setImageURL:[NSURL URLWithString:icon_url] placeholderImage:nil];
            
            [self doRelayoutMedalView];
        }
        else
        {
            self.medalView.hidden = YES;
            self.medalView.delegate = nil;
        }
    }
    else
    {
        self.medalView.hidden = YES;
        self.medalView.delegate = nil;
    }
}
 */

#pragma mark - UMComImageViewDelegate
- (void)umcomImageViewLoadedImage:(UMComImageView *)imageView;
{
    //单勋章布局
    //[self doRelayoutMedalView];
    
    //多勋章布局
    [self layoutMedalViews];
}

-(void) createMedalViews
{
    //创建默认的medalViewArray队列
    self.medalViewArray = [NSMutableArray arrayWithCapacity:[UMComMedalImageView maxMedalCount]];
    
    //创建勋章
    for(NSInteger i = 0; i < [UMComMedalImageView maxMedalCount]; i++)
    {
        UMComMedalImageView* medalView = [[UMComMedalImageView alloc] initWithFrame:CGRectMake(0, 0, [UMComMedalImageView defaultWidth], [UMComMedalImageView defaultHeight])];
        medalView.tag = i;
        medalView.contentMode =  UIViewContentModeScaleAspectFit;
        [self.medalViewArray addObject:medalView];
        [self addSubview:medalView];
    }
    
}

-(void) requestIMGForMedalViews:(UMComUser*)user
{
    if (user.medal_list.count > 0) {
        //确认当前勋章不能超过[UMComMedalImageView maxMedalCount]
        self.curMedalCount = user.medal_list.count;
        if (self.curMedalCount > [UMComMedalImageView maxMedalCount]) {
            self.curMedalCount = [UMComMedalImageView maxMedalCount];
        }
        
        for(int i = 0;i < self.curMedalCount; i++)
        {
            UMComMedalImageView* medalView  = self.medalViewArray[i];
            if (medalView) {
                medalView.hidden = NO;
                UMComMedal* umcomMedal = (UMComMedal*)user.medal_list[i];
                if (umcomMedal && umcomMedal.icon_url) {
                    medalView.imageLoaderDelegate =  nil;
                    medalView.isAutoStart = YES;
                    [medalView setImageURL:[NSURL URLWithString:umcomMedal.icon_url] placeholderImage:nil];
                    medalView.imageLoaderDelegate =  self;
                }
                else{
                    medalView.hidden = YES;
                }
                
            }
        }
        
        [self layoutMedalViews];
    }
}

-(void) clearRequestForMedalViews
{
    for(int i = 0;i < self.medalViewArray.count; i++)
    {
        UMComMedalImageView* medalView  = self.medalViewArray[i];
        if (medalView) {
            medalView.hidden = YES;
            medalView.imageLoaderDelegate = nil;
        }
    }
}

-(CGSize)computeMedalViewSize:(UMComMedalImageView*)medalView
{
    if (!medalView) {
        return CGSizeMake(0, 0);
    }
    
    //先确定勋章图片的宽度和高度；
    CGFloat medalWidth = [UMComMedalImageView defaultWidth];
    CGFloat medalHeight = [UMComMedalImageView defaultHeight];
    
    CGSize cellSize = self.bounds.size;

    if (medalView.image) {
        
        CGSize  tempSize = medalView.image.size;
        
        if (tempSize.height <= medalHeight) {
            medalHeight = tempSize.height;
        }
        else{
            //目前只是简单的判断图片的高度是否超过self.nameLabel.frame的高度
            if (tempSize.height < self.nameLabel.frame.size.height) {
                medalHeight = tempSize.height;
            }
            else
            {
                medalHeight = self.nameLabel.frame.size.height;
            }
        }
        
        if (tempSize.width <= medalWidth) {
            medalWidth = tempSize.width;
        }
        else{
            //根据图片的宽高比，算勋章的宽度
            medalWidth =  medalHeight * tempSize.width /  tempSize.height;
            if (medalWidth >= cellSize.width) {
                //如果宽度大于cell的宽度就设置为默认值(此处只是简单判断)
                medalWidth = [UMComMedalImageView defaultWidth];
            }
        }
    }
    
    medalView.bounds = CGRectMake(0, 0, medalWidth, medalHeight);
    return medalView.bounds.size;
}

-(void) layoutMedalViews
{
    CGFloat medalTopMargin = 0;
    CGFloat medalBottomMargin = 0;
    
    //先确定勋章图片的宽度和高度
    CGFloat totalMedalWidth = 0;
    CGFloat maxMedalHeight = 0;
    for (int i = 0; i < self.curMedalCount; i++) {
        
        //先计算图片的宽高
        UMComMedalImageView* medalView  = self.medalViewArray[i];
        if (medalView) {
            CGSize medalViewSize = [self computeMedalViewSize:medalView];
            if (i == self.curMedalCount -1) {
                totalMedalWidth += medalViewSize.width;
            }
            else{
                totalMedalWidth += medalViewSize.width + [UMComMedalImageView spaceBetweenMedalViews];
            }
            
            if (maxMedalHeight < medalViewSize.height) {
                maxMedalHeight = medalViewSize.height;
            }
            
            //判断当前的请求的图片是否获得，如果还没有获得把高度设置为0，等于不显示
            if (!medalView.image) {
                maxMedalHeight = 0;
            }
        }
    }
    
    //计算勋章坐标位置,使其对称显示
    CGFloat orginx = (self.bounds.size.width - totalMedalWidth)/2;
    CGFloat orginy = self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + medalTopMargin;
    CGFloat orginXOffset = orginx;
    for (int i = 0; i < self.curMedalCount; i++) {
        UMComMedalImageView* medalView  = self.medalViewArray[i];
        if (medalView) {
            CGRect medalViewFrame = medalView.frame;
            medalViewFrame.origin.x = orginXOffset;
            medalViewFrame.origin.y = orginy;
            medalView.frame = medalViewFrame;
            orginXOffset += medalViewFrame.size.width + [UMComMedalImageView spaceBetweenMedalViews];
        }
    }
    
    
    //布局勋章下面的控件
    CGFloat medalViewOffset = self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + maxMedalHeight + medalBottomMargin;
    CGRect albumButtonFrame  = self.albumButton.frame;
    albumButtonFrame.origin.y = medalViewOffset;
    self.albumButton.frame = albumButtonFrame;
    
    CGRect topicButtonFrame = self.topicButton.frame;
    topicButtonFrame.origin.y = medalViewOffset;
    self.topicButton.frame = topicButtonFrame;
    
    CGRect scoreButtonFrame = self.scoreButton.frame;
    scoreButtonFrame.origin.y = medalViewOffset;
    self.scoreButton.frame = scoreButtonFrame;
    

}



@end
