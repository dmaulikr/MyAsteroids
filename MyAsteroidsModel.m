//
//  MyMyAsteroidsModel.m
//  MyAsteroids
//
//  Created by zhang yan on 3/17/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//

#import "MyAsteroidsModel.h"
#import "VectorSprite.h"
#import "AtlasSprite.h"
#import "Defs.h"
#import "images.h"

@implementation MyAsteroidsModel
@synthesize rocks, state, ship;
@synthesize deadSprites, fingers, time, lines, worldSpeed, demoRocks, demoRockSize,bonus;
@synthesize /*left, right, slow, */thrust, status, lives;
@synthesize score;

#pragma mark game state

+ (CGPoint) gamePoint: (CGPoint) p
{
	// Touch points start in the upper left of the screen,
	// in landscape mode.  Here we translate these points to 
	// game space.
	
	CGFloat w2 = kScreenWidth*0.5;
	CGFloat h2 = kScreenHeight*0.5;
	
	return CGPointMake(p.y*2 - h2, p.x*2 - w2);
}

+ (MyAsteroidsModel *) sharedModel
{
	static MyAsteroidsModel *sharedInstance;
	
	@synchronized(self)
	{
		if (!sharedInstance)
			sharedInstance = [[MyAsteroidsModel alloc] init];
		
		return sharedInstance;
	}
	return sharedInstance;
}

+ (int) getState: (NSString *) indicator 
{
	MyAsteroidsModel *game = [MyAsteroidsModel sharedModel]; 
	if (game.state == nil) game.state = [[NSMutableDictionary alloc] init];
	NSNumber *n = [game.state objectForKey: indicator];
	if (n) {
		return [n intValue];
	}
	return kUnknown;
}

+ (void) setState: (NSString *) indicator to: (int) val
{
	MyAsteroidsModel *game = [MyAsteroidsModel sharedModel];
	if (game.state == nil) game.state = [[NSMutableDictionary alloc] init];
	NSNumber *n = [NSNumber numberWithInt: val];
	[game.state setObject: n forKey: indicator];
}

#pragma mark model methods

- (id) init
{
	self = [super init];
	if (self) {
        worldSpeed = kNormalSpeed;
		state = [[NSMutableDictionary alloc] init];
		rocks = [[NSMutableArray alloc] init];
		deadSprites = [[NSMutableArray alloc] init];
		//newSprites = [[NSMutableArray alloc] init];
		state = [[NSMutableDictionary alloc] init];
		fingers = [[NSMutableDictionary alloc] init];
        lines = [[NSMutableArray alloc] init];
        demoRocks = [[NSArray alloc] initWithObjects:NSStringFromCGPoint(CGPointMake(640, 220)),
                     NSStringFromCGPoint(CGPointMake(1140, -260)),NSStringFromCGPoint(CGPointMake(1640, -20)),
                     NSStringFromCGPoint(CGPointMake(2160, 260)),NSStringFromCGPoint(CGPointMake(2840, -240)),
                     NSStringFromCGPoint(CGPointMake(3140, 160)),NSStringFromCGPoint(CGPointMake(3640, -220)),
                     NSStringFromCGPoint(CGPointMake(4140, -20)),nil];
        
        demoRockSize = (CGFloat *)malloc(kDemoRockNum*sizeof(CGFloat));
        for (int i = 0; i<kDemoRockNum; i++) {
            demoRockSize[i] = 1;
        }
        
		time = 0;
        score = 0;
		[self addObjects];
	}
	return self;
}

- (void) kill: (Sprite *) s
{
	[deadSprites addObject: s];
}

- (void) unleashGrimReaper
{
	int count = [deadSprites count];
	if (count > 0) {
		//printf("Reaping %d sprites\n",count);
		[rocks removeObjectsInArray: deadSprites];
        [lines removeObjectsInArray: deadSprites];
		[deadSprites removeAllObjects];
	}
}

