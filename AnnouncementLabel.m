//
//  AnouncementLabel.m
//  MyAsteroids
//
//  Created by yan zhang on 5/16/12.
//  Copyright (c) 2012 Zhejiang university. All rights reserved.
//

#import "AnnouncementLabel.h"

@implementation AnnouncementLabel

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textAlignment =  UITextAlignmentCenter;
        self.lineBreakMode = UILineBreakModeWordWrap;
        self.numberOfLines = 10;
        self.userInteractionEnabled = NO;
        self.opaque = NO;
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


@end
