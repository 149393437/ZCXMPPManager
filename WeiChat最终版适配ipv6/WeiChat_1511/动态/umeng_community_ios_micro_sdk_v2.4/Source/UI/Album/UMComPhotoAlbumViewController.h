//
//  UMComPhotoAlbumViewController.h
//  UMCommunity
//
//  Created by umeng on 15/7/7.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComViewController.h"

@class UMComImageView, UMComUser;

@interface UMComPhotoAlbumViewController : UMComViewController


@property (nonatomic, strong) UMComUser *user;

@end


@interface UMComPhotoAlbumCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UMComImageView *imageView;

@end