- (void) initState
{
	[MyAsteroidsModel setState: kThrust to: kThrustOff];
	[MyAsteroidsModel setState: kLeft to: kLeftOff];
	[MyAsteroidsModel setState: kRight to: kRightOff];
	[MyAsteroidsModel setState: kSlow to: kSlowOff];
	[MyAsteroidsModel setState: kGameOver to: 0];
	[MyAsteroidsModel setState: kLife to: kLives];
	[MyAsteroidsModel setState: kScore to: 0];
	[MyAsteroidsModel setState: kLevel to: 0];
	[MyAsteroidsModel setState: kGameState to: kGameStatePlay];
    [MyAsteroidsModel setState: kLines to: kLinesRelease];
}

- (void) addButtons
{
	thrust = [AtlasSprite fromFile: @"buttons.png" withRows: 2 withColumns: 4];
	/*left = [AtlasSprite fromFile: @"buttons.png" withRows: 2 withColumns: 4];
	right = [AtlasSprite fromFile: @"buttons.png" withRows: 2 withColumns: 4];
	slow = [AtlasSprite fromFile: @"buttons.png" withRows: 2 withColumns: 4];*/
	
	thrust.frame = kThrustOff;
	//left.frame = kLeftOff;
	//right.frame = kRightOff;
	//slow.frame = kSlowOff;
	
	[thrust moveTo: kThrustLocation];
	//[left moveTo: kLeftLocation];
	//[right moveTo: kRightLocation];
	//[slow moveTo: kSlowLocation];
    
    [thrust scaleTo:1.5];
}

- (void) addLabels
{
	printf("Adding labels\n");
	status = [TextSprite withString: @"Score: 0"];
	lives = [TextSprite withString: @"Lives: 3"];
	[status moveUpperLeftTo: kStatusLocation];
	[lives moveUpperLeftTo: kLivesLocation];
}

- (void) updateButtons
{
	thrust.frame = [MyAsteroidsModel fingerIsTouching: thrust] ? kThrustOn : kThrustOff;
	/*left.frame = [MyAsteroidsModel fingerIsTouching: left] ? kLeftOn : kLeftOff;
	right.frame = [MyAsteroidsModel fingerIsTouching: right] ? kRightOn : kRightOff;
	slow.frame = [MyAsteroidsModel fingerIsTouching: slow] ? kSlowOn : kSlowOff;*/
	
	[MyAsteroidsModel setState: kThrust to: thrust.frame];
	/*[MyAsteroidsModel setState: kLeft to: left.frame];
	[MyAsteroidsModel setState: kRight to: right.frame];
	[MyAsteroidsModel setState: kSlow to: slow.frame];*/
}
- (VectorSprite *) randomRock
{
	VectorSprite *rock;
	int rockNum = RANDOM_PCT()*4;
	switch (rockNum) {
		case 0:
			rock = [VectorSprite withPoints: kRock1Points count: kRock1Count];
			break;
		case 1:
			rock = [VectorSprite withPoints: kRock2Points count: kRock2Count];
			break;
		case 2:
			rock = [VectorSprite withPoints: kRock3Points count: kRock3Count];
			break;
		default:
			rock = [VectorSprite withPoints: kRock4Points count: kRock4Count];
			break;
	}
	rock.wrap = NO;
	rock.type = kRockType;
	[rock setRotation: RANDOM_PCT()*360];
	return rock;
}

- (void) addRock: (Sprite *) rock
{
	[rocks addObject: rock];
}


- (void) addRocks
{
	/*int totalRocks = kRocks * (time > 0 ? [MyAsteroidsModel getState: kLevel] : 1);
	if (totalRocks > kMaxRocks) totalRocks = kMaxRocks;*/
	
	for (int i=0; i < kDemoRockNum; i++) {
        VectorSprite *rock;
		if (i!=4){
            rock = [self randomRock];
        }
        else{
            rock = [VectorSprite withPoints:kBonusPoints count:kBonusCount];
            rock.type = kBonusType;
            rock.r = 1.0;
            rock.g = 0;
            rock.b = 0;
        }
		// place rocks outside the core ship area
		/*CGFloat dx = 80+kScreenHeight*0.5;
		CGFloat dy = RANDOM_PCT()*kScreenWidth*0.5-kScreenWidth*0.25; */
        CGPoint p = CGPointFromString([demoRocks objectAtIndex:i]);
        CGFloat dx = p.x;
        CGFloat dy = p.y;
		CGFloat angleMove = 180;
        
		[rock setAngle: angleMove];
		rock.speed = worldSpeed;
		rock.r = RANDOM_PCT();
		rock.g = RANDOM_PCT();
		rock.b = RANDOM_PCT();
		[rock moveTo: CGPointMake(dx,dy)];
		[rock scaleTo: demoRockSize[i]];
		[rocks addObject: rock];
	}
    VectorSprite* b = [VectorSprite withPoints:kBonusPoints count:kBonusCount];
    [b moveTo:CGPointMake(1000, 0)];
}

