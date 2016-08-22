//
//  RadarViewController.m
//  weiChat
//
//  Created by ZhangCheng on 14/6/27.
//  Copyright (c) 2014年 张诚. All rights reserved.
//

#import "RadarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RadarErrorViewController.h"
#import "MyVcardViewController.h"
@interface RadarViewController ()

@end

@implementation RadarViewController

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
    self.title=@"发现";
    [self createView];
    self.dataArray=[NSMutableArray arrayWithCapacity:0];
    
    //创建iBeacon发现服务
  
    server=[[IBeaconServer alloc]init];
    client=[[IBeaconClient alloc]initWithBlock:^(int type, NSDictionary *dic) {
        
        switch (type) {
            case 0:
            {
                //停止动画
                [radarDisCoverImageView.layer removeAnimationForKey:@"rotationAnimation"];
                //停止发现
                [client stopBeacon];
                [server stopServer];
                
                UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提示" message:@"发现服务启动失败点击确定查看说明" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                al.tag=345;
                [al show];
            }
                break;
            case 1:
            {
                NSLog(@"发现一个新的好友");
                int tag=[[dic objectForKey:@"useName"]intValue];
               
                [[ZCXMPPManager sharedInstance] friendsVcard:[NSString stringWithFormat:@"%d",tag] Block:^(BOOL isSucceed, XMPPvCardTemp *vcard) {
                    UIButton*createButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 44, 44) ImageName:nil Target:self Action:@selector(friendClick:) Title:nil];
                    createButton.center=CGPointMake(160, 160);
                    createButton.layer.cornerRadius=23;
                    createButton.layer.masksToBounds=YES;
                    createButton.tag=tag;
                    if (vcard.photo) {
                        [createButton setImage:[UIImage imageWithData:vcard.photo] forState:UIControlStateNormal];
                    }else{
                        [createButton setTitle:UNCODE(vcard.nickname) forState:UIControlStateNormal];
                    }
                    [self.dataArray addObject:vcard];
                    [radarImageView addSubview:createButton];
                    [UIView animateWithDuration:2 animations:^{
                        CGSize size=[self findFrameSize];
                        createButton.frame=CGRectMake(size.width, size.height, 44, 44);
                    }];
                }];
            }
                break;
            case 2:
            {
                NSLog(@"好友离开了");
                int tag1=[[dic objectForKey:@"useName"]intValue];
                UIButton*deleteButton=   (UIButton*)[radarImageView viewWithTag:tag1];
            [UIView animateWithDuration:0.5 animations:^{
                deleteButton.alpha=0;
            }completion:^(BOOL finished) {
                for (XMPPvCardTemp*temp in self.dataArray) {
                   
                    if ( [temp.jid.user isEqualToString:[NSString stringWithFormat:@"%d",tag1]]) {
                        [self.dataArray removeObject:temp];
                    }
                    
                    
                }
                [deleteButton removeFromSuperview];
            }];
            }
                
                break;
            default:
            
                break;
        }
        
      
        
    }];
    
    
}

-(CGSize)findFrameSize{
    CGFloat r=160-44;
    while (1) {
        CGFloat x=arc4random()%320;
        x-=160;
        CGFloat y=arc4random()%320;
        y-=160;
        if ((x*x+y*y)>r*r) {
        }else {
            return CGSizeMake(x+160, y+160);
        }
    }
}



-(void)backClick{
    
    //停止动画
    [radarDisCoverImageView.layer removeAnimationForKey:@"rotationAnimation"];
    //停止发现
    [client stopBeacon];
    [server stopServer];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 创建界面
-(void)createView{
    radarDisCoverImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    radarDisCoverImageView.userInteractionEnabled=YES;
    radarDisCoverImageView.image=[UIImage imageNamed:@"radarDiscoverLayer.png"];
    [self.view addSubview:radarDisCoverImageView];
    radarDisCoverImageView.center=CGPointMake(self.view.center.x, self.view.center.y);
    
    radarImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    radarImageView.center=CGPointMake(self.view.center.x, self.view.center.y);
    radarImageView.userInteractionEnabled=YES;
    radarImageView.image=[UIImage imageNamed:@"radarBg.png"];
    
    [self.view addSubview:radarImageView];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 10000;
    
    [radarDisCoverImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)friendClick:(UIButton*)button{

    //获得vard  还有用户账号
    MyVcardViewController*vc=[[MyVcardViewController alloc]init];
    vc.friendJid=[NSString stringWithFormat:@"%ld",button.tag];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag==345) {
        RadarErrorViewController*vc=[[RadarErrorViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
 
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
