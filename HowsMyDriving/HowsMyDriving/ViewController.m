//
//  ViewController.m
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 28/01/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSURL *carStartURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tirespin" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) carStartURL, & carStart);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startJourney:(id)sender {
    AudioServicesPlaySystemSound(carStart);
}
@end
