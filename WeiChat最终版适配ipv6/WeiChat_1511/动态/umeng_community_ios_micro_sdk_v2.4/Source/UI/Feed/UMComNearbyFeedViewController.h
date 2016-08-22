//
//  UMComNearbyFeedViewController.h
//  UMCommunity
//
//  Created by umeng on 15/7/9.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComFeedTableViewController.h"
#import <CoreLocation/CLLocation.h>

@interface UMComNearbyFeedViewController : UMComFeedTableViewController

- (instancetype)initWithLocation:(CLLocation *)location
                           title:(NSString *)title;

@end
