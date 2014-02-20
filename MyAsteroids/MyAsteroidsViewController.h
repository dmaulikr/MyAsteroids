//
//  MyAsteroidsViewController.h
//  MyAsteroids
//
//  Created by zhang yan on 3/16/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MyAsteroidsModel.h"
#import "MyAsteroidsView.h"
#import "Defs.h"
#import "GameController.h"
#import "AnnouncementLabel.h"

@interface MyAsteroidsViewController : UIViewController {
	GameController *game;
	NSTimer *animationTimer;
	NSTimeInterval animationInterval;
	NSTimeInterval deltaTime;
	NSTimeInterval lastFrameStartTime;
	NSTimeInterval timeSinceLevelStart;
	NSDate * levelStartTime;
    AnnouncementLabel *announcementLabel;
    BOOL launched;
    BOOL over;
}

@property (retain, nonatomic) NSTimer *animationTimer;
@property (assign, nonatomic) NSTimeInterval animationInterval;
@property (assign) NSTimeInterval deltaTime;
@property (assign) NSTimeInterval lastFrameStartTime;
@property (assign) NSTimeInterval timeSinceLevelStart;
@property (assign) NSDate *levelStartTime;

- (void) startAnimation;
- (void) stopAnimation;
- (void) showAnnouncement: (NSString *)text;
- (void) hideAnnouncement;

@end
