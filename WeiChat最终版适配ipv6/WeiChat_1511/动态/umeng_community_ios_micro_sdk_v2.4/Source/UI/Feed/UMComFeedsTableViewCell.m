//
//  UMComFeedsTableViewCell.m
//  UMCommunity
//
//  Created by Gavin Ye on 8/27/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComFeedsTableViewCell.h"
#import "UMComSession.h"
#import "UMComFeedStyle.h"
#import "UMComClickActionDelegate.h"
#import "UMComTopic.h"
#import "UMComFeed.h"
#import "UMComMutiStyleTextView.h"
#import "UMComImageView.h"
#import "UMComGridView.h"
#import "UMComTools.h"
#import "UMComUser+UMComManagedObject.h"
#import "UMComLocationModel.h"
#import "UMComMedalImageView.h"
#import "UMComMedal+CoreDataProperties.h"


@interface UMComFeedsTableViewCell ()<UMComClickActionDelegate,UMComImageViewDelegate>

@property (nonatomic, assign) CGFloat cellSubviewCommonWidth;

@property (nonatomic, strong) UMComFeedStyle *feedStyle;

@property (nonatomic, assign) CGFloat subViewWidth;



//多勋章布局
@property(nonatomic,assign)NSInteger curMedalCount;//勋章的数量(最大5个)
@property(nonatomic,strong)NSMutableArray* medalViewArray;//包含勋章控件(UMComMedalImageView)
-(void) createMedalViews;
-(void) requestIMGForMedalViews:(UMComUser*)user;
-(void) clearRequestForMedalViews;
-(CGSize)computeMedalViewSize:(UMComMedalImageView*)medalView;
-(void) layoutMedalViews;

//重新布局勋章（单个勋章布局）
//@property(nonatomic,strong)UMComMedalImageView* medalView;
//-(void)reloadMedalView;

@end



@implementation UMComFeedsTableViewCell

-(void)awakeFromNib
{
    UIFont *font = UMComFontNotoSansLightWithSafeSize(UMCom_Micro_FeedButton_FontSize);
    self.likeButton.titleLabel.font = font;
    self.forwardButton.titleLabel.font = font;
    self.commentButton.titleLabel.font = font;
    self.likeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.forwardButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.commentButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.likeButton setTitleColor:UMComColorWithColorValueString(UMCom_Micro_Feed_ButtonTitleCollor) forState:UIControlStateNormal];
    [self.forwardButton setTitleColor:UMComColorWithColorValueString(UMCom_Micro_Feed_ButtonTitleCollor) forState:UIControlStateNormal];
    [self.commentButton setTitleColor:UMComColorWithColorValueString(UMCom_Micro_Feed_ButtonTitleCollor) forState:UIControlStateNormal];
    self.contentView.backgroundColor = UMComColorWithColorValueString(UMCom_Micro_Feed_CellBgCollor);
    self.feedBgView.layer.cornerRadius = 5;
    self.feedBgView.layer.borderWidth = 1;
    self.feedBgView.layer.borderColor = UMComColorWithColorValueString(@"#EEEFF3").CGColor;
    self.feedBgView.clipsToBounds = YES;
    self.locationLabel.font = UMComFontNotoSansLightWithSafeSize(12);
    self.portrait = [[[UMComImageView imageViewClassName] alloc]initWithFrame:CGRectMake(UMCom_Micro_Feed_Avata_LeftEdge, UMCom_Micro_Feed_Avata_TopEdge, UMCom_Micro_Feed_Avata_Width, UMCom_Micro_Feed_Avata_Width)];
    self.portrait.userInteractionEnabled = YES;
    [self.feedBgView addSubview:self.portrait];
    
    self.dateLabel.textColor = [UMComTools colorWithHexString:FontColorGray];
    
    UITapGestureRecognizer *tapPortrait = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapPortrait)];
    [self.portrait addGestureRecognizer:tapPortrait];
    
    UITapGestureRecognizer *tapOnGridView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnImageGridView)];
    [self.imageGridView addGestureRecognizer:tapOnGridView];
    [self.originFeedBackgroundView addGestureRecognizer:tapOnGridView];
    
    UITapGestureRecognizer *tapLocationView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClicLocation:)];
    [self.locationBgView addGestureRecognizer:tapLocationView];
    
    self.nameLabel.font = UMComFontNotoSansLightWithSafeSize(17);
    self.locationDistance.font = UMComFontNotoSansLightWithSafeSize(12);
    self.locationLabel.font = UMComFontNotoSansLightWithSafeSize(12);
    self.dateLabel.font = UMComFontNotoSansLightWithSafeSize(10);
    
    self.nameLabel.textColor = UMComColorWithColorValueString(UMCom_Micro_Feed_NameCollor);
    self.dateLabel.textColor = UMComColorWithColorValueString(UMCom_Micro_Feed_DateColor);
    self.locationLabel.textColor = UMComColorWithColorValueString(UMCom_Micro_Feed_LocationCollor);

    UITapGestureRecognizer *tapSelfView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToFeedDetaiView)];
    [self addGestureRecognizer:tapSelfView];
    //创建勋章控件
