//
//  ViewController.m
//  Calc
//
//  Created by Ruaidhri Hallinan on 30/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "ViewController.h"
#import "CalcModel.h"
#import "GraphViewController.h"

@interface ViewController ()
@property (nonatomic) BOOL numberHasDecimalPoint;
@property (nonatomic, strong) NSDictionary *testVariableValues;
@property (nonatomic) double memory;
@end

@implementation ViewController

@synthesize isInTheMiddleOfTypingSomething = _isInTheMiddleOfTypingSomething;
@synthesize calcModel = _calcModel;
@synthesize calcDisplay = _calcDisplay;

@synthesize histDisplay = _histDisplay;
@synthesize numberHasDecimalPoint = _numberHasDecimalPoint;
@synthesize memory = _memory;

- (GraphViewController *)graphViewController {
    return [self.splitViewController.viewControllers lastObject];
}

- (IBAction)graphPressed:(UIButton *)sender {
    
    if ([self graphViewController]) {
        [[self graphViewController] setProgram:self.calcModel.expression];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GraphViewController *destVC = (GraphViewController *)segue.destinationViewController;

    [destVC setProgram:self.calcModel.expression];
}


- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.titleLabel.text;
    NSLog(@"digitPressed %@", digit);
    
    if(self.isInTheMiddleOfTypingSomething) {
        if ([digit isEqualToString:@"."]) {
            if (self.numberHasDecimalPoint)
                return;
            else
                self.numberHasDecimalPoint = YES;
        }
        self.calcDisplay.text = [self.calcDisplay.text stringByAppendingString:digit];
    } else {
        if ([digit isEqualToString:@"."]) {
            self.calcDisplay.text = @"0.";
            self.numberHasDecimalPoint = YES;
        } else
            self.calcDisplay.text = digit;
        
        self.isInTheMiddleOfTypingSomething = YES;
    }
}


- (IBAction)operationPressed:(UIButton *) operation {
    
    NSLog(@"calcDisplay text: %@", self.calcDisplay.text);
    
    NSString *operator = [operation currentTitle];
    
    if(self.isInTheMiddleOfTypingSomething) {
        [self innerSolve];
    }
    
    // Performaning the Memory stuff here
    NSLog(@"operationPressed %@", operator);
    if ([operator isEqualToString:@"STO"]) {
        NSLog(@"STO: ");
        self.memory = [self.calcDisplay.text doubleValue];
        NSLog(@"%f", self.memory);
        
    } else if ([operator isEqualToString:@"RCL"]) {
        NSLog(@"RCL: ");
        operator = [NSString stringWithFormat:@"%g", self.memory];
        NSLog(@"%f", self.memory);
        NSLog(@"operator: ");
        NSLog(@"%@", operator);
        
    } else if ([operator isEqualToString:@"M+"]) {
        NSLog(@"M+ ");
        self.memory = self.memory + [self.calcDisplay.text doubleValue];
        NSLog(@"%f", self.memory);
        
    } else if ([operator isEqualToString:@"MC"]) {
        NSLog(@"MC ");
        self.memory = 0;
    }
    else {
        self.calcDisplay.text = [self.calcDisplay.text stringByAppendingString:operator];
        [self.calcModel pushVariable:operator];
    }
}

- (void)innerSolve {
    [self.calcModel pushOperand:[self.calcDisplay.text doubleValue]];
    self.isInTheMiddleOfTypingSomething = NO;
    
    [self updateView];
}

- (IBAction)solvePressed:(UIButton *)sender  {
    // Hard coding values for x, a and b
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:5], @"x", nil];
    [self innerSolve];
}

- (IBAction)clearError {
    NSLog(@"CE : clear Error");
    if (self.isInTheMiddleOfTypingSomething) {
        self.calcDisplay.text =[self.calcDisplay.text substringToIndex: [self.calcDisplay.text length] - 1];
        
        if ( [self.calcDisplay.text isEqualToString:@""]
            || [self.calcDisplay.text isEqualToString:@"0"]
            || [self.calcDisplay.text isEqualToString:@"-"]) {
            
            [self updateView];
        }
    } else {
        [self removeLastItemFromStack];
        [self updateView];
    }
}

// remove the last item from stack
- (void)removeLastItemFromStack {
    // NSLog(@"removing object from stack");
    [self.calcModel.operandStack removeLastObject];
}

- (IBAction)clear {
    NSLog(@"CE : clear pressed");
    
    self.calcDisplay.text = @"0";
    self.histDisplay.text = @"";
    
    self.isInTheMiddleOfTypingSomething = NO;
}

- (IBAction)variablePressed:(UIButton *)sender {
    NSString *var = sender.currentTitle;
    NSLog(@"%@", var);
    
    [[self calcModel] pushVariable:var];
}

-(void) updateView {
    NSLog(@"updateView expression:%@", self.calcModel.expression);
    NSLog(@"updateView testVariableValues:%@", self.testVariableValues);
    
    double result = [CalcModel evaluateExpression:self.calcModel.expression usingVariableValues:self.testVariableValues];
    
    NSLog(@"updateView result:%f",result);
    
    NSString *resultString = [NSString stringWithFormat:@"%f", result];
    
    self.calcDisplay.text = resultString;
    
    // Update calc history label
    self.histDisplay.text = [CalcModel descriptionOfExpression:self.calcModel.expression];
    
    self.isInTheMiddleOfTypingSomething = NO;
}

- (NSDictionary *)programVariableValues {
    // Find variables in the current expression as array
    NSLog(@"programVariableValues:");
    
    NSArray *variableArray =
    [[CalcModel variablesInExpression:self.calcModel.expression] allObjects];
    
    NSLog(@"%@", variableArray);
    return [self.testVariableValues dictionaryWithValuesForKeys:variableArray];
}

@end
