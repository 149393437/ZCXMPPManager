//
//  UMComCommentEditView.h
//  UMCommunity
//
//  Created by umeng on 15/7/22.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UMComCommentEditView : NSObject

@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UITextField *commentTextField;

@property (nonatomic, assign) NSInteger maxTextLenght;


@property (nonatomic, copy) void (^SendCommentHandler)(NSString *Content);

- (instancetype)initWithSuperView:(UIView *)view;

- (void)presentEmoji;

-(void)presentEditView;

- (void)dismissAllEditView;


@end
