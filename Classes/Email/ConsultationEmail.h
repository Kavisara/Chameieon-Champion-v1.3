//
//  ConsultationEmail.h
//  SleepTraining
//
//  Created by Development Team on 27/05/10.
//  Copyright 2010 Impressol. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ConsultationEmail : UIViewController <MFMailComposeViewControllerDelegate>
{
	UIView* mailView;
}

-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;

@end
