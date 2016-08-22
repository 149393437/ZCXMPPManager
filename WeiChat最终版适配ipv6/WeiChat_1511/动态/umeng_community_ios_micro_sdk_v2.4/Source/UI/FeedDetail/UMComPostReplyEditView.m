//
//  UMComPostReplyEditView.m
//  UMCommunity
//
//  Created by umeng on 12/10/15.
//  Copyright © 2015 Umeng. All rights reserved.
//

#import "UMComPostReplyEditView.h"
#import "UMComiToast.h"
#import "UMComTools.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define UMComReplyThumbImageKey @"UMComReplyThumbImageKey"
#define UMComReplyImageKey @"UMComReplyImageKey"

@interface UMComPostReplyEditView()
<UIActionSheetDelegate>

@property (nonatomic, assign) NSUInteger maxLength;

@property (nonatomic, strong) UMComPostReplyCommitBlock commitBlock;

@property (nonatomic, strong) UMComPostReplyCancelBlock cancelBlock;

@property (nonatomic, strong) NSMutableArray *pickedImageList;

@end

@implementation UMComPostReplyEditView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)displayWithMaxLength:(NSUInteger)length commitBlock:(UMComPostReplyCommitBlock)commitBlock cancelBlock:(UMComPostReplyCancelBlock)cancelBlock
{
    self.maxLength = length;
    self.commitBlock = commitBlock;
    self.cancelBlock = cancelBlock;
    
    [self initViews];
    
    [self registerKeyboard];
    
    [_textView becomeFirstResponder];
}

- (void)registerKeyboard
{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(showKeyboard:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
}

- (void)initViews
{
    __weak typeof(self) ws = self;
    _textCountMarker.text = [NSString stringWithFormat:@"0/%lu", _maxLength];
    self.pickedImageList = [NSMutableArray array];
}

- (IBAction)cancel:(id)sender;
{
    [self removeFromSuperview];
    if (_cancelBlock) {
        _cancelBlock();
    }
}

- (IBAction)commit:(id)sender
{
    if (_textView.text.length == 0 && _pickedImageList.count == 0) {
        [[UMComiToast makeText:@"回复内容不能为空"] show];
        return;
    }
    if ([UMComTools getStringLengthWithString:_textView.text] > _maxLength) {
        [[UMComiToast makeText:[NSString stringWithFormat:@"回复长度最多为%lu", _maxLength]] show];
        return;
    }
    if (_commitBlock) {
        NSArray *imageList = nil;
        if (_pickedImageList.count > 0) {
            imageList = @[_pickedImageList[0][UMComReplyImageKey]];
        }
        _commitBlock(_textView.text, imageList);
    }
    
    [self removeFromSuperview];
}

- (IBAction)addImage:(id)sender
{
    [self popActionSheetForAddImageView];
}

-(void) popActionSheetForAddImageView
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片源:"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"拍照",@"相册",nil];
    
    [_textView resignFirstResponder];
    [sheet showInView:self];
}

- (void)textViewDidChange:(UITextView *)textView
{
    _textCountMarker.text = [NSString stringWithFormat:@"%lu/%lu", [UMComTools getStringLengthWithString:_textView.text], _maxLength];
    _commitButton.selected = _textView.text.length > 0;

    if ([UMComTools getStringLengthWithString:_textView.text] > _maxLength) {
        _textCountMarker.textColor = [UIColor redColor];
    } else {
        _textCountMarker.textColor = UMComColorWithColorValueString(@"#A5A5A5");
    }
}


- (void)showKeyboard:(NSNotification *)note
{
    NSDictionary* info = [note userInfo];
    CGSize size = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    if(kbSize.height == 216)
//    {
//        keyboardhight = 0;
//    }
//    else
//    {
//        keyboardhight = 36;   //252 - 216 键盘的两个高度
//    }
    [self textViewMoveAnimation:size.height];
}

- (void)textViewMoveAnimation:(NSUInteger)height
{
    CGRect frame = _contentView.frame;
    if (frame.origin.y < self.frame.size.height - frame.size.height - height) {
        return;
    }
    [UIView animateWithDuration:0.5f
                     animations:^{
                         CGRect frame = _contentView.frame;
                         frame.origin.y = self.frame.size.height - frame.size.height - height;
                         _contentView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)addDeleteButton
{
    CGSize delSize = CGSizeMake(18.f, 18.f);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contentView addSubview:button];
    
    button.frame = CGRectMake(_addImageButton.frame.origin.x + _addImageButton.frame.size.width - delSize.width, _addImageButton.frame.origin.y - delSize.height, delSize.width, delSize.height);
    [button setImage:UMComImageWithImageName(@"um_forum_delete_gray") forState:UIControlStateNormal];
    [button addTarget:self action:@selector (deleteImage:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)deleteImage:(id)sender
{
    UIButton *delButton = (UIButton *)sender;
    [delButton removeFromSuperview];
    
    [_addImageButton setImage:UMComImageWithImageName(@"um_forum_add_image_gray") forState:UIControlStateNormal];
    _addImageButton.userInteractionEnabled = YES;
    [_pickedImageList removeAllObjects];
}

- (void)addPickedImage:(UIImage *)image
{
    if (!image) {
        return;
    }
    [_pickedImageList addObject:@{UMComReplyThumbImageKey:image, UMComReplyImageKey: image}];
    [self setImage:image];
}

- (void)setImageAssets:(NSArray *)imageAssets
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        for(ALAsset *asset in imageAssets)
        {
            UIImage *thumbImage = [UIImage imageWithCGImage:[asset thumbnail]];
            
            UIImage *originImage = [UIImage
                                    imageWithCGImage:[asset.defaultRepresentation fullScreenImage]
                                    scale:[asset.defaultRepresentation scale]
                                    orientation:UIImageOrientationUp];
            NSData *originData = UIImageJPEGRepresentation(originImage, .9f);
            [_pickedImageList addObject:@{UMComReplyThumbImageKey: thumbImage, UMComReplyImageKey: [UIImage imageWithData:originData]}];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:_pickedImageList[0][UMComReplyImageKey]];
        });
    });
}

- (void)setImage:(UIImage *)image
{
    _addImageButton.userInteractionEnabled = NO;
    [_addImageButton setImage:image forState:UIControlStateNormal];
    [self addDeleteButton];
}

#pragma mark - Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            if (_getImageBlock) {
                _getImageBlock(UMComPostReplyImagePickerCamera);
            }
            break;
        case 1:
            if (_getImageBlock) {
                _getImageBlock(UMComPostReplyImagePickerLibrary);
            }
            break;
        case 2:
            [_textView becomeFirstResponder];
            break;
        default:
            break;
    }
}
@end
