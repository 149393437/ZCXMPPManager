//
//  UMComLocationTableViewController1.m
//  UMCommunity
//
//  Created by umeng on 15/8/7.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComLocationListController.h"
#import <CoreLocation/CoreLocation.h>
#import "UMComLocationTableViewCell.h"
#import "UMComShowToast.h"
#import "UMUtils.h"
#import "UIViewController+UMComAddition.h"
#import "UMComLocationModel.h"
#import "UMComPullRequest.h"


@interface UMComLocationListController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, copy) void (^complectionBlock)(UMComLocationModel *locationModel);

@end

@implementation UMComLocationListController
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted
        || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [[[UIAlertView alloc] initWithTitle:nil message:UMComLocalizedString(@"No location",@"此应用程序没有权限访问地理位置信息，请在隐私设置里启用") delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
    }
    if (NO==[CLLocationManager locationServicesEnabled]) {
        UMLog(@"---------- 未开启定位");
    }
    [self setTitleViewWithTitle:UMComLocalizedString(@"LocationTitle",@"我的位置")];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 15.0f;
    
    [_locationManager startUpdatingLocation];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UMComLocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"LocationTableViewCell"];
    
    if (!([CLLocationManager locationServicesEnabled] == YES  && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)){
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    self.tableView.rowHeight = LocationCellHeight;
    self.loadMoreStatusView = nil;
}

- (id)initWithLocationSelectedComplectionBlock:(void (^)(UMComLocationModel *locationModel))block
{
    self = [super init];
    if (self) {
        self.complectionBlock = block;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return 0;
    }
    return self.dataArray.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"LocationTableViewCell";
    UMComLocationTableViewCell *cell = (UMComLocationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.locationName.center = CGPointMake(cell.locationName.center.x, tableView.rowHeight/2);
        cell.locationName.text = @"不显示位置";
        cell.locationDetail.hidden = YES;
        cell.locationName.textColor = [UMComTools colorWithHexString:FontColorBlue];
    }else{
        UMComLocationModel *locationModel = self.dataArray[indexPath.row-1];
        cell.locationName.textColor = [UIColor blackColor];
        cell.locationName.center = CGPointMake(cell.locationName.center.x, (tableView.rowHeight-cell.locationDetail.frame.size.height)/2);
        cell.locationDetail.hidden = NO;
        [cell reloadFromLocationModel:locationModel];
    }
    return cell;
}

#pragma mark - locationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    self.fetchRequest = [[UMComLocationRequest alloc]initWithLocation:manager.location];
    [self refreshNewDataFromServer:nil];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [UMComShowToast fetchFailWithNoticeMessage:UMComLocalizedString(@"fail to location",@"定位失败")];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > 0) {
        UMComLocationModel *locationModel = self.dataArray[indexPath.row-1];
//        self.editViewModel.locationDescription = locationModel.name;
        if (self.complectionBlock) {
            self.complectionBlock(locationModel);
        }
    }else{
//        self.editViewModel.locationDescription = @"";
        if (self.complectionBlock) {
            self.complectionBlock(nil);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
