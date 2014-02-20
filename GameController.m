//
//  GameController.m
//  MyAsteroids
//
//  Created by zhang yan on 3/17/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameController.h"

@implementation GameController

@synthesize model, view, audio, start;

- (id) initWithView: (MyAsteroidsView *) theView
{
	self = [super init];
	if (self) {
		MyAsteroidsModel *m = [MyAsteroidsModel sharedModel];
		self.audio = [[AudioController alloc] init];
		self.model = m;
		self.view = theView;
		self.start = YES;
		[m initState];
		[theView useModel: m];
	}
	return self;
}

- (void) tic: (NSTimeInterval) dt
{
	if (start) {
		start = NO;
		model.time = 0;
	}
	else {
		[self updateModel: dt];
		[self updateView: dt];
		[audio tic: dt];
	}
}

- (void) updateShip: (NSTimeInterval) dt
{
	if (![MyAsteroidsModel getState: kGameOver]) {
		[self moveShip: dt];
	}
	else if ([MyAsteroidsModel getState: kLife] > 0) {
        model.worldSpeed = 0;
		if (restartDelay <= 0) {
            model.worldSpeed = kNormalSpeed;
			[MyAsteroidsModel setState: kGameOver to: 0];
			[model.lives 
			 newText: [NSString stringWithFormat: @"Lives %d", [MyAsteroidsModel getState: kLife]]];
			restartDelay = 0;
			model.lives.r = 1.0;
			model.lives.g = 1.0;
			model.lives.b = 1.0;
            for (LineSprite* l in model.lines) {
                [model kill:l];
            }
            model.ship.boostCount = kBoostFrame;
			[MyAsteroidsModel setState: kGameState to: kGameStatePlay];
		}
		else {
			restartDelay--;
		}
	}
}

- (void) updateLines:(NSTimeInterval)dt
{
    LineSprite* max;
    CGFloat m = -480;
    for (LineSprite *p in model.lines ){
        if (p.end.x > m || p.start.x > m) {
            m = p.end.x; if(p.start.x > m) m = p.start.x;
            max = p;
        }
    }
    for (LineSprite *p in model.lines ) {
        if (p.active) {
            p.speed = model.worldSpeed;
            [p setAngle:180.0];
        }
        else p.speed = 0;
        [p tic: dt];
        if ((p.start.x < -480 && p.end.x < -480) || (p.start.x>480 && p.end.x>480)) {
            [model kill:p];
        }
    }
    if ([model.lines count]> 0 && max.start.x < -230 && max.end.x < -230) {
        for (LineSprite *p in model.lines) {
            [model kill:p];
        }
    }
}

- (void) updateFingers: (NSTimeInterval) dt
{	
	// update our fingers
	for (id key in model.fingers) {
		Finger *f = [model.fingers objectForKey: key];
		[f tic: dt];
	}	
}


- (void) updateModel: (NSTimeInterval) dt
{
    if([MyAsteroidsModel getState:kGameState] != kGameStateDone){
        model.time += dt;
        [self moveRocks: dt];
        [self updateShip: dt];
        [self updateFingers: dt];
        [self updateLines: dt];
        [model updateButtons];
        [model unleashGrimReaper];
    }
}

- (void) boomSoundForRockOfSize: (CGFloat) size
{
	uint boom = kSoundExplode3;
	if (size <= kRockMinSize) {
		boom = kSoundExplode3;
	}
	else if (size <= 2*kRockMinSize) {
		boom = kSoundExplode2;
	}
	else {
		boom = kSoundExplode1;
	}
	[MyAsteroidsModel setState: kSound to: boom];
}

- (void) updateView: (NSTimeInterval) dt
{
	[view tic: dt];
}	

