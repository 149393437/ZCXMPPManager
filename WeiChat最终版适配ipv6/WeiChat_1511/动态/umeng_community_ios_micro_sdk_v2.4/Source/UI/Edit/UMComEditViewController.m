//
//  UMComEditViewController.m
//  UMCommunity
//
//  Created by Gavin Ye on 9/2/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComEditViewController.h"
#import "UMComLocationListController.h"
#import "UMComFriendTableViewController.h"
#import "UMImagePickerController.h"
#import "UMComEditTopicsViewController.h"
#import "UMComUser.h"
#import "UMComTopic.h"
#import "UMComShowToast.h"
#import "UMUtils.h"
#import "UMComSession.h"
#import "UIViewController+UMComAddition.h"
#import "UMComNavigationController.h"
#import "UMComImageView.h"
#import "UMComAddedImageView.h"
#import "UMComBarButtonItem.h"
#import "UMComFeedEntity.h"
#import <AVFoundation/AVFoundation.h>
#import "UMComHorizonMenuView.h"
#import "UMComEditTextView.h"
#import "UMComMutiStyleTextView.h"
#import "UMComLocationModel.h"
#import "UMComPushRequest.h"
#import "UMComUser+UMComManagedObject.h"
#import "UMComFeed.h"
#import "UMComLocationView.h"
#import "UMComEditForwardView.h"
#import "UMComFeedOperationFinishDelegate.h"
#import "UMComEmojiKeyBoardView.h"
#import "UMComImageUrl.h"


#define ForwardViewHeight 101
#define EditToolViewHeight 43
#define textFont UMComFontNotoSansLightWithSafeSize(15)
#define MinTextLength 5

const CGFloat g_MicroTemplate_MainScreenWidth = 375.f;//微博屏幕的宽度参考值
const CGFloat g_MicroTemplate_MainScreenHeight = 667.f;//微博屏幕的高度参考值
const CGFloat g_MicroTemplate_TextViewLeftMargin = 15.f;//添加图片控件的高度
const CGFloat g_MicroTemplate_AddImageViewHeight = 90.f;//添加图片控件的高度
const CGFloat g_MicroTemplate_AddImageViewItemSize = 80.f;//添加图片控件的高度
const CGFloat g_MicroTemplate_AddImageViewMarginSpace = 15.f;//添加图片控件的高度
const CGFloat g_MicroTemplate_LocationViewHeight = 45.f;//添加地图控件的高度
const CGFloat g_MicroTemplate_EditMenuViewViewHeight = 45.f;//UMComHorizonMenuView的高度

//静态的提示图片
static UIImage* g_um_micro_topic_notice_img = nil;

@interface UMComEditViewController () <UMComEditTextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UMComEmojiKeyboardViewDelegate>
{
    UMComEmojiKeyboardView* _emojiKeyboardView;//表情键盘
    UIWindow* _systemKeyboardWindow;//系统键盘的window
    UIView* _systemInputSetContainerView;//
    UIView* _systemKeyboardView;//系统键盘的view
    UIButton* _emojiBtn;//点击表情的按钮
}

@property (nonatomic,strong) UMComEditTopicsViewController *topicsViewController;

@property (nonatomic, strong) UMComFeed *forwardFeed;       //转发的feed

@property (nonatomic, strong) NSMutableArray *forwardCheckWords;  //转发时用于校验高亮字体

@property (nonatomic, strong) UMComTopic *topic;

@property (nonatomic, assign) CGFloat visibleViewHeight;

@property (nonatomic, strong) NSMutableArray *originImages;

@property (strong, nonatomic) UMComAddedImageView *addedImageView;

@property (nonatomic,assign) NSInteger addImgViewHeightWithkeyboard;//图片控件带键盘的高度
@property (nonatomic,assign) BOOL isClickEmoji;//是否点击切换键盘,防止键盘hide和show时间回调多次，出现布局抖动现象
@property (nonatomic,assign) NSInteger addImgViewItemSize;//图片控件的itemsize

@property (nonatomic, strong) UMComEditTextView *realTextView;

@property (nonatomic, strong) UMComHorizonMenuView *editMenuView;

@property (nonatomic, strong) UIView *imagesBgView;


@property (nonatomic, strong) UMComEditForwardView * forwardFeedBackground;

@property (strong, nonatomic) UIImageView *topicNoticeBgView;

@property (strong, nonatomic) UMComLocationView *locationView;

@property (nonatomic, copy) void (^selectedFeedTypeBlock)(NSNumber *type);


@property (nonatomic, strong) UMComEmojiKeyboardView *emojiKeyboardView;
-(void) createEmojiKeyboardView;
-(void) showEmojiKeyboardView;
-(BOOL) findSysmtemKeyboard;
-(void) addEmojiKeyboardViewIntoSystemKeyboard;
-(void) changeEmojiBtnImg:(BOOL)isEmoji;

//隐藏话题提示
-(void) dismissTopicNoticeBgView;
-(void) presentTopicNoticeBgView;
-(void) animateTopicNoticeBgView;


/**
 *  初始化上次发送失败的数据
 */
-(void) initPrePostingData;

/**
 *  获得要发送的话题数组
 */
-(NSArray*)postingTopicsArray;
@end

@implementation UMComEditViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.editFeedEntity = [[UMComFeedEntity alloc]init];
    }
    return self;
}

-(id)initWithForwardFeed:(UMComFeed *)forwardFeed
{
    self = [self init];
    if (self) {
        self.forwardFeed = forwardFeed;
    }
    return self;
}

- (id)initWithTopic:(UMComTopic *)topic
{
    self = [self init];
    if (self) {
        self.topic = topic;
    }
    return self;
}

-(void) dealloc
{
    if (_emojiKeyboardView) {
        _emojiKeyboardView.hidden = YES;
        [_emojiKeyboardView removeFromSuperview];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWiilHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:self];
    [self.realTextView resignFirstResponder];
 
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismissTopicNoticeBgView) object:nil];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self presentTopicNoticeBgView];

}

