//
//  MyAsteroidsViewController.m
//  MyAsteroids
//
//  Created by zhang yan on 3/16/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//

#import "MyAsteroidsViewController.h"

@implementation MyAsteroidsViewController

@synthesize animationTimer, animationInterval, deltaTime, timeSinceLevelStart, levelStartTime, lastFrameStartTime;

- (void)dealloc
{
    [self stopAnimation];
	[game release];
    [announcementLabel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sranddev();
    announcementLabel = [[AnnouncementLabel alloc] initWithFrame:self.view.frame];
    announcementLabel.center = CGPointMake(announcementLabel.center.x, announcementLabel.center.y - 23.0);
    launched = NO;
    over = NO;
    [self showAnnouncement:@"Welcome to MyAsteroids!\n\nPlease tap to begin."];
    
    
    //[self startAnimation];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//
// Core game loop
//
// these methods are copied over from the EAGLView template

- (void)startAnimation {
    UIView *v = [self view];
    v.multipleTouchEnabled = YES;
    game = [[GameController alloc] initWithView: (MyAsteroidsView *) v];
    printf("Inside viewdidload\n");
    
	self.animationInterval = 1.0/kFPS;
	self.levelStartTime = nil;
	self.timeSinceLevelStart = 0;
	self.deltaTime = 0;
	self.levelStartTime = [[NSDate date] retain];
	self.lastFrameStartTime = [levelStartTime timeIntervalSinceNow];
	self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:self.animationInterval
														   target:self 
														 selector:@selector(gameLoop) 
														 userInfo:nil 
														  repeats:YES];
}

- (void)showAnnouncement:(NSString*)announcementText {
    announcementLabel.text = announcementText;
    [self.view addSubview:announcementLabel];
}

- (void)hideAnnouncement {
    [announcementLabel removeFromSuperview];
}

- (void)stopAnimation {
	self.animationTimer = nil;
}

- (void)setAnimationTimer:(NSTimer *)newTimer {
	[animationTimer invalidate];
	animationTimer = newTimer;
}

- (void)setAnimationInterval:(NSTimeInterval)interval {	
	animationInterval = interval;
	if (animationTimer) {
		[self stopAnimation];
		[self startAnimation];
	}
}

- (void)gameLoop
{
	// we use our own autorelease pool so that we can control when garbage gets collected
	NSAutoreleasePool * apool = [[NSAutoreleasePool alloc] init];
	
	/*self.timeSinceLevelStart = [levelStartTime timeIntervalSinceNow];
	self.deltaTime = lastFrameStartTime - timeSinceLevelStart;
	self.lastFrameStartTime = timeSinceLevelStart;	*/
    
	[game tic: self.animationInterval];
    if([MyAsteroidsModel getState:kGameState] == kGameStateDone) over = YES;
	[apool release];
}

//
// Basic UI - store touches in the model
//

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	NSSet *allTouches = [event allTouches];
    for (UITouch *touch in allTouches) {
        // Get the point where the player has touched the screen
        CGPoint touchLocation = [touch locationInView:self.view];
		[game.model placeFinger: [touch hash] at: touchLocation];
    }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    NSSet *allTouches = [event allTouches];
    for (UITouch *touch in allTouches) {
		CGPoint touchLocation = [touch locationInView:self.view];
		[game.model moveFinger: [touch hash] to: touchLocation];
	}
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *st = [[event allTouches] anyObject];
    if (!launched && st.tapCount > 0) {
        launched = YES;
        [self hideAnnouncement];
        [self startAnimation];
        return;
    }
    else if(over && st.tapCount > 0){
        over = NO;
        //todo: restart
        return;
    }
    
	for (UITouch *touch in touches) {
		[game.model liftFinger: [touch hash]];
	}
}

@end
