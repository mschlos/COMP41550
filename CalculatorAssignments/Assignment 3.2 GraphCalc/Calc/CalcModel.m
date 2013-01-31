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
    if([operation isEqual:@"sqrt"])
        self.operand = sqrt(self.operand);
    else if ([@"+/-" isEqualToString:operation])
        self.operand = -self.operand;
    else {
        [self performWaitingOperation];
        self.waitingOperation = operation;
        self.waitingOperand = self.operand;
    }
    return self.operand;
}

- (void) performWaitingOperation
{
    if([@"+" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand + self.operand;
    else if ([@"-" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand - self.operand;
    else if ([@"*" isEqualToString:self.waitingOperation])
        self.operand = self.waitingOperand * self.operand;
    else if ([@"/" isEqualToString:self.waitingOperation])
        if(self.operand)self.operand = self.waitingOperand / self.operand;
}
@end
