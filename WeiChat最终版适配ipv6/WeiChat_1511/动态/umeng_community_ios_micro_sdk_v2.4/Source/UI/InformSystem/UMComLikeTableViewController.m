//
//  UMComLikeTableViewController.m
//  UMCommunity
//
//  Created by umeng on 15/12/22.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComLikeTableViewController.h"
#import "UMComLike.h"
#import "UMComPullRequest.h"
#import "UMComClickActionDelegate.h"
#import "UMComUnReadNoticeModel.h"
#import "UMComSession.h"
#import "UIViewController+UMComAddition.h"
#import "UMComWebViewController.h"
#import "UMComUserCenterViewController.h"
#import "UMComTopicFeedViewController.h"
#import "UMComFeedDetailViewController.h"
#import "UMComLike.h"
#import "UMComSysCommonTableViewCell.h"
#import "UMComSysLikeTableViewCell.h"
#import "UMComMutiStyleTextView.h"
#import "UMComFeed.h"
#import "UMComTopic.h"


@interface UMComLikeTableViewController ()<UITableViewDelegate, UMComClickActionDelegate>

- (NSDictionary *)likeDictDictionaryWithLike:(UMComLike *)like;

@end

@implementation UMComLikeTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setForumUITitle:UMComLocalizedString(@"UMCom_Forum_Like", @"收到的赞")];
    
    self.fetchRequest = [[UMComUserLikesReceivedRequest alloc]initWithCount:BatchSize];
    [self loadAllData:nil fromServer:nil];
    // Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellID = @"cellID";
