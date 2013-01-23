//
//  PolygonView.m
//  HelloPoly
//
//  Created by Ruaidhri Hallinan on 16/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "PolygonView.h"

@interface PolygonView()
@property (nonatomic, strong) NSArray *points;
@end

@implementation PolygonView

-(void) drawRect:(CGRect)rect{
    
    int numberOfSides = [self.delegate numberOfSides:self];
    
    if(self.points.count != numberOfSides)
        self.points = [PolygonView pointsForPolygonInRect:self.bounds numberOfSides:numberOfSides];
    
    if(self.points.count <3) return;
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextBeginPath (context);
    
	for(NSValue * point in self.points) {
		CGPoint val = [point CGPointValue];
		if([self.points indexOfObject:point]==0)
			CGContextMoveToPoint (context, val.x, val.y);
		else
			CGContextAddLineToPoint (context, val.x, val.y);
	}
    
	CGContextClosePath (context);
	[[UIColor greenColor] setFill];
	[[UIColor blackColor] setStroke];
	CGContextDrawPath (context, kCGPathFillStroke);
}

+ (NSArray *)pointsForPolygonInRect:(CGRect)rect numberOfSides:(int)numberOfSides {
    CGPoint center = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
    float radius = 0.9 * center.x; NSMutableArray *result = [NSMutableArray array];
    float angle = (2.0 * M_PI) / numberOfSides;
    float exteriorAngle = M_PI - angle;
    float rotationDelta = angle - (0.5 * exteriorAngle); 
    for (int currentAngle = 0; currentAngle < numberOfSides; currentAngle++) {
        float newAngle = (angle * currentAngle) - rotationDelta;
        float curX = cos(newAngle) * radius;
        float curY = sin(newAngle) * radius;
        [result addObject:[NSValue valueWithCGPoint:
        CGPointMake(center.x+curX,center.y+curY)]];
    }
    return result; }

@end
