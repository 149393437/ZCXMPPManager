//
//  UMComCommentEditView.m
//  UMCommunity
//
//  Created by umeng on 15/7/22.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComCommentEditView.h"
#import "UMComEmojiKeyBoardView.h"
#import "UMComTools.h"
#import "UMComShowToast.h"
#import "UMComSession.h"


@interface UMComCommentEditView ()<UITextFieldDelegate,UMComEmojiKeyboardViewDelegate>

@property (nonatomic, strong) UIView *commentInputView;

@property (nonatomic, strong) UIButton *emojiButton;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) UMComEmojiKeyboardView *emojiKeyboardView;

@property (nonatomic, strong) UILabel *noticeLabel;

@property (nonatomic, strong) NSString *lastText;

@property (nonatomic, strong) UIView *mySuperView;


@end


@implementation UMComCommentEditView

- (instancetype)initWithSuperView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.view = [[UIView alloc]initWithFrame:view.bounds];
        self.view.backgroundColor = [UIColor blackColor];
        self.view.alpha = 0.3;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAllEditView)];
        [self.view addGestureRecognizer:tap];
        [self creatCommentTextField];
        self.mySuperView = view;
    }
    return self;
}

- (void)creatCommentTextField
{
    NSArray *commentInputNibs = [[NSBundle mainBundle]loadNibNamed:@"UMComCommentInput" owner:self options:nil];
    self.maxTextLenght = [UMComSession sharedInstance].comment_length;
    //得到第一个UIView
    UIView *commentInputView = [commentInputNibs objectAtIndex:0];
    self.commentInputView = commentInputView;
    [self.commentInputView addSubview:[self creatSpaceLineWithWidth:self.mySuperView.frame.size.width]];
    self.commentTextField = [commentInputView.subviews objectAtIndex:2];
    self.emojiButton = [commentInputView.subviews objectAtIndex:0];
    self.sendButton = [commentInputView.subviews objectAtIndex:1];
    self.commentTextField.delegate = self;
    self.commentInputView.hidden = YES;
    self.commentTextField.hidden = YES;
    self.commentTextField.delegate = self;
    self.commentInputView.frame = CGRectMake(0,  self.view.frame.size.height, self.view.frame.size.width, self.commentInputView.frame.size.height);
    self.commentTextField.center = self.commentInputView.center;

    [self.emojiButton addTarget:self action:@selector(presentEmoji) forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton addTarget:self action:@selector(sendCommend) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    UMComEmojiKeyboardView *emojiKeyboardView = [[UMComEmojiKeyboardView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216) dataSource:nil];
    emojiKeyboardView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    emojiKeyboardView.delegate = self;
    self.emojiKeyboardView = emojiKeyboardView;
    
    [self.commentTextField addTarget:self action:@selector(onChangeTextField) forControlEvents:UIControlEventEditingChanged];
}

- (void)sendCommend
{
    if (self.commentTextField.text.length > self.maxTextLenght) {
        [UMComShowToast commentMoreWord];
        return;
    }
    if (self.SendCommentHandler) {
        self.SendCommentHandler(self.commentTextField.text);
    }
    [self dismissAllEditView];
}

- (void)presentEmoji
{
    if (self.commentTextField.inputView == nil) {
        self.commentTextField.inputView = self.emojiKeyboardView;
        [self.commentTextField resignFirstResponder];
        [self.commentTextField becomeFirstResponder];
        [self.emojiButton setImage:UMComImageWithImageName(@"um_keyboard") forState:UIControlStateNormal];
    } else {
        [self.emojiButton setImage:UMComImageWithImageName(@"um_emoji") forState:UIControlStateNormal];
        self.commentTextField.inputView = nil;
        [self.commentTextField resignFirstResponder];
        [self.commentTextField becomeFirstResponder];
    }
}

- (void)emojiKeyBoardView:(UMComEmojiKeyboardView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji
{
    NSString * commentString = [self.commentTextField.text stringByAppendingString:emoji];
    if (commentString.length > self.maxTextLenght) {
        [UMComShowToast commentMoreWord];
        self.commentTextField.text = self.lastText;
        return;
    } else {
        self.commentTextField.text = commentString;
    }
    self.lastText = self.commentTextField.text;
}

- (void)emojiKeyBoardViewDidPressBackSpace:(UMComEmojiKeyboardView *)emojiKeyBoardView {
    [self.commentTextField deleteBackward];
}

- (UIColor *)randomColor {
    return [UIColor colorWithRed:drand48()
                           green:drand48()
                            blue:drand48()
                           alpha:drand48()];
}

- (UIImage *)randomImage {
    CGSize size = CGSizeMake(30, 10);
    UIGraphicsBeginImageContextWithOptions(size , NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *fillColor = [self randomColor];
    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextFillRect(context, rect);
    
    fillColor = [self randomColor];
    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    CGFloat xxx = 3;
    rect = CGRectMake(xxx, xxx, size.width - 2 * xxx, size.height - 2 * xxx);
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)emojiKeyboardView:(UMComEmojiKeyboardView *)emojiKeyboardView imageForSelectedCategory:(UMComEmojiKeyboardViewCategoryImage)category {
    UIImage *img = [self randomImage];
    [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}

- (UIImage *)emojiKeyboardView:(UMComEmojiKeyboardView *)emojiKeyboardView imageForNonSelectedCategory:(UMComEmojiKeyboardViewCategoryImage)category {
    UIImage *img = [self randomImage];
    [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}

- (UIImage *)backSpaceButtonImageForEmojiKeyboardView:(UMComEmojiKeyboardView *)emojiKeyboardView {
    //替换删除按钮
    UIImage *img = UMComImageWithImageName(@"um_emoji_delete");
    return img;
}

- (UIView *)creatSpaceLineWithWidth:(CGFloat)width
{
    UIView *spaceLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 0.3)];
    spaceLine.backgroundColor = UMComTableViewSeparatorColor;
    spaceLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return spaceLine;
}

-(void)presentEditView
{
    self.commentTextField.text = @"";
    NSString *chContent = [NSString stringWithFormat:@"评论内容不能超过%d个字符",(int)self.maxTextLenght];
    NSString *key = [NSString stringWithFormat:@"Content must not exceed %d characters",(int)self.maxTextLenght];
    self.commentTextField.placeholder = UMComLocalizedString(key,chContent);
    self.commentTextField.hidden = NO;
    self.commentInputView.hidden = NO;
    if (!self.view.superview) {
        [self.mySuperView addSubview:self.view];
        [self.mySuperView addSubview:self.commentInputView];
        [self.mySuperView addSubview:self.commentTextField];
    }
    [self.commentTextField becomeFirstResponder];
}

- (void)dismissAllEditView
{
    [self.view removeFromSuperview];
    if ([self.commentTextField becomeFirstResponder]) {
        [self.commentTextField resignFirstResponder];
        [self.commentTextField removeFromSuperview];
        [self.commentInputView removeFromSuperview];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.commentTextField.text.length > self.maxTextLenght) {
        [UMComShowToast commentMoreWord];
        return NO;
    }
    if (self.SendCommentHandler) {
        self.SendCommentHandler(textField.text);
    }
    [self dismissAllEditView];
    return YES;
}

- (void)onChangeTextField
{
    NSInteger textLenght = self.commentTextField.text.length;
    if (textLenght > self.maxTextLenght) {
        [UMComShowToast commentMoreWord];
        NSString *sunString = [self.commentTextField.text substringWithRange:NSMakeRange(0, self.maxTextLenght)];
        self.commentTextField.text = sunString;
        return;
    }
    self.lastText = self.commentTextField.text;
}


- (void)hidenNoticeLabel
{
    self.noticeLabel.hidden = YES;
    self.commentTextField.hidden = NO;
}

/*
- (void)keyboardWillShow:(NSNotification*)notification {
    
    [self.mySuperView bringSubviewToFront:self.commentInputView];
    [self.mySuperView bringSubviewToFront:self.commentTextField];
    CGRect  keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.commentInputView.center = CGPointMake(self.mySuperView.frame.size.width/2, keyBoardFrame.origin.y - self.commentInputView.frame.size.height/2);
    self.commentTextField.center = self.commentInputView.center;
    CGRect viewFrame = self.mySuperView.frame;
    viewFrame.size.height = keyBoardFrame.size.height + self.commentInputView.frame.size.height;
    viewFrame.origin.y = self.commentInputView.frame.origin.y;
 
}
 
 - (void) keyboardWillHide:(NSNotification *)note
 {
 }
 */
 


- (void)keyboardWillShow:(NSNotification*)notification {
    
    [self.mySuperView bringSubviewToFront:self.commentInputView];
    [self.mySuperView bringSubviewToFront:self.commentTextField];
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect commentInputViewFrame = self.commentInputView.frame;
    commentInputViewFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + commentInputViewFrame.size.height);
    
    CGRect commentTextFieldFrame = self.commentTextField.frame;
    commentTextFieldFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + commentTextFieldFrame.size.height );
    
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.commentInputView.frame = commentInputViewFrame;
    //self.commentTextField.frame = commentTextFieldFrame;
    //此处为了和commentInputView的中心对齐
    self.commentTextField.center = self.commentInputView.center;
    
    // commit animations
    [UIView commitAnimations];
}

- (void) keyboardWillHide:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect commentInputViewFrame = self.commentInputView.frame;
    commentInputViewFrame.origin.y = self.view.bounds.size.height + commentInputViewFrame.size.height;
    
    CGRect commentTextFieldFrame = self.commentTextField.frame;
    commentTextFieldFrame.origin.y = self.view.bounds.size.height + commentTextFieldFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.commentInputView.frame = commentInputViewFrame;
    self.commentTextField.frame = commentTextFieldFrame;
    
    // commit animations
    [UIView commitAnimations];
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.commentInputView = nil;
    self.view = nil;
    self.mySuperView = nil;
    self.commentTextField = nil;
    self.noticeLabel = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