- (void)viewDidLoad
{
    self.doNotShowBackButton = YES;
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.visibleViewHeight = 0;
    
    //根据屏幕计算图片控件的高度和itemsize
    CGSize mainScreenSize = [UIScreen mainScreen].bounds.size;
    CGFloat addImgViewHeight = g_MicroTemplate_AddImageViewHeight;
    addImgViewHeight = mainScreenSize.height * g_MicroTemplate_AddImageViewHeight/g_MicroTemplate_MainScreenHeight;
    self.addImgViewHeightWithkeyboard = addImgViewHeight;
    
    CGFloat itemWidth = g_MicroTemplate_AddImageViewItemSize;
    itemWidth = mainScreenSize.width * g_MicroTemplate_AddImageViewItemSize / g_MicroTemplate_MainScreenWidth;
    self.addImgViewItemSize = itemWidth;
    
    
    [self setTitleViewWithTitle:@"新鲜事"];
    [self topicsAddOneTopic:self.topic];
    //创建textView
    [self createTextView];
    
    if (self.forwardFeed) {
        [self followsAddOneUser:self.forwardFeed.creator];
    }else{
        [self showWhenEditNewFeed];
    }
    self.originImages = [NSMutableArray array];
    
    //设置导航条两端按钮
    UMComButton* leftCustomButtonView = [[UMComButton alloc] initWithNormalImageName:@"um_edit_cancel" target:self action:@selector(onClickClose:)];
    leftCustomButtonView.frame = CGRectMake(0, 0, 14, 14);
    UIBarButtonItem *leftButtonItem =  [[UMComBarButtonItem alloc] initWithCustomView:leftCustomButtonView];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
    
    UMComButton* rightCustomButtonView = [[UMComButton alloc] initWithNormalImageName:@"um_edit_send" target:self action:@selector(postContent)];
    rightCustomButtonView.frame = CGRectMake(0, 0, 20, 14);
    UIBarButtonItem *rightButtonItem =  [[UMComBarButtonItem alloc] initWithCustomView:rightCustomButtonView];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    
    self.forwardFeedBackground.hidden = YES;
    if ([UMComSession sharedInstance].draftFeed) {
        self.editFeedEntity = [UMComSession sharedInstance].draftFeed;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    

    [self.locationView.label setText:self.editFeedEntity.locationDescription];
    [self.realTextView becomeFirstResponder];
    
    [self createMenuView];
    self.editMenuView.frame = CGRectMake(self.editMenuView.frame.origin.x, self.editMenuView.frame.origin.y, self.view.frame.size.width, 50);
    if (self.forwardFeed) {
        if (!self.forwardFeedBackground) {
            [self showWhenForwordOldFeed];
        }
    }
    
    //初始化上次发送失败的数据
    [self initPrePostingData];
    
    //创建表情控件
    if (!self.forwardFeed) {
        //不是转发，就创建表情
        [self createEmojiKeyboardView];
    }
}

-(void) initPrePostingData
{
    if (self.realTextView && self.editFeedEntity.text) {
        //在函数内部已经加入了self.editFeedEntity.text的数据，此处只要传入空字符串即可
        [self editContentAppendKvoString:@""];
    }
    
    if (self.locationView && self.editFeedEntity.locationDescription) {
        self.locationView.label.text = self.editFeedEntity.locationDescription;
    }
    
    if (self.editFeedEntity.images) {
        [self.originImages addObjectsFromArray:self.editFeedEntity.images];
        [self handleOriginImages:self.editFeedEntity.images];
        [self.addedImageView setIntrinsicSize:CGSizeMake(self.addedImageView.frame.size.width, self.addImgViewHeightWithkeyboard)];
    }
    else
    {
        [self handleOriginImages:self.editFeedEntity.images];
    }
    
    
}


-(void)onClickClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - ViewsChange

- (void)createMenuView
{
    if (!self.editMenuView) {
        self.editMenuView = [[UMComHorizonMenuView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, g_MicroTemplate_EditMenuViewViewHeight)];
        self.editMenuView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.editMenuView];
        __weak typeof(self) weakSelf = self;
        self.editMenuView.selectedAtIndex = ^(UMComHorizonMenuView *menuView, NSInteger index){
            if (index == 0) {
                //调用话题
                [weakSelf showTopicPicker:nil];
            }else if (index == 1){
                //调用相机
                [weakSelf takePhoto:nil];
            }else if (index == 2){
                //相册
                [weakSelf showImagePicker:nil];

            }else if (index == 3){
                //@好友
                [weakSelf showAtFriend:nil];
            }else if (index == 4){
                [weakSelf showEmojiKeyboardView];
            }
            
            weakSelf.topicNoticeBgView.hidden = YES;
        };
        
        if (self.forwardFeed) {
            NSArray *menuItems = [NSArray arrayWithObjects:[UMComMenuItem itemWithTitle:nil imageName:@"um_edit_@_normal" highLightImageName:@"um_edit_@_highlight"],[UMComMenuItem itemWithTitle:nil imageName:@"um_edit_#_normal" highLightImageName:@"um_edit_#_highlight"],[UMComMenuItem itemWithTitle:nil imageName:@"um_edit_emoji_normal" highLightImageName:@"um_edit_emoji_highlight"], nil];
            for (UMComMenuItem *item in menuItems) {
                item.highLightType = HighLightImage;
                item.itemViewType = menuButtonType;
            }
            [self.editMenuView reloadWithNewMenuItems:menuItems leftMargin:35 rightMargin:35 itemSize:CGSizeMake(30, 30)];
            
            _emojiBtn = (UIButton*)[self.editMenuView viewWithIndex:menuItems.count -1];
            self.editMenuView.selectedAtIndex = ^(UMComHorizonMenuView *menuView, NSInteger index){
                if (index == 0) {
                    //@好友
                    [weakSelf showAtFriend:nil];

                }else if (index == 1){
                    //调用话题
                    [weakSelf showTopicPicker:nil];
                }else if (index == 2){
                   [weakSelf showEmojiKeyboardView];
                }
            };
        }else{
            NSArray *menuItems = [NSArray arrayWithObjects:[UMComMenuItem itemWithTitle:nil imageName:@"um_edit_#_normal" highLightImageName:@"um_edit_#_highlight"],[UMComMenuItem itemWithTitle:nil imageName:@"um_edit_camera_normal" highLightImageName:@"um_edit_camera_highlight"],[UMComMenuItem itemWithTitle:nil imageName:@"um_edit_photo_normal" highLightImageName:@"um_edit_photo_normal_highlight"],[UMComMenuItem itemWithTitle:nil imageName:@"um_edit_@_normal" highLightImageName:@"um_edit_@_highlight"],[UMComMenuItem itemWithTitle:nil imageName:@"um_edit_emoji_normal" highLightImageName:@"um_edit_emoji_highlight"], nil];

            for (UMComMenuItem *item in menuItems) {
                item.highLightType = HighLightImage;
                item.itemViewType = menuButtonType;
            }
            [self.editMenuView reloadWithMenuItems:menuItems
                                          itemSize:CGSizeMake(30, 30)];
            _emojiBtn = (UIButton*)[self.editMenuView viewWithIndex:menuItems.count -1];

            self.topicNoticeBgView.frame = CGRectMake(self.editMenuView.itemSize.width/2 + self.editMenuView.itemSpace, self.topicNoticeBgView.frame.origin.y, self.topicNoticeBgView.frame.size.width, self.topicNoticeBgView.frame.size.height);
            
            
        }
    }
}

#pragma mark -  UITextView relate method

- (void)createTextView
{
    NSArray *regexArray = [NSArray arrayWithObjects:UserRulerString, TopicRulerString,UrlRelerSring, nil];
    self.realTextView = [[UMComEditTextView alloc]initWithFrame:CGRectMake(g_MicroTemplate_TextViewLeftMargin, 0, self.view.frame.size.width-g_MicroTemplate_TextViewLeftMargin, 120) checkWords:[self getCheckWords] regularExStrArray:regexArray];
    self.realTextView.editDelegate = self;
    self.realTextView.maxTextLenght = [UMComSession sharedInstance].maxFeedLength;
    [self.realTextView setFont:textFont];
    __weak typeof(self) weakSekf = self;
    self.realTextView.getCheckWords = ^(){
        return [weakSekf getCheckWords];
    };
    //如果有话题则默认添加话题
    if (self.topic && [UMComSession sharedInstance].isShowTopicName) {
        [self.realTextView setText:[NSString stringWithFormat:TopicString,self.topic.name]];
    }
    self.realTextView.text = self.editFeedEntity.text;
    [self.realTextView updateEditTextView];
    [self.view addSubview:self.realTextView];
    
    CGRect placeholderLabelFrame =  self.realTextView.placeholderLabel.frame;
    placeholderLabelFrame.origin.x = 0;
    self.realTextView.placeholderLabel.frame = placeholderLabelFrame;
    self.realTextView.placeholderLabel.text = @" 写点什么吧";
    self.realTextView.textAlignment = NSTextAlignmentLeft;
}


- (NSArray *)getCheckWords
{
    NSMutableArray *checkWodrs = [NSMutableArray array];
    if (self.forwardCheckWords.count > 0) {
        [checkWodrs addObjectsFromArray:self.forwardCheckWords];
    }
    for (UMComTopic *topic in self.editFeedEntity.topics) {
        NSString *topicName = [NSString stringWithFormat:TopicString,topic.name];
        if (![checkWodrs containsObject:topicName]) {
            [checkWodrs addObject:topicName];
        }
    }
    for (UMComUser *user in self.editFeedEntity.atUsers) {
        NSString *userName = [NSString stringWithFormat:UserNameString,user.name];
        if (![checkWodrs containsObject:userName]) {
            [checkWodrs addObject:userName];
        }
    }
    return checkWodrs;
}

