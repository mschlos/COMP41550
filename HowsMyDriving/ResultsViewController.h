//
//  ResultsViewController.h
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 28/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Exception.h"

@interface ResultsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    AppDelegate *appDelegate;
    
    IBOutlet UILabel *exceptionLabel;
 
    IBOutlet UIPickerView *exceptionPicker;

}

@property (retain, nonatomic) IBOutlet UIPickerView *exceptionPicker;

@end
