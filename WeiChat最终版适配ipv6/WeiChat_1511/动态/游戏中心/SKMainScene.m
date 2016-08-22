//
//  SKMainScene.m
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import "SKMainScene.h"

#import "SKSharedAtles.h"

#import "SKFoePlane.h"


// 角色类别
typedef NS_ENUM(uint32_t, SKRoleCategory){
    SKRoleCategoryBullet = 1,
    SKRoleCategoryFoePlane = 4,
    SKRoleCategoryPlayerPlane = 8
};


@implementation SKMainScene

- (instancetype)initWithSize:(CGSize)size{
    
    self = [super initWithSize:size];
    if (self) {
        
        [self initPhysicsWorld];
        [self initAction];
        [self initBackground];
        [self initScroe];
        [self initPlayerPlane];
        [self firingBullets];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(restart) name:@"restartNotification" object:nil];
    }
    return self;
}

- (void)restart{
    [self removeAllChildren];
    [self removeAllActions];
    [self initBackground];
    [self initScroe];
    [self initPlayerPlane];
    [self firingBullets];
}

- (void)initPhysicsWorld{
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0,0);
}

- (void)initAction{
    _smallFoePlaneHitAction = [SKSharedAtles hitActionWithFoePlaneType:SKFoePlaneTypeSmall];
    _mediumFoePlaneHitAction = [SKSharedAtles hitActionWithFoePlaneType:SKFoePlaneTypeMedium];
    _bigFoePlaneHitAction = [SKSharedAtles hitActionWithFoePlaneType:SKFoePlaneTypeBig];
    
    _smallFoePlaneBlowupAction = [SKSharedAtles blowupActionWithFoePlaneType:SKFoePlaneTypeSmall];
    _mediumFoePlaneBlowupAction = [SKSharedAtles blowupActionWithFoePlaneType:SKFoePlaneTypeMedium];
    _bigFoePlaneBlowupAction = [SKSharedAtles blowupActionWithFoePlaneType:SKFoePlaneTypeBig];
}

- (void)initBackground{
    
    _adjustmentBackgroundPosition = self.size.height;
    
    _background1 = [SKSpriteNode spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypeBackground]];
    _background1.position = CGPointMake(self.size.width / 2, 0);
    _background1.anchorPoint = CGPointMake(0.5,0.5);
    _background1.zPosition = 0;
    _background1.xScale=1.5;
    _background1.yScale=1.5;
    
    _background2 = [SKSpriteNode spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypeBackground]];
    _background2.anchorPoint = CGPointMake(0.5, 0.5);
    _background2.position = CGPointMake(self.size.width / 2, _adjustmentBackgroundPosition - 1);
    _background2.zPosition = 0;
    _background2.xScale=1.5;
    _background2.yScale=1.5;
    
    [self addChild:_background1];
    [self addChild:_background2];
    
    [self runAction:[SKAction repeatActionForever:[SKAction playSoundFileNamed:@"game_music.mp3" waitForCompletion:YES]]];
}

- (void)scrollBackground{
    _adjustmentBackgroundPosition--;
    
    if (_adjustmentBackgroundPosition <= 0)
    {
        _adjustmentBackgroundPosition = HEIGHT;
    }
    
    [_background1 setPosition:CGPointMake(self.size.width / 2, _adjustmentBackgroundPosition - HEIGHT)];
    [_background2 setPosition:CGPointMake(self.size.width / 2, _adjustmentBackgroundPosition - 1)];
}

- (void)initScroe{
    
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Thin"];
    _scoreLabel.text = @"0000";
    _scoreLabel.zPosition = 2;
    _scoreLabel.fontColor = [SKColor blackColor];
    _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _scoreLabel.position = CGPointMake(50 , self.size.height - 52);
    [self addChild:_scoreLabel];
}

- (void)initPlayerPlane{
    
    _playerPlane = [SKSpriteNode spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypePlayerPlane]];
    _playerPlane.position = CGPointMake(160, 50);
    _playerPlane.zPosition = 1;
    _playerPlane.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_playerPlane.size];
    _playerPlane.physicsBody.categoryBitMask = SKRoleCategoryPlayerPlane;
    _playerPlane.physicsBody.collisionBitMask = 0;
    _playerPlane.physicsBody.contactTestBitMask = SKRoleCategoryFoePlane;
    [self addChild:_playerPlane];
    [_playerPlane runAction:[SKSharedAtles playerPlaneAction]];
}

