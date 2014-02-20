//
//  MyAsteroidsAppDelegate.h
//  MyAsteroids
//
//  Created by zhang yan on 3/16/12.
//  Copyright 2012 Zhejiang university. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyAsteroidsViewController;

@interface MyAsteroidsAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MyAsteroidsViewController *viewController;

@end