//隐藏话题提示
-(void) dismissTopicNoticeBgView
{
    self.topicNoticeBgView.hidden = YES;
    [self.topicNoticeBgView removeFromSuperview];
}

-(void) presentTopicNoticeBgView
{
    if (self.forwardFeed)
        return;
    
    //话题为空的时候就提示用户
    if (self.editFeedEntity.topics.count == 0) {
        
        if (![[self.view subviews] containsObject:self.topicNoticeBgView]) {
            return;
        }
        
        self.topicNoticeBgView.frame = CGRectMake(self.editMenuView.leftMargin + +self.editMenuView.itemSpace - 5 , self.editMenuView.frame.origin.y-self.topicNoticeBgView.frame.size.height, self.topicNoticeBgView.frame.size.width, self.topicNoticeBgView.frame.size.height);
        [self.view bringSubviewToFront:self.topicNoticeBgView];
        
        
//        [self performSelector:@selector(dismissTopicNoticeBgView) withObject:nil afterDelay:3 inModes:@[NSDefaultRunLoopMode]];
        [self animateTopicNoticeBgView];
    }
}


-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"moveTopicNoticeBgView"]) {
        [self dismissTopicNoticeBgView];
    }
}

-(void) animateTopicNoticeBgView
{
    CGPoint org_center = self.topicNoticeBgView.center;
    CGPoint target_center = CGPointMake(org_center.x,org_center.y + 5);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"moveTopicNoticeBgView" context:context];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelay:0.0f];
    [UIView setAnimationRepeatCount:2.5];
    [UIView setAnimationRepeatAutoreverses:YES];
    
    [UIView setAnimationDelegate:self];
    self.topicNoticeBgView.center = target_center;
    [UIView commitAnimations];
}

#pragma mark - 翻转提示图片
-(UIImage*)rotateMirroredImage:(UIImage *)aImage
{
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    
    transform = CGAffineTransformMakeTranslation(0.0, height);
    transform = CGAffineTransformScale(transform, 1.0, -1.0);
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

-(UIImage*) topicNoticeImg
{
    if (g_um_micro_topic_notice_img) {
        return g_um_micro_topic_notice_img;
    }
    UIImage* orgImg = UMComImageWithImageName(@"um_micro_topic_notice");
    if (!orgImg) {
        return nil;
    }
    
    UIImage* mirroredImage =  [self rotateMirroredImage:orgImg];
    if (!mirroredImage) {
        return nil;
    }
    
//    UIImage *resizableImage = [mirroredImage resizableImageWithCapInsets:UIEdgeInsetsMake(15, 12, 15, 12) resizingMode:UIImageResizingModeStretch];
    
    g_um_micro_topic_notice_img = mirroredImage;
    return g_um_micro_topic_notice_img;
}

#pragma mark -

- (void)showWhenEditNewFeed
{
//    self.topicNoticeBgView = [[UIImageView alloc]initWithFrame: CGRectMake(20, 300, 200, 30)];
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, self.topicNoticeBgView.frame.size.width, 25)];
    self.topicNoticeBgView = [[UIImageView alloc]initWithFrame: CGRectMake(20, 300, 176, 41)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, 154, 30)];

    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = textFont;
    label.textColor = UMComColorWithColorValueString(@"008bea");
    [self.topicNoticeBgView addSubview:label];
    if ([[[[UMComSession sharedInstance] loginUser] gender] integerValue] == 1) {
        label.text = @"大哥啊,添加个话题吧!";
    }else{
        label.text = @"大妹砸,添加个话题吧!";
    }
    //self.topicNoticeBgView.image = UMComImageWithImageName(@"add_topic_notice");
    self.topicNoticeBgView.image = [self topicNoticeImg];
    self.topicNoticeBgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.topicNoticeBgView];
    
    //self.realTextView.placeholderLabel.text = @" 分享新鲜事...";
    //[self handleOriginImages:self.editFeedEntity.images];
}


- (void)showWhenForwordOldFeed
{
    UMComFeed *originFeed = self.forwardFeed;
    NSString *feedAndUserNamesText = @" ";
    self.forwardCheckWords = [NSMutableArray array];
    NSArray *tempArray = [self getFeedCheckWordsFromFeed:originFeed];
    for (NSString *checkWord in tempArray) {
        if (![self.forwardCheckWords containsObject:checkWord]) {
            [self.forwardCheckWords addObject:checkWord];
        }
    }
    while (originFeed.origin_feed) {
        feedAndUserNamesText = [feedAndUserNamesText stringByAppendingFormat:@"//@%@：%@ ",originFeed.creator.name,originFeed.text];
        NSArray *tempArray2 = [self getFeedCheckWordsFromFeed:originFeed.origin_feed];
        for (NSString *checkWord in tempArray2) {
            if (![self.forwardCheckWords containsObject:checkWord]) {
                [self.forwardCheckWords addObject:checkWord];
            }
        }
        [self followsAddOneUser:originFeed.creator];
        originFeed = originFeed.origin_feed;
    }
    self.realTextView.placeholderLabel.text = @" 说说你的观点...";
    self.realTextView.text = feedAndUserNamesText;
    self.editFeedEntity.text = feedAndUserNamesText;
    [self.realTextView updateEditTextView];
    
    //设置realTextView的焦点坐标在最开始
    NSRange range;
    range.location = 0;
    range.length = 0;
    self.realTextView.selectedRange = range;

    [self.topicNoticeBgView removeFromSuperview];
    if (!self.forwardFeedBackground) {
        self.forwardFeedBackground = [[UMComEditForwardView alloc]initWithFrame: CGRectMake(0, self.realTextView.frame.size.height, self.view.frame.size.width, 90)];
        [self.view addSubview:self.forwardFeedBackground];
    }
    
    NSString *nameString = originFeed.creator.name? originFeed.creator.name:@"";
    NSString *feedString = originFeed.text?originFeed.text:@"";
    if (feedString && [feedString isEqualToString:@""] && originFeed.image_urls.count > 0) {
        feedString = @"分享图片";
    }
    NSString *showForwardText = [NSString stringWithFormat:@"@%@：%@ ", nameString, feedString];
    NSString *urlString = nil;
    if (originFeed.image_urls && [originFeed.image_urls count] > 0) {
        urlString = [[originFeed.image_urls firstObject] valueForKey:@"small_url_string"];
    }
    //[self.forwardFeedBackground reloadViewsWithText:showForwardText checkWords:self.forwardCheckWords urlString:urlString];
    NSString* forwardCreator = [[NSString alloc] initWithFormat:@"@%@",nameString];
    if(!urlString)
    {
        //去用户头像
        UMComImageUrl* icon_url = originFeed.creator.icon_url;
        if (icon_url) {
            urlString = icon_url.small_url_string;
        }
    }
    [self.forwardFeedBackground reloadViewsWithForwardCreator:forwardCreator forwardContent:feedString checkWords:self.forwardCheckWords urlString:urlString];
}

- (NSArray *)getFeedCheckWordsFromFeed:(UMComFeed *)feed
{
    NSMutableArray *checkWords = [NSMutableArray array];
    NSString *word = [NSString stringWithFormat:UserNameString,feed.creator.name];
    [checkWords addObject:word];
    for (NSString *userName in [feed.related_user.array valueForKeyPath:@"name"]) {
        if (![checkWords containsObject:userName]) {
            [checkWords addObject:[NSString stringWithFormat:UserNameString,userName]];        }
    }
    for (NSString *topicName in [feed.topics.array valueForKeyPath:@"name"]) {
        if (![checkWords containsObject:topicName]) {
            [checkWords addObject:[NSString stringWithFormat:TopicString,topicName]];
        }
    }
    return checkWords;
}


