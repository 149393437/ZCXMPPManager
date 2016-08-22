//  Created by zhangcheng on 16/3/14.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//     _                            _
// ___| |__   __ _ _ __   __ _  ___| |__   ___ _ __   __ _
//|_  / '_ \ / _` | '_ \ / _` |/ __| '_ \ / _ \ '_ \ / _` |
// / /| | | | (_| | | | | (_| | (__| | | |  __/ | | | (_| |
///___|_| |_|\__,_|_| |_|\__, |\___|_| |_|\___|_| |_|\__, |
//                       |___/                       |___/

//小张诚技术博客http://blog.sina.com.cn/u/2914098025
//github代码地址https://github.com/149393437
//欢迎加入iOS研究院 QQ群号305044955    你的关注就是我开源的动力

#import "ZCMessageToolBar.h"

#import <BQMM/BQMM.h>
#import "MMTextParser+ExtData.h"
#import "LocationViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Photo.h"

@interface ZCMessageToolBar()<UITextViewDelegate, MMEmotionCentreDelegate>
{
    CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
}

@property (nonatomic) CGFloat version;

/**
 *  背景
 */
@property (strong, nonatomic) UIImageView *toolbarBackgroundImageView;
@property (strong, nonatomic) UIImageView *backgroundImageView;

/**
 *  按钮、输入框、toolbarView
 */
@property (strong, nonatomic) UIView *toolbarView;
@property (strong, nonatomic) UIButton *styleChangeButton;
@property (strong, nonatomic) UIButton *moreButton;
@property (strong, nonatomic) UIButton *faceButton;

/**
 *  底部扩展页面
 */
@property (nonatomic) BOOL isShowButtomView;
@property (strong, nonatomic) UIView *activityButtomView;//当前活跃的底部扩展页面

@end

@implementation ZCMessageToolBar
-(instancetype)initWithBlock:(void(^)(NSString*sign,NSString*message))a
{
   
    CGRect rect=CGRectMake(0, [UIScreen mainScreen].bounds.size.height-45, [UIScreen mainScreen].bounds.size.width, 45);
    
    self = [super initWithFrame:rect];
    if (self) {
        _isQQ=YES;
        //创建UI
        //判断本地是否有主题地址,如果没有地址,使用当前工程目录下的地址
        if (_isQQ) {
            //使用QQ主题
            NSString*theme=[[NSUserDefaults standardUserDefaults]objectForKey:@"theme"];
            if (theme) {
                _path=[NSString stringWithFormat:@"%@%@/",[NSString stringWithFormat:@"%@/",[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]],[[NSUserDefaults standardUserDefaults] objectForKey:@"theme"]];
            }else{
                _path=[NSString stringWithFormat:@"%@/",[[NSBundle mainBundle]bundlePath]];
                
            }
        }else{
            //使用默认简约
            _path=[NSString stringWithFormat:@"%@/",[[NSBundle mainBundle]bundlePath]];
        }
        
        
        
        
        [self setupSubviews];
        
        //检测音频
        [self detectionAudio];
        
        self.MyBlock=a;
    }
    return self;
}
-(void)detectionAudio{
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                NSLog(@"Microphone is enabled..");
                
            }
            else {
                // Microphone disabled code
                NSLog(@"Microphone is disabled..");
                
                // We're in a background thread here, so jump to main thread to do UI work.
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"Microphone Access Denied"
                                                 message:@"This app requires access to your device's Microphone.\n\nPlease enable Microphone access for this app in Settings / Privacy / Microphone"
                                                delegate:nil
                                       cancelButtonTitle:@"Dismiss"
                                       otherButtonTitles:nil] show];
                });
            }
        }];
    }

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [_inputTextView removeObserver:self forKeyPath:@"frame"];
    _MyBlock=nil;
    _inputTextView.delegate = nil;
    _inputTextView = nil;
}
-(UIImage*)imageNameToImageStr:(NSString*)imageName{
    
    
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",self.path,imageName]];

}

#pragma mark - getter

- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.backgroundColor = [UIColor clearColor];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    return _backgroundImageView;
}

- (UIImageView *)toolbarBackgroundImageView
{
    if (_toolbarBackgroundImageView == nil) {
        _toolbarBackgroundImageView = [[UIImageView alloc] init];
        _toolbarBackgroundImageView.backgroundColor = [UIColor clearColor];
        _toolbarBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return _toolbarBackgroundImageView;
}

- (UIView *)toolbarView
{
    if (_toolbarView == nil) {
        _toolbarView = [[UIView alloc] init];
        _toolbarView.backgroundColor = [UIColor clearColor];
    }
    
    return _toolbarView;
}

#pragma mark - setter

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
}

- (void)setToolbarBackgroundImage:(UIImage *)toolbarBackgroundImage
{
    _toolbarBackgroundImage = toolbarBackgroundImage;
    self.toolbarBackgroundImageView.image = toolbarBackgroundImage;
}

- (void)setMaxTextInputViewHeight:(CGFloat)maxTextInputViewHeight
{
    if (maxTextInputViewHeight > kInputTextViewMaxHeight) {
        maxTextInputViewHeight = kInputTextViewMaxHeight;
    }
    _maxTextInputViewHeight = maxTextInputViewHeight;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    self.faceButton.selected = NO;
    self.styleChangeButton.selected = NO;
    self.moreButton.selected = NO;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    
   
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        self.MyBlock(@"[1]",textView.mmText);
            self.inputTextView.text = @"";
            [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];
        
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.markedTextRange == nil) {
        NSRange selectedRange = textView.selectedRange;
        textView.mmText = textView.mmText;
        textView.selectedRange = selectedRange;
    }
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
}

#pragma mark - UIKeyboardNotification

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)() = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    
    void(^completion)(BOOL) = ^(BOOL finished){
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:completion];
}

#pragma mark - private


