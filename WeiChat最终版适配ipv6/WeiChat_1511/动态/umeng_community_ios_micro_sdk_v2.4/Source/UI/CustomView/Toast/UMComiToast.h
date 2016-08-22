/*

iToast.h

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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#import "UMSocialConfig.h"

typedef enum {
    UMSocialiToastPositionTop = 1000001,        //提示位置在屏幕上部
    UMSocialiToastPositionBottom,               //提示位置在屏幕下部
    UMSocialiToastPositionCenter                //提示位置在屏幕中间
} UMSocialiToastPosition;

typedef enum iUMComDuration {
	UMComiToastDurationLong = 10000,
	UMComiToastDurationShort = 1000,
	UMComiToastDurationNormal = 3000
} UMComiToastDuration;

typedef enum iToastType {
	UMComiToastTypeInfo = -100000,
    UMComiToastTypeNotice,
    UMComiToastTypeWarning,
    UMComiToastTypeError,
    UMComiToastTypeNone // For internal use only (to force no image)
} UMComiToastType;

typedef enum {
    UMComiToastImageLocationTop,
    UMComiToastImageLocationLeft
} UMComiToastImageLocation;


@class UMComiToastSettings;

@interface UMComiToast : NSObject {
	UMComiToastSettings *_settings;
	NSInteger offsetLeft;
	NSInteger offsetTop;
	
	NSTimer *timer;
	
	UIView *view;
	NSString *text;
}

- (void) show;
- (void) show:(UMComiToastType) type;
- (UMComiToast *) setDuration:(NSInteger ) duration;
- (UMComiToast *) setGravity:(UMSocialiToastPosition) gravity
			 offsetLeft:(NSInteger) left
			 offsetTop:(NSInteger) top;
- (UMComiToast *) setGravity:(UMSocialiToastPosition) gravity;
- (UMComiToast *) setPostion:(CGPoint) position;

+ (UMComiToast *) makeText:(NSString *) text;

-(UMComiToastSettings *) theSettings;

@end



@interface UMComiToastSettings : NSObject<NSCopying>{
	NSInteger duration;
	UMSocialiToastPosition gravity;
	CGPoint postition;
	UMComiToastType toastType;
	
	NSDictionary *images;
	
	BOOL positionIsSet;
}


@property(assign) NSInteger duration;
@property(assign) UMSocialiToastPosition gravity;
@property(assign) CGPoint postition;
@property(readonly) NSDictionary *images;
@property(assign) UMComiToastImageLocation imageLocation;

/*
 设置是否隐藏，默认不隐藏
 
 */
@property(assign) BOOL isHidden;

+ (UMComiToastSettings *) getSharedSettings;
						  
@end