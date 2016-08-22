//
//  GroupCreateViewController.m
//  weiChat
//
//  Created by ZhangCheng on 14/7/3.
//  Copyright (c) 2014年 张诚. All rights reserved.
//

#import "GroupCreateViewController.h"
#import "GroupChatViewController.h"
#import "ThemeManager.h"
@interface GroupCreateViewController ()

@end

@implementation GroupCreateViewController

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
    self.title=@"创建群组";
    [self createTextField];
    [self createRightNav];
}

-(void)createRightNav{
    UIButton*create=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 44) ImageName:nil Target:self Action:@selector(createClick) Title:@"创建"];
    [create setTitleColor:[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:create];
    
    
}
-(void)createTextField{

    //创建账号
    useName=[ZCControl createLabelWithFrame:CGRectMake(50, 84, 200, 20) Font:15 Text:[NSString stringWithFormat:@"您的群数字账号为:%ld",DATETIME]];
    useName.textColor=[ThemeManager themeColorStrToColor:kTabBarItemTitleColorNormal];
    [self.view addSubview:useName];
    UILabel*shuoming=[ZCControl createLabelWithFrame:CGRectMake(50, 40+64, 200, 20) Font:5 Text:@"诚花花为您创建了群数字账号,不满意请点击重试来进行创建一个新的数字账号"];
    shuoming.textColor=[ThemeManager themeColorStrToColor:kTabBarItemTitleColorNormal];
    [self.view addSubview:shuoming];
    
    UIButton*timeButton=[ZCControl createButtonWithFrame:CGRectMake(250, 64, 80, 44) ImageName:nil Target:self Action:@selector(timeButtonClick) Title:@"重试"];
    [self.view addSubview:timeButton];
    
    

   //群名称
    UIImageView*leftImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_edit.png"]];
    leftImageView.frame=CGRectMake(20, 12, 20, 20);
    UIImageView*view=[[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
    [view addSubview:leftImageView];

    nikeName=[ZCControl createTextFieldWithFrame:CGRectMake(0,60+64, WIDTH, 44) placeholder:@"给自己的群创建一个响亮的名称" passWord:NO leftImageView:view rightImageView:nil Font:12 backgRoundImageName:nil];
    nikeName.delegate=self;
    nikeName.returnKeyType=UIReturnKeyNext;
    [self.view addSubview:nikeName];
    nikeName.backgroundColor=[UIColor whiteColor];
   // [nikeName becomeFirstResponder];
    
    UIImageView*leftImageViewdes=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_edit.png"]];
    leftImageViewdes.frame=CGRectMake(20, 12, 20, 20);
    UIImageView*viewdes=[[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
    [viewdes addSubview:leftImageViewdes];
    
    desName=[ZCControl createTextFieldWithFrame:CGRectMake(0,110+64, WIDTH, 44) placeholder:@"给自己的群添加一个主题" passWord:NO leftImageView:viewdes rightImageView:nil Font:12 backgRoundImageName:nil];
    desName.delegate=self;
    desName.returnKeyType=UIReturnKeyDone;
    desName.backgroundColor=[UIColor whiteColor];

    [self.view addSubview:desName];
   
    
    //设置临时房间
    UIButton*button=[ZCControl createButtonWithFrame:CGRectMake(44, 160+64, 80, 44) ImageName:nil Target:self Action:@selector(roomClick:) Title:nil];
    [button setAttributedTitle:[[NSAttributedString alloc] initWithString:@"永久房间" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal]}] forState:UIControlStateNormal];
 [button setImage:[UIImage imageNamed:@"icon_video_play_colose.png"] forState:UIControlStateNormal];
    [self.view addSubview:button];
   
    isOpen=0;
    //最大人数 选择框
    maxButton=[ZCControl createButtonWithFrame:CGRectMake(160, 160+64, WIDTH-88, 44) ImageName:nil Target:self Action:@selector(maxButtonClick) Title:nil];
    [self.view addSubview:maxButton];
    [maxButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"群组最大人数" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal]}] forState:UIControlStateNormal];
    num=30;
    
    UILabel*label=[ZCControl createLabelWithFrame:CGRectMake(44, 200+64, WIDTH-88, 44) Font:8 Text:@"默认群组创建为临时群组，在最后一个组员退出房间后即解散，如果要创建永久房间，请点击永久房间，群组默认最大人数为30人"];
    label.numberOfLines=0;
    label.adjustsFontSizeToFitWidth=YES;
    label.textColor=[UIColor redColor];
    [self.view addSubview:label];
    

}
#pragma mark 开关
-(void)roomClick:(UIButton*)button{
    isOpen=!isOpen;
    if (isOpen) {
        [button setImage:[UIImage imageNamed:@"icon_videoreview_select.png"] forState:UIControlStateNormal];
    }else{
        [button setImage:[UIImage imageNamed:@"icon_video_play_colose.png"] forState:UIControlStateNormal];
    }

}
#pragma mark 群组最大人数
-(void)maxButtonClick{
    
    if (maxPicker==nil) {
        maxPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-216, WIDTH, 216)];
        maxPicker.delegate=self;
        maxPicker.dataSource=self;
        maxPicker.showsSelectionIndicator=YES;
        
        [maxPicker selectRow:30 inComponent:0 animated:YES];
        [self.view addSubview:maxPicker];
         [self.view endEditing:YES];
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 1000;
}
- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  return  [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"群组最大人数为%ld人",(long)(long)row] attributes:@{NSForegroundColorAttributeName:[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal]}];
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [maxButton setAttributedTitle:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"设置群组最大人数为%ld人",(long)row] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal]}] forState:UIControlStateNormal];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    if (maxPicker) {
        [UIView animateWithDuration:0.5 animations:^{
            maxPicker.frame=CGRectMake(0, self.view.frame.size.height, 0, 0);
        }completion:^(BOOL finished) {
            [maxPicker removeFromSuperview];
            maxPicker=nil;
        
        }];
    }

}

