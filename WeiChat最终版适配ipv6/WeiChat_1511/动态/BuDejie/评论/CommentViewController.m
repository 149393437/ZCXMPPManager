//
//  CommentViewController.m
//  BuDeJie_1511
//
//  Created by zhangcheng on 16/2/2.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentModel.h"
#import "CommentCell.h"
#import "ZCMessageToolBar.h"
@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_tableView;
    //上拉加载
    MJRefreshFooterView*footer;
    
    UIView*bgTextFieldView;
    ZCMessageToolBar*_toolBar;

}
@property(nonatomic,strong)NSMutableArray*dataArray;

//最后一个id值
@property(nonatomic,copy)NSString*lastcid;
@end

@implementation CommentViewController
-(void)dealloc{
    [_toolBar removeObserver:self forKeyPath:@"frame"];
    [footer free];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=COLOR;
    [self createTableView];
    [self loadData];
//    [self createTextField];
    [self createTextField1];
    // Do any additional setup after loading the view.
}
-(void)createTextField1{
    _toolBar=[[ZCMessageToolBar alloc]initWithBlock:^(NSString *sign, NSString *message) {
        
    }];
    [self.view addSubview:_toolBar];
    //添加观察着
    [_toolBar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    _tableView.frame=CGRectMake(0, 0, WIDTH, _toolBar.frame.origin.y);
    if (self.dataArray.count) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
-(void)voiceClick{

}
-(void)createTextField{
    bgTextFieldView=[LFZCControl createViewWithFrame:CGRectMake(0, HEIGHT-44, WIDTH, 44)];
    bgTextFieldView.backgroundColor=[UIColor grayColor];
    UIButton*voice=[LFZCControl createButtonWithFrame:CGRectMake(0, 0, 44, 44) Target:self Method:@selector(voiceClick) Title:nil ImageName:@"play-voice-icon-2.png" BgImageName:nil];
    [bgTextFieldView addSubview:voice];
    
    //输入框
    UITextField*text=[[UITextField alloc]initWithFrame:CGRectMake(44, 0, WIDTH-88, 44)];
    UIImage*image=[UIImage imageNamed:@"post-tag-bg.png"];
    //image进行图像拉伸
    image=[image stretchableImageWithLeftCapWidth:20 topCapHeight:10];
    
    text.background=image;
    
    text.placeholder=@"请输入评论";
    
    text.tag=100;
    
    [bgTextFieldView addSubview:text];
    
    UIButton*aite=[LFZCControl createButtonWithFrame:CGRectMake(WIDTH-44, 0, 44, 44) Target:self Method:@selector(aiteClick) Title:nil ImageName:@"post-@.png" BgImageName:nil];
    [bgTextFieldView addSubview:aite];
    
    
    [self.view addSubview:bgTextFieldView];
    
    //观察键盘弹出和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];

}
-(void)keyboardShow:(NSNotification*)not{
//计算键盘高度
    CGFloat height=[[not.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height;
    
    //进行移动
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame=CGRectMake(0, 0, WIDTH, HEIGHT-44-height);
        bgTextFieldView.frame=CGRectMake(0, HEIGHT-height-44, WIDTH, 44);
        
        
    }];
    
    //移动到最后
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[self.dataArray lastObject] count]-1 inSection:self.dataArray.count-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
    
}
-(void)keyboardHide:(NSNotification*)not{
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame=CGRectMake(0, 0, WIDTH, HEIGHT-44);
        bgTextFieldView.frame=CGRectMake(0, HEIGHT-44, WIDTH, 44);
        
        
    }];
}


-(void)aiteClick{

}
-(void)loadData{
    //组装参数
    NSDictionary*dic=nil;
  
    if (_lastcid==nil) {
        dic=@{@"a":@"dataList",@"c":@"comment",@"data_id":_model.id,@"hot":@"1"};
    }else{
        //上拉加载
        dic=@{@"a":@"dataList",@"c":@"comment",@"data_id":_model.id,@"hot":@"1",@"lastcid":_lastcid};
        
    }
 
    
    HttpDownLoad*http=[[HttpDownLoad alloc]initWithURLStr:API Post:NO DataDic:dic Block:^(HttpDownLoad *xx, BOOL isSuccess) {
        
        
        if (isSuccess) {
            
            //进行数据解析
            
            //需要判断是开始数据请求,还是上拉加载
            if (_lastcid==nil) {
    
            //热门评论
            NSArray*hotArray=xx.dataDic[@"hot"];
            
            [self createDataToModel:hotArray];

            ///评论数据
            NSArray*array1=xx.dataDic[@"data"];
            
            [self createDataToModel:array1];
            
            [_tableView  reloadData];
            
            }else{
            //进行对应数据追加
                NSMutableArray*array=[NSMutableArray arrayWithArray:[self.dataArray lastObject]];
                
                NSLog(@"%ld",[xx.dataDic[@"data"] count]);
                for (NSDictionary*dic in xx.dataDic[@"data"]) {
                    CommentModel*model=[[CommentModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    
                    [array addObject:model];
                }
                //修改元数据
                [self.dataArray removeLastObject];
                [self.dataArray addObject:array];
                
                [_tableView reloadData];
                [footer endRefreshing];

                
                
            }
            
        //读取最后一个id值用于上拉加载使用
            
            if ([xx.dataDic[@"data"] count]) {
          _lastcid=  [xx.dataDic[@"data"] lastObject][@"data_id"];
            }
          
            
            
            
        }
    }];
    http=nil;

}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-44) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    //添加上拉加载
    footer=[MJRefreshFooterView footer];
    
    footer.scrollView=_tableView;
    
   __weak CommentViewController*vc=self;
    
    footer.beginRefreshingBlock=^(MJRefreshBaseView*xx){
    //开始上拉加载
        [vc loadData];
        
        
    };
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    //读取模型
    CommentModel*model=self.dataArray[indexPath.section][indexPath.row];
    
//    cell.textLabel.text=model.content;
    [cell config:model];
    
    
    return cell;
    
}
-(void)createDataToModel:(NSArray*)array{

    if (self.dataArray==nil) {
        self.dataArray=[NSMutableArray array];
    }
    
    NSMutableArray*tempArray=[NSMutableArray array];
    for (NSDictionary*dic1 in array) {
        CommentModel*model=[[CommentModel alloc]init];
        [model setValuesForKeysWithDictionary:dic1];
        [tempArray addObject:model];
    }
    
    //把模型加入到大数组内
    [self.dataArray addObject:tempArray];

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