- (void)setupSubviews
{
    
    self.version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    self.maxTextInputViewHeight = kInputTextViewMaxHeight;
    
    self.activityButtomView = nil;
    self.isShowButtomView = NO;
    self.backgroundImageView.image =_isQQ==NO?[[UIImage imageNamed:@"messageToolbarBg"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:10]:[self imageNameToImageStr:@"chat_bottom_bg.png"];
    [self addSubview:self.backgroundImageView];
    
    self.toolbarView.frame = CGRectMake(0, 0, self.frame.size.width, kVerticalPadding * 2 + kInputTextViewMinHeight);
    self.toolbarBackgroundImageView.frame = self.toolbarView.bounds;
    [self.toolbarView addSubview:self.toolbarBackgroundImageView];
    [self addSubview:self.toolbarView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    CGFloat allButtonWidth = 0.0;
    CGFloat textViewLeftMargin = 6.0;
    
    //转变输入样式
    self.styleChangeButton = [[UIButton alloc] initWithFrame:CGRectMake(kHorizontalPadding, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
    self.styleChangeButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.styleChangeButton setImage:_isQQ==NO?[UIImage imageNamed:@"chatBar_record"]:[self imageNameToImageStr:@"chat_bottom_voice_nor.png"] forState:UIControlStateNormal];
    [self.styleChangeButton setImage:_isQQ==NO?[UIImage imageNamed:@"chatBar_keyboard"]:[self imageNameToImageStr:@"chat_bottom_keyboard_nor.png"] forState:UIControlStateSelected];
    [self.styleChangeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.styleChangeButton.tag = 0;
    allButtonWidth += CGRectGetMaxX(self.styleChangeButton.frame);
    textViewLeftMargin += CGRectGetMaxX(self.styleChangeButton.frame);
    
    //更多
    self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - kHorizontalPadding - kInputTextViewMinHeight, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
    self.moreButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.moreButton setImage:_isQQ==NO?[UIImage imageNamed:@"chatBar_more"]:[self imageNameToImageStr:@"chat_bottom_up_nor.png"] forState:UIControlStateNormal];
    [self.moreButton setImage:_isQQ==NO?[UIImage imageNamed:@"chatBar_moreSelected"]:[self imageNameToImageStr:@"chat_bottom_up_press.png"] forState:UIControlStateHighlighted];
    [self.moreButton setImage:_isQQ==NO?[UIImage imageNamed:@"chatBar_keyboard"]:[self imageNameToImageStr:@"chat_bottom_up_disable.png"] forState:UIControlStateSelected];
    [self.moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.moreButton.tag = 2;
    allButtonWidth += CGRectGetWidth(self.moreButton.frame) + kHorizontalPadding * 2.5;
    
    //表情
    self.faceButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.moreButton.frame) - kInputTextViewMinHeight - kHorizontalPadding, kVerticalPadding, kInputTextViewMinHeight, kInputTextViewMinHeight)];
    self.faceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.faceButton setImage:_isQQ==NO?[UIImage imageNamed:@"chatBar_face"]:[self imageNameToImageStr:@"chat_bottom_smile_nor.png"] forState:UIControlStateNormal];
    [self.faceButton setImage:_isQQ==NO?[UIImage imageNamed:@"chatBar_faceSelected"]:[self imageNameToImageStr:@"chat_bottom_smile_press.png"] forState:UIControlStateHighlighted];
    [self.faceButton setImage:_isQQ==NO?[UIImage imageNamed:@"chatBar_keyboard"]:[self imageNameToImageStr:@"chat_bottom_keyboard_nor.png"] forState:UIControlStateSelected];
    [self.faceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.faceButton.tag = 1;
    allButtonWidth += CGRectGetWidth(self.faceButton.frame) + kHorizontalPadding * 1.5;
    
    
    // 输入框的高度和宽度
    CGFloat width = CGRectGetWidth(self.bounds) - (allButtonWidth ? allButtonWidth : (textViewLeftMargin * 2));
    // 初始化输入框
    self.inputTextView = [[XHMessageTextView  alloc] initWithFrame:CGRectMake(textViewLeftMargin, kVerticalPadding, width, kInputTextViewMinHeight)];
    self.inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    self.inputTextView.contentMode = UIViewContentModeCenter;
    _inputTextView.scrollEnabled = YES;
    _inputTextView.returnKeyType = UIReturnKeySend;
    _inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    _inputTextView.placeHolder = @"请输入内容";
    _inputTextView.delegate = self;
    self.inputTextView.backgroundColor=[UIColor clearColor];
    if (_isQQ) {
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _inputTextView.frame.size.width, _inputTextView.frame.size.height)];
        
        imgView.image = [[self imageNameToImageStr:@"chat_bottom_textfield.png"]stretchableImageWithLeftCapWidth:40 topCapHeight:20];
        
        [_inputTextView addSubview:imgView];
        
        [_inputTextView sendSubviewToBack: imgView];
        
        //设置观察者
        [_inputTextView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        

    }else{
        _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
        _inputTextView.layer.borderWidth = 0.65f;
        _inputTextView.layer.cornerRadius = 6.0f;
    }
    
    _previousTextViewContentHeight = [self getTextViewContentH:_inputTextView];
    
    //录制
    self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake(textViewLeftMargin, kVerticalPadding, width, kInputTextViewMinHeight)];
    self.recordButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.recordButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.recordButton setBackgroundImage:_isQQ==NO?[[UIImage imageNamed:@"chatBar_recordBg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]:[self imageNameToImageStr:@"chat_bottom_textfield.png"] forState:UIControlStateNormal];
    [self.recordButton setBackgroundImage:_isQQ==NO?[[UIImage imageNamed:@"chatBar_recordSelectedBg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]:[self imageNameToImageStr:@"chat_bottom_textfield.png"] forState:UIControlStateHighlighted];
    [self.recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.recordButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
    [self.recordButton addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.recordButton addTarget:self action:@selector(recordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self.recordButton addTarget:self action:@selector(recordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.recordButton addTarget:self action:@selector(recordDragOutside) forControlEvents:UIControlEventTouchDragExit];
    [self.recordButton addTarget:self action:@selector(recordDragInside) forControlEvents:UIControlEventTouchDragEnter];
    self.recordButton.hidden = YES;
    
    if (!_moreView) {
        _moreView = [[ZCChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), self.frame.size.width, 80) type:ChatMoreTypeGroupChat];
        _moreView.delegate=self;
        _moreView.backgroundColor = [UIColor lightGrayColor];
        _moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    //语音键盘输入
    [self.toolbarView addSubview:self.styleChangeButton];
    //更多按钮
    [self.toolbarView addSubview:self.moreButton];
    //表情按钮
    [self.toolbarView addSubview:self.faceButton];
    //文本输入框
    [self.toolbarView addSubview:self.inputTextView];
    //语音按钮
    [self.toolbarView addSubview:self.recordButton];
    
    [[MMEmotionCentre defaultCentre] shouldShowShotcutPopoverAboveView:self.faceButton withInput:self.inputTextView];
    
    //对表情包进行初始化操作
    [[MMEmotionCentre defaultCentre] setAppId:BQMM_APPID secret:BQMM_SECRET];
    [MMEmotionCentre defaultCentre].delegate = self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    imgView.frame =CGRectMake(0, 0, _inputTextView.frame.size.width, _inputTextView.frame.size.height);
}

#pragma mark DXChatBarMoreViewDelegate

- (void)moreViewTakePicAction:(ZCChatBarMoreView *)moreView
{
    NSLog(@"相机");
    
    UIImagePickerController*vc=[[UIImagePickerController alloc]init];
    vc.delegate=self;
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        vc.sourceType=UIImagePickerControllerSourceTypeCamera;
    }
    //获取顶层VC
    UIViewController*top;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            top=(UIViewController*)nextResponder;
        }  
    }
    if (top) {
        [top presentViewController:vc animated:YES completion:nil];
    }
    
    
}
- (void)moreViewPhotoAction:(ZCChatBarMoreView *)moreView
{
    NSLog(@"相册");
    UIImagePickerController*vc=[[UIImagePickerController alloc]init];
    vc.delegate=self;
    //获取顶层VC
    UIViewController*top;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            top=(UIViewController*)nextResponder;
        }
    }
    if (top) {
        [top presentViewController:vc animated:YES completion:nil];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage*image=[info objectForKey:UIImagePickerControllerOriginalImage];
    NSString*str=[Photo image2String:image];
    self.MyBlock(@"[3]",str);
    
    [picker dismissViewControllerAnimated:YES completion:nil];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    [picker dismissViewControllerAnimated:YES completion:nil];

}


- (void)moreViewLocationAction:(ZCChatBarMoreView *)moreView
{
    NSLog(@"定位");
    LocationViewController*vc=[LocationViewController shareSendLocationBlock:^(NSString *locationStr) {
        self.MyBlock(@"[5]",locationStr);

    }];
 
    //获取顶层VC
    UIViewController*top;
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            top=(UIViewController*)nextResponder;
        }
    }
    if (top) {
        [top presentViewController:vc animated:YES completion:nil];
    }
}
- (void)moreViewAudioCallAction:(ZCChatBarMoreView *)moreView
{
    NSLog(@"音频");
}
- (void)moreViewVideoCallAction:(ZCChatBarMoreView *)moreView
{
    NSLog(@"视频");
}

#pragma mark - change frame

- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.toolbarView.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
    if(bottomHeight == 0 && self.frame.size.height == self.toolbarView.frame.size.height)
    {
        return;
    }
    
    if (bottomHeight == 0) {
        self.isShowButtomView = NO;
    }
    else{
        self.isShowButtomView = YES;
    }
    
    self.frame = toFrame;
    
    
}

