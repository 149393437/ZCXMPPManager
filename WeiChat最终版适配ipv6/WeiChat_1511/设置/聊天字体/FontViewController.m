//
//  FontViewController.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/4/4.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "FontViewController.h"
#import "BubbleDownLoadCell.h"
@interface FontViewController ()
{
}
@property(nonatomic,strong)NSMutableArray*dataArray;

@end

@implementation FontViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:FONT object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置字体";
    
    
    [[NSNotificationCenter defaultCenter]addObserver:_tableView selector:@selector(reloadData) name:FONT object:nil];
    _tableView.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
}

-(void)loadData{
    
    HttpDownLoad*http=[[HttpDownLoad alloc]initWithURLStr:@"http://i.gtimg.cn/qqshow/admindata/comdata/vipList_font_data/xydata.all.v2.js" Post:NO DataDic:nil Block:^(HttpDownLoad *xx, BOOL isOk) {
        if (isOk) {
            //data进行转换
            NSString*str=[[NSString alloc]initWithData:xx.data encoding:NSUTF8StringEncoding];
            //查找{
            NSRange range=[str rangeOfString:@"{"];
            //进行截取
            NSString*newStr=[str substringWithRange:NSMakeRange(range.location,str.length-range.location)];
            
            //进行数据解析
            NSDictionary*dic=[NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            NSDictionary*dic1=dic[@"detailList"];
            
            NSArray*array=[dic1 allValues];
            
            NSMutableArray*tempArray=[NSMutableArray array];
            
            self.dataArray=[NSMutableArray array];
            
            //损坏的主题编号
            //            NSArray*failArray=[[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FailThemeList" ofType:@"plist"]]allKeys];
            
            for (int i=0; i<array.count; i++) {
                //如果数量为3时候,小数组追加到大数组中,如果不等3,就继续在小数组中保存
                if (tempArray.count==2) {
                    [self.dataArray addObject:tempArray];
                    tempArray=[NSMutableArray array];
                }
                //屏蔽掉默认字体
                if (![array[i][@"baseInfo"][@"id"] isEqualToString:@"0"]) {
                    [tempArray addObject:array[i]];
    
                }
                
            }
            if (tempArray.count) {
                [self.dataArray addObject:tempArray];
            }
            
            [_tableView reloadData];
            
            
            
        }
    }];
    http=nil;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BubbleDownLoadCell*cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[BubbleDownLoadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    //每次需要读取2个数据源
    [cell configFontWithArray:self.dataArray[indexPath.row]];
    return cell;
    
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
