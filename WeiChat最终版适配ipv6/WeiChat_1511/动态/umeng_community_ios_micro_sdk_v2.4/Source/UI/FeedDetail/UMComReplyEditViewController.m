//
//  UMComReplyEditViewController.m
//  UMCommunity
//
//  Created by 张军华 on 16/2/3.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComReplyEditViewController.h"
#import "UMComSession.h"
#import "UMComEmojiKeyboardView.h"
#import "UMComTools.h"
#import "UMImagePickerController.h"
#import "UMComNavigationController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <UIKit/UIImagePickerController.h>

const CGFloat g_ReplyEditView_EditMenuViewViewHeight = 45.f;//表情框的高度
const CGFloat g_ReplyEditView_leftMargin = 15.f;//控件的左边距间距

@interface UMComReplyEditViewController ()<UMComEmojiKeyboardViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>

//回复的编辑界面的view
@property(nonatomic,readwrite,strong)UMComPostReplyEditView* postReplyEditView;
@property(nonatomic,readwrite,strong)UITextView *textView;
@property(nonatomic,readwrite,strong)UILabel* placeholderLabel;
-(void)updateTextViewWord;

-(void)createImagePicker;
-(void)takePhoto;

@property (nonatomic, strong) UMComEmojiKeyboardView *emojiKeyboardView;
@property(nonatomic,readwrite,strong)UIView* menuView;//为标题控件对应
@property(nonatomic,strong)UIButton* emojiBtn;//点击表情的按钮
-(void)createPostReplyEditView;
-(void) createEmojiKeyboardView;
-(void) createMenuView;
-(void) showEmojiKeyboardViewWithTextView:(UITextView*)textview;
-(void) changeEmojiBtnImg:(BOOL)isEmoji withTextView:(UITextView*)textview;
-(void) appendEmoji:(NSString*)emoji withUITextView:(UITextView*)textview;

@end

@implementation UMComReplyEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    if (UMComSystem_Version_Greater_Than_Or_Equal_To(@"7.0")) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    [self createPostReplyEditView];
    [self.postReplyEditView displayWithMaxLength:[UMComSession sharedInstance].comment_length commitBlock:self.commitBlock cancelBlock:self.cancelBlock];
    

    __weak typeof(self) weakself = self;
    self.postReplyEditView.getImageBlock = ^(UMComPostReplyImagePickerType type){
        if (type == UMComPostReplyImagePickerCamera) {
            [weakself takePhoto];
        } else if(type == UMComPostReplyImagePickerLibrary){
            [weakself createImagePicker];
        }
        else{
            [weakself.textView becomeFirstResponder];
        }
    };
    //赋值给textView
    self.textView = self.postReplyEditView.textView;
    if (self.textView && self.commentcreator) {
        
        NSString* tempCommentTip = [[NSString alloc] initWithFormat:@"回复 %@:",self.commentcreator];
        //self.textView.text = tempCommentTip;
        //self.commentcreator = tempCommentTip;
        //设置提示语:todo....
        
        self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, -5,self.textView.bounds.size.width, 40)];
        self.placeholderLabel.font = self.textView.font;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textColor = [UIColor grayColor];
        _placeholderLabel.text = tempCommentTip;
        [self.textView addSubview:_placeholderLabel];
    }
    
    self.textView.delegate = self;
    

    [self createMenuView];
    
    [self createEmojiKeyboardView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    if (UMComSystem_Version_Greater_Than_Or_Equal_To(@"7.0")) {
        return YES;
    }
    return NO;
}

#pragma mark - new method
-(void)createPostReplyEditView
{
    NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:@"UMComPostReplyEditView" owner:self options:nil];
    UMComPostReplyEditView *replyView = viewArray[0];
    replyView.frame = self.view.bounds;
    self.postReplyEditView = replyView;
    [self.view addSubview:replyView];
}

-(void) createEmojiKeyboardView
{
    if (!self.emojiKeyboardView) {
        //添加表情控件
        UMComEmojiKeyboardView *emojiKeyboardView = [[UMComEmojiKeyboardView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 216) dataSource:nil];
        emojiKeyboardView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        emojiKeyboardView.delegate = self;
        self.emojiKeyboardView = emojiKeyboardView;
    }
}

