//
//  UMComErrorCode.m
//  UMCommunity
//
//  Created by umeng on 15/9/9.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComErrorCode.h"

//===user===
NSInteger  const  ERR_CODE_USER_NOT_EXIST = 10002;
NSInteger  const  ERR_CODE_USER_NOT_LOGIN = 10003;
NSInteger  const  ERR_CODE_USER_NO_PRIVILEGE = 10004;
NSInteger  const  ERR_CODE_USER_IDENTITY_INVAILD = 10005;
NSInteger  const  ERR_CODE_USER_HAS_CREATED = 10006;
NSInteger  const  ERR_CODE_USER_HAVE_FOLLOWED = 10007;
NSInteger  const  ERR_CODE_USER_LOGIN_INFO_NOT_COMPLETE = 10008;
NSInteger  const  ERR_CODE_USER_CANNOT_FOLLOW_SELF = 10009;
NSInteger  const  ERR_CODE_USER_NAME_LENGTH_ERROR = 10010;
NSInteger  const  ERR_CODE_USER_IS_UNUSABLE = 10011;
NSInteger  const  ERR_CODE_USER_NAME_SENSITIVE = 10012;
NSInteger  const  ERR_CODE_USER_NAME_DUPLICATE = 10013;
NSInteger  const  ERR_CODE_USER_CUSTOM_LENGTH_ERROR = 10014;
NSInteger  const  ERR_CODE_ONE_TIME_ONE_USER = 10015;
NSInteger  const  ERR_CODE_USER_NAME_CONTAINS_ILLEGAL_CHARS = 10016;
NSInteger  const  ERR_CODE_DEVICE_IN_BLACKLIST = 10017;
NSInteger  const  ERR_CODE_FAVOURITES_OVER_LIMIT = 10018;
NSInteger  const  ERR_CODE_HAS_ALREADY_COLLECTED = 10019;
NSInteger  const  ERR_CODE_HAS_NOT_COLLECTED = 10020;
NSInteger  const  ERR_CODE_MEDAL_NOT_EXIST = 10021;
NSInteger  const  ERR_CODE_MEDALNAME_DUPLICATE =10022;
NSInteger  const  ERR_CODE_USER_HAS_BEEN_BAN =10023;
NSInteger  const  ERR_CODE_USER_HAS_THIS_MEDAL =10024;
NSInteger  const  ERR_CODE_STRING_CANNOT_CONVERT_TO_INTEGER=11000;
NSInteger  const  ERR_CODE_THERE_ISNOT_CHAT_CHANNEL_BETWEEN_THESE_USERS = 11001;
NSInteger  const  ERR_CODE_MESSAGE_CONTENT_IS_EMPTY = 11002;
NSInteger  const  ERR_CODE_MESSAGE_TOO_LONG = 11003;
NSInteger  const  ERR_CODE_CANNOT_SEND_MESSAGE_TO_USER_SELF = 11004;


//
NSString * const  ERR_MSG_USER_BASE_INFO_NOT_COMPLETE = @"user base info is not complete";
NSString * const  ERR_MSG_USER_NOT_EXIST = @"user does not exist";
NSString * const  ERR_MSG_USER_NOT_LOGIN = @"user did not log in";
NSString * const  ERR_MSG_USER_NO_PRIVILEGE = @"user don\'t have privilege to do this.";
NSString * const  ERR_MSG_USER_IDENTITY_INVAILD = @"user identity is invaild";
NSString * const  ERR_MSG_USER_HAS_CREATED = @"user has been created";
NSString * const  ERR_MSG_USER_HAVE_FOLLOWED = @"user has been followed";
NSString * const  ERR_MSG_USER_LOGIN_INFO_NOT_COMPLETE = @"user login info not complete";
NSString * const  ERR_MSG_USER_CANNOT_FOLLOW_SELF = @"user cannot follow self";
NSString * const  ERR_MSG_USER_NAME_LENGTH_ERROR = @"user name length should be in range 2,20";
NSString * const  ERR_MSG_USER_IS_UNUSABLE = @"user is unusable: deleted or forbidden";
NSString * const  ERR_MSG_USER_NAME_SENSITIVE = @"user name contains sensitive words";
NSString * const  ERR_MSG_USER_NAME_DUPLICATE = @"user name is duplicated";
NSString * const  ERR_MSG_USER_CUSTOM_LENGTH_ERROR = @"user custom length should be in range 0, 50";
NSString * const  ERR_MSG_ONE_TIME_ONE_USER_ERROR = @"this operation only allows one user per time";
NSString * const  ERR_MSG_USER_NAME_CONTAINS_ILLEGAL_CHARS = @"user name contains illegal characters";
NSString * const  ERR_MSG_DEVICE_IN_BLACKLIST = @"the device is in blacklist";
NSString * const  ERR_MSG_FAVOURITES_OVER_LIMIT = @"collection has touch the limit: 50";
NSString * const  ERR_MSG_HAS_ALREADY_COLLECTED = @"feed has already been collected";
NSString * const  ERR_MSG_HAS_NOT_COLLECTED = @"feed has not been collected yet";

