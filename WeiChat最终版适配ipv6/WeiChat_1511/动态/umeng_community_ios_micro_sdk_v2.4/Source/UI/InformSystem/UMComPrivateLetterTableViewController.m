//
//  UMComPrivateLetterTableViewController.m
//  UMCommunity
//
//  Created by umeng on 15/11/30.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComPrivateLetterTableViewController.h"
#import "UMComImageView.h"
#import "UMComPullRequest.h"
#import "UMComSession.h"
#import "UMComUser+UMComManagedObject.h"
#import "UMComPrivateLetter.h"
#import "UMComPrivateMessage.h"
#import "UMComImageUrl.h"
#import "UMComPrivateChatTableViewController.h"
#import "UMComUser+UMComManagedObject.h"
#import "UIViewController+UMComAddition.h"
#import "UMComShowToast.h"
#import "UMComSysPrivateLetterCell.h"


@interface UMComPrivateLetterTableViewController ()

@end

@implementation UMComPrivateLetterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UMCom_Forum_LetterList_Cell_Height;
    
    [self setForumUITitle:UMComLocalizedString(@"UM_Forum_Private_Letter_Title", @"私信管理员")];
    self.fetchRequest = [[UMComPrivateLetterRequest alloc]initWithCount:BatchSize];
    [self loadAllData:nil fromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
    }];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UMComSysPrivateLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UMComSysPrivateLetterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellSize:CGSizeMake(tableView.frame.size.width, tableView.rowHeight)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell reloadCellWithPrivateLetter:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMComPrivateChatTableViewController *privateViewController = [[UMComPrivateChatTableViewController alloc]initWithPrivateLetter:self.dataArray[indexPath.row]];//
    [self.navigationController pushViewController:privateViewController animated:YES];
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

