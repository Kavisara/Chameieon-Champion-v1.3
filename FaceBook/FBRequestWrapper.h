//
//  FBRequestWrapper.h
//  Facebook Demo
//
//  Created by Andy Yanok on 3/6/11.
//  Copyright 2011 Techintegrity Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"
//
//#define FB_APP_ID @"197366800287642"
//#define FB_API_KEY @"3269fff9ef3b6fc13255e670ebb44c4d"
//#define FB_APP_SECRET @"d038b12cc8632865952f69722fe26393"

#define FB_APP_ID @"271757789543407"
#define FB_API_KEY @"3269fff9ef3b6fc13255e670ebb44c4d"
#define FB_APP_SECRET @"54c4221a6be83c50e9d5b5946d1cb0ac"

//#define FB_APP_ID @"200832719990177"
//#define FB_API_KEY @"3269fff9ef3b6fc13255e670ebb44c4d"
//#define FB_APP_SECRET @"d0eba1cac42387601a1a5d08468ae0aa"

//static NSString* kApiKey = @"200832719990177";
//static NSString* kApiSecret = @"d0eba1cac42387601a1a5d08468ae0aa"; // @"<YOUR SECRET KEY>";


@interface FBRequestWrapper : NSObject <FBRequestDelegate, FBSessionDelegate> 
{
	Facebook *facebook;
	BOOL isLoggedIn;
}

@property (nonatomic, assign) BOOL isLoggedIn;

+ (id) defaultManager;
- (void) setIsLoggedIn:(BOOL) _loggedIn;
- (void) FBSessionBegin:(id<FBSessionDelegate>) _delegate;
- (void) FBLogout;
- (void) getFBRequestWithGraphPath:(NSString*) _path andDelegate:(id) _delegate;
- (void) sendFBRequestWithGraphPath:(NSString*) _path params:(NSMutableDictionary*) _params andDelegate:(id) _delegate;

@end
