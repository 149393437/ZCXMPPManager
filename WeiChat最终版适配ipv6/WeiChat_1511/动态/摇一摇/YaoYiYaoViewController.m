//
//  YaoYiYaoViewController.m
//  weiChat
//
//  Created by ZhangCheng on 14/6/27.
//  Copyright (c) 2014年 张诚. All rights reserved.
//

#import "YaoYiYaoViewController.h"
#import "FriendCell.h"
#import "RadarFriendViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface YaoYiYaoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_tableView;
}
@end

@implementation YaoYiYaoViewController

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
    self.title=@"摇一摇";
    
       [self createTableView];
    [_tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ID"];
    bgImageView1=[ZCControl createImageViewWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) ImageName:[NSString stringWithFormat:@"YaoYiYao%d.jpg",arc4random()%2]];
    [self.view addSubview:bgImageView1];

}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"开始摇动");
    
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    SystemSoundID _soundID;
    NSURL *soundUrl=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tweet" ofType:@"caf"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(soundUrl), &_soundID);
    AudioServicesPlaySystemSound(_soundID);
    NSLog(@"结束摇动");
    
    if (!isFinish) {

        isFinish=YES;
       HttpDownLoad*xx= [[HttpDownLoad alloc]initWithURLStr:@"http://1000phone.net:8088/app/openfire/api/user/near.php?latitude=39.896304&longitude=116.410103&radius=100" Post:NO DataDic:nil Block:^(HttpDownLoad *http, BOOL success) {
           self.dataArray=[http.dataDic  objectForKey:@"users"];
           [_tableView reloadData];
           
           dispatch_async(dispatch_get_main_queue(), ^{
               isFinish=NO;
               CATransition*ani=[CATransition animation];
               ani.duration=2.0f;
               ani.subtype = kCATransitionFromRight;
               NSArray*array=@[@"reveal",@"pageCurl",@"pageUnCurl", @"suckEffect",@"rippleEffect"];
               NSString*aniStr=array[arc4random()%array.count];
               NSLog(@"~~%@",aniStr);
               ani.type=aniStr;
               [self.view.layer addAnimation:ani forKey:@""];
               [self.view bringSubviewToFront:_tableView];
               bgImageView1.hidden=YES;
           });

        }];
        xx=nil;
        
        
    }

}

-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    [cell configOfRecent:@[@"[1]W",@"2016-03-11 03:51:19 +0000",@"53276888",@"[1]"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    //获得vard  还有用户账号
    RadarFriendViewController*vc=[[RadarFriendViewController alloc]init];
    //获得用户vcard
    vc.friendJid=[self.dataArray[indexPath.row] objectForKey:@"jid"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}


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
