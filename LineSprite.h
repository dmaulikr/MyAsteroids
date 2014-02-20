//
//  LineSprite.h
//  MyAsteroids
//
//  Created by zhang yan on 3/20/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"

@interface LineSprite : Sprite {
    BOOL active;
    CGPoint start;
    CGPoint end;
    CGPoint dir;
}

@property (assign) BOOL active;
@property (assign) CGPoint start, end, dir;

+(LineSprite *) withStartPoint: (CGPoint) p1 withEndPoint: (CGPoint) p2;
-(void) activeSprite;
-(BOOL) hitShipTest: (Sprite *) s;

@end
