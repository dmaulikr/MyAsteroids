//
//  Sprite.m
//  MyAsteroids
//
//  Created by zhang yan on 3/16/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//

#import "Sprite.h"

@implementation Sprite
@synthesize x,y,speed,angle,width,height,scale,frame,box,rotation,wrap,render,type;
@synthesize r,g,b,alpha,offScreen;
@synthesize sinTheta,cosTheta;
@synthesize boostCount,lineNum;

- (id) init
{
	self = [super init];
	if (self) {
        lineNum = -1;
        boostCount = kBoostFrame;
		wrap = NO;
		x = y = 0.0;
		width = height = 1.0;
		scale = 1.0;
		speed = 0.0;
		angle = 0.0;
		rotation = 0;   // facing angle
		cosTheta = 1.0;
		sinTheta = 0.0;
		r = 1.0;
		g = 1.0;
		b = 1.0;
		alpha = 1.0;
		offScreen = NO;
		box = CGRectMake(0,0,0,0);
		frame = 0;
		render = YES;
		type = kSpriteType;
	}
	return self;
}

- (void) setAngle: (CGFloat) a
{
	angle = a;
	cosTheta = cos(a*PI/180.0);
	sinTheta = sin(a*PI/180.0);
    
}

- (void) applyForce: (CGFloat) magnitude atAngle: (CGFloat) degrees
{
	CGFloat rad = degrees*PI/180.0;
	CGFloat xnew = speed*cosTheta + magnitude*cos(rad);
	CGFloat ynew = speed*sinTheta + magnitude*sin(rad);
	CGFloat angleNew = atan2(ynew,xnew)*180.0/PI; 
	CGFloat speedNew = sqrt(xnew*xnew + ynew*ynew);
	
	//printf("Ship heading %f thrust at %f yields %f\n", rotation*180.0/PI, degrees, angleNew);
	[self setAngle: angleNew];
	
	speed = speedNew;
}

- (void) setRotation: (CGFloat) newRot
{
	//printf("Ship rotated to %f\n", newRot);
	rotation = newRot*PI/180.0;
}

- (void) scaleTo: (CGFloat) zoom;
{
	scale = zoom;
	[self updateBox];
}

- (void) moveTo: (CGPoint) p
{
	x = p.x;
	y = p.y;
	[self updateBox];
}

- (void) updateBox
{
	CGFloat w = width*scale;
	CGFloat h = height*scale;
	CGFloat w2 = w*0.5;
	CGFloat h2 = h*0.5;
	CGPoint origin = box.origin;
	CGSize bsize = box.size;
	CGFloat left = -kScreenHeight*0.5;
	CGFloat right = -left;
	CGFloat top = kScreenWidth*0.5;
	CGFloat bottom = -top;
	
	offScreen = NO;
	if (wrap) {
		if ((x+w2) < left) x = right + w2;
		else if ((x-w2) > right) x = left - w2;
		else if ((y+h2) < bottom) y = top + h2;
		else if ((y-h2) > top) y = bottom - h2; 
	}
	else {
		offScreen = 
		((x+w2) < left) ||
		((x-w2) > right) ||
		((y+h2) < bottom) ||
		((y-h2) > top);
	}
    
	origin.x = x-w2;
	origin.y = y-h2;
	bsize.width = w;
	bsize.height = h;
	box.origin = origin;
	box.size = bsize;
}

- (void) gradientFill: (CGContextRef) myContext
{
	CGGradientRef myGradient;
	CGColorSpaceRef myColorspace;
    
	CGPoint myStartPoint, myEndPoint;
	CGFloat myStartRadius, myEndRadius;
	
	CGFloat w2 = box.size.width*0.5;
	CGFloat h2 = box.size.height*0.5;
	myStartPoint.x = 0;
	myStartPoint.y = 0;
	myEndPoint.x = 0;
	myEndPoint.y = 0;
	myStartRadius = 0.0;
	myEndRadius = (w2 > h2) ? w2*1.5 : h2*1.5;
	size_t num_locations = 2;
	CGFloat locations[2] = { 0, 1.0 };
	CGFloat components[8] = { 
		r,g,b, 1.0,
		r,g,b, 0.1, 
	};
	myColorspace = CGColorSpaceCreateDeviceRGB();
	myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
													  locations, num_locations);
	CGContextDrawRadialGradient (myContext, myGradient, myStartPoint,
								 myStartRadius, myEndPoint, myEndRadius,
								 kCGGradientDrawsAfterEndLocation);
}
- (void) tic: (NSTimeInterval) dt
{
	if (!render) return;
	
	CGFloat sdt = speed*dt;
	x += sdt*cosTheta;
	y += sdt*sinTheta;
    if (!wrap && type == kShipType) {
        x = x>kScreenHeight/2?kScreenHeight/2:x;
        x = x<-kScreenHeight/2?-kScreenHeight/2:x;
        y = y>kScreenWidth/2?kScreenWidth/2:y;
        y = y<-kScreenWidth/2?-kScreenWidth/2:y;
    }
	if (sdt) [self updateBox];
}

