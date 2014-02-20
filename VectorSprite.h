//
//  VectorSprite.h
//  MyAsteroids
//
//  Created by zhang yan on 3/16/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Sprite.h"

@interface VectorSprite : Sprite {
	CGFloat *points;
	int count;
	CGFloat vectorScale;
}

@property (assign) int count;
@property (assign) CGFloat vectorScale;
@property (assign) CGFloat *points;

+ (VectorSprite *) withPoints: (CGFloat *) rawPoints count: (int) count;
- (void) updateSize;
@end