- (void)willShowBottomView:(UIView *)bottomView
{
    if (![self.activityButtomView isEqual:bottomView]) {
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        [self willShowBottomHeight:bottomHeight];
        
        if (bottomView) {
            CGRect rect = bottomView.frame;
            rect.origin.y = CGRectGetMaxY(self.toolbarView.frame);
            bottomView.frame = rect;
            [self addSubview:bottomView];
        }
        
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = bottomView;
    }
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        //一定要把self.activityButtomView置为空
        [self willShowBottomHeight:toFrame.size.height];
        if (self.activityButtomView) {
            [self.activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
    }
    else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        [self willShowBottomHeight:0];
    }
    else{
        [self willShowBottomHeight:toFrame.size.height];
    }
}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight < kInputTextViewMinHeight) {
        toHeight = kInputTextViewMinHeight;
    }
    if (toHeight > self.maxTextInputViewHeight) {
        toHeight = self.maxTextInputViewHeight;
    }
    
    if (toHeight == _previousTextViewContentHeight)
    {
        return;
    }
    else{
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.toolbarView.frame;
        rect.size.height += changeHeight;
        self.toolbarView.frame = rect;
        
        if (self.version < 7.0) {
            [self.inputTextView setContentOffset:CGPointMake(0.0f, (self.inputTextView.contentSize.height - self.inputTextView.frame.size.height) / 2) animated:YES];
        }
        _previousTextViewContentHeight = toHeight;
        
       
    }
}

- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    if (self.version >= 7.0)
    {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - action

- (void)buttonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    NSInteger tag = button.tag;
    
    switch (tag) {
        case 0://切换状态
        {
            if (button.selected) {
                self.faceButton.selected = NO;
                self.moreButton.selected = NO;
                //录音状态下，不显示底部扩展页面
                [self willShowBottomView:nil];
                
                //将inputTextView内容置空，以使toolbarView回到最小高度
                self.inputTextView.text = @"";
                [self textViewDidChange:self.inputTextView];
                [self.inputTextView resignFirstResponder];
            }
            else{
                //键盘也算一种底部扩展页面
                [self.inputTextView becomeFirstResponder];
            }
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.recordButton.hidden = !button.selected;
                self.inputTextView.hidden = button.selected;
            } completion:^(BOOL finished) {
                
            }];
            
           
        }
            break;
        case 1://表情
        {

            if (self.styleChangeButton.selected) {
                self.styleChangeButton.selected = NO;
                self.recordButton.hidden = YES;
                self.inputTextView.hidden = NO;
            }
            if (button.isSelected) {
                self.moreButton.selected = NO;
                
                if (!_inputTextView.isFirstResponder) {
                    [_inputTextView becomeFirstResponder];
                }
                [[MMEmotionCentre defaultCentre] attachEmotionKeyboardToInput:_inputTextView];
                self.faceButton.selected = YES;
            }
            else {
                [[MMEmotionCentre defaultCentre] switchToDefaultKeyboard];
            }
        }
            break;
        case 2://更多
        {
            if (button.selected) {
                self.faceButton.selected = NO;
                //如果选择表情并且处于录音状态，切换成文字输入状态，但是不显示键盘
                if (self.styleChangeButton.selected) {
                    self.styleChangeButton.selected = NO;
                }
                else{//如果处于文字输入状态，使文字输入框失去焦点
                    [self.inputTextView resignFirstResponder];
                }

                [self willShowBottomView:self.moreView];
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.recordButton.hidden = button.selected;
                    self.inputTextView.hidden = !button.selected;
                } completion:^(BOOL finished) {
                    
                }];
            }
            else
            {
                self.styleChangeButton.selected = NO;
                [self.inputTextView becomeFirstResponder];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 开始录音
- (void)recordButtonTouchDown
{
    if (_audio==nil) {
        //加载录音模块
        _audio=[ZCChatAudioPlay sharedInstance];

    }
    [_audio startRecording];
    
    if (_audio) {
        _audio.recorderVC.recorderView.countDownLabel.text=@"松开手指,发送语音";
        _audio.recorderVC.recorderView.backgroundColor=[UIColor clearColor];

    }

}
#pragma mark  取消录音
- (void)recordButtonTouchUpOutside
{
    NSLog(@"recordButtonTouchUpOutside");
    if (_audio) {
        _audio.recorderVC.recorderView.countDownLabel.text=@"松开手指,取消录音";
        _audio.recorderVC.recorderView.backgroundColor=[UIColor redColor];
    }
    
    //结束录音
    if (_audio) {
        [_audio endRecordingWithBlock:^(NSString *aa) {
            
        }];
        //不进行处理
    }

}
#pragma mark 手指松开完成录音
- (void)recordButtonTouchUpInside
{
    NSLog(@"recordButtonTouchUpInside");
    if (_audio) {
        _audio.recorderVC.recorderView.countDownLabel.text=@"结束录音";
        _audio.recorderVC.recorderView.backgroundColor=[UIColor clearColor];
    }

    [_audio endRecordingWithBlock:^(NSString *aa) {
        
        if (self.MyBlock) {
            if (aa.length>50) {
                self.MyBlock(@"[2]",aa);
            }else{
            //录制时间太短
              if (hudLabel==nil) {
                    hudLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-100, 20)];
                    hudLabel.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, -200);
                    hudLabel.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
                    hudLabel.text=@"录音时间太短!无法发送";
                    hudLabel.textAlignment=NSTextAlignmentCenter;
                    hudLabel.textColor=[UIColor whiteColor];

                    [self addSubview:hudLabel];

                }
                [self bringSubviewToFront:hudLabel];
                hudLabel.hidden=NO;
            [self performSelector:@selector(hudHide) withObject:nil afterDelay:0.5];
            }
        }
    }
    ];
   
}
-(void)hudHide{
    hudLabel.hidden=YES;
}
#pragma makr  手指移动到录音按钮外部