//    self.medalView = [[UMComMedalImageView alloc] initWithFrame:CGRectMake(0, 0, [UMComMedalImageView defaultWidth], [UMComMedalImageView defaultHeight])];
//    self.medalView.contentMode =  UIViewContentModeScaleAspectFit;
//    [self.feedBgView addSubview:self.medalView];
    
    [self createMedalViews];

}

/****************************reload cell views start *****************************/
- (void)reloadFeedWithfeedStyle:(UMComFeedStyle *)feedStyle tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = self.feedBgView.frame;
    frame.origin.y = self.cellBgViewTopEdge;
    frame.size.width = self.contentView.frame.size.width - frame.origin.x*2;
    frame.size.height = feedStyle.totalHeight - UMCom_Micro_Feed_Cell_Space;
    self.feedBgView.frame = frame;
    self.feed = feedStyle.feed;
    self.indexPath = indexPath;
    self.cellSubviewCommonWidth = feedStyle.subViewWidth;
    [self reloadDetaiViewWithFeedStyle:feedStyle viewWidth:tableView.frame.size.width];
  
    if ([self.feed.liked boolValue]) {
        [self.likeButton setImage:UMComImageWithImageName(@"um_micro_like_highlight") forState:UIControlStateNormal];
    }else{
        [self.likeButton setImage:UMComImageWithImageName(@"um_micro_like_normal") forState:UIControlStateNormal];
    }
    [self reloadMenuBgViewWithFeed:self.feed originHeigt:self.dateLabel.frame.origin.y];
    
    if ([self.feed.status intValue] >= FeedStatusDeleted){
        self.bottomMenuBgView.hidden = YES;
    } else {
        self.bottomMenuBgView.hidden = NO;
    }
}


