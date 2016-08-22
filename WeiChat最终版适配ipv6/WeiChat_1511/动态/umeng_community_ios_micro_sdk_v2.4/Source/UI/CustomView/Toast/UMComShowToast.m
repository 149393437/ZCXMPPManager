//
//  UMComShowToast.m
//  UMCommunity
//
//  Created by Gavin Ye on 1/21/15.
//  Copyright (c) 2015 Umeng. All rights reserved.
//

#import "UMComShowToast.h"
#import "UMComiToast.h"
#import "UMComLoginManager.h"
#import "UMComSession.h"
#import "UMComTools.h"


@implementation UMComShowToast

+ (void)hanelerErrorWithError:(NSError *)error
{
    //====user====
    if (error.code == ERR_CODE_USER_NOT_EXIST) {
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_USER_NOT_EXIST,@"用户不存在")];
    }else if (error.code == ERR_CODE_USER_NOT_LOGIN){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_USER_NOT_LOGIN,@"对不起，您还未登录")];
        
    }else if (error.code == ERR_CODE_USER_NO_PRIVILEGE){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_USER_NO_PRIVILEGE,@"对不起，你没有这个操作的权限")];
    }else if (error.code == ERR_CODE_USER_IDENTITY_INVAILD){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_USER_IDENTITY_INVAILD,@"当前用户无效")];
        
    }else if (error.code == ERR_CODE_USER_HAS_CREATED){
        NSLog(@"ERR_MSG_USER_HAS_CREATED：%@",ERR_MSG_USER_HAS_CREATED);
        
    }else if (error.code == ERR_CODE_USER_HAVE_FOLLOWED){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_USER_HAVE_FOLLOWED,@"你已经关注过了")];
    }else if (error.code == ERR_CODE_USER_LOGIN_INFO_NOT_COMPLETE){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_USER_LOGIN_INFO_NOT_COMPLETE,@"用户登录信息不完善")];
    }else if (error.code == ERR_CODE_USER_CANNOT_FOLLOW_SELF){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_USER_CANNOT_FOLLOW_SELF,@"自己不能关注自己哦")];
    }else if (error.code == ERR_CODE_USER_NAME_LENGTH_ERROR){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_USER_NAME_LENGTH_ERROR,@"用户名长度不符合要求")];
    }else if (error.code == ERR_CODE_USER_IS_UNUSABLE){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_USER_IS_UNUSABLE,@"对不起，你已经被禁言")];
    }else if (error.code == ERR_CODE_USER_NAME_SENSITIVE){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_USER_NAME_SENSITIVE,@"用户名包含敏感词汇")];
    }else if (error.code == ERR_CODE_USER_NAME_DUPLICATE){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_USER_NAME_DUPLICATE,@"用户明已经存在，请换个靓号哦")];
    }else if (error.code == ERR_CODE_USER_CUSTOM_LENGTH_ERROR){
        NSLog(@"ERR_MSG_USER_CUSTOM_LENGTH_ERROR:%@",ERR_MSG_USER_CUSTOM_LENGTH_ERROR);
    }else if (error.code == ERR_CODE_ONE_TIME_ONE_USER){
        NSLog(@"ERR_CODE_ONE_TIME_ONE_USER_ERROR:%@",ERR_MSG_ONE_TIME_ONE_USER_ERROR);
    }else if (error.code == ERR_CODE_USER_NAME_CONTAINS_ILLEGAL_CHARS){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_USER_NAME_CONTAINS_ILLEGAL_CHARS,@"用户名包含非法字符")];
    }else if (error.code == ERR_CODE_DEVICE_IN_BLACKLIST){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_DEVICE_IN_BLACKLIST,@"该设备已经被屏蔽，请联系社区管理员")];
    }else if (error.code == ERR_CODE_FAVOURITES_OVER_LIMIT){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_FAVOURITES_OVER_LIMIT,@"你的收藏列表已满，请先移除一些收藏项")];
    }else if (error.code == ERR_CODE_HAS_ALREADY_COLLECTED){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_HAS_ALREADY_COLLECTED,@"你已经收藏过啦")];
    }else if (error.code == ERR_CODE_HAS_NOT_COLLECTED){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_HAS_ALREADY_COLLECTED,@"你还没有收藏过啦")];

    }else if (error.code == ERR_CODE_MEDAL_NOT_EXIST){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_MEDAL_NOT_EXIST,@"勋章不存在")];
    }else if (error.code == ERR_CODE_MEDALNAME_DUPLICATE){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_MEDALNAME_DUPLICATE,@"勋章名称重复了")];
    }else if (error.code == ERR_CODE_USER_HAS_BEEN_BAN){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_USER_HAS_BEEN_BAN,@"用户已经被禁言过啦")];
    }else if (error.code == ERR_CODE_USER_HAS_THIS_MEDAL){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_USER_HAS_THIS_MEDAL,@"该用户已经有这个勋章了")];
    }else if (error.code == ERR_CODE_STRING_CANNOT_CONVERT_TO_INTEGER){
        NSLog(@"error is %@",UMComLocalizedString(ERR_MSG_STRING_CANNOT_CONVERT_TO_INTEGER,@"字符串无法转成number类型"));
    }else if (error.code == ERR_CODE_THERE_ISNOT_CHAT_CHANNEL_BETWEEN_THESE_USERS){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_THERE_ISNOT_CHAT_CHANNEL_BETWEEN_THESE_USERS,@"你们之前没有消息建立私信通道")];
    }else if (error.code == ERR_CODE_MESSAGE_CONTENT_IS_EMPTY){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_MESSAGE_CONTENT_IS_EMPTY,@"发送私信消息为空")];
    }else if (error.code == ERR_CODE_MESSAGE_TOO_LONG){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_MESSAGE_TOO_LONG,@"私信消息太长啦")];
    }else if (error.code == ERR_CODE_CANNOT_SEND_MESSAGE_TO_USER_SELF){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_CANNOT_SEND_MESSAGE_TO_USER_SELF,@"自己不能给自己发消息哦")];
    }
    //====feed====
    else if (error.code == ERR_CODE_FEED_UNAVAILABLE){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_FEED_UNAVAILABLE,@"该内容已被删除")];
    }else if (error.code == ERR_CODE_FEED_NOT_EXSIT){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_FEED_NOT_EXSIT,@"该内容不存在")];
    }else if (error.code == ERR_CODE_FEED_HAS_BEEN_LIKED){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_FEED_HAS_BEEN_LIKED,@"你已经赞过啦")];
    }else if (error.code == ERR_CODE_FEED_RELATED_USER_ID_INVALID){
        NSLog(@"ERR_MSG_FEED_RELATED_USER_ID_INVALID:%@",ERR_MSG_FEED_RELATED_USER_ID_INVALID);
    }else if (error.code == ERR_CODE_FEED_CANNOT_FORWARD){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_FEED_CANNOT_FORWARD,@"该内容不能被转发")];
    }else if (error.code == ERR_CODE_FEED_RELATED_TOPIC_ID_INVALID){
        NSLog(@"ERR_MSG_FEED_RELATED_TOPIC_ID_INVALID:%@",ERR_MSG_FEED_RELATED_TOPIC_ID_INVALID);
    }else if (error.code == ERR_CODE_COMMENT_CONTENT_LENGTH_ERROR){
        NSString *noticeString = [NSString stringWithFormat:@"评论内容只能在1到%d个字符之间",(int)[UMComSession sharedInstance].comment_length];
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_COMMENT_CONTENT_LENGTH_ERROR,noticeString)];
    }else if (error.code == ERR_CODE_FEED_CONTENT_LENGTH_ERROR){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_FEED_CONTENT_LENGTH_ERROR,@"内容长度不符合要求")];
    }else if (error.code == ERR_CODE_FEED_TYPE_INVALID){
        NSLog(@"ERR_MSG_FEED_TYPE_INVALID:%@",ERR_MSG_FEED_TYPE_INVALID);
    }else if (error.code == ERR_CODE_FEED_CUSTOM_LENGTH_ERROR){
        NSLog(@"ERR_MSG_FEED_CUSTOM_LENGTH_ERROR:%@",ERR_MSG_FEED_CUSTOM_LENGTH_ERROR);
    }else if (error.code == ERR_CODE_FEED_SHARE_CALLBACK_PLATFORM_ERROR){
        NSLog(@"ERR_MSG_FEED_SHARE_CALLBACK_PLATFORM_ERROR:%@",ERR_MSG_FEED_SHARE_CALLBACK_PLATFORM_ERROR);
    }else if (error.code == ERR_CODE_LIKE_HAS_BEEN_CANCELED){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_LIKE_HAS_BEEN_CANCELED,@"你已经取消过赞啦")];
    }else if (error.code == ERR_CODE_TITLE_LENGTH_ERROR){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(EER_MSG_TITLE_LENGTH_ERROR,@"标题长度超过上限啦")];
    }else if (error.code == ERR_CODE_FEED_COMMENT_UNAVAILABLE){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_FEED_COMMENT_UNAVAILABLE ,@"该评论已被删除")];
    }else if (error.code == ERR_CODE_FEED_IS_LOCKED){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_FEED_IS_LOCKED ,@"该内容已被锁定")];
    }else if (error.code == ERR_CODE_FEED_CANNOT_FORWARD_RICH_TEXT_FEED){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_FEED_CANNOT_FORWARD_RICH_TEXT_FEED ,@"不能转发富文本的内容")];
    }
    //====topic====
    else if (error.code == ERR_CODE_HAVE_FOCUSED){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_HAVE_FOCUSED,@"该话题已经被关注啦")];
    }else if (error.code == ERR_CODE_NOT_EXIST){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_NOT_EXSIT,@"该话题不存在啦")];
    }else if (error.code == ERR_CODE_TOPIC_CANNOT_CREATE){
        NSLog(@"ERR_MSG_TOPIC_CANNOT_CREATE:%@",ERR_MSG_TOPIC_CANNOT_CREATE);
    }else if (error.code == ERR_CODE_TOPIC_RANK_ERROR){
        NSLog(@"ERR_MSG_TOPIC_RANK_ERROR:%@",ERR_MSG_TOPIC_RANK_ERROR);
    }else if (error.code == ERR_CODE_HAVE_NOT_FOCUSED){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_HAVE_NOT_FOCUSED,@"你并未关注该话题哦")];
    }
    //===spammer===
    else if (error.code == ERR_CODE_STATUS_INVILD){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_STATUS_INVILD,@"举报操作无效")];
    }else if (error.code == ERR_CODE_SPAMMER_HAS_CREATED){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_SPAMMER_HAS_CREATED,@"该内容已经被举报过了")];
    }else if (error.code == ERR_CODE_INVALID_TYPE){
        NSLog(@"ERR_MSG_INVALID_TYPE:%@",ERR_MSG_INVALID_TYPE);
    }else if (error.code == ERR_CODE_SPAMMER_HAS_BEEN_CREATED){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_SPAMMER_HAS_BEEN_CREATED,@"你已经举报过了")];
    }
    //===midgard_commen===
    else if (error.code == ERR_CODE_REQUEST_PRARMS_ERROR){
        NSLog(@"ERR_MSG_REQUEST_PRARMS_ERROR:%@",ERR_MSG_REQUEST_PRARMS_ERROR);
    }else if (error.code == ERR_CODE_IMAGE_UPLOAD_FAILED){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_IMAGE_UPLOAD_FAILED,@"图片上传失败")];
    }else if (error.code == ERR_CODE_INVALID_AUTH_TOKEN){
        NSLog(@"ERR_MSG_INVALID_AUTH_TOKEN:%@",ERR_MSG_INVALID_AUTH_TOKEN);
    } else if (error.code == ERR_CODE_INVALID_COMMUNITY){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_INVALID_COMMUNITY,@"社区已经被强制关闭，暂时无法访问请见谅。")];
    } else if (error.code == ERR_CODE_INVALID_COMMUNITY_APPKEY){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_INVALID_COMMUNITY_APPKEY,@"社区Appkey无效,请检查。")];
    }else if (error.code == ERR_CODE_REQUEST_TOO_OFTEN){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(ERR_MSG_INVALID_COMMUNITY,@"你的操作太快啦，网络跟不上哦")];
    }else if(error.code == 90001){
        NSLog(@"error :%@", error.localizedDescription);
    }else if([error.domain isEqualToString:NSURLErrorDomain]){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"UMCom_Network_fail",@"网络请求失败")];
    }
    else{
        NSLog(@"服务器错误 error is %@", error.localizedDescription);
//        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"UMCom_Unknown_fail",@"未知错误")];
    }
}


