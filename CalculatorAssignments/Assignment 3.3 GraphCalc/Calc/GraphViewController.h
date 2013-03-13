//
//  GraphViewController.h
//  Calc
//
//  Created by Ruaidhri Hallinan on 12/03/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic, strong) id program;

- (void) setProgram:(id)program;

@end
