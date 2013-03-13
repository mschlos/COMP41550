//
//  AxisDrawer.h
//  Calc
//
//  Created by Ruaidhri Hallinan on 12/03/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AxisDrawer : NSObject
+ (void)drawAxisInRect:(CGRect)bounds originAtPoint:(CGPoint)axisOrigin scale:(CGFloat)pointsPerUnit;

@end