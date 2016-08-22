//
//  IBeaconServer.h
//  weiChat
//
//  Created by ZhangCheng on 14/7/5.
//  Copyright (c) 2014年 张诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
//服务端主要用于发出信号
@interface IBeaconServer : NSObject<CLLocationManagerDelegate,CBPeripheralManagerDelegate>
{
    
    CLBeaconRegion*myBeaconRegion;
    NSMutableDictionary*myBeaconData;
    CBPeripheralManager*peripheralMsg;
    
}
-(void)stopServer;
@end
