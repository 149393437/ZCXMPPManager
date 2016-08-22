//
//  DetailViewController.m
//  爱限免
//
//  Created by zhangcheng on 16/2/17.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "DetailViewController.h"
#import "PhotosViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UIButton+WebCache.h"
#import <StoreKit/StoreKit.h>
#import "MBProgressHUD.h"
#import "UMSocial.h"
@interface DetailViewController ()<CLLocationManagerDelegate,SKStoreProductViewControllerDelegate>
{
    //定位的指针请一定写为全局的
    CLLocationManager*_manager;
    
    CLLocation*old;
}
@property (nonatomic,strong) NSDictionary *appDetailDic;
//用于记录附近应用
@property(nonatomic,strong)NSArray*dataArray;
@end

@implementation DetailViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //xib在即将出现的时候才会更改坐标
    //获取数量
    NSInteger a = [self.appDetailDic[@"photos"] count] ;
    
    for (int i = 0; i < a; i++) {
        UIImageView * imageView = [_appScrollerView viewWithTag:100+i];
        imageView.frame = CGRectMake(10+(_appScrollerView.frame.size.height*0.5+10)*i, 10, _appScrollerView.frame.size.height*0.5, _appScrollerView.frame.size.height - 20);
    }
    _appScrollerView.contentSize = CGSizeMake((_appScrollerView.frame.size.height*0.5+10)*a, _appScrollerView.frame.size.height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *url = [NSString stringWithFormat:DETAIL,self.appID];
    HttpDownLoad *http = [[HttpDownLoad alloc]initWithURLStr:url Post:NO DataDic:nil Block:^(HttpDownLoad *x, BOOL isSuccess) {
        //读取结果
        NSLog(@"~~%@",x.dataDic);
        self.appDetailDic = x.dataDic;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:x.dataDic[@"iconUrl"]] placeholderImage:[UIImage imageNamed:@"account_candou"]];
         
         _appNameLabel.text = x.dataDic[@"name"];
         
         _priceLabel.text =[NSString stringWithFormat:@"现价%@元 原价%@元",x.dataDic[@"currentPrice"],x.dataDic[@"lastPrice"]];
         _typeLabel.text = [NSString stringWithFormat:@"类型:%@  评分:%@",x.dataDic[@"priceTrend"],x.dataDic[@"starCurrent"]];
         _commentLabel.text = x.dataDic[@"description"];
        
        NSArray *imageArray = x.dataDic[@"photos"];
        
        for (int i = 0; i < imageArray.count; i++) {
            UIImageView *imageView = [LFZCControl createImageViewWithFrame: CGRectMake(i+(WIDTH-40)/5*i, 10, (WIDTH-40)/5, _appScrollerView.frame.size.height) ImageName:nil];
            [imageView sd_setImageWithURL:imageArray[i][@"smallUrl"] placeholderImage:[UIImage  imageNamed:@"topic_TopicImage_Default"]];
   
            imageView.tag = 100+i;
            [_appScrollerView addSubview:imageView];
            
            //添加手势
            UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            [imageView addGestureRecognizer:tap];
            
            
        }
            }];
    http = nil;
    
    
    
    [self createLocation];
    
    [self createLeftNav];
    
}
-(void)createLeftNav{
    UIButton*button=[LFZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) Target:self Method:@selector(leftButtonClick) Title:@"返回" ImageName:nil BgImageName:nil];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}
