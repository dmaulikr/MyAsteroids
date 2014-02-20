//
//  TextSprite.h
//  MyAsteroids
//
//  Created by zhang yan on 3/16/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"
#import "Defs.h"

@interface TextSprite : Sprite {
	NSString *text;
	NSString *font;
	uint fontSize;
	uint textLength;
	
	char *charFont;
	char *charText;
}

@property (assign) NSString *text;
@property (assign) NSString *font;
@property (assign) uint fontSize;

+ (TextSprite *) withString: (NSString *) label;
- (void) moveUpperLeftTo: (CGPoint) p;
- (void) newText: (NSString *) val;

@end
