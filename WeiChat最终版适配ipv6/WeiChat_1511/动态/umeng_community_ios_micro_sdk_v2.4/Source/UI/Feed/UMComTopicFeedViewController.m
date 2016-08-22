//
//  UMComOneFeedViewController.m
//  UMCommunity
//
//  Created by Gavin Ye on 9/12/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComTopicFeedViewController.h"
#import "UMComTopic+UMComManagedObject.h"
#import "UMComLoginManager.h"
#import "UMComSession.h"
#import "UMComUser+UMComManagedObject.h"
#import "UMComShowToast.h"
#import "UIViewController+UMComAddition.h"
#import "UMComNavigationController.h"
#import "UMComHorizonCollectionView.h"
#import "UMComPullRequest.h"
#import "UMComPushRequest.h"
#import "UMComCommonUserTableViewCell.h"
#import "UMComFeed.h"
#import "UMComFeedTableViewController.h"
#import "UMComUsersTableViewController.h"
#import "UMComHotFeedMenuViewController.h"
#import "UMComTopFeedTableViewHelper.h"
#import "UMComBarButtonItem.h"
#import "UMComEditViewController.h"

@interface UMComTopicFeedViewController ()<UMComHorizonCollectionViewDelegate>

@property (nonatomic, strong) UMComHorizonCollectionView *menuControlView;

@end

@implementation UMComTopicFeedViewController

-(id)initWithTopic:(UMComTopic *)topic
{
    self = [super init];
    if (self) {
        self.topic = topic;
   }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.menuControlView) {
        [self createMenuControlView];
        [self creatChildViewControllers];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UMComRGBColor(245, 246, 250);

    [self setTitleViewWithTitle:[NSString stringWithFormat:TopicString,self.topic.name]];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self creatNavigationItemList];
}

//创建子ViewControllers
- (void)creatChildViewControllers
{
    CGRect frame = self.view.frame;
    frame.origin.y = self.menuControlView .frame.size.height + UMCom_Micro_Feed_Cell_Space;
    frame.size.height = self.view.frame.size.height - frame.origin.y;
    UMComFeedTableViewController *lastPublicTableViewController = [[UMComFeedTableViewController alloc]initWithFetchRequest:[[UMComTopicFeedsRequest alloc] initWithTopicId:self.topic.topicID count:BatchSize order:UMComFeedSortTypeDefault isReverse:NO]];
    lastPublicTableViewController.isShowEditButton = YES;
    lastPublicTableViewController.view.frame = frame;
    lastPublicTableViewController.feedCellBgViewTopEdge = 0;
    //添加置顶类---begin
    UMComTopFeedTableViewHelper* tempTopFeedTableViewHelper =  [[UMComTopFeedTableViewHelper alloc] init];
    tempTopFeedTableViewHelper.topFeedRequest = [[UMComTopicTopFeedRequest alloc] initwithTopFeedCount:BatchSize topFeedTopicID:self.topic.topicID];
    lastPublicTableViewController.topFeedTableViewHelper = tempTopFeedTableViewHelper;
    lastPublicTableViewController.showTopMark = YES;
    //添加置顶类---end
    [self addChildViewController:lastPublicTableViewController];
    [self.view addSubview:lastPublicTableViewController.view];
    
    UMComFeedTableViewController *lastReplyTableViewController = [[UMComFeedTableViewController alloc]initWithFetchRequest:[[UMComTopicFeedsRequest alloc] initWithTopicId:self.topic.topicID count:BatchSize order:UMComFeedSortTypeComment isReverse:YES]];
    lastReplyTableViewController.isShowEditButton = YES;
    lastReplyTableViewController.feedCellBgViewTopEdge = 0;
    lastReplyTableViewController.view.frame = frame;
    [self addChildViewController:lastReplyTableViewController];
    
    UMComFeedTableViewController *recommendTableViewController = [[UMComFeedTableViewController alloc]initWithFetchRequest:[[UMComTopicRecommendFeedsRequest alloc] initWithTopicId:self.topic.topicID count:BatchSize]];
    recommendTableViewController.isShowEditButton = YES;
    recommendTableViewController.feedCellBgViewTopEdge = 0;
    recommendTableViewController.view.frame = frame;
    [self addChildViewController:recommendTableViewController];
    
    UMComHotFeedMenuViewController *topicFeedTableViewController = [[UMComHotFeedMenuViewController alloc]initWithTopic:self.topic];
    topicFeedTableViewController.view.frame = frame;
    [self addChildViewController:topicFeedTableViewController];
    
    UMComUsersTableViewController *followersTableViewController = [[UMComUsersTableViewController alloc] initWithFetchRequest:[[UMComRecommendTopicUsersRequest alloc] initWithTopicId:self.topic.topicID count:BatchSize]];
    followersTableViewController.view.frame = frame;
    [self addChildViewController:followersTableViewController];
    [self transitionSubViewControllers];
}


