//
//  RotatableViewController.m
//  Calc
//
//  Created by Ruaidhri Hallinan on 04/04/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "RotatableViewController.h"

#import "SplitViewBarButtonItemPresenter.h"

@implementation RotatableViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if(![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) detailVC = nil;
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonPresenter]?UIInterfaceOrientationIsPortrait(orientation):NO;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.title;
    [self splitViewBarButtonPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // tell the detail view to take button away
    [self splitViewBarButtonPresenter].splitViewBarButtonItem = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end