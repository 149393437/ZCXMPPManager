//
//  RootViewController.h
//  LimitFreeProject
//
//  Created by zhangcheng on 16/2/16.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFRootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    //表格
    UITableView*_tableView;
    //下拉刷新
    MJRefreshHeaderView*header;
    //上拉刷新
    MJRefreshFooterView*footer;
    

}
//数据源
@property(nonatomic,strong)NSMutableArray*dataArray;
//传入不同的参数
@property(nonatomic,copy)NSString*urlStr;

@end







