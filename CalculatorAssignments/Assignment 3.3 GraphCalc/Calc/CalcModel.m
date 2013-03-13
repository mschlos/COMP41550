//
//  CalcModel.m
//  Calc
//
//  Created by Ruaidhri Hallinan on 30/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "CalcModel.h"

@interface CalcModel()

@property (nonatomic, strong) NSDictionary *variables;

@end

@implementation CalcModel

@synthesize variables =  _variables;
@synthesize operandStack = _operandStack;
@synthesize expression = _expression;

#pragma mark - Getters
- (NSMutableArray *)operandStack {
    if (_operandStack == nil)
        _operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}

- (id) expression {
    return [self.operandStack copy];
}

- (void) pushOperand:(double)operand {
    NSLog(@"pushOperand to operandStack: %f", operand);
    // adding operand to stack
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void) pushVariable:(NSString *)variable {
    NSLog(@"pushVariable to operandStack: %@", variable);
    //adding var to stack
    [self.operandStack addObject:variable];
}

// perform operation
- (double) performOperation:(NSString *)operation {
    NSLog(@"performOperation: %@", operation);
    
    double det = [CalcModel runProgram:self.expression];
    
    NSLog(@"Det: %f", det);
    
    return det;
}

// running program with nil
+ (double)runProgram:(id)program {
    //    NSLog(@"runProgram:%@", program);
    
    return [self evaluateExpression:program usingVariableValues:nil];
}

// new method for part 2 of assignment 3 to set variables as operands
- (void) setVariableAsOperand:(NSString *) varName {
    //Modify your ViewController to add a target-action method which calls setVariableAsOperand:
    //above with the title of the button as the argument.
    //Add at least 3 different variable buttons (e.g. @“x”, @“a” and @“b”) in Interface Builder and hook them up to this method.
    //    NSLog(@"/ : setVariableAsOperand: %@", varName);
    
    [self.expression addObject:[NSString stringWithFormat:@"$%@", varName]];
}

+ (double) evaluateExpression: (id) anExpression
          usingVariableValues: (NSDictionary *) variables {
    
    NSLog(@"evaluateExpression - anExpression:/%@/", anExpression);
    NSLog(@"evaluateExpression - using Variables:/%@/", variables);
    
    if ([anExpression isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *stack= [anExpression mutableCopy];
        //        NSLog(@"evaluateExpression - stack: %@", stack);
        
        for (int i=0; i < [stack count]; i++) {
            id obj = [stack objectAtIndex:i];
            //            NSLog(@"evaluateExpression - obj: %@", obj);
            if ([obj isKindOfClass:[NSString class]] && ![self isAnOperation:obj]) {
                id value = [variables objectForKey:obj];
                //                NSLog(@"evaluateExpression - value: %@", value);
                if (![value isKindOfClass:[NSNumber class]])
                    value = [NSNumber numberWithInt:0]; // if no value substitute zero
                //                    NSLog(@"evaluateExpression - value int: %@", value);
                // replace program variable
                [stack replaceObjectAtIndex:i withObject:value];
            }
        }
        
        return [self performCalculationsOnTheStack:stack];
    }
    else {
        return 0;
    }
}

+ (double)performCalculationsOnTheStack:(NSMutableArray *) stack {
    NSLog(@"performCalculationsOnTheStack");
    
    double result = 0;
    NSString *operation = @"";
    
    for (int i=0; i < [stack count]; i++) {
        id topStack = [stack objectAtIndex:i];
        if ([topStack isKindOfClass:[NSNumber class]]) {
            if(![@"" isEqualToString:operation]) {
                if ([operation isEqualToString:@"/"]){
                    result = result / [topStack doubleValue];
                } else if ([operation isEqualToString:@"+"]) {
                    result = result + [topStack doubleValue];
                } else if ([operation isEqualToString:@"-"]) {
                    result = result - [topStack doubleValue];
                } else if ([operation isEqualToString:@"*"]) {
                    result = result * [topStack doubleValue];
                } else if ([operation isEqualToString:@"sqrt"]) {
                    result = sqrt([topStack doubleValue]);
                } else if ([operation isEqualToString:@"+/-"]) {
                    result = -[topStack doubleValue];
                } else if ([operation isEqualToString:@"sin"]) {
                    result = sin([topStack doubleValue]);
                } else if ([operation isEqualToString:@"cos"]) {
                    result = cos([topStack doubleValue]);
                } else if ([operation isEqualToString:@"π"]) {
                    result = M_PI;
                }
                
            } else {
                result = [topStack doubleValue];;
            }
        } else if ([topStack isKindOfClass:[NSString class]] && [self isAnOperation:topStack] ) {
            operation = topStack;
        } else {
            //replace variable
            if ([topStack isEqualToString:@"a"]) {
                if (result !=0) {
                    result = result + 4;
                } else {
                    result = 4;
                }
            }
        }
    }
    
    return result;
}

+ (NSSet *) variablesInExpression: (id) anExpression {
    NSLog(@"variablesInExpression: %@", anExpression);
    
    NSMutableSet *variableSet = [[NSMutableSet alloc] init];
    
    for (id object in anExpression) {
        
        if ([object isKindOfClass:[NSString class]] && ![self isAnOperation:object]) {
            
            if ([object rangeOfString:@"$"].location != NSNotFound) {
                
                [variableSet addObject:[NSString stringWithFormat:@"%c",
                                        [object characterAtIndex:1]]];
            }
        }
    }
    
    if ([variableSet count] == 0) {
        variableSet = nil;
    }
    return variableSet;
}

+ (NSString *) descriptionOfExpression: (id) anExpression {
    NSLog(@"descriptionOfExpression %@", anExpression);
    
    if (![self isValidExpression:anExpression]) return @"Invalid program!";
    
    NSMutableString *description = [[NSMutableString alloc] init];
    
    for (id object in anExpression) {
        if (([object isKindOfClass:[NSString class]]) && ([object characterAtIndex:0] == '$')) {
            [description appendString:[NSString stringWithFormat:@"%c", [object characterAtIndex:1]]];
        } else {
            [description appendString:[object description]];
        }
    }
    NSLog(@"descriptionOfExpression - description: %@", description);
    return description;
}

// checks operaton is Ok
+ (BOOL)isAnOperation:(NSString *) operation {
    NSLog(@"isAnOperation: %@", operation);
    NSSet *validOperations = [[NSSet alloc] initWithObjects:
                              @"sqrt",@"sin",@"cos",@"1/x",@"π",@"+",@"-",@"*",@"/",
                              nil];
    
    return [validOperations containsObject:operation];
}

// checks if anExpression is an array
+ (BOOL)isValidExpression:(id)anExpression {
    NSLog(@"isValidExpression: %@", anExpression);
    
    return [anExpression isKindOfClass:[NSArray class]];
}

@end