//
//  IBeaconClient.h
//  weiChat
//
//  Created by ZhangCheng on 14/7/6.
//  Copyright (c) 2014年 张诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
@interface IBeaconClient : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager*locationManager;
    CLBeaconRegion*myBeaconRegion;
    
    //根据进出变化，比对是否数据变化
    BOOL isData;
}
@property(nonatomic,retain)NSMutableArray*dataArray;
@property(nonatomic,copy)void(^find)(int,NSDictionary*);
-(id)initWithBlock:(void(^)(int,NSDictionary*))a;
-(void)stopBeacon;
@end