+ (void)showFetchResultTipWithError:(NSError *)error
{
    if ([error.domain isEqualToString:NSURLErrorDomain]){
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Network request failed",@"网络请求失败")];
    }else if(error){
        [[self class] hanelerErrorWithError:error];
    }else{
    
    }
}


+ (void)createFeedSuccess
{
    [self fetchFailWithNoticeMessage:UMComLocalizedString(@"Create_Feed_Success",@"消息发送成功")];
}


+ (void)notSupportPlatform
{
    [self fetchFailWithNoticeMessage:UMComLocalizedString(@"Not Support Platform", @"暂不支持该平台登录")];
}

//+ (void)createFeedFail:(NSError *)error
//{
//    if (![self handleError:error]){
//        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Create_Feed_Fail",@"消息发送失败")];
//    }
//}

+ (void)showNotInstall
{
    [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Not_Install",@"抱歉，您没有安装微信客户端")];
}

+ (void)showNoMore{
    [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Not_Install",@"已加载全部数据")];
}

//+ (void)loginFail:(NSError *)error
//{
//    if (error.code == kUserDelete){
//        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"User_Delete_Fail",@"该用户已经被删除，请联系管理员")];
//    } else if (![self handleError:error] && error){
//        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Login_Fail",@"登录失败")];
//    }
//}

//+ (void)createCommentFail:(NSError *)error
//{
//    if (![self handleError:error] && error){
//        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Create_Comment_Fail",@"发送评论失败")];
//    }
//}

+ (void)spamSuccess:(NSError *)error
{
    if (error) {
        [self showFetchResultTipWithError:error];
    }else{
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Spam_Success",@"举报消息成功")];
    }
}


+ (void)spamComment:(NSError *)error
{
    if (error) {
        [self showFetchResultTipWithError:error];
    }else{
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Spam_Comment_Success",@"举报评论成功")];
    }
}

+ (void)spamUser:(NSError *)error
{
    if (error) {
        if (error.code == ERR_CODE_SPAMMER_HAS_CREATED) {
            [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"User has been spam",@"该用户已经被举报过了")];
        } if (error.code == ERR_CODE_SPAMMER_HAS_BEEN_CREATED) {
            [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"User has been spam",@"你已经举报过了")];
        }else{
            [self showFetchResultTipWithError:error];
        }
    }else{
        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Spam_Comment_Success",@"举报用户成功")];
    }
}

