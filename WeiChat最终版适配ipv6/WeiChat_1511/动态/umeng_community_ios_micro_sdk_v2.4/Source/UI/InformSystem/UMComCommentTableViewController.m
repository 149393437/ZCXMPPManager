//
//  UMComCommentTableViewController.m
//  UMCommunity
//
//  Created by umeng on 15/12/22.
//  Copyright © 2015年 Umeng. All rights reserved.
//

#import "UMComCommentTableViewController.h"
#import "UMComComment.h"
#import "UMComTools.h"
#import "UMComPullRequest.h"
//#import "UMComSysCommentCell.h"
#import "UMComClickActionDelegate.h"
#import "UMComUser.h"
#import "UMComSession.h"
#import "UMComCommentEditView.h"
#import "UMComPushRequest.h"
#import "UMComShowToast.h"
#import "UMComUserCenterViewController.h"
#import "UMComTopicFeedViewController.h"
#import "UMComFeedDetailViewController.h"
#import "UMComUnReadNoticeModel.h"
#import "UIViewController+UMComAddition.h"
#import "UMComWebViewController.h"
#import "UMComSysCommonTableViewCell.h"
#import "UMComSysCommentCell.h"
#import "UMComMutiStyleTextView.h"
#import "UMComFeed.h"
#import "UMComTopic.h"


@interface UMComCommentTableViewController ()<UMComClickActionDelegate>

@property (nonatomic, strong) UMComCommentEditView *commentEditView;

- (NSDictionary *)commentDictionaryWithComment:(UMComComment *)comment;


@end

