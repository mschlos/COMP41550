//
//  RankViewController.h
//  HowsMyDriving
//
//  Created by Ruaidhri Hallinan on 22/04/2013.
//  Copyright (c) 2013 Ruaidhri Hallinan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <Social/Social.h>

@interface RankViewController : UIViewController {
    AppDelegate *appDelegate;

    //Displays your overall driving rank
    IBOutlet UILabel *drivingRank;

    //Displays random funny description
    IBOutlet UILabel *drivingRankDescription;
}

//called on tap of facebook button
- (IBAction)postOnFacebookButtonTapped:(id)sender;

//called on tap of tweet button
- (IBAction)tweetButtonTapped:(id)sender;

@end
