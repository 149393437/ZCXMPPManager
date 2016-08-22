//
//  TopViewController.m
//  LimitFreeProject
//
//  Created by zhangcheng on 16/2/18.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "TopViewController.h"
#import "TopCell.h"
@interface TopViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSMutableArray*dataArray;
@end

@implementation TopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //对sc的自适配关闭
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"] forBarMetrics:UIBarMetricsDefault];
    
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(leftBarButtonItemClick)];
    
    
    
    //加载代码的cell
//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ID"];
    
    //加载xib的cell
//    [_tableView registerNib:[UINib nibWithNibName:@"" bundle:nil] forCellReuseIdentifier:@"ID"];
    
    [self loadData];
    
    // Do any additional setup after loading the view.
}
-(void)leftBarButtonItemClick{
     [[NSNotificationCenter defaultCenter]postNotificationName:@"pop" object:nil];

}

-(void)loadData{
    HttpDownLoad*http=[[HttpDownLoad alloc]initWithURLStr:[NSString stringWithFormat:TOP,1] Post:YES DataDic:nil Block:^(HttpDownLoad *xx, BOOL isSuccess) {
        if (isSuccess) {
            self.dataArray=[NSMutableArray arrayWithArray:xx.dataArray];
            [_tableView reloadData];
        }
    }];
    http=nil;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
//    if (cell==nil) {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
//    }
    
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"TopViewController" owner:nil options:nil]lastObject];
    
        //把当前viewController指针传递进入cell中
        cell.vc=self;
    }
    
    //读取数据
    NSDictionary*dic=self.dataArray[indexPath.row];
//    cell.textLabel.text=dic[@"title"];
    [cell configDic:dic];
  
    
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 260;
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
