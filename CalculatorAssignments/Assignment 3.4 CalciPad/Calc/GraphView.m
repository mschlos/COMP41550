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
@synthesize delegate = _delegate;

- (CGPoint)pointOfTouch:(CGPoint)touch
{
    CGPoint point;
    point.x = (touch.x - self.delegate.origin.x)
    / self.delegate.scale;
    point.y = (touch.y - self.delegate.origin.y)
    / self.delegate.scale;
    return point;
}

- (void)setOriginFor:(CGPoint)point forTouch:(CGPoint)touch
{
    CGPoint origin;
    origin.x = touch.x - point.x * self.delegate.scale;
    origin.y = touch.y - point.y * self.delegate.scale;
    self.delegate.origin = origin;
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state != UIGestureRecognizerStateChanged) &&
        (gesture.state != UIGestureRecognizerStateEnded)) return;
    
    CGPoint touch = [gesture locationInView:self];
    CGPoint point = [self pointOfTouch:touch];
    self.delegate.scale *= gesture.scale;
    gesture.scale = 1;
    [self setOriginFor:point forTouch:touch];
    
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state != UIGestureRecognizerStateChanged) &&
        (gesture.state != UIGestureRecognizerStateEnded)) return;
    CGPoint translation = [gesture translationInView:self];
    translation.x += self.delegate.origin.x;
    translation.y += self.delegate.origin.y;
    self.delegate.origin = translation;
    [gesture setTranslation:CGPointZero inView:self];
}

- (void)center:(UITapGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateEnded) return;
    CGPoint location = [gesture locationInView:self];
    self.delegate.origin = location;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (CGFloat)xPointFromPixel:(NSInteger)xPixel inRect:(CGRect)bounds
{
    return xPixel / self.contentScaleFactor + bounds.origin.x;
}

- (double)xValueFromPixel:(NSInteger)xPixel inRect:(CGRect)bounds originAtPoint:(CGPoint)origin scale:(CGFloat)pointsPerUnit
{
    return ([self xPointFromPixel:xPixel inRect:bounds] - origin.x) / pointsPerUnit;
}

- (CGFloat)yPointFromValue:(double)y inRect:(CGRect)bounds originAtPoint:(CGPoint)origin scale:(CGFloat)pointsPerUnit
{
    return origin.y - y * pointsPerUnit;
}

- (double)xValueForHorizontalPixel:(double)px
{
	double absPt = px / self.contentScaleFactor;
	double ptWRTOrigin = absPt - (CGRectGetWidth(self.bounds) / 2.0);
	return ptWRTOrigin / self.delegate.scale;
}

- (double)verticalPointForYValue:(double)y
{
	double ptWRTOrigin = -y * self.delegate.scale;
	return ptWRTOrigin + (CGRectGetHeight(self.bounds) / 2.0);
}

- (void)drawRect:(CGRect) rect
{
    NSLog(@"x: %f", rect.origin.x);
    NSLog(@"y: %f", rect.origin.y);
    
	CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.bounds),
									  CGRectGetMidY(self.bounds));
	[[UIColor blueColor] set];
    CGFloat scale = self.delegate.scale;
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
}

@end