//
//  ResultsViewController.m
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 28/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "ResultsViewController.h"

@interface ResultsViewController ()
    
@end

@implementation ResultsViewController 

@synthesize exceptionPicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    //and then access the variable by appDelegate.variable
    
    [super viewDidLoad];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
     return 1;
} 

- (NSInteger) pickerView: (UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger)component {
    return [appDelegate.drivingExceptions count];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"%ld", (long)row);
    Exception *_exception = (Exception *)[appDelegate.drivingExceptions objectAtIndex:row];  // explicit cast
    return _exception.exceptionTypeName;
}

- (void) pickerView:(UIPickerView *) pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%ld", (long)row);
    Exception *_exception = (Exception *)[appDelegate.drivingExceptions objectAtIndex:row];  // explicit cast
    
    NSString *displayText = _exception.exceptionTypeName;
    displayText = [displayText stringByAppendingString:@" at "];
    displayText = [displayText stringByAppendingString:_exception.time];
    displayText = [displayText stringByAppendingString:@" travelling at "];
    displayText = [displayText stringByAppendingString:[NSString stringWithFormat:@"%f KM/hr", _exception.exceptionLocation.speed]];
    
    exceptionLabel.text = displayText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [appDelegate release];
    [exceptionLabel release];
    [super dealloc];
}
@end