- (void)reloadDetaiViewWithFeedStyle:(UMComFeedStyle *)feedStyle viewWidth:(CGFloat)viewWidth
{
    self.feed = feedStyle.feed;
    self.feedStyle = feedStyle;
    self.subViewWidth = feedStyle.subViewWidth;
    
    UMComFeed *feed = feedStyle.feed;
    self.nameLabel.text = feed.creator.name;
    
    //刷新头像
    [self reloadAvatarImageViewWithFeed:feed];
    
    CGRect eletImageFrame = self.eletImage.frame;
    if ([feed.type intValue] == 1) {
     if (feedStyle.isShowTopIamge) {
            eletImageFrame.origin.x = self.topImage.frame.origin.x + self.topImage.frame.size.width + 8;
        }else{
            eletImageFrame.origin.x = self.topImage.frame.origin.x;
        }
        self.publicImage.hidden = NO;
    }else{
        self.publicImage.hidden = YES;
    }
    
    if (feedStyle.isShowTopIamge) {
        self.topImage.hidden = NO;
    }else{
        self.topImage.hidden = YES;
    }
    if ([feed.tag integerValue] == 1) {
        CGRect eletImageFrame = self.eletImage.frame;
        if (self.topImage.hidden == NO) {
            eletImageFrame.origin.x = self.topImage.frame.origin.x + self.topImage.frame.size.width + 10;
        }else{
            eletImageFrame.origin.x = self.topImage.frame.origin.x;
        }
        self.eletImage.frame = eletImageFrame;
        self.eletImage.hidden = NO;
    }else{
        self.eletImage.hidden = YES;
    }
    self.nameLabel.frame = CGRectMake(UMCom_Micro_FeedContent_LeftEdge, UMCom_Micro_Feed_Avata_TopEdge, feedStyle.nameLabelWidth, self.nameLabel.frame.size.height);
    
    //布局勋章(包括重新布局nameLabel的宽度)---begin
    //单个勋章布局
    /*
    UMComUser* user = feed.creator;
    if (user.medal_list.count > 0) {
        self.medalView.hidden = NO;
        UMComMedal* umcomMedal = (UMComMedal*)user.medal_list.firstObject;
        if (umcomMedal && umcomMedal.icon_url) {
            self.medalView.imageLoaderDelegate =  self;
            self.medalView.isAutoStart = YES;
            [self.medalView setImageURL:[NSURL URLWithString:umcomMedal.icon_url] placeholderImage:nil];
            
            [self reloadMedalView];
        }
    }
    else
    {
        self.medalView.hidden = YES;
        self.medalView.imageLoaderDelegate = nil;
    }
     */
    UMComUser* user = feed.creator;
    if (user.medal_list.count > 0) {
        [self clearRequestForMedalViews];
        [self requestIMGForMedalViews:feed.creator];
    }
    else{
        [self clearRequestForMedalViews];
    }
    
    //布局勋章(包括重新布局nameLabel的宽度)---end
    
    float totalHeight = self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height+UMCom_Micro_FeedCellItem_Vertical_Space;
    
    if (feed) {
        //刷新feedTextView
        [self reloadFeedTextViewWithFeed:feed originHeigt:totalHeight];
        totalHeight += self.feedStyleView.frame.size.height;
    }
    float totalBgHeight = UMCom_Micro_FeedForwardText_TopEdge;
    UMComFeed *originFeed = feedStyle.originFeed;
    if (originFeed) {
        //如果是转发，显示originFeedTextView，否则隐藏
        self.originFeedStyleView.hidden = NO;
        [self reloadOriginFeedTextViewWithFeed:feed originHeigt:totalBgHeight];
        totalBgHeight += self.originFeedStyleView.frame.size.height;
        self.originFeedBackgroundView.backgroundColor = UMComColorWithColorValueString(UMCom_Micro_Feed_ForwardBgCollor);
//        totalHeight += UMCom_Micro_FeedCellItem_Vertical_Space/2;
    } else {
        totalBgHeight = 0;
        self.originFeedBackgroundView.backgroundColor = [UIColor whiteColor];
        self.originFeedStyleView.hidden = YES;
    }
    
    NSArray *imagesArray = feedStyle.imageModels;
    CGFloat originX = feedStyle.imageGridViewOriginX;
    //如果存在定位信息则显示否则隐藏
    if (feedStyle.locationModel == nil) {
        self.locationBgView.hidden = YES;
    } else {
        totalBgHeight += UMCom_Micro_FeedCellItem_Vertical_Space - UMCom_Micro_FeedContent_LineSpace;
        [self.locationLabel setText:feedStyle.locationModel.name];
        self.locationLabel.frame = CGRectMake(self.locationLabel.frame.origin.x, 0, self.subViewWidth, self.locationLabel.frame.size.height);
        self.locationBgView.hidden = NO;
        self.locationBgView.frame = CGRectMake(originX, totalBgHeight, self.locationBgView.frame.size.width, self.locationBgView.frame.size.height);
        totalBgHeight += self.locationBgView.frame.size.height;
    }

    if ([feed.distance integerValue] >= 0) {
        [self.locationDistance setText:[NSString stringWithFormat:@"%@m",countString(feed.distance)]];
        self.locationLabel.frame = CGRectMake(self.locationLabel.frame.origin.x, self.locationLabel.frame.origin.y, self.locationBgView.frame.size.width-self.locationDistance.frame.size.width-6, self.locationLabel.frame.size.height);
        self.locationDistance.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.locationDistance.hidden = NO;
    } else {
        self.locationDistance.hidden = YES;
    }
    if ([imagesArray count] == 0) {
        self.imageGridView.hidden = YES;
    } else {
        //如果有图片则刷新图片
        totalBgHeight += UMCom_Micro_FeedContent_LineSpace;
        [self reloadGridViewWithFeed:feed originHeigt:totalBgHeight imagesArr:imagesArray originX:originX];
        totalBgHeight += self.imageGridView.frame.size.height;
        totalBgHeight += UMCom_Micro_FeedForwardText_TopEdge-UMCom_Micro_FeedContent_LineSpace;

    }
    self.originFeedBackgroundView.frame = CGRectMake(self.feedStyle.subViewOriginX, totalHeight, self.subViewWidth, totalBgHeight);
    totalHeight += self.originFeedBackgroundView.frame.size.height+UMCom_Micro_FeedCellItem_Vertical_Space - UMCom_Micro_FeedContent_LineSpace;
    [self.dateLabel setText:feedStyle.dateString];
    self.dateLabel.frame = CGRectMake(self.feedStyle.subViewOriginX, totalHeight, self.subViewWidth, self.dateLabel.frame.size.height);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, feedStyle.totalHeight);
}