- (void)recordDragOutside
{
    NSLog(@"recordDragOutside");
    if (_audio) {

    _audio.recorderVC.recorderView.countDownLabel.text=@"松开手指,取消录音";
    _audio.recorderVC.recorderView.backgroundColor=[UIColor redColor];
    
    }

}
#pragma mark 手指移动到录音按钮内部
- (void)recordDragInside
{
    NSLog(@"recordDragInside");
    if (_audio) {

    _audio.recorderVC.recorderView.backgroundColor=[UIColor clearColor];
    _audio.recorderVC.recorderView.countDownLabel.text=@"手指上滑,取消发送";
    }
}

#pragma mark - public

/**
 *  停止编辑
 */
- (BOOL)endEditing:(BOOL)force
{
    BOOL result = [super endEditing:force];
    
    self.faceButton.selected = NO;
    self.moreButton.selected = NO;
    [self willShowBottomView:nil];
    [[MMEmotionCentre defaultCentre] switchToDefaultKeyboard];
    
    return result;
}



+ (CGFloat)defaultHeight
{
    return kVerticalPadding * 2 + kInputTextViewMinHeight;
}

//表情MM代理
#pragma mark - *MMEmotionCentreDelegate
- (void)didSelectEmoji:(MMEmoji *)emoji
{
    if (self.MyBlock) {
        self.MyBlock(@"[4]",emoji.emojiCode);
    }
  
}

- (void)didSelectTipEmoji:(MMEmoji *)emoji
{
    if (self.MyBlock) {
        self.MyBlock(@"[4]",emoji.emojiName);
        self.inputTextView.text = @"";
    }
}

- (void)didSendWithInput:(UIResponder<UITextInput> *)input
{
    if (self.MyBlock) {
       
        self.MyBlock(@"[1]",_inputTextView.mmText);
        self.inputTextView.text = @"";
        [self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];
    }
}

- (void)tapOverlay
{
    self.faceButton.selected = NO;
}
-(void)hideKeyBorard
{
//放弃键盘的响应对象
    [_inputTextView resignFirstResponder];
    self.faceButton.selected=YES;
    if (self.faceButton.selected==YES) {
        [self buttonAction:_faceButton];

    }
    if (self.moreButton.selected==YES) {
        [self buttonAction:self.moreButton];
    }
}


@end













