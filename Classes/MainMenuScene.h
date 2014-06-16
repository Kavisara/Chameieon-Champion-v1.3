//
//  MainMenuScene.h
//  NinjaFish
//
//  Created by Techintegrity Services on 9/7/11.
//  Copyright 2011 Techintegrity Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"

@interface MainMenuScene : CCLayer<UIAlertViewDelegate> {
	int m_nTick;
	
	CCMenuItemImage *btnItemPlay;
	CCMenuItemImage *btnItemOption;
	CCMenuItemImage *btnItemGameCenter;
	CCMenuItemImage *btnItemBonus;
	
	CCSprite *bgOption;
}

+(id) scene;

-(void) initUserInfo;
+(void)saveUserInfo;
-(BOOL)GetUserInfoFromFile;

-(void) removeLabel : (CCLabelBMFont*)label;
-(void) removeSprite : (CCSprite*)sprite;
-(void) removeMenuItem : (CCMenuItemImage*)item;
@end
