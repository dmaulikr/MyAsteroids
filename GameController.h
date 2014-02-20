//
//  GameController.h
//  MyAsteroids
//
//  Created by zhang yan on 3/17/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyAsteroidsModel.h"
#import "MyAsteroidsView.h"
#import "Sprite.h"
#import "AudioController.h"

@interface GameController : NSObject {
	MyAsteroidsModel *model;
	MyAsteroidsView *view;
	AudioController *audio;
	BOOL start;
	int restartDelay;
}

@property (assign) MyAsteroidsModel *model;
@property (assign) MyAsteroidsView *view;
@property (nonatomic, retain) AudioController *audio;
@property (assign) BOOL start;

- (id) initWithView: (MyAsteroidsView *) theView;
- (void) tic: (NSTimeInterval) dt;
- (void) updateModel: (NSTimeInterval) dt;
- (void) updateView: (NSTimeInterval) dt;
- (void) updateLines: (NSTimeInterval) dt;
- (void) moveShip: (NSTimeInterval) dt;
- (void) moveRocks: (NSTimeInterval) dt;
- (void) hitShipWithRock: (Sprite *) s;
- (void) boomSoundForRockOfSize: (CGFloat) size;
@end