//
//  CalcModel.m
//  Calc
//
//  Created by Ruaidhri Hallinan on 30/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "CalcModel.h"
@implementation CalcModel

@synthesize waitingOperand = _waitingOperand;
@synthesize waitingOperation = _waitingOperation;
@synthesize operand = _operand;

- (double) performOperation:(NSString *)operation {
    if([operation isEqual:@"sqrt"]) {
        NSLog(@"sqrt : performingOperation!");
        self.operand = sqrt(self.operand);
    }
    else if ([@"+/-" isEqualToString:operation]) {
        NSLog(@"+/- : performingOperation!");
        self.operand = -self.operand;
    }
    else if ([@"sin" isEqualToString:operation]) {
        NSLog(@"sin : performingOperation!");
    }
    else if ([@"cos" isEqualToString:operation]) {
        NSLog(@"cos : performingOperation!");
    }
    // including tangent button, even though its not asked for
    // sin and cos dont look right without tan :p
    else if ([@"tan" isEqualToString:operation]) {
        NSLog(@"tan : performingOperation!");
    }
    else if ([@"1/x" isEqualToString:operation]) {
        NSLog(@"1/x : performingOperation!");
    }
    else {
        [self performWaitingOperation];
        self.waitingOperation = operation;
        self.waitingOperand = self.operand;
    }
    return self.operand;
}

- (void) performWaitingOperation
{
    if([@"+" isEqualToString:self.waitingOperation]) {
        NSLog(@"+ : performingWaitingOperation!");
        self.operand = self.waitingOperand + self.operand;
    }
    else if ([@"-" isEqualToString:self.waitingOperation]) {
        NSLog(@"- : performingWaitingOperation!");
        self.operand = self.waitingOperand - self.operand;
    }
    else if ([@"*" isEqualToString:self.waitingOperation]) {
        NSLog(@"* : performingWaitingOperation!");
        self.operand = self.waitingOperand * self.operand;
    }
    else if ([@"/" isEqualToString:self.waitingOperation]) {
        NSLog(@"/ : performingWaitingOperation!");
        if(self.operand)self.operand = self.waitingOperand / self.operand;
    }
}
@end
