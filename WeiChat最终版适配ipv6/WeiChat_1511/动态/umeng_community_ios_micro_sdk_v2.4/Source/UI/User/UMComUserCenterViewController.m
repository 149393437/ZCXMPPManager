//
//  UMComUserCenterViewController.m
//  UMCommunity
//
//  Created by Gavin Ye on 9/10/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComUserCenterViewController.h"
#import "UMComPullRequest.h"
#import "UMComUser+UMComManagedObject.h"
#import "UMComSession.h"
#import "UMComShowToast.h"
#import "UMComTopicsTableViewController.h"
#import "UMComPhotoAlbumViewController.h"
#import "UMComPushRequest.h"
#import "UMComFeedTableViewController.h"
#import "UMComUsersTableViewController.h"
#import "UMComPrivateChatTableViewController.h"
#import "UIViewController+UMComAddition.h"
#import "UMComBarButtonItem.h"
#import "UMComUserOperationFinishDelegate.h"
#import "UMComLoginManager.h"
#import "UMComUserProfileDetailView.h"
#import "UMComScrollViewDelegate.h"
#import "UMComMedal+CoreDataProperties.h"
#import "UMComFeedsTableViewCell.h"
//#import "UMComUserTableViewCell.h"

#define SuperAdmin 3 //超级管理员

@interface UMComUserCenterViewController ()<UMComScrollViewDelegate, UIActionSheetDelegate, UMComUserProfileDetaiViewDelegate, UMComUserOperationFinishDelegate>

@property (nonatomic, strong) UMComUser *user;

@property (nonatomic, strong) UMComUserProfileDetailView *detailView;

@property (nonatomic, strong) UMComUserProfileRequest *userProfileRequest;

@property (nonatomic, strong) UIViewController *lastViewController;

@property(nonatomic,readwrite,strong)UMComBarButtonItem* privateLetterItem;//操作私信的按钮
/** 判断当前私信是否显示 */
-(BOOL) isPrivateLetterItemShow;

@end

@implementation UMComUserCenterViewController


- (instancetype)initWithUser:(UMComUser *)user
{
    self = [super init];
    if (self) {
        self.user = user;
        self.userProfileRequest = [[UMComUserProfileRequest alloc]initWithUid:self.user.uid sourceUid:nil];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setForumUITitle:self.user.name];
    
    //设置返回按钮
    [self setForumUIBackButton];
    
    //设置私信和更多按钮
    [self creatNavigationItemList];
    
    //创建详情按钮
    [self creatDetailView];
    
    //获取个人信息
    [self getCurrentUserRequest];
    
    //创建子ViewController
    [self creatChildViewControllers];
    
}

-(BOOL) isPrivateLetterItemShow
{
    NSString* curUserUID = self.user.uid;
    NSString* longUserUID = [UMComSession sharedInstance].loginUser.uid;
    
    //判断当前用户和自己进入个人中心的用户是否是一个人，如果是就不显示
    if (curUserUID && longUserUID && [longUserUID isEqualToString:curUserUID]) {
        return NO;
    }
    
    int curUserType = 0;
    int loginUserType = 0;
    curUserType  = self.user.atype.intValue;
    loginUserType = [UMComSession sharedInstance].loginUser.atype.intValue;
    
    if (curUserType == 1 || curUserType == 3 || loginUserType == 3 || loginUserType == 1) {
        return YES;
    }
    return NO;
}

//点击私信管理
- (void)clickOnPrivateLetter
{
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            UMComPrivateChatTableViewController *chatTableViewController = [[UMComPrivateChatTableViewController alloc]initWithUser:weakSelf.user];
            [weakSelf.navigationController pushViewController:chatTableViewController animated:YES];
        }
    }];
    
}

- (void)showMoreOperationMenuView
{
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报", nil];
            [actionSheet showInView:self.view];
        }
    }];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"举报"]) {
        [UMComPushRequest spamWithUser:self.user completion:^(NSError *error) {
            [UMComShowToast spamUser:error];
        }];
    }
}

