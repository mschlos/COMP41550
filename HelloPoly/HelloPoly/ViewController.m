//
//  ViewController.m
//  HelloPoly
//
//  Created by Ruaidhri Hallinan on 15/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "ViewController.h"
#import "PolygonShape.h"
#import "PolygonView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet PolygonView *polygonView;
@property (nonatomic, strong) PolygonShape *model;

@property (weak, nonatomic) IBOutlet UIButton *decrease;
@property (weak, nonatomic) IBOutlet UIButton *increase;

@property (weak, nonatomic) IBOutlet UILabel *numberOfSidesLabel;

- (IBAction)increase:(UIButton *)sender;
- (IBAction)decrease:(UIButton *)sender;

- (IBAction)handleSwipeLeft:(UISwipeGestureRecognizer *)sender;
- (IBAction)handleSwipeRight:(UISwipeGestureRecognizer *)sender;

@end

@implementation ViewController

- (PolygonShape *)polygonModel
{
    if (!_model) {
        _model = [[PolygonShape alloc] init];
    }
    return _model;
}

- (int) numberOfSides:(PolygonView *)polygonViewDelegator {
    int numberOfSides = -1;
    if(polygonViewDelegator == self.polygonView) {
       return self.model.numberOfSides; 
    }
    return numberOfSides;
}

- (void)viewWillAppear:(BOOL)animated {
    self.polygonView .delegate = self;
    [self.numberOfSidesLabel setText:self.polygonModel.name];
}

- (IBAction)decrease:(UIButton *)sender {
    NSLog(@"I'm in the decrease method!");
    self.polygonModel.numberOfSides = self.polygonModel.numberOfSides - 1;
    
    [self updateLabel];
}

- (IBAction)handleSwipeLeft:(UISwipeGestureRecognizer *)sender {
    NSLog(@"I'm in the handleSwipeLeft method!");
    self.polygonModel.numberOfSides = self.polygonModel.numberOfSides - 1;
    
    [self updateLabel];
}

- (IBAction)handleSwipeRight:(UISwipeGestureRecognizer *)sender {
    NSLog(@"I'm in the handleSwipeRight method!");
    self.polygonModel.numberOfSides = self.polygonModel.numberOfSides + 1;
    
    [self updateLabel];
}

- (IBAction)increase:(UIButton *)sender {
    NSLog(@"I'm in the increase method!");
    self.polygonModel.numberOfSides = self.polygonModel.numberOfSides + 1;
    
    [self updateLabel];
}

- (void)updateLabel {
    
    [self.numberOfSidesLabel setText:self.polygonModel.name];
    [self.polygonView setNeedsDisplay];
    
    if (self.model.numberOfSides == 3) {
        
		self.decrease.enabled = NO;
        [self.decrease setBackgroundColor:[UIColor blackColor]];
    }
	else if (self.model.numberOfSides == 12){
		self.decrease.enabled = YES;
        [self.decrease setBackgroundColor:[UIColor whiteColor]];
        
		self.increase.enabled = NO;
        [self.increase setBackgroundColor:[UIColor blackColor]];
	}
	else{
		self.decrease.enabled = YES;
		self.increase.enabled = YES;
        
        [self.increase setBackgroundColor:[UIColor whiteColor]];
        [self.decrease setBackgroundColor:[UIColor whiteColor]];
	}
}

- (void) awakeFromNib {
    NSLog(@"My polygon: %@", self.model.name);
}

@end
