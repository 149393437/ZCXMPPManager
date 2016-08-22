//
//  FriendViewController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/8.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "FriendViewController.h"
#import "CheckViewController.h"
#import "ChatViewController.h"
#import "FriendCell.h"
#import "ThemeManager.h"
#import "GroupChatViewController.h"
@interface FriendViewController ()
{
    //显示验证消息数量
    UIButton*checkButton;
    
    int  isOpen[4];
    UIButton*leftButton;
    UIButton*rightButton;
    BOOL isLeft;
}
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)NSMutableArray*groupListArray;
@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=nil;

    [self createRightNav];
    
    //创建tableView
    [self createTabelView];
    
    [self createSegmentControl];

    [self loadData];
    
    [self loadGroup];
    // Do any additional setup after loading the view.
}
#pragma mark 群组列表
-(void)loadGroup{
   [manager myGroupListBlock:^(NSMutableArray *array) {
       self.groupListArray=[NSMutableArray arrayWithArray:array];
       if (!isLeft) {
           [_tableView reloadData];
       }
    }];
}
-(void)createSegmentControl{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    leftButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:nil Target:self Action:@selector(leftButtonClick) Title:@"好友"];
    leftButton.selected=YES;
    leftButton.userInteractionEnabled=NO;
    isLeft=YES;
    
    [leftButton setTitleColor:[ThemeManager themeColorStrToColor:kTableMenuTextColorNormal] forState:UIControlStateNormal];
    [leftButton setTitleColor:[ThemeManager themeColorStrToColor:kTableMenuTextColorSelected] forState:UIControlStateSelected];
    
    [leftButton setBackgroundImage:[self imageNameStringToImage:@"header_lefttab_nor.png"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[self imageNameStringToImage:@"header_lefttab_press.png"] forState:UIControlStateSelected];
    [view addSubview:leftButton];
    rightButton=[ZCControl createButtonWithFrame:CGRectMake(60, 0, 60, 30) ImageName:nil Target:self Action:@selector(rightButtonClick) Title:@"群组"];
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

    [_tableView setSeparatorColor:[ThemeManager themeColorStrToColor:kTableViewSeparatorColor]];

    self.navigationItem.leftBarButtonItem=nil;

    [_tableView reloadData];
}
-(void)loadData{
    
   NSArray*array= [manager friendsList:^(BOOL isOK) {
       if (isLeft) {
           [self loadData];
       }
    }];
    
    self.dataArray =[NSMutableArray arrayWithArray:array];
    if (manager.subscribeArray.count>0) {
        if (checkButton==nil) {
            checkButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, WIDTH, 30) ImageName:nil Target:self Action:@selector(CheckClick) Title:nil];
            [checkButton setTitleColor:[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal] forState:UIControlStateNormal];
            _tableView.tableHeaderView=checkButton;
        }
        
        [checkButton setTitle:[NSString stringWithFormat:@"当前有%ld条验证消息",manager.subscribeArray.count] forState:UIControlStateNormal];
        if (_tableView.tableHeaderView==nil) {
            _tableView.tableHeaderView=checkButton;
        }
        
    }else {
        _tableView.tableHeaderView=nil;
    }
    [_tableView reloadData];

}
-(void)createTabelView{
    isLeft=YES;
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView setSeparatorColor:[ThemeManager themeColorStrToColor:kTableViewSeparatorColor]];
    
    [self.view addSubview:_tableView];
}

-(void)CheckClick{
    
    CheckViewController*vc=[[CheckViewController alloc]init];
    
    vc.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)createRightNav{
    UIButton*button=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:nil Target:self Action:@selector(rightClick) Title:@"添加"];
    [button setTitleColor:[ThemeManager themeColorStrToColor:kNavigationBarButtonTitleColorNoraml] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    

}
-(void)rightClick{
    UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"请输入好友账号" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alertView show];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        return;
    }
    UITextField*textField=[alertView textFieldAtIndex:0];
    
    if (textField.text.length>0) {
        //开始发送好友请求  2个参数 第一个是好友账号 第二个是验证消息
        [manager addSomeBody:textField.text Newmessage:[NSString stringWithFormat:@"%@请求添加你为好友",[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID]]];
    }

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isLeft) {
        return  self.dataArray.count;

    }else{
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isLeft) {
        return isOpen[section]?0:[self.dataArray[section] count];

    }else{
        return self.groupListArray.count;
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
        }
        cell.selectedBackgroundView.backgroundColor=[ThemeManager themeColorStrToColor:kTableViewCellNormalCellBackgroundColorHighlighted];
        
        //读取数据源
        XMPPUserCoreDataStorageObject*object=self.dataArray[indexPath.section][indexPath.row];
        
        [cell configOfFriendModel:object];
        return cell;
    }else{
        UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID1"];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID1"];
        }
        cell.textLabel.textColor=[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal];
        cell.textLabel.text=self.groupListArray[indexPath.row][@"name"];
        return cell;

    
    }
 
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isLeft) {
        //读取用户jid
        XMPPUserCoreDataStorageObject*object=self.dataArray[indexPath.section][indexPath.row];
        ChatViewController*vc=[[ChatViewController alloc]init];
        vc.friendJid=object.jidStr;
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        GroupChatViewController*vc=[[GroupChatViewController alloc]init];
        vc.roomJid=self.groupListArray[indexPath.row][@"from"];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
  

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (isLeft) {
        NSArray*array=@[@"好友",@"关注",@"被关注",@"陌生人"];
        
        UIView*view=[[UIView alloc]initWithFrame:CGRectZero];
        UIImageView*spin=[[UIImageView alloc]initWithFrame:CGRectMake(20,20 , 10, 10)];
        
        spin.image=[self imageNameStringToImage:@"buddy_header_arrow.png"];
        [view addSubview:spin];
        if (!isOpen[section]) {
            spin.transform=CGAffineTransformMakeRotation(M_PI_2);
        }
        
        UILabel*label=[ZCControl createLabelWithFrame:CGRectMake(50, 15, 200, 20) Font:15 Text:[NSString stringWithFormat:@"%@ (%ld 人)",array[section],[self.dataArray[section] count]]];
        
        [view addSubview:label];
        UIControl*control=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        control.tag=section;
        [control addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        view.backgroundColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
        [view addSubview:control];
        
        
        return view;

    }else{
        return nil;
    }
    
}
//判断收缩
-(void)headerButtonClick:(UIControl*)button{
    
    isOpen[button.tag]=!isOpen[button.tag];
    //刷新某一段
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (isLeft) {
        return 44;
    }else{
        return 0;
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
