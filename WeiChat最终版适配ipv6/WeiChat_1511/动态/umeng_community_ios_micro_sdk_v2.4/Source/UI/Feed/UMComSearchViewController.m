//
//  UMComSearchViewController.m
//  UMCommunity
//
//  Created by umeng on 15-4-22.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComSearchViewController.h"
#import "UMComHorizontalTableView.h"
#import "UMComUsersTableViewController.h"
#import "UMComUserCenterViewController.h"
#import "UMComBarButtonItem.h"
#import "UMComShowToast.h"
#import "UIViewController+UMComAddition.h"
#import "UMComFeedDetailViewController.h"
#import "UMComPullRequest.h"


@interface UMComSearchViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) UMComHorizontalTableView *userTableView;

@property (nonatomic, strong) UMComPullRequest *userFetchRequest;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UMComBarButtonItem *rightButtonItem;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UIView *spaceLine;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) CGRect navigationBarOriginFrame;

@property (nonatomic, assign) CGRect naviOriginViewFrame;

@property (nonatomic, assign) BOOL firstTime;

@end

@implementation UMComSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstTime = YES;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = nil;
    //self.navigationItem.leftBarButtonItems = nil;
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-kUMComLoadMoreOffsetHeight);
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-160, 30)];
    searchBar.placeholder = UMComLocalizedString(@"Enter user or content key words", @"请输入用户或内容关键字");
    searchBar.backgroundImage = [[UIImage alloc] init];
    searchBar.delegate = self;
    [self.navigationItem setTitleView:searchBar];
    [searchBar becomeFirstResponder];
    self.searchBar = searchBar;
    UMComBarButtonItem *rightButtonItem = [[UMComBarButtonItem alloc] initWithTitle:@"取消" target:self action:@selector(goBack:)];
    rightButtonItem.customButtonView.frame = CGRectMake(10, 0, 40, 30);
    rightButtonItem.customButtonView.titleLabel.font = UMComFontNotoSansLightWithSafeSize(17);
    self.rightButtonItem = rightButtonItem;
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]init];
    spaceItem.width = 5;
    [self.navigationItem setRightBarButtonItems:@[spaceItem,rightButtonItem,spaceItem]];
    UISwipeGestureRecognizer *leftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(noAction)];
    leftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftGestureRecognizer];
    
    UISwipeGestureRecognizer *rightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(noAction)];
    rightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noAction)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.headView = [self creatHorizonTbaleView];
}

- (void)noAction
{
    [self.searchBar resignFirstResponder];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.userTableView) {
        [self creatHorizonTbaleView];
    }
    if (!_firstTime) {
        self.navigationController.view.frame = self.naviOriginViewFrame;
        self.navigationController.navigationBar.frame = self.navigationBarOriginFrame;
    }
    if (_firstTime) {
        _firstTime = NO;
        self.naviOriginViewFrame = self.navigationController.view.frame;
        self.navigationBarOriginFrame = self.navigationController.navigationBar.frame;
    }
    self.tableView.frame = self.navigationController.view.bounds;
    self.noDataTipLabel.text = @"没有找到相关内容";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    CGRect naviViewFrame = self.navigationController.view.frame;
    CGRect navigationBarFrame = self.navigationBarOriginFrame;
    if (self.navigationController.viewControllers.count > 1) {
        naviViewFrame.origin.y = 0;
        navigationBarFrame.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height;
        naviViewFrame.size.height = self.navigationController.view.frame.size.height - navigationBarFrame.size.height;
    }else{
        naviViewFrame = self.naviOriginViewFrame;
    }
    self.navigationController.navigationBar.frame = navigationBarFrame;
    self.navigationController.view.frame = naviViewFrame;
}

- (UIView *)creatHorizonTbaleView
{
    self.userTableView = [[UMComHorizontalTableView alloc]initWithFrame:CGRectMake(0, 0, 100, self.view.frame.size.width) style:UITableViewStylePlain];
    self.userTableView.rowHeight = self.userTableView.frame.size.width/4;
    __weak UMComSearchViewController *weakSelf = self;
    self.userTableView.didSelectedUser = ^(UMComUser *user){
        UIViewController *tempViewController = nil;
        if (user) {
            tempViewController = [[UMComUserCenterViewController alloc] initWithUser:user];
        }else{
            UMComUsersTableViewController *temSearchAllUserVc = [[UMComUsersTableViewController alloc]init];
            tempViewController.title = UMComLocalizedString(@"related_user", @"相关用户");
            temSearchAllUserVc.userList = weakSelf.userTableView.userList;
            tempViewController = temSearchAllUserVc;
        }
        [weakSelf.navigationController pushViewController:tempViewController animated:YES];
    };
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    [tableHeaderView addSubview:self.userTableView];
    self.userTableView.center = CGPointMake(tableHeaderView.frame.size.width/2, tableHeaderView.frame.size.height/2);
    UIView *spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 100-10, self.view.frame.size.width, 0.3)];
    spaceView.backgroundColor = UMComTableViewSeparatorColor;
    spaceView.hidden = YES;
    self.spaceLine = spaceView;
    [tableHeaderView addSubview:spaceView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 95, 60, 12)];
    label.backgroundColor = [UIColor clearColor];
    label.text = UMComLocalizedString(@"related_feed", @"相关消息");
    label.textColor = [UMComTools colorWithHexString:FontColorGray];
    label.font = UMComFontNotoSansLightWithSafeSize(12);
    [tableHeaderView addSubview:label];
    label.hidden = YES;
    self.titleLabel = label;
    return tableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.headView;
    }else{
        return 0;
    }
}

- (void)goBack:(id)sender
{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

#pragma mark - searchBarDelelagte
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [searchBar resignFirstResponder];
    self.titleLabel.hidden = YES;
    [self.userTableView searchUsersWithKeyWord:searchBar.text];
    [self searchFeedsWithKeyWord:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.titleLabel.hidden = YES;
    if (searchBar.text.length == 0) {
        [self.searchBar resignFirstResponder];
    }
}


- (void)searchFeedsWithKeyWord:(NSString *)keyWord
{
    self.searchText = keyWord;
    self.titleLabel.hidden = YES;
    self.fetchRequest = [[UMComSearchFeedRequest alloc]initWithKeywords:keyWord count:BatchSize];
    __weak typeof(self) weakSelf = self;
    [self refreshNewDataFromServer:^(NSArray *data, BOOL haveNextPage,NSError *error) {
        if (error) {
            weakSelf.titleLabel.hidden = YES;
            [UMComShowToast showFetchResultTipWithError:error];
        }else{
            if (data.count == 0) {
                weakSelf.titleLabel.hidden = YES;
            }else{
                weakSelf.titleLabel.hidden = NO;
            }
        }
        weakSelf.spaceLine.hidden = NO;
    }];
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