//+ (BOOL)handleError:(NSError *)error
//{
//    BOOL handleResult = NO;
//    if (error.code == 10011) {
//        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"User unusable",@"对不起，你已经被禁言")];
//        handleResult = YES;
//    } else if ([error.domain isEqualToString:NSURLErrorDomain]){
//        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Network request failed",@"网络请求失败")];
//        handleResult = YES;
//    }
//    return handleResult;
//}

//+ (void)fetchFeedFail:(NSError *)error
//{
//    if (error) {
//        [self showFetchResultTipWithError:error];
//    }else{
//    
//    }
//    if (![self handleError:error] && error) {
//        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Fetch_Feeds_Fail",@"获取消息失败")];
//    }
//}

//+ (void)createLikeFail:(NSError *)error
//{
//    if (![self handleError:error] && error) {
//        if (error.code == 20003) {
//            [self dealWithFeedFailWithErrorCode:20003];
//        }else{
//            [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Add_Like_Fail",@"点赞失败")];
//        }
//    }
//}

//+ (void)deleteLikeFail:(NSError *)error
//{
//    if (![self handleError:error] && error) {
//        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Delete_Like_Fail",@"取消点赞失败")];
//    }
//}

//+ (void)fetchMoreFeedFail:(NSError *)error
//{
//    [self showFetchResultTipWithError:error];
//}

