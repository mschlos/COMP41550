//
//  AppDelegate.h
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 28/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exception.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSMutableArray *drivingExceptions;
    Exception *exception;
}
@property(nonatomic, retain) NSMutableArray *drivingExceptions;
@property(nonatomic, retain) Exception *exception;

@property (strong, nonatomic) UIWindow *window;
    
@end
