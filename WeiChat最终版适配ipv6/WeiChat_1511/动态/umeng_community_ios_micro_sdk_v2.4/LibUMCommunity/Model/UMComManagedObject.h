//
//  UMComManagedObject.h
//  UMCommunity
//
//  Created by luyiyuan on 14/9/28.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <CoreData/CoreData.h>

@class UMComPullRequest;

@interface UMComManagedObject : NSManagedObject
- (id)initWithDictionary:(NSDictionary *)dictionary classer:(Class)classer;

+ (BOOL)isDelete;

+ (NSDictionary *)attributes:(NSDictionary *)representation
                    ofEntity:(NSEntityDescription *)entity
                fetchRequest:(UMComPullRequest *)pullRequest;

+ (id)objectWithObjectId:(NSString *)objectId;

+ (NSDictionary *)relationshipsFromRepresentation:(NSDictionary *)representation ofEntity:(NSEntityDescription *)entity fetchRequest:(UMComPullRequest *)pullRequest;

+ (NSArray *)representationFromData:(id)representations fetchRequest:(UMComPullRequest *)pullRequest;

+ (NSDate *)dateTransform:(NSString *)dateString;

+ (id)entityName;
+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext*)context;

@end
