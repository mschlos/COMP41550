//
//  ViewController.h
//  Calc
//
//  Created by Ruaidhri Hallinan on 30/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalcModel.h"

@interface ViewController : UIViewController
@property (nonatomic, strong) IBOutlet CalcModel *calcModel;
@property (nonatomic,weak) IBOutlet UILabel *calcDisplay;
@property (nonatomic) BOOL isInTheMiddleOfTypingSomething;

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)pointPressed:(UIButton *)sender;
- (IBAction)backspacePressed:(UIButton *)sender;
- (IBAction)variablePressed:(UIButton *)sender;
- (IBAction)solvePressed:(UIButton *)sender;

@end
