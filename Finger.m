//
//  Finger.m
//  MyAsteroids
//
//  Created by zhang yan on 3/16/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//

#import "Finger.h"
#import "MyAsteroidsModel.h"

@implementation Finger

@synthesize x,y,speed,theta,hash,accel,pt,isLine;

+ (Finger *) atPoint: (CGPoint) p
{
	Finger *f = [[Finger alloc] init];
	[f startAt: p];
	return f;
}

- (id) init
{
	self = [super init];
	if (self) {
        isLine = NO;
		x0 = y0 = 0;
		x = y = 0;
		speed = 0;
		theta = 0;
		hash = 0;
		pt.x = pt.y = 0;
		t = [[MyAsteroidsModel sharedModel] time];
	}
	return self;
}

- (void) startAt: (CGPoint) p
{
	CGPoint p1 = [MyAsteroidsModel gamePoint: p];
	x0 = x = p1.x;
	y0 = y = p1.y;
	speed = 0;
	theta = 0;
	accel = 0;
	v = 0;
	t = [[MyAsteroidsModel sharedModel] time];
	pt = p1;
	printf("finger %d down @(%f,%f)\n", hash, x, y);
}

- (void) moveTo: (CGPoint) p
{
	pt = [MyAsteroidsModel gamePoint: p];
}

- (BOOL) isTouching: (Sprite *) s
{
	return CGRectContainsPoint(s.box, self.pt);
}

- (void) update
{
	CGFloat t1 = [[MyAsteroidsModel sharedModel] time];
	CGFloat dt = (t1 - t);
	CGFloat dx = (pt.x - x);
	CGFloat dy = (pt.y - y);
	
	if (dx == 0 && dy == 0) {
		// slowly dampen our speed and acceleration
		speed = speed*0.95;
		accel = accel*0.95;
	}
	else {
		theta = atan2(dy,dx);
		speed = (dt == 0) ? 0 : sqrt(dx*dx+dy*dy)/dt;
		accel = (dt == 0) ? 0 : (speed - v)/dt;
		x = pt.x;
		y = pt.y;
		v = speed;
		t = t1;
		//printf("finger %d speed=%f accel=%f theta=%f @(%f,%f)\n", hash, speed, accel, theta*180.0/3.141592, x, y);
	}
}

- (void) tic: (NSTimeInterval) dt
{
	[self update];
}




@end