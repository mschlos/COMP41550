//
//  DrivingViewController.m
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 28/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "DrivingViewController.h"
#import "AppDelegate.h"

// Max number of seconds old a location update can be and still be recorded
#define MAX_LOCATION_AGE 1

// Max distance in meters to accept for horizontal accuracy
#define MAX_HORIZONTAL_ACCURACY 10.0

#define NORTH_DEGREES 337.5
#define NORTHWEST_DEGREES 292.5
#define WEST_DEGREES 247.5
#define SOUTHWEST_DEGREES 202.5
#define SOUTH_DEGREES 157.5
#define SOUTHEAST_DEGREES 112.5
#define EAST_DEGREES 67.5
#define NORTHEAST_DEGREES 22.5

@interface DrivingViewController ()

@end

@implementation DrivingViewController

- (void) countUp {
    MainInt += 1;
    //seconds.text = [NSString stringWithFormat:@"%i", MainInt];
}

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
    
    [speedLabel release];
    [distanceLabel release];
    
    [lat release];
    [lon release];
    [alt release];
    [course release];
    
    [xBar release];
    [yBar release];
    [zBar release];
    
    [stopJourney release];
    
    [accelerometer release];
    [locationManager release];
    
    [lastLocation release];
    [currentLocation release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSURL *carHornURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"horngoby" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((CFURLRef) carHornURL, & carHorn);

    //NB Clean Up Other Vars here
    
    harshBreakingStarted = false;
    unsafeAccelerationStarted = false;
    
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
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    [locationManager startMonitoringSignificantLocationChanges];
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.updateInterval = 0.1;
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
    
    [locationManager stopUpdatingLocation];
    [locationManager stopMonitoringSignificantLocationChanges];
}

