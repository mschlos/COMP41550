//
//  Exception.m
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 19/04/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "Exception.h"

@implementation Exception

- (id)init {
    self = [super init];
    if (self) {
        _exceptionTypeName = @"";
        _exceptionLocation = nil;
        _distance = 0.0;
        _time = @"";
    }
    return self;
}

- (void)updateException:(Exception *)exception {
    
    _exceptionTypeName = [exception exceptionTypeName];
    _exceptionLocation = [exception exceptionLocation];
    _distance = [exception distance];
    _time= [exception time];
}

@end
