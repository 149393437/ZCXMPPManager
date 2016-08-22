//
//  UMComLoginManager.m
//  UMCommunity
//
//  Created by Gavin Ye on 8/25/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComLoginManager.h"
#import "UMComSession.h"
#import "UMComMessageManager.h"
#import "UMComShowToast.h"
#import "UMUtils.h"
#import "UMComPushRequest.h"
#import "UMComNavigationController.h"
#import "UMComUsersTableViewController.h"
#import "UMComTopicsTableViewController.h"
#import "UMComProfileSettingController.h"
#import "UMComErrorCode.h"
#import "UMComPullRequest.h"

@interface UMComLoginManager ()

@property (nonatomic, strong) id<UMComLoginDelegate> loginHandler;

@property (nonatomic, copy) NSString *appKey;

@property (nonatomic, strong) UIViewController *currentViewController;

@property (nonatomic, copy) void (^loginCompletion)(id responseObject, NSError *error);//登录回调


@property (nonatomic, assign) BOOL didUpdateFinish;


@end

@implementation UMComLoginManager

static UMComLoginManager *_instance = nil;
+ (UMComLoginManager *)shareInstance {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[UMComLoginManager alloc] init];
        }
    }
    return _instance;
}

- (void)loginWhenReceivedLoginError
{
    [UMComLoginManager performLogin:[UIApplication sharedApplication].keyWindow.rootViewController completion:^(id responseObject, NSError *error) {
        
    }];
}

+ (void)setAppKey:(NSString *)appKey
{
    if ([[self shareInstance].loginHandler respondsToSelector:@selector(setAppKey:)]) {
        [self shareInstance].appKey = appKey;
        [[self shareInstance].loginHandler setAppKey:appKey];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        
        Class delegateClass = NSClassFromString(@"UMComUMengLoginHandler");
        self.loginHandler = [[delegateClass alloc] init];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginWhenReceivedLoginError) name:kUMComUserDidNotLoginErrorNotification object:nil];
    }
    return self;
}

+ (void)performLogin:(UIViewController *)viewController completion:(void (^)(id responseObject, NSError *error))completion
{
    if ([self isLogin]) {
        if (completion) {
            completion([UMComSession sharedInstance].loginUser,nil);
        }
    }else if ([self shareInstance].loginHandler) {
        [self shareInstance].currentViewController = viewController;
        //设置登录登录回调
        [self shareInstance].loginCompletion = completion;
        //弹出登录页面
        [[self shareInstance].loginHandler presentLoginViewController:viewController finishResponse:nil];
    }else{
        UMLog(@"There is no implement login delegate method");
    }
}

+ (id<UMComLoginDelegate>)getLoginHandler
{
    return [self shareInstance].loginHandler;
}

+ (BOOL)isLogin{
    BOOL isLogin = [UMComSession sharedInstance].isLogin;
    return isLogin;
}

+ (void)setLoginHandler:(id <UMComLoginDelegate>)loginHandler
{
    [self shareInstance].loginHandler = loginHandler;
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    if ([[self shareInstance].loginHandler respondsToSelector:@selector(handleOpenURL:)]) {
        return [[self shareInstance].loginHandler handleOpenURL:url];
    }
    return NO;
}

+ (BOOL)isIncludeSpecialCharact:(NSString *)str {
    
    NSString *regex = @"(^[a-zA-Z0-9_\u4e00-\u9fa5]+$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isRight = ![pred evaluateWithObject:str];
    return isRight;
}

+ (void)loginWithLoginViewController:(UIViewController *)loginViewController userAccount:(UMComUserAccount *)loginUserAccount loginCompletion:(LoginCompletion)completion
{
    UMComLoginManager *loginManager = [UMComLoginManager shareInstance];
    //    基本登录逻辑（如果不使用demo推荐的登录逻辑可以直接实现这个方法）
    [UMComPushRequest loginWithUser:loginUserAccount completion:^(id responseObject, NSError *error) {
        if ([responseObject isKindOfClass:[UMComUser class]]) {//登录成功则隐藏登录页面
            [loginViewController dismissViewControllerAnimated:YES completion:^{
                [UMComLoginManager loginSuccessWithUser:responseObject];
                UMComUser *loginUser = responseObject;
                if ([loginUser.registered integerValue] == 0) {//判断是否第一次登录，如果是第一次登陆则走第一次登录逻辑
                    [loginManager firstTimeLoginHandleLogic:loginManager.currentViewController loginUserAccount:loginUserAccount responseObject:responseObject loginCompletion:completion];
                }else{
                    //如果不是第一次登陆则直接返回
                    SafeCompletionDataAndError(loginManager.loginCompletion, responseObject, nil);
                }
            }];
        }else{
            [loginManager loginFailWithLoginViewController:loginViewController userAccount:loginUserAccount error:error completion:^(id responseObject, NSError *error) {
                SafeCompletionDataAndError(loginManager.loginCompletion, nil, error);

            }];
        }
    }];
}


- (void)loginFailWithLoginViewController:(UIViewController *)loginViewController
                             userAccount:(UMComUserAccount *)loginUserAccount
                                   error:(NSError *)error
                              completion:(void (^)(id responseObject, NSError *))completion
{
    __weak typeof(self) weakSelf = self;
    if (error.code == ERR_CODE_USER_NAME_LENGTH_ERROR || error.code == ERR_CODE_USER_NAME_SENSITIVE || error.code == ERR_CODE_USER_NAME_DUPLICATE || error.code == ERR_CODE_USER_NAME_CONTAINS_ILLEGAL_CHARS) {
        //如果登录的是后用户名不服和要求则会调到用户设置页面
        [UMComShowToast showFetchResultTipWithError:error];
        [self showUserAccountSettingViewController:loginViewController userAccont:loginUserAccount error:error completion:^(UIViewController *viewController, UMComUserAccount *userAcount) {
            //用户名修改完成后重新登录
            weakSelf.didUpdateFinish = YES;
            [viewController dismissViewControllerAnimated:YES completion:^{
                [UMComLoginManager loginWithLoginViewController:loginViewController userAccount:loginUserAccount loginCompletion:completion];
            }];
        }];
    } else{
        SafeCompletionDataAndError(completion, nil, error);
        [UMComShowToast showFetchResultTipWithError:error];
    }
}