- (void)handleOriginImages:(NSArray *)images{
    
    if (!self.imagesBgView) {
        __weak typeof(self) weakSelf = self;
        
        //创建增加图片的控件
        self.addedImageView = [[UMComAddedImageView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, self.addImgViewHeightWithkeyboard)];
        self.addedImageView.isUsingForumMethod = YES;
        self.addedImageView.isAddImgViewShow = YES;
        self.addedImageView.isDashWithBorder = YES;
        self.addedImageView.deleteViewType = UMComActionDeleteViewType_Rectangle;
        self.addedImageView.itemSize = CGSizeMake(self.addImgViewItemSize, self.addImgViewItemSize);
        [self.addedImageView setPickerAction:^{
            weakSelf.topicNoticeBgView.hidden = YES;
            [weakSelf setUpPicker];
        }];
        self.addedImageView.imagesChangeFinish = ^(){
            [weakSelf updateImageAddedImageView];
        };
        self.addedImageView.imagesDeleteFinish = ^(NSInteger index){
            [weakSelf.originImages removeObjectAtIndex:index];
        };
        
        [self.addedImageView addImages:images];

        //创建地图定位控件
        self.locationView = [[UMComLocationView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, g_MicroTemplate_LocationViewHeight)];
        self.locationView.label.text = @"";
        self.locationView.label.font = UMComFontNotoSansLightWithSafeSize(13);
        self.locationView.backgroundColor = UMComColorWithColorValueString(@"f5f6fa");
        self.locationView.locationbackgroudColor = self.locationView.backgroundColor;
        self.locationView.locationBlock = ^{
            weakSelf.topicNoticeBgView.hidden = YES;
            UMComLocationListController *locationViewController = [[UMComLocationListController alloc] initWithLocationSelectedComplectionBlock:^(UMComLocationModel *locationModel) {
                if (locationModel) {
                    weakSelf.editFeedEntity.location = [[CLLocation alloc] initWithLatitude:locationModel.coordinate.latitude longitude:locationModel.coordinate.longitude];
                    weakSelf.editFeedEntity.locationDescription = locationModel.name;
                    [weakSelf.locationView relayoutChildControlsWithLocation:weakSelf.editFeedEntity.locationDescription];
                    
                }
            }];
            [weakSelf.navigationController pushViewController:locationViewController animated:YES];
        };
        
        self.imagesBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.addedImageView.frame.size.height + self.locationView.frame.size.height)];

        [self.imagesBgView addSubview:self.addedImageView];
        [self.imagesBgView addSubview:self.locationView];
        [self.view addSubview:self.imagesBgView];
    }else{
        if (!images) {
           [self.addedImageView addImages:[NSArray array]];
        }
        else
        {
            if (images.count > 0) {
                //优先调整addImageview的位置，让其在添加图片的时候根据控件的范围布局
                self.addedImageView.frame = CGRectMake(0, 0, self.addedImageView.frame.size.width, self.addImgViewHeightWithkeyboard);
                self.locationView.frame = CGRectMake(0,self.addedImageView.bounds.size.height,self.locationView.bounds.size.width,self.locationView.bounds.size.height);
            }
            [self.addedImageView addImages:images];
        }
        
    }
    [self updateImageAddedImageView];
}


- (void)updateImageAddedImageView
{
    if (self.addedImageView.arrayImages.count == 0) {
        self.addedImageView.frame = CGRectMake(self.addedImageView.frame.origin.x, self.locationView.frame.size.height, self.addedImageView.frame.size.width, 0);
        self.locationView.frame = CGRectMake(0, 0, self.locationView.bounds.size.width, self.locationView.bounds.size.height);
        
    }else{
        self.addedImageView.frame = CGRectMake(0, 0, self.addedImageView.frame.size.width, self.addedImageView.bounds.size.height);
        self.locationView.frame = CGRectMake(0,self.addedImageView.bounds.size.height,self.locationView.bounds.size.width,self.locationView.bounds.size.height);
        
        if ([self.realTextView isFirstResponder]) {
            [self.addedImageView setIntrinsicSize:CGSizeMake(self.addedImageView.frame.size.width, self.addImgViewHeightWithkeyboard)];
        }
        else{
            [self.addedImageView setIntrinsicSize:CGSizeMake(self.addedImageView.frame.size.width, 0)];
            //此处重新设置addedImageView和locationView的高度
            self.addedImageView.frame = CGRectMake(0, 0, self.addedImageView.frame.size.width, self.addedImageView.bounds.size.height);
            self.locationView.frame = CGRectMake(0,self.addedImageView.bounds.size.height,self.locationView.bounds.size.width,self.locationView.bounds.size.height);
        }
        
    }
    CGFloat height = self.addedImageView.frame.size.height + self.locationView.frame.size.height;
    CGFloat originY = self.editMenuView.frame.origin.y - height;
    self.imagesBgView.frame = CGRectMake(self.imagesBgView.frame.origin.x, originY, self.imagesBgView.frame.size.width, height);
    [self viewsFrameChange];
}

- (void)viewsFrameChange
{
    CGRect realTextViewFrame = self.realTextView.frame;
    realTextViewFrame.origin.y = 0;
    if (self.forwardFeed) {
        CGRect fowordBgFrame = self.forwardFeedBackground.frame;
        realTextViewFrame.size.height = self.editMenuView.frame.origin.y - fowordBgFrame.size.height - 2;
        self.realTextView.frame = realTextViewFrame;
        fowordBgFrame.origin.y = realTextViewFrame.origin.y + realTextViewFrame.size.height;
        self.forwardFeedBackground.frame = fowordBgFrame;
    }else{
        self.imagesBgView.hidden = NO;
        if (self.addedImageView.arrayImages.count > 0) {
            realTextViewFrame.size.height = self.editMenuView.frame.origin.y - self.imagesBgView.frame.size.height;
        }else{
            realTextViewFrame.size.height = self.editMenuView.frame.origin.y - 2 - self.imagesBgView.bounds.size.height;
        }
        
        self.imagesBgView.frame = CGRectMake(0, self.editMenuView.frame.origin.y -self.imagesBgView.bounds.size.height , self.imagesBgView.bounds.size.width, self.imagesBgView.bounds.size.height);

        [self.locationView relayoutChildControlsWithLocation:self.editFeedEntity.locationDescription];
        self.realTextView.frame = realTextViewFrame;
    }
}


#pragma mark - UIKeyboardWillShowNotification & UIKeyboardDidShowNotification
-(void)keyboardWillShow:(NSNotification*)notification
{
    CGRect keybordFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float endheight = keybordFrame.size.height;
    self.visibleViewHeight = self.view.frame.size.height - endheight - self.editMenuView.frame.size.height;
    self.editMenuView.frame = CGRectMake(self.editMenuView.frame.origin.x,self.visibleViewHeight, keybordFrame.size.width, self.editMenuView.frame.size.height);
    
    if (self.forwardFeed) {
        [self viewsFrameChange];
    }
    else{
        [self updateImageAddedImageView];
    }
}

-(void)keyboardDidShow:(NSNotification*)notification
{
//    CGRect keybordFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    float endheight = keybordFrame.size.height;
//    self.visibleViewHeight = self.view.frame.size.height - endheight - self.editMenuView.frame.size.height;
//    self.editMenuView.frame = CGRectMake(self.editMenuView.frame.origin.x,self.visibleViewHeight, keybordFrame.size.width, self.editMenuView.frame.size.height);
//    [self viewsFrameChange];
//    self.forwardFeedBackground.hidden = NO;
    
}



-(void)keyboardWiilHide:(NSNotification*)notification
{
    if (self.isClickEmoji) {
        return;
    }
     //此处可能会调用很多次，不适合在此加入代码
    ////在失去焦点的时候，键盘快要消失的时候调用，防止随键盘变化的空间位置突然变化
    BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    int offset = 0;
    if (statusBarHidden) {
        offset = 20;//此处设置固定的20，因为系统隐藏状态栏可能会把高度为0
    }
    self.editMenuView.frame = CGRectMake(self.editMenuView.frame.origin.x,self.view.bounds.size.height - self.editMenuView.bounds.size.height - offset, self.view.bounds.size.width, self.editMenuView.frame.size.height);
    
    CGRect editMenuViewRC = self.editMenuView.frame;
    CGRect viewRC = self.view.frame;
    NSLog(@"keyboardWiilHide:viewRC:[%f:%f],editMenuViewRC:[%f:%f]",viewRC.origin.y,viewRC.size.height,editMenuViewRC.origin.y,editMenuViewRC.size.height);

    [self viewsFrameChange];

    
}

