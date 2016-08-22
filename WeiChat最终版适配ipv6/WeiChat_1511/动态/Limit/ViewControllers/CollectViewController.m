
//
//  CollectViewController.m
//  LimitFreeProject
//
//  Created by zhangcheng on 16/2/18.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "CollectViewController.h"
#import "DetailViewController.h"
@interface CollectViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView*_collectView;
}
@property(nonatomic,strong)NSMutableArray*dataArray;
@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //读取数据
    NSArray*array=[[[NSUserDefaults standardUserDefaults]objectForKey:COLLECT] allValues];
    self.dataArray=[NSMutableArray arrayWithArray:array];
    NSLog(@"%@",self.dataArray);
    
    //创建collectView
    [self createCollectView];
    
    
    
    // Do any additional setup after loading the view.
}
-(void)createCollectView{
    UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];

    _collectView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) collectionViewLayout:layout];
    _collectView.delegate=self;
    _collectView.dataSource=self;
    
    //注册cell
    [_collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ID"];
    
    
    //设置layout每个的大小
    layout.itemSize=CGSizeMake(100, 100);
    
    
    //设置滑动方向  默认是纵向滑动,我们需要设置为横向滚动
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    [self.view addSubview:_collectView];


}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
//最小间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
    
    
    //读取数据
    NSDictionary*dic=self.dataArray[indexPath.row];
    
    UIImageView*imageView=[cell.contentView viewWithTag:100];
    if (imageView==nil) {
        imageView=[LFZCControl createImageViewWithFrame:CGRectMake(20, 10, 60, 60) ImageName:nil];
        imageView.tag=100;
        imageView.layer.cornerRadius=5;
        imageView.layer.masksToBounds=YES;
        [cell.contentView addSubview:imageView];
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"iconUrl"]] placeholderImage:[UIImage imageNamed:@"account_candou"]];
    
    UILabel*label=[cell.contentView viewWithTag:200];
    if (label==nil) {
        label=[LFZCControl createLabelWithFrame:CGRectMake(20, 70, 60, 10) Font:10 Text:nil];
        label.textAlignment=NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
    }
    label.text=dic[@"name"];
    cell.backgroundColor=[UIColor redColor];
    return cell;

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary*dic=self.dataArray[indexPath.row];
    
    DetailViewController*vc=[[DetailViewController alloc]init];
    vc.appID=dic[@"appid"];
    
    [self.navigationController pushViewController:vc animated:YES];

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
