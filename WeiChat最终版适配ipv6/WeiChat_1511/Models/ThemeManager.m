//
//  ThemeManager.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/9.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "ThemeManager.h"
#import "HttpDownLoad.h"
#import "ZipArchive.h"
static ThemeManager*manager=nil;
@implementation ThemeManager
+(id)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[ThemeManager alloc]init];
        
        manager.themePath=[NSString stringWithFormat:@"%@downLoadThemeList.plist",LIBPATH];
        manager.bubblePath=[NSString stringWithFormat:@"%@downLoadBubble.plist",LIBPATH];
        manager.chatBgPath=[NSString stringWithFormat:@"%@downLoadChatBgName.plist",LIBPATH];
        manager.fontPath=[NSString stringWithFormat:@"%@downLoadFontName.plist",LIBPATH];
        
        manager.themeArray=[NSMutableArray arrayWithContentsOfFile:manager.themePath];
        manager.bubbleArray=[NSMutableArray arrayWithContentsOfFile:manager.bubblePath];
        manager.chatBgNameArray=[NSMutableArray arrayWithContentsOfFile:manager.chatBgPath];
        manager.fontArray=[NSMutableArray arrayWithContentsOfFile:manager.fontPath];
        
        //如果themeArray为nil
        if (manager.themeArray==nil) {
            manager.themeArray=[NSMutableArray array];
        }
        if (manager.bubbleArray==nil) {
            manager.bubbleArray=[NSMutableArray array];
        }
        if (manager.chatBgNameArray==nil) {
            manager.chatBgNameArray=[NSMutableArray array];
        }
        if (manager.fontArray==nil) {
            manager.fontArray=[NSMutableArray array];
        }
    });
    return manager;
}
#pragma mark 下载气泡
-(void)downLoadBubbleWithDic:(NSDictionary *)dic{
    self.bubbleName=dic[@"baseInfo"][@"name"];
    NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
    if ([self.bubbleArray containsObject:self.bubbleName]) {
        [user setObject:self.bubbleName forKey:BUBBLE];
        [user synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:BUBBLE object:nil];
    }else{
        alertView=[[UIAlertView alloc]initWithTitle:@"正在努力下载中..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [alertView show];
        
        //进行下载
        //http://i.gtimg.cn/club/item/avatar/zip/7/i487/all.zip
        HttpDownLoad*http=[[HttpDownLoad alloc]initWithURLStr:[NSString stringWithFormat:@"http://i.gtimg.cn/club/item/avatar/zip/%d/i%@/all.zip",[dic[@"baseInfo"][@"id"] intValue]%10,dic[@"baseInfo"][@"id"]] Post:NO DataDic:nil Block:^(HttpDownLoad *xx, BOOL isSuccess) {
            if (isSuccess) {
                //保存的路径
                NSString*savePath=[NSString stringWithFormat:@"%@all.zip",LIBPATH];
                //解压缩路径
                NSString*unZipPath=[NSString stringWithFormat:@"%@%@",LIBPATH,self.bubbleName];
                
                [xx.data writeToFile:savePath atomically:YES];
                
                ZipArchive*zip=[[ZipArchive alloc]init];
                
                [zip UnzipOpenFile:savePath];
                
                [zip UnzipFileTo:unZipPath overWrite:YES];
                
                [zip CloseZipFile2];
                
                //解压缩完成后记录主题在本地
                [user setObject:self.bubbleName forKey:BUBBLE];
                [user synchronize];
                
                //主题持久化记录在主题下载列表中
                [self.bubbleArray addObject:self.bubbleName];
                
                [self.bubbleArray writeToFile:_bubblePath atomically:YES];
                
                //发送广播
                [[NSNotificationCenter defaultCenter]postNotificationName:BUBBLE object:nil];
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
                
            }
        }];
        
        http=nil;

    }
}

#pragma mark 下载主题
-(void)downLoadThemeWithDic:(NSDictionary *)dic
{
    self.themeName=dic[@"baseInfo"][@"name"];
    NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
    
    //判断主题是否存在
    if ([self.themeArray containsObject:self.themeName]) {
        //如果存在,则本地记录当前主题,在进行广播
        [user setObject:self.themeName forKey:THEME];
        [user synchronize];
        //让所有接受通知的vc进行全部切换主题
        [[NSNotificationCenter defaultCenter]postNotificationName:THEME object:nil];
        
    }else{
        alertView=[[UIAlertView alloc]initWithTitle:@"正在努力下载中..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [alertView show];
        
        //进行下载
        
        //http://i.gtimg.cn/qqshow/admindata/comdata/vipThemeNew_item_2033/2033_i_6_0_i_2.zip
        HttpDownLoad*http=[[HttpDownLoad alloc]initWithURLStr:[NSString stringWithFormat:@"http://i.gtimg.cn/qqshow/admindata/comdata/vipThemeNew_item_%@/%@",dic[@"baseInfo"][@"id"],[dic[@"operationInfo"] lastObject][@"zip"]] Post:NO DataDic:nil Block:^(HttpDownLoad *xx, BOOL isSuccess) {
            if (isSuccess) {
                //保存的路径
                NSString*savePath=[NSString stringWithFormat:@"%@com.zip",LIBPATH];
                //解压缩路径
                NSString*unZipPath=[NSString stringWithFormat:@"%@%@",LIBPATH,self.themeName];
                
                [xx.data writeToFile:savePath atomically:YES];
                
                ZipArchive*zip=[[ZipArchive alloc]init];
                
                [zip UnzipOpenFile:savePath];
                
                [zip UnzipFileTo:unZipPath overWrite:YES];
                
                [zip CloseZipFile2];
                
                //解压缩完成后记录主题在本地
                [user setObject:self.themeName forKey:THEME];
                [user synchronize];
                
                //主题持久化记录在主题下载列表中
                [self.themeArray addObject:self.themeName];
                
                [self.themeArray writeToFile:_themePath atomically:YES];
                
                //发送广播
                [[NSNotificationCenter defaultCenter]postNotificationName:THEME object:nil];
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
                
            }
        }];
        
        http=nil;
    
    }
    

}
#pragma mark 下载背景
-(void)downLoadChatBgWithDic:(NSDictionary*)dic
{
    self.chatBgName=dic[@"name"];
    NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
    
    //判断主题是否存在
    if ([self.chatBgNameArray containsObject:self.chatBgName]) {
        //如果存在,则本地记录当前主题,在进行广播
        [user setObject:self.chatBgName forKey:CHATBGNAME];
        [user synchronize];
        //让所有接受通知的vc进行全部切换主题
        [[NSNotificationCenter defaultCenter]postNotificationName:CHATBGNAME object:nil];
        
    }else{
        alertView=[[UIAlertView alloc]initWithTitle:@"正在努力下载中..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [alertView show];
        
        //进行下载
        
        //http://i.gtimg.cn/qqshow/admindata/comdata/vipThemeNew_item_2033/2033_i_6_0_i_2.zip
        HttpDownLoad*http=[[HttpDownLoad alloc]initWithURLStr:[NSString stringWithFormat:@"http://i.gtimg.cn/qqshow/admindata/comdata/vipChatBg_item_%@/%@",dic[@"id"],dic[@"aioImage"]] Post:NO DataDic:nil Block:^(HttpDownLoad *xx, BOOL isSuccess) {
            
            if (isSuccess) {
                //保存的路径
                NSString*savePath=[NSString stringWithFormat:@"%@%@.png",LIBPATH,dic[@"name"]];
                [xx.data writeToFile:savePath atomically:YES];
                //解压缩完成后记录主题在本地
                [user setObject:self.chatBgName forKey:CHATBGNAME];
                [user synchronize];
                
                manager.chatBgPath=[NSString stringWithFormat:@"%@downLoadChatBgName.plist",LIBPATH];

                //主题持久化记录在主题下载列表中
                [self.chatBgNameArray addObject:self.chatBgName];
                
                [self.chatBgNameArray writeToFile:_chatBgPath atomically:YES];
                
                //发送广播
                [[NSNotificationCenter defaultCenter]postNotificationName:CHATBGNAME object:nil];
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
                
            }
        }];
        
        http=nil;
        
    }


}
-(void)downLoadFontWithDic:(NSDictionary*)dic
{
    self.fontNum=dic[@"baseInfo"][@"id"];
    NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
    
    //判断主题是否存在
    if ([self.fontArray containsObject:self.fontNum]) {
        //如果存在,则本地记录当前主题,在进行广播
        [user setObject:self.fontNum forKey:FONT];
        [user synchronize];
        //让所有接受通知的vc进行全部切换主题
        [[NSNotificationCenter defaultCenter]postNotificationName:FONT object:nil];
        
    }else{
        alertView=[[UIAlertView alloc]initWithTitle:@"正在努力下载中..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [alertView show];
        
        //进行下载
        
        //http://i.gtimg.cn/qqshow/admindata/comdata/vipThemeNew_item_2033/2033_i_6_0_i_2.zip
        HttpDownLoad*http=[[HttpDownLoad alloc]initWithURLStr:[NSString stringWithFormat:@"http://i.gtimg.cn/qqshow/admindata/comdata/vipfont_%@/ios.zip",dic[@"baseInfo"][@"id"]] Post:NO DataDic:nil Block:^(HttpDownLoad *xx, BOOL isSuccess) {
            if (isSuccess) {
                //保存的路径
                NSString*savePath=[NSString stringWithFormat:@"%@font.zip",LIBPATH];
                //解压缩路径
                NSString*unZipPath=[NSString stringWithFormat:@"%@%@",LIBPATH,self.fontNum];
                
                [xx.data writeToFile:savePath atomically:YES];
                
                ZipArchive*zip=[[ZipArchive alloc]init];
                
                [zip UnzipOpenFile:savePath];
                
                [zip UnzipFileTo:unZipPath overWrite:YES];
                
                [zip CloseZipFile2];
                
                //解压缩完成后记录主题在本地
                [user setObject:self.fontNum forKey:FONT];
                [user synchronize];
                
                //主题持久化记录在主题下载列表中
                [self.fontArray addObject:self.fontNum];
                
                [self.fontArray writeToFile:_fontPath atomically:YES];
                
                //发送广播
                [[NSNotificationCenter defaultCenter]postNotificationName:FONT object:nil];
                [alertView dismissWithClickedButtonIndex:0 animated:YES];
                
            }
        }];
        
        http=nil;
        
    }


}


+(UIColor*)themeColorStrToColor:(NSString*)name
{
    //读取地址
    NSString*imagePath=[NSString stringWithFormat:@"%@%@/",[NSString stringWithFormat:@"%@/",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]],[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]];
    
    NSDictionary*colorDic=[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@ThemeConfig.plist",imagePath]];
    
    if (colorDic==nil) {
        return [UIColor whiteColor];
    }
    //0x00,0x08,0x14,1
    NSString*ColorStr=colorDic[@"ColorTable"][name];
    NSArray*ColorArray=[ColorStr componentsSeparatedByString:@","];
    //c语言方法~~字符串16进制转换为16进制数字
    //    strtoul([@"0x6587" UTF8String],0,0);
    UIColor*color=[UIColor colorWithRed:strtoul([ColorArray[0] UTF8String],0,0)/255.0 green:strtoul([ColorArray[1] UTF8String],0,0)/255.0 blue:strtoul([ColorArray[2] UTF8String],0,0)/255.0 alpha:[ColorArray[3] floatValue]];
    
    
    return color;
}

@end
