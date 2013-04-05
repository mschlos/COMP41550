//
//  GraphViewController.h
//  Calc
//
//  Created by Ruaidhri Hallinan on 12/03/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController <GraphViewDelegate> 

@property (nonatomic, strong) id expression;

- (IBAction)zoomInPressed;
- (IBAction)zoomOutPressed;

@end