-(void)keyboardDidHide:(NSNotification*)notification
{
    BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    int offset = 0;
    if (statusBarHidden) {
        offset = 20;//此处设置固定的20，因为系统隐藏状态栏可能会把高度为0
    }
    self.editMenuView.frame = CGRectMake(self.editMenuView.frame.origin.x,self.view.bounds.size.height - self.editMenuView.bounds.size.height - offset, self.view.bounds.size.width, self.editMenuView.frame.size.height);
    
    if (self.forwardFeed) {
        [self viewsFrameChange];
    }
    else{
        [self updateImageAddedImageView];
    }
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *selectImage = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *tempImage = nil;
    if (selectImage.imageOrientation != UIImageOrientationUp) {
        UIGraphicsBeginImageContext(selectImage.size);
        [selectImage drawInRect:CGRectMake(0, 0, selectImage.size.width, selectImage.size.height)];
        tempImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else{
        tempImage = selectImage;
    }
    if (self.originImages.count < 9) {
        [self.originImages addObject:tempImage];
        [self handleOriginImages:@[tempImage]];
    }
}

- (void)setUpPicker
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied)
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"本应用无访问照片的权限，如需访问，可在设置中修改" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
        return;
    }
    if([UMImagePickerController isAccessible])
    {
        UMImagePickerController *imagePickerController = [[UMImagePickerController alloc] init];
        imagePickerController.minimumNumberOfSelection = 1;
        imagePickerController.maximumNumberOfSelection = 9 - [self.addedImageView.arrayImages count];
        
        [imagePickerController setFinishHandle:^(BOOL isCanceled,NSArray *assets){
            if(!isCanceled)
            {
                [self dealWithAssets:assets];
            }
        }];
        
        UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}


- (void)dealWithAssets:(NSArray *)assets
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSMutableArray *array = [NSMutableArray array];
        for(ALAsset *asset in assets)
        {
            UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
            if (image) {
                [array addObject:image];
            }
            if ([asset defaultRepresentation]) {
                //这里把图片压缩成fullScreenImage分辨率上传，可以修改为fullResolutionImage使用原图上传
                UIImage *originImage = [UIImage
                                        imageWithCGImage:[asset.defaultRepresentation fullScreenImage]
                                        scale:[asset.defaultRepresentation scale]
                                        orientation:UIImageOrientationUp];
                if (originImage) {
                    [self.originImages addObject:originImage];
                }
            } else {
                UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
                image = [self compressImage:image];
                if (image) {
                    [self.originImages addObject:image];
                }
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleOriginImages:array];
        });
    });
}

- (UIImage *)compressImage:(UIImage *)image
{
    UIImage *resultImage  = image;
    if (resultImage.CGImage) {
        NSData *tempImageData = UIImageJPEGRepresentation(resultImage,0.9);
        if (tempImageData) {
            resultImage = [UIImage imageWithData:tempImageData];
        }
    }
    return image;
}

#pragma mark - EditMenuViewSelected
-(void)showImagePicker:(id)sender
{
    if(self.originImages.count >= 9){
        [[[UIAlertView alloc] initWithTitle:UMComLocalizedString(@"Sorry",@"抱歉") message:UMComLocalizedString(@"Too many images",@"图片最多只能选9张") delegate:nil cancelButtonTitle:UMComLocalizedString(@"OK",@"好") otherButtonTitles:nil] show];
        return;
    }
    [self setUpPicker];
}

-(void)takePhoto:(id)sender
{
    if(self.originImages.count >= 9){
        [[[UIAlertView alloc] initWithTitle:UMComLocalizedString(@"Sorry",@"抱歉") message:UMComLocalizedString(@"Too many images",@"图片最多只能选9张") delegate:nil cancelButtonTitle:UMComLocalizedString(@"OK",@"好") otherButtonTitles:nil] show];
        return;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted)
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"本应用无访问相机的权限，如需访问，可在设置中修改" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
            return;
        }
    }else{
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied)
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"本应用无访问相机的权限，如需访问，可在设置中修改" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
            return;
        }
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }
}

-(void)showLocationPicker:(id)sender
{
    __weak typeof(self) weakSelf = self;
    UMComLocationListController *locationViewController = [[UMComLocationListController alloc] initWithLocationSelectedComplectionBlock:^(UMComLocationModel *locationModel) {
        if (locationModel) {
            weakSelf.editFeedEntity.location = [[CLLocation alloc] initWithLatitude:locationModel.coordinate.latitude longitude:locationModel.coordinate.longitude];
            weakSelf.editFeedEntity.locationDescription = locationModel.name;
            weakSelf.locationView.hidden = NO;
            [weakSelf updateImageAddedImageView];
            //[weakSelf.realTextView becomeFirstResponder];//zhangjunhua
            CGRect locationFrame = weakSelf.locationView.frame;
            locationFrame.size.height = 25;
            weakSelf.locationView.frame = locationFrame;
            weakSelf.locationView.userInteractionEnabled = NO;
            weakSelf.locationView.indicatorView.hidden = YES;
            weakSelf.locationView.backgroundColor = [UIColor clearColor];
            [weakSelf.locationView relayoutChildControlsWithLocation:locationModel.name];
        }
    }];
    [self.navigationController pushViewController:locationViewController animated:YES];
}