- (void) addShips
{
	ship = [VectorSprite withPoints: kShipPoints count: kShipCount];
	[ship moveTo: kShipLocation];
	[ship scaleTo: 1.6];
	ship.wrap = YES;
    [ship setRotation:270];
	ship.type = kShipType;
}

- (Sprite *) myShip
{
	return ship;
}

- (void) addLine:(Sprite *)line
{
    [lines addObject:line];
}

- (void) addObjects
{
	[self addRocks];
	[self addShips];
	[self addButtons];
	[self addLabels];
}

//
// Fingers
//

- (void) placeFinger: (NSUInteger) hash at: (CGPoint) p
{
	Finger *f = [Finger atPoint: p];
    f.hash = hash;
    f.isLine = NO;
    if (!(/*[f isTouching:left] || [f isTouching:right] ||*/ [f isTouching:thrust] /*|| [f isTouching:slow]*/)) {
        [self unleashGrimReaper];
        if ([MyAsteroidsModel getState:kLines] == kLinesRelease && [lines count]==0) {
            [MyAsteroidsModel setState:kLines to:kLinesDrawing];
            f.isLine = YES;
            [fingers setObject: f forKey: [NSNumber numberWithInt: hash]];
        }
        //printf("lines: %d\n",[lines count]);
        //printf("rocks: %d\n",[rocks count]);
    }
    else [fingers setObject: f forKey: [NSNumber numberWithInt: hash]];
}

- (void) moveFinger: (NSUInteger) hash to: (CGPoint) p
{
	Finger *f = [fingers objectForKey: [NSNumber numberWithInt: hash]];
	if (!f) printf("Moving finger %d that doesn't exist.\n",hash);
	else {
        if ([MyAsteroidsModel getState:kLines]==kLinesDrawing && f.isLine ==YES && [lines count]<kLineLen) {
            LineSprite *s = [LineSprite withStartPoint:f.pt withEndPoint:[MyAsteroidsModel gamePoint:p]];
            
            //printf("add a line of (%.1f,%.1f) to (%.1f,%.1f)\n",f.pt.x, f.pt.y, p.x, p.y);
            //printf("%.2f\n",sqrt(s.dir.x*s.dir.x+s.dir.y*s.dir.y));
            
            [self addLine:s];
            printf("count:%d\n",[lines count]);
        }
        [f moveTo:p];
	}
}

- (void) liftFinger: (NSUInteger) hash
{
	Finger *f = [fingers objectForKey: [NSNumber numberWithInt: hash]];
	if (!f) printf("Trying to lift finger %d that was never placed.\n",hash);
	[fingers removeObjectForKey: [NSNumber numberWithInt: hash]];
    if ([MyAsteroidsModel getState:kLines] == kLinesDrawing) {
        [MyAsteroidsModel setState:kLines to:kLinesRelease];
        for (LineSprite *k in lines) {
            k.active = YES;
        }
    }
	[f release];
}

+ (BOOL) fingerIsTouching: (Sprite *) s
{
	BOOL touching = NO;
	MyAsteroidsModel *model = [MyAsteroidsModel sharedModel]; 
	// update our fingers
	for (id key in model.fingers) {
		Finger *f = [model.fingers objectForKey: key];
		touching = touching || [f isTouching: s];
	}
	return touching;
}

- (void) dealloc
{
	// TODO iterate and release thru each
	[rocks release];
	[deadSprites release];
	//[newSprites release];
	[fingers release];
    [lines release];
	[state release];
    [demoRocks release];
    free(demoRockSize);
	[super dealloc];
}

@end