- (void)reloadAvatarImageViewWithFeed:(UMComFeed *)feed
{
    NSString *iconString = [feed.creator iconUrlStrWithType:UMComIconSmallType];
    UIImage *placeHolderImage = [UMComImageView placeHolderImageGender:[feed.creator.gender integerValue]];
    [self.portrait setImageURL:iconString placeHolderImage:placeHolderImage];
    self.portrait.clipsToBounds = YES;
    self.portrait.layer.cornerRadius = self.portrait.frame.size.width/2;
}

- (void)reloadFeedTextViewWithFeed:(UMComFeed *)feed originHeigt:(CGFloat)originHeigth
{
    self.feedStyleView.frame = CGRectMake(self.feedStyle.subViewOriginX, originHeigth, self.subViewWidth, self.feedStyle.feedStyleTextModel.textSize.height);
    [self.feedStyleView setMutiStyleTextViewWithMutiText:self.feedStyle.feedStyleTextModel];
    __weak typeof(self) weakSelf = self;
    self.feedStyleView.clickOnlinkText = ^(UMComMutiStyleTextView *styleView,UMComMutiTextRun *run){
        [weakSelf clickInTextView:weakSelf.feedStyleView mutiTextRun:run];
    };
}

- (void)reloadOriginFeedTextViewWithFeed:(UMComFeed *)feed originHeigt:(CGFloat)originHeigth
{
//    self.originFeedStyleView.pointOffset = CGPointMake(0, OriginFeedHeightOffset);
    self.originFeedStyleView.frame = CGRectMake(self.feedStyle.imageGridViewOriginX, UMCom_Micro_FeedForwardText_TopEdge, self.originFeedStyleView.frame.size.width, self.feedStyle.originFeedStyleTextModel.textSize.height);
    [self.originFeedStyleView setMutiStyleTextViewWithMutiText:self.feedStyle.originFeedStyleTextModel];
    __weak typeof(self) weakSelf = self;
    self.originFeedStyleView.clickOnlinkText = ^(UMComMutiStyleTextView *styleView,UMComMutiTextRun *run){
        [weakSelf clickInTextView:weakSelf.originFeedStyleView mutiTextRun:run];
    };
}

- (void)reloadGridViewWithFeed:(UMComFeed *)feed originHeigt:(CGFloat)originHeigth imagesArr:(NSArray *)imagesArray originX:(CGFloat)originX
{
    self.imageGridView.hidden = NO;
    CGFloat imageViewWidth = self.subViewWidth-originX*2;
    self.imageGridView.frame = CGRectMake(originX,  originHeigth, imageViewWidth, self.feedStyle.imagesViewHeight);
    [self.imageGridView setImages:imagesArray placeholder:UMComImageWithImageName(@"image-placeholder") cellPad:UMCom_Micro_Feed_Image_Space];
    self.imageGridView.frame = CGRectMake(originX,  originHeigth, self.originFeedBackgroundView.frame.size.width-originX*2, self.feedStyle.imagesViewHeight);
    __weak typeof(self) weakSelf = self;
    self.imageGridView.TapInImage = ^(UMComGridViewerController *viewerController, UIImageView *imageView){
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(customObj:clickOnImageView:complitionBlock:)]) {
            __strong typeof(self) strongSelf = weakSelf;
            [weakSelf.delegate customObj:strongSelf clickOnImageView:imageView complitionBlock:^(UIViewController *currentViewController) {
                [currentViewController presentViewController:viewerController animated:YES completion:^{
                }];
            }];
        }
    };
}


