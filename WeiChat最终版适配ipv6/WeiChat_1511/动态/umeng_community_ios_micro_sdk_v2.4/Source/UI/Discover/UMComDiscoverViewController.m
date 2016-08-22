//
//  UMComForumFindViewController.m
//  UMCommunity
//
//  Created by umeng on 15/11/17.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComDiscoverViewController.h"
#import "UMComFindTableViewCell.h"
#import "UMComProfileSettingController.h"
#import "UIViewController+UMComAddition.h"
#import "UMComSession.h"
#import "UMComPullRequest.h"
#import "UMComUserInfoBar.h"
#import "UMComLoginManager.h"
#import "UMComUnReadNoticeModel.h"
#import "UMComTools.h"
#import "UMComPushRequest.h"


@interface UMComDiscoverViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIView *systemNotificationView;

@property (nonatomic, strong) UIView *userMessageView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UMComUserInfoBar *userInfoBar;

@end

@implementation UMComDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setForumUIBackButton];
    [self setForumUITitle:UMComLocalizedString(@"find", @"我的")];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"UMComFindTableViewCell" bundle:nil] forCellReuseIdentifier:@"FindTableViewCell"];
    self.tableView.rowHeight = 55.0f;
    if (UMCom_Current_System_Version >= 7.0 && UMCom_Current_System_Version < 8) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    [self.view addSubview:self.tableView];
    
    UIButton *menuItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuItemButton addTarget:self action:@selector(tranToSetting) forControlEvents:UIControlEventTouchUpInside];
    [menuItemButton setImage:UMComImageWithImageName(@"um_setting_normal") forState:UIControlStateNormal];
    [menuItemButton setImage:UMComImageWithImageName(@"um_setting_highlighted") forState:UIControlStateHighlighted];
    menuItemButton.frame = CGRectMake(0.f, 0.f, 20.f, 20.f);
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuItemButton];
    
    [self.navigationItem setRightBarButtonItem:menuItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNoticeItemViews) name:kUMComUnreadNotificationRefreshNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessageData:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self refreshNoticeItemViews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.rightButton removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshMessageData:(id)sender
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [UMComPushRequest requestConfigDataWithResult:^(id responseObject, NSError *error) {
        [self refreshNoticeItemViews];
    }];
}
- (void)refreshNoticeItemViews
{
    [self.tableView reloadData];
}

- (UIView *)creatNoticeViewWithOriginX:(CGFloat)originX
{
    CGFloat noticeViewWidth = 7;
    UIView *itemNoticeView = [[UIView alloc]initWithFrame:CGRectMake(originX,0, noticeViewWidth, noticeViewWidth)];
    itemNoticeView.backgroundColor = [UIColor redColor];
    itemNoticeView.layer.cornerRadius = noticeViewWidth/2;
    itemNoticeView.clipsToBounds = YES;
    itemNoticeView.hidden = YES;
    return itemNoticeView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        return 5;
    } else {
        return 4;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FindTableViewCell";
    UMComFindTableViewCell *cell = (UMComFindTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: {
                cell.titleImageView.image = UMComImageWithImageName(@"um_notice_f");
                cell.titleNameLabel.text = UMComLocalizedString(@"um_news_notice", @"我的消息");
                
                UMComUnReadNoticeModel *unReadNotice = [UMComSession sharedInstance].unReadNoticeModel;
                if (unReadNotice.totalNotiCount == 0) {
                    self.userMessageView.hidden = YES;
                }else{
                    if (!self.userMessageView) {
                        self.userMessageView = [self creatNoticeViewWithOriginX:110];
                        self.userMessageView.center = CGPointMake(self.userMessageView.center.x, cell.titleNameLabel.frame.origin.y+11);
                        [cell.contentView addSubview:self.userMessageView];
                    } else {
                        if (self.userMessageView.superview != cell.contentView) {
                            [self.userMessageView removeFromSuperview];
                            [cell addSubview:self.userMessageView];
                        }
                    }
                    self.userMessageView.hidden = NO;
                }
            }
                break;
            case 1: {
                cell.titleImageView.image = UMComImageWithImageName(@"um_fav+");
                cell.titleNameLabel.text = UMComLocalizedString(@"um_collection", @"我的收藏");
            }
                break;
            case 2: {
                cell.titleImageView.image = UMComImageWithImageName(@"um_friend");
                cell.titleNameLabel.text = UMComLocalizedString(@"um_friend", @"好友圈");
            }
                break;
            case 3: {
                // 我关注的
                cell.titleImageView.image = UMComImageWithImageName(@"um_follow_topic");
                cell.titleNameLabel.text = UMComLocalizedString(@"um_follow_topic", @"我关注的话题");
            }
                break;
            case 4: {
                // 我的图册
                cell.titleImageView.image = UMComImageWithImageName(@"um_my_gallery");
                cell.titleNameLabel.text = UMComLocalizedString(@"um_my_gallery", @"我的图册");
            }
                break;
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0: {
                cell.titleImageView.image = UMComImageWithImageName(@"um_near");
                cell.titleNameLabel.text = UMComLocalizedString(@"um_near", @"附近推荐");
            }
                break;
            case 1: {
                cell.titleImageView.image = UMComImageWithImageName(@"um_newcontent");
                cell.titleNameLabel.text = UMComLocalizedString(@"um_newcontent", @"实时内容");
            }
                break;
            case 2: {
                cell.titleImageView.image = UMComImageWithImageName(@"user_recommend");
                cell.titleNameLabel.text = UMComLocalizedString(@"user_recommend", @"用户推荐");
            }
                break;
            case 3: {
                cell.titleImageView.image = UMComImageWithImageName(@"topic_recommend");
                cell.titleNameLabel.text = UMComLocalizedString(@"topic_recommend", @"话题推荐");
            }
                break;
            default:
                break;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets edge = UIEdgeInsetsMake(tableView.rowHeight - 1, 15, 0, 0);
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:edge];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:edge];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 91.f;
    } else if (section == 1) {
        return 31.0f;
    }else {
        return 31.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"UMComUserInfoBar" owner:self options:nil];
        self.userInfoBar = xibs[0];
        
        [_userInfoBar refresh];
        [_userInfoBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(prepareToUserCenter)]];
        return _userInfoBar;
    } else if (section == 1) {
        return [self headViewWithTitle:UMComLocalizedString(@"Mine", @"我的") viewHeight:31];
    } else {
        return [self headViewWithTitle:UMComLocalizedString(@"recommend", @"推荐") viewHeight:31];
    }
}

