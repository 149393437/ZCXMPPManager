//
//  MyVcardViewController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/10.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "MyVcardViewController.h"
//用于生成二维码
#import "QRCodeGenerator.h"
#import "ThemeManager.h"
@interface MyVcardViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    UITableView*_tableView;
    
    UIAlertView*_alertView;
    
    UIActionSheet*_sheet;
    
    //记录是否修改了
    BOOL isSave;
}
@property (nonatomic)XMPPvCardTemp*myVcard;
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,strong)NSArray*titleArray;
@end

@implementation MyVcardViewController
-(instancetype)initWithBlock:(void(^)())a
{
    if (self=[super init]) {
        self.myBlock=a;
    }
    return self;
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
    if (self.friendJid) {
        self.title=@"好友资料";
    }else{
        self.title=@"我的资料";
    }
    [self createTableView];
    
    [self loadVcard];
    
    // Do any additional setup after loading the view.
}

-(void)backClick{
    if (isSave) {
        [manager upData:_myVcard];
        
        if (self.myBlock) {
            //调用block进行响应
            self.myBlock();
        }
        
    }
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)loadVcard{
    if (_friendJid) {
        //读取朋友个人名片信息
        //别人有可能传递13321@feiqueit.com 也有可能传递13321,我们内部进行处理了
        [manager friendsVcard:_friendJid Block:^(BOOL isOK, XMPPvCardTemp *frinend) {
            _myVcard=frinend;
            [self loadData];
        }];
        
    }else{
        //读取自己的名片信息
        [manager getMyVcardBlock:^(BOOL isOK, XMPPvCardTemp *myVcard) {
            _myVcard=myVcard;
            [self loadData];
        }];
    
    }

}
-(void)loadData{
//建立2个数组
    _titleArray=@[@"头像",@"昵称",@"签名",@"性别",@"地区",@"二维码",@"手机号"];
    
    _dataArray=[NSMutableArray array];
    UIImage*headerImage;
    if (_myVcard.photo) {
        headerImage=[UIImage imageWithData:_myVcard.photo];
    }else{
        headerImage=[UIImage imageNamed:@"logo_2"];
    }
    
    [_dataArray addObject:headerImage];
    
    NSString*nickName;
    if (_myVcard.nickname) {
        nickName=_myVcard.nickname;
    }else{
        
        nickName=_myVcard.jid.user;
    }
    [_dataArray addObject:UNCODE(nickName)];
    
    NSString*qmd;
    qmd=[[_myVcard elementForName:QMD]stringValue];
    if (qmd==nil) {
        qmd=@"这家伙很懒,没有留下什么";
    }
    [_dataArray addObject:UNCODE(qmd)];
    
    NSString*sex;
    sex=[[_myVcard elementForName:SEX]stringValue];
    if (sex==nil) {
        sex=@"无";
    }
    [_dataArray addObject:UNCODE(sex)];
    
    NSString*address;
    address=[[_myVcard elementForName:ADDRESS]stringValue];
    if (address==nil) {
        address=@"暂无地区";
    }
    [_dataArray addObject:UNCODE(address)];
    
    //生成二维码 300数值越大越清晰
    UIImage*qrImage=[QRCodeGenerator qrImageForString:[[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID] imageSize:300];
    
    [_dataArray addObject:qrImage];
    
    //手机号
    NSString*phoneNum=[[_myVcard elementForName:PHONENUM]stringValue];
    if (phoneNum==nil) {
        phoneNum=@"暂无设置";
    }
    [_dataArray addObject:UNCODE(phoneNum)];
    UILabel*userName=[ZCControl createLabelWithFrame:CGRectMake(0, 0, WIDTH, 20) Font:10 Text:nil];
    userName.textAlignment=NSTextAlignmentCenter;
    userName.textColor=[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal];
    if (_friendJid) {
        
        userName.text=[NSString stringWithFormat:@"您的数字账号为:%@",[[_friendJid componentsSeparatedByString:@"@"]firstObject]];
    }else{
        userName.text=[NSString stringWithFormat:@"您的数字账号为:%@",[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID]];

    }
  
  
    _tableView.tableHeaderView=userName;

    //刷新UI
    [_tableView reloadData];
    
}
-(void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
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
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ID"];
        UIImageView*imageView1=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-70, 0, 44, 44) ImageName:@"logo_2"];
        imageView1.layer.cornerRadius=22;
        imageView1.layer.masksToBounds=YES;
        imageView1.tag=300;
        [cell.contentView addSubview:imageView1];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.textColor=[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal];

    UIImageView*imageView2=[cell.contentView viewWithTag:300];
    
    cell.textLabel.text=self.titleArray[indexPath.row];
    
    id result=self.dataArray[indexPath.row];
    
    //判断类型
    if ([result isKindOfClass:[UIImage class]]) {
        imageView2.hidden=NO;
        imageView2.image=result;
        cell.detailTextLabel.text=nil;
    }else{
        imageView2.hidden=YES;
        cell.detailTextLabel.text=result;
    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (_friendJid) {
        return;
    }
    switch (indexPath.row) {
        case 0:
            //头像
        {
            UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
            sheet.tag=123;
            [sheet showInView:self.view];
        }
            break;
        case 1:
            //昵称
            [self showAlertViewMessage:@"设置昵称" Tag:101];
            break;
        case 2:
            //签名
            [self showAlertViewMessage:@"设置签名" Tag:102];
            break;
        case 4:
            //地区
            [self showAlertViewMessage:@"设置地区" Tag:104];
            break;
        case 6:
            //手机号
            [self showAlertViewMessage:@"设置手机号" Tag:106];
            break;
        default:
            break;
    }

}
//封装警告框
-(void)showAlertViewMessage:(NSString*)message Tag:(NSInteger)tag
{
    _alertView=[[UIAlertView alloc]initWithTitle:message message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    _alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
    _alertView.tag=tag;
    [_alertView show];


}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        return;
    }
    
    UITextField*_textField=[alertView textFieldAtIndex:0];
    
    switch (alertView.tag) {
        case 101:
            //昵称
            _myVcard.nickname=CODE(_textField.text);
            break;
        case 102:
            //签名
            [manager customVcardXML:CODE(_textField.text) name:QMD myVcard:_myVcard];
            break;
            
        case 104:
            //地区
            [manager customVcardXML:CODE(_textField.text) name:ADDRESS myVcard:_myVcard];
            break;
            
        case 106:
            //手机号
            [manager customVcardXML:CODE(_textField.text) name:PHONENUM myVcard:_myVcard];
            break;
        default:
            break;
    }
    
    //重新读取一次数据
    [self loadData];
    
    //修改过
    isSave=YES;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==2) {
        return;
    }
    UIImagePickerController*pick=[[UIImagePickerController alloc]init];
    
    pick.delegate=self;
    
    if (!buttonIndex) {
        //相机
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            pick.sourceType=UIImagePickerControllerSourceTypeCamera;
        }
    }
    [self presentViewController:pick animated:YES completion:nil];
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage*image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    _myVcard.photo=UIImageJPEGRepresentation(image, 0.1);
    [self loadData];
    
    isSave=YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