- (void)createFoePlane{
 
    _smallPlaneTime++;
    _mediumPlaneTime++;
    _bigPlaneTime++;
    
    SKFoePlane * (^create)(SKFoePlaneType) = ^(SKFoePlaneType type){
        
        int x = (arc4random() % 220) + 35;

        SKFoePlane *foePlane = nil;
        
        switch (type) {
            case 1:
                foePlane = [SKFoePlane createBigPlane];
                break;
            case 2:
                foePlane = [SKFoePlane createMediumPlane];
                break;
            case 3:
                foePlane = [SKFoePlane createSmallPlane];
                break;
            default:
                break;
        }
        foePlane.zPosition = 1;
        foePlane.physicsBody.categoryBitMask = SKRoleCategoryFoePlane;
        foePlane.physicsBody.collisionBitMask = SKRoleCategoryBullet;
        foePlane.physicsBody.contactTestBitMask = SKRoleCategoryBullet;
        foePlane.position = CGPointMake(x, self.size.height);
        
        return foePlane;
    };
    
    if (_smallPlaneTime > 25)
    {
        float speed = (arc4random() % 3) + 2;
        
        SKFoePlane *foePlane = create(SKFoePlaneTypeSmall);
        [self addChild:foePlane];
        [foePlane runAction:[SKAction sequence:@[[SKAction moveToY:0 duration:speed],[SKAction removeFromParent]]]];
        
        _smallPlaneTime = 0;
    }
    
    if (_mediumPlaneTime > 400)
    {
        float speed = (arc4random() % 3) + 4;
        
        SKFoePlane *foePlane = create(SKFoePlaneTypeMedium);
        [self addChild:foePlane];
        [foePlane runAction:[SKAction sequence:@[[SKAction moveToY:0 duration:speed],[SKAction removeFromParent]]]];
        
        _mediumPlaneTime = 0;
    }
    
    if (_bigPlaneTime > 700)
    {
        float speed = (arc4random() % 3) + 6;
        
        SKFoePlane *foePlane = create(SKFoePlaneTypeBig);
        [self addChild:foePlane];
        [foePlane runAction:[SKAction sequence:@[[SKAction moveToY:0 duration:speed],[SKAction removeFromParent]]]];
        [self runAction:[SKAction playSoundFileNamed:@"enemy2_out.mp3" waitForCompletion:NO]];
        
        _bigPlaneTime = 0;
    }
}

- (void)createBullets{
    SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypeBullet]];
    bullet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bullet.size];
    bullet.physicsBody.categoryBitMask = SKRoleCategoryBullet;
    bullet.physicsBody.collisionBitMask = SKRoleCategoryFoePlane;
    bullet.physicsBody.contactTestBitMask = SKRoleCategoryFoePlane;
    bullet.zPosition = 1;
    bullet.position = CGPointMake(_playerPlane.position.x, _playerPlane.position.y + (_playerPlane.size.height / 2));
    [self addChild:bullet];
    
    SKAction *actionMove = [SKAction moveTo:CGPointMake(_playerPlane.position.x,self.size.height) duration:0.5];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    
    [bullet runAction:[SKAction sequence:@[actionMove,actionMoveDone]]];
    
    [self runAction:[SKAction playSoundFileNamed:@"bullet.mp3" waitForCompletion:NO]];
}

- (void)firingBullets{
    
    SKAction *action = [SKAction runBlock:^{
        [self createBullets];
    }];
    SKAction *interval = [SKAction waitForDuration:0.2];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[action,interval]]]];
}

- (void)changeScore:(SKFoePlaneType)type{
    
    int score = 0;
    switch (type) {
        case SKFoePlaneTypeBig:
            score = 30000;
            break;
        case SKFoePlaneTypeMedium:
            score = 6000;
            break;
        case SKFoePlaneTypeSmall:
            score = 1000;
            break;
        default:
            break;
    }
    
    [_scoreLabel runAction:[SKAction runBlock:^{
    
        _scoreLabel.text = [NSString stringWithFormat:@"%d",_scoreLabel.text.intValue + score];
    }]];
}

