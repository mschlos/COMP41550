//
//  ResultsViewController.h
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 28/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "resultsPopover.h"

@interface ResultsViewController : UIViewController <UIPopoverControllerDelegate> {
    
    
    IBOutlet UIViewController *popoverView;
    
    IBOutlet UIButton *showResults;
    IBOutlet UIButton *startAgain;
    IBOutlet UIButton *shareResults;

    IBOutlet UILabel *drivingRank;
}

@end
