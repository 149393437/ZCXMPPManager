//
//  ClearViewController.m
//  weiChat
//
//  Created by zhangcheng on 14-8-5.
//  Copyright (c) 2014年 张诚. All rights reserved.
//

#import "ClearViewController.h"
#import "ThemeManager.h"
@interface ClearViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_tableView;
}
@end

@implementation ClearViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=YES;
}
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
    // Do any additional setup after loading the view.
    self.title=@"清理缓存";
    [self createTableView];
    [self loadData];
    
}
-(void)loadData{
    NSString*theme=[self ThemeSize];
    NSString*bubble=[self bubbleSize];
    NSString*httpDownFile=[self httpSize];
    NSString*chatBg=[self chatBgSize];
    self.dataArray=@[theme,chatBg,httpDownFile,bubble];
    [_tableView reloadData];
}

-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.textLabel.textColor=[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal];
    }
    NSArray*xx=@[@"主题缓存数据为：",@"背景图缓存数据为：",@"网络请求缓存数据为：",@"气泡缓存为:"];
    cell.textLabel.text=[NSString stringWithFormat:@"%@%@",xx[indexPath.row],self.dataArray[indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self clearTheme];
            break;
        case 1:
            [self clearBubbleSize];
            break;
        case 2:
            [self clearHttp];
            break;
        case 3:
            [self clearChatBgSize];
            break;
        default:
            break;
    }
    [self loadData];
    [_tableView reloadData];
}
-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"点击相应按键清空缓存，由于当前使用主题，主题缓存不会全部清空";
}
-(NSString*)httpSize{
    //            NSString*path=[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),_cacheFileName];

    float size=[self folderSizeAtPath:[NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()]];
    return [NSString stringWithFormat:@"%.2fM",size];

}
-(void)clearHttp{
    NSFileManager*manager1=[NSFileManager defaultManager];
    [manager1 removeItemAtPath:[NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()] error:nil];
}
-(NSString*)bubbleSize{
    //读取文件列表
    NSArray*array=[NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@downLoadBubble.plist",LIBPATH]];
    
    CGFloat filesize=0;
    for (NSString*name in array) {
        //计算文件夹下的文件
        float cacheSize=[self folderSizeAtPath:[NSString stringWithFormat:@"%@%@",LIBPATH,name]];
        filesize+=cacheSize;
        
    }
    return [NSString stringWithFormat:@"%.2fM",filesize];
    


}

-(void)clearBubbleSize{
    //读取文件列表
    NSArray*array=[NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@downLoadBubble.plist",LIBPATH]];
    NSString*bubble=[[NSUserDefaults standardUserDefaults]objectForKey:BUBBLE];
    NSFileManager*manager1=[NSFileManager defaultManager];
    for (NSString*name in array) {
        //删除
        if (![name isEqualToString:bubble]) {
            [manager1 removeItemAtPath:[NSString stringWithFormat:@"%@%@",LIBPATH,name] error:nil];
        }
    }
    [manager1 removeItemAtPath:[NSString stringWithFormat:@"%@%@",LIBPATH,@"all.zip"] error:nil];
    NSArray*write=@[bubble];
    [write writeToFile:[NSString stringWithFormat:@"%@downLoadBubble.plist",LIBPATH] atomically:YES];

}

-(NSString*)ThemeSize{
//读取文件列表
    NSArray*array=[NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@downLoadThemeList.plist",LIBPATH]];

    CGFloat filesize=0;
    for (NSString*name in array) {
        //计算文件夹下的文件
        float cacheSize=[self folderSizeAtPath:[NSString stringWithFormat:@"%@%@",LIBPATH,name]];
        filesize+=cacheSize;
  
    }
    return [NSString stringWithFormat:@"%.2fM",filesize];
    

}


-(void)clearTheme{
    
    //读取文件列表
    NSArray*array=[NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@downLoadThemeList.plist",LIBPATH]];
    NSString*themeStr=[[NSUserDefaults standardUserDefaults]objectForKey:THEME];
    NSString*bubble=[[NSUserDefaults standardUserDefaults]objectForKey:BUBBLE];
    NSFileManager*manager1=[NSFileManager defaultManager];
    for (NSString*name in array) {
        //删除
                if (![name isEqualToString:themeStr]&&![name isEqualToString:bubble]) {
                    [manager1 removeItemAtPath:[NSString stringWithFormat:@"%@%@",LIBPATH,name] error:nil];
        }
    }
    [manager1 removeItemAtPath:[NSString stringWithFormat:@"%@%@",LIBPATH,@"com.zip"] error:nil];
    NSArray*write=@[themeStr];
    [write writeToFile:[NSString stringWithFormat:@"%@downLoadThemeList.plist",LIBPATH] atomically:YES];
    
    
}
-(NSString*)chatBgSize{
    //读取文件列表
    NSArray*array=[NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@downLoadChatBgName.plist",LIBPATH]];
    
    CGFloat filesize=0;
    for (NSString*name in array) {
        //计算文件夹下的文件
        CGFloat cacheSize=[[[NSFileManager defaultManager] attributesOfItemAtPath:[NSString stringWithFormat:@"%@%@.png",LIBPATH,name] error:nil] fileSize];;
        filesize+=cacheSize;
        
    }
    return [NSString stringWithFormat:@"%.2fM",filesize/(1024*1024)];
    
    
    
}

-(void)clearChatBgSize{
    //读取文件列表
    NSArray*array=[NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@downLoadChatBgName.plist",LIBPATH]];
    NSString*bubble=[[NSUserDefaults standardUserDefaults]objectForKey:BUBBLE];
    NSFileManager*manager1=[NSFileManager defaultManager];
    for (NSString*name in array) {
        //删除
        if (![name isEqualToString:bubble]) {
            [manager1 removeItemAtPath:[NSString stringWithFormat:@"%@%@.png",LIBPATH,name] error:nil];
        }
    }
    NSArray*write=@[bubble];
    [write writeToFile:[NSString stringWithFormat:@"%@downLoadBubble.plist",LIBPATH] atomically:YES];
    
}
//文件夹下的大小
- (float )folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager1 = [NSFileManager defaultManager];
    if (![manager1 fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager1 subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    CGFloat folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    
    return folderSize/(1024.0*1024.0);
}

- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager1 = [NSFileManager defaultManager];
    if ([manager1 fileExistsAtPath:filePath]){
        return [[manager1 attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//删除文件
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
