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

@implementation ResultsViewController{
   
}


- (IBAction) showResultsPop:(id)sender {
    UIView *anchor = sender;
    UIViewController *viewControllerForPopover =
    [self.storyboard instantiateViewControllerWithIdentifier:@"ShowResultsViewController"];
    
    // UIPopoverController DOES NOT WORK ON IPHONE!!!!!!!
    // USE A DIALOG INSTEAD
    
//    popover = [[UIPopoverController alloc]
//               initWithContentViewController:viewControllerForPopover];
//    [popover presentPopoverFromRect:anchor.frame
//                             inView:anchor.superview
//           permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    UIStoryboardPopoverSegue *popoverSegue;
//    popoverSegue=(UIStoryboardPopoverSegue *)segue;
//    
//    UIPopoverController *popoverController;
//    popoverController=popoverSegue.popoverController;
//    popoverController.delegate=self;
//    
//    ShowResultsViewController *showResultsVC;
//    showResultsVC=(ShowResultsViewController *)popoverController.contentViewController;
//    //editorVC.emailField.text = self.emailLabel.text;
//    
////    UIPopoverController *popoverController;
////    popoverController=popoverSegue.popoverController;
////    popoverController.delegate=self;
//    
////    ShowResultsViewController *editorVC ;
////    editorVC=(ShowResultsViewController *) popoverController.contentViewController;
//    
//}

- (void)popoverControllerDidDismissPopover: (UIPopoverController *)popoverController {

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
