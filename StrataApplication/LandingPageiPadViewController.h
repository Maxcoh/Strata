//
//  LandingPageiPadViewController.h
//  StrataApplication
//
//  Created by Brendan Barnes on 8/18/14.
//  Copyright (c) 2014 StrataApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Decoder.h"
#import "Encoder.h"
#import "AppDelegate.h"


@interface LandingPageiPadViewController : UIViewController <UINavigationControllerDelegate, UIAlertViewDelegate, UIScrollViewAccessibilityDelegate,UIImagePickerControllerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate>

//Landing Page Controller
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)breaker:(id)sender;
- (IBAction)maker:(id)sender;

//Make Controller
@property (weak, nonatomic) IBOutlet UITextField *textFieldMake;
- (IBAction)cameraButtonMake:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *makeButton;
@property (weak, nonatomic) IBOutlet UIImageView *makeImageView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButtonTop;
- (IBAction)goDown:(id)sender;
- (IBAction)make:(id)sender;

//Break Controller
- (IBAction)breakButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cameraButtonBreak;
@property (weak, nonatomic) IBOutlet UIButton *flipButton;
@property (weak, nonatomic) IBOutlet UIButton *breakButton;
@property (weak, nonatomic) IBOutlet UIImageView *breakImageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)cameraButtonBreak:(id)sender;
- (IBAction)goUp:(id)sender;
- (IBAction)flip:(id)sender;

//Other necessary things
@property (strong, nonatomic) UIImage* makeImage;
@property (strong, nonatomic) UIImage* breakImage;
@property (nonatomic) BOOL canMake;
@property (nonatomic) int currentScreen;
@property (nonatomic) AppDelegate* appDelegate;

@end
