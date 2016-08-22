

//
//  AboutViewController.m
//  weiChat
//
//  Created by ZhangCheng on 14/6/20.
//  Copyright (c) 2014年 张诚. All rights reserved.
//

#import "AboutViewController.h"
#import "ThemeManager.h"
@interface AboutViewController ()

@end

@implementation AboutViewController
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
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    self.title=@"关于我们";
    [self createTextView];
    
    
}
-(void)createTextView{

    UITextView*textView=[[UITextView alloc]initWithFrame:CGRectMake(10, 64, 300, HEIGHT-150)];
    textView.editable=NO;
    
    textView.backgroundColor=[UIColor clearColor];
    textView.font=[UIFont fontWithName:@"Bradley Hand ITC TT" size:15];
    textView.text=@"\n\n\n微聊小圈是由浪的不能在浪的🌸诚花花🌸倾力打造\n\n欢迎各位努力打赏🌸诚花花🌸\n\niOS研究院欢迎你的加入\n\niOS研究院1群305044955(已满)\n\niOS研究院2群495514120\n\n 诚花花的github地址 https://github.com/149393437\n\n 鸣谢：表情MM给予的支持\n\n我们将努力做到更好，你的使用就是对我们最大的支持\n\n打个广告:\n\n\n如果你有朋友要学习iOS或者Html5,不要忘记给🌸诚花花🌸推荐哦!\n\n良心教育,品质保障";
    textView.textColor=[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal];
    UIButton*button=[ZCControl createButtonWithFrame:CGRectMake(50, HEIGHT-50, 220, 50) ImageName:nil Target:self Action:@selector(teleClick) Title:@"联系我们:13811928431"];
    [button setTitleColor:[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal] forState:UIControlStateNormal];
    [self.view addSubview:textView];
    [self.view addSubview:button];
}
-(void)teleClick{
    UIWebView*callWebView=[[UIWebView alloc]init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:13811928431"]]];
    [self.view addSubview:callWebView];
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