NSString * const  ERR_MSG_MEDAL_NOT_EXIST =  @"the medal in this community not exist";
NSString * const  ERR_MSG_MEDALNAME_DUPLICATE = @"the medal in this community name duplicate";
NSString * const  ERR_MSG_USER_HAS_BEEN_BAN = @"the user has ban in this community topic";
NSString * const  ERR_MSG_USER_HAS_THIS_MEDAL = @"the user has this medal";
NSString * const  ERR_MSG_STRING_CANNOT_CONVERT_TO_INTEGER = @"the string can not to convert to Integer";
NSString * const  ERR_MSG_THERE_ISNOT_CHAT_CHANNEL_BETWEEN_THESE_USERS = @"There is no chat channel between these users";
NSString * const  ERR_MSG_MESSAGE_CONTENT_IS_EMPTY = @"message content is empty!";

NSString * const  ERR_MSG_MESSAGE_TOO_LONG = @"message too long, max 300";
NSString * const  ERR_MSG_CANNOT_SEND_MESSAGE_TO_USER_SELF = @"cannot send message to user self";
//
//===Feed===
NSInteger  const  ERR_CODE_FEED_UNAVAILABLE = 20001;
NSInteger  const  ERR_CODE_FEED_NOT_EXSIT = 20002;
NSInteger  const  ERR_CODE_FEED_HAS_BEEN_LIKED = 20003;
NSInteger  const  ERR_CODE_FEED_RELATED_USER_ID_INVALID = 20004;
NSInteger  const  ERR_CODE_FEED_CANNOT_FORWARD = 20005;
NSInteger  const  ERR_CODE_FEED_RELATED_TOPIC_ID_INVALID = 20006;
NSInteger  const  ERR_CODE_COMMENT_CONTENT_LENGTH_ERROR = 20007;
NSInteger  const  ERR_CODE_FEED_CONTENT_LENGTH_ERROR = 20008;
NSInteger  const  ERR_CODE_FEED_TYPE_INVALID = 20009;
NSInteger  const  ERR_CODE_FEED_CUSTOM_LENGTH_ERROR = 20010;
NSInteger  const  ERR_CODE_FEED_SHARE_CALLBACK_PLATFORM_ERROR = 20011;
NSInteger  const  ERR_CODE_LIKE_HAS_BEEN_CANCELED = 20012;
NSInteger  const  ERR_CODE_TITLE_LENGTH_ERROR = 20013;
NSInteger  const  ERR_CODE_FEED_COMMENT_UNAVAILABLE = 20014;
NSInteger  const  ERR_CODE_FEED_IS_LOCKED = 20015;
NSInteger  const  ERR_CODE_FEED_CANNOT_FORWARD_RICH_TEXT_FEED = 20016;

