//
//  ThemeViewController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/9.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "ThemeViewController.h"
#import "HttpDownLoad.h"
#import "ThemeCell.h"
#import "ThemeManager.h"
@interface ThemeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
}
@end

@implementation ThemeViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:_tableView name:THEME object:nil];

}
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"个性装扮";
    
    [self createTableView];
    
    [self loadData];
    //收到主题下载完的通知,刷新tableView
    [[NSNotificationCenter defaultCenter]addObserver:_tableView selector:@selector(reloadData) name:THEME object:nil];

    // Do any additional setup after loading the view.
}

-(void)themeClick
{
    [_tableView setSeparatorColor:[ThemeManager themeColorStrToColor:kTableViewSeparatorColor]];

    [_tableView reloadData];
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
    ThemeCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[ThemeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    //每次需要读取3个数据源

    [cell configWithArray:self.dataArray[indexPath.row]];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
-(void)loadData{

 
    
    HttpDownLoad*http=[[HttpDownLoad alloc]initWithURLStr:@"http://i.gtimg.cn/qqshow/admindata/comdata/vipList_theme_new/xydata.all.v2.js" Post:NO DataDic:nil Block:^(HttpDownLoad *xx, BOOL isOk) {
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
            NSArray*failArray=[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FailThemeList" ofType:@"plist"]]allKeys];
            
            for (int i=0; i<array.count; i++) {
                //如果数量为3时候,小数组追加到大数组中,如果不等3,就继续在小数组中保存
                if (tempArray.count==3) {
                    [self.dataArray addObject:tempArray];
                    tempArray=[NSMutableArray array];
                }
                //在接口中屏蔽损坏的主题
               NSString*idStr= array[i][@"baseInfo"][@"id"];
                if (![failArray containsObject:idStr]) {
                    [tempArray addObject:array[i]];
                }
                
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
