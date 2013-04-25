//
//  DrivingViewController.m
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 28/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "DrivingViewController.h"
#import "AppDelegate.h"
#import "HelperClass.h"
#import "Constants.h"

@interface DrivingViewController ()

@end

@implementation DrivingViewController

- (void) countUp {
    MainInt += 1;
}

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
    
    exceptionStar.hidden = YES;
    
    [appDelegate.drivingExceptions removeAllObjects];
    
    // loading car horn sound
    NSURL *carHornURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"horngoby" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) carHornURL, & carHorn);

    harshBreakingStarted = false;
    unsafeAccelerationStarted = false;
    unsafeCorneringStarted = false;
    unsafeBumpDetected = false;
    
    listenToAccel = true;
    
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

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [locationManager startUpdatingLocation];
    
    accelerometer = [UIAccelerometer sharedAccelerometer];
    
    // location updates every half second
    accelerometer.updateInterval = 0.5;
    distance = 0.0;
    
    //making this class the delegate...?
    accelerometer.delegate = self;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if([appDelegate.drivingExceptions count] == 0) {
        [self mockSomeData];
    }
    
    listenToAccel = false;
    
    [locationManager stopUpdatingLocation];
}

- (void) mockSomeData {
    
    NSLog(@"No exceptions logged so mocking results for picker");
    
    [self addException:@"* Breaking * "];
    [self addException:@"* Acceleration *"];
    [self addException:@"* Cornering *"];
    [self addException:@"* Bump *"];

}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    if(listenToAccel) {
        xLabel.text = [NSString stringWithFormat:@"%f", acceleration.x];
        xBar.progress = ABS(acceleration.x);
        
        yLabel.text = [NSString stringWithFormat:@"%f", acceleration.y];
        yBar.progress = ABS(acceleration.y);
        
        zLabel.text = [NSString stringWithFormat:@"%f", acceleration.z];
        zBar.progress = ABS(acceleration.z);
        
        NSLog(@"YBar: %f", yBar.progress);
        NSLog(@"XBar: %f", xBar.progress);
        NSLog(@"ZBar: %f", zBar.progress);
        
        //For harsh breaking:
        //If Z Axis is below 0.5 for any longer than 3 seconds then that is harsh breaking
        if (zBar.progress >= 0.5) {
            [self startHarshBreakingTimer];
        }
        else {
            [self stopHarshBreakingTimer];
        }
        
        //For unsafe accelleration
        //If Y Axis is above 0.95 for longer than 5 seconds then that is unsafe acceleration
        if (yBar.progress >= 0.95) {
            [self startUnsafeAccelerationTimer];
        }
        else {
            [self stopUnsafeAccelerationTimer];
        }
        
        //For fast cornering, detect peak of 0.25 for X axis for 5 seconds
        if (xBar.progress >= 0.25) {
            [self startUnsafeCorneringTimer];
        } else {
            [self stopUnsafeCorneringTimer];
        }
        
        //For going over a bump/pothole too fast check out values and jolts in for the Z axis
        if (zBar.progress >= 0.75) {
            [self unsafeBumpDetected];
        }
    }
}

- (void) startHarshBreakingTimer {
    
    if(!harshBreakingStarted) {
                                //Time in seconds
        harshBreakStartTime = [[NSDate date] timeIntervalSince1970];
        NSLog(@"Time startHarshBreakingTimer =%ld", harshBreakStartTime);
        harshBreakingStarted = true;
    }
}

- (void) stopHarshBreakingTimer {
       
    if(harshBreakingStarted) {
                                        //Time in seconds
        long harshBreakingStopTime = [[NSDate date] timeIntervalSince1970];
        NSLog(@"Time stopHarshBreakingTimer =%ld", harshBreakingStopTime);
        
        if(harshBreakingStopTime - harshBreakStartTime > 3)
        {
            NSLog(@"HARSH BREAKING DETECTED");
            
            [self addException:@"Breaking"];
        }
        harshBreakingStarted = false;
    }
}

- (void) startUnsafeAccelerationTimer {
    
    if(!unsafeAccelerationStarted) {
                                //Time in seconds
        harshAccelStartTime = [[NSDate date] timeIntervalSince1970];
        NSLog(@"Time startUnsafeAccelerationTimer =%ld", harshAccelStartTime);
        unsafeAccelerationStarted = true;
    }
}

- (void) stopUnsafeAccelerationTimer {
    
    if(unsafeAccelerationStarted) {
                                    //Time in seconds
        long harshAccelStopTime = [[NSDate date] timeIntervalSince1970];
        NSLog(@"Time stopUnsafeAccelerationTimer =%ld", harshAccelStopTime);
        
        if(harshAccelStopTime - harshAccelStartTime >= 5) {
            NSLog(@"UNSAFE ACCELERATION DETECTED");
            
            [self addException:@"Acceleration"];
            
        }
        unsafeAccelerationStarted = false;
    }
}