#pragma mark - 第一次登陆调用此方法
- (void)firstTimeLoginHandleLogic:(UIViewController *)loginViewController
                 loginUserAccount:(UMComUserAccount *)loginUserAccount
                   responseObject:(id)responseObject
                  loginCompletion:(LoginCompletion)completion
{
    if (_didUpdateFinish) {
        // 注册后因为用户名有错误，已经修改过用户名，直接显示推荐话题和推荐用户页面
        [self showRecommendViewControllerWithLoginViewController:loginViewController loginComletion:^{
            SafeCompletionDataAndError(completion, responseObject, nil);
        }];
    }else{
        // 注册后用户名正确，没有修改过用户名，则显示用户信息修改页面
        [self showUserAccountSettingViewController:loginViewController userAccont:loginUserAccount error:nil completion:^(UIViewController *viewController, UMComUserAccount *userAccount) {
            //[viewController dismissViewControllerAnimated:YES completion:^{
            //显示推荐话题和推荐用户页面
            [self showRecommendViewControllerWithLoginViewController:loginViewController loginComletion:^{
                SafeCompletionDataAndError(completion, responseObject, nil);
                //     }];
            }];
        }];
    }
    
}

#pragma mark - 显示信息设置页面
- (void)showUserAccountSettingViewController:(UIViewController *)viewController
                                  userAccont:(UMComUserAccount *)userAccount
                                       error:(NSError *)error
                                  completion:(void (^)(UIViewController *viewController, UMComUserAccount *loginUserAccount))completion
{
    UMComProfileSettingController *profileController = [[UMComProfileSettingController alloc] init];
    if (error) {
        profileController.settingCompletion = ^(UIViewController *viewController, UMComUserAccount *loginUserAccount){
            SafeCompletionDataAndError(completion, viewController, loginUserAccount);
        };
        profileController.registerError  = error;
    }else{
        profileController.updateCompletion = ^(id data, NSError *error){
            SafeCompletionDataAndError(completion, nil, nil);
        };
    }
    profileController.userAccount = userAccount;
    UMComNavigationController *profileNaviController = [[UMComNavigationController alloc] initWithRootViewController:profileController];
    [viewController presentViewController:profileNaviController animated:YES completion:nil];
}

#pragma mark - 显示推荐页面
- (void)showRecommendViewControllerWithLoginViewController:(UIViewController *)viewController loginComletion:(void (^)())loginCompletion
{
    [self showForumRecommendTopicWithViewController:viewController completion:^(UIViewController *recommendTopicVC) {
        [self showForumRecommendUserWithViewController:recommendTopicVC completion:^(UIViewController *recommendUserVC) {
            [recommendUserVC dismissViewControllerAnimated:YES completion:nil];
            if (loginCompletion) {
                loginCompletion();
            }
        }];
    }];
}

- (void)showForumRecommendUserWithViewController:(UIViewController *)viewController
                                      completion:(void (^)(UIViewController *recommendUserVC))completion
{
    UMComUsersTableViewController *userRecommendViewController = [[UMComUsersTableViewController alloc] initWithCompletion:completion];
    userRecommendViewController.isAutoStartLoadData = YES;
    userRecommendViewController.title = UMComLocalizedString(@"user_recommend", @"用户推荐");
    userRecommendViewController.fetchRequest = [[UMComRecommendUsersRequest alloc]initWithCount:BatchSize];
    [viewController.navigationController pushViewController:userRecommendViewController animated:YES];
}

- (void)showForumRecommendTopicWithViewController:(UIViewController *)viewController completion:(void (^)(UIViewController *recommendTopicVC))completion
{
    UMComTopicsTableViewController *topicsRecommendViewController = [[UMComTopicsTableViewController alloc] initWithCompletion:completion];
    topicsRecommendViewController.completion = completion;
    topicsRecommendViewController.isAutoStartLoadData = YES;
    topicsRecommendViewController.isShowNextButton = YES;
    topicsRecommendViewController.title = UMComLocalizedString(@"user_topic_recommend", @"话题推荐");
    topicsRecommendViewController.fetchRequest = [[UMComRecommendTopicsRequest alloc]initWithCount:BatchSize];
    UMComNavigationController *topicsNav = [[UMComNavigationController alloc] initWithRootViewController:topicsRecommendViewController];
    [viewController presentViewController:topicsNav animated:YES completion:nil];
}



+ (void)loginSuccessWithUser:(UMComUser *)loginUser
{
    if (![loginUser isKindOfClass:[UMComUser class]]) {
        return;
    }
    NSString *uid = loginUser.uid;
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSucceedNotification object:nil];
    NSString *aliasKey = @"UM_COMMUNITY";
    [UMComMessageManager addAlias:uid type:aliasKey response:^(id responseObject, NSError *error) {
        if (error) {
            //添加alias失败的话在每次启动时候重新添加
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"UMComMessageAddAliasFail"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UMLog(@"add alias is %@ error is %@",responseObject,error);
        }
    }];
    
    [UMComPushRequest requestConfigDataWithResult:nil];
}

+ (void)userLogout
{
    [[UMComSession sharedInstance] userLogout];
}

@end
