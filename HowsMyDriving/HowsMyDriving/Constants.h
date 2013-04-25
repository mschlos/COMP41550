//
//  Constants.h
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 25/04/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

extern double const NORTHWEST_DEGREES;
extern double const WEST_DEGREES;
extern double const SOUTHWEST_DEGREES;
extern double const SOUTH_DEGREES;
extern double const SOUTHEAST_DEGREES;
extern double const EAST_DEGREES;
extern double const NORTHEAST_DEGREES;
extern double const NORTH_DEGREES;

// Max number of seconds old a location update can be and still be recorded
extern double const MAX_LOCATION_AGE;

// Max distance in meters to accept for horizontal accuracy
extern double const MAX_HORIZONTAL_ACCURACY;

@end