-(void) createMenuView
{
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, g_ReplyEditView_EditMenuViewViewHeight)];
    self.menuView.backgroundColor = [UIColor whiteColor];
    
    UIButton* emojiBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat emojiBtn_y = (g_ReplyEditView_EditMenuViewViewHeight -30)/2;
    emojiBtn.frame = CGRectMake(g_ReplyEditView_leftMargin,emojiBtn_y,30,30);
    
    [emojiBtn addTarget:self action:@selector(handleBtnChangeEmojiBtnImg:) forControlEvents:UIControlEventTouchUpInside];
    
    //显示表情
    [emojiBtn setBackgroundImage:UMComImageWithImageName(@"um_edit_emoji_normal") forState:UIControlStateNormal];
    [emojiBtn setBackgroundImage:UMComImageWithImageName(@"um_edit_emoji_highlight") forState:UIControlStateHighlighted];
    
    [self.menuView addSubview:emojiBtn];
    self.emojiBtn = emojiBtn;
    
    UIView* separateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    separateView.backgroundColor = UMComColorWithColorValueString(@"eeeff3");
    [self.menuView addSubview:separateView];
    
    self.textView.inputAccessoryView = self.menuView;
}

-(void)updateTextViewWord
{
    if (self.textView.text.length <= 0) {
        self.placeholderLabel.hidden = NO;
    }
    else
    {
        self.placeholderLabel.hidden = YES;
    }
    
    if ([self.postReplyEditView respondsToSelector:@selector(textViewDidChange:)]){
        [self.postReplyEditView textViewDidChange:self.textView];
    }
}

-(void)handleBtnChangeEmojiBtnImg:(UIButton*)target
{
    [self showEmojiKeyboardViewWithTextView:self.textView];
}

-(void) showEmojiKeyboardViewWithTextView:(UITextView*)textview
{
    if (self.textView.inputView == nil) {
        self.textView.inputView = self.emojiKeyboardView;
        [self.textView resignFirstResponder];
        [self.textView becomeFirstResponder];
        [self changeEmojiBtnImg:NO withTextView:self.textView];
    } else {
        self.textView.inputView = nil;
        [self.textView resignFirstResponder];
        [self.textView becomeFirstResponder];
        [self changeEmojiBtnImg:YES withTextView:self.textView];
    }
}

-(void) changeEmojiBtnImg:(BOOL)isEmoji withTextView:(UITextView*)textview
{
    if (textview == self.textView)
    {
        if (isEmoji) {
            //显示表情
            [self.emojiBtn setBackgroundImage:UMComImageWithImageName(@"um_edit_emoji_normal") forState:UIControlStateNormal];
            [self.emojiBtn setBackgroundImage:UMComImageWithImageName(@"um_edit_emoji_highlight") forState:UIControlStateHighlighted];
        }
        else
        {
            //显示键盘
            [self.emojiBtn  setBackgroundImage:UMComImageWithImageName(@"um_edit_keyboard_normal") forState:UIControlStateNormal];
            [self.emojiBtn  setBackgroundImage:UMComImageWithImageName(@"um_edit_keyboard_highlight") forState:UIControlStateHighlighted];
        }
    }
}



#pragma mark - UMComEmojiKeyboardViewDelegate

/**
 Delegate method called when user taps an emoji button
 
 @param emojiKeyBoardView EmojiKeyBoardView object on which user has tapped.
 
 @param emoji Emoji used by user
 */
- (void)emojiKeyBoardView:(UMComEmojiKeyboardView *)emojiKeyBoardView
              didUseEmoji:(NSString *)emoji
{
    [self appendEmoji:emoji withUITextView:self.textView];
    
    [self updateTextViewWord];
}

-(void) appendEmoji:(NSString*)emoji withUITextView:(UITextView*)textview
{
    if (!emoji  || !textview) {
        return;
    }
    
    NSRange orgRange = textview.selectedRange;
    
    NSRange rangeBefore;
    rangeBefore.location = 0;
    rangeBefore.length = orgRange.location;
    NSString* orgBefore = [textview.text substringWithRange:[textview.text rangeOfComposedCharacterSequencesForRange:rangeBefore]];
    
    NSRange rangeAfter;
    rangeAfter.location = rangeBefore.location + rangeBefore.length;
    if (orgBefore) {
        //直接
        rangeAfter.length = textview.text.length - orgBefore.length;
    }
    else
    {
        //如果用rangeBefore.length操作，可能会有问题
        rangeAfter.length = textview.text.length -  rangeBefore.length;
    }
    
    NSString* orgAfter = [textview.text substringWithRange:[textview.text rangeOfComposedCharacterSequencesForRange:rangeAfter]];
    
    NSUInteger resultLocation = 0;
    NSMutableString* resultString = [[NSMutableString alloc] initWithCapacity:10];
    if (orgBefore) {
        
        [resultString appendString:orgBefore];
        resultLocation += orgBefore.length;
    }
    
    if (emoji) {
        [resultString appendString:emoji];
        resultLocation += emoji.length;
    }
    
    if (orgAfter) {
        [resultString appendString:orgAfter];
    }
    
    textview.text = resultString;
    textview.selectedRange = NSMakeRange(resultLocation, 0);
}

