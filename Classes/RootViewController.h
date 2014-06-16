//
//  RootViewController.h
//  NinjaFishing
//
//  Created by Techintegrity Services on 11/7/11.
//  Copyright Techintegrity Services 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBFeedPost.h"

@interface RootViewController : UIViewController<FBFeedPostDelegate> {

}

/**Post to Facebook**/
- (void)PostFacebookWall;

@end
