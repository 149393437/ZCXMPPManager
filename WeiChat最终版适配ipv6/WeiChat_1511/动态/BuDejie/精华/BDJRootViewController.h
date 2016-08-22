//
//  RootViewController.h
//  BuDeJie_1511
//
//  Created by zhangcheng on 16/1/29.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDJRootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*_tableView;
    //下拉刷新
    MJRefreshHeaderView*header;
    //上拉加载
    MJRefreshFooterView*footer;
    
    UIView*headerBgView;

}
@property(nonatomic,strong)NSMutableArray*dataArray;
@property(nonatomic,copy)NSString*type;
//传入参数
@property(nonatomic,strong)NSDictionary*dic;
@end








