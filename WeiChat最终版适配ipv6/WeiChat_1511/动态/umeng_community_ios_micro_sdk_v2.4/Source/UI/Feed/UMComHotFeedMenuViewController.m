//
//  UMComHotFeedMenuViewController.m
//  UMCommunity
//
//  Created by umeng on 16/1/20.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComHotFeedMenuViewController.h"
#import "UMComPullRequest.h"
#import "UMComFeedTableViewController.h"
#import "UMComTopic.h"
#import "UIViewController+UMComAddition.h"
#import "UMComTopFeedTableViewHelper.h"
#import "UMComSegmentedControl.h"

@interface UMComHotFeedMenuViewController ()

@property (nonatomic, assign) NSInteger lastPage;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation UMComHotFeedMenuViewController

- (instancetype)initWithTopic:(UMComTopic *)topic
{
    self = [super init];
    if (self) {
        _topic = topic;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    if (!self.topic) {
        [self createHotFeedsSubViewControllers];
    }else{
        [self createTopicHotFeedsSubViewControllers];
    }
}

- (void)setPage:(NSInteger)page
{
    _lastPage = _currentPage;
    _currentPage = page;
    [self transitionFromViewControllers];
}

- (void)transitionFromViewControllers
{
    [self transitionFromViewControllerAtIndex:self.lastPage toViewControllerAtIndex:self.currentPage duration:0.2 options:UIViewAnimationOptionTransitionNone animations:nil completion:nil];
}

//全局热门Feed列表
- (void)createHotFeedsSubViewControllers
{
    CGRect commonFrame = self.view.bounds;
    for (int index = 0; index < 4; index ++) {
        UMComFeedTableViewController *feedTableViewC = [[UMComFeedTableViewController alloc] init];
        feedTableViewC.feedCellBgViewTopEdge = 0;
        feedTableViewC.isLoadLoacalData = NO;
        feedTableViewC.isShowEditButton = YES;
        UMComHotFeedRequest *hotFeedRequest = [[UMComHotFeedRequest alloc]initWithCount:BatchSize withinDays:1];
        if (index == 0) {
            hotFeedRequest.days = 1;
            feedTableViewC.isAutoStartLoadData = YES;
            [self.view addSubview:feedTableViewC.view];
        }else if (index == 1){
            commonFrame.origin.x = self.view.frame.size.width;
            hotFeedRequest.days = 3;
        }else if (index == 2){
            hotFeedRequest.days = 7;
        }else if (index == 3){
            hotFeedRequest.days = 30;
        }
        feedTableViewC.fetchRequest = hotFeedRequest;
        feedTableViewC.view.frame = commonFrame;
        [self addChildViewController:feedTableViewC];
        
        
        //添加置顶类---begin
        UMComTopFeedTableViewHelper* tempTopFeedTableViewHelper =  [[UMComTopFeedTableViewHelper alloc] init];
        tempTopFeedTableViewHelper.topFeedRequest = [[UMComTopFeedRequest alloc] initwithTopFeedCountCount:BatchSize];
        feedTableViewC.topFeedTableViewHelper = tempTopFeedTableViewHelper;
        feedTableViewC.showTopMark = YES;
        //添加置顶类---end
    }
    [self transitionFromViewControllers];
}

//话题热门feed列表
- (void)createTopicHotFeedsSubViewControllers
{
    UMComSegmentedControl *segmentedControl = [[UMComSegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"1天内",@"3天内",@"7天内",@"30天内", nil]];
    segmentedControl.frame = CGRectMake(40, 0, self.view.frame.size.width - 80, 27);
    [self.view addSubview:segmentedControl];
    [segmentedControl addTarget:self action:@selector(didSelectedHotFeedPage:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.tintColor = UMComColorWithColorValueString(@"#008BEA");
    [segmentedControl setfont:UMComFontNotoSansLightWithSafeSize(14) titleColor:UMComColorWithColorValueString(@"#008BEA") selectedColor:[UIColor whiteColor]];
    [self.view addSubview:segmentedControl];
    
    CGRect commonFrame = self.view.bounds;
    commonFrame.origin.y = segmentedControl.frame.size.height + segmentedControl.frame.origin.y + UMCom_Micro_Feed_Cell_Space;
    commonFrame.size.height = self.view.frame.size.height - commonFrame.origin.y;
    for (int index = 0; index < 4; index ++) {
        UMComFeedTableViewController *feedTableViewC = [[UMComFeedTableViewController alloc] init];
        feedTableViewC.isLoadLoacalData = NO;
        feedTableViewC.isShowEditButton = YES;
        feedTableViewC.feedCellBgViewTopEdge = 2;
        UMComTopicHotFeedsRequest *hotFeedRequest = [[UMComTopicHotFeedsRequest alloc]initWithTopicId:self.topic.topicID count:BatchSize withinDays:1];
        if (index == 0) {
            feedTableViewC.isAutoStartLoadData = YES;
            [self.view addSubview:feedTableViewC.view];
        }else if (index == 1){
            commonFrame.origin.x = self.view.frame.size.width;
            hotFeedRequest.days = 3;
        }else if (index == 2){
            hotFeedRequest.days = 7;
        }else if (index == 3){
            hotFeedRequest.days = 30;
        }
        feedTableViewC.fetchRequest = hotFeedRequest;
        feedTableViewC.view.frame = commonFrame;
        [self addChildViewController:feedTableViewC];
    }
    [self transitionFromViewControllers];
}


- (void)didSelectedHotFeedPage:(UISegmentedControl *)sender
{
    [self setPage:sender.selectedSegmentIndex];
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
