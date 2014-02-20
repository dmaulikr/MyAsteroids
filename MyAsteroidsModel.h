//
//  MyAsteroidsModel.h
//  MyAsteroids
//
//  Created by zhang yan on 3/17/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"
#import "Finger.h"
#import "AtlasSprite.h"
#import "VectorSprite.h"
#import "TextSprite.h"
#import "LineSprite.h"


@interface MyAsteroidsModel : NSObject {
	NSMutableArray *rocks;
	NSMutableArray *deadSprites;
	//NSMutableArray *newSprites;
	NSMutableDictionary *fingers;
	NSMutableArray *lines;
    NSMutableArray *bonus;
	Sprite *ship;
	
	AtlasSprite *thrust;
	//AtlasSprite *left;
	//AtlasSprite *right;
	//AtlasSprite *slow;
    
	TextSprite *status;
	TextSprite *lives;
    
	NSMutableDictionary *state;
    NSArray *demoRocks;
    CGFloat *demoRockSize;
	CGFloat time;
    CGFloat worldSpeed;
    int score;
}

@property (nonatomic, retain) NSMutableDictionary *state;
@property (nonatomic, retain) NSMutableArray *rocks;
@property (nonatomic, retain) NSMutableArray *bonus;
@property (nonatomic, retain) NSMutableDictionary *fingers;
@property (nonatomic, retain) NSMutableArray *deadSprites;
//@property (nonatomic, retain) NSMutableArray *newSprites;
@property (nonatomic, retain) NSMutableArray *lines;
@property (nonatomic, retain) NSArray *demoRocks;
@property (nonatomic, retain) Sprite *ship;
@property (assign) CGFloat time;
@property (assign) CGFloat worldSpeed;
@property (assign) CGFloat *demoRockSize;
@property (nonatomic, retain) AtlasSprite *thrust;
//@property (nonatomic, retain) AtlasSprite *left;
//@property (nonatomic, retain) AtlasSprite *right;
//@property (nonatomic, retain) AtlasSprite *slow;
@property (nonatomic, retain) TextSprite *status;
@property (nonatomic, retain) TextSprite *lives;
@property (assign) int score;

+ (MyAsteroidsModel *) sharedModel;
+ (int) getState: (NSString *) indicator;
+ (void) setState: (NSString *) indicator to: (int) val;
- (void) addObjects;
- (void) addShips;
- (void) addRocks;
- (Sprite *) myShip;
+ (CGPoint) gamePoint: (CGPoint) p;
+ (BOOL) fingerIsTouching: (Sprite *) s;
- (void) initState;
- (void) updateButtons;
- (void) unleashGrimReaper;
- (void) kill: (Sprite *) s;
- (void) placeFinger: (NSUInteger) hash at: (CGPoint) p;
- (void) moveFinger: (NSUInteger) hash to: (CGPoint) p;
- (void) liftFinger: (NSUInteger) hash;	
- (VectorSprite *) randomRock;
- (void) addRock: (Sprite *) rock;
- (void) addLine: (Sprite *) line;

@end

