//
//  RootViewController.m
//  LimitFreeProject
//
//  Created by zhangcheng on 16/2/16.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

/*
 代理
 1.定制协议
 2.遵循协议的指针
 3.调用指针
 4.遵循协议
 5.设置代理
 6.实现方法
 
 block
 1.声明block指针
 2.调用block指针
 3.实现block指针
 
 
 
 */


#import "LFRootViewController.h"
#import "AppModel.h"
#import "CategroyViewController.h"
#import "AppCell.h"
#import "ZCiFLYTEK.h"
#import "SearchViewController.h"
#import "DetailViewController.h"
//负责放大图片
#import "UIImage+Scale.h"
#import "LFSettingViewController.h"
@interface LFRootViewController ()<categroyDelegate,UISearchBarDelegate>
{
    int page;
}
@end

@implementation LFRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
//    page=1;
    [self createNav];
    [self createTableView];
    
//    [self loadData];
    [header beginRefreshing];
    // Do any additional setup after loading the view.
}
-(void)createNav{
    //导航背景图
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navigationbar"] scaleToSize:CGSizeMake(WIDTH, 44)] forBarMetrics:UIBarMetricsDefault];
    //导航文字大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor purpleColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    
    //左导航按钮
    UIButton*leftButton=[LFZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) Target:self Method:@selector(leftBarButtonItemClick1) Title:@"主页" ImageName:nil BgImageName:@"buttonbar_action"];
    //左导航按钮
    UIButton*leftButton1=[LFZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) Target:self Method:@selector(leftBarButtonItemClick) Title:@"分类" ImageName:nil BgImageName:@"buttonbar_action"];
   
    self.navigationItem.leftBarButtonItems=@[[[UIBarButtonItem alloc]initWithCustomView:leftButton],[[UIBarButtonItem alloc]initWithCustomView:leftButton1]];
    
    //右导航按钮
    UIButton*rightButton=[LFZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) Target:self Method:@selector(rightBarButtonItemClick) Title:@"设置" ImageName:nil BgImageName:@"buttonbar_action"];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];

}
#pragma mark 左导航按钮
-(void)leftBarButtonItemClick1{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pop" object:nil];
}
-(void)leftBarButtonItemClick{
   
    
    CategroyViewController*vc=[[CategroyViewController alloc]init];
    //设置代理
    vc.delegate=self;
    //实现block
    vc.myBlock=^(NSString*cateID){
        NSLog(@"root中接受的数据~~%@~~%@",cateID,self.urlStr);
        
        //每次拼接前,先进行切割
        self.urlStr=[[self.urlStr componentsSeparatedByString:@"&cate_id="]firstObject];
        if (![cateID isEqualToString:@"0"]) {
            self.urlStr=[NSString stringWithFormat:@"%@&cate_id=%@",self.urlStr,cateID];
        }

        NSLog(@"%@",self.urlStr);
        
        //开始刷新
        //需要回归主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [header beginRefreshing];

        });
        
        
    };
    
    
    vc.title=@"分类";
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 实现代理方法
-(void)categroyIDToRootViewController:(NSString *)cateID
{
    NSLog(@"代理接收的数据~~%@",cateID);
}

#pragma mark 右导航按钮
-(void)rightBarButtonItemClick{
    LFSettingViewController*vc=[[LFSettingViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)loadData{
    HttpDownLoad*http=[[HttpDownLoad alloc]initWithURLStr:[NSString stringWithFormat:self.urlStr,page] Post:NO DataDic:nil Block:^(HttpDownLoad *xx, BOOL isSuccess) {
       
        //进行数据处理 字典转模型
        [self dataDicToModel:xx.dataDic];
        
    }];
    http=nil;

}
-(void)createTableView{
   
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    
    //下拉和上拉
    __weak LFRootViewController*vc=self;
    header=[MJRefreshHeaderView header];
    header.scrollView=_tableView;
    header.beginRefreshingBlock=^(MJRefreshBaseView*xx){
        page=1;
        [vc loadData];
    };
    
    footer=[MJRefreshFooterView footer];
    footer.scrollView=_tableView;
    footer.beginRefreshingBlock=^(MJRefreshBaseView*xx){
        page+=1;
        [vc loadData];
    
    };

    
    //添加搜索框
    UISearchBar*search=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    
    search.placeholder=@"输入搜索内容";
    search.showsCancelButton=YES;
    search.showsBookmarkButton=YES;
    [search setImage:[UIImage imageNamed:@"composedingwei"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    search.delegate=self;
    _tableView.tableHeaderView=search;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        
        cell=[[[NSBundle mainBundle]loadNibNamed:@"AppCell" owner:nil options:nil]lastObject];
        
    }
    AppModel*model=self.dataArray[indexPath.row];
    
    [cell configModel:model];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
-(void)dataDicToModel:(NSDictionary*)dic{
    //首先我需要判断这个是来源于谁
    if (page==1) {
        //下拉刷新
        self.dataArray=[NSMutableArray array];
    }else{
        //上拉加载 不进行处理保留元数据
        
    }
    
    //处理数据源
    NSArray*array=dic[@"applications"];
    //遍历数据源
    for (NSDictionary*dic in array) {
        
        AppModel*model=[[AppModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [self.dataArray addObject:model];
        
    }
    [_tableView reloadData];
    //结束上下拉刷新
    [header endRefreshing];
    [footer endRefreshing];
    
    


}
-(void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    //识别带UI界面的
    ZCiFLYTEK*xunfei=[ZCiFLYTEK shareManager];
    [xunfei discernShowView:self.view Block:^(NSString *xx) {
        NSLog(@"识别结果~~~%@",xx);
        
        if (xx) {
            searchBar.text=xx;
        }
    }];

}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    NSLog(@"%@",searchBar.text);
    [searchBar resignFirstResponder];

    //切割字符串
    NSString*newStr=[[self.urlStr componentsSeparatedByString:@"&cate_id"]firstObject];
    SearchViewController*vc=[[SearchViewController alloc]init];
    vc.title=searchBar.text;
    vc.urlStr=[NSString stringWithFormat:@"%@&search=%@",newStr,searchBar.text];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
    

}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=nil;
    
    [searchBar resignFirstResponder];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    DetailViewController*vc=[[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    
    //读取模型
    AppModel*model=self.dataArray[indexPath.row];
    
    vc.appID=model.applicationId;
    
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];


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
