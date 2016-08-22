//
//  AppDelegate.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/7.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainSliderViewController.h"
//解压缩
#import "ZipArchive.h"

//友盟微社区的头文件
#import "UMCommunity.h"

#import "ThemeManager.h"
//友盟反馈
#import "UMFeedback.h"
//友盟推送
#import "UMessage.h"
#import "UMOpus.h"
#define APPKEY @"56fde982e0f55a30c5001eae"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self UMConfig:launchOptions];
    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    
    NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
    
    
    //判断程序是不是第一次启动,如果第一次启动,把主题包解压缩到lib文件夹下
    if (![user objectForKey:@"appfirst"]) {
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"本座联系方式QQ:149393437@qq.com,仅此提醒一次,下次运行不会出现" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
        //第一次启动
        //设置路径
        NSString*movePath=[[NSBundle mainBundle]pathForResource:@"com" ofType:@"zip"];
        NSString*savePath=[NSString stringWithFormat:@"%@初音未来/",LIBPATH];
        
        ZipArchive*zip=[[ZipArchive alloc]init];
        
        [zip UnzipOpenFile:movePath];
        
        [zip UnzipFileTo:savePath overWrite:YES];
        //当关闭解压缩工具时候,才会从内存中进行开始解压缩
        [zip UnzipCloseFile];
        
        NSLog(@"%@",savePath);
        //保存第一次启动
        [user setObject:@"appfirst" forKey:@"appfirst"];
        //记录当前默认主题是谁
        [user setObject:@"初音未来" forKey:THEME];
        
        [user synchronize];
        
        
    }
    //对tableView进行统一设置
    //取消背景色
    [[UITableView appearance]setBackgroundColor:[UIColor clearColor]];
    //取消背景色
    [[UITableViewCell appearance]setBackgroundColor:[UIColor clearColor]];
    //修改状态条
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UITableView appearance]setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    //判断是否登陆过
    if ([user objectForKey:isLogin1]) {
        //直接进入主界面
        MainSliderViewController*slider=[MainSliderViewController sharedSliderController];
        UINavigationController*nc=[[UINavigationController alloc]initWithRootViewController:slider];
        self.window.rootViewController=nc;
    }else{
        //创建登陆界面
        LoginViewController*vc=[[LoginViewController alloc]init];
        self.window.rootViewController=vc;
    
    }

    [self.window makeKeyAndVisible];
    
    return YES;
}
-(void)UMConfig:(NSDictionary*)launchOptions{
    // Override point for customization after application launch.
    [UMOpus setAudioEnable:YES];
    [UMFeedback setAppkey:APPKEY];
    //推送相关,有反馈的时候,点击进入
    [[UMFeedback sharedInstance] setFeedbackViewController:[UMFeedback feedbackViewController] shouldPush:YES];
    NSDictionary *notificationDict = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ([notificationDict valueForKey:@"aps"]) // 点击推送进入
    {
        [UMFeedback didReceiveRemoteNotification:notificationDict];
        // 自定义UI时需判断notificationDict[@"feedback"]
    }
    
    // with remote push notification
    [UMessage startWithAppkey:APPKEY launchOptions:launchOptions];
    
    //设置APPKEY
    [UMCommunity setWithAppKey:@"568e1157e0f55aec9b002711"];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>8.0) {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    } else {
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert];
    }
    [UMessage setLogEnabled:NO];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(checkFinished:)
//                                                 name:UMFBCheckFinishedNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receiveNotification:)
//                                                 name:nil
//                                               object:nil];

}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSLog(@"device token is: %@", deviceToken);
    [UMessage registerDeviceToken:deviceToken];
//    NSLog(@"umeng message alias is: %@", [UMFeedback uuid]);
    [UMessage addAlias:[UMFeedback uuid] type:[UMFeedback messageType] response:^(id responseObject, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //    [UMessage didReceiveRemoteNotification:userInfo];
    [UMFeedback didReceiveRemoteNotification:userInfo];
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
