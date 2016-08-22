//
//  IBeaconServer.m
//  weiChat
//
//  Created by ZhangCheng on 14/7/5.
//  Copyright (c) 2014年 张诚. All rights reserved.
//

#import "IBeaconServer.h"

@implementation IBeaconServer
-(id)init{
    if (self=[super init]) {
//        //使用UUID生成及即可
        NSUUID*uuid=[[NSUUID alloc]initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E4"];
        
        
        int num=[[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID]intValue];
        CLBeaconMajorValue major=num>65535?num/65535:0;
        CLBeaconMinorValue minor=num>65535?num%65535:num;
        myBeaconRegion=[[CLBeaconRegion alloc]initWithProximityUUID:uuid major:major minor:minor identifier:[[NSBundle mainBundle] bundleIdentifier]];
        myBeaconData=[myBeaconRegion peripheralDataWithMeasuredPower:nil];

        peripheralMsg=[[CBPeripheralManager  alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
        
    }
    return self;

}
-(void)dealloc{
    [self stopServer];
}
-(void)stopServer{
    [peripheralMsg stopAdvertising];
    
}
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{

    if (peripheral.state==CBPeripheralManagerStatePoweredOn) {
        [peripheralMsg startAdvertising:myBeaconData];
    }else{
    
        if (peripheralMsg.state==CBPeripheralManagerStatePoweredOff) {
            [peripheralMsg stopAdvertising];
        }
    }
}
@end
