//
//  NinjaFishingAppDelegate.m
//  NinjaFishing
//
//  Created by Techintegrity Services on 11/7/11.
//  Copyright Techintegrity Services 2011. All rights reserved.
//

#import "cocos2d.h"

#import "NinjaFishingAppDelegate.h"
#import "GameConfig.h"
#import "HelloWorldScene.h"
#import "RootViewController.h"
#import <RevMobAds/RevMobAds.h>
#import "MKStoreManager.h"

#define REVMOB_ID  @"51dd14118e78c0775e000024"


@implementation NinjaFishingAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize viewController;

@synthesize viewController2;
@synthesize gameCenterManager, currentLeaderBoard;
@synthesize gameScore;

@synthesize isHighRes;
@synthesize is4inchPhone;


@synthesize cb;
@synthesize ad;


+ (NinjaFishingAppDelegate *)sharedAppDelegate
{
    return (NinjaFishingAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void) removeStartupFlicker
{

#if GAME_AUTOROTATION == kGameAutorotationUIViewController

#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    [MKStoreManager sharedManager];
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];

	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
//#else
//	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
//#endif
	
	[director setAnimationInterval:1.0/60];
//	[director setDisplayFPS:YES];	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
//	[window addSubview: viewController.view];
	
	navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	navigationController.navigationBarHidden = YES;
	
	[window addSubview: navigationController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	g_size = [[CCDirector sharedDirector] winSize];
    
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        g_fScaleX = 1024.0 / 480.0f;
        g_fScaleY = 768.0f / 320.0f;
        
        g_rScale = 2.0f;
    }
    else
    {
        if(![director enableRetinaDisplay:YES])
            CCLOG(@"Retina Display Not supported");
        
        if( CC_CONTENT_SCALE_FACTOR() == 2 )
        {
            [director setContentScaleFactor:2];
            isHighRes = YES;
            
            g_fScaleX = 1.0f;
            g_fScaleY = 1.0f;
        }
        else
        {
            [director setContentScaleFactor:1];
            
            g_fScaleX = 1.0f;
            g_fScaleY = 1.0f;
        }
        
        if (g_size.height == 568)
        {
            is4inchPhone = YES;
            
            g_fScaleY = 568.0f/480.0f;
            g_fScaleX = 1.0f;
        }
    }
    
    nInterval_generatefish = 0.8f;
    nStepDepth = 2.f;
    nInterval_loadwall = 4.f;

	g_rMusic = 0.75f; g_rSound = 1.f; //g_bVib = NO;
	//g_bSetup = TRUE;
	
	[self performSelector:@selector(loadShopInfo)];

	g_GameUtils = [[GameUtils alloc] init];
	[g_GameUtils setSoundEffectVolume:g_rSound];
	[g_GameUtils setMusicVolume:g_rMusic];
	
	[self initGameCenter];
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [HelloWorld scene]];
    
    [RevMobAds startSessionWithAppID:REVMOB_ID];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}
-(void)revmobAdDidFailWithError:(NSError *)error
{
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
    
    cb = [Chartboost sharedChartboost];
    

    cb.appId = @"51dd146617ba476828000001";
    cb.appSignature = @"9a766c961c81a6b0f1afdcb589a91dce836b48b7";

    //cb.appId = @"5089920316ba474316000016";
    //cb.appSignature = @"5c9df3491f4e887ab6a006b9a63e5c88ae1d5368";
    
    [cb startSession];
    [cb cacheInterstitial];

    //[cb showMoreApps];
    
    [[RevMobAds session] showFullscreen];
    [cb showInterstitial];
}

-(void)dispFreeGames
{
    ad = [[RevMobAds session] adLink]; // you must retain this object
    ad.delegate = self;
    [ad loadAd];
    [ad openLink];
}

-(void)dispAdvertise
{
    {
        [[RevMobAds session] showFullscreen];
        
        [cb cacheInterstitial];
        [cb showInterstitial];
        
    }
}

