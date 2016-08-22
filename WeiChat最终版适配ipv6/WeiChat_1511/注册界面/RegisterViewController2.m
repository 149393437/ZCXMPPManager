//
//  RegisterViewController2.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/7.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "RegisterViewController2.h"
#import "RegisterViewController3.h"
#import "RegisterManager.h"
@interface RegisterViewController2 ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    //日期选择器
    UIDatePicker*_datePicker;
    
    RegisterManager*manager;
}
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

@end

@implementation RegisterViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置导航
    [self  createNav];
    
    manager=[RegisterManager shareManager];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)tapClick{

    
}
-(void)createNav{
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"logo_bg_2"]];

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"下一页" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick)];
    
    self.title=@"个人资料(2/4)";
    
    //设置返回按钮
    UIButton*back=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:@"header_leftbtn_black_nor.png" Target:self Action:@selector(backButtonClick) Title:@"返回"];
    
    //设置文字黑色
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:back];
    


}
#pragma mark 右按钮
-(void)rightBarButtonItemClick{
    
    RegisterViewController3*vc=[[RegisterViewController3  alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark 左按钮
-(void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma 选择相册
- (IBAction)photoButtonClick:(id)sender {
    //弹出选择相机相册
    UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    sheet.tag=101;
    [sheet showInView:self.view];
}
#pragma 选择生日
- (IBAction)birthdayClick:(id)sender {
    if (_datePicker==nil) {
        //进行创建
        _datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 216)];
        //设置最大时间
        _datePicker.maximumDate=[NSDate date];
        //设置最小时间
        //时间的格式化
        NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate*date= [formatter dateFromString:@"1970-1-1"];
        _datePicker.minimumDate=date;
        //设置datePicker显示格式
        _datePicker.datePickerMode=UIDatePickerModeDate;
        [self.view addSubview:_datePicker];
        //添加事件
        [_datePicker addTarget:self action:@selector(dateClick) forControlEvents:UIControlEventValueChanged];
    }
    [UIView animateWithDuration:0.3 animations:^{
        
        _datePicker.frame=CGRectMake(0, HEIGHT-216, WIDTH, 216);
        
    }];
    
    
    
}
#pragma mark 选择日期
-(void)dateClick{
    //获取日期
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //日期转换为字符串
    NSString*timeStr=[formatter stringFromDate:_datePicker.date];
    _birthdayLabel.text=timeStr;
    
    manager.birthday=_birthdayLabel.text;
    
    
}

#pragma 选择性别
- (IBAction)sexClick:(id)sender {
    UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男♂",@"女♀", nil];
    sheet.tag=102;
    [sheet showInView:self.view];
    
}

#pragma mark 代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==2) {
        return;
    }
    if (actionSheet.tag==101) {
        //初始化
        UIImagePickerController*picker=[[UIImagePickerController alloc]init];
        //判断选择
        if (!buttonIndex) {
            //判断相机是否可用
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                
                picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            }
            
        }
        //设置代理
        picker.delegate=self;
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        //选择男女
        if (buttonIndex) {
            _sexImageView.image=[UIImage imageNamed:@"icon_register_woman"];
            _sexLabel.text=@"女♀";
        }else{
            _sexImageView.image=[UIImage imageNamed:@"icon_register_man"];
            _sexLabel.text=@"男♂";
        }
        manager.sex=_sexLabel.text;
    
    
    }
    

}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //读取图片
    UIImage*image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    manager.headerImage=image;
    
    //对button进行赋值
    UIButton*button=(UIButton*)[self.view viewWithTag:200];
    //对button进行圆角处理
    button.layer.cornerRadius=5;
    button.layer.masksToBounds=YES;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    [self dismissViewControllerAnimated:YES completion:nil];
}
//把日期收回去
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_datePicker&&_datePicker.frame.origin.y<HEIGHT) {
        [UIView animateWithDuration:0.3 animations:^{
            _datePicker.frame=CGRectMake(0, HEIGHT, WIDTH, 216);
        }];
    }
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
