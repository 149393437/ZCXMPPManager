//
//  GroupRoomViewController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/17.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "GroupRoomViewController.h"
//群聊
#import "GroupChatViewController.h"
#import "ThemeManager.h"
//创建群组
#import "GroupCreateViewController.h"
//加入群组
#import "GroupAddViewController.h"
@interface GroupRoomViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_tableView;
}
@property(nonatomic,strong)NSMutableArray*dataArray;
@end

@implementation GroupRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"群聊列表";
    [self createTableView];
    [self loadData];
    [self createRightNav];
    // Do any additional setup after loading the view.
}
-(void)createRightNav{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[self imageNameStringToImage:@"header_icon_add.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightNavClick)];


}
-(void)rightNavClick{
    
    UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"选择加入或创建" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"创建",@"加入", nil];
    [sheet showInView:self.view];

}
-(void)loadData{
    //xmpp的房间列表
    [manager searchXmppRoomBlock:^(NSMutableArray *roomList) {
        self.dataArray=[NSMutableArray arrayWithArray:roomList];
        //每一个元素是字典 roomJid  roomName
        [_tableView reloadData];
    }];

}
-(void)themeClick
{
    [_tableView setSeparatorColor:[ThemeManager themeColorStrToColor:kTableViewSeparatorColor]];

}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
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
    }
    cell.textLabel.textColor=[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal];
    
    cell.textLabel.text=self.dataArray[indexPath.row][@"roomName"];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GroupChatViewController*vc=[[GroupChatViewController alloc]init];
    vc.roomJid=self.dataArray[indexPath.row][@"roomJid"];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
        //创建
            GroupCreateViewController*vc=[[GroupCreateViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 1:
        {
        //加入
            GroupAddViewController*vc=[[GroupAddViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
        //取消
        }
            break;
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
