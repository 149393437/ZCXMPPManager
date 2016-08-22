//
//  UMComUserInfoBar.m
//  UMCommunity
//
//  Created by umeng on 1/21/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComUserInfoBar.h"
#import "UMComTools.h"
#import "UMComSession.h"
#import "UMComUser.h"
#import "UMComImageUrl+CoreDataProperties.h"
#import "UMComMedalImageView.h"
#import "UMComMedal+CoreDataProperties.h"


const CGFloat g_UMComUserInfoBar_SpaceBetweenNameAndMedal = 5;//勋章和名字的间距

@interface UMComUserInfoBar ()<UMComImageViewDelegate>

//单个勋章显示
//@property(nonatomic,strong)UMComMedalImageView* medalView;

//多勋章布局
@property(nonatomic,assign)NSInteger curMedalCount;//勋章的数量(最大5个)
@property(nonatomic,strong)NSMutableArray* medalViewArray;//包含勋章控件
-(void) createMedalViews;
-(void) requestIMGForMedalViews:(UMComUser*)user;
-(void) clearRequestForMedalViews;
-(CGSize)computeMedalViewSize:(UMComMedalImageView*)medalView;
-(void) layoutMedalViews;

@end

@implementation UMComUserInfoBar

- (void)awakeFromNib
{
    [super awakeFromNib];
  
//单个勋章显示
//    self.medalView = [[UMComMedalImageView alloc] initWithFrame:CGRectMake(0, 0, [UMComMedalImageView defaultWidth], [UMComMedalImageView defaultHeight])];
//    self.medalView.contentMode =  UIViewContentModeScaleAspectFit;
//    [self addSubview:self.medalView];
    
    [self createMedalViews];
    
    self.name.textColor = UMComColorWithColorValueString(@"#666666");
    self.name.font = UMComFontNotoSansLightWithSafeSize(15);
}

- (void)refresh
{
    if ([UMComSession sharedInstance].isLogin) {
        UMComUser *user = [UMComSession sharedInstance].loginUser;
        _name.text = user.name;
        
        //单勋章布局--begin
        /*
        if (user.medal_list.count > 0) {
            UMComMedal* umcomMedal = (UMComMedal*)user.medal_list.firstObject;
            if (umcomMedal && umcomMedal.icon_url) {
                
                [self.medalView setImageURL:[NSURL URLWithString:umcomMedal.icon_url] placeholderImage:nil];
                
                //布局勋章和name的坐标
                CGFloat nameWidth = 0;
                CGFloat maxWidth =  self.accessoryView.frame.origin.x - self.name.frame.origin.x- [UMComMedalImageView defaultWidth] - g_UMComUserInfoBar_SpaceBetweenNameAndMedal;
                CGSize size =  [user.name sizeWithFont:UMComFontNotoSansLightWithSafeSize(15)];
                if (size.width >= maxWidth) {
                    nameWidth = maxWidth;
                }
                else{
                    nameWidth = size.width;
                }
                
                CGRect nameFrame = self.name.frame;
                nameFrame.size.width = nameWidth;
                self.name.frame = nameFrame;
                
                
                CGRect medalFrame = self.medalView.frame;
                medalFrame.origin.x = self.name.frame.origin.x +  self.name.frame.size.width+g_UMComUserInfoBar_SpaceBetweenNameAndMedal;
                medalFrame.origin.y = self.name.frame.origin.y;
                self.medalView.frame = medalFrame;
            }
        }
         */
        //单勋章布局--end
        
        //多勋章布局----begin
        if (user.medal_list.count > 0) {
            [self clearRequestForMedalViews];
            [self requestIMGForMedalViews:user];
        }
        //多勋章布局----end
        
        _status.text = user.level_title;
        _status.layer.borderWidth = .5f;
        _status.layer.borderColor = UMComColorWithColorValueString(@"34C035").CGColor;
        _follower.text = [NSString stringWithFormat:@"粉丝 %@", countString(user.fans_count)];
        _folowing.text = [NSString stringWithFormat:@"关注 %@", countString(user.following_count)];
        _score.text = [NSString stringWithFormat:@"积分 %@", countString(user.point)];
        [_avatar setImageURL:[user.icon_url small_url_string] placeHolderImage:UMComImageWithImageName(@"um_forum_post_default")];
        [self hideInfoSubviews:NO];
        _loginTip.hidden = YES;
    } else {
        [self hideInfoSubviews:YES];
        _loginTip.hidden = NO;
        [_avatar setImage:UMComImageWithImageName(@"um_forum_post_default")];
    }
}

