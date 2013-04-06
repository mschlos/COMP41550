//
//  GraphViewController.m
//  Calc
//
//  Created by Ruaidhri Hallinan on 12/03/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "GraphViewController.h"
#import "CalcModel.h"

#define POINTS_PER_UNIT 50.0

@interface GraphViewController () <GraphViewDelegate>
@property (nonatomic, retain) IBOutlet GraphView *graphView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *formula;

@end

@implementation GraphViewController
@synthesize toolbar = _toolbar;
@synthesize formula = _formula;
@synthesize expression = _expression;
@synthesize graphView = _graphView;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize scale = _scale;
@synthesize origin = _origin;

- (CGFloat)scale
{
    if (!_scale) return POINTS_PER_UNIT;
    return _scale;
}

- (void)setScale:(CGFloat)scale
{
    if (scale == _scale) return;
    _scale = scale;
    [self.graphView setNeedsDisplay];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:self.scale
                forKey:[NSString stringWithFormat:@"graphViewScale%i",
                        self.graphView.tag]];
    [defaults synchronize];
    
}

- (void)setOrigin:(CGPoint)origin
{
    if (CGPointEqualToPoint(origin, _origin)) return;
    _origin = origin;
    [self.graphView setNeedsDisplay];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:
     [NSArray arrayWithObjects:
      [NSNumber numberWithFloat:self.origin.x],
      [NSNumber numberWithFloat:self.origin.y],
      nil]
                 forKey:[NSString stringWithFormat:@"graphViewOrigin%i",
                         self.graphView.tag]];
    [defaults synchronize];
}

- (void)handleSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        [self handleSplitViewBarButtonItem:splitViewBarButtonItem];
    }
}

- (void) setExpression:(id)expression {
    
    _expression = expression;
    NSLog(@"expression %@", expression);
    NSString *formula = [CalcModel descriptionOfExpression:self.expression];
    if ([formula isEqualToString:@""]) formula = @"Graph";
    else formula = [NSString stringWithFormat:@"y = %@", formula];
    self.title = formula;
    self.formula.title = formula;
    [self.graphView setNeedsDisplay];
}

- (double)yGivenX:(double)xValue forGraphView:(GraphView *)requestor
{
    
    // Find the corresponding Y value by passing the x value to the calculator Brain
    double yValue = [CalcModel evaluateExpression:self.expression usingVariableValues:
                     [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:xValue]
                                                 forKey:@"x"]];
    
    return yValue;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self handleSplitViewBarButtonItem:self.splitViewBarButtonItem];
}

- (void)viewDidUnload
{
    [self setGraphView:nil];
    [self setToolbar:nil];
    [self setFormula:nil];
	self.graphView = nil;
    [super viewDidUnload];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)setGraphView:(GraphView *)graphView
{
    if (graphView == _graphView) return;
    _graphView = graphView;
    graphView.delegate = self;
    [graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]
                                     initWithTarget:self.graphView action:@selector(pinch:)]];
    [graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc]
                                     initWithTarget:self.graphView action:@selector(pan:)]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self.graphView action:@selector(center:)];
    tap.numberOfTapsRequired = 3;
    [graphView addGestureRecognizer:tap];
    
    CGPoint point;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *defaultOrigin = [defaults arrayForKey:[NSString stringWithFormat:@"graphViewOrigin%i", self.graphView.tag]];
    if (defaultOrigin) {
        point.x = [[defaultOrigin objectAtIndex:0] floatValue];
        point.y = [[defaultOrigin objectAtIndex:1] floatValue];
    } else {
        point.x = self.graphView.bounds.origin.x + self.graphView.bounds.size.width / 2;
        point.y = self.graphView.bounds.origin.y + self.graphView.bounds.size.height / 2;
    }
    self.origin = point;
    CGFloat defaultScale = [defaults floatForKey:[NSString stringWithFormat:@"graphViewScale%i", self.graphView.tag]];
    if (defaultScale) self.scale = defaultScale;
}

@end