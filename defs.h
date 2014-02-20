//
//  defs.h
//  MyAsteroids
//
//  Created by zhang yan on 3/16/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//

#define RANDOM_SEED() srandom(time(NULL))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__+1) - (__MIN__)))

#define kFPS 60.0
#define kPi	3.14159
#define kEps 500

// a handy constant to keep around
#define APRADIANS_TO_DEGREES 57.2958

// material import settings
#define AP_CONVERT_TO_4444 0
#define RANDOM_PCT() (((CGFloat)(arc4random() % 40001) )/40000.0)

// Various constants

#define kRocks					1		// Number of new rocks per level
#define kMaxRocks				8		// Maximum number of rocks to start
#define kScreenWidth			640
#define kScreenHeight			960
#define kShipRotationChange		20  // Number of degrees to move per frame if pressed
#define kShipVelocityChange		240
#define kShipVelocityDec        240
#define kReloadTime				5
#define kRockMinSize			60			// minimum size of a rock at level 1
#define kDefaultFont			@"Helvetica"
#define kDefaultFontSize		28
#define kLineWidth              6
#define PI                      3.141592
#define kGravity                10.0
#define kNormalSpeed            200
#define kBoostSpeed             350
#define kDemoRockNum            8
#define kBoostFrame             kFPS*1
#define kLineLen                35

// Scoring
#define kScoreTinyRock			500
#define kScoreMediumRock		250
#define kScoreBigRock			100

// Sprite types
#define kSpriteType				1
#define kRockType				100
#define kShipType				101
#define kLineType               102
#define kBonusType              103
#define kLives					3

// Various states
#define kUnknown	-1
#define kScore		@"score"
#define kLevel		@"level"
#define kLife		@"life"
#define kDied		@"dead"
#define kGameOver	@"over"
#define kThrust		@"thrust"
#define kLeft		@"left"
#define kRight		@"right"
#define kSlow		@"Slow"
#define kLines      @"Lines"

#define kGameState			@"gameState"
#define kGameStatePlay		0
#define kGameStateLevel		1
#define kGameStateNewLife	2
#define kGameStateDone		3
#define kGameStateBoost     4
#define kGameStateLine      5


// Button frames, as stored in buttons.png
#define kThrustOff				0
#define kLeftOff				2
#define kRightOff				4
#define kSlowOff				6
#define kThrustOn				1
#define kLeftOn					3
#define kRightOn				5
#define kSlowOn					7
#define kLinesDrawing           8
#define kLinesRelease           9

// Location of things
#define kThrustLocation			CGPointMake(-332,-202)
//#define kLeftLocation			CGPointMake(-212,-132)
//#define kRightLocation		CGPointMake(-158,-132)
//#define kSlowLocation			CGPointMake(212,-132)
#define kShipLocation			CGPointMake(-200,0)
#define kStatusLocation			CGPointMake(-460,290)
#define kLivesLocation			CGPointMake(320,290)

// Sound effects
#define kSound				@"sound"
#define kSoundNone			-1
#define kSoundExplode1		0
#define kSoundExplode2		1
#define kSoundExplode3		2
#define kSoundSlow			3
#define kSoundSaucerFire	4
#define kSoundSaucer1		5
#define kSoundSaucer2		6
#define kSoundThrust		7
#define kSoundAlert			8

#define kTotalSounds		9 // must equal the number of sound effects we have
#define kSoundReload		0.10 // Sounds need at least a tenth of a second before playing again
#define kNewLifeDelay		60 // Number of frames to delay before a new life is begun