#pragma mark - created subviews method
- (void)creatNavigationItemList
{
    if (![self.user.uid isEqualToString:[UMComSession sharedInstance].uid]) {
        self.privateLetterItem = [[UMComBarButtonItem alloc] initWithNormalImageName:@"um_forum_user_privateletter" target:self action:@selector(clickOnPrivateLetter)];
        self.privateLetterItem.customButtonView.frame = CGRectMake(0, 0, 20, 20);
        self.privateLetterItem.customButtonView.titleLabel.font = UMComFontNotoSansLightWithSafeSize(17);
        UMComBarButtonItem *rightButtonItem = nil;
        if ([self.user.uid isEqualToString:[UMComSession sharedInstance].uid]|| [self.user.atype intValue] == 3) {
            rightButtonItem = [[UMComBarButtonItem alloc] init];
            rightButtonItem.customButtonView.frame = CGRectMake(0, 12, 10, 4);
        }else{
            rightButtonItem = [[UMComBarButtonItem alloc] initWithNormalImageName:@"um_forum_more_gray" target:self action:@selector(showMoreOperationMenuView)];
            rightButtonItem.customButtonView.frame = CGRectMake(0, 12, 20, 4);
        }
        rightButtonItem.customButtonView.titleLabel.font = UMComFontNotoSansLightWithSafeSize(17);
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]init];
        UIView *spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 20)];
        spaceView.backgroundColor = [UIColor clearColor];
        [spaceItem setCustomView:spaceView];
        UMComBarButtonItem *rightSpaceItem = [[UMComBarButtonItem alloc] init];
        rightSpaceItem.customButtonView.frame = CGRectMake(0, 12, 20, 4);
        rightSpaceItem.customButtonView.titleLabel.font = UMComFontNotoSansLightWithSafeSize(17);
        [self.navigationItem setRightBarButtonItems:@[rightButtonItem,spaceItem,self.privateLetterItem]];
        
        //判断私信按钮是否显示
        if ([self isPrivateLetterItemShow]) {
            self.privateLetterItem.customButtonView.hidden = NO;
        }
        else{
            self.privateLetterItem.customButtonView.hidden = YES;
        }
        
    }
    
}

//创建个人信息详情页
- (void)creatDetailView
{
    CGFloat UserProfileDetailViewHeight = 220;
    UMComMedal *medal = self.user.medal_list.firstObject;
    if (medal.icon_url) {
        UserProfileDetailViewHeight += 30;
    }
    self.detailView = [[UMComUserProfileDetailView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, UserProfileDetailViewHeight) user:self.user];
    self.detailView.deleagte = self;
    [self.view addSubview:self.detailView];
}

//创建子ViewControllers
- (void)creatChildViewControllers
{
    CGRect frame = self.view.frame;
    frame.origin.y = self.detailView.frame.size.height;
    frame.size.height = self.view.frame.size.height - frame.origin.y;
    UMComFeedTableViewController *postTableViewController = [[UMComFeedTableViewController alloc]initWithFetchRequest:[[UMComUserFeedsRequest alloc] initWithUid:self.user.uid count:BatchSize type:UMComTimeLineTypeDefault]];
    postTableViewController.view.frame = frame;
    [self.view addSubview:postTableViewController.view];
    [self addChildViewController:postTableViewController];
    postTableViewController.scrollViewDelegate = self;

    
    UMComUsersTableViewController *followersTableViewController = [[UMComUsersTableViewController alloc] initWithFetchRequest:[[UMComFollowersRequest alloc] initWithUid:self.user.uid count:BatchSize]];
    followersTableViewController.userOperationFinishDelegate = self;
    followersTableViewController.view.frame = frame;
    [self addChildViewController:followersTableViewController];
    followersTableViewController.scrollViewDelegate = self;
    
    UMComUsersTableViewController *fanTableViewController = [[UMComUsersTableViewController alloc]initWithFetchRequest:[[UMComFansRequest alloc] initWithUid:self.user.uid count:BatchSize]];
    fanTableViewController.view.frame = frame;
    [self addChildViewController:fanTableViewController];
    self.lastViewController = fanTableViewController;
    fanTableViewController.userOperationFinishDelegate = self;
    fanTableViewController.scrollViewDelegate = self;
    [self userProfileDetailView:self.detailView clickAtIndex:0];
}