- (void) outlinePath: (CGContextRef) context
{
	// By default, just draw our box outline, assuming our center is at (0,0)
    
	CGFloat w2 = box.size.width*0.5;
	CGFloat h2 = box.size.height*0.5;
	
	CGContextBeginPath(context);
	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextMoveToPoint(context, -w2, h2);
	CGContextAddLineToPoint(context, w2, -h2);
	CGContextAddLineToPoint(context, w2, -h2);
	CGContextAddLineToPoint(context, -w2, -h2);
	CGContextAddLineToPoint(context, -w2, h2);
	CGContextClosePath(context);
}		

- (void) draw: (CGContextRef) context
{
	
	CGContextSaveGState(context);
	
	// Position the sprite 
	CGAffineTransform t = CGAffineTransformIdentity;
	t = CGAffineTransformTranslate(t,y+320,480-x);
	t = CGAffineTransformRotate(t,rotation - PI/2.0);
	t = CGAffineTransformScale(t,scale,scale);
	CGContextConcatCTM(context, t);
    
	// draw sprite body
	[self drawBody: context];
	
	CGContextRestoreGState(context);
    
}

- (void) drawBody: (CGContextRef) context
{
	
	if (alpha < 0.05) return;
	
	CGContextBeginPath(context);
	CGContextSetRGBFillColor(context, r,g,b,alpha);
	CGContextAddEllipseInRect(context, CGRectMake(-width/2,-height/2,width,height));
	CGContextClosePath(context);
	CGContextDrawPath(context,kCGPathFill);
}

//
// Collision detection
//

//
// Determine if lines (p0,p1) and (p2,p3) intersect
//

- (BOOL) linesIntersect: (CGPoint) p0 p1: (CGPoint) p1 p2: (CGPoint) p2 p3: (CGPoint) p3
{
	CGPoint s1, s2;
	
    s1.x = p1.x - p0.x;     s1.y = p1.y - p0.y;
    s2.x = p3.x - p2.x;     s2.y = p3.y - p2.y;
	
    CGFloat s, t;
    s = (-s1.y * (p0.x - p2.x) + s1.x * (p0.y - p2.y)) / (-s2.x * s1.y + s1.x * s2.y);
    t = ( s2.x * (p0.y - p2.y) - s2.y * (p0.x - p2.x)) / (-s2.x * s1.y + s1.x * s2.y);
	
    return (s >= 0 && s <= 1 && t >= 0 && t <= 1);
}


- (BOOL) hitTest: (CGRect) rect
{
	return CGRectIntersectsRect(rect, box);
}

- (BOOL) spriteHitTest: (Sprite *) s
{
	return CGRectIntersectsRect(box, s.box);
}

- (BOOL) lineHitTest: (CGPoint) p0 p1: (CGPoint) p1
{
	CGPoint p2, p3;
	CGFloat w = box.size.width;
	CGFloat h = box.size.height;
	BOOL hit = NO;
	
	p2 = box.origin;
	p3 = CGPointMake(p2.x+w, p2.y);
	hit = [self linesIntersect: p0 p1: p1 p2: p2 p3: p3];
	if (hit) return YES;
	
	p3 = CGPointMake(p2.x, p2.y+h);
	hit = [self linesIntersect: p0 p1: p1 p2: p2 p3: p3];
	if (hit) return YES;
	
	p2 = CGPointMake(p3.x+w, p3.y);
	hit = [self linesIntersect: p0 p1: p1 p2: p2 p3: p3];
	if (hit) return YES;
	
	p3 = CGPointMake(p2.x, p2.y-h);
	return [self linesIntersect: p0 p1: p1 p2: p2 p3: p3];
}

- (void) dealloc
{
	[super dealloc];
}

@end
