//
//  IBeaconClient.m
//  weiChat
//
//  Created by ZhangCheng on 14/7/6.
//  Copyright (c) 2014年 张诚. All rights reserved.
//

#import "IBeaconClient.h"

@implementation IBeaconClient
-(id)init{
    if (self=[super init]) {
        self.dataArray=[NSMutableArray arrayWithCapacity:0];
        locationManager=[[CLLocationManager alloc]init];
        locationManager.delegate=self;
        NSUUID*uuid=[[NSUUID alloc]initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E4"];
        myBeaconRegion=[[CLBeaconRegion alloc]initWithProximityUUID:uuid identifier:[[NSBundle mainBundle] bundleIdentifier]];
        [locationManager startMonitoringForRegion:myBeaconRegion];
        [locationManager requestStateForRegion:myBeaconRegion];
        [locationManager startRangingBeaconsInRegion:myBeaconRegion];
    
    }
    return self;
}
-(id)initWithBlock:(void(^)(int,NSDictionary*))a{
    self.find=a;
    return [self init];
}
-(void)dealloc
{
    [self stopBeacon];
    
}
-(void)stopBeacon{
    [locationManager stopMonitoringForRegion:myBeaconRegion];
    [locationManager stopRangingBeaconsInRegion:myBeaconRegion];
    [locationManager stopUpdatingLocation];
    locationManager.delegate=nil;

}
-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    switch (state) {
        case CLRegionStateInside:
            NSLog(@"在里面");
            break;
        case CLRegionStateOutside:
            NSLog(@"在外面");
            break;
        case CLRegionStateUnknown:
            NSLog(@"无法知道在什么位置");
            break;
        default:
            break;
    }

}
//每次定位的距离
-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSLog(@"扫描中。。。%ld",beacons.count);
    if (self.dataArray.count!=beacons.count) {
        if (self.dataArray.count>beacons.count) {
            //离开区域
            NSMutableArray*tempArray=[NSMutableArray arrayWithArray:self.dataArray];
            for (CLBeacon*beacon in beacons) {
                NSDictionary*dic=[self makeData:beacon];
                [tempArray removeObject:dic];
                
            }

            //剩下的tempArray就是离开的
            if (tempArray.count) {
                [self.dataArray removeObject:[tempArray firstObject]];
                self.find(2,[tempArray firstObject]);
            }
        }
        if (self.dataArray.count<beacons.count) {
            //进入区域
            for (CLBeacon*beacon in beacons) {
                NSDictionary*dic=[self makeData:beacon];
                BOOL isBeing=[self.dataArray containsObject:dic];
                if (!isBeing) {
                    [self.dataArray addObject:dic];
                    self.find(1,dic);
                }
                
            }
        }
        
    }
    

}
-(NSDictionary*)makeData:(CLBeacon*)beacon{
    //生成账号
    int major=[beacon.major intValue];
    int minor=[beacon.minor intValue];
    
    NSString*useName=[NSString stringWithFormat:@"%d",major>0?major*65535+minor:minor];
    NSString*proximity=[NSString stringWithFormat:@"%ld",(long)beacon.proximity];
    NSString*accuracy=[NSString stringWithFormat:@"距离我多远 %0.4f\n",beacon.accuracy];
    NSString*rssi=[NSString stringWithFormat:@"信号强度%ld",(long)beacon.rssi];
    
    return @{@"useName": useName,@"proximity":proximity,@"accuracy":accuracy,@"rssi":rssi};
    

}
-(void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"开启失败");
    self.find(0,nil);
    
}
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"进入到一个iBeacon区域");

}
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"离开一个IBeacon区域");
}



@end
