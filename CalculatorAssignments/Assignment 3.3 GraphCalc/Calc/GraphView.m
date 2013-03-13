//
//  GraphView.m
//  Calc
//
//  Created by Ruaidhri Hallinan on 12/03/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "GraphView.h"
#import "AxisDrawer.h"
@implementation GraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [AxisDrawer drawAxisInRect:rect originAtPoint:CGPointMake(CGRectGetMidX(rect),CGRectGetMidY(rect)) scale:1];
}

@end