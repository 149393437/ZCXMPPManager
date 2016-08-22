//
//  GroupAddFriendViewController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/4/6.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "GroupAddFriendViewController.h"
#import "ThemeManager.h"
#import "FriendCell.h"
@interface GroupAddFriendViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_tableView;
    BOOL isOpen[4];
}
@property(nonatomic,strong)NSArray*dataArray;
@property(nonatomic,strong)NSMutableArray*selectIndexArray;
@end

@implementation GroupAddFriendViewController
-(instancetype)initWithBlock:(void(^)(NSArray*))a
{
    if (self=[super init]) {
        self.myBlock=a;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavLeftandRight];
    self.selectIndexArray=[NSMutableArray array];
    
    self.dataArray=manager.listArray;
    if (self.dataArray==nil) {
        self.dataArray=[manager friendsList:nil];
    }
    
    [self createTableView];

    // Do any additional setup after loading the view.
}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.editing=YES;
    [_tableView setSeparatorColor:[ThemeManager themeColorStrToColor:kTableViewSeparatorColor]];
    
    [self.view addSubview:_tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return isOpen[section]?0:[self.dataArray[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"FriendCell" owner:self options:nil]firstObject];
        UIView*view=[[UIView alloc]initWithFrame:CGRectZero];
        cell.selectedBackgroundView=view;
        cell.qmd.hidden=YES;
    }
    cell.selectedBackgroundView.backgroundColor=[ThemeManager themeColorStrToColor:kTableViewCellNormalCellBackgroundColorHighlighted];
    
    //读取数据源
    XMPPUserCoreDataStorageObject*object=self.dataArray[indexPath.section][indexPath.row];
    
    [cell configOfFriendModel:object];
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //读取用户jid
    XMPPUserCoreDataStorageObject*object=self.dataArray[indexPath.section][indexPath.row];

    if (![self.selectIndexArray containsObject:object.jidStr]) {
        [self.selectIndexArray addObject:object.jidStr];
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //读取用户jid
    XMPPUserCoreDataStorageObject*object=self.dataArray[indexPath.section][indexPath.row];
    [self.selectIndexArray removeObject:object.jidStr];
   

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
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
    
}

//判断收缩
-(void)headerButtonClick:(UIControl*)button{
    
    isOpen[button.tag]=!isOpen[button.tag];
    //刷新某一段
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:button.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
#pragma mark 多选操作
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //
}


-(void)createNavLeftandRight{
    //建立左边和右边的返回
    UIButton*leftButton=[ZCControl createButtonWithFrame:CGRectMake(0, 20, 60, 30) ImageName:nil Target:self Action:@selector(leftButtonClick) Title:@"返回"];
    [leftButton setTitleColor:[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal] forState:UIControlStateNormal];
    
    [self.view addSubview:leftButton];
    
    UIButton*rightButton=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-60, 20, 60, 30) ImageName:nil Target:self Action:@selector(rightButtonClick) Title:@"完成"];
    [rightButton setTitleColor:[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal] forState:UIControlStateNormal];
    
    [self.view addSubview:rightButton];

}
-(void)leftButtonClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)rightButtonClick{
//    [self dismissViewControllerAnimated:YES completion:nil];
   al= [[UIAlertView alloc]initWithTitle:@"正在发送邀请" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    
    [al show];
    for (NSString*jidStr in self.selectIndexArray) {
        [manager inviteRoom:_room userName:jidStr];
    }
    [al dismissWithClickedButtonIndex:0 animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