-(void)dispMoreGames
{
    [cb showMoreApps];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[g_GameUtils release];
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

- (void) loadShopInfo
{
//	m_ShopItem[LINE125_25].nCost = 25;
//	m_ShopItem[LINE125_25].strFile = @"line125.png";
//	m_ShopItem[LINE125_25].strTop = @"Line Upgrade(125m) - 25";
//	m_ShopItem[LINE125_25].strBottom = @"Extend fishing line to 125m";
//	m_ShopItem[LINE125_25].strBuy = @"NOW LINE UPGRADE(125m) FOR";
//	m_ShopItem[LINE125_25].szTop = ccp(286 * 0.6f, 62 * 0.85f);
//	m_ShopItem[LINE125_25].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
//	m_ShopItem[LINE125_25].szCoin = ccp(286 * 0.82f, 62 * 0.85f);
//	
	m_ShopItem[BLADE1_250].nCost = 250;
	m_ShopItem[BLADE1_250].strFile = @"blade1.png";
	m_ShopItem[BLADE1_250].strTop = @"Hattori Blade - 250";
	m_ShopItem[BLADE1_250].strBottom = @"Adds 1 extra slicing power to your Katana";
	m_ShopItem[BLADE1_250].strBuy = @"NOW HATTORI BLADE FOR";
	m_ShopItem[BLADE1_250].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[BLADE1_250].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[BLADE1_250].szCoin = ccp(286 * 0.78f, 62 * 0.85f);
	
	m_ShopItem[FUEL100_50].nCost = 50; 
	m_ShopItem[FUEL100_50].strFile = @"fuel100.png";
	m_ShopItem[FUEL100_50].strTop = @"Fuel Upgrade 100 - 50";
	m_ShopItem[FUEL100_50].strBottom = @"Gives 100 Fuel for your Drill";
	m_ShopItem[FUEL100_50].strBuy = @"NOW FUEL UPGRADE 100 FOR";
	m_ShopItem[FUEL100_50].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[FUEL100_50].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[FUEL100_50].szCoin = ccp(286 * 0.8f, 62 * 0.85f);
	
	m_ShopItem[SPEED25_400].nCost = 400;
	m_ShopItem[SPEED25_400].strFile = @"speed25.png";
	m_ShopItem[SPEED25_400].strTop = @"Speed Upgrade - 400";
	m_ShopItem[SPEED25_400].strBottom = @"Increases speed of descend by 25%";
	m_ShopItem[SPEED25_400].strBuy = @"NOW SPEED UPGRADE FOR";
	m_ShopItem[SPEED25_400].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[SPEED25_400].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[SPEED25_400].szCoin = ccp(286 * 0.8f, 62 * 0.85f);
	
	m_ShopItem[SALE10_500].nCost = 500;
	m_ShopItem[SALE10_500].strFile = @"sales10.png";
	m_ShopItem[SALE10_500].strTop = @"Sales Guide - 500";
	m_ShopItem[SALE10_500].strBottom = @"Sells fish for 10% more";
	m_ShopItem[SALE10_500].strBuy = @"NOW SALES GUIDE FOR";
	m_ShopItem[SALE10_500].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[SALE10_500].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[SALE10_500].szCoin = ccp(286 * 0.77f, 62 * 0.85f);
	
	m_ShopItem[MBA25_2000].nCost = 2000;
	m_ShopItem[MBA25_2000].strFile = @"mba25.png";
	m_ShopItem[MBA25_2000].strTop = @"MBA Diploma - 2000";
	m_ShopItem[MBA25_2000].strBottom = @"Sells fish for 25% more";
	m_ShopItem[MBA25_2000].strBuy = @"NOW MBA DIPLOMA FOR";
	m_ShopItem[MBA25_2000].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[MBA25_2000].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[MBA25_2000].szCoin = ccp(286 * 0.8f, 62 * 0.85f);
	
	m_ShopItem[LANTERN500_1000].nCost = 1000;
	m_ShopItem[LANTERN500_1000].strFile = @"lantern500.png";
	m_ShopItem[LANTERN500_1000].strTop = @"Deep Sea Lantern - 1000";
	m_ShopItem[LANTERN500_1000].strBottom = @"Illuminate the area when reaching beyond\n                               500m";
	m_ShopItem[LANTERN500_1000].strBuy = @"NOW DEEP SEA LANTERN FOR";
	m_ShopItem[LANTERN500_1000].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[LANTERN500_1000].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[LANTERN500_1000].szCoin = ccp(286 * 0.83f, 62 * 0.85f);
	
	m_ShopItem[HOOK35_500].nCost = 500;
	m_ShopItem[HOOK35_500].strFile = @"hook35.png";
	m_ShopItem[HOOK35_500].strTop = @"Hook Upgrade(35) - 500";
	m_ShopItem[HOOK35_500].strBottom = @"Upgrade hook capacity to 35 fishes";
	m_ShopItem[HOOK35_500].strBuy = @"NOW HOOK UPGRADE(35) FOR";
	m_ShopItem[HOOK35_500].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[HOOK35_500].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[HOOK35_500].szCoin = ccp(286 * 0.82f, 62 * 0.85f);
	
	m_ShopItem[WEIGHT30_30].nCost = 30;
	m_ShopItem[WEIGHT30_30].strFile = @"weight30.png";
	m_ShopItem[WEIGHT30_30].strTop = @"Weight Upgrade 1 - 30";
	m_ShopItem[WEIGHT30_30].strBottom = @"Auto drill and starts fishing at 30m";
	m_ShopItem[WEIGHT30_30].strBuy = @"NOW WEIGHT UPGRADE FOR";
	m_ShopItem[WEIGHT30_30].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[WEIGHT30_30].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[WEIGHT30_30].szCoin = ccp(286 * 0.82f, 62 * 0.85f);
	
	m_ShopItem[LINE200_150].nCost = 150;
	m_ShopItem[LINE200_150].strFile = @"line200.png";
	m_ShopItem[LINE200_150].strTop = @"Line Upgrade(200m) - 150";
	m_ShopItem[LINE200_150].strBottom = @"Extend fishing line to 200m";
	m_ShopItem[LINE200_150].strImpos = @"Purchase 125m fishing line to unlock";
	m_ShopItem[LINE200_150].strBuy = @"NOW LINE UPGRADE(200m) FOR";
	m_ShopItem[LINE200_150].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[LINE200_150].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[LINE200_150].szCoin = ccp(286 * 0.84f, 62 * 0.85f);
	
	m_ShopItem[LINE300_400].nCost = 400;
	m_ShopItem[LINE300_400].strFile = @"line300.png";
	m_ShopItem[LINE300_400].strTop = @"Line Upgrade(300m) - 400";
	m_ShopItem[LINE300_400].strBottom = @"Extend fishing line to 300m";
	m_ShopItem[LINE300_400].strImpos = @"Purchase 200m fishing line to unlock";
	m_ShopItem[LINE300_400].strBuy = @"NOW LINE UPGRADE(300m) FOR";
	m_ShopItem[LINE300_400].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[LINE300_400].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[LINE300_400].szCoin = ccp(286 * 0.84f, 62 * 0.85f);
	
	m_ShopItem[LINE400_1200].nCost = 1200;
	m_ShopItem[LINE400_1200].strFile = @"line400.png";
	m_ShopItem[LINE400_1200].strTop = @"Line Upgrade(400m) - 1200";
	m_ShopItem[LINE400_1200].strBottom = @"Extend fishing line to 400m";
	m_ShopItem[LINE400_1200].strImpos = @"Purchase 300m fishing line to unlock";
	m_ShopItem[LINE400_1200].strBuy = @"NOW LINE UPGRADE(400m) FOR";
	m_ShopItem[LINE400_1200].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[LINE400_1200].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[LINE400_1200].szCoin = ccp(286 * 0.86f, 62 * 0.85f);
	
	m_ShopItem[LINE500_2000].nCost = 2000;
	m_ShopItem[LINE500_2000].strFile = @"line500.png";
	m_ShopItem[LINE500_2000].strTop = @"Line Upgrade(500m) - 2000";
	m_ShopItem[LINE500_2000].strBottom = @"Extend fishing line to 500m";
	m_ShopItem[LINE500_2000].strImpos = @"Purchase 400m fishing line to unlock";
	m_ShopItem[LINE500_2000].strBuy = @"NOW LINE UPGRADE(500m) FOR";
	m_ShopItem[LINE500_2000].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[LINE500_2000].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[LINE500_2000].szCoin = ccp(286 * 0.86f, 62 * 0.85f);
	
	m_ShopItem[LINE600_3500].nCost = 3500;
	m_ShopItem[LINE600_3500].strFile = @"line600.png";
	m_ShopItem[LINE600_3500].strTop = @"Line Upgrade(600m) - 3500";
	m_ShopItem[LINE600_3500].strBottom = @"Extend fishing line to 600m";
	m_ShopItem[LINE600_3500].strImpos = @"Purchase 500m fishing line to unlock";
	m_ShopItem[LINE600_3500].strBuy = @"NOW LINE UPGRADE(600m) FOR";
	m_ShopItem[LINE600_3500].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[LINE600_3500].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[LINE600_3500].szCoin = ccp(286 * 0.86f, 62 * 0.85f);
	
	m_ShopItem[LINE800_5000].nCost = 5000;
	m_ShopItem[LINE800_5000].strFile = @"line800.png";
	m_ShopItem[LINE800_5000].strTop = @"Line Upgrade(800m) - 5000";
	m_ShopItem[LINE800_5000].strBottom = @"Extend fishing line to 800m";
	m_ShopItem[LINE800_5000].strImpos = @"Purchase 600m fishing line to unlock";
	m_ShopItem[LINE800_5000].strBuy = @"NOW LINE UPGRADE(800m) FOR";
	m_ShopItem[LINE800_5000].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[LINE800_5000].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[LINE800_5000].szCoin = ccp(286 * 0.86f, 62 * 0.85f);
	
	m_ShopItem[BLADE2_1000].nCost = 1000; 
	m_ShopItem[BLADE2_1000].strFile = @"blade2.png";
	m_ShopItem[BLADE2_1000].strTop = @"Sakabato Blade - 1000";
	m_ShopItem[BLADE2_1000].strBottom = @"Adds 2 extra slicing power to your Katana";
	m_ShopItem[BLADE2_1000].strImpos = @"Purchase 1 slicing power Katana to unlock";
	m_ShopItem[BLADE2_1000].strBuy = @"NOW SAKABATO BLADE FOR";
	m_ShopItem[BLADE2_1000].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[BLADE2_1000].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[BLADE2_1000].szCoin = ccp(286 * 0.82f, 62 * 0.85f);
	
	m_ShopItem[BLADE3_2500].nCost = 2500; 
	m_ShopItem[BLADE3_2500].strFile = @"blade3.png";
	m_ShopItem[BLADE3_2500].strTop = @"Zabuza Blade - 2500";
	m_ShopItem[BLADE3_2500].strBottom = @"Adds 3 extra slicing power to your Katana";
	m_ShopItem[BLADE3_2500].strImpos = @"Purchase 2 slicing power Katana to unlock";
	m_ShopItem[BLADE3_2500].strBuy = @"NOW ZABUZA BLADE FOR";
	m_ShopItem[BLADE3_2500].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[BLADE3_2500].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[BLADE3_2500].szCoin = ccp(286 * 0.8f, 62 * 0.85f);
	
	m_ShopItem[BLADE4_4000].nCost = 4000; 
	m_ShopItem[BLADE4_4000].strFile = @"blade4.png";
	m_ShopItem[BLADE4_4000].strTop = @"Muramasa Blade - 4000";
	m_ShopItem[BLADE4_4000].strBottom = @"Adds 4 extra slicing power to your Katana";
	m_ShopItem[BLADE4_4000].strImpos = @"Purchase 3 slicing power Katana to unlock";
	m_ShopItem[BLADE4_4000].strBuy = @"NOW MURAMASA BLADE FOR";
	m_ShopItem[BLADE4_4000].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[BLADE4_4000].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[BLADE4_4000].szCoin = ccp(286 * 0.84f, 62 * 0.85f);
	
	m_ShopItem[FUEL125_300].nCost = 300; 
	m_ShopItem[FUEL125_300].strFile = @"fuel125.png";
	m_ShopItem[FUEL125_300].strTop = @"Fuel Upgrade 125 - 300";
	m_ShopItem[FUEL125_300].strBottom = @"Gives 125 Fuel for your Drill";
	m_ShopItem[FUEL125_300].strImpos = @"Purchase 100 fuel to unlock";
	m_ShopItem[FUEL125_300].strBuy = @"NOW FUEL UPGRADE 125 FOR";
	m_ShopItem[FUEL125_300].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[FUEL125_300].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[FUEL125_300].szCoin = ccp(286 * 0.82f, 62 * 0.85f);
	
	m_ShopItem[FUEL150_1000].nCost = 1000; 
	m_ShopItem[FUEL150_1000].strFile = @"fuel150.png";
	m_ShopItem[FUEL150_1000].strTop = @"Fuel Upgrade 150 - 1000";
	m_ShopItem[FUEL150_1000].strBottom = @"Gives 150 Fuel for your Drill";
	m_ShopItem[FUEL150_1000].strImpos = @"Purchase 125 fuel to unlock";
	m_ShopItem[FUEL150_1000].strBuy = @"NOW FUEL UPGRADE 150 FOR";
	m_ShopItem[FUEL150_1000].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[FUEL150_1000].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[FUEL150_1000].szCoin = ccp(286 * 0.84f, 62 * 0.85f);
	
	m_ShopItem[FUEL200_2500].nCost = 2500; 
	m_ShopItem[FUEL200_2500].strFile = @"fuel200.png";
	m_ShopItem[FUEL200_2500].strTop = @"Fuel Upgrade 200 - 2500";
	m_ShopItem[FUEL200_2500].strBottom = @"Gives 200 Fuel for your Drill";
	m_ShopItem[FUEL200_2500].strImpos = @"Purchase 150 fuel to unlock";
	m_ShopItem[FUEL200_2500].strBuy = @"NOW FUEL UPGRADE 200 FOR";
	m_ShopItem[FUEL200_2500].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[FUEL200_2500].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[FUEL200_2500].szCoin = ccp(286 * 0.84f, 62 * 0.85f);
	
	m_ShopItem[HOOK50_1500].nCost = 2000;
	m_ShopItem[HOOK50_1500].strFile = @"hook50.png";
	m_ShopItem[HOOK50_1500].strTop = @"Hook Upgrade(50) - 1500";
	m_ShopItem[HOOK50_1500].strBottom = @"Upgrade hook capacity to 50 fishes";
	m_ShopItem[HOOK50_1500].strImpos = @"Purchase 35 hook to unlock";
	m_ShopItem[HOOK50_1500].strBuy = @"NOW HOOK UPGRADE(50) FOR";
	m_ShopItem[HOOK50_1500].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[HOOK50_1500].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[HOOK50_1500].szCoin = ccp(286 * 0.82f, 62 * 0.85f);
	
	m_ShopItem[WEIGHT90_500].nCost = 500;
	m_ShopItem[WEIGHT90_500].strFile = @"weight90.png";
	m_ShopItem[WEIGHT90_500].strTop = @"Weight Upgrade 2 - 500";
	m_ShopItem[WEIGHT90_500].strBottom = @"Auto drill and starts fishing at 90m";
	m_ShopItem[WEIGHT90_500].strImpos = @"Purchase 30 wight to unlock";
	m_ShopItem[WEIGHT90_500].strBuy = @"NOW WEIGHT UPGRADE FOR";
	m_ShopItem[WEIGHT90_500].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[WEIGHT90_500].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[WEIGHT90_500].szCoin = ccp(286 * 0.84f, 62 * 0.85f);
	
	m_ShopItem[WEIGHT190_1000].nCost = 1000;
	m_ShopItem[WEIGHT190_1000].strFile = @"weight190.png";
	m_ShopItem[WEIGHT190_1000].strTop = @"Weight Upgrade 3 - 1000";
	m_ShopItem[WEIGHT190_1000].strBottom = @"Auto drill and starts fishing at 190m";
	m_ShopItem[WEIGHT190_1000].strImpos = @"Purchase 90 wight to unlock";
	m_ShopItem[WEIGHT190_1000].strBuy = @"NOW WEIGHT UPGRADE FOR";
	m_ShopItem[WEIGHT190_1000].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[WEIGHT190_1000].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[WEIGHT190_1000].szCoin = ccp(286 * 0.84f, 62 * 0.85f);
	
	m_ShopItem[WEIGHT290_2500].nCost = 2500;
	m_ShopItem[WEIGHT290_2500].strFile = @"weight290.png";
	m_ShopItem[WEIGHT290_2500].strTop = @"Weight Upgrade 4 - 2500";
	m_ShopItem[WEIGHT290_2500].strBottom = @"Auto drill and starts fishing at 290m";
	m_ShopItem[WEIGHT290_2500].strImpos = @"Purchase 190 wight to unlock";
	m_ShopItem[WEIGHT290_2500].strBuy = @"NOW WEIGHT UPGRADE FOR";
	m_ShopItem[WEIGHT290_2500].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[WEIGHT290_2500].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[WEIGHT290_2500].szCoin = ccp(286 * 0.84f, 62 * 0.85f);	
	
	m_ShopItem[WEIGHT390_4000].nCost = 4000;
	m_ShopItem[WEIGHT390_4000].strFile = @"weight390.png";
	m_ShopItem[WEIGHT390_4000].strTop = @"Weight Upgrade 5 - 4000";
	m_ShopItem[WEIGHT390_4000].strBottom = @"Auto drill and starts fishing at 390m";
	m_ShopItem[WEIGHT390_4000].strImpos = @"Purchase 290 wight to unlock";
	m_ShopItem[WEIGHT390_4000].strBuy = @"NOW WEIGHT UPGRADE FOR";
	m_ShopItem[WEIGHT390_4000].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[WEIGHT390_4000].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[WEIGHT390_4000].szCoin = ccp(286 * 0.84f, 62 * 0.85f);
	
	m_ShopItem[WEIGHT490_6000].nCost = 6000;
	m_ShopItem[WEIGHT490_6000].strFile = @"weight490.png";
	m_ShopItem[WEIGHT490_6000].strTop = @"Weight Upgrade 6 - 6000";
	m_ShopItem[WEIGHT490_6000].strBottom = @"Auto drill and starts fishing at 490m";
	m_ShopItem[WEIGHT490_6000].strImpos = @"Purchase 390 wight to unlock";
	m_ShopItem[WEIGHT490_6000].strBuy = @"NOW WEIGHT UPGRADE FOR";
	m_ShopItem[WEIGHT490_6000].szTop = ccp(286 * 0.6f, 62 * 0.85f);
	m_ShopItem[WEIGHT490_6000].szBottom = ccp(286 * 0.62f, 62 * 0.4f);
	m_ShopItem[WEIGHT490_6000].szCoin = ccp(286 * 0.84f, 62 * 0.85f);
}

#pragma mark Action Methods
- (void) addOne{
	NSString* identifier= NULL;
	double percentComplete= 0;
    
	if (gameScore == 1000) {
		identifier= kAchievement100;
		percentComplete= 100.0;
	}
	else if ( gameScore == 2000) {
		identifier= kAchievement300;
		percentComplete= 300.0;
	}
	else if ( gameScore == 3000 ) {
		identifier= kAchievement600;
		percentComplete= 600.0;
	}
	else if ( gameScore ==4000 || gameScore == 5000) {
		identifier= kAchievement1000;
		percentComplete= 1000.0;
	}
	if(identifier!= NULL){
		[self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
	}
	[self performSelector:@selector(submitScore) withObject:nil afterDelay:0.2];
}

- (void)submitScore{
	if( gameScore > 0){
        
        if ([GameCenterManager isGameCenterAvailable])
        {
        [self initGameCenter];
		
		[self.gameCenterManager reportScore:gameScore  forCategory: self.currentLeaderBoard];
            [self.gameCenterManager reloadHighScoresForCategory:self.currentLeaderBoard];
        }
	}
}

#pragma mark GameCenter View Controllers

- (void)initGameCenter {
	if(viewController2 != nil)
		return;
	viewController2 = [GCViewController alloc];
    self.currentLeaderBoard = kEasyLeaderboardID;
    
	if ([GameCenterManager isGameCenterAvailable])
	{
		self.gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
		[self.gameCenterManager setDelegate:self];
		[self.gameCenterManager authenticateLocalUser];
	}
    
    //	viewController2.view.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
}

- (void)abrirLDB{
    self.currentLeaderBoard = kEasyLeaderboardID;
    if ([GameCenterManager isGameCenterAvailable]) {
        [viewController2.view setHidden:NO];
        [self.window addSubview:viewController2.view];
        [self showLeaderboard];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Gamecenter is not available in your iOS version" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        
    }
}

- (void)abrirACHV{
    if ([GameCenterManager isGameCenterAvailable])
    {
        [viewController2.view setHidden:NO];
        [self.window addSubview:viewController2.view];
        [self showAchievements];
        
    }
}

- (void) showLeaderboard{
	GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != NULL) {
		leaderboardController.category = self.currentLeaderBoard;
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardController.leaderboardDelegate = self; 
		[viewController2 presentViewController: leaderboardController animated: YES completion:Nil];
        //		leaderboardController.view.transform = CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(0.0f));
	}
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController1
{
	[viewController1 dismissViewControllerAnimated:YES completion:Nil];
	[viewController2.view removeFromSuperview];
	[viewController2.view setHidden:YES];
	[viewController1 release];
}

- (void) showAchievements{
	GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
	if (achievements != NULL){
		achievements.achievementDelegate = self;
		[viewController2 presentViewController:achievements animated:YES completion:Nil];
	}
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController1{
	[viewController1 dismissViewControllerAnimated:YES completion:Nil];
	[viewController2.view removeFromSuperview];
	[viewController2.view setHidden:YES];
	[viewController1 release];
}

- (IBAction) resetAchievements: (id) sender{
	[gameCenterManager resetAchievements];
}

#pragma mark Facebook method
- (void)PostScoreToFacebook
{
    [viewController PostFacebookWall];
}

@end
