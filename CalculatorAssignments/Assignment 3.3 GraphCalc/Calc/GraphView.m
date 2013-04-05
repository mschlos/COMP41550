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

@synthesize scale;
//@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (double)xValueForHorizontalPixel:(double)px
{
	double absPt = px / self.contentScaleFactor;
	double ptWRTOrigin = absPt - (CGRectGetWidth(self.bounds) / 2.0);
	return ptWRTOrigin / scale;
}

- (double)verticalPointForYValue:(double)y
{
	//-y = (absPt - (CGRectGetHeight(self.bounds) / 2.0)) / scale
	//-y * scale = absPt - (CGRectGetHeight(self.bounds) / 2.0)
	//(-y * scale) + (CGRectGetHeight(self.bounds) / 2.0) = absPt
	
	double ptWRTOrigin = -y * scale;
	return ptWRTOrigin + (CGRectGetHeight(self.bounds) / 2.0);
	
}

- (void)drawRect:(CGRect) rect
{
    NSLog(@"x: %f", rect.origin.x);
    NSLog(@"y: %f", rect.origin.y);
    
	CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.bounds),
									  CGRectGetMidY(self.bounds));
	[[UIColor blueColor] set];
    [AxisDrawer drawAxisInRect:self.bounds originAtPoint:centerPoint scale:scale];
    
	int minXPixel = self.bounds.origin.x * self.contentScaleFactor;
	int maxXPixel = (self.bounds.origin.x + CGRectGetWidth(self.bounds)) * self.contentScaleFactor;
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextBeginPath(context);
	double x = [self xValueForHorizontalPixel:minXPixel];
	double y = [self.delegate yGivenX:x forGraphView:self];
	double vertPt = [self verticalPointForYValue:y];
	CGContextMoveToPoint(context,
						 minXPixel / self.contentScaleFactor,
						 vertPt);
	++minXPixel;
	for (int px = minXPixel; px < maxXPixel; ++px) {
		double horzPt = px / self.contentScaleFactor;
		double x = [self xValueForHorizontalPixel:px];
		double y = [self.delegate yGivenX:x forGraphView:self];
		double vertPt = [self verticalPointForYValue:y];
		CGContextAddLineToPoint(context, horzPt, vertPt);
	}
    
	[[UIColor redColor] set];
	CGContextDrawPath(context, kCGPathStroke);
}

@end