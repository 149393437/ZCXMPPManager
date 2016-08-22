//
//  UMComCoreData.h
//  UMCommunity
//
//  Created by Gavin Ye on 8/28/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComHttpClient.h"

@class UMComPullRequest;

extern NSString *const kUMCommanagedObjectContextDidMergeNotification;

typedef NS_ENUM(NSInteger, UMComCoreDataErrorCode)
{
    UMComCoreDataErrorCodeUnknown,
    UMComCoreDataErrorNoMoreFeed
};


@interface UMComCoreData : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSManagedObjectContext *backManagedObjectContext;

extern NSString * UMComResourceIdentifierFromReferenceObject(id referenceObject);

extern NSString * UMComReferenceObjectFromResourceIdentifier(NSString *resourceIdentifier);

@property (nonatomic, strong) NSCache *backingObjectIDByObjectID;

@property (nonatomic, strong) NSCache *managedObjectIdentifier;

- (void)saveManagedObject:(NSManagedObject *)managedObject;

- (void)clearData;

- (NSManagedObject *)objectWithEntityName:(NSString *)entityName objectId:(NSString *)objectId;

- (void)deleteObject:(NSManagedObject *)managedObject objectId:(NSString *)backingObjectIDString;


- (void)saveRequestResultRequst:(NSManagedObjectContext *)context fetchRequst:(UMComPullRequest *)fetchRequest response:(id)responseObject managedObjects:(void (^)(NSArray * managedObjects))saveObjects error:(NSError *)error;

+ (UMComCoreData *)sharedInstance;

+ (NSError *)errorWithCode:(UMComCoreDataErrorCode)code reason:(NSString *)reason;

@end
