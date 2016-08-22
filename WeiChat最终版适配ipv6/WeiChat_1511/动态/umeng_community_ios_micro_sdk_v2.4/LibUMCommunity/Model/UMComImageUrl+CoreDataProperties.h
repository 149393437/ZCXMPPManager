//
//  UMComImageUrl+CoreDataProperties.h
//  UMCommunity
//
//  Created by umeng on 15/12/3.
//  Copyright © 2015年 Umeng. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UMComImageUrl.h"

void initImageUrl ();

NS_ASSUME_NONNULL_BEGIN

@interface UMComImageUrl (CoreDataProperties)

/**
 图片URL本地存储唯一ID（SDK内部使用）
 */
@property (nullable, nonatomic, retain) NSString *image_url_id;
/**
 小图url
 */
@property (nullable, nonatomic, retain) NSString *small_url_string;
/**
 中图url
 */
@property (nullable, nonatomic, retain) NSString *midle_url_string;
/**
 大图url
 */
@property (nullable, nonatomic, retain) NSString *large_url_string;
/**
 图片格式
 */
@property (nullable, nonatomic, retain) NSString *format;

@end

NS_ASSUME_NONNULL_END