- (void) moveShip: (NSTimeInterval) dt
{
	// rotation
    if ([model.lines count] && [MyAsteroidsModel getState:kGameState]!=kGameStateLine && [MyAsteroidsModel getState:kLines]==kLinesRelease) {
        for (int i=0; i<[model.lines count];i++) {
            LineSprite *l = [model.lines objectAtIndex:i];
            
            //printf("judge\n");
            
            if ([l hitShipTest:model.ship]) {
                [MyAsteroidsModel setState:kGameState to:kGameStateLine];
                model.ship.lineNum = i;
                
                printf("get in line\n");
                
                break;
            }
        }
    }
    if ([MyAsteroidsModel getState:kGameState] == kGameStateLine) {
        LineSprite *l;
        CGFloat sum = sqrt(model.ship.speed*model.ship.speed+model.worldSpeed*model.worldSpeed);
        if ([model.lines count]>model.ship.lineNum) {
            l = [model.lines objectAtIndex:model.ship.lineNum];
            if (l.dir.x-0<0.01 && [model.lines count]-model.ship.lineNum < 3 ) {
                l = [model.lines objectAtIndex:model.ship.lineNum - 5];
            }
            
            if (![l hitShipTest:model.ship]) {
                if (sum>1) {
                    model.ship.lineNum+= (int)sum;
                }
                else model.ship.lineNum++;
            }
            if (model.ship.lineNum >= [model.lines count]) {
                if (model.ship.boostCount < kBoostFrame) {
                    [MyAsteroidsModel setState:kGameState to:kGameStateBoost];
                }
                else [MyAsteroidsModel setState:kGameState to:kGameStatePlay];
                model.ship.lineNum = -1;
            }
            else{
                
                //printf("Rock and roll at Line:%d\n",model.ship.lineNum);
                
                
                CGFloat angle = 270+atan2(l.dir.y,l.dir.x)*180.0/3.141592;
                [model.ship setRotation:angle];
                
                model.worldSpeed = sum * cos((angle-270)*3.141592/180);
                model.ship.speed = sum * sin((angle-270)*3.141592/180);
                /*if (l.dir.y < 0) {
                    model.ship.speed*= -1;
                }*/
                model.ship.angle = 90.0;
                
                printf("angle:%.2f, shipSpeed:%.2f\n",angle,model.ship.speed);
            }
        }
        else{ 
            if (model.ship.boostCount < kBoostFrame) {
                [MyAsteroidsModel setState:kGameState to:kGameStateBoost];
            }
            else [MyAsteroidsModel setState:kGameState to:kGameStatePlay];
            model.ship.lineNum = -1;
        }
    }
    
	CGFloat r = model.ship.rotation-1.5*PI;
	//CGFloat dr = 0;
	/*if ([MyAsteroidsModel getState: kLeft] == kLeftOn) {
		dr = kShipRotationChange;
	}
	else if ([MyAsteroidsModel getState: kRight] == kRightOn) {
		dr = -kShipRotationChange;
	}*/
	//CGFloat deg = r*180.0/3.141592+dr;
	//if (dr) [model.ship setRotation: deg];  // wtf fix me
	
	
    
    
    // thrust
	if ([MyAsteroidsModel getState: kThrust] == kThrustOn) {
        if ([MyAsteroidsModel getState:kGameState] == kGameStatePlay) {
            [MyAsteroidsModel setState:kGameState to:kGameStateBoost];
        }
		//[model.ship applyForce: kShipVelocityChange atAngle: thrustAngle];
		[MyAsteroidsModel setState: kSound to: kSoundThrust];
	}
    /*else if ([MyAsteroidsModel getState:kSlow] == kSlowOn) {
        CGFloat slowAngle = deg - 90;
        [model.ship applyForce:kShipVelocityChange atAngle:slowAngle];
    }*/
    
    if ([MyAsteroidsModel getState:kGameState] == kGameStateBoost) {
        if (model.ship.boostCount <= 0) {
            [MyAsteroidsModel setState:kGameState to:kGameStatePlay];
            model.ship.boostCount = kBoostFrame;
        }
        else{
            model.ship.boostCount--;
            model.worldSpeed += kShipVelocityChange*cos(r)*dt;
            model.ship.speed += kShipVelocityChange*sin(r)*dt;
        }   
    }
    else if([MyAsteroidsModel getState:kGameState] == kGameStatePlay){
        if (sqrt(model.worldSpeed*model.worldSpeed+model.ship.speed*model.ship.speed) > kNormalSpeed) {
            model.worldSpeed -= kShipVelocityDec*cos(r)*dt;
            model.ship.speed -= kShipVelocityDec*sin(r)*dt;
        }
    }
	
	[model.ship tic: dt];
	
	// rocks!
	CGRect me = model.ship.box;
	for (Sprite *rock in model.rocks) {
		if (CGRectIntersectsRect(me,rock.box)) {
			[self hitShipWithRock: rock]; 
			[model kill: rock];
            [self boomSoundForRockOfSize:rock.scale];
			return;
		}
	}
}

