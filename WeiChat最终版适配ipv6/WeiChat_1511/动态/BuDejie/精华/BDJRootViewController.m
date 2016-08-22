//
//  RootViewController.m
//  BuDeJie_1511
//
//  Created by zhangcheng on 16/1/29.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "BDJRootViewController.h"
#import "AllModel.h"
#import "EssenceCell.h"
#import "CrossViewController.h"
#import "CommentViewController.h"
@interface BDJRootViewController ()
//上拉刷新的关键字
@property(nonatomic)NSNumber *maxtime;
@end

@implementation BDJRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景色,如果不设置背景色,在push时候会卡顿
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    _type=@"1";
    [self createNav];
    [self createTableView];
    
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)createNav{
    UIImageView*titleImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 150, 30) ImageName:@"MainTitle.png"];
    self.navigationItem.titleView=titleImageView;
    
    //左边设置按钮
    UIButton*leftButton=[LFZCControl createButtonWithFrame:CGRectMake(0, 0, 30, 30) Target:self Method:@selector(leftBarButtonItemClick) Title:nil ImageName:@"MainTagSubIcon.png" BgImageName:nil];
    UIButton*leftButton1=[LFZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) Target:self Method:@selector(leftBarButtonItemClick1) Title:@"主页" ImageName:nil BgImageName:nil];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton1];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    

}
-(void)leftBarButtonItemClick1{
    //多媒体停止
    [[VideoPlayControl shareManager]stop];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 穿越
-(void)leftBarButtonItemClick{
    CrossViewController*vc=[[CrossViewController alloc]init];
    vc.dic=@{@"a":@"list",@"order":@"timewarp"};
    
  
    //隐藏tabBar
//    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)loadData{
    
    NSDictionary*dic=nil;
    if (_maxtime) {
        dic=@{@"c":@"data",@"maxtime":_maxtime,@"type":_type};
    }else{
        dic=@{@"c":@"data",@"type":_type};
    }
    
    
    NSMutableDictionary*tempDic=[NSMutableDictionary dictionaryWithDictionary:_dic];
    [tempDic setValuesForKeysWithDictionary:dic];
    
    HttpDownLoad*http=[[HttpDownLoad alloc]initWithURLStr:API Post:NO DataDic:tempDic Block:^(HttpDownLoad *xx, BOOL isSucceed) {
        
        if (isSucceed) {
            //判断是下拉刷新还是上拉加载
            if (_maxtime) {
                //上拉加载.数据追加
                [self.dataArray addObjectsFromArray:[self createArrayToModel:xx.dataDic[@"list"]]];
            }else{
                //数据清空,追加新数据
                self.dataArray=[NSMutableArray arrayWithArray:[self createArrayToModel:xx.dataDic[@"list"]]];
                //对maxtime进行赋值
                _maxtime=xx.dataDic[@"info"][@"maxtime"];
                
            }
            
            [_tableView reloadData];
            
            [header endRefreshing];
            
            [footer endRefreshing];
            
            
            
        }
        
    }];
    http=nil;

}

-(void)createTableView{
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    //去除灰线
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    
    //创建上下拉刷新
    __weak BDJRootViewController*vc=self;
    
    header=[MJRefreshHeaderView header];
    header.beginRefreshingBlock=^(MJRefreshBaseView*xx){
        _maxtime=nil;
        [vc loadData];
    
    };
    header.scrollView=_tableView;
    
    footer=[MJRefreshFooterView footer];
    footer.beginRefreshingBlock=^(MJRefreshBaseView*xx){
        [vc loadData];
    };
    footer.scrollView=_tableView;
    

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EssenceCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[EssenceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        //选中时候的颜色
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
//    //读取数据源
    AllModel*model=self.dataArray[indexPath.row];
//    cell.textLabel.text=model.text;
    [cell config:model];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //计算文字大小
    AllModel*model=self.dataArray[indexPath.row];
    
    float height=[model.text boundingRectWithSize:CGSizeMake(WIDTH-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height;
    
    float width1=WIDTH<[model.width integerValue]?WIDTH:[model.width integerValue];
    float height1=(width1/WIDTH)*[model.height integerValue];
    if (height1>300) {
        height1=300;
    }
    if ([model.type integerValue]==29) {
        height1=20;
    }
    return height+45+height1+60;
    
}
#pragma mark 添加段头
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self createTableViewHeaderView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
//将要消失的
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"将要消失的%ld",indexPath.row);
}
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"已经消失的%ld",indexPath.row);
    EssenceCell*cell1=(EssenceCell*)cell;
    
    if ([cell1 isVideoPlay]) {
        VideoPlayControl*vp=[VideoPlayControl shareManager];
        [vp stop];
    }
    

}

#pragma mark 模型转换
-(NSMutableArray*)createArrayToModel:(NSMutableArray*)array{
    NSMutableArray*tempArray=[NSMutableArray array];
    
    for (NSDictionary*dic in array) {
        AllModel*model=[[AllModel alloc]init];
        
        [model setValuesForKeysWithDictionary:dic];
        
        [tempArray addObject:model];
    }

    return tempArray;

}
-(UIView*)createTableViewHeaderView{
    //navigationbarBackgroundWhite.png
    if (headerBgView) {
        return headerBgView;
    }
    
    headerBgView=[LFZCControl createViewWithFrame:CGRectMake(0, 0,WIDTH, 30)];
    headerBgView.backgroundColor=COLOR;
    
    //红色的view
    UIView*redView=[LFZCControl createViewWithFrame:CGRectMake(0, 29,60, 1)];
    
    redView.backgroundColor=[UIColor redColor];
    
    [headerBgView addSubview:redView];

    //创建5个button
    NSArray*titleArray=@[@"全部",@"视频",@"声音",@"图片",@"段子"];
    
    for (int i=0; i<titleArray.count; i++) {
        UIButton*button=[LFZCControl createButtonWithFrame:CGRectMake(WIDTH/5*i, 0, WIDTH/5, 29) Target:self Method:@selector(headerViewButtonClick:) Title:titleArray[i] ImageName:nil BgImageName:nil];
        if (!i) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        button.tag=200+i;
        [headerBgView addSubview:button];
    }

    //默认的是第一个的位置,我们需要把位置红色的位置进行移动
    redView.frame=CGRectMake(0, 29, WIDTH/5, 1);
    redView.tag=400;
    return headerBgView;

}

-(void)headerViewButtonClick:(UIButton*)button{
    //点击的这个button颜色要变为红色,其他变为灰色
    for (int i=0; i<5; i++) {
        UIButton*temp=[button.superview viewWithTag:200+i];
        [temp setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //移动红色
    UIView*redView=[button.superview viewWithTag:400];
    [UIView animateWithDuration:0.2 animations:^{
        redView.frame=CGRectMake((button.tag-200)*(WIDTH/5), 29, WIDTH/5, 1);
    }];
    
    
    //全部1 图片10  段子29  音频31  视频41  默认1
    switch (button.tag-200) {
        case 0:
            //全部1
            _type=@"1";
            break;
        case 1:
            //视频41
            _type=@"41";
            break;
        case 2:
            //音频31
            _type=@"31";
            break;
        case 3:
            //图片10
            _type=@"10";
            break;
        case 4:
            //段子10
            _type=@"29";
            break;
            
        default:
            break;
    }
    
    //下拉刷新
    [header beginRefreshing];
    
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    
    CommentViewController*vc=[[CommentViewController alloc]init];
    vc.model=self.dataArray[indexPath.row];
    
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
