//
//  LandingPageViewController.m
//  StrataApplication
//
//  Created by Brendan Barnes on 8/14/14.
//  Copyright (c) 2014 StrataApp. All rights reserved.
//

#import "LandingPageViewController.h"

@interface LandingPageViewController ()

@end

@implementation LandingPageViewController

- (void)viewDidLoad
{
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"big-old-background.png"]];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }


- (IBAction)breaker:(id)sender {
 _scrollView.contentOffset = CGPointMake(0, 2048);
}

- (IBAction)make:(id)sender {

}
@end
