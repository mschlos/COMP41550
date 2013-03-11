//
//  CalcModel.h
//  Calc
//
//  Created by Ruaidhri Hallinan on 30/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalcModel : NSObject

@property (readonly,strong) id expression;
@property (nonatomic, strong) NSMutableArray *operandStack;

- (void) pushOperand:(double)operand;
- (void) pushVariable:(NSString *)variable;

- (double) performOperation:(NSString *)operation;
- (void) setVariableAsOperand:(NSString *)variableName;

+ (double) evaluateExpression:(id)anExpression usingVariableValues:(NSDictionary *)variables;

+ (NSSet *) variablesInExpression:(id)anExpression;
+ (NSString *) descriptionOfExpression:(id)anExpression;

@end
