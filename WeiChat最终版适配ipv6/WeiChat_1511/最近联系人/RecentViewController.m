//
//  RecentViewController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/8.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "RecentViewController.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ChatViewController.h"
#import "FriendCell.h"
#import "ZCZBarViewController.h"
#import "GroupChatViewController.h"
#import "ThemeManager.h"
#import "GroupCheckCell.h"

@interface RecentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_tableView;
    UIButton*leftButton;
    UIButton*rightButton;
    BOOL isLeft;
}
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)NSArray*groupCheckArray;
@end

@implementation RecentViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kXMPPNewMsgNotifaction object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=nil;
    //最近联系人实际上是一个本地数据库的读取操作,xmpp本身是不提供这个逻辑,我们通过截取收发信息,来记录在数据库中,每次收到新的消息,进行排序,优先获取
    
    [self createTableView];
    
    [self loadData];
    
    [self createRightNav];
    
    [self createSegmentControl];
    
    //读取验证信息
    [manager groupCheckWithBlock:^(NSArray *xx) {
        
        self.groupCheckArray=xx;
        if (!isLeft) {
            [_tableView reloadData];
            //可以选择加小红点
        }
    }];
    //注册通知,当有新消息时候,更新最近联系人
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:kXMPPNewMsgNotifaction object:nil];
    // Do any additional setup after loading the view.
}
-(void)createSegmentControl{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    leftButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:nil Target:self Action:@selector(leftButtonClick) Title:@"消息"];
    leftButton.selected=YES;
    leftButton.userInteractionEnabled=NO;
    isLeft=YES;

    [leftButton setTitleColor:[ThemeManager themeColorStrToColor:kTableMenuTextColorNormal] forState:UIControlStateNormal];
    [leftButton setTitleColor:[ThemeManager themeColorStrToColor:kTableMenuTextColorSelected] forState:UIControlStateSelected];

    [leftButton setBackgroundImage:[self imageNameStringToImage:@"header_lefttab_nor.png"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[self imageNameStringToImage:@"header_lefttab_press.png"] forState:UIControlStateSelected];
    [view addSubview:leftButton];
    rightButton=[ZCControl createButtonWithFrame:CGRectMake(60, 0, 60, 30) ImageName:nil Target:self Action:@selector(rightButtonClick) Title:@"验证"];
    [rightButton setTitleColor:[ThemeManager themeColorStrToColor:kTableMenuTextColorNormal] forState:UIControlStateNormal];
    [rightButton setTitleColor:[ThemeManager themeColorStrToColor:kTableMenuTextColorSelected] forState:UIControlStateSelected];
    [rightButton setBackgroundImage:[self imageNameStringToImage:@"header_righttab_nor.png"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[self imageNameStringToImage:@"header_righttab_press.png"] forState:UIControlStateSelected];
    [view addSubview:leftButton];
    [view addSubview:rightButton];
    
    self.navigationItem.titleView=view;
}
-(void)leftButtonClick{
    isLeft=YES;
    leftButton.selected=YES;
    rightButton.selected=NO;
    rightButton.userInteractionEnabled=YES;
    leftButton.userInteractionEnabled=NO;
    [_tableView reloadData];
}
-(void)rightButtonClick{
    isLeft=NO;
    leftButton.selected=NO;
    rightButton.selected=YES;
    rightButton.userInteractionEnabled=NO;
    leftButton.userInteractionEnabled=YES;
    [_tableView reloadData];

}
-(void)themeClick
{
    [leftButton setTitleColor:[ThemeManager themeColorStrToColor:kTableMenuTextColorNormal] forState:UIControlStateNormal];
    [leftButton setTitleColor:[ThemeManager themeColorStrToColor:kTableMenuTextColorSelected] forState:UIControlStateSelected];
    
    [leftButton setBackgroundImage:[self imageNameStringToImage:@"header_lefttab_nor.png"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[self imageNameStringToImage:@"header_lefttab_press.png"] forState:UIControlStateSelected];
    
    [rightButton setTitleColor:[ThemeManager themeColorStrToColor:kTableMenuTextColorNormal] forState:UIControlStateNormal];
    [rightButton setTitleColor:[ThemeManager themeColorStrToColor:kTableMenuTextColorSelected] forState:UIControlStateSelected];
    [rightButton setBackgroundImage:[self imageNameStringToImage:@"header_righttab_nor.png"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[self imageNameStringToImage:@"header_righttab_press.png"] forState:UIControlStateSelected];
    
    self.navigationItem.leftBarButtonItem=nil;
    [_tableView setSeparatorColor:[ThemeManager themeColorStrToColor:kTableViewSeparatorColor]];

    [self createRightNav];
    [_tableView reloadData];
}
-(void)createRightNav{
    UIButton*button=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) ImageName:nil Target:self Action:@selector(rightNavClick) Title:nil];
    [button setImage:[self imageNameStringToImage:@"menu_icon_bulb.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];

}
#pragma mark 扫一扫
-(void)rightNavClick{
  
    
    ZCZBarViewController*vc=[[ZCZBarViewController alloc]initWithBlock:^(NSString *message, BOOL isSuccess) {
        if (isSuccess) {
            //判断是群聊邀请还是好友邀请
            if ([message hasPrefix:@"[1]"]) {
                //切割前面[1]和后面后缀
              NSString*newStr=[[message componentsSeparatedByString:@"@"]firstObject];
                newStr=[newStr substringFromIndex:3];
            
                GroupChatViewController*vc=[[GroupChatViewController alloc]init];
                vc.roomJid=newStr;
                vc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                //添加好友
                [manager addSomeBody:message Newmessage:nil];
                [[[UIAlertView alloc]initWithTitle:@"已发送好友邀请" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
            }

        }
        
        
    }];
    [self presentViewController:vc animated:YES completion:nil];

}
-(void)loadData{
   NSArray*array= [ZCMessageObject fetchRecentChatByPage:20];
    self.dataArray=[NSMutableArray arrayWithArray:array];
    [_tableView reloadData];
}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    [self.view addSubview:_tableView];
    
    //取消阴影线
    [_tableView setSeparatorColor:[ThemeManager themeColorStrToColor:kTableViewSeparatorColor]];
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isLeft) {
        return self.dataArray.count;
    }else{
        return self.groupCheckArray.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isLeft) {
        FriendCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"FriendCell" owner:self options:nil]firstObject];
            UIView*view=[[UIView alloc]initWithFrame:CGRectZero];
            view.backgroundColor=[UIColor redColor];
            cell.selectedBackgroundView=view;
            
            cell.selectedBackgroundView.backgroundColor=[ThemeManager themeColorStrToColor:kTableViewCellNormalCellBackgroundColorHighlighted];
        }
        NSArray*array=self.dataArray[indexPath.row];
        
        [cell configOfRecent:array];
        
        
        return cell;

    }else{
        GroupCheckCell*cell=[_tableView dequeueReusableCellWithIdentifier:@"ID1"];
        if (cell==nil) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"GroupCheckCell" owner:nil options:nil]firstObject];
        }
        NSDictionary*dic=self.groupCheckArray[indexPath.row];
        //@{@"from":from,@"to":to,@"reason":reason,@"type":type,@"date":[NSDate date]
        [cell config:dic];
        return cell;
    
    
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (isLeft) {
        NSArray*array=self.dataArray[indexPath.row];
        
        NSString*jid=array[2];
        
        
        if ([[array lastObject]hasPrefix: GROUPCHAT]) {
            GroupChatViewController*vc=[[GroupChatViewController alloc]init];
            vc.roomJid=jid;
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ChatViewController*vc=[[ChatViewController alloc]init];
            
            vc.friendJid=jid;
            
            vc.hidesBottomBarWhenPushed=YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }

    }else{
        NSDictionary*dic=self.groupCheckArray[indexPath.row];
        //@{@"from":from,@"to":to,@"reason":reason,@"type":type,@"date":[NSDate date]
        
        if ([dic[@"type"] isEqualToString:@"2"]) {
            GroupChatViewController*vc=[[GroupChatViewController alloc]init];
            vc.roomJid=dic[@"from"];
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        
        }
       
    
    }
    
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