-(void)showTopicPicker:(id)sender
{
    if (!self.topicsViewController) {
        //加入话题列表
        __weak typeof(self) weakSelf = self;
        self.topicsViewController = [[UMComEditTopicsViewController alloc] initWithTopicSelectedComplectionBlock:^(UMComTopic *topic) {
            if (topic.topicID) {
                [self topicsAddOneTopic:topic];
            }
            [weakSelf editContentAppendKvoString:[NSString stringWithFormat:TopicString,topic.name]];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        
    }
    
    [self.navigationController pushViewController:self.topicsViewController animated:YES];
}

-(void)showAtFriend:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    UMComFriendTableViewController *friendViewController = [[UMComFriendTableViewController alloc] initWithUserSelectedComplectionBlock:^(UMComUser *user) {
        [weakSelf followsAddOneUser:user];
        NSString *atFriendStr = @"";
        if (![sender isKindOfClass:[NSString class]]) {
            atFriendStr = @"@";
        }
        [weakSelf editContentAppendKvoString:[NSString stringWithFormat:@"%@%@ ",atFriendStr,user.name]];
    }];
    [self.navigationController pushViewController:friendViewController animated:YES];
}

- (void)editContentAppendKvoString:(NSString *)appendString
{
    NSMutableString *editString = nil;
    if (self.editFeedEntity.text.length > 0) {
        editString = [[NSMutableString alloc] initWithString:self.editFeedEntity.text];
    }else{
        editString = [[NSMutableString alloc]init];
    }
    NSRange tempRange = self.realTextView.selectedRange;
    if (editString.length >= self.realTextView.selectedRange.location) {
        [editString insertString:appendString atIndex:tempRange.location];
    }else{
        [editString appendString:appendString];
    }
    

    self.editFeedEntity.text = editString;
    [self.realTextView setText:self.editFeedEntity.text];
    [self.realTextView updateEditTextView];
    [self.realTextView becomeFirstResponder];
    
    self.realTextView.selectedRange = NSMakeRange(tempRange.location+appendString.length, 0);
}

- (void)followsAddOneUser:(UMComUser *)user
{
    NSMutableArray *follows = [NSMutableArray array];
    if (self.editFeedEntity.atUsers) {
        [follows addObjectsFromArray:self.editFeedEntity.atUsers];
    }
    if ([user isKindOfClass:[UMComUser class]]) {
        BOOL isInclude = NO;
        for (NSString *name in [self.editFeedEntity.atUsers valueForKeyPath:@"name"]) {
            if ([name isEqualToString:user.name]) {
                isInclude = YES;
            }
        }
        if (isInclude == NO) {
            [follows addObject:user];
        }
    }
    self.editFeedEntity.atUsers = follows;
}

- (void)topicsAddOneTopic:(UMComTopic *)topic
{
    NSMutableArray *topics = [NSMutableArray array];
    if (self.editFeedEntity.topics) {
        [topics addObjectsFromArray:self.editFeedEntity.topics];
    }
    if ([topic isKindOfClass:[UMComTopic class]]) {
        BOOL isInclude = NO;
        for (NSString *name in [self.editFeedEntity.topics valueForKeyPath:@"name"]) {
            if ([name isEqualToString:topic.name]) {
                isInclude = YES;
            }
        }
        if (isInclude == NO) {
            [topics addObject:topic];
        }
    }
    self.editFeedEntity.topics = topics;
}


#pragma mark - UITextViewDelegate

- (void)editTextViewDidEndEditing:(UMComEditTextView *)textView
{
    self.editFeedEntity.text = textView.text;
}

- (BOOL)editTextView:(UMComEditTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text complection:(void (^)())block
{
    if ([@"@" isEqualToString:text]) {
        [self showAtFriend:text];
        return YES;
    }
    if ([@"#" isEqualToString:text]) {
        if (self.forwardFeed == nil) {
            NSInteger location = textView.selectedRange.location;
            NSMutableString *tempString = [NSMutableString stringWithString:textView.text];
            [tempString insertString:@"#" atIndex:textView.selectedRange.location];
            textView.text = tempString;
            textView.selectedRange = NSMakeRange(location+1, 0);
            [textView resignFirstResponder];
            if (block) {
                block();
            }
            return YES;
        }
    }
    return YES;
}


- (NSArray *)editTextViewDidUpdate:(UMComEditTextView *)textView matchWords:(NSArray *)matchWords
{
    NSArray *checkWords = [self getCheckWords];
    NSMutableArray *array = [NSMutableArray arrayWithArray:checkWords];
    NSMutableArray *userList = [NSMutableArray arrayWithArray:self.editFeedEntity.atUsers];
    NSMutableArray *topicList = [NSMutableArray arrayWithArray:self.editFeedEntity.topics];
    for (NSString *checkWord in checkWords) {
        if (![matchWords containsObject:checkWord]) {
            [array removeObject:checkWord];
            for (UMComUser *user in self.editFeedEntity.atUsers) {
                NSString *userName = [NSString stringWithFormat:UserNameString,user.name];
                if ([userName isEqualToString:checkWord]) {
                    [userList removeObject:user];
                }
            }
            for (UMComTopic *topic in self.editFeedEntity.topics) {
                NSString *topicName = [NSString stringWithFormat:TopicString,topic.name];
                if ([topicName isEqualToString:checkWord]) {
                    [topicList removeObject:topic];
                }
            }
        }
    }
    self.editFeedEntity.atUsers = userList;
    self.editFeedEntity.topics = topicList;
    if (self.editFeedEntity.topics.count > 0) {
        self.topicNoticeBgView.hidden = YES;
    }else{
        self.topicNoticeBgView.hidden = NO;
    }
    self.editFeedEntity.text = textView.text;
    return array;
}

- (BOOL)isString:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (string.length > 0) {
        return YES;
    }
    return NO;
}

#pragma mark - creatFeed

/**
 *  获得要发送的话题数组
 */
-(NSArray*)postingTopicsArray
{
    NSMutableOrderedSet* resultOrderedSet = [[NSMutableOrderedSet alloc] initWithArray:self.editFeedEntity.topics];
    
    if (!resultOrderedSet) {
        return [NSArray array];
    }
    
    if (self.forwardFeed) {
        [resultOrderedSet unionOrderedSet:self.forwardFeed.topics];
    }
    
    return [resultOrderedSet array];
}

- (void)postContent
{
    [self.realTextView resignFirstResponder];
    [self dismissTopicNoticeBgView];
    
    self.editFeedEntity.text = self.realTextView.text;
    
//    if (!self.forwardFeed && ![self isString:self.realTextView.text]) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:UMComLocalizedString(@"Sorry",@"抱歉") message:UMComLocalizedString(@"Empty_Text",@"文字内容不能为空") delegate:nil cancelButtonTitle:UMComLocalizedString(@"OK",@"好") otherButtonTitles:nil];
//        [alertView show];
//        [self.realTextView becomeFirstResponder];
//        return;
//    }
    
    NSString *realTextString = [self.realTextView.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableString *realString = [NSMutableString stringWithString:realTextString];
    if (self.topic) {
        //若需要显示话题用户手动删除话题就不带话题id，如果不需要显示话题就自动加上话题id
        NSString *topicName = [NSString stringWithFormat:TopicString,self.topic.name];
        NSRange range = [self.editFeedEntity.text rangeOfString:topicName];
        if (range.length > 0 && [UMComSession sharedInstance].isShowTopicName) {
            [realString replaceCharactersInRange:range withString:@""];
        }
    }
    
    if (!self.forwardFeed && ((self.realTextView.text.length == 0) && (self.originImages.count == 0))) {
        //在编辑界面，如果文本内容或者图片都为0，就提示用户不能发送
        NSString *tooShortNotice = [NSString stringWithFormat:@"至少需要发布内容或者图片"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:UMComLocalizedString(@"Sorry",@"抱歉") message:UMComLocalizedString(@"The content or img",tooShortNotice) delegate:nil cancelButtonTitle:UMComLocalizedString(@"OK",@"好") otherButtonTitles:nil];
        [alertView show];
        [self.realTextView becomeFirstResponder];
        return;
    }
    
    //编辑界面下设置最小字数限制
    if (!self.forwardFeed && ([self.realTextView getRealTextLength] < MinTextLength) && (self.originImages.count == 0)) {
        NSString *tooShortNotice = [NSString stringWithFormat:@"发布的内容太少啦，再多写点内容。"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:UMComLocalizedString(@"Sorry",@"抱歉") message:UMComLocalizedString(@"The content is too long",tooShortNotice) delegate:nil cancelButtonTitle:UMComLocalizedString(@"OK",@"好") otherButtonTitles:nil];
        [alertView show];
        [self.realTextView becomeFirstResponder];
        return;
    }
    
    if (!self.forwardFeed && self.realTextView.text && [self.realTextView getRealTextLength] > self.realTextView.maxTextLenght) {
        NSString *tooLongNotice = [NSString stringWithFormat:@"内容过长,超出%d个字符",(int)[self.realTextView getRealTextLength] - (int)self.realTextView.maxTextLenght];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:UMComLocalizedString(@"Sorry",@"抱歉") message:UMComLocalizedString(@"The content is too long",tooLongNotice) delegate:nil cancelButtonTitle:UMComLocalizedString(@"OK",@"好") otherButtonTitles:nil];
        [alertView show];
        [self.realTextView becomeFirstResponder];
        return;
    }
    

    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (!self.forwardFeedBackground) {
        if (self.topic) {
            //若需要显示话题用户手动删除话题就不带话题id，如果不需要显示话题就自动加上话题id
            NSString *topicName = [NSString stringWithFormat:TopicString,self.topic.name];
            NSRange range = [self.editFeedEntity.text rangeOfString:topicName];
            if (range.length > 0 || ![UMComSession sharedInstance].isShowTopicName) {
                [self topicsAddOneTopic:self.topic];
                //                [self.editFeedEntity.topics addObject:self.topic];
            }
        }
        NSMutableArray *postImages = [NSMutableArray array];
        //iCloud共享相册中的图片没有原图
        for (UIImage *image in self.originImages) {
            UIImage *originImage = [self compressImage:image];
            [postImages addObject:originImage];
        }
        [self postEditContentWithImages:postImages response:^(id responseObject, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self dealWhenPostFeedFinish:responseObject error:error];
        }];
    } else {
        [self postForwardFeed:self.forwardFeed response:^(id responseObject, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self dealWhenPostFeedFinish:responseObject error:error];
        }];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)dealWhenPostFeedFinish:(NSArray *)responseObject error:(NSError *)error
{
    if (error) {
        [UMComShowToast showFetchResultTipWithError:error];
    } else if([responseObject isKindOfClass:[NSArray class]] && responseObject.count > 0) {
        UMComFeed *feed = responseObject.firstObject;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPostFeedResultNotification object:feed];
        [UMComShowToast createFeedSuccess];
        if (self.feedOperationFinishDelegate && [self.feedOperationFinishDelegate respondsToSelector:@selector(reloadDataWhenFeedOperationFinish:)]) {
            [self.feedOperationFinishDelegate reloadDataWhenFeedOperationFinish:feed];
        }
        if (self.feedOperationFinishDelegate && [self.feedOperationFinishDelegate respondsToSelector:@selector(createFeedSucceed:)]) {
            [self.feedOperationFinishDelegate createFeedSucceed:feed];
        }
    }
}


