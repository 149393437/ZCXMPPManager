//
//  UMComEditTopicsViewController.m
//  UMCommunity
//
//  Created by luyiyuan on 14/9/22.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMComEditTopicsViewController.h"
#import "UMComSession.h"
#import "UMComTopic.h"
#import "UMComEditTopicsTableViewCell.h"
#import "UMComPullRequest.h"
#import "UMComShowToast.h"
#import "UIViewController+UMComAddition.h"
#import <UIKit/UISearchDisplayController.h>
#import "UMComSearchBar.h"

@interface UMComEditTopicsViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, copy) void (^complectionBlock)(UMComTopic *topic);

//NS_CLASS_DEPRECATED_IOS(3_0, 8_0) 8.0之前
@property(nonatomic,strong) UISearchDisplayController* searchDisplayController;
//8.0以后
@property (nonatomic, strong) NSMutableArray *filterData;
@property(nonatomic,strong) UMComSearchBar* searchBar;

-(void) createTopicSearchbar;
-(void) creatSearchBar;
@end

@implementation UMComEditTopicsViewController


- (instancetype)initWithTopicSelectedComplectionBlock:(void (^)(UMComTopic *))block
{
    self = [super init];
    if (self) {
        self.complectionBlock = block;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self setTitleViewWithTitle:@"话题"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UMComEditTopicsTableViewCell" bundle:nil] forCellReuseIdentifier:@"EditTopicsCell"];
    self.tableView.rowHeight = 45;
    self.fetchRequest = [[UMComAllTopicsRequest alloc] initWithCount:BatchSize];
    [self loadAllData:nil fromServer:nil];
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //method1:using UISearchDisplayController
    UITableView* searchtableview = self.searchDisplayController.searchResultsTableView;
    if (tableView != searchtableview) {
        return self.dataArray.count;
    }else{
        return self.filterData.count;
    }
    
    //method2:using UISearchController
//    if (self.searchController.active)
//    {
//        return self.filterData.count;
//    }
//    else
//    {
//        return self.dataArray.count;
//    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"EditTopicsCell";
    UMComEditTopicsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UMComEditTopicsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = @"";
    
    //method1:using UISearchDisplayController
    UITableView* searchtableview = self.searchDisplayController.searchResultsTableView;
    if (tableView != searchtableview)  {
        [cell setWithTopic:self.dataArray[indexPath.row]];
    }
    else
    {
        [cell setWithTopic:self.filterData[indexPath.row]];
    }
    
    //method2:using UISearchController
//    if (!self.searchController.active) {
//        [cell setWithTopic:self.dataArray[indexPath.row]];
//    }else{
//        [cell setWithTopic:self.filterData[indexPath.row]];
//    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchDisplayController setActive:NO animated:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UMComTopic *topic = self.dataArray[indexPath.row];
    
    if (self.complectionBlock) {
        self.complectionBlock(topic);
    }
}

#pragma mark - 搜索相关
-(void) createTopicSearchbar
{
    // 添加 searchbar 到 headerview
    self.tableView.tableHeaderView = self.searchBar;
    
    // 用 searchbar 初始化 SearchDisplayController
    // 并把 searchDisplayController 和当前 controller 关联起来
    self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    self.searchDisplayController.delegate = self;
    
    // searchResultsDataSource 就是 UITableViewDataSource
    self.searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    self.searchDisplayController.searchResultsDelegate = self;
    
    self.filterData = [NSMutableArray array];
    
    self.searchDisplayController.searchBar.barTintColor = [UIColor colorWithPatternImage:UMComImageWithImageName(@"search_frame")];
    
    UITableView* searchtableview= self.searchDisplayController.searchResultsTableView;
    [searchtableview registerNib:[UINib nibWithNibName:@"UMComEditTopicsTableViewCell" bundle:nil] forCellReuseIdentifier:@"EditTopicsCell"];
    searchtableview.rowHeight = 45;
    
    
    //method2:using UISearchController
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchController.searchResultsUpdater = self;
//    self.searchController.dimsBackgroundDuringPresentation = false;
//    [self.searchController.searchBar sizeToFit];
//    self.searchController.searchBar.backgroundColor = [UIColor lightGrayColor];
//    self.tableView.tableHeaderView = self.searchController.searchBar;
    
//      self.searchController.searchBar.barTintColor = [UIColor colorWithPatternImage:UMComImageWithImageName(@"search_frame")];
}

- (void)creatSearchBar
{
    UMComSearchBar *searchBar =
    [[UMComSearchBar alloc] initWithFrame:CGRectMake(0, 0 ,self.view.frame.size.width, 44)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.placeholder = UMComLocalizedString(@"Search topic", @"搜索话题");
    searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    searchBar.delegate = self;
    self.searchBar = searchBar;
}

#pragma mark - UISearchBarDelegate

#pragma mark - UISearchResultsUpdating
//method2:using UISearchController
//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
//{
//    [self.filterData removeAllObjects];
//    NSString* searchText = @"";
//    if (self.searchController.searchBar.text) {
//        searchText = self.searchController.searchBar.text;
//    }
//    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[c] %@", searchText];
//    self.filterData = [[self.dataArray filteredArrayUsingPredicate:searchPredicate] mutableCopy];
//    
//    [self.tableView reloadData];
//}

#pragma mark - UISearchDisplayDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"searchString = %@",searchString);
    
//    // 谓词搜索
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[c] %@",searchString];
//    self.filterData =  [[self.dataArray filteredArrayUsingPredicate:predicate] mutableCopy];
//    [self.tableView reloadData];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString* searchString = @"";
    if (searchBar.text) {
        searchString = searchBar.text;
    }
    
    // 谓词搜索
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[c] %@",searchString];
    self.filterData =  [[self.dataArray filteredArrayUsingPredicate:predicate] mutableCopy];
    
    [self.searchDisplayController.searchResultsTableView reloadData];
}

@end
