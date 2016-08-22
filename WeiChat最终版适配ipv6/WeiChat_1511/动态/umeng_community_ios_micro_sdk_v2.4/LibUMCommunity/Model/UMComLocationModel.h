//
//  UMComLocation.h
//  UMCommunity
//
//  Created by umeng on 15/9/25.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UMComLocationModel : NSObject

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) NSInteger distance;

+ (UMComLocationModel *)locationWithFeedLocationDict:(NSDictionary *)feedLocationDict;

+ (UMComLocationModel *)locationWithLocationDict:(NSDictionary *)locationDict;

@end
