//
//  GraphView.h
//  Calc
//
//  Created by Ruaidhri Hallinan on 12/03/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GraphView;

@protocol GraphViewDelegate

- (double)yGivenX:(double)xValue forGraphView:(GraphView *)requestor;

@property (nonatomic) CGFloat scale; // 1 = 100%
@property (nonatomic) CGPoint origin; // point to place in the middle of the screen

@end

@interface GraphView : UIView

@property (nonatomic, weak) IBOutlet id <GraphViewDelegate> delegate;
- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)pan:(UIPanGestureRecognizer *)gesture;
- (void)center:(UITapGestureRecognizer *)gesture;

@end