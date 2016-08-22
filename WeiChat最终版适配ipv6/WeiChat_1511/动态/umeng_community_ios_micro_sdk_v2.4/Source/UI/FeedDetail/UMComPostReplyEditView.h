//
//  UMComPostReplyEditView.h
//  UMCommunity
//
//  Created by umeng on 12/10/15.
//  Copyright © 2015 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UMComPostReplyImagePickerType)
{
    UMComPostReplyImagePickerLibrary,
    UMComPostReplyImagePickerCamera
};

typedef void (^UMComPostReplyCommitBlock)(NSString *content, NSArray *imageList);
typedef void (^UMComPostReplyCancelBlock)();
typedef void (^UMComPostReplyCommitGetImageBlock)(UMComPostReplyImagePickerType type);

@interface UMComPostReplyEditView : UIView
<UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UILabel *textCountMarker;
@property (nonatomic, weak) IBOutlet UIButton *addImageButton;
@property (nonatomic, weak) IBOutlet UIButton *commitButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentBottomConstraints;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentHeightConstraints;

@property (nonatomic, strong) UMComPostReplyCommitGetImageBlock getImageBlock;

- (IBAction)commit:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)addImage:(id)sender;

- (void)displayWithMaxLength:(NSUInteger)length commitBlock:(UMComPostReplyCommitBlock)commitBlock cancelBlock:(UMComPostReplyCancelBlock)cancelBlock;

- (void)addPickedImage:(UIImage *)image;
- (void)setImageAssets:(NSArray *)imageAssets;

@end
