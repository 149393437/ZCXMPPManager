//
//  UMComProfileSettingController.h
//  UMCommunity
//
//  Created by luyiyuan on 14/10/27.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMComTools.h"
#import "UMComViewController.h"

#define UpdateUserProfileSuccess @"update user profile success!"

@class UMComUser, UMComUserAccount, UMComImageView;

@interface UMComProfileSettingController : UMComViewController
<UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy) void (^updateCompletion)(id responseObject, NSError *error) ;

@property (nonatomic, strong) UMComUserAccount *userAccount;

@property (nonatomic, copy) void (^settingCompletion)(UIViewController *viewController, UMComUserAccount *userAccount);


@property (nonatomic, weak) IBOutlet UITextField * nameField;
@property (nonatomic, strong) IBOutlet UMComImageView *userPortrait;

@property (nonatomic, weak) IBOutlet UIButton * genderSelector;

@property (nonatomic, weak) IBOutlet UIButton * genderButton;

@property (nonatomic, weak) IBOutlet UIPickerView *genderPicker;

@property (nonatomic, strong) NSError *registerError;

@property (weak, nonatomic) IBOutlet UILabel *pushStatus;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

- (IBAction)logout:(id)sender;

@end
