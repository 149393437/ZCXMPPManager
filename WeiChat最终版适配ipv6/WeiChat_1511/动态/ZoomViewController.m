//
//  ZoomViewController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/8.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "ZoomViewController.h"
//附近群
#import "GroupRoomViewController.h"
//爱限免
#import "LFMainTabBarController.h"
//友盟微社区
#import "UMCommunity.h"
//二维码
#import "ZCZBarViewController.h"
//不得姐
#import "EssenceViewController.h"
//主题管理
#import "ThemeManager.h"
//雷达
#import "RadarViewController.h"
//游戏中心
#import "SKViewController.h"
//摇一摇
#import "YaoYiYaoViewController.h"


@interface ZoomViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_tableView;
}
@property(nonatomic,strong)NSArray*dataArray;
@property(nonatomic,strong)NSArray*imageNameArray;
@end

@implementation ZoomViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.rightBarButtonItem=nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    [self loadData];
    [self themeClick];
    // Do any additional setup after loading the view.
}
-(void)themeClick
{
    self.navigationItem.leftBarButtonItem=nil;
    [_tableView setSeparatorColor:[ThemeManager themeColorStrToColor:kTableViewSeparatorColor]];

    [_tableView reloadData];
}
-(void)loadData{
    self.dataArray=@[@"微社区",@"扫一扫",@"摇一摇",@"附近的人",@"附近的群",@"雷达",@"蚕豆应用",@"百思不得姐"];
    
    [_tableView reloadData];
}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //取消阴影线
    [_tableView setSeparatorColor:[ThemeManager themeColorStrToColor:kTableViewSeparatorColor]];
    
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        UIView*view=[[UIView alloc]initWithFrame:CGRectZero];
        view.backgroundColor=[UIColor redColor];
        cell.selectedBackgroundView=view;

    }
    cell.textLabel.text=self.dataArray[indexPath.row];
    cell.imageView.image=[UIImage imageNamed:self.dataArray[indexPath.row]];
    cell.selectedBackgroundView.backgroundColor=[ThemeManager themeColorStrToColor:kTableViewCellNormalCellBackgroundColorHighlighted];

    //设置颜色
    cell.textLabel.textColor=[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 0:
            //友盟微社区
        {
            [manager getMyVcardBlock:^(BOOL isSuccess, XMPPvCardTemp *myVcard) {
                UMComUserAccount*accout=[[UMComUserAccount alloc]initWithSnsType:UMComSnsTypeSelfAccount];
                 accout.usid=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
                if (isSuccess) {
                    accout.name=UNCODE(myVcard.nickname);
                    
                  NSString*sex=  [[myVcard elementForName:SEX]stringValue];
                    if (sex.length>0) {
                        if ([sex isEqualToString:@"男"]) {
                            accout.gender=[NSNumber numberWithInt:1];
                        }else{
                            accout.gender=[NSNumber numberWithInt:0];
                        }
                    }else{
                        //如果没有设置,就默认是0
                        accout.gender=0;
                    }
                    if (myVcard.photo) {
                        accout.iconImage=[UIImage imageWithData:myVcard.photo];
                    }else{
                        accout.iconImage=[UIImage imageNamed:@"logo_2"];
                    }
                    
                }else{
                    accout.name=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
                    accout.gender=[NSNumber numberWithInt:0];
                    accout.iconImage=[UIImage imageNamed:@"logo_2"];
                }
                
                [UMComLoginManager loginWithLoginViewController:self userAccount:accout loginCompletion:^(id responseObject, NSError *error) {
                    
                }];

                UIViewController *mainVc = [UMCommunity getFeedsViewController];
                mainVc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:mainVc animated:YES];
                
 
            }];
        
        }
            break;
        case 1:
            //二维码扫描
        {
            ZCZBarViewController*vc=[[ZCZBarViewController alloc]initWithBlock:^(NSString *message, BOOL isSuccess) {
                if (isSuccess) {
                    //添加好友
                    [manager addSomeBody:message Newmessage:nil];
                    [[[UIAlertView alloc]initWithTitle:@"已发送好友邀请" message:nil delegate:nil cancelButtonTitle:@"" otherButtonTitles: nil]show];
                    
                }
                
                
            }];
            [self presentViewController:vc animated:YES completion:nil];

        
        }
            
            
            
            break;
        case 2:
            //摇一摇
        {
            YaoYiYaoViewController*vc=[[YaoYiYaoViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
            //附近人
            break;
        case 4:
            //附近群
        {
            GroupRoomViewController*vc=[[GroupRoomViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 5:
            //雷达
        {
            RadarViewController*vc=[[RadarViewController alloc]init];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            //蚕豆应用
            LFMainTabBarController*tbc=[[LFMainTabBarController alloc]init];
            tbc.nc=self.navigationController;
            tbc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:tbc animated:YES];
            
            //隐藏导航条
            self.navigationController.navigationBarHidden=YES;
        
        }
            break;
        case 7:
        {
        //不得姐
            EssenceViewController*vc=[[EssenceViewController alloc]init];
            
            vc.dic=@{@"a":@"list"};
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 8:
        {
        //游戏中心
            SKViewController*net=[[SKViewController alloc]init];
            net.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:net animated:YES];
        }
            
        default:
            break;
    }

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

@end
