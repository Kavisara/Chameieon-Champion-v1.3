//
//  GameScene.h
//  NinjaFish
//
//  Created by Techintegrity Services on 9/9/11.
//  Copyright 2011 Techintegrity Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "cocos2d.h"
#import "GameConfig.h"

@interface GameScene : CCLayer {
	NSString *str;
	int m_nTick;
	int m_nTime;
    
	CCSprite *spHelpSlash[2];
	CCSprite *spHelpTap[2];
	CCSprite *spHelpTilt[3];
    
	CCSprite *spMan[8];
	
	CCSprite *spLine;
	CCSprite *spHook;
	CCSprite *spDrill;
    
	//touch
	BOOL m_bTouch;
	BOOL m_fTouch;
	CGPoint m_arrayTouch[MAX_TOUCH];
	int m_nTouchNum;
	BOOL m_fDrill;
	
	//Game property
	int m_nDepth;
	int m_nCurFuel;
	int m_nBombNum;
    
	float m_rSpeed;
	
	CGPoint ptOld, ptNew;
	
	CCSprite *m_spLine[LINE_NUM];
	CCSprite *m_spPoint[LINE_NUM];
	BOOL m_fLines[LINE_NUM];
	BOOL m_fSword;
	CGPoint m_ptBef;
	CGPoint m_ptCur;
	int m_nFreeLine;
	int m_nCurLines;
    
	ALint szDug;
}

+(id) scene;
-(void) loadTex;
-(void) initGame;
-(void) onBlood:(CCSprite*)fish dir:(BOOL)fDir;
-(int) sliceFish:(CGPoint)ptFirst secondPoint:(CGPoint)ptSecond;
-(void) onSlash : (CGPoint)pt;
-(void) bomb : (CGPoint)pt;
-(void) loadScoreScene : (id)sender;

@end
