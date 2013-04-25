//
//  HelperClass.m
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 25/04/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "HelperClass.h"
#import "Constants.h"

@implementation HelperClass

+ (NSString *)getDateString {
    
    //Setting the time
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSLog(@"getDateString: %@", dateString);
    
    return dateString;
}

+ (NSString *) getCourseText:(double) heading {
    
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


@end