+ (void)commentMoreWord
{
    NSString *noticeString = [NSString stringWithFormat:@"评论内容不能超过%d个字",(int)[UMComSession sharedInstance].comment_length];
    [[UMComiToast makeText:UMComLocalizedString(@"Comment More word",noticeString)] show];
}

+ (void)fetchFailWithNoticeMessage:(NSString *)message
{
    [[UMComiToastSettings getSharedSettings] setGravity:UMSocialiToastPositionBottom];
    [[UMComiToast makeText:message] show];
}


//+ (void)fetchTopcsFail:(NSError *)error
//{
//    if (![self handleError:error] && error) {
//        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Topics search fail",@"请求话题失败")];
//    }
//}


//+ (void)fetchLocationsFail:(NSError *)error
//{
//    if (![self handleError:error] && error) {
//        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Locations search fail",@"获取地址失败")];
//    }
//}

//+ (void)fetchFriendsFail:(NSError *)error
//{
//    if (![self handleError:error] && error) {
//        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Locations search fail",@"获取好友列表失败")];
//    }
//}


+ (void)saveIamgeResultNotice:(NSError *)error
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = UMComLocalizedString(@"Image save fail!",@"保存图片失败");
    }else{
        msg = UMComLocalizedString(@"Image save succeed!",@"保存图片成功");;
    }
    [[self class] fetchFailWithNoticeMessage:msg];
}

