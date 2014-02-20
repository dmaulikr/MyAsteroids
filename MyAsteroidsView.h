//
//  MyAsteroidsView.h
//  MyAsteroids
//
//  Created by zhang yan on 3/17/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AtlasSprite.h"
#import "VectorSprite.h"
#import "MyAsteroidsModel.h"

@interface MyAsteroidsView : UIView {
	MyAsteroidsModel *model;
	BOOL ready;
}

@property (retain,nonatomic) MyAsteroidsModel *model;

- (void) useModel: (MyAsteroidsModel *) model;
- (void) tic: (NSTimeInterval) dt;

@end

