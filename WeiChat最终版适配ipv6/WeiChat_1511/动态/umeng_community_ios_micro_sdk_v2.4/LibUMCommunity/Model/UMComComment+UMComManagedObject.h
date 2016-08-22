//
//  UMComComment+UMComManagedObject.h
//  UMCommunity
//
//  Created by Gavin Ye on 11/17/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComComment.h"


void printComment();

@interface UMComComment (UMComManagedObject)

/**
 通过评论commentId获取到本地 UMComComment 对象的方法，如果本地没有， 则会新建一个
 
 @param commentId 评论的id
 
 */
+ (UMComComment *)objectWithObjectId:(NSString *)commentId;

@end


//@interface UMComCommentImageArray : NSValueTransformer
//
//@end