//+ (void)focusTopicFail:(NSError *)error
//{
//    if (![self handleError:error] && error) {
//        if (error.code == 30001) {
//            [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Topic has been followed",@"该话题已被关注")];
//        }else{
//            [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Operation fail",@"操作失败")];
//        }
//    }
//}

//+ (void)focusUserFail:(NSError *)error
//{
//    if (![self handleError:error] && error) {
//        if (error.code == 10007) {
//            [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"User has been followed",@"该用户已被关注")];
//        }else if (error.code == 10009){
//            [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"User cannot follow self",@"自己不能关注自己")];
//        }else{
//            [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Operation fail",@"操作失败")];
//        }
//    }
//}

//+ (void)fetchRecommendUserFail:(NSError *)error
//{
//    if (![self handleError:error] && error) {
//        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Recommend user search fail",@"请求推荐用户失败")];
//    }
//}

//+ (void)fetchUserFail:(NSError *)error
//{
//    if (![self handleError:error] && error) {
//        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"user search fail",@"请求用户失败")];
//    }
//}

//
//
//+ (void)deletedFail:(NSError *)error
//{
//    if (![self handleError:error]){
//        if (error) {
//            if (error.code == 10004) {
//                [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"no privilege",@"您没有此删除操作的权限")];
//            }else{
//                [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Delete_Fail",@"删除消息失败")];
//            }
//        } else{
//            [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Delete_Success",@"删除成功")];
//        }
//    }
//}

+ (void)favouriteFeedFail:(NSError *)error isFavourite:(BOOL)isFavourite
{
    if (error) {
        [self showFetchResultTipWithError:error];
    }else{
        if (isFavourite) {
            [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Favourite_Success",@"收藏成功")];
        }else{
            [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"DisFavourite_Success",@"取消收藏成功")];
        }
    }
//    if (![self handleError:error]) {
//        if (error) {
//            if (error.code == 10004) {
//                [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"no privilege",@"您没有此删除操作的权限")];
//            }else{
//                if (isFavourite) {
//                    if (error.code == 10018) {
//                        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Collection_has_touch_the_limit",@"你的收藏列表已满，请先移除一些收藏项")];
//                    }else{
//                        [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Favourite_Fail",@"收藏消息失败")];
//                    }
//
//                }else{
//                    [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"DisFavourite_Fail",@"取消收藏消息失败")];
//                }
//
//            }
//        } else{
//            if (isFavourite) {
//                [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Favourite_Success",@"收藏成功")];
//            }else{
//                     [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"DisFavourite_Success",@"取消收藏成功")];
//            }
//        }
//    }
}


+ (void)focuseUserSuccess:(NSError *)error focused:(BOOL)focused
{
    if (error) {
        [self showFetchResultTipWithError:error];
    }else{
        if (focused) {
            [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Focused_Success",@"关注成功")];
        }else{
            [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"DisFocused_Success",@"取消关注成功")];
        }
    }
}

+ (void)focusTopicFail:(NSError *)error focused:(BOOL)focused
{
    if (error) {
        [self showFetchResultTipWithError:error];
    }else{
        if (focused) {
            [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"Focused_Success",@"关注成功")];
        }else{
            [[self class] fetchFailWithNoticeMessage:UMComLocalizedString(@"DisFocused_Success",@"取消关注成功")];
        }
    }
}

@end
