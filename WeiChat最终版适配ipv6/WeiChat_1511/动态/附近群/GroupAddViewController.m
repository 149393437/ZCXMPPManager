//
//  GroupAddViewController.m
//  weiChat
//
//  Created by ZhangCheng on 14/7/3.
//  Copyright (c) 2014年 张诚. All rights reserved.
//

#import "GroupAddViewController.h"
#import "GroupChatViewController.h"

@interface GroupAddViewController ()

@end

@implementation GroupAddViewController

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
    self.title=@"添加群号";
    //创建UI
    //执行搜索
    [self createUI];

    
    
}
-(void)createUI{
    UISearchBar*searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, 320, 44)];
    searchBar.delegate=self;
     searchBar.showsCancelButton=YES;
    UIImage*searchBarImage=[self imageNameStringToImage:@"searchbar_icon_search.png"];
    [searchBar setImage:searchBarImage forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    searchBar.placeholder=@"输入你要进入的群号";
    if (_resultStr) {
        searchBar.text=_resultStr;
        searchStr=_resultStr;
        [[ZCXMPPManager sharedInstance]fetchRoomName:searchBar.text Block:^(NSDictionary *dic) {
            
            [self createSearchResult:dic];
        }];
    }else{
        [searchBar becomeFirstResponder];
    }
    
    [self.view addSubview:searchBar];
 

}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //182684
    
    if (searchBar.text.length>5) {
        searchStr=[searchBar.text copy];
        [[ZCXMPPManager sharedInstance]fetchRoomName:searchBar.text Block:^(NSDictionary *dic) {
            NSLog(@"%@",dic);
            
            [self createSearchResult:dic];
        }];
    }else{
    
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"没有这个号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [al show];
    }
   
}
-(void)createSearchResult:(NSDictionary*)dic{
//开始搜索
  //  NSDictionary*dic=@{@"des":str,@"num":str2,@"time":str3};
    if (dic) {
        if (errorImageView) {
            errorImageView.hidden=YES;
        }
        
        if (succeedImageView) {
            succeedImageView.hidden=NO;
            subjectLabel.text=[dic objectForKey:@"name"];
            desLabel.text=[dic objectForKey:@"des"];
            numLabel.text=[dic objectForKey:@"num"];
            timeLabel.text=[dic objectForKey:@"time"];
            
            
        }else {
            
            succeedImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 110, 320, 320) ImageName:nil];
            succeedImageView.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
            [self.view addSubview:succeedImageView];
            
            UILabel*xx=[ZCControl createLabelWithFrame:CGRectMake(0, 0, 320, 44) Font:12 Text:@"搜索结果"];
            xx.textAlignment=NSTextAlignmentCenter;
            [succeedImageView addSubview:xx];
            //group1@2x.png
            //主题
            UIImageView*subjcetImageView1=[ZCControl createImageViewWithFrame:CGRectMake(40, 40, 20, 20) ImageName:@"group1.png"];
            [succeedImageView addSubview:subjcetImageView1];

            subjectLabel=[ZCControl createLabelWithFrame:CGRectMake(80, 30, 240, 44) Font:12 Text:[NSString stringWithFormat:@"主题：%@",[dic objectForKey:@"name"]]];
            [succeedImageView addSubview:subjectLabel];
            //描述
            UIImageView*desImageView=[ZCControl createImageViewWithFrame:CGRectMake(40, 74, 20, 20) ImageName:@"group2.png"];
            [succeedImageView addSubview:desImageView];
            desLabel=[ZCControl createLabelWithFrame:CGRectMake(80, 64, 240, 44) Font:12 Text:[NSString stringWithFormat:@"描述：%@",[dic objectForKey:@"des"]]];
            desLabel.adjustsFontSizeToFitWidth=YES;
            
            [succeedImageView addSubview:desLabel];
            //当前人数
            UIImageView*numImageView=[ZCControl createImageViewWithFrame:CGRectMake(40,114,20, 20) ImageName:@"group3.png"];
            [succeedImageView addSubview:numImageView];
            numLabel=[ZCControl createLabelWithFrame:CGRectMake(80, 104, 240, 44) Font:12 Text:[NSString stringWithFormat:@"当前在线%@人",[dic objectForKey:@"num"]]];
            [succeedImageView addSubview:numLabel];
            //创建日期
            UIImageView*timeImageView=[ZCControl createImageViewWithFrame:CGRectMake(40,144,20, 20) ImageName:@"group4.png"];
            [succeedImageView addSubview:timeImageView];
            
            timeLabel=[ZCControl createLabelWithFrame:CGRectMake(80, 134, 240, 44) Font:12 Text:[self format:dic[@"time"]]];
            [succeedImageView addSubview:timeLabel];
            //进入
            
            
            createButton=[ZCControl createButtonWithFrame:CGRectMake(0, 174, 320, 44) ImageName:nil Target:self Action:@selector(createBUttonClick) Title:@"进入"];
            [succeedImageView addSubview:createButton];
            
        
        }
        
        
    }else{
    //失败
        if (succeedImageView) {
           succeedImageView.hidden=YES;
        }
        
        if (errorImageView) {
            errorImageView.hidden=NO;
        }else{

        errorImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 110, 320, 320)];
            errorImageView.image=[UIImage imageNamed:@"confirm_bigicon.png"];
            [self.view addSubview:errorImageView];
            errorImageView.center=CGPointMake(self.view.center.x, self.view.center.y-100);
            UILabel*label=[ZCControl createLabelWithFrame:CGRectMake(0, 320, 320, 44) Font:12 Text:@"没有找到相关群"];
            label.textColor=[UIColor grayColor];
            label.textAlignment=NSTextAlignmentCenter;
            [errorImageView addSubview:label];
        
        }
    }
    
    [self.view endEditing:YES];
}
-(void)createBUttonClick{

    GroupChatViewController*vc=[[GroupChatViewController alloc]init];
    vc.roomJid=searchStr;
    [self.navigationController pushViewController:vc animated:YES];
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
