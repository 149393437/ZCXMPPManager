//
//  RadarViewController.h
//  weiChat
//
//  Created by ZhangCheng on 14/6/27.
//  Copyright (c) 2014年 张诚. All rights reserved.
//

#import "RootViewController.h"
#import "IBeaconClient.h"
#import "IBeaconServer.h"
@interface RadarViewController : RootViewController<UIAlertViewDelegate>
{
    NSTimer*timer;
    UIImageView*radarDisCoverImageView;
    UIImageView*radarImageView;
    int rotation;
    IBeaconClient*client;
    IBeaconServer*server;
    
}
@property(nonatomic,retain)NSMutableArray*dataArray;
@end