- (void) mockSomeData {
    
    NSLog(@"No exceptions logged so mocking results in mockSomeData");
    
    Exception *mockException = [[Exception alloc] init];
    mockException.time = [[NSString alloc] initWithString:[self getDateString]];
    mockException.exceptionTypeName = @"Harsh Breaking";
    mockException.distance = 10.0;
    mockException.exceptionLocation = currentLocation;
    [appDelegate.drivingExceptions addObject:mockException];
    
    mockException = [[Exception alloc] init];
    mockException.time = [[NSString alloc] initWithString:[self getDateString]];
    mockException.exceptionTypeName = @"Unsafe Acceleration";
    mockException.distance = 20.0;
    mockException.exceptionLocation = currentLocation;
    [appDelegate.drivingExceptions addObject:mockException];
    
    mockException = [[Exception alloc] init];
    mockException.time = [[NSString alloc] initWithString:[self getDateString]];
    mockException.exceptionTypeName = @"Unsafe Cornering";
    mockException.distance = 40.0;
    mockException.exceptionLocation = currentLocation;
    [appDelegate.drivingExceptions addObject:mockException];
    
    mockException = [[Exception alloc] init];
    mockException.time = [[NSString alloc] initWithString:[self getDateString]];
    mockException.exceptionTypeName = @"Unsafe Bump";
    mockException.distance = 50.0;
    mockException.exceptionLocation = currentLocation;
    [appDelegate.drivingExceptions addObject:mockException];
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    xLabel.text = [NSString stringWithFormat:@"%f", acceleration.x];
    xBar.progress = ABS(acceleration.x);
    
    yLabel.text = [NSString stringWithFormat:@"%f", acceleration.y];
    yBar.progress = ABS(acceleration.y);
    
    zLabel.text = [NSString stringWithFormat:@"%f", acceleration.z];
    zBar.progress = ABS(acceleration.z);
    
    //For harsh breaking:
    //If Y Axis is above 4 for any longer than 5 seconds then that is harsh breaking
    if (yBar.progress >= 4) {
        [self startHarshBreakingTimer];
    }
    else {
        [self stopHarshBreakingTimer];
    }
    
    //For unsafe accelleration
    //If Y Axis is -1 or below for longer than 10 seconds then that is unsafe acceleration
    if (yBar.progress <= -1) {
        [self startUnsafeAccelerationTimer];
    }
    else {
        [self stopUnsafeAccelerationTimer];
    }
    
    //For fast cornering, detect bottom peak of -2 for X axis
    if (xBar.progress <= -2) {
        [self unsafeCorneringDetected];
    }
    
    //For going over a bump/pothole too fast check out values and jolts in for the Z axis
    if (zBar.progress > 1) {
        [self unsafeBumpDetected];
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
        
        if(harshBreakingStopTime - harshBreakStartTime > 5)
        {
            NSLog(@"HARSH BREAKING DETECTED");
            AudioServicesPlaySystemSound(carHorn);
            
            //Setting time of event
            appDelegate.exception.time = [[NSString alloc] initWithString:[self getDateString]];
            
            //Setting name of event
            appDelegate.exception.exceptionTypeName = [[NSString alloc] initWithString:@"Harsh Breaking"];
            
            //Add location and exception info to array
            appDelegate.exception.exceptionLocation = currentLocation;
           
            //Add to NSMutableArray
            [appDelegate.drivingExceptions addObject:appDelegate.exception];
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
        
        if(harshAccelStopTime - harshAccelStartTime >= 10) {
            NSLog(@"UNSAFE ACCELERATION DETECTED");
            
            AudioServicesPlaySystemSound(carHorn);
            
            //Setting time of event
            appDelegate.exception.time = [[NSString alloc] initWithString:[self getDateString]];
            
            //Setting the name of the exception
            appDelegate.exception.exceptionTypeName = [[NSString alloc] initWithString:@"Unsafe Acceleration"];
            
            //Add location and exception info to array
            appDelegate.exception.exceptionLocation = currentLocation;
            
            //Add to NSMutableArray
            [appDelegate.drivingExceptions addObject:appDelegate.exception];
        }
        unsafeAccelerationStarted = false;
    }
}

- (NSString *)getDateString {
    
    //Setting the time
    NSDate *date = [[NSDate alloc] init];
    NSLog(@"%@", date);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSLog(@"%@", dateString);
    
    return dateString;
}

- (void) unsafeCorneringDetected {
    //log unsafe cornering exception
    NSLog(@"UNSAFE CORNERING DETECTED");
    
    AudioServicesPlaySystemSound(carHorn);
    
    //Setting time of event
    appDelegate.exception.time = [[NSString alloc] initWithString:[self getDateString]];
    
    //Setting name of event
    appDelegate.exception.exceptionTypeName = [[NSString alloc] initWithString:@"Unsafe Cornering"];
    
    //Setting location of event
    appDelegate.exception.exceptionLocation = currentLocation;
    
    //Add to NSMutableArray
    [appDelegate.drivingExceptions addObject:appDelegate.exception];
}


- (void) unsafeBumpDetected {
    //log unsafe bump exception
    NSLog(@"UNSAFE BUMP DETECTED");
    
    AudioServicesPlaySystemSound(carHorn);
    
    //Setting time of event
    appDelegate.exception.time = [[NSString alloc] initWithString:[self getDateString]];
    
    //Setting name of event
    appDelegate.exception.exceptionTypeName = [[NSString alloc] initWithString:@"Unsafe Bump"];
    
    //Setting location of event
    appDelegate.exception.exceptionLocation = currentLocation;
    
    //Add to NSMutableArray
    [appDelegate.drivingExceptions addObject:appDelegate.exception];
}


- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //[manager stopUpdatingLocation];
    
    currentLocation = [locations objectAtIndex:0];
    
    NSLog(@"Last Location = %@", lastLocation);
    NSLog(@"Current Location = %@", currentLocation);
    
    //NSLog(@"Latitude: %f", location.coordinate.latitude );
    //NSLog(@"Longitude: %f", location.coordinate.longitude );
    //NSLog(@"Altitude: %f", location.altitude );
    //NSLog(@"Course: %f", location.course );
    
    lat.text = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    lon.text = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    alt.text = [NSString stringWithFormat:@"%f", currentLocation.altitude];
    
    if(currentLocation.course > NORTH_DEGREES) {
        course.text = @"North";
    } else if(currentLocation.course > NORTHWEST_DEGREES) {
        course.text = @"North West";
    } else if(currentLocation.course > WEST_DEGREES) {
        course.text = @"West";
    } else if(currentLocation.course > SOUTHWEST_DEGREES) {
        course.text = @"South West";
    } else if(currentLocation.course > SOUTH_DEGREES) {
        course.text = @"South";
    } else if(currentLocation.course > SOUTHEAST_DEGREES) {
        course.text = @"South East";
    } else if(currentLocation.course > EAST_DEGREES) {
        course.text = @"East";
    } else if(currentLocation.course > NORTHEAST_DEGREES) {
        course.text = @"North East";
    } else {
        course.text = @"North";
    }
    
  	//NSLog(@"%f%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
    if ([self isLocationValid:currentLocation]) {

        // Calculate distance travelled since last location
        double currentDistance = [lastLocation distanceFromLocation:currentLocation];
        
        // Update the total distance 
        distance += currentDistance;
        
        //calculate distance in KM from distance (meters)
        int KMs = (distance / 1000);
        
        if(KMs < 0) {
            distanceLabel.text = @"0 KM/hr";
        } else {
            distanceLabel.text = [NSString stringWithFormat:@"%d", KMs];
            appDelegate.exception.distance = KMs;
        }
        
        // get Speed from current location
        
        if(currentLocation.speed < 0) {
            speedLabel.text = @"0 KM/hr";
        } else {
            speedLabel.text = [NSString stringWithFormat:@"%f KM/hr", lastLocation.speed];
        }
        
    }
    
    // Update the last location with the current location
    [lastLocation release];
    lastLocation = [currentLocation retain];
}

- (BOOL)isLocationValid:(CLLocation *)location {
    
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