- (void)postEditContentWithImages:(NSArray *)images
                         response:(void (^)(id responseObject,NSError *error))response
{
    __weak typeof(self) weakSelf = self;
    self.editFeedEntity.images = images;
    if ([self isPermission_bulletin]) {
        self.selectedFeedTypeBlock = ^(NSNumber *type){
            [UMComPushRequest postWithFeed:weakSelf.editFeedEntity completion:^(id responseObject, NSError *error) {
                
                if (response) {
                    response(responseObject, error);
                }
                if (error) {
                    //一旦发送失败会保存到草稿箱
                    [UMComSession sharedInstance].draftFeed = weakSelf.editFeedEntity;
                } else {
                    [UMComSession sharedInstance].draftFeed = nil;
                }
            }];
        };
        [self showFeedTypeNotice];
    }else{
        [UMComPushRequest postWithFeed:self.editFeedEntity completion:^(id responeObject,NSError *error) {
            
            if (error) {
                //一旦发送失败会保存到草稿箱
                [UMComSession sharedInstance].draftFeed = weakSelf.editFeedEntity;
            } else {
                [UMComSession sharedInstance].draftFeed = nil;
            }
            
            if (response) {
                response(responeObject, error);
            }
             
        }];
    }
}


- (BOOL)isPermission_bulletin
{
    UMComUser *user = [UMComSession sharedInstance].loginUser;
    BOOL isPermission_bulletin = NO;
    if ([[UMComSession sharedInstance].loginUser.atype intValue] == 1 && [user isPermissionBulletin]) {
        isPermission_bulletin = YES;
    }
    return isPermission_bulletin;
}

- (void)showFeedTypeNotice
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:UMComLocalizedString(@"public feed", @"是否需要将本条内容标记为公告？") delegate:self cancelButtonTitle:UMComLocalizedString(@"NO", @"否") otherButtonTitles:UMComLocalizedString(@"YES", @"是"), nil];
    alertView.tag = 10001;
    [alertView show];
}

- (void)showResetFeedTypeNotice
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:UMComLocalizedString(@"no privilege creat feed", @"你没有发公告的权限，是否标记为非公告重新发送？") delegate:self cancelButtonTitle:UMComLocalizedString(@"NO", @"否") otherButtonTitles:UMComLocalizedString(@"YES", @"是"), nil];
    alertView.tag = 10002;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSNumber *type = @0;
    if (alertView.tag == 10001) {
        type = [NSNumber numberWithInteger:buttonIndex];
        if (self.selectedFeedTypeBlock) {
            self.editFeedEntity.type = type;
            self.selectedFeedTypeBlock(type);
        }
    }else{
        if (buttonIndex == 1) {
            if (self.selectedFeedTypeBlock) {
                self.editFeedEntity.type = type;
                self.selectedFeedTypeBlock(type);
            }
        }
    }
    
}