-(void)leftButtonClick{
    [self.navigationController popToRootViewControllerAnimated:YES];

}
-(void)createLocation{
    //我们在添加定位时候iOS8对定位进行了重新改变,需要多增加2个方法,才可以进行定位,并且在infoplist中需要增加2个key值,用于提醒使用
    _manager=[[CLLocationManager alloc]init];
    
    //设置代理
    _manager.delegate=self;
    //NSLocationWhenInUseUsageDescription  NSLocationAlwaysUsageDescription
    
    //设定距离 单位 米
    _manager.distanceFilter=1000;
    
    [_manager requestWhenInUseAuthorization];
    [_manager requestAlwaysAuthorization];
    [_manager startUpdatingLocation];
    

}
#pragma mark 定位的代理方法
//定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"定位成功");
    
    
    //读取经纬度
    CLLocation *cl=[locations lastObject];

    //开始网络请求,并且停止定位
    [manager stopUpdatingLocation];
    
    
    HttpDownLoad*http=[[HttpDownLoad alloc]initWithURLStr:[NSString stringWithFormat:FIND,cl.coordinate.longitude,cl.coordinate.latitude] Post:NO DataDic:nil Block:^(HttpDownLoad *xx, BOOL is) {
        
        NSLog(@"%@",xx.dataDic);
        //这里面我只需要用到3个数值 applicationId name iconUrl  applications
        self.dataArray=xx.dataDic[@"applications"];
        
        
        //遍历循环创建进行创建
        for (int i=0; i<self.dataArray.count; i++) {
            //读取数据源
            NSDictionary*dic=self.dataArray[i];
            UIButton*button;
            if ([_findScorllView viewWithTag:100+i]==nil) {
               button =[LFZCControl createButtonWithFrame:CGRectMake(10+50*i, 5, 40, 40) Target:self Method:@selector(buttonClick:) Title:nil ImageName:nil BgImageName:nil];
                button.tag=100+i;
  
            }
            
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:dic[@"iconUrl"]] forState:UIControlStateNormal];
            button.tag=[dic[@"applicationId"]integerValue];
            [_findScorllView addSubview:button];
            
            UILabel*label;
            if ([_findScorllView viewWithTag:200+i]==nil) {
                label=[LFZCControl createLabelWithFrame:CGRectMake(0, 40, 40, 10) Font:5 Text:dic[@"name"]];
                label.textAlignment=NSTextAlignmentCenter;
                label.tag=200+i;
                [button addSubview:label];
            }
            label.text=dic[@"name"];
            
            
            
        }
        //设置sc大小
        _findScorllView.contentSize=CGSizeMake(50*self.dataArray.count+20, 50);
        
        
        
        
    }];
    
    http=nil;
    
}
#pragma mark find点击方法
-(void)buttonClick:(UIButton*)button{

    DetailViewController*vc=[[DetailViewController alloc]init];
    vc.appID=[NSString stringWithFormat:@"%ld",(long)button.tag];
    [self.navigationController pushViewController:vc animated:YES];
}
//定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"失败成功");
}

-(void)tapClick:(UITapGestureRecognizer*)tap{
   
    NSLog(@"%ld",tap.view.tag);
    
    PhotosViewController*vc=[[PhotosViewController alloc]init];
    vc.page=tap.view.tag-100;
    
    vc.dataArray=self.appDetailDic[@"photos"];
    
    vc.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    

}
- (IBAction)downClick:(id)sender {
  
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_appDetailDic[@"itunesUrl"]]];
}

- (IBAction)collectClick:(id)sender {
    
    NSLog(@"%@",self.appDetailDic[@"applicationId"]);
    
    NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
    
    NSDictionary*dic=@{@"iconUrl":self.appDetailDic[@"iconUrl"],@"name":self.appDetailDic[@"name"],@"appid":self.appDetailDic[@"applicationId"]};
    
    //取出所有收藏内容
    NSDictionary*collect=[user objectForKey:COLLECT];
    NSMutableDictionary*m_collect=[NSMutableDictionary dictionaryWithDictionary:collect];
    [m_collect setObject:dic forKey:self.appDetailDic[@"applicationId"]];
    //重新保存收藏内容
    [user setObject:m_collect forKey:COLLECT];
    [user synchronize];
    
    if (IOS9) {
        UIAlertController*al=[UIAlertController alertControllerWithTitle:@"收藏完成" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:al animated:YES completion:nil];
        
    }else{
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"收藏完成" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
- (IBAction)shareClick:(id)sender {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"507fcab25270157b37000010"
                                      shareText:_appDetailDic[@"description"]
                                     shareImage:_iconImageView.image
                                shareToSnsNames:nil
                                       delegate:nil];
    
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
