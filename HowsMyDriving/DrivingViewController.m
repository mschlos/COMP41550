//
//  DrivingViewController.m
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 28/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "DrivingViewController.h"

@interface DrivingViewController ()

@end

@implementation DrivingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc {
    [xLabel release];
    [yLabel release];
    [zLabel release];
    
    [xBar release];
    [yBar release];
    [zBar release];
    
    accelerometer.delegate = nil;
    [accelerometer release];
    [super dealloc];
}

- (void)viewDidLoad
{
    // road image animation
    self.road.animationImages = [NSArray arrayWithObjects:
                                  [UIImage imageNamed:@"Road1.png"],
                                  [UIImage imageNamed:@"Road2.png"],
                                  [UIImage imageNamed:@"Road3.png"],
                                  [UIImage imageNamed:@"Road4.png"],
                                  nil];
    self.road.animationDuration = 0.5;
    self.road.transform = CGAffineTransformIdentity;
    [self.road startAnimating];
    self.road.userInteractionEnabled = YES;

    
    accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.updateInterval = 0.1;
    
    //making this class the delegate...?
    accelerometer.delegate = self;

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    // http://answers.oreilly.com/topic/845-how-to-build-and-test-an-iphone-app-that-uses-the-accelerometer/

    xLabel.text = [NSString stringWithFormat:@"%f", acceleration.x];
    xBar.progress = ABS(acceleration.x);
    // drivingExceptions addObj
    yLabel.text = [NSString stringWithFormat:@"%f", acceleration.y];
    yBar.progress = ABS(acceleration.y);
    
    zLabel.text = [NSString stringWithFormat:@"%f", acceleration.z];
    zBar.progress = ABS(acceleration.z);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
