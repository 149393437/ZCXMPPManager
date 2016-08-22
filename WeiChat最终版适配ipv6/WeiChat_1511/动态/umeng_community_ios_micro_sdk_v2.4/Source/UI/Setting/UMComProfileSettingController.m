//
//  UMComProfileSettingController.m
//  UMCommunity
//
//  Created by luyiyuan on 14/10/27.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMComProfileSettingController.h"
#import "UMComBarButtonItem.h"
#import "UMComImageView.h"
#import "UMComPullRequest.h"
#import "UMComUser.h"
#import "UMComHttpManager.h"
#import "UMComSession.h"
#import "UMComCoreData.h"
#import "UMComShowToast.h"
#import "UMUtils.h"
#import "UIViewController+UMComAddition.h"
#import "UMComPushRequest.h"
#import "UMComUser+UMComManagedObject.h"
#import "UMComImageUrl.h"

#define NoticeLabelTag 10001

@interface UMComProfileSettingController ()


@end

@implementation UMComProfileSettingController
{
    UILabel *noticeLabel;
}


- (id)init
{
    self = [super initWithNibName:@"UMComProfileSettingController" bundle:nil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    if (self.registerError) {
        [UMComShowToast showFetchResultTipWithError:self.registerError];
    }
    if (!self.userAccount) {
        self.userAccount = [[UMComUserAccount alloc]initWithSnsType:UMComSnsTypeSelfAccount];
    }
    [self setUserProfile];

     self.genderButton.titleLabel.font = UMComFontNotoSansLightWithSafeSize(16);
    self.userPortrait.userInteractionEnabled = YES;
    self.userPortrait.clipsToBounds = YES;
    self.userPortrait.layer.cornerRadius =  self.userPortrait.frame.size.width/2;

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.nameField.delegate = self;
    int gender = [[UMComSession sharedInstance].loginUser.gender intValue];
    [self.genderPicker selectRow:gender inComponent:0 animated:NO];
    
    [self setRightButtonWithTitle:UMComLocalizedString(@"Save",@"保存") action:@selector(onClickSave)];
    [self setTitleViewWithTitle:UMComLocalizedString(@"ProfileSetting", @"设置")];
    
    UITapGestureRecognizer *userImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickChangeUserImage)];
    [self.userPortrait addGestureRecognizer:userImageGesture];
    
    [self.genderButton addTarget:self action:@selector(onClickChangeGender) forControlEvents:UIControlEventTouchUpInside];
    
    BOOL isOpen = NO;
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        isOpen = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
#endif
    } else {
        UIRemoteNotificationType notificationType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (notificationType != UIRemoteNotificationTypeNone) {
            isOpen = YES;
        } else {
            isOpen = NO;
        }
    }
    if (isOpen) {
        self.pushStatus.text = UMComLocalizedString(@"message_status_open",@"已开启");
    } else {
        self.pushStatus.text = UMComLocalizedString(@"message_status_close",@"已关闭");
    }
    
    _logoutButton.layer.borderColor = UMComColorWithColorValueString(@"FF9D0F").CGColor;
}

- (void)setGender:(NSInteger)gender
{
    if (gender == 0) {
        [self.genderButton setTitle:UMComLocalizedString(@"Female",@"女") forState:UIControlStateNormal];
    } else {
        [self.genderButton setTitle:UMComLocalizedString(@"Male",@"男") forState:UIControlStateNormal];
    }
}

- (void)onClickChangeUserImage
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (UIImage *)fixOrientation:(UIImage *)sourceImage
{
    // No-op if the orientation is already correct
    if (sourceImage.imageOrientation == UIImageOrientationUp) return sourceImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (sourceImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, sourceImage.size.width, sourceImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, sourceImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, sourceImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:;
    }
    
    switch (sourceImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, sourceImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, sourceImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, sourceImage.size.width, sourceImage.size.height,
                                             CGImageGetBitsPerComponent(sourceImage.CGImage), 0,
                                             CGImageGetColorSpace(sourceImage.CGImage),
                                             CGImageGetBitmapInfo(sourceImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (sourceImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,sourceImage.size.height,sourceImage.size.width), sourceImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,sourceImage.size.width,sourceImage.size.height), sourceImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *selectImage = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    
    if (selectImage) {
        selectImage = [self fixOrientation:selectImage];
        [self.userPortrait setImage:selectImage];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        self.userAccount.iconImage = selectImage;
        [UMComPushRequest updateWithUser:self.userAccount completion:^(NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdateUserProfileSuccess object:self];
        }];
    }
}

- (void)setUserProfile
{
    UMComUser *loginUser = [UMComSession sharedInstance].loginUser;
    self.userAccount.name = loginUser.name;
    self.userAccount.gender = loginUser.gender;
    self.userAccount.icon_url = loginUser.icon_url.small_url_string;
    
    [self.nameField setText:self.userAccount.name];
    NSString *imageName = @"female";
    if ([self.userAccount.gender integerValue] == 1) {
        imageName = @"male";
    }
    [self.userPortrait  setImageURL:self.userAccount.icon_url placeHolderImage:UMComImageWithImageName(imageName)];
    [self setGender:self.userAccount.gender.integerValue];
}


