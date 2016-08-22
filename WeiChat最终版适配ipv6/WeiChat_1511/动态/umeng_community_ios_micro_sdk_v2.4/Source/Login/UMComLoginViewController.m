//
//  UMComLoginViewController.m
//  UMCommunity
//
//  Created by Gavin Ye on 8/25/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComLoginViewController.h"
#import "UMSocial.h"
#import "UMComHttpClient.h"
#import "UMComSession.h"
#import "UMComHttpManager.h"
#import "UMComShowToast.h"
#import "UMComBarButtonItem.h"
#import "WXApi.h"
#import "UIViewController+UMComAddition.h"

@interface UMComLoginViewController ()

@end

@implementation UMComLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sinaLoginButton.tag = UMSocialSnsTypeSina;
    self.qqLoginButton.tag = UMSocialSnsTypeMobileQQ;
    self.wechatLoginButton.tag = UMSocialSnsTypeWechatSession;
    
    if ([UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ]) {
        [self.qqLoginButton setImage:UMComImageWithImageName(@"tencentx") forState:UIControlStateNormal];
    }
    if ([UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession]) {
        [self.wechatLoginButton setImage:UMComImageWithImageName(@"wechatx") forState:UIControlStateNormal];
    }
    
    [self.sinaLoginButton addTarget:self action:@selector(onClickLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.qqLoginButton addTarget:self action:@selector(onClickLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.wechatLoginButton addTarget:self action:@selector(onClickLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton addTarget:self action:@selector(onClickClose) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButtonItem = [[UMComBarButtonItem alloc] initWithNormalImageName:@"Backx" target:self action:@selector(onClickClose)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    [self setTitleViewWithTitle:UMComLocalizedString(@"Login_Title", @"登录")];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)onClickClose
{
//    [UIView setAnimationsEnabled:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onClickLogin:(UIButton *)button
{
    
    
    
    NSString *snsName = nil;
    switch (button.tag) {
        case UMSocialSnsTypeSina:
            snsName = UMShareToSina;
            break;
        case UMSocialSnsTypeMobileQQ:
            snsName = UMShareToQQ;
            break;
        case UMSocialSnsTypeWechatSession:
            snsName = UMShareToWechatSession;
            break;
        default:
            break;
    }
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    if (!snsPlatform) {
        [UMComShowToast notSupportPlatform];
    } else if ([snsName isEqualToString:UMShareToWechatSession] && ![WXApi isWXAppInstalled]){
        [UMComShowToast showNotInstall];
    } else {
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity * response){

            if (response.responseCode == UMSResponseCodeSuccess) {
                [[UMSocialDataService defaultDataService] requestSnsInformation:snsPlatform.platformName completion:^(UMSocialResponseEntity *userInfoResponse) {
                    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
                    UMComSnsType snsType = UMComSnsTypeOther;
                    if ([snsPlatform.platformName isEqualToString:UMShareToSina]) {
                        snsType = UMComSnsTypeSina;
                    } else if ([snsPlatform.platformName isEqualToString:UMShareToWechatSession]){
                        snsType = UMComSnsTypeWechat;
                    } else if ([snsPlatform.platformName isEqualToString:UMShareToQQ]){
                        snsType = UMComSnsTypeQQ;
                    }
                    UMComUserAccount *account = [[UMComUserAccount alloc] initWithSnsType:snsType];
                    account.usid = snsAccount.usid;
                    account.custom = @"这是一个自定义字段，可以改成自己需要的数据";
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        if ([userInfoResponse.data valueForKey:@"screen_name"]) {
                            account.name = [userInfoResponse.data valueForKey:@"screen_name"];
                        }
                        if ([userInfoResponse.data valueForKey:@"profile_image_url"]) {
                            account.icon_url = [userInfoResponse.data valueForKey:@"profile_image_url"];
                        }
                        if ([userInfoResponse.data valueForKey:@"gender"]) {
                            account.gender = [userInfoResponse.data valueForKey:@"gender"] ;
                        }
                    }
                    [UMComLoginManager loginWithLoginViewController:self userAccount:account loginCompletion:^(id responseObject, NSError *error) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                }];
                
            } else {
                    [UMComLoginManager loginWithLoginViewController:self userAccount:nil loginCompletion:^(id responseObject, NSError *error) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
            }
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
