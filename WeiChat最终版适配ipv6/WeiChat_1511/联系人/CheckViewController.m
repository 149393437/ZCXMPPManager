//
//  CheckViewController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/10.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "CheckViewController.h"
#import "ThemeManager.h"
@interface CheckViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_tableView;
}
@property(nonatomic,strong)NSMutableArray*dataArray;
@end

@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)loadData{
    self.dataArray=manager.subscribeArray;
    [_tableView reloadData];

}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
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
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        //同意
        UIButton*agree=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-100, 5, 80, 30) ImageName:nil Target:self Action:@selector(agreeClick:) Title:@"同意"];
        [cell.contentView addSubview:agree];
        //拒绝
        UIButton*reject=[ZCControl createButtonWithFrame:CGRectMake(WIDTH-200, 5, 80, 30) ImageName:nil Target:self Action:@selector(rejectClick:) Title:@"拒绝"];
        [cell.contentView addSubview:reject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

    }
    cell.textLabel.textColor=[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal];

    cell.contentView.tag=indexPath.row;
    XMPPPresence*presence=self.dataArray[indexPath.row];
    cell.textLabel.text=presence.from.user;
    
    
    return cell;
    
}
-(void)agreeClick:(UIButton*)button{
    XMPPPresence*presence=self.dataArray[button.superview.tag];
    //同意
    [manager agreeRequest:presence.from.user];
    
    [_tableView reloadData];
}
-(void)rejectClick:(UIButton*)button{
 XMPPPresence*presence=self.dataArray[button.superview.tag];
    //拒绝
    [manager reject:presence.from.user];
    
    [_tableView reloadData];
    
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
