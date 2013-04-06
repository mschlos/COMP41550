//
//  GraphViewController.h
//  Calc
//
//  Created by Ruaidhri Hallinan on 12/03/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "CalcModel.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface GraphViewController : UIViewController <SplitViewBarButtonItemPresenter> 

@property (nonatomic, strong) CalcModel *expression;

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;

@end
