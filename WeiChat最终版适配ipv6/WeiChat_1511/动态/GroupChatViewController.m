//
//  GroupChatViewController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/17.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "GroupChatViewController.h"
#import "MessageModel.h"
#import "ZCMessageToolBar.h"
#import "MessageCell.h"
#import "GroupDetailViewController.h"
#import "MainSliderViewController.h"
@interface GroupChatViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UITableView*_tableView;
    ZCMessageToolBar*_toolBar;
}
@property(nonatomic,strong)NSMutableArray*dataArray;
@end

@implementation GroupChatViewController
-(void)dealloc
{
    [_toolBar removeObserver:self forKeyPath:@"frame"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:CHATBGNAME object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BUBBLE object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:THEME object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:_tableView name:FONT object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    
    [MainSliderViewController sharedSliderController].panGestureRec.delegate=self;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MainSliderViewController sharedSliderController].panGestureRec.delegate=nil;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch

{

    return NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLeftNav];
    [self createTableView];
    [self createToolBar];
    [self loadData];
    [self createBgView];
    [self rightNav];
    [self addTap];
    //获取群配置信息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createBgView) name:CHATBGNAME object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:_tableView selector:@selector(reloadData) name:FONT object:nil];

    // Do any additional setup after loading the view.
}
-(void)addTap{
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [_tableView addGestureRecognizer:tap];
    
}
-(void)tapClick{
    [_toolBar hideKeyBorard];

}
-(void)rightNav{
    rightNavButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 40, 40) ImageName:nil Target:self Action:@selector(rightNavButtonClick) Title:nil];
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:rightNavButton];
    
    UIImage*image1=[self imageNameStringToImage:@"header_icon_group.png"];
    [rightNavButton setImage:image1 forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=item;
    
    
}
-(void)rightNavButtonClick{
        GroupDetailViewController*vc=[[GroupDetailViewController alloc]init];
        vc.room=room;
        vc.groupNum=_roomJid;
        vc.roomConfigDic=self.roomConifgDic;
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
        
}
-(void)createBgView{
    //设置背景色
    NSString*chatBgName=[[NSUserDefaults standardUserDefaults] objectForKey:CHATBGNAME];
    if (chatBgName) {
        imageView.image=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@.png",LIBPATH,chatBgName]];
    }
    
}
-(void)createToolBar{
    _toolBar=[[ZCMessageToolBar alloc]initWithBlock:^(NSString *sign, NSString *message) {
        [manager sendGroupMessage:[NSString stringWithFormat:@"%@%@",sign,message] roomName:_roomJid];
        
    }];
    [self.view addSubview:_toolBar];
    
    //添加观察者
    [_toolBar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];

}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    _tableView.frame=CGRectMake(0, 64, WIDTH, _toolBar.frame.origin.y-64);
    if (self.dataArray.count) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)createLeftNav{
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[self imageNameStringToImage:@"header_leftbtn_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftNavClick)];
}
-(void)leftNavClick{
    //退出房间
    [manager XmppOutRoom:room];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)loadData{
    /*
     进入房间分为如果房间存在则进入房间,如果不存在就进行创建
     创建分为2种方式,一种是创建临时房间,一种是创建永久房间
     临时房间为最后一个人退出,就解散房间,永久房间则不解散
     昵称要求唯一,如果2个人昵称一样,则肯定有一个人进不去
     */

   room= [manager xmppRoomCreateRoomName:self.roomJid nickName:[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID] MessageBlock:^(NSDictionary *message) {
        //进入房间后给出50条消息
       
       MessageModel*model=[[MessageModel alloc]init];
       [model setValuesForKeysWithDictionary:message];
        
        if (self.dataArray==nil) {
            self.dataArray=[NSMutableArray array];
        }
        [self.dataArray addObject:model];
        [_tableView reloadData];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        
        
    } configBlock:^(NSDictionary *config) {
        //预留接口
        //进入成功，获取房间主题和描述
        NSLog(@"%@",config);
        self.title=config[@"name"];
        self.roomConifgDic=config;
    }];
    

}

-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-45) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    
    MessageModel*model=self.dataArray[indexPath.row];
    
    [cell configWithCustomModel:model leftImage:nil rightImage:nil];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel*model=self.dataArray[indexPath.row];
    
    return [MessageCell contentStrToHeight:model.body];
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
