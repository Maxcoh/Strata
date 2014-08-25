//
//  LandingPageiPadViewController.m
//  StrataApplication
//
//  Created by Brendan Barnes on 8/18/14.
//  Copyright (c) 2014 StrataApp. All rights reserved.
//

#import "LandingPageiPadViewController.h"

@interface LandingPageiPadViewController ()

@end

@implementation LandingPageiPadViewController

-(void)viewWillAppear:(BOOL)animated{
    if(_makeImageView.image == NULL){
        _cameraButtonTop.alpha = 1;
    }
    else{
        _cameraButtonTop.alpha = .015;
    }
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIImage* rotatedImage = [[UIImage alloc] initWithCGImage: _appDelegate.loadedImage.CGImage
                                                       scale: 1.0
                                                 orientation: UIImageOrientationRight];
    _breakImage = rotatedImage;

    UIImage *newImage;
    if(_breakImage.size.height > _breakImageView.frame.size.height || _breakImage.size.width > _breakImageView.frame.size.width){
        if(_breakImage.size.width > _breakImage.size.height){
            float iWidth = _breakImageView.frame.size.width;
            float ratio = iWidth/_breakImage.size.width;
            
            float newHeight = _breakImage.size.height * ratio;
            
            UIGraphicsBeginImageContext(CGSizeMake(iWidth, newHeight));
            [_breakImage drawInRect:CGRectMake(0, 0, iWidth, newHeight)];
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
        }
        else
        {
            float iHeight = _breakImageView.frame.size.height;
            float ratio = iHeight/_breakImage.size.height;
            
            float newWidth = _breakImage.size.width * ratio;
            
            UIGraphicsBeginImageContext(CGSizeMake(newWidth, iHeight));
            [_breakImage drawInRect:CGRectMake(0, 0, newWidth, iHeight)];
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        _breakImageView.image = newImage;
    }
    else{
        _breakImageView.image = _breakImage;
    }
    if(_breakImage != NULL){
        _breakButton.imageView.image = [UIImage imageNamed:@"break-button-on.png"];
        _cameraButtonBreak.alpha = .015;
        [_scrollView setContentOffset:CGPointMake(0, 1024) animated:NO];
    }
    else{
        switch(_currentScreen){
            case 1:
                [_scrollView setContentOffset:CGPointMake(0, -1024) animated:NO];
                break;
            case 0:
                [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                break;
            case -1:
                [_scrollView setContentOffset:CGPointMake(0, 1024) animated:NO];
                break;
        }
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    self.textFieldMake.delegate = self;
    _flipButton.hidden = YES;
    _scrollView.delegate = self;
    _textFieldMake.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"make-text-input-view.png"]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)breaker:(id)sender {
        _breakButton.imageView.image = [UIImage imageNamed:@"break-button-off.png"];
        _cameraButtonBreak.alpha = 1;
        _flipButton.hidden = YES;
    _currentScreen = -1;
    [_scrollView setContentOffset:CGPointMake(0, 1024) animated:YES];
}

- (IBAction)maker:(id)sender {
    _makeImageView.image = NULL;
    _makeButton.imageView.image = [UIImage imageNamed:@"make-button-off.png"];
    _cameraButtonTop.alpha = 1;
    _currentScreen = 1;
    _textFieldMake.text = @"";
    [_scrollView setContentOffset:CGPointMake(0, -1024) animated:YES];
}
- (IBAction)cameraButtonMake:(id)sender {
    _breakImage = NULL;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:imagePicker animated:YES completion:NULL];
    _cameraButtonTop.alpha = .015;
}
- (IBAction)goDown:(id)sender {
    _canMake = NO;
    _currentScreen = 0;
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)make:(id)sender {
    if(_canMake){
        Encoder *encoder = [[Encoder alloc] init];
        _makeImage = [encoder encodeMessage:_makeImage:_textFieldMake.text];
        _makeButton.imageView.image = [UIImage imageNamed:@"make-button-on.png"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Your Creation" message:@"Your message has been encoded, now send it out!" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Message", @"Tumblr", @"Email", @"Save", nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        _makeButton.imageView.image = [UIImage imageNamed:@"make-button-on.png"];
    }
    if(buttonIndex == 1){
        [self displaySMSComposerSheet];
        _makeButton.imageView.image = [UIImage imageNamed:@"make-button-on.png"];
    }
    if(buttonIndex == 2){
        [self displayTumblrComposerSheet];
        _makeButton.imageView.image = [UIImage imageNamed:@"make-button-on.png"];
    }
    if(buttonIndex == 3){
        [self displayMailComposerSheet];
        _makeButton.imageView.image = [UIImage imageNamed:@"make-button-on.png"];
    }
    if(buttonIndex == 4){
        UIImageWriteToSavedPhotosAlbum(_makeImage, nil, nil, nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved!" message:nil delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        _makeButton.imageView.image = [UIImage imageNamed:@"make-button-on.png"];
    }
}
-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText]) {
        [picker setMessageComposeDelegate:self];
        NSData *myData = UIImagePNGRepresentation(_makeImage);
        [picker addAttachmentData:myData typeIdentifier:@"public.data" filename:@"image.png"];
        
    }
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)displayTumblrComposerSheet
{
    
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    if([MFMailComposeViewController canSendMail]){
	picker.mailComposeDelegate = self;
    NSArray *recipentsArray = [[NSArray alloc]initWithObjects:@"inrcbfuyxep3j@tumblr.com", nil];
    
	[picker setToRecipients:recipentsArray];
    
	[picker setSubject:@"My Encoded Image!"];
	
	// Attach an image to the email
    NSData *myData = UIImagePNGRepresentation(_makeImage);
	[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"encodedImage"];
	
	// Fill out the email body text
	NSString *emailBody = @"";
	[picker setMessageBody:emailBody isHTML:NO];
	
    
	[self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)displayMailComposerSheet
{
    if([MFMailComposeViewController canSendMail]){
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    
	// Attach an image to the email
    NSData *myData = UIImagePNGRepresentation(_makeImage);
	[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"encodedImage"];
	
	// Fill out the email body text
	NSString *emailBody = @"";
	[picker setMessageBody:emailBody isHTML:NO];
	
    
	[self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
	[self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _scrollView.contentOffset = CGPointMake(0, -950);
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(![_textFieldMake.text isEqual:@""] && _makeImageView.image != NULL){
        _makeButton.imageView.image = [UIImage imageNamed:@"make-button-on.png"];
        _canMake = YES;
    }
    _scrollView.contentOffset = CGPointMake(0, -1024);
}
- (IBAction)breakButton:(id)sender {
    if(_breakImageView.image != NULL){
    _appDelegate.loadedImage = NULL;
    Decoder *decoder = [[Decoder alloc] init];
    
    NSString *decodedText = [decoder decodeMessage:_breakImage];
    _textView.text = decodedText;
    _textView.font = [UIFont systemFontOfSize:60.0];
    _textView.textColor = [UIColor colorWithRed:(243.0/225.0) green:(255.0/255.0) blue:(226.0/255.0) alpha:1];
    _textView.alpha = .6;
    _flipButton.hidden = NO;
    }
}

- (IBAction)cameraButtonBreak:(id)sender {
    _breakImage = NULL;
    UIImagePickerController *imagePicker2 = [[UIImagePickerController alloc] init];
    imagePicker2.delegate = self;
    [self presentViewController:imagePicker2 animated:YES completion:NULL];
    _flipButton.hidden = YES;
    _textView.alpha = 0;
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *newImage;
    [self dismissViewControllerAnimated:YES completion:NULL];
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        _makeImage = image;
        if(_makeImage.size.height > _makeImageView.frame.size.height || _makeImage.size.width > _makeImageView.frame.size.width){
            if(_makeImage.size.width > _makeImage.size.height){
                float iWidth = _makeImageView.frame.size.width;
                float ratio = iWidth/_makeImage.size.width;
                
                float newHeight = _makeImage.size.height * ratio;
                
                UIGraphicsBeginImageContext(CGSizeMake(iWidth, newHeight));
                [_makeImage drawInRect:CGRectMake(0, 0, iWidth, newHeight)];
                newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
            }
            else
            {
                float iHeight = _makeImageView.frame.size.height;
                float ratio = iHeight/_makeImage.size.height;
                
                float newWidth = _makeImage.size.width * ratio;
                
                UIGraphicsBeginImageContext(CGSizeMake(newWidth, iHeight));
                [_makeImage drawInRect:CGRectMake(0, 0, newWidth, iHeight)];
                newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            
            _makeImageView.image = newImage;
        }
        else{
            _makeImageView.image = _makeImage;
        }
        if(![_textFieldMake.text isEqual:@""] && _makeImageView.image != NULL){
            _makeButton.imageView.image = [UIImage imageNamed:@"make-button-on.png"];
            _canMake = YES;
        }
        [_scrollView setContentOffset:CGPointMake(0, -1024) animated:NO];
        
        if(_makeImageView.image == NULL){
            _cameraButtonTop.alpha = 1;
        }
    }
    else{
        UIImage* rotatedImage = [[UIImage alloc] initWithCGImage: image.CGImage
                                                           scale: 1.0
                                                     orientation: UIImageOrientationRight];
        _breakImage = rotatedImage;
        if(_breakImage.size.height > _breakImageView.frame.size.height || _breakImage.size.width > _breakImageView.frame.size.width){
            if(_breakImage.size.width > _breakImage.size.height){
                float iWidth = _breakImageView.frame.size.width;
                float ratio = iWidth/_breakImage.size.width;
                
                float newHeight = _breakImage.size.height * ratio;
                
                UIGraphicsBeginImageContext(CGSizeMake(iWidth, newHeight));
                [_breakImage drawInRect:CGRectMake(0, 0, iWidth, newHeight)];
                newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
            }
            else
            {
                float iHeight = _breakImageView.frame.size.height;
                float ratio = iHeight/_breakImage.size.height;
                
                float newWidth = _breakImage.size.width * ratio;
                
                UIGraphicsBeginImageContext(CGSizeMake(newWidth, iHeight));
                [_breakImage drawInRect:CGRectMake(0, 0, newWidth, iHeight)];
                newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            
            _breakImageView.image = newImage;
        }
        else{
            _breakImageView.image = _breakImage;
        }
        
        if(_breakImageView.image != NULL){
        _breakButton.imageView.image = [UIImage imageNamed:@"break-button-on.png"];
        _cameraButtonBreak.alpha = .015;
        [_scrollView setContentOffset:CGPointMake(0, 1024) animated:NO];
        }
    }
    
}

- (IBAction)goUp:(id)sender {
    _textView.alpha = 0;
    _breakImageView.image = NULL;
    _appDelegate.loadedImage = NULL;
    _currentScreen = 0;
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)flip:(id)sender {
    if(_textView.alpha == 0)
        _textView.alpha = .6;
    else
        _textView.alpha = 0;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
