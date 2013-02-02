//
//  ViewController.m
//  Calc
//
//  Created by Ruaidhri Hallinan on 30/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize calcModel = _calcModel;
@synthesize calcDisplay = _calcDisplay;
@synthesize isInTheMiddleOfTypingSomething = _isInTheMiddleOfTypingSomething;

- (IBAction)digitPressed:(UIButton *)sender {
    NSLog(@"digitPressed!");
    NSString *digit = sender.titleLabel.text;
    
    //This might need a tidy up 
    if([digit isEqual:@"0"] && [self.calcModel.waitingOperation isEqual:@"/"]){
            NSLog(@"digit: %@ ", digit);
            NSLog(@"operand: %@ ", self.calcModel.waitingOperation);
            // validation of dividing by 1 UIAlertView example
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Invalid"
                                  message: @"You cant divide by 0!"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        
        // UILabel example
        self.errorDisplay.text = @"You cant divide by 0!";
    }
    else {
        self.errorDisplay.text = @"";
        self.errorDisplay = nil;
    }

    if(self.isInTheMiddleOfTypingSomething)
        self.calcDisplay.text =
        [self.calcDisplay.text stringByAppendingString:digit];
    else {
        [self.calcDisplay setText:digit];
        self.isInTheMiddleOfTypingSomething = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    NSLog(@"operationPressed!");
    if(self.isInTheMiddleOfTypingSomething) {
        self.calcModel.operand = [self.calcDisplay.text doubleValue];
        self.isInTheMiddleOfTypingSomething = NO;
    }
    
    NSString *operation = [[sender titleLabel] text];
    double result = [[self calcModel] performOperation:operation];
    [self.calcDisplay setText:[NSString stringWithFormat:@"%g", result]];
}

// noticing a bug here when adding two floating point numbers, it wont allow a decimal in the second number
- (IBAction)pointPressed:(UIButton *)sender {
    NSLog(@"pointPressed!");
    NSRange range = [self.calcDisplay.text rangeOfString:@"."];
    if(range.location == NSNotFound) {
            self.calcDisplay.text = [self.calcDisplay.text stringByAppendingString:@"."];
    }
    self.isInTheMiddleOfTypingSomething = YES;
}
@end