- (void) startUnsafeCorneringTimer {
    
    if(!unsafeCorneringStarted) {
                                //Time in seconds
        unsafeCorneringStart = [[NSDate date] timeIntervalSince1970];
        NSLog(@"Time unsafeCorneringStart =%ld", unsafeCorneringStart);
        unsafeCorneringStarted = true;
    }
}

- (void) stopUnsafeCorneringTimer {
    
    if(unsafeCorneringStarted) {
                                    //Time in seconds
        long unsafeCorneringStopTime = [[NSDate date] timeIntervalSince1970];
        NSLog(@"Time unsafeCorneringStopTime =%ld", unsafeCorneringStopTime);
        
        if( unsafeCorneringStopTime - unsafeCorneringStart >= 5) {
            //log unsafe cornering exception
            NSLog(@"UNSAFE CORNERING DETECTED");
            
            [self addException:@"Cornering"];
            
        }
        unsafeCorneringStarted = false;
    }
}

- (void) startUnsafeBumpTimerReset {
    if(!unsafeBumpDetected) {
        unsafeBumpTimerReset = [[NSDate date] timeIntervalSince1970];
        unsafeBumpDetected = true;
    }
}

- (void) unsafeBumpDetected {
                            //Time in seconds
    long unsafeLapseTime = [[NSDate date] timeIntervalSince1970];
    
    NSLog(@"unsafeLapseTime: %ld", unsafeLapseTime);
    
    if(!unsafeBumpDetected) {
        [self startUnsafeBumpTimerReset];
        
            //log unsafe bump exception
        NSLog(@"UNSAFE BUMP DETECTED");
        [self addException:@"Bump"];
    }
    
    //Waiting 5 seconds before detecting another bump
    if(unsafeLapseTime - unsafeBumpTimerReset >= 5) {
        unsafeBumpDetected = false;
    }
}

-(void) addException:(NSString *)exceptionName
{
    AudioServicesPlaySystemSound(carHorn);
    
    exceptionStar.hidden = false;
    double count = [appDelegate.drivingExceptions count] + 1;
    exceptionCount.text = [NSString stringWithFormat:@"%.f", count];
    
    Exception *newException = [[Exception alloc] init];
        newException.time = [HelperClass getDateString];
        newException.exceptionTypeName = exceptionName;
        newException.distance = distance;
        newException.exceptionLocation = currentLocation;
    
    NSLog(@"ADDING EXCEPTION TO ARRAY = %@", exceptionName);
    [appDelegate.drivingExceptions addObject:newException];
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    NSLog(@"Pausing location Updates? Not on my watch!");
    [locationManager startUpdatingLocation];
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"Resuming location Updates");
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    currentLocation = [locations lastObject];
    
    NSLog(@"Latitude: %f", currentLocation.coordinate.latitude );
    NSLog(@"Longitude: %f", currentLocation.coordinate.longitude );
    NSLog(@"Altitude: %f", currentLocation.altitude );
    NSLog(@"Course: %f", currentLocation.course );
    NSLog(@"Speed: %f", lastLocation.speed);
    
    lat.text = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    lon.text = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    alt.text = [NSString stringWithFormat:@"%f", currentLocation.altitude];
    course.text = [HelperClass getCourseText:currentLocation.course];
    
    if ([self isLocationValid:currentLocation]) {

        // Calculate distance travelled since last location
        double currentDistance = [lastLocation distanceFromLocation:currentLocation];
        
        // Update the total distance 
        distance += currentDistance;
    
        //calculate distance in KM from distance (meters)
        double KMs = (distance / 1000);
        
        if(KMs < 0) {
            distanceLabel.text = @"0 KM";
        } else {
            distanceLabel.text = [NSString stringWithFormat:@"%.2lf KM" , KMs];
            appDelegate.exception.distance = KMs;
        }
        
        // get Speed from current location
        double speed = currentLocation.speed;
        
        if(speed < 0) {
            speedLabel.text = @"0 km/h";
        } else {
            speedLabel.text = [NSString stringWithFormat:@"%.2lf km/r", lastLocation.speed];
        }
        
    }
    
    lastLocation = currentLocation;
}

- (BOOL)isLocationValid:(CLLocation *)location {
    
    NSLog(@"horizontalAccuracy %f: ",location.horizontalAccuracy);
    NSLog(@"timeStamp %f: ",ABS([location.timestamp timeIntervalSinceNow]));
    
    // Check if the location update is current
    if (ABS([location.timestamp timeIntervalSinceNow]) > MAX_LOCATION_AGE) {
        return NO;
    }
    
    // Check of the location accuracy is good enough
    if (location.horizontalAccuracy > MAX_HORIZONTAL_ACCURACY) {
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