-(void)createClick{
    //nikeName.text.length>0
    if (!isOpen) {
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定只创建临时房间？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        al.tag=100;
        [al show];
        return;
    }
    
    if (desName.text.length>0) {
        NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
        [self.view endEditing:YES];
        if (maxPicker) {
            [UIView animateWithDuration:0.5 animations:^{
                maxPicker.frame=CGRectMake(0, self.view.frame.size.height, 0, 0);
            }completion:^(BOOL finished) {
                [maxPicker removeFromSuperview];
                maxPicker=nil;
                
            }];
        }
        //@"nikeName":nikeName.text,
    NSDictionary*dic=@{@"name":nikeName.text,@"desName":[NSString stringWithFormat:@"%@",desName.text],@"isOpen":[NSString stringWithFormat:@"%d",isOpen],@"num":[NSString stringWithFormat:@"%d",num]};
        
        [defaults setObject:dic forKey:GROUNDNAME];
        [defaults synchronize];
        
        GroupChatViewController*vc=[[GroupChatViewController alloc]init];
        vc.roomJid=[useName.text substringFromIndex:9];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"资料不全" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [al show];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        if (buttonIndex) {
            if (desName.text.length>0) {
                NSUserDefaults*defaults=[NSUserDefaults standardUserDefaults];
                [self.view endEditing:YES];
                if (maxPicker) {
                    [UIView animateWithDuration:0.5 animations:^{
                        maxPicker.frame=CGRectMake(0, self.view.frame.size.height, 0, 0);
                    }completion:^(BOOL finished) {
                        [maxPicker removeFromSuperview];
                        maxPicker=nil;
                        
                    }];
                }
                NSDictionary*dic=@{@"name":nikeName.text,@"desName":[NSString stringWithFormat:@"%@",desName.text],@"isOpen":[NSString stringWithFormat:@"%d",isOpen],@"num":[NSString stringWithFormat:@"%d",num]};
                
                [defaults setObject:dic forKey:GROUNDNAME];
                [defaults synchronize];
                
                GroupChatViewController*vc=[[GroupChatViewController alloc]init];
                vc.roomJid=[useName.text substringFromIndex:9];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else {
                UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"资料不全" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [al show];
            }

            
        }
    }
    

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==nikeName) {
        [desName becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
      //  [self createClick];
    }
    return YES;
}
-(void)timeButtonClick{
    
    useName.text=[NSString stringWithFormat:@"您的群数字账号为:%ld",DATETIME];
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
