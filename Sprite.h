//
//  Sprite.h
//  MyAsteroids
//
//  Created by zhang yan on 3/16/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Defs.h"

@interface Sprite : NSObject {
	uint type;						// type of our sprite
    int lineNum;                    
	
	CGFloat x;						// x location
	CGFloat y;						// y location
	CGFloat r;						// red tint
	CGFloat g;						// green tint
	CGFloat b;						// blue tint
	CGFloat alpha;					// alpha value, for transparency
	CGFloat speed;					// speed of movement in pixels/frame
	CGFloat angle;					// angle of movement in degrees
	CGFloat rotation;				// rotation of our sprite in degrees, about the center
	CGFloat width;					// width of sprite in pixels
	CGFloat height;					// height of sprite in pixels
	CGFloat scale;					// uniform scaling factor for size
    int boostCount;
	int frame;						// from 0 to (rows*cols - 1)
	
	CGFloat cosTheta;				// pre-computed for speed
	CGFloat sinTheta;
	CGRect box;						// our bounding box
	
	BOOL render;					// true when we're rendering
	BOOL offScreen;					// true when we're off the screen
	BOOL wrap;						// true if you want the motion to wrap on the screen
}

@property (assign) BOOL wrap, render, offScreen;
@property (assign) CGFloat x, y, r, g, b, alpha;
@property (assign, nonatomic) CGFloat speed, angle, rotation;
@property (assign) CGFloat width, height, scale;
@property (assign) CGRect box;
@property (assign) int frame,boostCount,lineNum;
@property (assign) uint type;
@property (assign) CGFloat sinTheta, cosTheta;

- (BOOL) hitTest: (CGRect) rect;    //to check the collision invoked by spriteHitTest
- (BOOL) spriteHitTest: (Sprite *) s;    //to check the collision
- (void) updateBox;    //update the box-framework of objects
- (void) moveTo: (CGPoint) p;    //the movements
- (void) scaleTo: (CGFloat) s;    //to scale

- (void) draw: (CGContextRef) context;    //to draw
- (void) outlinePath: (CGContextRef) context;    //to draw outline
- (void) drawBody: (CGContextRef) context;    //to draw the body 

- (void) tic: (NSTimeInterval) dt;    //time function 
- (void) gradientFill: (CGContextRef) myContext;    //filling function 
- (void) applyForce: (CGFloat) magnitude atAngle : (CGFloat) degrees;    //moving function
- (BOOL) lineHitTest: (CGPoint) p0 p1: (CGPoint) p1;    //hit test

@end

