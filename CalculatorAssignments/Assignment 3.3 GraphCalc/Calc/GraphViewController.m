//
//  GraphViewController.m
//  Calc
//
//  Created by Ruaidhri Hallinan on 12/03/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "GraphViewController.h"
#import "CalcModel.h"
#import "GraphView.h"

@interface GraphViewController ()

@end

@implementation GraphViewController
@synthesize program = _program;

- (void) setProgram:(id)program {
    
    _program = program;
    
    // Set the title of the controller
    self.title = [NSString stringWithFormat:@"y = %@",
                  [CalcModel descriptionOfExpression:self.program]];
}


@end