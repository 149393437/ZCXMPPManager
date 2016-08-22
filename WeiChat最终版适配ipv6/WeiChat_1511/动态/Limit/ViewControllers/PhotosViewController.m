//
//  PhotosViewController.m
//  LimitFreeProject
//
//  Created by zhangcheng on 16/2/17.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "PhotosViewController.h"
@interface PhotosViewController ()<UIActionSheetDelegate>
{
    UIImageView*tempImageView;

}
@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView*sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    sc.contentSize=CGSizeMake(WIDTH*self.dataArray.count, HEIGHT-64);
    //关闭反弹
    sc.bounces=NO;
    //分页属性
    sc.pagingEnabled=YES;
    
    [self.view addSubview:sc];
    
    //进行循环创建
    for (int i=0; i<self.dataArray.count; i++) {
        UIImageView*imageView=[LFZCControl createImageViewWithFrame:CGRectMake(i*WIDTH, 0, WIDTH, HEIGHT-64) ImageName:nil];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[i][@"originalUrl"]] placeholderImage:[UIImage imageNamed:@"topic_TopicImage_Default"]];
        //添加长按手势
        UILongPressGestureRecognizer*longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressClick:)];
        [imageView addGestureRecognizer:longPress];
        
        
        
        //加载在sc上
        [sc addSubview:imageView];
    }
    
    
    
    // Do any additional setup after loading the view.
}
-(void)longPressClick:(UILongPressGestureRecognizer*)longPress{
    tempImageView=(UIImageView*)longPress.view;
    if (IOS9) {
        //iOS9.0以上的
        UIAlertController*al=[UIAlertController alertControllerWithTitle:@"选择保存图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self actionAlert];
        }]];
        [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        //展示
        [self presentViewController:al animated:YES completion:nil];
        
    }else{
        UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"选择保存照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [sheet showInView:self.view];
    
    
    }

}
#pragma mark 点击确定触发的方法
-(void)actionAlert{
    //进行保存图片
    
    if (tempImageView) {
    UIImageWriteToSavedPhotosAlbum(tempImageView.image, nil, nil, nil);
        
        //处理完成以后,需要告知用户,保存成功
        if (IOS9) {
            UIAlertController*al=[UIAlertController alertControllerWithTitle:@"保存图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [al addAction:[UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:al animated:YES completion:nil];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"保存图片" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"完成", nil]show];
        
        }
    }
    
    
   
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        //确定
        [self actionAlert];

    }else{
        //取消
    
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
