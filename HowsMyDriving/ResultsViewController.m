//
//  ResultsViewController.m
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 28/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "ResultsViewController.h"

#define NORTH_DEGREES 337.5
#define NORTHWEST_DEGREES 292.5
#define WEST_DEGREES 247.5
#define SOUTHWEST_DEGREES 202.5
#define SOUTH_DEGREES 157.5
#define SOUTHEAST_DEGREES 112.5
#define EAST_DEGREES 67.5
#define NORTHEAST_DEGREES 22.5

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
    NSString *pickerText = _exception.exceptionTypeName;
        pickerText = [pickerText stringByAppendingString:@" at "];
        pickerText = [pickerText stringByAppendingString:_exception.time];
    
    return pickerText;
}

- (void) pickerView:(UIPickerView *) pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%ld", (long)row);
    Exception *_exception = (Exception *)[appDelegate.drivingExceptions objectAtIndex:row];  // explicit cast
    
    NSString *displayText = _exception.exceptionTypeName;
    displayText = [displayText stringByAppendingString:@"\n"];
    displayText = [displayText stringByAppendingString:@"Detected at "];
    displayText = [displayText stringByAppendingString:_exception.time];
    displayText = [displayText stringByAppendingString:@"\n"];
    
    displayText = [displayText stringByAppendingString:@"Travelling at "];
    
    
    //TODO BUG HERE 
    
    NSLog(@"%f", _exception.exceptionLocation.speed);
    
    if(_exception.exceptionLocation.speed == 0) {
        displayText = [displayText stringByAppendingString:[NSString stringWithFormat:@"%.f km/h", _exception.exceptionLocation.speed]];
    } else {
        displayText = [displayText stringByAppendingString:[NSString stringWithFormat:@"%f km/h", _exception.exceptionLocation.speed]];
    }
    
    displayText = [displayText stringByAppendingString:@"\n"];
    
    displayText = [displayText stringByAppendingString:@"Heading "];
    displayText = [displayText stringByAppendingString:[self getCourseText:_exception.exceptionLocation.course]];
    displayText = [displayText stringByAppendingString:@"\n"];
    
    displayText = [displayText stringByAppendingString:@"At location: "];
    displayText = [displayText stringByAppendingString:[NSString stringWithFormat:@"%g", _exception.exceptionLocation.coordinate.latitude]];
    displayText = [displayText stringByAppendingString:@", "];
    displayText = [displayText stringByAppendingString:[NSString stringWithFormat:@"%g", _exception.exceptionLocation.coordinate.longitude]];
    displayText = [displayText stringByAppendingString:@"\n"];
    
    exceptionLabel.text = displayText;
}

- (NSString *) getCourseText:(double) heading {
    
    if(heading > NORTH_DEGREES) {
        return @"North";
    } else if(heading > NORTHWEST_DEGREES) {
        return @"North West";
    } else if(heading > WEST_DEGREES) {
        return @"West";
    } else if(heading > SOUTHWEST_DEGREES) {
        return @"South West";
    } else if(heading > SOUTH_DEGREES) {
        return @"South";
    } else if(heading > SOUTHEAST_DEGREES) {
        return @"South East";
    } else if(heading > EAST_DEGREES) {
        return @"East";
    } else if(heading > NORTHEAST_DEGREES) {
        return @"North East";
    } else {
        return @"North";
    }
    return @"";
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