- (void)hideInfoSubviews:(BOOL)hide
{
    _name.hidden = hide;
    _status.hidden = hide;
    _follower.hidden = hide;
    _folowing.hidden = hide;
    _score.hidden = hide;
//    _medalView.hidden = hide;
    if (hide) {
        [self clearRequestForMedalViews];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - 勋章相关
-(void) createMedalViews
{
    //创建默认的medalViewArray队列
    self.medalViewArray = [NSMutableArray arrayWithCapacity:[UMComMedalImageView maxMedalCount]];
    
    //创建勋章
    for(NSInteger i = 0; i < [UMComMedalImageView maxMedalCount]; i++)
    {
        UMComMedalImageView* medalView = [[UMComMedalImageView alloc] initWithFrame:CGRectMake(0, 0, [UMComMedalImageView defaultWidth], [UMComMedalImageView defaultHeight])];
        medalView.tag = i;
        medalView.contentMode =  UIViewContentModeScaleAspectFit;
        [self.medalViewArray addObject:medalView];
        [self addSubview:medalView];
    }
}

-(void) requestIMGForMedalViews:(UMComUser*)user
{
    if (user.medal_list.count > 0) {
        //确认当前勋章不能超过[UMComMedalImageView maxMedalCount]
        self.curMedalCount = user.medal_list.count;
        if (self.curMedalCount > [UMComMedalImageView maxMedalCount]) {
            self.curMedalCount = [UMComMedalImageView maxMedalCount];
        }
        
        for(int i = 0;i < self.curMedalCount; i++)
        {
            UMComMedalImageView* medalView  = self.medalViewArray[i];
            if (medalView) {
                medalView.hidden = NO;
                UMComMedal* umcomMedal = (UMComMedal*)user.medal_list[i];
                if (umcomMedal && umcomMedal.icon_url) {
                    medalView.imageLoaderDelegate =  nil;
                    medalView.isAutoStart = YES;
                    [medalView setImageURL:[NSURL URLWithString:umcomMedal.icon_url] placeholderImage:nil];
                    medalView.imageLoaderDelegate =  self;
                }
                else{
                    medalView.hidden = YES;
                }
                
            }
        }
        
        [self layoutMedalViews];
    }
}

-(void) clearRequestForMedalViews
{
    for(int i = 0;i < self.medalViewArray.count; i++)
    {
        UMComMedalImageView* medalView  = self.medalViewArray[i];
        if (medalView) {
            medalView.hidden = YES;
            medalView.imageLoaderDelegate = nil;
        }
    }
}

-(CGSize)computeMedalViewSize:(UMComMedalImageView*)medalView
{
    if (!medalView) {
        return CGSizeMake(0, 0);
    }
    
    //先确定勋章图片的宽度和高度；
    CGFloat medalWidth = [UMComMedalImageView defaultWidth];
    CGFloat medalHeight = [UMComMedalImageView defaultHeight];
    
    CGSize cellSize = self.bounds.size;
    
    if (medalView.image) {
        
        CGSize  tempSize = medalView.image.size;
        
        if (tempSize.height <= medalHeight) {
            medalHeight = tempSize.height;
        }
        else{
            //目前只是简单的判断图片的高度是否超过self.nameLabel.frame的高度
            if (tempSize.height < self.name.frame.size.height) {
                medalHeight = tempSize.height;
            }
            else
            {
                medalHeight = self.name.frame.size.height;
            }
        }
        
        if (tempSize.width <= medalWidth) {
            medalWidth = tempSize.width;
        }
        else{
            //根据图片的宽高比，算勋章的宽度
            medalWidth =  medalHeight * tempSize.width /  tempSize.height;
            if (medalWidth >= cellSize.width) {
                //如果宽度大于cell的宽度就设置为默认值(此处只是简单判断)
                medalWidth = [UMComMedalImageView defaultWidth];
            }
        }
    }
    
    medalView.bounds = CGRectMake(0, 0, medalWidth, medalHeight);
    return medalView.bounds.size;
}

-(void) layoutMedalViews
{
    //先确定勋章图片的宽度和高度
    CGFloat totalMedalWidth = 0;
    for (int i = 0; i < self.curMedalCount; i++) {
        
        //先计算图片的宽高
        UMComMedalImageView* medalView  = self.medalViewArray[i];
        if (medalView) {
            CGSize medalViewSize = [self computeMedalViewSize:medalView];
            totalMedalWidth += medalViewSize.width + [UMComMedalImageView spaceBetweenMedalViews];
        }
    }

    //计算nameLabel的宽度
    CGFloat nameLabelWidth = 0;
    CGFloat nameLabelMaxWidth = self.bounds.size.width -  self.name.frame.origin.x  - totalMedalWidth - 10;
    CGSize nameLabelSize = [self.name.text sizeWithFont:self.name.font];
    if (nameLabelSize.width > nameLabelMaxWidth) {
        nameLabelWidth = nameLabelSize.width;
    }
    else{
        nameLabelWidth = nameLabelSize.width;
    }
    
    //确定nameLabel的范围
    CGRect nameLabelFrame = self.name.frame;
    nameLabelFrame.size.width = nameLabelWidth;
    self.name.frame = nameLabelFrame;
    
    //确定medalViews的范围
    CGFloat offsetX = self.name.frame.origin.x + self.name.frame.size.width + 5;
    CGFloat offsetY = self.name.frame.origin.y;
    for (int i = 0; i < self.curMedalCount; i++) {
        
        UMComMedalImageView* medalView  = self.medalViewArray[i];
        if (medalView) {
            CGRect medalViewFrame =  medalView.frame;
            medalViewFrame.origin.x = offsetX;
            medalViewFrame.origin.y = offsetY;
            medalView.frame = medalViewFrame;
            offsetX += medalViewFrame.size.width + [UMComMedalImageView spaceBetweenMedalViews];
        }
    }
}

- (void)umcomImageViewLoadedImage:(UMComImageView *)imageView
{
    [self layoutMedalViews];
}

@end
