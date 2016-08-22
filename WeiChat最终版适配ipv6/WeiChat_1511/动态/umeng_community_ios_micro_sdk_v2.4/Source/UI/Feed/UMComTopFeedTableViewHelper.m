//
//  UMComTopFeedTableViewHelper.m
//  UMCommunity
//
//  Created by 张军华 on 16/1/28.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComTopFeedTableViewHelper.h"

#import "UMComPullRequest.h"
#import "UMComFeed.h"

@interface UMComTopFeedTableViewHelper ()

@property (nonatomic,strong) UMComPullRequest* secondTopFeedRequest;//置顶的第二次请求(和topFeedRequest的请求不一样,例如第一次全局置顶，第二次话题下置顶)

//合并置顶feed到当前的Feed
-(void)mergeTopFeedToCurFeed;

@end

@implementation UMComTopFeedTableViewHelper

-(id) init
{
    if (self = [super init]) {
        self.topFeedState = EUMTopFeedStateNone;
        self.topFeedArray = [NSMutableArray arrayWithCapacity:3];
        self.commonFeedArray = [NSArray array];
        self.tablviewDataArray = [NSMutableArray arrayWithCapacity:20];
    }
    return self;
}

#pragma mark - new method

-(void)mergeTopFeedToCurFeed
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.topFeedArray];
    
    //过滤普通的feed流的数据
    self.commonFeedArray = [UMComTopFeedTableViewHelper filterTopfeedFromCommonFeedArray:self.commonFeedArray];
    
    [tempArray addObjectsFromArray:self.commonFeedArray];
    
    self.tablviewDataArray = tempArray;
}

-(BOOL) isExistFromDesArray:(NSMutableArray*)desArray withObject:(id)feed
{
    if (!feed || !desArray) {
        return NO;
    }
    
    for(int i = 0; i < desArray.count;i++)
    {
       id desFeed =  desArray[i];
        
        if (desFeed && feed &&
            [feed isKindOfClass:[UMComFeed class]] &&
            [desFeed isKindOfClass:[UMComFeed class]]) {
            
            NSString* desFeedID =  ((UMComFeed*)desFeed).feedID;
            NSString* feedID = ((UMComFeed*)feed).feedID;
            if (desFeedID && feedID && [desFeedID isEqualToString:feedID]) {
                return YES;
            }
        }
    }
    
    return NO;
}

/**
 *  合并desArray和data,并去重
 *
 *  @param desArray 目的数据
 *  @param data     网络数据
 */
-(void)mergeTopFeed:(NSMutableArray*)desArray fromServerData:(NSArray*)data
{
    if (!data || data.count <= 0 || !desArray) {
        return;
    }
    
    for(int i = 0; i < data.count;i++)
    {
        id tempObject =  data[i];
        if (!tempObject) {
            continue;
        }
        
        BOOL isExist = [self isExistFromDesArray:desArray withObject:tempObject];
        if (!isExist) {
            [desArray addObject:tempObject];
        }
        
    }
}


-(void)refreshTopFeedFromServer:(LoadTopFeedSeverDataCompletionHandler)loadTopFeedSeverDataCompletionHandler
{
    if (!self.topFeedRequest) {
        if (loadTopFeedSeverDataCompletionHandler) {
            loadTopFeedSeverDataCompletionHandler(nil, nil);
        }
        return;
    }
    
    //重置topFeedArray的数据
    self.topFeedArray = [NSMutableArray arrayWithCapacity:3];
    //如果目前正在请求本地或者网络数据，此次请求忽略
    if (self.topFeedState == EUMTopFeedStateLoadingLocalData ||
        self.topFeedState == EUMTopFeedStateLoadingServerData) {
        if (loadTopFeedSeverDataCompletionHandler) {
            loadTopFeedSeverDataCompletionHandler(nil, nil);
        }
        return;
    }
    
    self.topFeedState = EUMTopFeedStateLoadingServerData;
    __weak typeof(self) weakSelf = self;
    
    [self.topFeedRequest fetchRequestFromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
        
        if (error) {
            weakSelf.topFeedState = EUMTopFeedStateServerDataError;
            //提示用户
//            NSLog(@"refreshTopFeedFromServer>>>error:%@",error);
            if (loadTopFeedSeverDataCompletionHandler) {
                loadTopFeedSeverDataCompletionHandler(nil, error);
            }
            return;
        }

        if (data && data.count > 0) {
            weakSelf.topFeedArray  = [data mutableCopy];
        }
        
        //此处的数据在话题置顶的情况下,is_top字段为0,is_topic_top =1,目前模型中没有此字段
        
        if (!weakSelf.secondTopFeedRequest) {
            weakSelf.topFeedState = EUMTopFeedStateFinishServerData;
            if (loadTopFeedSeverDataCompletionHandler) {
                loadTopFeedSeverDataCompletionHandler(data,error);
            }
        }
        else
        {
            //第二次不同的置顶请求
            [weakSelf.topFeedRequest fetchRequestFromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
                if (error) {
                    weakSelf.topFeedState = EUMTopFeedStateServerDataError;
                    if (loadTopFeedSeverDataCompletionHandler) {
                        loadTopFeedSeverDataCompletionHandler(nil, error);
                    }
                    //提示用户
//                    NSLog(@"refreshTopFeedFromServer>>>error:%@",error);
                    return;
                }
                else
                {
                    if (data && data.count > 0) {
                        //去重添加第二次的数据
                        [weakSelf mergeTopFeed:weakSelf.topFeedArray fromServerData:data];
                    }
                    
                    weakSelf.topFeedState = EUMTopFeedStateFinishServerData;
                    if (loadTopFeedSeverDataCompletionHandler) {
                        loadTopFeedSeverDataCompletionHandler(data,error);
                    }
                }
                
            }];
        }
    }];
}

