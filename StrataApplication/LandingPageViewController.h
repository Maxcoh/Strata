//
//  LandingPageViewController.h
//  StrataApplication
//
//  Created by Brendan Barnes on 8/14/14.
//  Copyright (c) 2014 StrataApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LandingPageViewController : UIViewController <UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)breaker:(id)sender;
- (IBAction)make:(id)sender;


@end
