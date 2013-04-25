//
//  DrivingViewController.h
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 28/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"

@interface DrivingViewController : UIViewController <UIAccelerometerDelegate, CLLocationManagerDelegate> {
    
    AppDelegate *appDelegate;
    SystemSoundID carHorn;
    
    IBOutlet UIImageView *exceptionStar;
    IBOutlet UILabel *exceptionCount;
    
    IBOutlet UILabel *xLabel;
    IBOutlet UILabel *yLabel;
    IBOutlet UILabel *zLabel;
    
    IBOutlet UILabel *speedLabel;
    IBOutlet UILabel *distanceLabel;
    
    IBOutlet UILabel *lat;
    IBOutlet UILabel *lon;
    IBOutlet UILabel *alt;
    IBOutlet UILabel *course;
    
    IBOutlet UIProgressView *xBar;
    IBOutlet UIProgressView *yBar;
    IBOutlet UIProgressView *zBar;
    
    IBOutlet UIButton *stopJourney;
    
    UIAccelerometer *accelerometer;
    CLLocationManager *locationManager;

    int MainInt;
    
    BOOL listenToAccel;
    
    BOOL *harshBreakingStarted;
    BOOL *unsafeAccelerationStarted;
    BOOL *unsafeCorneringStarted;
    BOOL *unsafeBumpDetected;
    
    long harshBreakStartTime;
    long harshAccelStartTime;
    long unsafeCorneringStart;
    
    long unsafeBumpTimerReset;
    
    CLLocationDistance distance;
    
    CLLocation *lastLocation;
    CLLocation *currentLocation;
    
}

@property (strong, nonatomic) IBOutlet UIImageView *road;

-(void) countUp;

@end
