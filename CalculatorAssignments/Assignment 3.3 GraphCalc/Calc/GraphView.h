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
@end

@interface GraphView : UIView

@property (nonatomic, strong) id <GraphViewDelegate> delegate;
@property double scale;
@end