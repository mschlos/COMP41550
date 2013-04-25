//
//  Constants.m
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 25/04/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "Constants.h"

@implementation Constants

double const NORTH_DEGREES = 337.5;
double const NORTHWEST_DEGREES = 292.5;
double const WEST_DEGREES = 247.5;
double const SOUTHWEST_DEGREES = 202.5;
double const SOUTH_DEGREES = 157.5;
double const SOUTHEAST_DEGREES = 112.5;
double const EAST_DEGREES = 67.5;
double const NORTHEAST_DEGREES = 22.5;

// Max number of seconds old a location update can be and still be recorded
double const MAX_LOCATION_AGE = 1;

// Max distance in meters to accept for horizontal accuracy
double const MAX_HORIZONTAL_ACCURACY = 10.0;

@end
