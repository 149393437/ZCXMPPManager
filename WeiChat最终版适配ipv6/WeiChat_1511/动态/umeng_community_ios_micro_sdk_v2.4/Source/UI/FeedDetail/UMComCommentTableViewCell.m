//
//  UMComCommentTableViewCell.m
//  UMCommunity
//
//  Created by umeng on 15/5/22.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import "UMComCommentTableViewCell.h"
#import "UMComUser.h"
#import "UMComTools.h"
#import "UMComImageView.h"
#import "UMComComment.h"
#import "UMComMutiStyleTextView.h"
#import "UMComClickActionDelegate.h"
#import "UMComUser+UMComManagedObject.h"
#import "UMComGridView.h"


@interface UMComCommentTableViewCell ()

@property (nonatomic, strong) UMComComment *comment;

@end

@implementation UMComCommentTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.portrait = [[[UMComImageView imageViewClassName] alloc]initWithFrame:CGRectMake(15, 11, 35, 35)];
    self.portrait.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapPortrait = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnUser:)];
    [self.portrait addGestureRecognizer:tapPortrait];
    [self.contentView addSubview:self.portrait];
    UITapGestureRecognizer *tapCommentContent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnCommentContent)];
    [self.contentView addGestureRecognizer:tapCommentContent];
    [self.timeLabel setTextColor:[UMComTools colorWithHexString:FontColorGray]];
    self.commentTextView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor whiteColor];
    self.nameLabel.font = UMComFontNotoSansLightWithSafeSize(UMCom_Micro_Comment_NameFontSize);
    self.nameLabel.textColor = UMComColorWithColorValueString(UMCom_Micro_Comment_NameTextCollor);
    self.likeCountLabel.font = UMComFontNotoSansLightWithSafeSize(UMCom_Micro_Comment_LikeFontSize);
    self.timeLabel.textColor = UMComColorWithColorValueString(UMCom_Micro_Comment_TimeTextCollor);
    self.timeLabel.font = UMComFontNotoSansLightWithSafeSize(UMCom_Micro_Comment_TimeFontSize);
    self.customLeftEdge = 15;
}


- (void)reloadWithComment:(UMComComment *)comment
         commentStyleView:(UMComMutiText *)mutiText
{
    self.comment = comment;
    NSString *iconString = [comment.creator iconUrlStrWithType:UMComIconSmallType];
    self.portrait.layer.cornerRadius = self.portrait.frame.size.width/2;
    self.portrait.layer.masksToBounds = YES;
    UIImage *placeHolderImage = [UMComImageView placeHolderImageGender:[comment.creator.gender integerValue]];
    [self.portrait setImageURL:iconString placeHolderImage:placeHolderImage];
    
    if (comment.creator.name) {
        self.nameLabel.text = comment.creator.name;
    }
    self.timeLabel.text = createTimeString(comment.create_time);

    if ([comment.liked boolValue]) {
        [self.likeButton setImage:UMComImageWithImageName(@"um_micro_like_highlight") forState:UIControlStateNormal];
        self.likeCountLabel.textColor = UMComColorWithColorValueString(@"#008BEA");
    }else{
        [self.likeButton setImage:UMComImageWithImageName(@"um_micro_like_nomal") forState:UIControlStateNormal];
        self.likeCountLabel.textColor = UMComColorWithColorValueString(@"#A5A5A5");
    }
    CGRect nameFrame = self.nameLabel.frame;
    nameFrame.size.width = self.contentView.frame.size.width-57-75;
    self.nameLabel.frame = nameFrame;
    CGRect timeFrame = self.timeLabel.frame;
    timeFrame.origin.x = nameFrame.origin.x;
    timeFrame.size.width = nameFrame.size.width;
    self.timeLabel.frame = timeFrame;
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    
    self.likeCountLabel.text = [NSString stringWithFormat:@"%@",countString(comment.likes_count)];
    if (comment.content) {
        CGRect commentFrame = self.commentTextView.frame;
        commentFrame.size.height = mutiText.textSize.height;
        self.commentTextView.frame = commentFrame;
        [self.commentTextView setMutiStyleTextViewWithMutiText:mutiText];
        __weak UMComCommentTableViewCell *weakSelf = self;
        self.commentTextView.clickOnlinkText = ^(UMComMutiStyleTextView *styleView, UMComMutiTextRun *run){
            if ([run isKindOfClass:[UMComMutiTextRunClickUser class]]) {
                [weakSelf tapOnUser:comment.reply_user];
            }else if ([run isKindOfClass:[UMComMutiTextRunURL class]]){
                [self tapOnUrlString:run.text];
            }else{
                [weakSelf tapOnCommentContent];
            }
        };
    }
    if (comment.image_urls.count > 0) {
        self.commentImageView.hidden = NO;
        CGRect commentImageFrame = self.commentImageView.frame;
        commentImageFrame.origin.y = self.commentTextView.frame.origin.y + self.commentTextView.frame.size.height + 8;
        self.commentImageView.frame = commentImageFrame;
        [self.commentImageView setImages:comment.image_urls.array placeholder:UMComImageWithImageName(@"um_forum_post_default") cellPad:3];
        self.commentImageView.TapInImage = ^(UIViewController *viewController, UIImageView *imageView){
            if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnImageView:complitionBlock:)]) {
            [self.delegate customObj:self clickOnImageView:imageView complitionBlock:^(UIViewController *currentViewController) {
                [currentViewController presentViewController:viewController animated:YES completion:nil];
            }];
            }
        };
        
    }else{
        self.commentImageView.hidden = YES;
    }
}

- (void)tapOnUser:(id)sender
{
    UMComUser *user = nil;
    if ([sender isKindOfClass:[UMComUser class]]) {
        user = sender;
    }else{
        user = self.comment.creator;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnUser:)]) {
        [self.delegate customObj:self clickOnUser:user];
    }
    if (self.clickOnUserportrait) {
        self.clickOnUserportrait(self.comment);
    }
}

- (void)tapOnUrlString:(NSString *)urlString
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnURL:)]) {
        [self.delegate customObj:self clickOnURL:urlString];
    }
}

- (void)tapOnCommentContent
{
    if (self.clickOnCommentContent) {
        self.clickOnCommentContent(self.comment);
    }
}

- (IBAction)onClickLikeButton:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(customObj:clickOnLikeComment:)]) {
        [self.delegate customObj:self clickOnLikeComment:self.comment];
    }
}


@end