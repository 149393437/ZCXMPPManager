//
//  MMLabel.m
//  StampMeSDK
//
//  Created by ceo on 11/9/15.
//  Copyright © 2015 siyanhui. All rights reserved.
//

#import "MMTextView.h"
#import <BQMM/BQMM.h>
#import "MMTextParser+ExtData.h"

@interface MMTextView ()

@property (nonatomic, strong) NSMutableArray *attachmentRanges;
@property (nonatomic, strong) NSMutableArray *attachments;
@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation MMTextView

#pragma mark - setter/getter

- (void)setMmFont:(UIFont *)mmFont
{
    _mmFont = mmFont;
    [self setFont:mmFont];
}

- (void)setMmTextColor:(UIColor *)mmTextColor
{
    _mmTextColor = mmTextColor;
    [self setTextColor:mmTextColor];
}

- (void)setPlaceholderTextWithData:(NSArray*)extData
{
    NSMutableAttributedString *mAStr = [[NSMutableAttributedString alloc] init];
    for (NSArray *obj in extData) {
        NSString *str = obj[0];
        BOOL isEmoji = [obj[1] integerValue] == 0 ? NO : YES;
        
        if (isEmoji) {
            SMTextAttachment *attachemnt = [[SMTextAttachment alloc] init];
            attachemnt.emoji = [MMTextParser placeholderEmoji];
            [mAStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachemnt]];
        }
        else {
            [mAStr appendAttributedString:[[NSAttributedString alloc] initWithString:str]];
        }
    }
    if (self.mmFont) {
        [mAStr addAttribute:NSFontAttributeName value:self.mmFont range:NSMakeRange(0, mAStr.length)];
    }
    if (self.mmTextColor) {
        [mAStr addAttribute:NSForegroundColorAttributeName value:self.mmTextColor range:NSMakeRange(0, mAStr.length)];
    }
    self.attributedText = mAStr;
}

- (void)setMmTextData:(NSArray *)extData
{
    [self setMmTextData:extData completionHandler:nil];
}

- (void)setMmTextData:(NSArray*)extData completionHandler:(void(^)(void))completionHandler
{
    [self setPlaceholderTextWithData:extData];
    [self clearImageViewsCover];
    [self.attributedText enumerateAttribute:NSAttachmentAttributeName
                                    inRange:NSMakeRange(0, [self.attributedText length])
                                    options:0
                                 usingBlock:^(id value, NSRange range, BOOL * stop) {
                                     if ([value isKindOfClass:[SMTextAttachment class]]) {
                                         SMTextAttachment *attachment = (SMTextAttachment *)value;
                                         UIImage *emojiImg = attachment.emoji.emojiImage;
                                         if ([emojiImg.images count] > 1) {
                                             [self.attachmentRanges addObject:[NSValue valueWithRange:range]];
                                             [self.attachments addObject:value];
                                             UIImageView *imgView = [[UIImageView alloc] initWithImage:attachment.emoji.emojiImage];
                                             [self.imageViews addObject:imgView];
                                         }
                                     }
                                 }];
    [self updateAttributeTextWithData:extData completionHandler:completionHandler];
}

- (void)updateAttributeTextWithData:(NSArray*)extData completionHandler:(void(^)(void))completionHandler
{
    NSMutableArray *codes = [NSMutableArray array];
    __block NSMutableArray *textImgArray = [NSMutableArray array];
    for (NSArray *obj in extData) {
        NSString *str = obj[0];
        BOOL isEmoji = [obj[1] integerValue] == 0 ? NO : YES;
        if (isEmoji) {
            if (![codes containsObject:str]) {
                [codes addObject:str];
            }
        }
        [textImgArray addObject:str];
    }
    
    //
    [[MMEmotionCentre defaultCentre] fetchEmojisByType:MMFetchTypeSmall codes:codes completionHandler:^(NSArray *emojis, NSError *error) {
        NSMutableAttributedString *mAStr = [[NSMutableAttributedString alloc] init];
        for (MMEmoji *emoji in emojis) {
            NSInteger objIndex = [textImgArray indexOfObject:emoji.emojiCode];
            while (objIndex != NSNotFound) {
                [textImgArray replaceObjectAtIndex:objIndex withObject:emoji];
                objIndex = [textImgArray indexOfObject:emoji.emojiCode];
            }
        }
        for (id obj in textImgArray) {
            if ([obj isKindOfClass:[MMEmoji class]]) {
                SMTextAttachment *attachemnt = [[SMTextAttachment alloc] init];
                attachemnt.emoji = obj;
                if ([attachemnt.image.images count] > 1) {
                    attachemnt.image = [attachemnt placeHolderImage];
                }
                [mAStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachemnt]];
            }
            else {
                [mAStr appendAttributedString:[[NSAttributedString alloc] initWithString:obj]];
            }
        }
        if (self.mmFont) {
            [mAStr addAttribute:NSFontAttributeName value:self.mmFont range:NSMakeRange(0, mAStr.length)];
        }
        if (self.mmTextColor) {
            [mAStr addAttribute:NSForegroundColorAttributeName value:self.mmTextColor range:NSMakeRange(0, mAStr.length)];
        }
        self.attributedText = mAStr;
        if (completionHandler) {
            completionHandler();
        }
    }];
}

- (NSMutableArray *)attachments {
    if (_attachments == nil) {
        _attachments = [[NSMutableArray alloc] init];
    }
    return _attachments;
}

- (NSMutableArray *)attachmentRanges {
    if (_attachmentRanges == nil) {
        _attachmentRanges = [[NSMutableArray alloc] init];
    }
    return _attachmentRanges;
}

- (NSMutableArray *)imageViews {
    if (_imageViews == nil) {
        _imageViews = [[NSMutableArray alloc] init];
    }
    return _imageViews;
}

#pragma mark - private

- (void)clearImageViewsCover {
    [self.attachmentRanges removeAllObjects];
    [self.attachments removeAllObjects];
    
    for (UIImageView *imgView in self.imageViews) {
        [imgView removeFromSuperview];
    }
    [self.imageViews removeAllObjects];
}


#pragma mark - Layout

- (void)layoutAttachments {
    NSInteger attachmentCount = [self.attachments count];
    for (NSInteger i = 0; i < attachmentCount; i++) {
        NSRange range = [self.attachmentRanges[i] rangeValue];
        SMTextAttachment *attachment = self.attachments[i];
        UIImageView *imgView = self.imageViews[i];
        
        NSRange glyphRange = [self.layoutManager glyphRangeForCharacterRange:range actualCharacterRange:nil];
        CGRect rect = [self.layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:self.textContainer];
        rect.origin.x += self.textContainerInset.left;
        rect.origin.y += self.textContainerInset.top;
        rect.size.width = attachment.bounds.size.width;
        rect.size.height = attachment.bounds.size.height;
        imgView.frame = rect;
        if ([imgView superview] == nil) {
            [self addSubview:imgView];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutAttachments];
}



@end