#pragma mark - overide method

- (void)refreshNewDataFromServer:(LoadSeverDataCompletionHandler)complection
{
    __weak typeof(self) weakSelf = self;
    [self refreshTopFeedFromServer:^(NSArray *data, NSError *error) {
//        NSLog(@"refreshTopFeedFromServer....finish");
        if (!error && [data isKindOfClass:[NSArray class]]) {
            weakSelf.topFeedArray = [data mutableCopy];
            
            [weakSelf mergeTopFeedToCurFeed];
            
            if (complection) {
                complection(data,NO,nil);
            }
        }
        else{
            //提示用户
            if (complection) {
                complection(nil, NO,error);
            }
        }
    }];
    
    //重置普通的feed流
    self.commonFeedArray = [NSArray array];
    //重置显示的tableview的feed流
    [self.tablviewDataArray removeAllObjects];
}

#pragma mark - UMComTableViewHandleDataDelegate1
- (void)handleServerDataWithData:(NSArray *)data error:(NSError *)error dataHandleFinish:(DataHandleFinish)finishHandler
{
//    NSLog(@"handleServerDataWithData....finish");
    __weak typeof(self) weakSelf = self;
    if (!error && [data isKindOfClass:[NSArray class]]) {
        self.commonFeedArray = data;
    }
    else
    {
        //提示用户
//        NSLog(@"handleServerDataWithData>>>error:%@",error);
        self.commonFeedArray = [NSArray array];
    }
    [weakSelf mergeTopFeedToCurFeed];
    if (finishHandler) {
        finishHandler();
    }
    
//    if (weakSelf.topFeedState == EUMTopFeedStateFinishServerData ||
//        weakSelf.topFeedState == EUMTopFeedStateServerDataError  ||
//        weakSelf.topFeedState == EUMTopFeedStateNone) {
//        if (finishHandler) {
//            NSLog(@"handleServerDataWithData....reloadTableview");
//            finishHandler();
//        }
//    }
}

+(NSArray*) filterTopfeedFromCommonFeedArray:(NSArray*)commonFeedArray
{
    if (!commonFeedArray) {
        return  [NSArray array];
    }
    
    NSInteger commonFeedCount = commonFeedArray.count;
    if (commonFeedCount == 0) {
        return commonFeedArray;
    }
    
    NSMutableArray* curCommonArray =  [NSMutableArray arrayWithCapacity:20];
    for (NSUInteger i = 0; i < commonFeedCount; i++)
    {
        id  curObject = commonFeedArray[i];
        if (curObject && [curObject isKindOfClass:[UMComFeed class]])
        {
            UMComFeed* curFeed = (UMComFeed*)curObject;
            if (curFeed) {
                NSInteger curTopType =  curFeed.is_topType.integerValue;
                if (curTopType == EUMTopFeedType_GlobalTopFeed ||
                    curTopType == EUMTopFeedType_TopicTopFeed ||
                    curTopType == EUMTopFeedType_GlobalAndTopicTopFeed
                    ) {
                    //普通feed流中就不需要加入全局置顶和话题置顶的feed
                }
                else
                {
                    [curCommonArray addObject:curFeed];
                }
            }
        }
    }
    
    return curCommonArray;
}


@end
