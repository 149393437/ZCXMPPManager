/*

iToast.m

MIT LICENSE

Copyright (c) 2011 Travis CI development team

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/


#import "UMComiToast.h"
#import <QuartzCore/QuartzCore.h>
#import "UMUtils.h"
//#import "UMProtocolData.h"

#define CURRENT_TOAST_TAG 6984678

static const CGFloat kComponentPadding = 8;
static const CGFloat kComponentWidthPadding = 20;

static UMComiToastSettings *sharedSettings = nil;

@interface UMComiToast (private)

- (UMComiToast *) settings;
- (CGRect)_toastFrameForImageSize:(CGSize)imageSize withLocation:(UMComiToastImageLocation)location andTextSize:(CGSize)textSize;
- (CGRect)_frameForImage:(UMComiToastType)type inToastFrame:(CGRect)toastFrame;

@end


@implementation UMComiToast


- (id) initWithText:(NSString *) tex{
	if (self = [super init]) {
		text = [tex copy];
	}
	
	return self;
}

- (void) show{
    if (self.theSettings.isHidden == NO) {
        [self show:UMComiToastTypeNone];
    }
}

- (void) show:(UMComiToastType) type {
	
	UMComiToastSettings *theSettings = _settings;
	
	if (!theSettings) {
		theSettings = [UMComiToastSettings getSharedSettings];
	}
	
	UIImage *image = [theSettings.images valueForKey:[NSString stringWithFormat:@"%i", type]];
	
	UIFont *font = [UIFont systemFontOfSize:16];
	CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(280, 60)];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + kComponentWidthPadding, textSize.height + kComponentPadding)];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = font;
	label.text = text;
	label.numberOfLines = 0;
	label.shadowColor = [UIColor darkGrayColor];
	label.shadowOffset = CGSizeMake(1, 1);
    label.textAlignment = NSTextAlignmentCenter;
	
	UIButton *v = [UIButton buttonWithType:UIButtonTypeCustom];
	if (image) {
		v.frame = [self _toastFrameForImageSize:image.size withLocation:[theSettings imageLocation] andTextSize:textSize];
        
        switch ([theSettings imageLocation]) {
            case UMComiToastImageLocationLeft:
                [label setTextAlignment:NSTextAlignmentLeft];
                label.center = CGPointMake(image.size.width + kComponentPadding * 2
                                           + (v.frame.size.width - image.size.width - kComponentPadding * 2) / 2, 
                                           v.frame.size.height / 2);
                break;
            case UMComiToastImageLocationTop:
                [label setTextAlignment:NSTextAlignmentLeft];
                label.center = CGPointMake(v.frame.size.width / 2, 
                                           (image.size.height + kComponentPadding * 2 
                                            + (v.frame.size.height - image.size.height - kComponentPadding * 2) / 2));
                break;
            default:
                break;
        }
		
	} else {
		v.frame = CGRectMake(0, 0, textSize.width + kComponentWidthPadding * 2, textSize.height + kComponentPadding * 2);
		label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
	}
	CGRect lbfrm = label.frame;
	lbfrm.origin.x = ceil(lbfrm.origin.x);
	lbfrm.origin.y = ceil(lbfrm.origin.y);
	label.frame = lbfrm;
	[v addSubview:label];
//	[label release];
	
	if (image) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		imageView.frame = [self _frameForImage:type inToastFrame:v.frame];
		[v addSubview:imageView];
//		[imageView release];
	}
	
	v.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
	v.layer.cornerRadius = 8;
	
	//UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];//zhangjunhua_before
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];//zhangjunhua_after
	
	CGPoint point = CGPointZero;
	
	// Set correct orientation/location regarding device orientation
	UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if (orientation == UIDeviceOrientationPortrait || UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
#else
    if (orientation == UIDeviceOrientationPortrait)
#endif
    {
        if (theSettings.gravity == UMSocialiToastPositionTop) {
            point = CGPointMake(window.frame.size.width / 2, 45);
        } else if (theSettings.gravity == UMSocialiToastPositionBottom) {
            point = CGPointMake(window.frame.size.width / 2, window.frame.size.height - 45);
        } else if (theSettings.gravity == UMSocialiToastPositionCenter) {
            point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
        } else {
            point = theSettings.postition;
        }
        
        point = CGPointMake(point.x + offsetLeft, point.y + offsetTop);
    } else if (orientation == UIDeviceOrientationPortraitUpsideDown){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        if (UMSYSTEM_VERSION_LESS_THAN(@"8.0"))
#endif
        {
        v.transform = CGAffineTransformMakeRotation(M_PI);
        
        float width = window.frame.size.width;
        float height = window.frame.size.height;
        
        if (theSettings.gravity == UMSocialiToastPositionTop) {
            point = CGPointMake(width / 2, height - 45);
        } else if (theSettings.gravity == UMSocialiToastPositionBottom) {
            point = CGPointMake(width / 2, 45);
        } else if (theSettings.gravity == UMSocialiToastPositionCenter) {
            point = CGPointMake(width/2, height/2);
        } else {
            // TODO : handle this case
            point = theSettings.postition;
        }
        
        point = CGPointMake(point.x - offsetLeft, point.y - offsetTop);
        }
    } else if (orientation ==UIDeviceOrientationLandscapeLeft){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        if (UMSYSTEM_VERSION_LESS_THAN(@"8.0"))
#endif
        {
        v.transform = CGAffineTransformMakeRotation(M_PI/2); //rotation in radians
        
        if (theSettings.gravity == UMSocialiToastPositionTop) {
            point = CGPointMake(window.frame.size.width - 45, window.frame.size.height / 2);
        } else if (theSettings.gravity == UMSocialiToastPositionBottom) {
            point = CGPointMake(45,window.frame.size.height / 2);
        } else if (theSettings.gravity == UMSocialiToastPositionCenter) {
            point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
        } else {
            // TODO : handle this case
            point = theSettings.postition;
        }
        
        point = CGPointMake(point.x - offsetTop, point.y - offsetLeft);
        }
    } else if (orientation ==UIDeviceOrientationLandscapeRight){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        if (UMSYSTEM_VERSION_LESS_THAN(@"8.0"))
#endif
        {
        v.transform = CGAffineTransformMakeRotation(-M_PI/2);
        if (theSettings.gravity == UMSocialiToastPositionTop) {
            point = CGPointMake(45, window.frame.size.height / 2);
        } else if (theSettings.gravity == UMSocialiToastPositionBottom) {
            point = CGPointMake(window.frame.size.width - 45, window.frame.size.height/2);
        } else if (theSettings.gravity == UMSocialiToastPositionCenter) {
            point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
        } else {
            // TODO : handle this case
            point = theSettings.postition;
        }
        
        point = CGPointMake(point.x + offsetTop, point.y + offsetLeft);
        }
    }
    
	v.center = point;
	
	NSTimer *timer1 = [NSTimer timerWithTimeInterval:((float)theSettings.duration)/1000 
											 target:self selector:@selector(hideToast:) 
										   userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
	
	v.tag = CURRENT_TOAST_TAG;

	UIView *currentToast = [window viewWithTag:CURRENT_TOAST_TAG];
	if (currentToast != nil) {
    	[currentToast removeFromSuperview];
	}

	v.alpha = 0;
	[window addSubview:v];
	[UIView beginAnimations:nil context:nil];
	v.alpha = 1;
	[UIView commitAnimations];
	
	view = v;
	
	[v addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchDown];
}

- (CGRect)_toastFrameForImageSize:(CGSize)imageSize withLocation:(UMComiToastImageLocation)location andTextSize:(CGSize)textSize {
    CGRect theRect = CGRectZero;
    switch (location) {
        case UMComiToastImageLocationLeft:
            theRect = CGRectMake(0, 0, 
                                 imageSize.width + textSize.width + kComponentPadding * 3, 
                                 MAX(textSize.height, imageSize.height) + kComponentPadding * 2);
            break;
        case UMComiToastImageLocationTop:
            theRect = CGRectMake(0, 0, 
                                 MAX(textSize.width, imageSize.width) + kComponentPadding * 2, 
                                 imageSize.height + textSize.height + kComponentPadding * 3);
            
        default:
            break;
    }    
    return theRect;
}

- (CGRect)_frameForImage:(UMComiToastType)type inToastFrame:(CGRect)toastFrame {
    UMComiToastSettings *theSettings = _settings;
    UIImage *image = [theSettings.images valueForKey:[NSString stringWithFormat:@"%i", type]];
    
    if (!image) return CGRectZero;
    
    CGRect imageFrame = CGRectZero;

    switch ([theSettings imageLocation]) {
        case UMComiToastImageLocationLeft:
            imageFrame = CGRectMake(kComponentPadding, (toastFrame.size.height - image.size.height) / 2, image.size.width, image.size.height);
            break;
        case UMComiToastImageLocationTop:
            imageFrame = CGRectMake((toastFrame.size.width - image.size.width) / 2, kComponentPadding, image.size.width, image.size.height);
            break;
            
        default:
            break;
    }
    
    return imageFrame;
    
}

- (void) hideToast:(NSTimer*)theTimer{
	[UIView beginAnimations:nil context:NULL];
	view.alpha = 0;
	[UIView commitAnimations];
	
	NSTimer *timer2 = [NSTimer timerWithTimeInterval:500 
											 target:self selector:@selector(hideToast:) 
										   userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
}

- (void) removeToast:(NSTimer*)theTimer{
	[view removeFromSuperview];
}


+ (UMComiToast *) makeText:(NSString *) _text{
	__autoreleasing UMComiToast *toast = [[UMComiToast alloc] initWithText:_text];
	
	return toast;
}


- (UMComiToast *) setDuration:(NSInteger ) duration{
	[self theSettings].duration = duration;
	return self;
}

- (UMComiToast *) setGravity:(UMSocialiToastPosition) gravity
			 offsetLeft:(NSInteger) left
			  offsetTop:(NSInteger) top{
	[self theSettings].gravity = gravity;
	offsetLeft = left;
	offsetTop = top;
	return self;
}

- (UMComiToast *) setGravity:(UMSocialiToastPosition) gravity{
	[self theSettings].gravity = gravity;
	return self;
}

- (UMComiToast *) setPostion:(CGPoint) _position{
	[self theSettings].postition = CGPointMake(_position.x, _position.y);
	
	return self;
}

-(UMComiToastSettings *) theSettings{
	if (!_settings) {
		_settings = [[UMComiToastSettings getSharedSettings] copy];
	}
	
	return _settings;
}

@end


@implementation UMComiToastSettings
@synthesize duration;
@synthesize gravity;
@synthesize postition;
@synthesize images;
@synthesize imageLocation;

+ (UMComiToastSettings *) getSharedSettings{
	if (!sharedSettings) {
		sharedSettings = [UMComiToastSettings new];
		sharedSettings.gravity = UMSocialiToastPositionCenter;
		sharedSettings.duration = UMComiToastDurationShort;
        sharedSettings.isHidden = NO;
	}
	
	return sharedSettings;
	
}

- (id) copyWithZone:(NSZone *)zone{
	UMComiToastSettings *copy = [UMComiToastSettings new];
	copy.gravity = self.gravity;
	copy.duration = self.duration;
	copy.postition = self.postition;
    copy.isHidden = self.isHidden;

	return copy;
}

@end