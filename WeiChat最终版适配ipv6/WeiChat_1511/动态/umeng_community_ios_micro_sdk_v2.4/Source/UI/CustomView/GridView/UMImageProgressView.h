//
//  UMImageViewWithProgress.h
//  UMCommunity
//
//  Created by luyiyuan on 14/9/3.
//  Copyright (c) 2014年 luyiyuan. All rights reserved.
//

#import "UMComImageView.h"



@interface UMImageProgressView : UMComImageView <UMComImageViewDelegate>

- (void)setThumImageViewUrl:(NSString *)urlString;
@property (nonatomic, strong) UMComImageView *thumImageView;

@end