@implementation UMComCommentTableViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setForumUITitle:UMComLocalizedString(@"UMCom_Forum_Comment", @"评论")];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - UITabelViewDeleagte
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UMComSysCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UMComSysCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId cellSize:CGSizeMake(tableView.frame.size.width, tableView.rowHeight)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    if ([self.fetchRequest isKindOfClass:[UMComUserCommentsSentRequest class]]) {
        cell.replyButton.hidden = YES;
    }
    NSDictionary *commentDict = self.dataArray[indexPath.row];
    [cell reloadCellWithObj:[commentDict valueForKey:@"comment"]
                 timeString:[commentDict valueForKey:@"creat_time"]
                   mutiText:[commentDict valueForKey:@"commentMutiText"]
               feedMutiText:[commentDict valueForKey:@"feedMutiText"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *commentDict = self.dataArray[indexPath.row];
    return [[commentDict valueForKey:@"totalHeight"] floatValue] + 5;
}

#pragma mark - data handel

- (void)handleCoreDataDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler
{
    if ([data isKindOfClass:[NSArray class]] &&  data.count > 0) {
        self.dataArray = [self commentModlesWithCommentData:data];
    }
    if (finishHandler) {
        finishHandler();
    }
}

- (void)handleServerDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler
{
    if (!error) {
        if ([self.fetchRequest isKindOfClass:[UMComUserCommentsSentRequest class]]) {
            [UMComSession sharedInstance].unReadNoticeModel.notiByCommentCount = 0;
        }
        self.dataArray = [self commentModlesWithCommentData:data];
    }
    if (finishHandler) {
        finishHandler();
    }
}

- (void)handleLoadMoreDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler
{
    if (!error && [data isKindOfClass:[NSArray class]]) {
        self.dataArray = [self commentModlesWithCommentData:data];
    }
    if (finishHandler) {
        finishHandler();
    }
}

- (NSArray *)commentModlesWithCommentData:(NSArray *)dataArray
{
    if ([dataArray isKindOfClass:[NSArray class]] && dataArray.count >0) {
        NSMutableArray *commentModels = [NSMutableArray arrayWithCapacity:dataArray.count];
        for (UMComComment *comment in dataArray) {
            NSDictionary *commentDict = [self commentDictionaryWithComment:comment];
            if (commentDict) {
                [commentModels addObject:commentDict];
            }
        }
        return commentModels;
    }
    return nil;
}

- (NSDictionary *)commentDictionaryWithComment:(UMComComment *)comment
{
    NSMutableDictionary *commentDict = [NSMutableDictionary dictionary];
    CGFloat totalHeight = UMCom_SysCommonCell_Comment_UserNameTopMargin +
    UMCom_SysCommonCell_Comment_UserNameHeight +
    UMCom_SysCommonCell_Comment_SpaceBetweenUserNameAndComment;
    
    if (comment.content) {
        NSMutableString * replayStr = [NSMutableString stringWithString:@""];
        NSMutableArray *checkWords = nil;
        if (comment.reply_user) {
            [replayStr appendString:@"回复"];
            checkWords = [NSMutableArray arrayWithObject:[NSString stringWithFormat:UserNameString,comment.reply_user.name]];
            [replayStr appendFormat:UserNameString,comment.reply_user.name];
            [replayStr appendFormat:@":"];
        }
        if (comment.content) {
            [replayStr appendFormat:@"%@",comment.content];
        }
        
        CGFloat subViewWidth = self.view.frame.size.width - UMCom_SysCommonCell_Comment_LeftMargin - UMCom_SysCommonCell_Comment_RightMargin - UMCom_SysCommonCell_Comment_UserImgWidth -UMCom_SysCommonCell_Comment_SpaceBetweenUserNameAndComment;
        if ([self.fetchRequest isKindOfClass:[UMComUserCommentsReceivedRequest class]]) {
            //如果是收到的评论，还需要减去快捷回复的按钮的宽度
            subViewWidth -= UMCom_SysCommonCell_Comment_replyBtnWidth;
        }
        
        UMComMutiText *mutiText = [UMComMutiText mutiTextWithSize:CGSizeMake(subViewWidth, MAXFLOAT) font:UMComFontNotoSansLightWithSafeSize(14) string:replayStr lineSpace:2 checkWords:checkWords textColor:        [UMComTools colorWithHexString:@"#666666"]];
        totalHeight += mutiText.textSize.height;
        [commentDict setValue:mutiText forKey:@"commentMutiText"];
        //[commentDict setValue:@(subViewWidth) forKey:@"commentMutiTextWidth"];
    }
    else
    {
        //评论没有内容，加入默认的内容占位高度
        totalHeight += UMCom_SysCommonCell_Comment_CommentDefaultHeight;
    }
    
    //累加评论底部的边距
    totalHeight += UMCom_SysCommonCell_Comment_CommentBotoom;
    
    //获得feed相关的
    NSMutableArray *feedCheckWords = nil;
    UMComFeed *feed = comment.feed;
    
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
    
    UMComMutiText *feedMutiText = [UMComMutiText mutiTextWithSize:CGSizeMake(feedMutiTextWidth, MAXFLOAT) font:UMComFontNotoSansLightWithSafeSize(12) string:feedString lineSpace:2 checkWords:feedCheckWords textColor:[UMComTools colorWithHexString:@"#999999"]];
    
    [commentDict setValue:feedMutiText forKey:@"feedMutiText"];
    //[commentDict setValue:@(feedMutiTextWidth) forKey:@"feedMutiTextWidth"];
    
    NSString *timeString = createTimeString(comment.create_time);
    [commentDict setValue:comment forKey:@"comment"];
    [commentDict setValue:@(totalHeight) forKey:@"totalHeight"];
    [commentDict setValue:timeString forKey:@"creat_time"];
    
    return commentDict;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UMComClickActionDelegate
- (void) customObj:(id)obj clickOnComment:(UMComComment *)comment feed:(UMComFeed *)feed
{
    if (!self.commentEditView) {
        self.commentEditView = [[UMComCommentEditView alloc]initWithSuperView:[UIApplication sharedApplication].keyWindow];
    }
    __weak typeof(self) weakSelf = self;
    self.commentEditView.SendCommentHandler = ^(NSString *commentText){
        [weakSelf postComment:commentText comment:comment feed:feed];
    };
    [self.commentEditView presentEditView];
    self.commentEditView.commentTextField.placeholder = [NSString stringWithFormat:@"回复%@",[[comment creator] name]];
}

- (void)postComment:(NSString *)content comment:(UMComComment *)comment feed:(UMComFeed *)feed
{
    __weak typeof (self) weakSelf = self;
    [UMComPushRequest commentFeedWithFeed:feed
                           commentContent:content
                             replyComment:comment
                     commentCustomContent:nil
                                   images:nil
                               completion:^(id responseObject,NSError *error) {
                                   if (error) {
                                       [UMComShowToast showFetchResultTipWithError:error];
                                   }else{
                                       if ([self.fetchRequest isKindOfClass:[UMComUserCommentsSentRequest class]] || [comment.creator.uid isEqualToString:[UMComSession sharedInstance].uid]) {
                                           NSMutableArray *commentModels = [NSMutableArray array];
                                           NSDictionary *commentDict = [self commentDictionaryWithComment:responseObject];
                                           if (commentDict) {
                                               [commentModels addObject:commentDict];
                                           }
                                           if (self.dataArray.count > 0) {
                                               [commentModels addObjectsFromArray:self.dataArray];
                                           }
                                           self.dataArray = commentModels;
                                       }
                                       [weakSelf.tableView reloadData];
                                       [[NSNotificationCenter defaultCenter] postNotificationName:kUMComCommentOperationFinishNotification object:feed];
                                   }
                               }];
}


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