- (void)postForwardFeed:(UMComFeed *)forwardFeed
               response:(void (^)(id responseObject,NSError *error))response
{
    NSMutableArray *atUsers = [NSMutableArray arrayWithCapacity:1];
    for (UMComUser *user in self.editFeedEntity.atUsers) {
        [atUsers addObject:user];
    }
    UMComFeed *originFeed = forwardFeed;
    while (originFeed.origin_feed) {
        if (![atUsers containsObject:originFeed.creator]) {
            [atUsers addObject:originFeed.creator];
        }
        originFeed = originFeed.origin_feed;
    }
    self.editFeedEntity.atUsers = atUsers;
    self.editFeedEntity.topics = [self postingTopicsArray];
    [UMComPushRequest forwardWithFeed:forwardFeed newFeed:self.editFeedEntity completion:^(id responseObject, NSError *error) {
        if (response) {
            response(responseObject,error);
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - 表情相关函数
-(UMComEmojiKeyboardView*) emojiKeyboardView
{
    if (!_emojiKeyboardView) {
        //添加表情控件
        UMComEmojiKeyboardView *emojiKeyboardView = [[UMComEmojiKeyboardView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 216) dataSource:nil];
        emojiKeyboardView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        emojiKeyboardView.delegate = self;
        _emojiKeyboardView = emojiKeyboardView;
    }
    return _emojiKeyboardView;
}
-(void) setEmojiKeyboardView:(UMComEmojiKeyboardView*)emojiKeyboardView
{
    _emojiKeyboardView = emojiKeyboardView;
}

-(void) createEmojiKeyboardView
{
    if (!_emojiKeyboardView) {
        //添加表情控件
        UMComEmojiKeyboardView *emojiKeyboardView = [[UMComEmojiKeyboardView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 216) dataSource:nil];
        emojiKeyboardView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        emojiKeyboardView.delegate = self;
        _emojiKeyboardView = emojiKeyboardView;
    }
}

-(void) showEmojiKeyboardView
{
    if (!_emojiKeyboardView) {
        [self createEmojiKeyboardView];
    }
    self.isClickEmoji = YES;
    if (self.realTextView.inputView == nil) {
        self.realTextView.inputView = self.emojiKeyboardView;
        [self.realTextView resignFirstResponder];
        [self.realTextView becomeFirstResponder];
        [self changeEmojiBtnImg:NO];
    } else {
        self.realTextView.inputView = nil;
        [self.realTextView resignFirstResponder];
        [self.realTextView becomeFirstResponder];
        [self changeEmojiBtnImg:YES];
    }
    self.isClickEmoji = NO;
}

-(void) addEmojiKeyboardViewIntoSystemKeyboard
{
    BOOL isFound = [self findSysmtemKeyboard];
    if (!isFound) {
        return;
    }
    if ([[_systemKeyboardWindow subviews] indexOfObject:_emojiKeyboardView] == NSNotFound) {
       
        _emojiKeyboardView.frame = _systemKeyboardView.frame;
        [_systemKeyboardWindow addSubview:_emojiKeyboardView];
    }
    else
    {
        CGRect temp = _systemKeyboardView.frame;
        CGRect temp1 = _systemInputSetContainerView.frame;
        _emojiKeyboardView.frame = _systemKeyboardView.frame;//此处高度为0,不知为何
        //_emojiKeyboardView.frame = CGRectMake(0 ,315, 320,253);
        //_systemKeyboardWindow.hidden = NO;//此处_systemKeyboardWindow的隐藏属性为YES
        [_systemKeyboardWindow bringSubviewToFront:_emojiKeyboardView];
    }
}

-(void) changeEmojiBtnImg:(BOOL)isEmoji
{
    if (isEmoji) {
        //显示表情
        [_emojiBtn setBackgroundImage:UMComImageWithImageName(@"um_edit_emoji_normal") forState:UIControlStateNormal];
        [_emojiBtn setBackgroundImage:UMComImageWithImageName(@"um_edit_emoji_highlight") forState:UIControlStateHighlighted];
    }
    else
    {
        //显示键盘
        [_emojiBtn setBackgroundImage:UMComImageWithImageName(@"um_edit_keyboard_normal") forState:UIControlStateNormal];
        [_emojiBtn setBackgroundImage:UMComImageWithImageName(@"um_edit_keyboard_highlight") forState:UIControlStateHighlighted];
    }
}


/**
 *  获得系统的键盘view(deprecated 已废弃)
 *
 *  @return 系统的键盘view
 */
- (UIView *)getKeyboardView{
    
    //method1
    UIView *foundKeyboard = nil;
    UIWindow *keyboardWindow = nil;
    
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if (![[testWindow class] isEqual:[UIWindow class]]){
            keyboardWindow = testWindow;
            //break;
            //判断平台版本
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            {
            }
            else
            {
                //其他平台键盘的windows可能不一样，需要对每个平台分析
                //....todo //zhangjunhua
            }
        }
    }
    if (!keyboardWindow) return nil;
    
    for ( UIView *possibleKeyboard in [keyboardWindow subviews]) {
        
        if ([[possibleKeyboard description] hasPrefix:@"<UIInputSetContainerView"]) {
            for ( UIView *possibleKeyboard_2 in possibleKeyboard.subviews) {
                if ([possibleKeyboard_2.description hasPrefix:@"<UIInputSetHostView"]) {
                    foundKeyboard = possibleKeyboard_2;
                }
            }
        }
    }
    
    //return foundKeyboard;
    return keyboardWindow;
    
    
    /*
     UIWindow* tempWindow;
     
     //Because we cant get access to the UIKeyboard throught the SDK we will just use UIView.
     //UIKeyboard is a subclass of UIView anyways
     UIView* keyboard;
     
     NSLog(@"windows %d", [[[UIApplication sharedApplication]windows]count]);
     
     //Check each window in our application
     for(int c = 0; c < [[[UIApplication sharedApplication] windows] count]; c ++)
     {
     //Get a reference of the current window
     tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:c];
     
     //Get a reference of the current view
     for(int i = 0; i < [tempWindow.subviews count]; i++)
     {
     keyboard = [tempWindow.subviews objectAtIndex:i];
     NSLog(@"view: %@, on index: %d, class: %@", [keyboard description], i, [[tempWindow.subviews objectAtIndex:i] class]);
     if([[keyboard description] hasPrefix:@"(lessThen)UIKeyboard"] == YES)
     {
     //If we get to this point, then our UIView "keyboard" is referencing our keyboard.
     return keyboard;
     }
     }
     
     for(UIView* potentialKeyboard in tempWindow.subviews)
     // if the real keyboard-view is found, remember it.
     if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
     if([[potentialKeyboard description] hasPrefix:@"<UILayoutContainerView"] == YES)
     keyboard = potentialKeyboard;
     }
     else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
     if([[potentialKeyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
     keyboard = potentialKeyboard;
     }
     else {
     if([[potentialKeyboard description] hasPrefix:@"<UIKeyboard"] == YES)
     keyboard = potentialKeyboard;
     }
     }
     
     
     NSLog(@"view: %@, on index:", [keyboard description]);
     return keyboard;
     */
}


/**
 *  寻找ios8.0以上的系统键盘
 *
 *  @return 返回是否找到
 */
-(BOOL) doFindKeyboardForAboveIOS8_0
{
    UIView *foundKeyboard = nil;
    UIWindow *keyboardWindow = nil;
    UIView* inputSetContainerView = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows])
    {
        if (![[testWindow class] isEqual:[UIWindow class]]){
            
            if ([[testWindow description] hasPrefix:@"<UIRemoteKeyboardWindow"]) {
                
                keyboardWindow = testWindow;
                break;
            }
        }
    }
    
     for ( UIView *possibleKeyboard in [keyboardWindow subviews])
     {
         NSLog(@"possibleKeyboard:%@",possibleKeyboard);
         int i = 0;
         i++;
     }
    for ( UIView *possibleKeyboard in [keyboardWindow subviews]) {
        
        if ([[possibleKeyboard description] hasPrefix:@"<UIInputSetContainerView"]) {
            
            for ( UIView *possibleKeyboard_2 in possibleKeyboard.subviews)
            {
                NSLog(@"possibleKeyboard_2:%@",possibleKeyboard_2);
                int i = 0;
                i++;
            }
            
            for ( UIView *possibleKeyboard_2 in possibleKeyboard.subviews) {
                if ([possibleKeyboard_2.description hasPrefix:@"<UIInputSetHostView"]) {
                    foundKeyboard = possibleKeyboard_2;
                    inputSetContainerView = possibleKeyboard;
                    break;
                }
            }
        }
    }
    
    
    if (foundKeyboard && keyboardWindow) {
        
        _systemKeyboardView = foundKeyboard;
        _systemKeyboardWindow = keyboardWindow;
        _systemInputSetContainerView = inputSetContainerView;
        return true;
    }
    else
    {
        return false;
    }
}

-(BOOL) doFindSysmtemKeyboard
{
    
    //判断平台版本
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        return [self doFindKeyboardForAboveIOS8_0];
    }
    else
    {
        //其他平台键盘的windows可能不一样，需要对每个平台分别分析
        //....todo //zhangjunhua
    }

    return false;
}

-(BOOL) findSysmtemKeyboard
{
//    if (_systemKeyboardWindow && _systemKeyboardView) {
//        return true;
//    }
    return [self doFindSysmtemKeyboard];
}

#pragma mark - UMComEmojiKeyboardViewDelegate


/**
 Delegate method called when user taps an emoji button
 
 @param emojiKeyBoardView EmojiKeyBoardView object on which user has tapped.
 
 @param emoji Emoji used by user
 */
- (void)emojiKeyBoardView:(UMComEmojiKeyboardView *)emojiKeyBoardView
              didUseEmoji:(NSString *)emoji
{
    NSRange orgRange = self.realTextView.selectedRange;
    
    NSRange rangeBefore;
    rangeBefore.location = 0;
    rangeBefore.length = orgRange.location;
    NSString* orgBefore = [self.realTextView.text substringWithRange:[self.realTextView.text rangeOfComposedCharacterSequencesForRange:rangeBefore]];
    
    NSRange rangeAfter;
    rangeAfter.location = rangeBefore.location + rangeBefore.length;
    if (orgBefore) {
        //直接
       rangeAfter.length = self.realTextView.text.length - orgBefore.length;
    }
    else
    {
        //如果用rangeBefore.length操作，可能会有问题
        rangeAfter.length = self.realTextView.text.length -  rangeBefore.length;
    }
    
    NSString* orgAfter = [self.realTextView.text substringWithRange:[self.realTextView.text rangeOfComposedCharacterSequencesForRange:rangeAfter]];
    
    NSUInteger resultLocation = 0;
    NSMutableString* resultString = [[NSMutableString alloc] initWithCapacity:10];
    if (orgBefore) {
        
        [resultString appendString:orgBefore];
        resultLocation += orgBefore.length;
    }
    
    if (emoji) {
        [resultString appendString:emoji];
        resultLocation += emoji.length;
    }
    
    if (orgAfter) {
        [resultString appendString:orgAfter];
    }
    
    if (![self.realTextView checkMaxLength:resultString]) {
        self.realTextView.text = resultString;
        self.realTextView.selectedRange = NSMakeRange(resultLocation, 0);
    }
}

/**
 Delegate method called when user taps on the backspace button
 
 @param emojiKeyBoardView EmojiKeyBoardView object on which user has tapped.
 */
- (void)emojiKeyBoardViewDidPressBackSpace:(UMComEmojiKeyboardView *)emojiKeyBoardView
{
    NSLog(@"emojiKeyBoardViewDidPressBackSpace");
    [self.realTextView deleteBackward];
}

@end
