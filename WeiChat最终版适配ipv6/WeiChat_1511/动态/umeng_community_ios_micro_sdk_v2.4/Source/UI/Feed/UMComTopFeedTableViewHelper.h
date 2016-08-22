//
//  UMComTopFeedTableViewHelper.h
//  UMCommunity
//
//  Created by 张军华 on 16/1/28.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComRequestTableViewController.h"


@class UMComPullRequest;

//置顶feed的状态
typedef NS_OPTIONS(NSUInteger, EUMTopFeedState) {
    EUMTopFeedStateNone                     = 0,        /*初始化状态*/
    EUMTopFeedStateLoadingLocalData         = 1 << 0,   /*loading本地数据的状态(目前本地加载的topfeed暂时无用)*/
    EUMTopFeedStateFinishLocalData          = 1 << 1,   /*Finish本地数据的状态(目前本地加载的topfeed暂时无用)*/
    EUMTopFeedStateLoadingServerData        = 1 << 2,   /*loading网络服务器的状态*/
    EUMTopFeedStateFinishServerData         = 1 << 3,   /*Finish网络数据的状态*/
    EUMTopFeedStateLocalDataError           = 1 << 4,   /*本地状态error*/
    EUMTopFeedStateServerDataError          = 1 << 5,   /*服务器状态error*/
    
};

//网络取得TopFeed的回调
typedef void (^LoadTopFeedSeverDataCompletionHandler)(NSArray *data, NSError *error);


@interface UMComTopFeedTableViewHelper : NSObject

@property (nonatomic, strong) NSMutableArray *topFeedArray;//置顶的数据模型
//@property (nonatomic,strong) UMComTopFeedRequest* topFeedRequest;//置顶的topFeedRequest
@property (nonatomic,strong) UMComPullRequest* topFeedRequest;//置顶的topFeedRequest


@property(assign)EUMTopFeedState topFeedState;//置顶feed的状态


@property (nonatomic, strong) NSArray *commonFeedArray;//普通的feed

@property (nonatomic, strong) NSMutableArray *tablviewDataArray;//tableview的模型类


/**
 *  刷新topfeed的数据
 *
 *  @param complection 成功后的回调block
 */
- (void)refreshNewDataFromServer:(LoadSeverDataCompletionHandler)complection;

/**
 *  获得服务器发送的普通的feed，用于和topfeed的数据合并
 *
 *  @param data          普通的feed
 *  @param error         @see NSError
 *  @param finishHandler 回调的执行的block
 */
- (void)handleServerDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler;

/**
 *  从普通feed流中过滤置顶的feed流
 *
 *  @param commonFeedArray 源普通的feed流（可能有置顶的feed）
 *
 *  @return 返回普通的feed流的数组(没有置顶信息)
 */
+(NSArray*) filterTopfeedFromCommonFeedArray:(NSArray*)commonFeedArray;


@end
