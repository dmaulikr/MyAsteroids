//
//  AudioController.h
//  MyAsteroids
//
//  Created by zhang yan on 3/17/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defs.h"
#import "MyAsteroidsModel.h"
#include <AudioToolbox/AudioToolbox.h>

@interface AudioController : NSObject {
	SystemSoundID *sounds;
	CGFloat reload;
}

- (void) loadSound: (NSString *) name withKey: (uint) key;
- (void) tic: (NSTimeInterval) dt;

@end