- (void)foePlaneCollisionAnimation:(SKFoePlane *)sprite{
    
    if (![sprite actionForKey:@"dieAction"]) {
        
        SKAction *hitAction = nil;
        SKAction *blowupAction = nil;
        NSString *soundFileName = nil;
        switch (sprite.type) {
            case SKFoePlaneTypeBig:
            {
                sprite.hp--;
                hitAction = _bigFoePlaneHitAction;
                blowupAction = _bigFoePlaneBlowupAction;
                soundFileName = @"enemy2_down.mp3";
            }
                break;
            case SKFoePlaneTypeMedium:
            {
                sprite.hp--;
                hitAction = _mediumFoePlaneHitAction;
                blowupAction = _mediumFoePlaneBlowupAction;
                soundFileName = @"enemy3_down.mp3";
            }
                break;
            case SKFoePlaneTypeSmall:
            {
                sprite.hp--;
                hitAction = _smallFoePlaneHitAction;
                blowupAction = _smallFoePlaneBlowupAction;
                soundFileName = @"enemy1_down.mp3";
            }
                break;
            default:
                break;
        }
        if (!sprite.hp) {
            [sprite removeAllActions];
            [sprite runAction:blowupAction withKey:@"dieAction"];
            [self changeScore:sprite.type];
            [self runAction:[SKAction playSoundFileNamed:soundFileName waitForCompletion:NO]];
        }else{
            [sprite runAction:hitAction];
        }
    }
}

- (void)playerPlaneCollisionAnimation:(SKSpriteNode *)sprite{
   
    [self removeAllActions];
    [sprite runAction:[SKSharedAtles playerPlaneBlowupAction] completion:^{
        [self runAction:[SKAction sequence:@[[SKAction playSoundFileNamed:@"game_over.mp3" waitForCompletion:YES],[SKAction runBlock:^{
            
            SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Thin"];
            label.text = @"GameOver";
            label.zPosition = 2;
            label.fontColor = [SKColor blackColor];
            label.position = CGPointMake(self.size.width / 2 , self.size.height / 2 + 20);
            [self addChild:label];
            
        }]]] completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"gameOverNotification" object:nil];
        }];
    }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        
        if (location.x >= self.size.width - (_playerPlane.size.width / 2)) {
            
            location.x = self.size.width - (_playerPlane.size.width / 2);
            
        }else if (location.x <= (_playerPlane.size.width / 2)) {
            
            location.x = _playerPlane.size.width / 2;
            
        }
        
        if (location.y >= self.size.height - (_playerPlane.size.height / 2)) {
            
            location.y = self.size.height - (_playerPlane.size.height / 2);
            
        }else if (location.y <= (_playerPlane.size.height / 2)) {
            
            location.y = (_playerPlane.size.height / 2);
            
        }
        
        SKAction *action = [SKAction moveTo:CGPointMake(location.x, location.y) duration:0];
        
        [_playerPlane runAction:action];
    }
}

- (void)update:(NSTimeInterval)currentTime{
    [self createFoePlane];
    [self scrollBackground];
}

#pragma mark -
- (void)didBeginContact:(SKPhysicsContact *)contact{
    
    if (contact.bodyA.categoryBitMask & SKRoleCategoryFoePlane || contact.bodyB.categoryBitMask & SKRoleCategoryFoePlane) {
        
        SKFoePlane *sprite = (contact.bodyA.categoryBitMask & SKRoleCategoryFoePlane) ? (SKFoePlane *)contact.bodyA.node : (SKFoePlane *)contact.bodyB.node;
        
        if (contact.bodyA.categoryBitMask & SKRoleCategoryPlayerPlane || contact.bodyB.categoryBitMask & SKRoleCategoryPlayerPlane) {
            
            SKSpriteNode *playerPlane = (contact.bodyA.categoryBitMask & SKRoleCategoryPlayerPlane) ? (SKSpriteNode *)contact.bodyA.node : (SKSpriteNode *)contact.bodyB.node;
            [self playerPlaneCollisionAnimation:playerPlane];
        }else{
            SKSpriteNode *bullet = (contact.bodyA.categoryBitMask & SKRoleCategoryFoePlane) ? (SKFoePlane *)contact.bodyB.node : (SKFoePlane *)contact.bodyA.node;
            [bullet removeFromParent];
            [self foePlaneCollisionAnimation:sprite];
        }
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact{

}










@end
