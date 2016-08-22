//
//  SKSharedAtles.m
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import "SKSharedAtles.h"

static SKSharedAtles *_shared = nil;

@implementation SKSharedAtles

+ (instancetype)shared{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = (SKSharedAtles *)[SKSharedAtles atlasNamed:@"gameArts-hd"];
    });
    return _shared;
}

+ (SKTexture *)textureWithType:(SKTextureType)type{
    
    switch (type) {
        case SKTextureTypeBackground:
            return [[[self class] shared] textureNamed:@"background_2.png"];
            break;
        case SKTextureTypeBullet:
            return [[[self class] shared] textureNamed:@"bullet1.png"];
            break;
        case SKTextureTypePlayerPlane:
            return [[[self class] shared] textureNamed:@"hero_fly_1.png"];
            break;
        case SKTextureTypeSmallFoePlane:
            return [[[self class] shared] textureNamed:@"enemy1_fly_1.png"];
            break;
        case SKTextureTypeMediumFoePlane:
            return [[[self class] shared] textureNamed:@"enemy3_fly_1.png"];
            break;
        case SKTextureTypeBigFoePlane:
            return [[[self class] shared] textureNamed:@"enemy2_fly_1.png"];
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark -

+ (SKTexture *)playerPlaneTextureWithIndex:(int)index{
    return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"hero_fly_%d.png",index]];
}

+ (SKTexture *)playerPlaneBlowupTextureWithIndex:(int)index{
    return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"hero_blowup_%d.png",index]];
}

#pragma mark -

+ (SKTexture *)hitTextureWithPlaneType:(int)type animatonIndex:(int)animatonIndex{
    
    return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"enemy%d_hit_%d.png",type,animatonIndex]];
}

+ (SKTexture *)blowupTextureWithPlaneType:(int)type animatonIndex:(int)animatonIndex{
    
    return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"enemy%d_blowup_%i.png",type,animatonIndex]];
}


#pragma mark -


+ (SKAction *)hitActionWithFoePlaneType:(SKFoePlaneType)type{
    
    switch (type) {
        case 1:
        {
            NSMutableArray *textures = [[NSMutableArray alloc]init];
            
            SKTexture *texture1 = [[self class] hitTextureWithPlaneType:2 animatonIndex:1];
            SKAction *action1 = [SKAction setTexture:texture1];
            
            SKTexture *texture2 = [[self class] textureWithType:SKTextureTypeBigFoePlane];
            SKAction *action2 = [SKAction setTexture:texture2];
            
            [textures addObject:action1];
            [textures addObject:action2];
            
            return [SKAction sequence:textures];
        }
            break;
        case 2:
        {
            NSMutableArray *textures = [[NSMutableArray alloc]init];
            for (int i = 1; i<=2; i++) {
                SKTexture *texture = [[self class] hitTextureWithPlaneType:3 animatonIndex:i];
                SKAction *action = [SKAction setTexture:texture];
                [textures addObject:action];
            }
            
            return [SKAction sequence:textures];
        }
            break;
        case 3:
        {
            
        }
            break;
        default:
            break;
    }
    return nil;
}

+ (SKAction *)blowupActionWithFoePlaneType:(SKFoePlaneType)type{
    switch (type) {
        case 1:
        {
            NSMutableArray *textures = [[NSMutableArray alloc]init];
            for (int i = 1; i <= 7; i++) {
                
                SKTexture *texture = [[self class] blowupTextureWithPlaneType:2 animatonIndex:i];
                [textures addObject:texture];
            }
            SKAction *dieAction = [SKAction animateWithTextures:textures timePerFrame:0.1];
            
            return [SKAction sequence:@[dieAction,[SKAction removeFromParent]]];
        }
            break;
        case 2:
        {
            NSMutableArray *textures = [[NSMutableArray alloc]init];
            for (int i = 1; i <= 4; i++) {
                
                SKTexture *texture = [[self class] blowupTextureWithPlaneType:3 animatonIndex:i];
                [textures addObject:texture];
            }
            SKAction *dieAction = [SKAction animateWithTextures:textures timePerFrame:0.1];
            
            return [SKAction sequence:@[dieAction,[SKAction removeFromParent]]];
        }
            break;
        case 3:
        {
            NSMutableArray *textures = [[NSMutableArray alloc]init];
            for (int i = 1; i <= 4; i++) {
                
                SKTexture *texture = [[self class] blowupTextureWithPlaneType:1 animatonIndex:i];
                [textures addObject:texture];
            }
            SKAction *dieAction = [SKAction animateWithTextures:textures timePerFrame:0.1];
            
            return [SKAction sequence:@[dieAction,[SKAction removeFromParent]]];
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark -

+ (SKAction *)playerPlaneAction{
    NSMutableArray *textures = [[NSMutableArray alloc]init];
    
    for (int i= 1; i<=2; i++) {
        SKTexture *texture = [[self class] playerPlaneTextureWithIndex:i];
        
        [textures addObject:texture];
    }
   return [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1]];
}

+ (SKAction *)playerPlaneBlowupAction{
    
    NSMutableArray *textures = [[NSMutableArray alloc]init];
    for (int i = 1; i <= 4; i++) {
        
        SKTexture *texture = [[self class] playerPlaneBlowupTextureWithIndex:i];
        [textures addObject:texture];
    }
    SKAction *dieAction = [SKAction animateWithTextures:textures timePerFrame:0.1];
    
    return [SKAction sequence:@[dieAction,[SKAction removeFromParent]]];
}











@end
