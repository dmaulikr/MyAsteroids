//
//  MyAsteroidsView.m
//  MyAsteroids
//
//  Created by zhang yan on 3/17/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//

#import "MyAsteroidsView.h"
//#import "images.h"
#import "Defs.h"

@implementation MyAsteroidsView
@synthesize model;

- (void) useModel: (MyAsteroidsModel *) theModel
{
	self.model = theModel;
	ready = YES;
}

- (void)drawRect:(CGRect)rect {
	if (!ready) return;
	
	// Get a graphics context, with no transformations
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	CGAffineTransform t0 = CGContextGetCTM(context);
	t0 = CGAffineTransformInvert(t0);
	CGContextConcatCTM(context,t0);
	
    //head-up setting
	[model.status draw: context];
	[model.lives draw: context];
	
    // Draw
	if (![MyAsteroidsModel getState: kGameOver]) {
		[[model myShip] draw: context];
	}
	
	NSMutableArray *rocks = [model rocks];
	for (Sprite *rock in rocks) {
		[rock draw: context];
	}
    
    NSMutableArray *lines = [model lines];
    for (Sprite *line in lines) {
        [line draw:context];
    }
    
	//[model.left draw: context];
	//[model.right draw: context];
	[model.thrust draw: context];
	//[model.slow draw: context];
	
	CGContextRestoreGState(context);
	
}

- (void) tic: (NSTimeInterval) dt
{
	if (!model) return;
	[self setNeedsDisplay];
}

- (void)dealloc {
    [super dealloc];
}


@end