- (void)reloadMenuBgViewWithFeed:(UMComFeed *)feed originHeigt:(CGFloat)originHeigth
{
    [self.forwardButton setTitle:[NSString stringWithFormat:@"%@",countString(feed.forward_count)] forState:UIControlStateNormal];
    [self.likeButton setTitle:[NSString stringWithFormat:@"%@",countString(feed.likes_count)] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithFormat:@"%@",countString(feed.comments_count)] forState:UIControlStateNormal];
    
    self.bottomMenuBgView.frame = CGRectMake(self.bottomMenuBgView.frame.origin.x, originHeigth+1.5, self.bottomMenuBgView.frame.size.width, self.bottomMenuBgView.frame.size.height);
}

/****************************reload subViews views end *****************************/
#pragma mark - UMComClickActionDelegate
- (void)didTapPortrait
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnUser:)]) {
        [self.delegate customObj:self clickOnUser:self.feed.creator];
    }
}

- (void)clickInTextView:(UMComMutiStyleTextView *)styleView mutiTextRun:(UMComMutiTextRun *)mutiTextRun
{
    if ([mutiTextRun isKindOfClass:[UMComMutiTextRunClickUser class]]) {
        UMComMutiTextRunClickUser *userRun = (UMComMutiTextRunClickUser *)mutiTextRun;
        [self clickInUserWithUserNameString:userRun.text];
    }else if ([mutiTextRun isKindOfClass:[UMComMutiTextRunTopic class]])
    {
        UMComMutiTextRunTopic *topicRun = (UMComMutiTextRunTopic *)mutiTextRun;
        [self clickInTopicWithTopicNameString:topicRun.text];
    } else if ([mutiTextRun isKindOfClass:[UMComMutiTextRunURL class]]){
        [self clickInUrl:mutiTextRun.text];
    }
    else{
        if (styleView == self.feedStyleView) {
            [self goToFeedDetailView];
        }else if(styleView == self.originFeedStyleView){
            [self goToForwardDetailView];
        }
    }
}

- (void)clickInUrl:(NSString *)text
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnURL:)]) {
        [self.delegate customObj:self clickOnURL:text];
    }
}

- (void)goToForwardDetailView
{
    if (self.feed.origin_feed.isDeleted || [self.feed.origin_feed.status intValue] >= FeedStatusDeleted) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnOriginFeedText:)]) {
        [self.delegate customObj:self clickOnOriginFeedText:self.feed.origin_feed];
    }
}

- (void)goToFeedDetailView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnFeedText:)]) {
        [self.delegate customObj:self clickOnFeedText:self.feed];
    }
}

- (void)tapOnImageGridView
{
    if (self.feed.origin_feed) {
        [self goToForwardDetailView];
    }else{
        [self goToFeedDetailView];
    }
}

- (void)clickInUserWithUserNameString:(NSString *)nameString
{
    NSString *name = [nameString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    NSMutableArray *relatedUsers = [NSMutableArray arrayWithArray:self.feed.related_user.array];
    if (self.feed.origin_feed.creator) {
        [relatedUsers addObject:self.feed.origin_feed.creator];
    }
    for (UMComUser * user in relatedUsers) {
        if ([name isEqualToString:user.name]) {
            [self turnToUserCenterWithUser:user];
            break;
        }
    }
}

- (void)onClicLocation:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnLocationText:)]) {
        [self.delegate customObj:self clickOnLocationText:self.feed];
    }
}


- (void)clickInTopicWithTopicNameString:(NSString *)topicNameString
{
    NSString *topicName = [topicNameString substringWithRange:NSMakeRange(1, topicNameString.length -2)];
    for (UMComTopic * topic in self.feed.topics) {
        if ([topicName isEqualToString:topic.name]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnTopic:)]) {
                [self.delegate customObj:self clickOnTopic:topic];
            }
            break;
        }
    }
}

- (void)turnToUserCenterWithUser:(UMComUser *)user
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnUser:)]) {
        [self.delegate customObj:self clickOnUser:user];
    }
}

-(void)onClickUserProfile:(id)sender
{
    UMComUser *feedCreator = self.feed.creator;
    [self turnToUserCenterWithUser:feedCreator];
}

- (void)goToFeedDetaiView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnFeedText:)]) {
        [self.delegate customObj:self clickOnFeedText:self.feed];
    }
}

- (IBAction)didClickOnForwardButton:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnForward:)]) {
        [self.delegate customObj:self clickOnForward:self.feed];
    }
}

