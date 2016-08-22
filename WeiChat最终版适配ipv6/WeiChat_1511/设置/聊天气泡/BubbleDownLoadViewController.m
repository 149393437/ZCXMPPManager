//
//  BubbleDownLoadViewController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/4/1.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "BubbleDownLoadViewController.h"
#import "ThemeManager.h"
#import "BubbleDownLoadCell.h"
@interface BubbleDownLoadViewController ()
{
}
@property(nonatomic,strong)NSMutableArray*dataArray;

@end

@implementation BubbleDownLoadViewController
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:_tableView name:BUBBLE object:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"气泡背景";
    [self createTableView];
    
    [self loadData];
    
    
    //收到气泡下载完的通知,刷新tableView
    [[NSNotificationCenter defaultCenter]addObserver:_tableView selector:@selector(reloadData) name:BUBBLE object:nil];
    // Do any additional setup after loading the view.
}
-(void)themeClick
{
    [_tableView setSeparatorColor:[ThemeManager themeColorStrToColor:kTableViewSeparatorColor]];
    
}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
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
    BubbleDownLoadCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[BubbleDownLoadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    //每次需要读取3个数据源
    [cell configWithArray:self.dataArray[indexPath.row]];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(void)loadData{

    HttpDownLoad*http=[[HttpDownLoad alloc]initWithURLStr:@"http://i.gtimg.cn/qqshow/admindata/comdata/vipList_bubble_data/xydata.all.v2.js" Post:NO DataDic:nil Block:^(HttpDownLoad *xx, BOOL isOk) {
        if (isOk) {
            //data进行转换
            NSString*str=[[NSString alloc]initWithData:xx.data encoding:NSUTF8StringEncoding];
            //查找{
            NSRange range=[str rangeOfString:@"{"];
            //进行截取
            NSString*newStr=[str substringWithRange:NSMakeRange(range.location,str.length-range.location)];
            
            //进行数据解析
            NSDictionary*dic=[NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            NSDictionary*dic1=dic[@"detailList"];
            
            NSArray*array=[dic1 allValues];
            
            NSMutableArray*tempArray=[NSMutableArray array];
            
            self.dataArray=[NSMutableArray array];
            
            //损坏的主题编号
//            NSArray*failArray=[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FailThemeList" ofType:@"plist"]]allKeys];
            
            for (int i=0; i<array.count; i++) {
                //如果数量为3时候,小数组追加到大数组中,如果不等3,就继续在小数组中保存
                if (tempArray.count==2) {
                    [self.dataArray addObject:tempArray];
                    tempArray=[NSMutableArray array];
                }
                //在接口中屏蔽损坏的主题
//                NSString*idStr= array[i][@"baseInfo"][@"id"];
//                if (![failArray containsObject:idStr]) {
//                    [tempArray addObject:array[i]];
//                }
                [tempArray addObject:array[i]];
                
            }
            if (tempArray.count) {
                [self.dataArray addObject:tempArray];
            }
            
            [_tableView reloadData];
            
            
            
        }
    }];
    http=nil;
    
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