NSString * const  ERR_MSG_FEED_UNAVAILABLE = @"feed is unavailable";
NSString * const  ERR_MSG_FEED_NOT_EXSIT = @"feed is not exsit";
NSString * const  ERR_MSG_FEED_HAS_BEEN_LIKED = @"feed has been liked";
NSString * const  ERR_MSG_FEED_RELATED_USER_ID_INVALID = @"feed related uid is invalid";
NSString * const  ERR_MSG_FEED_CANNOT_FORWARD = @"feed can\'t be reposted";
NSString * const  ERR_MSG_FEED_RELATED_TOPIC_ID_INVALID = @"feed related topic id is invalid";
NSString * const  ERR_MSG_COMMENT_CONTENT_LENGTH_ERROR = @"a comment length should be in range 1, 300";
NSString * const  ERR_MSG_FEED_CONTENT_LENGTH_ERROR = @"a feed length should be in range 1, 300";
NSString * const  ERR_MSG_FEED_CUSTOM_LENGTH_ERROR = @"a custom string length should be in range 0, 50";
NSString * const  ERR_MSG_FEED_TYPE_INVALID = @"invalid feed_type value";
NSString * const  ERR_MSG_FEED_SHARE_CALLBACK_PLATFORM_ERROR = @"invalid share platform";
NSString * const  ERR_MSG_LIKE_HAS_BEEN_CANCELED = @"like has been canceled.";
NSString * const  EER_MSG_TITLE_LENGTH_ERROR = @"title length max 100";
NSString * const  ERR_MSG_FEED_COMMENT_UNAVAILABLE = @"comment is unavailable";
NSString * const  ERR_MSG_FEED_IS_LOCKED = @"feed is locked";
NSString * const  ERR_MSG_FEED_CANNOT_FORWARD_RICH_TEXT_FEED = @"Cannot forward rich text feed";
//===topic==
NSInteger  const  ERR_CODE_HAVE_FOCUSED = 30001;
NSInteger  const  ERR_CODE_NOT_EXIST = 30002;
NSInteger  const  ERR_CODE_TOPIC_CANNOT_CREATE = 30003;
NSInteger  const  ERR_CODE_TOPIC_RANK_ERROR = 30004;
NSInteger  const  ERR_CODE_HAVE_NOT_FOCUSED = 30005;

NSString * const  ERR_MSG_HAVE_FOCUSED = @"the topic has been focused";
NSString * const  ERR_MSG_NOT_EXSIT = @"the topic is not exist";
NSString * const  ERR_MSG_TOPIC_CANNOT_CREATE = @"the topic cannot be created";
NSString * const  ERR_MSG_HAVE_NOT_FOCUSED = @"the topic has not been focused yet";
NSString * const  ERR_MSG_TOPIC_RANK_ERROR = @"invalid topic new rank";
//
//===spammer===
NSInteger  const  ERR_CODE_STATUS_INVILD = 40001;
NSInteger  const  ERR_CODE_SPAMMER_HAS_CREATED = 40002;
NSInteger  const  ERR_CODE_INVALID_TYPE = 40003;
NSInteger  const  ERR_CODE_SPAMMER_HAS_BEEN_CREATED = 40004;

NSString * const  ERR_MSG_STATUS_INVILD = @"spammer action is invild";
NSString * const  ERR_MSG_SPAMMER_HAS_CREATED = @"spammer has been created";
NSString * const  ERR_MSG_INVALID_TYPE = @"invalid type to create spammer";
NSString * const  ERR_MSG_SPAMMER_HAS_BEEN_CREATED = @"spammer user has been created";
//
//===midgard_commen===
NSInteger  const  ERR_CODE_REQUEST_PRARMS_ERROR = 50001;
NSInteger  const  ERR_CODE_IMAGE_UPLOAD_FAILED = 50002;
NSInteger  const  ERR_CODE_INVALID_AUTH_TOKEN = 50003;
NSString * const  ERR_MSG_REQUEST_PRARMS_ERROR = @"request params contain erorr, please check to fix";
NSString * const  ERR_MSG_IMAGE_UPLOAD_FAILED = @"images upload failed";
NSString * const  ERR_MSG_INVALID_AUTH_TOKEN = @"auto token is invalid";

//Community
NSInteger  const  ERR_CODE_INVALID_COMMUNITY = 70017;
NSString * const  ERR_MSG_INVALID_COMMUNITY = @"community not available";

//APPKEY
NSInteger  const  ERR_CODE_INVALID_COMMUNITY_APPKEY = 70011;
NSString * const  ERR_MSG_INVALID_COMMUNITY_APPKEY  = @"the appkey is invalid";

NSInteger  const  ERR_CODE_REQUEST_TOO_OFTEN = 121212;

@implementation UMComErrorCode



@end