- (void)createMenuControlView
{
    UMComHorizonCollectionView *menuControlView = [[UMComHorizonCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49) itemCount:5];
    menuControlView.bottomLineHeight = 1;
    menuControlView.topLine.backgroundColor = UMComColorWithColorValueString(@"#EEEFF3");
    menuControlView.bottomLine.backgroundColor = UMComColorWithColorValueString(@"#EEEFF3");
    menuControlView.itemSpace = 1;
    menuControlView.backgroundColor = UMComTableViewSeparatorColor;
    menuControlView.cellDelegate = self;
    [self.view addSubview:menuControlView];
    self.menuControlView = menuControlView;
}


- (void)creatNavigationItemList
{
//    UMComBarButtonItem *editButton = [[UMComBarButtonItem alloc] initWithNormalImageName:@"um_forum_post_edit_highlight" target:self action:@selector(showPostEditViewController:)];
//    editButton.customButtonView.frame = CGRectMake(0, 0, 20, 20);
//    editButton.customButtonView.titleLabel.font = UMComFontNotoSansLightWithSafeSize(17);
    UMComBarButtonItem *topicFocusedButton = nil;
    if ([[self.topic is_focused] boolValue]) {
        topicFocusedButton = [[UMComBarButtonItem alloc] initWithNormalImageName:@"um_forum_topic_focused" target:self action:@selector(followTopic:)];;
    }else{
        topicFocusedButton = [[UMComBarButtonItem alloc] initWithNormalImageName:@"um_forum_topic_nofocused" target:self action:@selector(followTopic:)];
    }
    topicFocusedButton.customButtonView.frame = CGRectMake(0, 0, 20, 20);
    topicFocusedButton.customButtonView.titleLabel.font = UMComFontNotoSansLightWithSafeSize(17);
//    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]init];
//    UIView *spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
//    spaceView.backgroundColor = [UIColor clearColor];
//    [spaceItem setCustomView:spaceView];
//    
//    UMComBarButtonItem *rightSpaceItem = [[UMComBarButtonItem alloc] init];
//    rightSpaceItem.customButtonView.frame = CGRectMake(0, 12, 50, 4);
//    rightSpaceItem.customButtonView.titleLabel.font = UMComFontNotoSansLightWithSafeSize(17);
    [self.navigationItem setRightBarButtonItem:topicFocusedButton];
//    [self.navigationItem setRightBarButtonItems:@[rightSpaceItem,topicFocusedButton,spaceItem]];
}


- (void)followTopic:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [UMComPushRequest followerWithTopic:weakSelf.topic isFollower:![weakSelf.topic.is_focused boolValue] completion:^(NSError *error) {
                if ([weakSelf.topic.is_focused boolValue]) {
                    [sender setBackgroundImage:UMComImageWithImageName(@"um_forum_topic_focused") forState:UIControlStateNormal];
                }else{
                    [sender setBackgroundImage:UMComImageWithImageName(@"um_forum_topic_nofocused") forState:UIControlStateNormal];
                }
            }];
        }
    }];
}



#pragma mark - UMComHorizonCollectionViewDelegate
- (NSInteger)numberOfRowInHorizonCollectionView:(UMComHorizonCollectionView *)collectionView
{
    return 5;
}

- (void)horizonCollectionView:(UMComHorizonCollectionView *)collectionView reloadCell:(UMComHorizonCollectionCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    if (indexPath.row == 0) {
        title = UMComLocalizedString(@"um_com_forum_topic_latest_post", @"最新发布");
    }else if (indexPath.row == 1){
        title = UMComLocalizedString(@"um_com_forum_topic_latest_reply", @"最后回复");
    }else if (indexPath.row == 2){
        title = UMComLocalizedString(@"um_com_forum_topic_recommend", @"推荐");
    }else if (indexPath.row == 3){
        title = UMComLocalizedString(@"um_com_forum_topic_hot", @"最热");
    }else if (indexPath.row == 4){
        title = UMComLocalizedString(@"um_com_topic_related_user", @"活跃用户");
    }
    if (indexPath.row == collectionView.currentIndex) {
        cell.label.textColor = UMComColorWithColorValueString(FontColorBlue);
    }else{
        cell.label.textColor = [UIColor blackColor];
    }
    cell.label.text = title;
}

- (void)horizonCollectionView:(UMComHorizonCollectionView *)collectionView didSelectedColumn:(NSInteger)column
{
    [self transitionSubViewControllers];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)transitionSubViewControllers
{
    [self transitionFromViewControllerAtIndex:self.menuControlView.lastIndex toViewControllerAtIndex:self.menuControlView.currentIndex animations:nil completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
