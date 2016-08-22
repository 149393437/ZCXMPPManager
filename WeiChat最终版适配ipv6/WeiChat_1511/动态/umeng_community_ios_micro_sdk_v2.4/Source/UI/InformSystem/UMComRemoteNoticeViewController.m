//
//  UMComRemoteNoticeViewController.m
//  UMCommunity
//
//  Created by umeng on 15/7/9.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComRemoteNoticeViewController.h"
#import "UIViewController+UMComAddition.h"
#import "UMComTools.h"
#import "UMComNotification.h"
#import "UMComImageView.h"
#import "UMComMutiStyleTextView.h"
#import "UMComUser.h"
#import "UMComTools.h"
#import "UMComPullRequest.h"
#import "UMComSession.h"
#import "UMComClickActionDelegate.h"
#import "UMComUser+UMComManagedObject.h"
#import "UMComUnReadNoticeModel.h"



const float CellSubViewOriginX = 50;
const float CellSubViewRightSpace = 10;
const float NameLabelHeight = 30;
const float ContentOriginY = 15;

@interface UMComRemoteNoticeViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) NSMutableArray *styleViewList;

@end

@implementation UMComRemoteNoticeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.styleViewList = [NSMutableArray array];
    
    [self setTitleViewWithTitle:UMComLocalizedString(@"manager_notification", @"管理员通知")];
    self.fetchRequest = [[UMComUserNotificationRequest alloc]initWithCount:BatchSize];
    [self loadAllData:nil fromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
        [UMComSession sharedInstance].unReadNoticeModel.notiByAdministratorCount = 0;
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UMComSysNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UMComSysNotificationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell reloadCellWithNotification:self.dataArray[indexPath.row] styleView:self.styleViewList[indexPath.row] viewWidth:tableView.frame.size.width];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMComMutiText *styleView = self.styleViewList[indexPath.row];
    return styleView.textSize.height + ContentOriginY * 3/2 + NameLabelHeight;
}

#pragma mark - data fecth
- (void)handleCoreDataDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler
{
    if ([data isKindOfClass:[NSArray class]] &&  data.count > 0) {
        [self.styleViewList removeAllObjects];
        if ([data isKindOfClass:[NSArray class]]) {
            self.dataArray = data;
            [self.styleViewList addObjectsFromArray:[self styleViewListWithNotifications:data]];
        }
    }
    if (finishHandler) {
        finishHandler();
    }else{
        [self.tableView reloadData];
    }
}

- (void)handleServerDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler
{
    if (!error && [data isKindOfClass:[NSArray class]]) {
        [self.styleViewList removeAllObjects];
        if ([data isKindOfClass:[NSArray class]]) {
            self.dataArray = data;
            [self.styleViewList addObjectsFromArray:[self styleViewListWithNotifications:data]];
        }
    }
    if (finishHandler) {
        finishHandler();
    }else{
        [self.tableView reloadData];
    }
}

- (void)handleLoadMoreDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataArray];
    if (!error && [data isKindOfClass:[NSArray class]]) {
        [tempArray addObjectsFromArray:data];
        [self.styleViewList addObjectsFromArray:[self styleViewListWithNotifications:data]];
    }
    self.dataArray = tempArray;
    if (finishHandler) {
        finishHandler();
    }else{
        [self.tableView reloadData];
    }
}


- (NSArray *)styleViewListWithNotifications:(NSArray *)notifications
{
    NSMutableArray *styleViews = [NSMutableArray arrayWithCapacity:notifications.count];
    for (UMComNotification *notification in notifications) {
        UMComMutiText *styleView = [UMComMutiText mutiTextWithSize:CGSizeMake(self.tableView.frame.size.width-CellSubViewOriginX-CellSubViewRightSpace, MAXFLOAT) font:UMComFontNotoSansLightWithSafeSize(13) string:notification.content lineSpace:2 checkWords:nil textColor:UMComColorWithColorValueString(@"#999999")];
        [styleViews addObject:styleView];
    }
   return styleViews;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



@implementation UMComSysNotificationCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.portrait = [[[UMComImageView imageViewClassName] alloc]initWithFrame:CGRectMake(10, ContentOriginY, 30, 30)];
        self.portrait.userInteractionEnabled = YES;
        self.portrait.layer.cornerRadius = self.portrait.frame.size.width/2;
        self.portrait.clipsToBounds = YES;
        [self.contentView addSubview:self.portrait];
        
        self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CellSubViewOriginX, ContentOriginY, self.frame.size.width-CellSubViewOriginX-10-120, NameLabelHeight)];
        self.userNameLabel.font = UMComFontNotoSansLightWithSafeSize(16);
        self.userNameLabel.textColor = UMComColorWithColorValueString(@"#333333");
        [self.contentView addSubview:self.userNameLabel];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CellSubViewOriginX+self.userNameLabel.frame.size.width, ContentOriginY, 120, NameLabelHeight)];
        self.timeLabel.textColor = UMComColorWithColorValueString(@"#A5A5A5");
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.font = UMComFontNotoSansLightWithSafeSize(10);
        [self.contentView addSubview:self.timeLabel];
        
        self.contentTextView = [[UMComMutiStyleTextView alloc] initWithFrame:CGRectMake(CellSubViewOriginX, ContentOriginY + self.userNameLabel.frame.size.height+10, self.frame.size.width-60, 100)];
        self.contentTextView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.contentTextView];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)reloadCellWithNotification:(UMComNotification *)notification styleView:(UMComMutiText *)mutiText viewWidth:(CGFloat)viewWidth
{
    UMComUser *user = notification.creator;
    NSString *iconUrl = [user iconUrlStrWithType:UMComIconSmallType];
    [self.portrait setImageURL:iconUrl placeHolderImage:[UMComImageView placeHolderImageGender:user.gender.integerValue]];
    self.userNameLabel.text = user.name;
    self.timeLabel.text = createTimeString(notification.create_time);
    self.userNameLabel.frame = CGRectMake(CellSubViewOriginX, ContentOriginY/2, viewWidth-120-CellSubViewOriginX, NameLabelHeight);
    self.timeLabel.frame = CGRectMake(CellSubViewOriginX+self.userNameLabel.frame.size.width-10, ContentOriginY/2, 120, NameLabelHeight);
    self.contentTextView.frame = CGRectMake(CellSubViewOriginX, self.userNameLabel.frame.size.height+self.userNameLabel.frame.origin.y, viewWidth-CellSubViewOriginX-10, mutiText.textSize.height);
    [self.contentTextView setMutiStyleTextViewWithMutiText:mutiText];
    self.contentTextView.clickOnlinkText = ^(UMComMutiStyleTextView *styleView,UMComMutiTextRun *run){
    };
}


@end