//    UMComSysLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[UMComSysLikeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    }
//    cell.delegate = self;
//    [cell reloadCellWithLikeModel:self.dataArray[indexPath.row]];
//    return cell;
    
    static NSString *cellID = @"cellID";
    UMComSysLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UMComSysLikeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellSize:CGSizeMake(tableView.frame.size.width, tableView.rowHeight)];
    }
    cell.delegate = self;
    NSDictionary *likeDict = self.dataArray[indexPath.row];
    [cell reloadCellWithObj:[likeDict valueForKey:@"like"]
                 timeString:[likeDict valueForKey:@"creat_time"]
                   mutiText:nil
               feedMutiText:[likeDict valueForKey:@"feedMutiText"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UMComLikeModel *likeModle = self.dataArray[indexPath.row];
//    return likeModle.totalHeight;
    NSDictionary *likeDict = self.dataArray[indexPath.row];
    return [[likeDict valueForKey:@"totalHeight"] floatValue];
}

#pragma mark - data handler

- (void)handleCoreDataDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler
{
    if ([data isKindOfClass:[NSArray class]] &&  data.count > 0) {
        self.dataArray = [self likeModelListWithLikes:data];
    }
    if (finishHandler) {
        finishHandler();
    }
}

- (void)handleServerDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler
{
    if (!error) {
        [UMComSession sharedInstance].unReadNoticeModel.notiByLikeCount = 0;
        self.dataArray = [self likeModelListWithLikes:data];
    }
    if (finishHandler) {
        finishHandler();
    }
}

- (void)handleLoadMoreDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler
{
    if (!error && [data isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataArray];
        [tempArray addObjectsFromArray:[self likeModelListWithLikes:data]];
        self.dataArray = tempArray;
    }
    if (finishHandler) {
        finishHandler();
    }
}

- (NSArray *)likeModelListWithLikes:(NSArray *)likes
{
//    if ([likes isKindOfClass:[NSArray class]] && likes.count > 0) {
//        NSMutableArray *likeModels = [NSMutableArray arrayWithCapacity:likes.count];
//        for (UMComLike *like in likes) {
//            UMComLikeModel *likeModel = [UMComLikeModel likeModelWithLike:like viewWidth:self.view.frame.size.width];
//            [likeModels addObject:likeModel];
//        }
//        return likeModels;
//    }
//    return nil;
    
    if ([likes isKindOfClass:[NSArray class]] && likes.count > 0) {
        NSMutableArray *likeModels = [NSMutableArray arrayWithCapacity:likes.count];
        for (UMComLike *like in likes) {
            NSDictionary *commentDict = [self likeDictDictionaryWithLike:like];
            [likeModels addObject:commentDict];
        }
        return likeModels;
    }
    return nil;
}

- (NSDictionary *)likeDictDictionaryWithLike:(UMComLike *)like
{
    NSMutableDictionary *commentDict = [NSMutableDictionary dictionary];
    CGFloat totalHeight = UMCom_SysCommonCell_Comment_UserNameTopMargin +
    UMCom_SysCommonCell_Comment_UserNameHeight +
    UMCom_SysCommonCell_Comment_SpaceBetweenUserNameAndComment;
    
    
    //加入默认的高度来填写文字：赞了这条评论
    totalHeight += UMCom_SysCommonCell_Comment_CommentDefaultHeight;
    
    //累加评论底部的边距
    totalHeight += UMCom_SysCommonCell_Comment_CommentBotoom;
    
    //获得feed相关的
    NSMutableArray *feedCheckWords = nil;
    UMComFeed *feed = like.feed;
    
    //获得feed的内容
    NSString *feedString = @"";
    if (feed.text) {
        feedString = feed.text;
    }
    
    if ([feed.status integerValue] < FeedStatusDeleted) {
        if (feedString.length > kFeedContentLength) {
            feedString = [feedString substringWithRange:NSMakeRange(0, kFeedContentLength)];
        }
        feedCheckWords = [NSMutableArray array];
        for (UMComTopic *topic in feed.topics) {
            NSString *topicName = [NSString stringWithFormat:TopicString,topic.name];
            [feedCheckWords addObject:topicName];
        }
        for (UMComUser *user in feed.related_user) {
            NSString *userName = [NSString stringWithFormat:UserNameString,user.name];
            [feedCheckWords addObject:userName];
        }
        //加入feed创建者自身
        if(feed.creator.name){
            NSString *userName = [NSString stringWithFormat:UserNameString,feed.creator.name];
            [feedCheckWords addObject:userName];
        }
        
    }else{
        feedString = UMComLocalizedString(@"Delete Content", @"该内容已被删除");
    }
    
    CGFloat feedMutiTextWidth = 0;
    if (feed.image_urls && [feed.image_urls count] > 0 ) {
        
        if ([feed.status integerValue] < FeedStatusDeleted)
        {
            //feed有图片并且不为删除状态
            //totalHeight的高度为有照片的默认高度,默认宽度也要减去UMCom_SysCommonCell_Feed_IMGWidth
            totalHeight += UMCom_SysCommonCell_FeedWithIMG_Height;
            feedMutiTextWidth = self.view.frame.size.width - UMCom_SysCommonCell_Comment_LeftMargin - UMCom_SysCommonCell_Comment_RightMargin - UMCom_SysCommonCell_Comment_UserImgWidth -UMCom_SysCommonCell_Comment_SpaceBetweenUserNameAndComment - UMCom_SysCommonCell_Feed_IMGMargin*2 - UMCom_SysCommonCell_Feed_IMGWidth;
        }
        else
        {
            
            //totalHeight的高度为无照片的默认高度
            //totalHeight的高度为有照片的默认高度,默认宽度不需要减去UMCom_SysCommonCell_Feed_IMGWidth
            totalHeight += UMCom_SysCommonCell_FeedWithoutIMG_Height;
            feedMutiTextWidth = self.view.frame.size.width - UMCom_SysCommonCell_Comment_LeftMargin - UMCom_SysCommonCell_Comment_RightMargin - UMCom_SysCommonCell_Comment_UserImgWidth -UMCom_SysCommonCell_Comment_SpaceBetweenUserNameAndComment - UMCom_SysCommonCell_Feed_IMGMargin*2;
        }
        
    }
    else
    {
        //feed没有图片 高度固定
        totalHeight += UMCom_SysCommonCell_FeedWithoutIMG_Height;
        feedMutiTextWidth = self.view.frame.size.width - UMCom_SysCommonCell_Comment_LeftMargin - UMCom_SysCommonCell_Comment_RightMargin - UMCom_SysCommonCell_Comment_UserImgWidth -UMCom_SysCommonCell_Comment_SpaceBetweenUserNameAndComment;
        
    }
    
    totalHeight += UMCom_SysCommonCell_BottomMargin;
    
    UMComMutiText *feedMutiText = [UMComMutiText mutiTextWithSize:CGSizeMake(feedMutiTextWidth, MAXFLOAT) font:UMComFontNotoSansLightWithSafeSize(12) string:feedString lineSpace:2 checkWords:feedCheckWords textColor:[UMComTools colorWithHexString:@"A5A5A5"]];
    
    [commentDict setValue:feedMutiText forKey:@"feedMutiText"];
    
    NSString *timeString = createTimeString(like.create_time);
    [commentDict setValue:like forKey:@"like"];
    [commentDict setValue:@(totalHeight) forKey:@"totalHeight"];
    [commentDict setValue:timeString forKey:@"creat_time"];
    
    return commentDict;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ClickActionDelegate
- (void)customObj:(id)obj clickOnFeedText:(UMComFeed *)feed
{
    UMComFeedDetailViewController *postContent = [[UMComFeedDetailViewController alloc]initWithFeed:feed];
    [self.navigationController pushViewController:postContent animated:YES];
}

- (void)customObj:(id)obj clickOnUser:(UMComUser *)user
{
    UMComUserCenterViewController *userCenter = [[UMComUserCenterViewController alloc]initWithUser:user];
    [self.navigationController pushViewController:userCenter animated:YES];
}

- (void)customObj:(id)obj clickOnTopic:(UMComTopic *)topic
{
    UMComTopicFeedViewController *topicFeedVc = [[UMComTopicFeedViewController alloc]initWithTopic:topic];
    [self.navigationController pushViewController:topicFeedVc animated:YES];
}

- (void)customObj:(id)obj clickOnURL:(NSString *)url
{
    UMComWebViewController * webViewController = [[UMComWebViewController alloc] initWithUrl:url];
    [self.navigationController pushViewController:webViewController animated:YES];
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
