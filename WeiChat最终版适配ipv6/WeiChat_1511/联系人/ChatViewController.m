//
//  ChatViewController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/11.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "ChatViewController.h"
//输入框
#import "ZCMessageToolBar.h"
#import "MessageCell.h"
#import "MyVcardViewController.h"
#import "MainSliderViewController.h"
@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    UITableView*_tableView;
    
    ZCMessageToolBar*_toolBar;
}
@property(nonatomic,strong)UIImage*leftImage;

@property(nonatomic,strong)UIImage*rightImage;

@property(nonatomic,strong)NSMutableArray*dataArray;
@end

@implementation ChatViewController
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
-(void)dealloc{
    [_toolBar removeObserver:self forKeyPath:@"frame"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:CHATBGNAME object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:BUBBLE object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:THEME object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:_tableView name:FONT object:nil];

    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createTableView];
    
    //记录当前我和谁聊天了,所有消息回调,全部从block中读取
    [manager valuationChatPersonName:self.friendJid IsPush:YES MessageBlock:^(ZCMessageObject *xx) {
        //在这里ZCMessageObject参数无用
        [self loadData];
    }];
    
    //读取数据源
    [self loadData];
    
    //创建输入框
    [self createFaceToolBar];
    
    //返回按钮
    [self createLeftNav];
    //导航右按钮
    [self createRightNav];
    //获取Vcard信息
    [self getVcardMessage];
    //添加背景图片
    [self createBgView];
    //添加手势
    [self addTap];

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
-(void)createBgView{
    //设置背景色
    NSString*chatBgName=[[NSUserDefaults standardUserDefaults] objectForKey:CHATBGNAME];
    if (chatBgName) {
        imageView.image=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@.png",LIBPATH,chatBgName]];
    }

}
-(void)createRightNav{
//header_icon_single@2x.png
    
    UIButton*rightButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 30, 20) ImageName:nil Target:self Action:@selector(rightClick) Title:nil];
    [rightButton setImage:[self imageNameStringToImage:@"header_icon_single.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
}
-(void)rightClick{
    MyVcardViewController*vc=[[MyVcardViewController alloc]initWithBlock:^{
        NSLog(@"用户是否进行修改,但是我们的查看朋友的界面,是不许修改的,所以该block在这里无需使用");
    }];
    vc.friendJid=_friendJid;
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)getVcardMessage{
//获得对方Vcard信息
    self.title=[[self.friendJid componentsSeparatedByString:@"@"]firstObject];
    [manager friendsVcard:self.friendJid Block:^(BOOL isOK, XMPPvCardTemp *friendVcard) {
        if (friendVcard.nickname) {
            self.title=UNCODE(friendVcard.nickname);
        }
        //获取头像
        if (friendVcard.photo) {
            UIImage*leftImage=[UIImage imageWithData:friendVcard.photo];
            _leftImage=leftImage;
            [_tableView reloadData];
            if (self.dataArray.count) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            
        }
        
        
    }];
    
//获取自己的Vcard信息
    
    [manager getMyVcardBlock:^(BOOL isOK, XMPPvCardTemp *myVcard) {
        if (myVcard.photo) {
            UIImage*right=[UIImage imageWithData:myVcard.photo];
            _rightImage=right;
            [_tableView reloadData];
            if (self.dataArray.count) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }

        }
    }];

}
-(void)createLeftNav{
self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[self imageNameStringToImage:@"header_leftbtn_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];

}
-(void)backClick{
    //取消当前联系人
    [manager valuationChatPersonName:NONE IsPush:NO MessageBlock:nil];
    //删除kvo
    [_toolBar removeObserver:self forKeyPath:@"frame"];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)createFaceToolBar{
    //新版的xmpp对发送消息做了一些修正,解决了第一次发送消息,数据读取不及时的问题,以前解决办法是要求开发者读取数据延迟0.1秒读取,现在ZCXMPPManager已经内部解决这个问题,通过进去该聊天界面的回调来完成
    
    
    _toolBar=[[ZCMessageToolBar alloc]initWithBlock:^(NSString *sign, NSString *message) {
        [manager sendMessageWithJID:_friendJid Message:message Type:sign];
    }];
    
    [self.view addSubview:_toolBar];
    
    //使用观察者模式
    [_toolBar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    

}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    _tableView.frame=CGRectMake(0, 64, WIDTH, _toolBar.frame.origin.y-64);
    //数据偏移
    if (self.dataArray.count) {
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    

}

-(void)loadData{
    //读取聊天记录
    NSArray*messageArray=[manager messageRecord];
    
    self.dataArray=[NSMutableArray arrayWithArray:messageArray];
    
   
    //移动tableView
    if (self.dataArray.count) {
        //刷新数据
        [_tableView reloadData];
        //移动表格偏移
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
    
    
}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-45) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
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
    //读取数据源
    XMPPMessageArchiving_Message_CoreDataObject*object=self.dataArray[indexPath.row];
    
    [cell configWithXMPP_Model:object leftImage:_leftImage rightImage:_rightImage];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //读取模型
    XMPPMessageArchiving_Message_CoreDataObject*object=self.dataArray[indexPath.row];
    return [MessageCell contentStrToHeight:object.message.body];
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
