//
//  NinjaFishingAppDelegate.h
//  NinjaFishing
//
//  Created by Techintegrity Services on 11/7/11.
//  Copyright Techintegrity Services 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCViewController.h"
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"
#import "AppSpecificValues.h"
#import "Chartboost.h"
#import <RevMobAds/RevMobAdsDelegate.h>
#import <RevMobAds/RevMobAds.h>

@class RootViewController;

@interface NinjaFishingAppDelegate : NSObject <UIApplicationDelegate, GKAchievementViewControllerDelegate,ChartboostDelegate,RevMobAdsDelegate, GKLeaderboardViewControllerDelegate, GameCenterManagerDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
	UINavigationController *navigationController;
	
#pragma mark GAME_CENTER
    GCViewController* viewController2;
	GameCenterManager* gameCenterManager;
	NSString* currentLeaderBoard;
    int gameScore;
    
    BOOL isHighRes;
    BOOL is4inchPhone;
}

@property (nonatomic,retain) RootViewController	*viewController;
@property(nonatomic, retain) GCViewController* viewController2;
@property (nonatomic, retain) GameCenterManager* gameCenterManager;
@property (nonatomic, retain) NSString* currentLeaderBoard;
@property (nonatomic) int gameScore;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, assign) UINavigationController *navigationController;

@property (nonatomic, assign) BOOL isHighRes;
@property (nonatomic, assign) BOOL is4inchPhone;


@property (nonatomic, retain) Chartboost *cb;
@property (nonatomic, retain) RevMobAdLink *ad;

#pragma mark Facebook method
- (void)PostScoreToFacebook;

#pragma mark GAME_CENTER

+ (NinjaFishingAppDelegate *)sharedAppDelegate;

- (void) addOne;
- (void) submitScore;
- (void) showLeaderboard;
- (void) showAchievements;
- (void) initGameCenter;

- (void) abrirLDB;
- (void) abrirACHV;
-(void)dispAdvertise;
-(void)dispFreeGames;
-(void)dispMoreGames;
@end
