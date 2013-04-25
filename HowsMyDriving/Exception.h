//
//  Exception.h
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 19/04/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Exception : NSObject

@property (nonatomic, retain) NSString *exceptionTypeName; //Exception Type Name eg Harsh Breaking
@property (nonatomic, retain) CLLocation *exceptionLocation; //lat, lon, alt, course, speed
@property (nonatomic, assign) double distance; //distance
@property (nonatomic, retain) NSString *time; //time

@end
