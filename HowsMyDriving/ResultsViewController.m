//
//  ResultsViewController.m
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 28/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "ResultsViewController.h"
#import "ShowResultsViewController.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController

- (IBAction) showResults {
    NSLog(@"HOWYA");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIStoryboardPopoverSegue *popoverSegue;
    popoverSegue=(UIStoryboardPopoverSegue *)segue;
    
//    UIPopoverController *popoverController;
//    popoverController=popoverSegue.popoverController;
//    popoverController.delegate=self;
    
//    ShowResultsViewController *editorVC ;
//    editorVC=(ShowResultsViewController *) popoverController.contentViewController;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [drivingRank release];
    [super dealloc];
}
@end
