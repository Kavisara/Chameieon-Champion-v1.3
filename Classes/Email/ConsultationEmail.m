    //
//  ConsultationEmail.m
//  SleepTraining
//
//  Created by Development Team on 27/05/10.
//  Copyright 2010 Impressol. All rights reserved.
//


#import "ConsultationEmail.h"

//#import "MFMailComposeViewController.h"

@implementation ConsultationEmail

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
	}
    return self;
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.

- (void)loadView 
{
	self.title = @"Ninja Fishing";
	CGRect rect = [[UIScreen mainScreen] bounds];
	mailView = [[UIView alloc] initWithFrame:rect];
	[mailView setBackgroundColor:[UIColor clearColor]];
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
	
	self.view = mailView;
	[mailView release];
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad 
{
	self.title = @"Ninja Fishing";
	[super viewDidLoad];
}

#pragma mark -
#pragma mark Compose Mail
// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
	MFMailComposeViewController* picker = [[MFMailComposeViewController alloc] init];
	
	if (picker)
	{
		[picker setMailComposeDelegate:self];
		[picker setSubject:@"Ninja Fishing - love this game!"];

		NSString *emailBody;
		emailBody = [NSString stringWithString:@"Hey Buddy!\nI'm playing this new game called Ninja Fishing on the iPhone - seriously addicting!\nYou first start to fish in the ocean and then you use your Ninja sword to slash them all like crazy.\nIt's like that other slice game but 10,000x better!\nCheck it out at"];
		
		[picker setMessageBody:emailBody isHTML:NO];

		[self presentModalViewController:picker animated:YES];
		[picker release];
	}
}

#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:&subject=";
	NSString *body = @"&body=";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
	[[self navigationController] popViewControllerAnimated:YES];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)viewWillAppear:(BOOL)animated 
{
	[[self navigationController] setNavigationBarHidden:YES animated:NO];
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated 
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated 
{
	self.title = @"Recording Inside The Box";
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated 
{
	self.title = @"Recording Inside The Box";
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
    [super dealloc];
}



@end
