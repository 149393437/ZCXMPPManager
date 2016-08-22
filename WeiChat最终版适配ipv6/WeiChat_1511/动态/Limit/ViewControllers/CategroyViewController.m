//
//  CategroyViewController.m
//  LimitFreeProject
//
//  Created by zhangcheng on 16/2/16.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "CategroyViewController.h"
#import "CategroyModel.h"
@interface CategroyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_tableView;
}
@property(nonatomic,strong)NSMutableArray*dataArray;
@end

@implementation CategroyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createTableView];
    
    [self loadData];
    
    // Do any additional setup after loading the view.
}
-(void)loadData{
    HttpDownLoad*http=[[HttpDownLoad alloc]initWithURLStr:CATEGROY Post:NO DataDic:nil Block:^(HttpDownLoad *xx, BOOL isSuccess) {
        
        if (isSuccess) {
            self.dataArray=[NSMutableArray array];
            
            for (NSDictionary*dic in xx.dataArray) {
                CategroyModel*model=[[CategroyModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            
            [_tableView reloadData];
            
        }
        
        
    }];
    http=nil;
}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
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
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
    }
    //读取模型
    CategroyModel*model=self.dataArray[indexPath.row];
    
    cell.textLabel.text=model.categoryCname;
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"限免%@款  免费%@款  下载%@款",model.limited,model.free,model.down];
    
    cell.detailTextLabel.font=[UIFont systemFontOfSize:10];
    cell.detailTextLabel.textColor=[UIColor grayColor];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"account_candou"]];
    
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    //读取模型
    CategroyModel*model=self.dataArray[indexPath.row];
    
    NSLog(@"%@",model.categoryId);
    
    //调用block
    if (self.myBlock) {
        self.myBlock(model.categoryId);
    }
    
    //判断代理是否实现了方法
    if ([_delegate respondsToSelector:@selector(categroyIDToRootViewController:)]) {
        //调用
        [_delegate categroyIDToRootViewController:model.categoryId];
    }
    [self.navigationController popViewControllerAnimated:YES];

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
