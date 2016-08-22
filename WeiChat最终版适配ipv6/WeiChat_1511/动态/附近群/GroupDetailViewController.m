//
//  GrouoDetailViewController.m
//  weiChat
//
//  Created by ZhangCheng on 14/7/5.
//  Copyright (c) 2014年 张诚. All rights reserved.
//

#import "GroupDetailViewController.h"
#import "QRCodeGenerator.h"
#import "GroupAddFriendViewController.h"
#import "ThemeManager.h"
@interface GroupDetailViewController ()

@end

@implementation GroupDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"群详情";
    [self cretaeUI];
    // Do any additional setup after loading the view.
}
-(void)cretaeUI{
    succeedImageView=[ZCControl createImageViewWithFrame:CGRectMake((WIDTH-320)/2, 54, 320, self.view.frame.size.height-64-88) ImageName:nil];
//    succeedImageView.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    [self.view addSubview:succeedImageView];
    
    UILabel*xx=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 320, 44) Font:15 Text:@"群详情"];
    xx.textColor=[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal];
    xx.textAlignment=NSTextAlignmentCenter;
    [succeedImageView addSubview:xx];
    //group1@2x.png
                //主题
    UIImageView*subjcetImageView1=[ZCControl createImageViewWithFrame:CGRectMake(40, 40, 20, 20) ImageName:@"group1.png"];
    [succeedImageView addSubview:subjcetImageView1];
    
    subjectLabel=[ZCControl createLabelWithFrame:CGRectMake(80, 30, 240, 44) Font:12 Text:[NSString stringWithFormat:@"群号：%@",[[self.groupNum componentsSeparatedByString:@"@"] firstObject]]];
    subjectLabel.textColor=[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal];

    [succeedImageView addSubview:subjectLabel];
    //描述
    UIImageView*desImageView=[ZCControl createImageViewWithFrame:CGRectMake(40, 74, 20, 20) ImageName:@"group2.png"];
    [succeedImageView addSubview:desImageView];
    desLabel=[ZCControl createLabelWithFrame:CGRectMake(80, 64, 240-44, 44) Font:12 Text:[NSString stringWithFormat:@"描述：%@",[_roomConfigDic objectForKey:@"des"]]];
    desLabel.textColor=[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal];
    desLabel.adjustsFontSizeToFitWidth=YES;
    
    [succeedImageView addSubview:desLabel];
    //当前人数
    UIImageView*numImageView=[ZCControl createImageViewWithFrame:CGRectMake(40,114 , 20, 20) ImageName:@"group3.png"];
    [succeedImageView addSubview:numImageView];
    numLabel=[ZCControl createLabelWithFrame:CGRectMake(80, 104, 240, 44) Font:12 Text:[NSString stringWithFormat:@"当前在线%@人",[_roomConfigDic objectForKey:@"num"]]];
    numLabel.textColor=[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal];
    [succeedImageView addSubview:numLabel];
    //创建日期
    UIImageView*timeImageView=[ZCControl createImageViewWithFrame:CGRectMake(40,154 , 20, 20) ImageName:@"group4.png"];
    [succeedImageView addSubview:timeImageView];
    timeLabel=[ZCControl createLabelWithFrame:CGRectMake(80, 144, 240, 44) Font:12 Text:[NSString stringWithFormat:@"创建时间：%@",[self format:_roomConfigDic[@"time"]]]];
    timeLabel.textColor=[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal];
    [succeedImageView addSubview:timeLabel];
    //进入
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:GROUNDROOMCONFIG]) {
        createButton=[ZCControl createButtonWithFrame:CGRectMake(0, 184, succeedImageView.frame.size.width, 44) ImageName:nil Target:self Action:@selector(createButtonClick) Title:@"邀请好友进群"];
        [createButton setTitleColor:[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal] forState:UIControlStateNormal];
        [succeedImageView addSubview:createButton];
        
        UIButton*edit=[ZCControl createButtonWithFrame:CGRectMake(260, 64, 44, 44) ImageName:nil Target:self Action:@selector(editClick) Title:nil];
        [edit setImage:[UIImage imageNamed:@"icon_edit.png"] forState:UIControlStateNormal];
        [edit setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [succeedImageView addSubview:edit];
        
        //创建二维码
        UIImageView*qrImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 100, 100) ImageName:nil];
        qrImageView.image=[QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"[1]%@",self.groupNum] imageSize:300];
        qrImageView.center=CGPointMake(succeedImageView.frame.size.width/2,self.view.center.y+20);
        [succeedImageView addSubview:qrImageView];
        
        UILabel*label1=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 320, 20) Font:8 Text:@"你的好友扫二维码即可加入群组"];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.textColor=[UIColor redColor];
        label1.center=CGPointMake(succeedImageView.frame.size.width/2, self.view.center.y+70);
        [succeedImageView addSubview:label1];
    }
  

    

}
#pragma mark 邀请好友
-(void)createButtonClick{
    GroupAddFriendViewController*vc=[[GroupAddFriendViewController alloc]init];
    vc.room=_room;
    [self presentViewController:vc animated:YES completion:nil];
    
//    UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"输入好友的账号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    al.alertViewStyle=UIAlertViewStylePlainTextInput;
//    al.tag=100;
//    [al show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex&&alertView.tag==100) {
       UITextField*textField= [alertView textFieldAtIndex:0];
        if (textField.text.length>0) {
             [[ZCXMPPManager sharedInstance]inviteRoom:self.room userName:textField.text];
        }
    }
    if (buttonIndex&&alertView.tag==200) {
        UITextField*textField= [alertView textFieldAtIndex:0];
        if (textField.text.length>0) {
            NSMutableDictionary*dic=[NSMutableDictionary dictionaryWithDictionary:self.roomConfigDic];
            [dic setObject:textField.text forKey:@"desName"];
            NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
            [user setObject:dic forKey:GROUNDNAME];
            [user synchronize];
            [[ZCXMPPManager sharedInstance]configRoom:self.room config:nil];
            desLabel.text=[NSString stringWithFormat:@"描述：%@",textField.text];
        }
    }
    
}
#pragma mark
-(void)editClick{

    UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"可以修改群主题" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    al.alertViewStyle=UIAlertViewStylePlainTextInput;
    al.tag=200;
    [al show];
}
-(NSString *)format:(NSString *)string{
    
    NSString*newString=[[[string stringByReplacingOccurrencesOfString:@"T" withString:@" "]stringByReplacingOccurrencesOfString:@"Z" withString:@""]substringToIndex:19];
    
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //get date str
    //str to nsdate
    NSDate *strDate = [outputFormatter dateFromString:newString];
    //修正8小时的差时
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: strDate];
    NSDate *endDate = [strDate  dateByAddingTimeInterval: interval];
    //NSLog(@"endDate:%@",endDate);
    NSString *lastTime = [self compareDate:endDate];
    return lastTime;
}
-(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    //修正8小时之差
    NSDate *date1 = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date1];
    NSDate *localeDate = [date1  dateByAddingTimeInterval: interval];
    
    //NSLog(@"nowdate=%@\nolddate = %@",localeDate,date);
    NSDate *today = localeDate;
    NSDate *yesterday,*beforeOfYesterday;
    //今年
    NSString *toYears;
    
    toYears = [[today description] substringToIndex:4];
    
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    beforeOfYesterday = [yesterday dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *beforeOfYesterdayString = [[beforeOfYesterday description] substringToIndex:10];
    
    NSString *dateString = [[date description] substringToIndex:10];
    NSString *dateYears = [[date description] substringToIndex:4];
    
    NSString *dateContent;
    if ([dateYears isEqualToString:toYears]) {//同一年
        //今 昨 前天的时间
        NSString *time = [[date description] substringWithRange:(NSRange){11,5}];
        //其他时间
        NSString *time2 = [[date description] substringWithRange:(NSRange){5,11}];
        if ([dateString isEqualToString:todayString]){
            dateContent = [NSString stringWithFormat:@"今天 %@",time];
            return dateContent;
        } else if ([dateString isEqualToString:yesterdayString]){
            dateContent = [NSString stringWithFormat:@"昨天 %@",time];
            return dateContent;
        }else if ([dateString isEqualToString:beforeOfYesterdayString]){
            dateContent = [NSString stringWithFormat:@"前天 %@",time];
            return dateContent;
        }else{
            return time2;
        }
    }else{
        return dateString;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