/**
 Delegate method called when user taps on the backspace button
 
 @param emojiKeyBoardView EmojiKeyBoardView object on which user has tapped.
 */
- (void)emojiKeyBoardViewDidPressBackSpace:(UMComEmojiKeyboardView *)emojiKeyBoardView
{
    [self.textView deleteBackward];
    [self updateTextViewWord];
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *selectImage = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *tempImage = nil;
    if (selectImage.imageOrientation != UIImageOrientationUp) {
        UIGraphicsBeginImageContext(selectImage.size);
        [selectImage drawInRect:CGRectMake(0, 0, selectImage.size.width, selectImage.size.height)];
        tempImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else{
        tempImage = selectImage;
    }
    [self.postReplyEditView addPickedImage:tempImage];
}

-(void)takePhoto
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted)
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"本应用无访问相机的权限，如需访问，可在设置中修改" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
            return;
        }
    }else{
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusDenied || author == ALAuthorizationStatusRestricted)
        {
            [[[UIAlertView alloc] initWithTitle:nil message:@"本应用无访问相机的权限，如需访问，可在设置中修改" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
            return;
        }
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        __weak typeof(self) weakself = self;
        [self presentViewController:imagePicker animated:YES completion:^{
            [weakself.textView becomeFirstResponder];
        }];
    }
}

- (void)createImagePicker
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
    {
        [[[UIAlertView alloc] initWithTitle:nil message:@"本应用无访问照片的权限，如需访问，可在设置中修改" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
        return;
    }
    if([UMImagePickerController isAccessible])
    {
        UMImagePickerController *imagePickerController = [[UMImagePickerController alloc] init];
        imagePickerController.minimumNumberOfSelection = 1;
        imagePickerController.maximumNumberOfSelection = 1;
        
        __weak typeof(self) ws = self;
        [imagePickerController setFinishHandle:^(BOOL isCanceled,NSArray *assets){
            if(!isCanceled)
            {
                [ws.postReplyEditView setImageAssets:assets];
            }
        }];
        
        UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:imagePickerController];
        __weak typeof(self) weakself = self;
        [self presentViewController:navigationController animated:YES completion:^{
            [weakself.textView becomeFirstResponder];
        }];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
//    NSLog(@"UMComReplyEditViewController...textViewDidChange");
    [self updateTextViewWord];
}

#pragma mark - 键盘监听事件

-(void)keyboardWillShow:(NSNotification*)notification
{
    CGRect keybordFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:.3f animations:^{
        
        // adapting for short device
        ws.postReplyEditView.contentHeightConstraints.constant = self.view.frame.size.height - keybordFrame.size.height;
//        if (ws.postReplyEditView.contentHeightConstraints.constant == 300) {
//            CGFloat offset = ws.postReplyEditView.contentView.frame.origin.y - keybordFrame.size.height;
//            if (offset < 0) {
//                if (ws.postReplyEditView.contentHeightConstraints.constant + offset < 0) {
//                    ws.postReplyEditView.contentHeightConstraints.constant = 0;
//                } else {
//                    ws.postReplyEditView.contentHeightConstraints.constant += offset;
//                }
//            }
//        }
        
        ws.postReplyEditView.contentBottomConstraints.constant = keybordFrame.size.height;
        [ws.postReplyEditView.contentView layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)keyboardDidShow:(NSNotification*)notification
{
    
}

-(void)keyboardWillHide:(NSNotification*)notification
{
}

-(void)keyboardDidHide:(NSNotification*)notification
{
    CGRect keybordFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float endheight = keybordFrame.size.height;
    
    CGRect tempEditViewFrame =  self.postReplyEditView.contentView.frame;
    
    CGRect tempViewFrame = self.view.frame;
    
    CGFloat orgY =  tempViewFrame.size.height - endheight - tempEditViewFrame.size.height;
    tempEditViewFrame.origin.y = orgY;
    self.postReplyEditView.contentView.frame = tempEditViewFrame;

}

@end
