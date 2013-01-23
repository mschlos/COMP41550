//
//  PolygonView.h
//  HelloPoly
//
//  Created by Ruaidhri Hallinan on 16/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class PolygonView;

@protocol PolygonViewDelegate <NSObject>
-(int)numberOfSides:(PolygonView *)polygonViewDelegator;
@end

@interface PolygonView : UIView
@property (nonatomic, assign) id <PolygonViewDelegate> delegate;

@end