- (UIView *)headViewWithTitle:(NSString *)title viewHeight:(CGFloat)viewHeight
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, viewHeight)];
    view.backgroundColor = UMComColorWithColorValueString(@"#F5F6FA");
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 50, 30)];
    CGPoint center = label.center;
    center.y = view.frame.size.height / 2.f;
    label.center = center;
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.textColor = [UMComTools colorWithHexString:FontColorGray];
    label.font = UMComFontNotoSansLightWithSafeSize(13.f);
    [view addSubview:label];
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0,viewHeight-0.5,view.frame.size.width,0.5)];
    bottomLine.backgroundColor = UMComTableViewSeparatorColor;
    [view addSubview:bottomLine];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0,0,view.frame.size.width,0.5)];
        topLine.backgroundColor = UMComTableViewSeparatorColor;
        [view addSubview:topLine];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
    } else if (indexPath.section == 1) {
        [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
            switch (indexPath.row) {
                case 0:
                {
                    self.userMessageView.hidden = YES;
                    [self tranToUsersNotice];
                }
                    break;
                case 1:
                    [self tranToUsersFavourites];
                    break;
                case 2:
                    [self tranToCircleFriends];
                    break;
                case 3:
                    [self tranToFollowedTopic];
                    break;
                case 4:
                    [self tranToAlbum];
                    break;
                    
                default:
                    break;
            }
        }];
    }else if(indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
            {
                [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
                    [self tranToNearby];
                }];
            }
                break;
                
            case 1:
                [self tranToRealTimeFeeds];
                break;
            case 2:
                [self tranToRecommendUsers];
                break;
            case 3:
                [self tranToRecommendTopics];
                break;
                
            default:
                break;
        }
    }
}

- (void)prepareToUserCenter
{
    if ([UMComLoginManager isLogin]) {
        [self tranToUserCenter];
    } else {
        __weak typeof(self) ws = self;
        [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
            if (!error) {
                [ws.userInfoBar refresh];
            }
        }];
        
    }
}

- (void)tranToCircleFriends
{
    
}

- (void)tranToFollowedTopic
{
    
}

- (void)tranToAlbum
{
    
}

- (void)tranToNearby
{
    
}

- (void)tranToRealTimeFeeds
{
    
}


- (void)tranToRecommendUsers
{
    
}


- (void)tranToRecommendTopics
{
    
}

- (void)tranToUsersFavourites
{
    
}

- (void)tranToUsersNotice
{
    
}

- (void)tranToSetting
{
    __weak typeof(self) ws = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            UMComProfileSettingController *settingVc = [[UMComProfileSettingController alloc]initWithNibName:@"UMComProfileSettingController" bundle:nil];
            [ws.navigationController pushViewController:settingVc animated:YES];
        }
    }];
}

- (void)tranToUserCenter
{
    
}

@end