#pragma mark - UserDetailViewDelgate
//点击关注按钮
- (void)userProfileDetailView:(UMComUserProfileDetailView *)userProfileDetailView clickOnfocuse:(UIButton *)focuseButton
{
    
    __weak typeof(self) weakSelf = self;
    [UMComLoginManager performLogin:self completion:^(id responseObject, NSError *error) {
        if (!error) {
            [UMComPushRequest followerWithUser:weakSelf.user isFollow:![weakSelf.user.has_followed boolValue] completion:^(NSError *error) {
                UMComUsersTableViewController *userTableViewController = nil;
                if ([weakSelf.user.uid isEqualToString:[UMComSession sharedInstance].uid]) {
                    userTableViewController = weakSelf.childViewControllers[1];
                }else{
                    userTableViewController = weakSelf.childViewControllers[2];
                }
                UMComUser *user = [UMComSession sharedInstance].loginUser;
                if (error) {
                    if (error.code == ERR_CODE_USER_HAVE_FOLLOWED) {
                        [userTableViewController insertUserToTableView:user];
                    }
                    [UMComShowToast showFetchResultTipWithError:error];
                }else{
                    if ([weakSelf.user.has_followed boolValue]) {
                        [userTableViewController insertUserToTableView:user];
                    }else{
                        [userTableViewController deleteUserFromTableView:user];
                    }
                }
                if (!error ||  error.code == ERR_CODE_USER_HAVE_FOLLOWED) {
                    if (weakSelf.userOperationFinishDelegate && [weakSelf.userOperationFinishDelegate respondsToSelector:@selector(focusedUserOperationFinish:)]) {
                        [weakSelf.userOperationFinishDelegate focusedUserOperationFinish:weakSelf.user];
                    }
                }
                [weakSelf.detailView reloadSubViewsWithUser:weakSelf.user];
            }];
        }
    }];
}



//点击相册按钮
- (void)userProfileDetailView:(UMComUserProfileDetailView *)userProfileDetailView clickOnAlbum:(UIButton *)albumButton
{
    UMComPhotoAlbumViewController *photoAlbumVc = [[UMComPhotoAlbumViewController alloc]init];
    photoAlbumVc.user = self.user;
    [self.navigationController pushViewController:photoAlbumVc animated:YES];
}

//点击关注的话题的按钮
- (void)userProfileDetailView:(UMComUserProfileDetailView *)userProfileDetailView clickOnFollowTopic:(UIButton *)topicButton
{
    UMComTopicsTableViewController *topicViewController = [[UMComTopicsTableViewController alloc]init];
    topicViewController.isAutoStartLoadData = YES;
    topicViewController.fetchRequest = [[UMComUserTopicsRequest alloc]initWithUid:self.user.uid count:BatchSize];
    [self.navigationController pushViewController:topicViewController animated:YES];
}

- (void)userProfileDetailView:(UMComUserProfileDetailView *)userProfileDetailView clickAtIndex:(NSInteger)index
{
    [self transitionFromViewControllerAtIndex:self.detailView.lastIndex toViewControllerAtIndex:index animations:nil completion:nil];
}


#pragma mark - getData

- (void)getCurrentUserRequest
{
    __weak typeof(self) weakSelf = self;
    [self.userProfileRequest fetchRequestFromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
        if ([data isKindOfClass:[NSArray class]] && data.count > 0) {
            UMComUser *user = data.firstObject;
            weakSelf.user = user;
            [weakSelf.detailView reloadSubViewsWithUser:user];
        }else if(error){
            [UMComShowToast showFetchResultTipWithError:error];
        }
    }];
}