- (IBAction)didClickOnLikeButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnLikeFeed:)]) {
        [self.delegate customObj:self  clickOnLikeFeed:self.feed];
    }
}

- (IBAction)didClickOnCommentButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnComment:feed:)]) {
        [self.delegate customObj:self clickOnComment:nil feed:self.feed];
    }
}

- (IBAction)onClickOnMoreButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clikeOnMoreButton:)]) {
        [self.delegate customObj:self clikeOnMoreButton:sender];
    }
}

#pragma mark - UMImageViewDelegate
- (void)umcomImageViewLoadedImage:(UMComImageView *)imageView;
{
    //单个medalview的更新
    //[self reloadMedalView];
    
    //多个medalview更新
    [self layoutMedalViews];
}

/*
-(void)reloadMedalView
{
    //先确定勋章图片的宽度和高度；
    CGFloat medalWidth = [UMComMedalImageView defaultWidth];
    CGFloat medalHeight = [UMComMedalImageView defaultHeight];
    
    CGSize cellSize = self.contentView.bounds.size;
    
    if (self.medalView.image) {
        
       CGSize  tempSize = self.medalView.image.size;
        
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
    
    CGFloat nameLabelWidth = 0;
    CGFloat nameLabelMaxWidth = self.nameLabel.frame.size.width  - medalWidth - 10;
    CGSize nameLabelSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font];
    if (nameLabelSize.width > nameLabelMaxWidth) {
        nameLabelWidth = nameLabelSize.width;
    }
    else{
        nameLabelWidth = nameLabelSize.width;
    }
    
    CGRect nameLabelFrame = self.nameLabel.frame;
    nameLabelFrame.size.width = nameLabelWidth;
    self.nameLabel.frame = nameLabelFrame;
    
    self.medalView.frame = CGRectMake(self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width + 5, self.nameLabel.frame.origin.y, medalWidth, medalHeight);
    
}
 */

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
        [self.feedBgView addSubview:medalView];
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

//计算一个medalview的size
-(CGSize)computeMedalViewSize:(UMComMedalImageView*)medalView
{
    if (!medalView) {
        return CGSizeMake(0, 0);
    }
    
    //先确定勋章图片的宽度和高度；
    CGFloat medalWidth = [UMComMedalImageView defaultWidth];
    CGFloat medalHeight = [UMComMedalImageView defaultHeight];
    
    CGSize cellSize = self.contentView.bounds.size;
    
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

-(void)layoutMedalViews
{
    //先确定勋章图片的宽度和高度
    CGFloat totalMedalWidth = 0;
    for (int i = 0; i < self.curMedalCount; i++) {
        
        //先计算图片的宽高
        UMComMedalImageView* medalView  = self.medalViewArray[i];
        if (medalView) {
            CGSize medalViewSize = [self computeMedalViewSize:medalView];
            totalMedalWidth += medalViewSize.width + [UMComMedalImageView spaceBetweenMedalViews];
        }
    }
    
    //计算nameLabel的宽度
    CGFloat nameLabelWidth = 0;
    CGFloat nameLabelMaxWidth = self.nameLabel.frame.size.width  - totalMedalWidth - 10;
    CGSize nameLabelSize = [self.nameLabel.text sizeWithFont:self.nameLabel.font];
    if (nameLabelSize.width > nameLabelMaxWidth) {
        nameLabelWidth = nameLabelSize.width;
    }
    else{
        nameLabelWidth = nameLabelSize.width;
    }
    
    //确定nameLabel的范围
    CGRect nameLabelFrame = self.nameLabel.frame;
    nameLabelFrame.size.width = nameLabelWidth;
    self.nameLabel.frame = nameLabelFrame;
    
    //确定medalViews的范围
    CGFloat offsetX = self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width + 5;
    CGFloat offsetY = self.nameLabel.frame.origin.y;
    for (int i = 0; i < self.curMedalCount; i++) {
        
        UMComMedalImageView* medalView  = self.medalViewArray[i];
        if (medalView) {
            CGRect medalViewFrame =  medalView.frame;
            medalViewFrame.origin.x = offsetX;
            medalViewFrame.origin.y = offsetY;
            medalView.frame = medalViewFrame;
            offsetX += medalViewFrame.size.width + [UMComMedalImageView spaceBetweenMedalViews];
        }
    }
}

@end
