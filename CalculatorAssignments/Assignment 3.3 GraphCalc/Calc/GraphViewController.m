//
//  GraphViewController.m
//  Calc
//
//  Created by Ruaidhri Hallinan on 12/03/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "GraphViewController.h"
#import "CalcModel.h"

@interface GraphViewController()
@property (retain) IBOutlet GraphView *graphView;
@end

@implementation GraphViewController
@synthesize expression = _expression;
@synthesize graphView = _graphView;

- (void) setExpression:(id)expression {
    
    _expression = expression;
    // NB Expression is null here...
    NSLog(@"expression %@", expression);
    
    // We want to set the title of the controller if the program changes
    self.title = [NSString stringWithFormat:@"y = %@",
                  [CalcModel descriptionOfExpression:self.expression]];

}

- (double)yGivenX:(double)xValue forGraphView:(GraphView *)requestor
{
    
    // Find the corresponding Y value by passing the x value to the calculator Brain
    double yValue = [CalcModel evaluateExpression:self.expression usingVariableValues:
                     [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:xValue]
                                                 forKey:@"x"]];
    
    return yValue;
}

#pragma mark - Target actions

- (IBAction)zoomInPressed
{
	self.graphView.scale *= 1.5;
	[self.graphView setNeedsDisplay];
}

- (IBAction)zoomOutPressed
{
	self.graphView.scale /= 1.5;
	[self.graphView setNeedsDisplay];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.graphView.delegate = self;
	self.graphView.scale = 20;
	[self.graphView setNeedsDisplay];
	self.title = @"Graph";
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	self.graphView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end