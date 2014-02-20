//
//  LineSprite.m
//  MyAsteroids
//
//  Created by zhang yan on 3/20/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//

#import "LineSprite.h"


@implementation LineSprite

@synthesize active;
@synthesize start, end, dir;

- (id) init
{
    self = [super init];
    if (self) {
        active = NO;
        type = kLineType;
    }
    return self;
}

+ (LineSprite *) withStartPoint:(CGPoint)p1 withEndPoint:(CGPoint)p2
{
    LineSprite *line= [[LineSprite alloc] init];
    line.start = p1;
    line.end = p2;
    line.dir = CGPointMake(p2.x-p1.x, p2.y-p1.y);
    return line;
}

- (void) activeSprite;
{
    self.active = YES;
}

- (BOOL) hitShipTest:(Sprite *)s
{
    CGPoint p = CGPointMake(start.x+(end.x-start.x)/2, start.y+(end.y-start.y)/2);
    
    //printf("%.1f\n",(s.x-p.x)*(s.x-p.x)+(s.y-p.y)*(s.y-p.y));
    
    if((s.x-p.x)*(s.x-p.x)+(s.y-p.y)*(s.y-p.y)<kEps /*&& 
       (cross.x-p.x)*(cross.x-p.x)+(cross.y-p.y)*(cross.y-p.y)<(dir.x*dir.x+dir.y*dir.y)/2*/){
        return YES;
    }
    return NO;
}

- (void) tic:(NSTimeInterval)dt
{
    //[super tic: dt];
    self.start = CGPointMake(start.x-speed*dt, start.y);
    self.end = CGPointMake(end.x-speed*dt, end.y);
}

- (void) outlinePath: (CGContextRef) context
{
    if (active) {
        r = 1.0;
        g = 1.0;
        b = 1.0;
    }
    else{
        r = 1.0;
        g = 0;
        b = 0;
    }
	CGContextBeginPath(context);
	CGContextSetRGBStrokeColor(context, r, g, b, alpha);
    CGContextSetLineWidth(context, kLineWidth);
	CGContextMoveToPoint(context, start.x, start.y);
    CGContextAddLineToPoint(context, end.x, end.y);
    CGContextClosePath(context);
}

- (void) drawBody:(CGContextRef)context
{
    [self outlinePath:context];
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
