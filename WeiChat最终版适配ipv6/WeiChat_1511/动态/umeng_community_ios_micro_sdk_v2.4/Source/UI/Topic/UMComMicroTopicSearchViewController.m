//
//  UMComMicroTopicSearchViewController.m
//  UMCommunity
//
//  Created by umeng on 16/2/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComMicroTopicSearchViewController.h"
#import "UMComSearchBar.h"
#import "UMComTools.h"
#import "UMComNavigationController.h"
#import "UMComPullRequest.h"
#import "UMComBarButtonItem.h"

@interface UMComMicroTopicSearchViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation UMComMicroTopicSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.placeholder = UMComLocalizedString(@"Search_topic", @"搜索话题");
    searchBar.delegate = self;
    searchBar.backgroundImage = [[UIImage alloc] init];
    [self.navigationItem setTitleView:searchBar];
    _searchBar = searchBar;
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:UMComImageWithImageName(@"search_frame")];
    self.fetchRequest = [[UMComSearchTopicRequest alloc]initWithKeywords:@""];
    
    UMComBarButtonItem *rightButtonItem = [[UMComBarButtonItem alloc] initWithTitle:@"取消" target:self action:@selector(goBack:)];
    rightButtonItem.customButtonView.frame = CGRectMake(10, 0, 40, 30);
    rightButtonItem.customButtonView.titleLabel.font = UMComFontNotoSansLightWithSafeSize(17);
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]init];
    spaceItem.width = 5;
    [self.navigationItem setRightBarButtonItems:@[spaceItem,rightButtonItem,spaceItem]];
    [_searchBar becomeFirstResponder];
    // Do any additional setup after loading the view.
    //搜索框左边为空，让其不显示
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.noDataTipLabel.hidden = YES;
    self.noDataTipLabel.text = nil;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [self.searchBar resignFirstResponder];
    self.noDataTipLabel.hidden = NO;
    self.noDataTipLabel.text = @"没有找到相关的话题";
    self.fetchRequest.keywords = searchBar.text;
    [self loadAllData:nil fromServer:nil];
}

- (void)goBack:(id)sender
{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
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
