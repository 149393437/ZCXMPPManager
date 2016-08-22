//
//  UMComButton.m
//  UMCommunity
//
//  Created by luyiyuan on 14/10/9.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMComButton.h"
#import "UMComTools.h"

@implementation UMComButton

- (id)initWithNormalImageName:(NSString *)imageName target:(id)target action:(SEL)action
{
    if(![imageName length]){
        return nil;
    }
    
    UIImage *image = UMComImageWithImageName(imageName);
    
    self = [self initWithNormalImage:image];
    
    if(self){
        
        UIImage *selectedImage = nil;
        
        if([imageName hasSuffix:@"+x"]){
            NSString *resultName = [imageName substringToIndex:[imageName length] - 2];
            selectedImage = UMComImageWithImageName(resultName);
        }else if([imageName hasSuffix:@"x"]){
            NSString *str = [NSString stringWithFormat:@"%@+x",[imageName substringToIndex:[imageName length] - 1]];
            selectedImage = UMComImageWithImageName(str);
        }
        if(selectedImage){
            [self setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
        }
        
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (id)initWithNormalImage:(UIImage*)image
{
    if(!image){
        return nil;
    }
    
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    if(self){
        [self setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)setOrigin:(CGPoint)point
{
    [self setFrame:CGRectMake(point.x, point.y, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