- (void)onClickChangeGender
{
    [self.nameField resignFirstResponder];
    self.genderPicker.hidden = NO;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0) {
        [self.genderButton setTitle:UMComLocalizedString(@"Female",@"女") forState:UIControlStateNormal];
    } else {
        [self.genderButton setTitle:UMComLocalizedString(@"Male",@"男") forState:UIControlStateNormal];
    }
    self.genderPicker.hidden = YES;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = nil;
    if (row == 1) {
        title = UMComLocalizedString(@"Male",@"男");
    }
    if (row == 0) {
        title = UMComLocalizedString(@"FeMale",@"女");
    }
    return title;
}


-(void)onClickClose
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

-(void)onClickSave
{
    
    [self.nameField resignFirstResponder];
    if (self.nameField.text.length < 2) {
        [[[UIAlertView alloc]initWithTitle:UMComLocalizedString(@"sorry", @"抱歉") message:UMComLocalizedString(@"The user nickname is too short", @"用户昵称太短了") delegate:nil cancelButtonTitle:UMComLocalizedString(@"OK", @"好的") otherButtonTitles:nil, nil] show];
        return;
    }
    if (self.nameField.text.length > 20) {
        [[[UIAlertView alloc]initWithTitle:UMComLocalizedString(@"sorry", @"抱歉") message:UMComLocalizedString(@"The user nickname is too long", @"用户昵称过长") delegate:nil cancelButtonTitle:UMComLocalizedString(@"OK", @"好的") otherButtonTitles:nil, nil] show];
        return;
    }
    if ([self isIncludeSpecialCharact:self.nameField.text]) {
        [[[UIAlertView alloc]initWithTitle:UMComLocalizedString(@"sorry", @"抱歉") message:UMComLocalizedString(@"The input character does not conform to the requirements", @"昵称只能包含中文、中英文字母、数字和下划线") delegate:nil cancelButtonTitle:UMComLocalizedString(@"OK", @"好的") otherButtonTitles:nil, nil] show];
        return;
    }
    
    self.userAccount.name = self.nameField.text;
    self.userAccount.gender = [NSNumber numberWithInteger:[self.genderPicker selectedRowInComponent:0]];
    __weak typeof(self) weakSelf = self;
    //如果从登录页面因为用户名错误，直接跳转到设置页面，先进行登录注册
    if (self.settingCompletion) {
        self.settingCompletion(self, self.userAccount);
    }else{
        [UMComPushRequest updateWithUser:self.userAccount completion:^(NSError *error) {
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:UpdateUserProfileSuccess object:weakSelf];
                
                if (weakSelf.navigationController.viewControllers.count > 1) {
                    if (self.updateCompletion) {
                        self.updateCompletion(nil, nil);
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } else {
                    [weakSelf dismissViewControllerAnimated:YES completion:^{
                        if (self.updateCompletion) {
                            self.updateCompletion(nil, nil);
                        }
                    }];
                }
            } else {
                [UMComShowToast showFetchResultTipWithError:error];
            }
            weakSelf.userAccount.icon_url = [UMComSession sharedInstance].loginUser.icon_url.small_url_string;
            [weakSelf setUserProfile];
        }];
    }

}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 20 && string.length > 0) {
        [self creatNoticeLabelWithView:textField];
        noticeLabel.text = UMComLocalizedString(@"The user nickname is too long", @"用户昵称过长") ;
        self.nameField.hidden = YES;
        noticeLabel.hidden = NO;
        string = nil;
        [self performSelector:@selector(hiddenNoticeView) withObject:nil afterDelay:0.8f];
        return NO;
    }
    if (string.length > 0 && [self isIncludeSpecialCharact:string]) {
        [self creatNoticeLabelWithView:textField];
        noticeLabel.text = UMComLocalizedString(@"The input character does not conform to the requirements", @"昵称只能包含中文、中英文字母、数字和下划线") ;
        noticeLabel.hidden = NO;
        self.nameField.hidden = YES;
        string = nil;
        [self performSelector:@selector(hiddenNoticeView) withObject:nil afterDelay:0.8f];
        return NO;
    }
    return YES;
}

- (void)creatNoticeLabelWithView:(UITextField *)textField
{
    if (!noticeLabel) {
        noticeLabel = [[UILabel alloc]initWithFrame:textField.frame];
        noticeLabel.backgroundColor = [UIColor clearColor];
        [textField.superview addSubview:noticeLabel];
        noticeLabel.textAlignment = NSTextAlignmentCenter;
        noticeLabel.textColor = [UIColor grayColor];
        noticeLabel.adjustsFontSizeToFitWidth = YES;
    }
}

- (void)hiddenNoticeView
{
    noticeLabel.hidden = YES;
    self.nameField.hidden = NO;
}

-(BOOL)isIncludeSpecialCharact:(NSString *)str {
    
    NSString *regex = @"(^[a-zA-Z0-9_\u4e00-\u9fa5]+$)";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isRight = ![pred evaluateWithObject:str];
    return isRight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logout:(id)sender {
    [[UMComSession sharedInstance] userLogout];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutSucceedNotification object:nil];
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}
@end
