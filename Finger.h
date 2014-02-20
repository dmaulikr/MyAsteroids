//
//  Finger.h
//  MyAsteroids
//
//  Created by zhang yan on 3/16/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"

@interface Finger : NSObject {
	int		hash;					// hash from touches
    bool    isLine;
	
	CGFloat x0;						// origin
	CGFloat y0;			
	CGFloat x;						// current
	CGFloat y;
	CGFloat t;						// last time
	CGFloat v;						// last velocity
	CGFloat theta;					// angle
	CGFloat speed;					// speed
	CGFloat accel;
	CGPoint pt;						// last point
}

@property (assign) CGFloat x;
@property (assign) CGFloat y;
@property (assign) CGFloat theta;
@property (assign) CGFloat speed;
@property (assign) CGFloat accel;
@property (assign) CGPoint pt;
@property (assign) int hash;
@property (assign) bool isLine;

+ (Finger *) atPoint: (CGPoint) p;
- (void) startAt: (CGPoint) p;
- (void) moveTo: (CGPoint) p;
- (void) update;
- (void) tic: (NSTimeInterval) dt;
- (BOOL) isTouching: (Sprite *) s;

@end