#pragma mark - UMComUserOperationFinishDelegate
- (void)reloadDataWhenUserOperationFinish:(UMComUser *)user
{
    for (int index = 1; index < 2; index ++) {
        UMComUsersTableViewController *usertableVc = self.childViewControllers[index];
        [usertableVc.tableView reloadData];
    }
    [self.detailView reloadSubViewsWithUser:self.user];
}

- (void)focusedUserOperationFinish:(UMComUser *)user
{
    for (int index = 1; index < 2; index ++) {
        UMComUsersTableViewController *usertableVc = self.childViewControllers[index];
        if ([self.user.uid isEqualToString:[UMComSession sharedInstance].uid] && index == 1) {
            if ([user.has_followed boolValue]) {
                [usertableVc insertUserToTableView:user];
            }else{
                [usertableVc deleteUserFromTableView:user];
            }
        }
        [usertableVc.tableView reloadData];
    }
    [self.detailView reloadSubViewsWithUser:self.user];
}


- (void)scrollViewDidScrollWithScrollView:(UIScrollView *)scrollView lastPosition:(CGPoint)lastPosition
{
    if (scrollView.contentOffset.y >0 && scrollView.contentOffset.y > lastPosition.y+20) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self subViewControllersScrollToTop:scrollView];
        } completion:nil];
    }else{
        if (scrollView.contentOffset.y < lastPosition.y-10) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [self subViewControllersScrollToBottom:scrollView];

            } completion:^(BOOL finished) {
                if (self.detailView.frame.origin.y < 0 && scrollView.contentOffset.y <= 0) {
                    for (UMComRequestTableViewController *viewController in self.childViewControllers) {
                        CGRect frame = viewController.view.frame;
                        CGRect headFrame = self.detailView.frame;
                        headFrame.origin.y = 0;
                        self.detailView.frame = headFrame;
                        frame.origin.y = self.detailView.frame.size.height;
                        frame.size.height = self.view.frame.size.height - frame.origin.y;
                        viewController.view.frame = frame;
                        if (viewController.tableView.contentSize.height < frame.size.height) {
                            viewController.tableView.contentSize = CGSizeMake(viewController.tableView.contentSize.width, frame.size.height +1);
                        }
                    }
                }
            }];
        }
    }
}


- (void)subViewControllersScrollToTop:(UIScrollView *)scrollView
{
    if (self.detailView.frame.origin.y == 0 && scrollView.contentOffset.y >= 0) {
        for (UMComRequestTableViewController *viewController in self.childViewControllers) {
            CGRect frame = viewController.view.frame;
            CGRect headFrame = self.detailView.frame;
            headFrame.origin.y = - self.detailView.frame.size.height + 48;
            self.detailView.frame = headFrame;
            frame.origin.y = 48;
            frame.size.height = self.view.frame.size.height - frame.origin.y;
            viewController.view.frame = frame;
            if (viewController.tableView.contentSize.height < frame.size.height) {
                viewController.tableView.contentSize = CGSizeMake(viewController.tableView.contentSize.width, frame.size.height +1);
            }
        }
    }
}

- (void)subViewControllersScrollToBottom:(UIScrollView *)scrollView
{
    if (self.detailView.frame.origin.y < 0 && scrollView.contentOffset.y <= 0) {
        for (UMComRequestTableViewController *viewController in self.childViewControllers) {
            CGRect frame = viewController.view.frame;
            CGRect headFrame = self.detailView.frame;
            headFrame.origin.y = 0;
            self.detailView.frame = headFrame;
            frame.origin.y = self.detailView.frame.size.height;
            viewController.view.frame = frame;
        }
    }
}

#pragma mark - UMComScrollViewDelegate
- (void)customScrollViewDidScroll:(UIScrollView *)scrollView lastPosition:(CGPoint)lastPosition
{
    [self scrollViewDidScrollWithScrollView:scrollView lastPosition:lastPosition];
}

- (void)customScrollViewDidEnd:(UIScrollView *)scrollView lastPosition:(CGPoint)lastPosition
{
    [self scrollViewDidScrollWithScrollView:scrollView lastPosition:lastPosition];
}


@end
