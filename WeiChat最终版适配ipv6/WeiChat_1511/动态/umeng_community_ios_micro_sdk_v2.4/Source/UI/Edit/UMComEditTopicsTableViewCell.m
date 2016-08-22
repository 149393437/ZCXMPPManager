//
//  UMComEditTopicsTableViewCell.m
//  UMCommunity
//
//  Created by luyiyuan on 14/9/23.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMComEditTopicsTableViewCell.h"
#import "UMComTopic.h"
#import "UMComTools.h"

@interface UMComEditTopicsTableViewCell()
@property (nonatomic,strong) UMComTopic *topic;
@end

@implementation UMComEditTopicsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    self.labelName.font =  UMComFontNotoSansLightWithSafeSize(15.5);
    self.labelDesc.font =  UMComFontNotoSansLightWithSafeSize(14);
    self.labelName.textColor = [UMComTools colorWithHexString:FontColorBlue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWithTopic:(UMComTopic *)topic
{
    self.topic = topic;
    
    if(topic)
    {
        self.labelName.text = [NSString stringWithFormat:TopicString,topic.name];        
        self.labelDesc.text = [topic.descriptor length] == 0 ? UMComLocalizedString(@"Topic_No_Desc", @"该话题没有描述"): topic.descriptor;
    }
    else
    {
        self.labelName.text = nil;
        self.labelDesc.text = nil;
    }

    
}


// 自绘分割线
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, UMComTableViewSeparatorColor.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - TableViewCellSpace, rect.size.width, TableViewCellSpace));
    
}

@end