- (void) hitShipWithRock: (Sprite *) s
{
    if (s.type == kRockType) {
        model.ship.boostCount = kBoostFrame;
        int lives = [MyAsteroidsModel getState: kLife];
        if (lives > 1) {
            restartDelay = kNewLifeDelay;
            [MyAsteroidsModel setState: kLife to: lives-1];
            [model.lives newText: @"Try again!"];
            model.lives.r = 1.0;
            model.lives.g = 0.0;
            model.lives.b = 0.0;
            [MyAsteroidsModel setState: kGameState to: kGameStateNewLife];
        }
        else {
            [model.lives newText: @"Game Over"];
            [MyAsteroidsModel setState: kGameState to: kGameStateDone];
        }
        [MyAsteroidsModel setState: kGameOver to: 1];
        [MyAsteroidsModel setState: kSound to: kSoundExplode1];
    }
    else if (s.type == kBonusType){
        model.score+=50;
    }
}

- (void) moveRocks: (NSTimeInterval) dt
{
	BOOL hasRocks = NO;
	for (Sprite *rock in model.rocks) {
        rock.speed = model.worldSpeed;
		[rock tic: dt];
        if (rock.offScreen == YES && rock.x < 0) {
            [model kill:rock];
            if(rock.type == kRockType) model.score+=10;
            [model.status newText:[[NSString alloc] initWithFormat:@"Score: %d", model.score]];
        }
		hasRocks = YES;
	}
	if (!hasRocks) {
		uint state = [MyAsteroidsModel getState: kGameState];
		if (state == kGameStatePlay) {
			int level = [MyAsteroidsModel getState: kLevel];
			level++;
			state = kGameStateLevel;
			restartDelay = kNewLifeDelay*2;
			[model.lives newText: [NSString stringWithFormat: @"Level %d", level]];
			model.lives.r = 1.0;
			model.lives.g = 0.0;
			model.lives.b = 0.0;
			[MyAsteroidsModel setState: kGameOver to: 1];
			[MyAsteroidsModel setState: kLevel to: level];
			[MyAsteroidsModel setState: kGameState to: kGameStateLevel];
			[MyAsteroidsModel setState: kSound to: kSoundAlert];
		}
		else if (state == kGameStateLevel) {
			restartDelay--;
			if (restartDelay <= 0) {
				[model addRocks];
				[model.lives newText: [NSString stringWithFormat: @"Lives %d", 
									   [MyAsteroidsModel getState: kLife]]];
				model.lives.r = 1.0;
				model.lives.g = 1.0;
				model.lives.b = 1.0;
				[model.ship moveTo: kShipLocation];
                for (LineSprite* l in model.lines) {
                    [model kill:l];
                }
				model.ship.angle = 0.0;
				model.ship.rotation = 270;
				model.ship.speed = 0.0;
                model.worldSpeed = kNormalSpeed;
                model.ship.boostCount = kBoostFrame;
				[MyAsteroidsModel setState: kGameOver to: 0];
				[MyAsteroidsModel setState: kGameState to: kGameStatePlay];
			}
		}
	}
}

- (void) dealloc
{
	[audio release];
	[super dealloc];
}

@end