//
//  RankViewController.m
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 22/04/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import "RankViewController.h"

@interface RankViewController () {
    NSString *socialText;
}
@end

@implementation RankViewController

- (IBAction)postOnFacebookButtonTapped:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        NSString *socialSentence;
            socialSentence = @"I just got ranked ";
            socialSentence = [socialSentence stringByAppendingString:[NSString stringWithFormat:@"%@", socialText]];
            socialSentence = [socialSentence stringByAppendingString:[NSString stringWithFormat:@"%@", @" by How's My Driving App for iPhone! #HowsMyDriving"]];
        
        SLComposeViewController *fbComposer = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeFacebook];
        //set the initial text message
        [fbComposer setInitialText:socialSentence];
        
        //add url
        if ([fbComposer addURL:[NSURL URLWithString:@"www.csi.ucd.ie"]]) {
            NSLog(@"UCD url added");
        }
        
        // you can remove all added URLs as follows
        //[fbComposer removeAllURLs];
        
        //present the composer to the user
        [self presentViewController:fbComposer animated:YES completion:nil];
        
    }else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Facebook Error"
                                  message:@"No facebook service on your device or\n cannot connect to internet."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil];
        [alertView show];
    }
}

- (IBAction)tweetButtonTapped:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        NSString *socialSentence;
        socialSentence = @"I just got ranked ";
        socialSentence = [socialSentence stringByAppendingString:[NSString stringWithFormat:@"%@", socialText]];
        socialSentence = [socialSentence stringByAppendingString:[NSString stringWithFormat:@"%@", @" by How's My Driving App for iPhone! #HowsMyDriving"]];
        
        SLComposeViewController *twitterComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        //initial text
        [twitterComposer setInitialText:socialSentence];
        
        //composer
        [self presentViewController:twitterComposer animated:YES completion:nil];
        
        //completion handler
        twitterComposer.completionHandler = ^(SLComposeViewControllerResult result) {
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"User cancelled composing the tweet");
            }
            
            if (result == SLComposeViewControllerResultDone) {
                NSLog(@"User has finished composing the tweet and sent");
            }
        };
        
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"twitter Error"
                                  message:@"No twitter service on your device or\n cannot connect to internet."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil];
        [alertView show];
    }
    
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
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self updateLabels];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)updateLabels
{
    
    double numOfExceptions = [appDelegate.drivingExceptions count];
    double distance = appDelegate.exception.distance;
    
    NSString *resultLabel;
    NSString *resultRank;
    
    resultLabel = @"You committed ";
    resultLabel = [resultLabel stringByAppendingString:[NSString stringWithFormat:@"%g", numOfExceptions]];
    resultLabel = [resultLabel stringByAppendingString:@" exceptions over "];
    resultLabel = [resultLabel stringByAppendingString:[NSString stringWithFormat:@"%g", distance]];
    resultLabel = [resultLabel stringByAppendingString:@" "];
    resultLabel = [resultLabel stringByAppendingString:@"KM! "];
    resultLabel = [resultLabel stringByAppendingString:@"That ranks you: "];
    
    if(numOfExceptions <= 1) {
        resultRank = @"Miss Daisy!";  
    }
    else if(numOfExceptions <= 2) {
        resultRank = @"Taxi Driver!";
    }
    else if(numOfExceptions <= 3) {
        resultRank = @"Herbie!";
    }
    else if(numOfExceptions <= 4) {
        resultRank = @"Ricky Bobby!";
    }
    else if(numOfExceptions <= 5) {
        resultRank = @"Lightening McQueen!";
    }
    else if(numOfExceptions <= 6) {
        resultRank = @"The Transporter!";
    }
    else if(numOfExceptions <= 7) {
        resultRank = @"The Stig!";
    }
    else if(numOfExceptions <= 8) {
        resultRank = @"The Italian Job!";
    }
    else if(numOfExceptions <= 9) {
        resultRank = @"A Blues Brother!";
    }
    else if(numOfExceptions <= 10) {
        resultRank = @"A Duke of Hazzard!";
    }
    else if(numOfExceptions <= 11) {
        resultRank = @"Fast Eddie!";
    }
    else if(numOfExceptions <= 13) {
        resultRank = @"John Dunlop!";
    }
    else if(numOfExceptions <= 14) {
        resultRank = @"Mad Max!";
    }
    else if(numOfExceptions <= 15) {
        resultRank = @"Too Fast Too Furious!";
    }
    else {
        resultRank = @"Too Fast Too Furious!";
    }
    
    resultLabel = [resultLabel stringByAppendingString:resultRank];
    drivingRankDescription.text = resultLabel;
    drivingRank.text = resultRank;
    socialText = resultRank;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [appDelegate release];
    [drivingRankDescription release];
    [drivingRank release];
    [super dealloc];
}

@end
