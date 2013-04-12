//
//  DrivingViewController.h
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 28/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrivingViewController : UIViewController <UIAccelerometerDelegate> {
    
    IBOutlet UILabel *xLabel;
    IBOutlet UILabel *yLabel;
    IBOutlet UILabel *zLabel;
    
    IBOutlet UIProgressView *xBar;
    IBOutlet UIProgressView *yBar;
    IBOutlet UIProgressView *zBar;
    
    IBOutlet UIButton *stopJourney;
    
    UIAccelerometer *accelerometer;
}

@property (strong, nonatomic) IBOutlet UIImageView *road;

@end
