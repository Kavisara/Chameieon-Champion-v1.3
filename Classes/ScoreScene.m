//
//  ScoreScene.m
//  NinjaFish
//
//  Created by Techintegrity Services on 9/11/11.
//  Copyright 2011 Techintegrity Services. All rights reserved.
//

#import "ScoreScene.h"
#import "GameConfig.h"
#import "GameScene.h"
#import "FishSprite.h"
#import "ShopScene1.h"
#import "Trophies.h"
#import "MainMenuScene.h"
#import "NinjaFishingAppDelegate.h"
#import "Tools.h"
#import "TreasureScene.h"
#import "MKStoreManager.h"

enum TAG_SCORE {
	kTagMenu,
	kTagFish,
	kTagFishMenu,
	kTagMessMenu,
	kTagShareMenu,
	kTagLabel1,
	kTagLabel2,
	kTagLabel3,
	kTagLabel4,
	kTagLabel5,
	kTagLabel6,//10
	kTagLabel7,
	kTagLabelNewRecord,
	kTagFishString,
	kTagFishScore,
	kTagNoFish,
	kTagStar1,
	kTagStar2,
	kTagShareBg,
	kTagBox,
	kTagScoreBg
};

enum TAG_MENUITEM {
	kTagGame,
	kTagShop,
	kTagTrophies,
    kTagTreasure,
	kTagBonus,
    kTagUnlockAll,
    kTagf,
	kTagMess,
	kTagLabelTTF,
	kTagLabelBM,
	kTagPre,
	kTagNext
};

int nNewFishType;
int newfishType [FISHTYPE_NUM];

int m_nGameState;

@implementation ScoreScene
+(id) scene
{
	CCScene *scene = [CCScene node];
	ScoreScene *layer = [ScoreScene node];
	[scene addChild: layer];
	return scene;
}

-(void) OnUnlockAll : (id) sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    [[MKStoreManager sharedManager] buyUnloadAll];

}

-(void) OnTrophies : (id) sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    NSString *r = @"CCTransitionMoveInR";
	Class transion = NSClassFromString(r);
	[[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:0.5f scene:[Trophies scene]]];
}

-(void) OnTreasure : (id) sender
{
    if (fTrophies || fShop || fGame) {
		return;
	}
	[g_GameUtils playSoundEffect:@"Button_All.mp3"];
	fShop = YES;
    
	TreasureScene* layer_ShopScene = [[TreasureScene alloc] init];
	layer_ShopScene.position = ccp(g_size.width, 0);
	[self addChild:layer_ShopScene];
    
	[self runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(-g_size.width, 0)]];
	[layer_ShopScene release];// layer_ShopScene = nil;
    
}

-(void) OnBonus : (id) sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
    NinjaFishingAppDelegate* del = (NinjaFishingAppDelegate*)[UIApplication sharedApplication].delegate;
    [del dispAdvertise];
}


-(id) init
{
	if( (self=[super init] )) {
		[[CCTextureCache sharedTextureCache] removeAllTextures];
		fShop = NO; fTrophies = NO;fGame = NO;
        
        CCSprite *bgSprite;
        //  BG Sprite

        bgSprite = [CCSprite spriteWithFile:[Tools imageNameForName:@"score-BG"]];
        bgSprite.scaleX = g_fScaleX;bgSprite.scaleY = g_fScaleY;
        bgSprite.anchorPoint = ccp(0.0f, 0.0f);
        [self addChild:bgSprite z:-1 tag:kTagScoreBg];
        bgSprite.position = ccp(0.0f, 0.0f);
        
        

//         NinjaFishingAppDelegate* del = (NinjaFishingAppDelegate*)[UIApplication sharedApplication].delegate;
//         [del dispAdvertise];

        CCMenuItemImage *btnFishAgain = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"fish-again-button"]
                                                               selectedImage:[Tools imageNameForName:@"fish-again-button"] target:self selector:@selector(OnGame:)];
        btnFishAgain.anchorPoint = ccp(0.0, 1.0);
        btnFishAgain.tag = kTagGame;
        
        CCMenuItemImage *btnUnlockAll = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"unlock-all-button"]
                                                               selectedImage:[Tools imageNameForName:@"unlock-all-button"] target:self selector:@selector(OnUnlockAll:)];
        btnUnlockAll.anchorPoint = ccp(0.0, 1.0);
        btnUnlockAll.tag = kTagUnlockAll;
        
        
        CCMenuItemImage *btnShop = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"shop-button"]
                                                          selectedImage:[Tools imageNameForName:@"shop-button"] target:self selector:@selector(OnShop:)];
        btnShop.anchorPoint = ccp(0.0, 1.0);
        btnShop.tag = kTagShop;
        
        CCMenuItemImage *btnBonus = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"bonus-button"]
                                                           selectedImage:[Tools imageNameForName:@"bonus-button"] target:self selector:@selector(OnBonus:)];
        btnBonus.anchorPoint = ccp(0.0, 1.0);
        btnBonus.tag = kTagBonus;
        
        CCMenuItemImage *btnTrophies = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"tophies-button"]
                                                              selectedImage:[Tools imageNameForName:@"tophies-button"] target:self selector:@selector(OnTrophies:)];
        btnTrophies.anchorPoint = ccp(0.0, 1.0);
        btnTrophies.tag = kTagTrophies;
        
        CCMenuItemImage *btnTreasures = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"treasure-button"]
                                                               selectedImage:[Tools imageNameForName:@"treasure-button"] target:self selector:@selector(OnTreasure:)];
        btnTreasures.anchorPoint = ccp(0.0, 1.0);
        btnTreasures.tag = kTagTreasure;

            btnFishAgain.position = ccp(10 * g_fScaleX, 115 * g_fScaleY);
            btnUnlockAll.position = ccp(161 * g_fScaleX, 115 * g_fScaleY);
            btnShop.position = ccp(25 * g_fScaleX, 55 * g_fScaleY);
            btnBonus.position = ccp(180 * g_fScaleX, 55 * g_fScaleY);
            btnTrophies.position = ccp(25 * g_fScaleX, 168 * g_fScaleY);
            btnTreasures.position = ccp(180 * g_fScaleX, 168 * g_fScaleY);

 		CCMenu *menu = [CCMenu menuWithItems:btnFishAgain, btnUnlockAll, btnShop, btnBonus, btnTrophies, btnTreasures, nil];
		menu.position = ccp(0, 0);
        [self addChild:menu z:2 tag:kTagMenu];
		
		[self performSelector:@selector(initLayer:) withObject:self afterDelay:0.5f];
		[[CCTextureCache sharedTextureCache] removeAllTextures];
	}
	
	return self;
}

-(void) initLayer : (id) sender
{
	CCLabelBMFont *label1 = [[CCLabelBMFont alloc] initWithString:@"FISHING RESULT :" fntFile:@"Welltron40.fnt"];
	label1.position = ccp(160 * g_fScaleX, 445 * g_fScaleY);
	label1.scale = 0.5f * g_fScaleX;

    
    CCLabelTTF* label3 = [[CCLabelTTF alloc] initWithString:@"0m" fontName:@"BADABB_.TTF" fontSize:30.0f];
    label3.position = ccp(200 * g_fScaleX, 369 * g_fScaleY);
    //label3.scale = 0.75f * g_fScaleX;
	[self addChild:label3 z:0 tag:kTagLabel3];[label3 release];
    
	//str = [NSString stringWithFormat:@"%d~", g_UserInfo.nScore];
	CCLabelBMFont *label4 = [[CCLabelBMFont alloc] initWithString:@"0" fntFile:@"Welltron40.fnt"];
	label4.position = ccp(200 * g_fScaleX, 332 * g_fScaleY);
	label4.scale = 0.75f * g_fScaleX;label4.visible = NO;
	//[self addChild:label4 z:2 tag:kTagLabel4];
    [label4 release];
	
	//str = [NSString stringWithFormat:@"%d", slash_fishes.count];
	CCLabelBMFont *label5 = [[CCLabelBMFont alloc] initWithString:@"0" fntFile:@"Welltron40Yellow.fnt"];
	label5.position = ccp(210 * g_fScaleX, 310 * g_fScaleY);
	label5.scale = 0.75f * g_fScaleX;label5.visible = NO;
	//[self addChild:label5 z:2 tag:kTagLabel5];
    [label5 release];

  	CCLabelTTF *label6 = [[CCLabelTTF alloc] initWithString:@"0" fontName:@"BADABB_.TTF" fontSize:30.0f];
	label6.position = ccp(180 * g_fScaleX, 335 * g_fScaleY);
	//label6.scale = 0.65f * g_fScaleX;label6.visible = NO;
	[self addChild:label6 z:2 tag:kTagLabel6];[label6 release];

    CCLabelTTF *label7 = [[CCLabelTTF alloc] initWithString:@"0" fontName:@"BADABB_.TTF" fontSize:30.0f];
	label7.position = ccp(220 * g_fScaleX, 295 * g_fScaleY);
	//label7.scale = 0.65f * g_fScaleX;label7.visible = NO;
	[self addChild:label7 z:2 tag:kTagLabel7];[label7 release];
	
	[self schedule:@selector(loadDepth)];
	
	for (int i = 0; i < FISHTYPE_NUM; i++) {
		newfishType[i] = -1;
	}
	nNewFishType = 0;
	fScore = NO; fFish = NO; fMoney = NO; fTotal = NO;
}

-(void) loadDepth
{
	if (g_UserInfo.nCurDepth <= 50)  nTime = nIdx;
	else if (g_UserInfo.nCurDepth > 50 && g_UserInfo.nCurDepth <= 200)  nTime = nIdx * 10;
	else nTime = nIdx * 100;
	
	str = [NSString stringWithFormat:@"%dm", nTime];
	[[self getChildByTag:kTagLabel3] removeAllChildrenWithCleanup:YES];
	[(CCLabelBMFont*)[self getChildByTag:kTagLabel3] setString:str];
	
	if (nTime >= g_UserInfo.nCurDepth) {
		[self unschedule:@selector(loadDepth)];
		
		str = [NSString stringWithFormat:@"%dm", g_UserInfo.nCurDepth];
		[[self getChildByTag:kTagLabel3] removeAllChildrenWithCleanup:YES];
		[(CCLabelBMFont*)[self getChildByTag:kTagLabel3] setString:str];
		
		nIdx = 0;
		if (g_UserInfo.nCurDepth > g_UserInfo.nTotalDepth) {
			//[soundEngine playEffect:@"newRecord.wav"];
			[g_GameUtils playSoundEffect:@"newRecord.wav"];
			
			g_UserInfo.nTotalDepth = g_UserInfo.nCurDepth;
			[self getChildByTag:kTagLabel1].visible = NO;
			
			CCSprite *sp = [[CCSprite alloc] initWithFile:@"star.png"];
			sp.scaleX = g_fScaleX; sp.scaleY = g_fScaleY;
			sp.position = ccp(50 * g_fScaleX, 445 * g_fScaleY);
			[self addChild:sp z:2 tag:kTagStar1]; [sp release];
			
			sp = [[CCSprite alloc] initWithFile:@"star.png"];
			sp.scaleX = g_fScaleX; sp.scaleY = g_fScaleY;
			sp.position = ccp(270 * g_fScaleX, 445 * g_fScaleY);
			[self addChild:sp z:2 tag:kTagStar2];[sp release];
			
			CCLabelBMFont *label = [[CCLabelBMFont alloc] initWithString:@"NEW RECORED !" fntFile:@"Welltron40Yellow.fnt"];
			label.position = ccp(160 * g_fScaleX, 445 * g_fScaleY);
			label.scale = 0.5f * g_fScaleX;
			//[self addChild:label z:2 tag:kTagLabelNewRecord];
			
			id act_scale = [CCScaleTo actionWithDuration:0.5f scaleX:g_fScaleX scaleY:g_fScaleY];
			id act_scale_reverse = [CCScaleTo actionWithDuration:0.2f  scaleX:0.75f * g_fScaleX scaleY:0.75f * g_fScaleX];
			[label runAction:[CCSequence actions:act_scale, act_scale_reverse, nil]];
			[label release];
			
			sp = [[CCSprite alloc] initWithFile:@"sharescore.png"];
			sp.scaleX = g_fScaleX; sp.scaleY = g_fScaleY;
			sp.position = ccp(360 * g_fScaleX, 400 * g_fScaleY);
			//[self addChild:sp z:0 tag:kTagShareBg];
			
            /*
             CCMenuItemImage *itemf = [CCMenuItemImage itemFromNormalImage:@"f.png" selectedImage:@"f.png"
             target:self selector:@selector(facebook:)];
             itemf.position = ccp(sp.contentSize.width * 4 / 5, sp.contentSize.height / 2);
             itemf.tag = kTagf;
             
             CCMenu *menu1 = [CCMenu menuWithItems:itemf, nil];
             menu1.position = ccp(0, 0);
             [sp addChild:menu1 z:0 tag:kTagShareMenu];
             */
            
			//[sp runAction:[CCMoveBy actionWithDuration:1.f position:ccp(-155 * g_fScaleX, 0)]];
			[sp release];
			
			//[[self getChildByTag:kTagLabel2] runAction:[CCMoveBy actionWithDuration:1.f position:ccp(-155 * g_fScaleX, 0)]];
			//[[self getChildByTag:kTagLabel3] runAction:[CCMoveBy actionWithDuration:1.f position:ccp(-155 * g_fScaleX, 0)]];
		}
		
		for (int i = kTagLabel4; i <= kTagLabel7; i++) {
			[self getChildByTag:i].visible = YES;
		}
		
		[self schedule:@selector(loadScore)];
	}
	
	nIdx++;
}
-(void) loadScore
{
	if (!fScore) {
		if (g_UserInfo.nScore <= 50)  nTime = nIdx;
		else if (g_UserInfo.nScore > 50 && g_UserInfo.nScore <= 200)  nTime = nIdx * 10;
		else nTime = nIdx * 100;
		
		str = [NSString stringWithFormat:@"%d", nTime];
		[[self getChildByTag:kTagLabel4] removeAllChildrenWithCleanup:YES];
		[(CCLabelBMFont*)[self getChildByTag:kTagLabel4] setString:str];
		
		if (nTime >= g_UserInfo.nScore) {
			str = [NSString stringWithFormat:@"%d", g_UserInfo.nScore];
			[[self getChildByTag:kTagLabel4] removeAllChildrenWithCleanup:YES];
			[(CCLabelBMFont*)[self getChildByTag:kTagLabel4] setString:str];
			fScore = YES; nNum++;
		}
	}
    
	if (!fFish) {
		if (slash_fishes.count <= 50)  nTime = nIdx;
		else if (slash_fishes.count > 50 && slash_fishes.count <= 200)  nTime = nIdx * 10;
		else nTime = nIdx * 100;
		
		str = [NSString stringWithFormat:@"%d", nTime];
		[[self getChildByTag:kTagLabel5] removeAllChildrenWithCleanup:YES];
		[(CCLabelBMFont*)[self getChildByTag:kTagLabel5] setString:str];
		
		if (nTime >= slash_fishes.count) {
			str = [NSString stringWithFormat:@"%d", slash_fishes.count];
			[[self getChildByTag:kTagLabel5] removeAllChildrenWithCleanup:YES];
			[(CCLabelBMFont*)[self getChildByTag:kTagLabel5] setString:str];
			fFish = YES; nNum++;
		}
	}
	
	if (!fMoney) {
		if (g_UserInfo.nMoney <= 50)  nTime = nIdx;
		else if (g_UserInfo.nMoney > 50 && g_UserInfo.nMoney <= 200)  nTime = nIdx * 10;
		else if (g_UserInfo.nMoney > 200 && g_UserInfo.nMoney <= 2000)  nTime = nIdx * 100;
		else nTime = nIdx * 1000;
		
		str = [NSString stringWithFormat:@"%d", nTime];
		[[self getChildByTag:kTagLabel6] removeAllChildrenWithCleanup:YES];
		[(CCLabelBMFont*)[self getChildByTag:kTagLabel6] setString:str];
		
		if (nTime >= g_UserInfo.nMoney) {
			str = [NSString stringWithFormat:@"%d", g_UserInfo.nMoney];
			[[self getChildByTag:kTagLabel6] removeAllChildrenWithCleanup:YES];
			[(CCLabelBMFont*)[self getChildByTag:kTagLabel6] setString:str];
			fMoney = YES; nNum++;
		}
		
	}
	
	if (!fTotal) {
		if (g_UserInfo.nTotalScore <= 50)  nTime = nIdx;
		else if (g_UserInfo.nTotalScore > 50 && g_UserInfo.nTotalScore <= 200)  nTime = nIdx * 10;
		else if (g_UserInfo.nTotalScore > 200 && g_UserInfo.nTotalScore <= 2000)  nTime = nIdx * 100;
		else nTime = nIdx * 1000;
		
		str = [NSString stringWithFormat:@"%d", nTime];
		[[self getChildByTag:kTagLabel7] removeAllChildrenWithCleanup:YES];
		[(CCLabelBMFont*)[self getChildByTag:kTagLabel7] setString:str];
		
		if (nTime >= g_UserInfo.nTotalScore) {
			str = [NSString stringWithFormat:@"%d", g_UserInfo.nTotalScore];
			[[self getChildByTag:kTagLabel7] removeAllChildrenWithCleanup:YES];
			[(CCLabelBMFont*)[self getChildByTag:kTagLabel7] setString:str];
			fTotal = YES; nNum++;
            
            NinjaFishingAppDelegate *delegate = [NinjaFishingAppDelegate sharedAppDelegate];
            delegate.gameScore = g_UserInfo.nTotalScore;
            [delegate submitScore];
		}
	}
	
	if (nNum > 3) {
		[self unschedule:@selector(loadScore)];
		if ([self loadFish] == NO) {
			CCLabelBMFont *label = [[CCLabelBMFont alloc] initWithString:@"NO NEW FISH FOUND" fntFile:@"Welltron40.fnt"];
			label.position = ccp(160 * g_fScaleX, 180 * g_fScaleY);
			label.scale = 0.5f * g_fScaleX;
			//[self addChild:label z:3 tag:kTagNoFish];
            [label release];
            
            
            CCSprite* noNewFish;
            noNewFish = [CCSprite spriteWithFile:[Tools imageNameForName:@"noNewCandies"]];
            
            noNewFish.anchorPoint = ccp(0.0f, 0.0f);
            [self addChild:noNewFish z:3 tag:kTagNoFish];
            noNewFish.position = ccp(83.0f, 230.0);
            
            if([Tools is4inchPhone])
            {
                noNewFish.position = ccp(83.0f, 270.0);
            }
		}
		else {
			[g_GameUtils playSoundEffect:@"newFish.wav"];
			[MainMenuScene saveUserInfo];
		}
		
		if (g_bSetup) {
			[self performSelector:@selector(loadMessage)];
			g_bSetup = NO;fMes = YES;
			
			for (int i = kTagGame; i < kTagf; i++) {
				[(CCMenuItemImage*)[[self getChildByTag:kTagMenu] getChildByTag:i] setIsEnabled:NO];
			}
		}
	}
	
	nIdx++;
}
-(void) loadMessage
{
	CCMenuItemImage *itemMess = [CCMenuItemImage itemFromNormalImage:@"use-gold.png" selectedImage:@"use-gold.png"
                                                              target:self selector:@selector(hidemess:)]; // modified by Song
	itemMess.scaleX = g_fScaleX; itemMess.scaleY = g_fScaleY;
	itemMess.position = ccp(160 * g_fScaleX, 155 * g_fScaleY); itemMess.tag = kTagMess;
	
	CCMenu *menuMess = [CCMenu menuWithItems:itemMess, nil];
	menuMess.position = ccp(0, 0);
    [self addChild:menuMess z:3 tag:kTagMessMenu];
	
    /*
     CCLabelTTF *lbl = [[CCLabelTTF alloc] initWithString:@"Spend your Gold to\nby Upgrades in the\nShop below!"
     dimensions:CGSizeMake(200, 100)
     alignment:CCTextAlignmentCenter
     fontName:@"American Typewriter"
     fontSize:20];
     lbl.position = ccp(itemMess.contentSize.width * 0.5f, itemMess.contentSize.height * 0.4f);
     [lbl setColor:ccBLACK];
     [itemMess addChild:lbl z:1 tag:kTagLabelTTF];
     [lbl release];
     */
    /*
     CCLabelBMFont* label = [[CCLabelBMFont alloc] initWithString:@"TAP TO CONTINUE" fntFile:@"Welltron40Yellow.fnt"];
     label.position = ccp(itemMess.contentSize.width / 2, itemMess.contentSize.height * 0.05f);
     label.scale = 0.8f;
     [itemMess addChild:label z:2 tag:kTagLabelBM];
     [label release];
     */
    
    CCLabelTTF* label = [[CCLabelTTF alloc] initWithString:@"TAP TO CONTINUE" fontName:@"BADABB_.TTF" fontSize:40.0f];
	label.position = ccp(itemMess.contentSize.width / 2, itemMess.contentSize.height * 0.05f);
	label.scale = 0.8f;
	[itemMess addChild:label z:2 tag:kTagLabelBM];
	[label release];
    
    
}

-(BOOL) loadFish
{
	if (slash_fishes.count == 0) return NO;
	int i, j ;
	if (g_UserInfo.nFishTypeNum == 0) {
		fishType[g_UserInfo.nFishTypeNum++] = ((FishSprite*)[slash_fishes objectAtIndex:0]).type;
		newfishType[nNewFishType++] = ((FishSprite*)[slash_fishes objectAtIndex:0]).type;
	}
    
	for (FishSprite *fish in slash_fishes) {
		for (i = 0; i < g_UserInfo.nFishTypeNum; i++) {
			if (fish.type == fishType[i]) break;
		}
		if (i == g_UserInfo.nFishTypeNum) {
			newfishType[nNewFishType++] = fish.type;
			for (j = g_UserInfo.nFishTypeNum; j > 0; j --) {
				if (fish.type < fishType[j - 1]) fishType[j] = fishType[j - 1];
				else  break;
			}
			
			fishType[j] = fish.type;
			g_UserInfo.nFishTypeNum++;
		}
	}
	
	if (nNewFishType > 0) {
		nFishType = nNewFishType - 1;
		
		FishSprite *fish = [[FishSprite alloc] initWithType:newfishType[nFishType] flip:NO];
		
		fish.scaleX = g_fScaleX * MIN(1.f, 221 * 0.8f / fish.contentSize.width);
		fish.scaleY = g_fScaleY * MIN(1.f, 93 * 0.6f / fish.contentSize.height);
		fish.position = ccp(g_size.width / 2, 207 * g_fScaleY);
		[self addChild:fish z:2 tag:kTagFish];
		
		CCLabelBMFont *label = [[CCLabelBMFont alloc] initWithString:[fish getString] fntFile:@"Welltron40.fnt"];
		label.position = ccp(146 * g_fScaleX, 98 * g_fScaleY);
		label.scale = 0.35f * g_fScaleX;
		//[self addChild:label z:2 tag:kTagFishString];
        [label release];
		
		str = [NSString stringWithFormat:@"%d~", [fish getScore]];
		label = [[CCLabelBMFont alloc] initWithString:str fntFile:@"Welltron40Yellow.fnt"];
		label.position = ccp(206 * g_fScaleX, 98 * g_fScaleY);
		label.scale = 0.35f * g_fScaleX;
		//[self addChild:label z:2 tag:kTagFishScore];[label release];
		
		label = [[CCLabelBMFont alloc] initWithString:@"NEW FISH!" fntFile:@"Welltron40Yellow.fnt"];
		label.position = ccp(160 * g_fScaleX, 185 * g_fScaleY);
		label.scale = 0.5f * g_fScaleX;
		//[self addChild:label z:3 tag:kTagNoFish];
        
        CCSprite* noNewFish;

        noNewFish = [CCSprite spriteWithFile:[Tools imageNameForName:@"NewCandies"]];
        
        noNewFish.anchorPoint = ccp(0.0f, 0.0f);
        [self addChild:noNewFish z:3 tag:kTagNoFish];
        noNewFish.position = ccp(83.0f, 230.0f);
        
        if([Tools is4inchPhone])
            noNewFish.position = ccp(83.0f, 270.0f);
		
		id act_scale = [CCScaleTo actionWithDuration:0.5f scaleX:g_fScaleX scaleY:g_fScaleY];
		id act_scale_reverse = [CCScaleTo actionWithDuration:0.2f  scaleX:0.75f * g_fScaleX scaleY:0.75f * g_fScaleX];
		[label runAction:[CCSequence actions:act_scale, act_scale_reverse, nil]];
		[label release];
		
		if(nNewFishType > 1){
			CCMenuItemImage *itemPre= [CCMenuItemImage itemFromNormalImage:@"fish-.png" selectedImage:@"fish-.png"
																	target:self selector:@selector(prev:)];
			itemPre.scaleX = g_fScaleX; itemPre.scaleY = g_fScaleY;
			itemPre.position = ccp(60 * g_fScaleX, 205 * g_fScaleY);
			itemPre.tag = kTagPre;
			
			CCMenuItemImage *itemNext = [CCMenuItemImage itemFromNormalImage:@"fish+.png" selectedImage:@"fish+.png"
																	  target:self selector:@selector(next:)];
			itemNext.scaleX = g_fScaleX; itemNext.scaleY = g_fScaleY;
			itemNext.position = ccp(260 * g_fScaleX, 205 * g_fScaleY);
			itemNext.tag = kTagNext;
			
			CCMenu *menu1 = [CCMenu menuWithItems:itemPre, itemNext, nil];
			menu1.position = ccp(0, 0); [self addChild:menu1 z:2 tag:kTagFishMenu];
		}
        
		return YES;
	}
	else return NO;
    
}
-(void) hidemess : (id) sender
{
	int i;

	[[self getChildByTag:kTagMessMenu] setVisible:FALSE];
	
	for (i = kTagGame; i <= 5; i++) {
		[(CCMenuItemImage*)[[self getChildByTag:kTagMenu] getChildByTag:i] setIsEnabled:YES];
	}
}
-(void) facebook : (id) sender
{
	//[soundEngine playEffect:@"button.wav"];
	[g_GameUtils playSoundEffect:@"button.wav"];
    NinjaFishingAppDelegate* appDelegate = (NinjaFishingAppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate PostScoreToFacebook];
}
-(void) prev : (id) sender
{
	//[soundEngine playEffect:@"button.wav"];
	[g_GameUtils playSoundEffect:@"button.wav"];
	
	if (nFishType == 0) return;
	nFishType --;
    
	[(FishSprite*)[self getChildByTag:kTagFish] releasefish];
	[(FishSprite*)[self getChildByTag:kTagFish] release];
    
	FishSprite *fish = [[FishSprite alloc] initWithType:newfishType[nFishType] flip:NO];
	fish.scaleX = g_fScaleX * MIN(1.f, 221 * 0.8f / fish.contentSize.width);
	fish.scaleY = g_fScaleY * MIN(1.f, 93 * 0.6f / fish.contentSize.height);
	fish.position = ccp(g_size.width / 2, 207 * g_fScaleY);
	[self addChild:fish z:2 tag:kTagFish];
	
    /*
     [[self getChildByTag:kTagFishString] removeAllChildrenWithCleanup:YES];
     [(CCLabelBMFont*)[self getChildByTag:kTagFishString] setString:[fish getString]];
     
     str = [NSString stringWithFormat:@"%d~", [fish getScore]];
     [[self getChildByTag:kTagFishScore] removeAllChildrenWithCleanup:YES];
     [(CCLabelBMFont*)[self getChildByTag:kTagFishScore] setString:str];
     */
}
-(void) next : (id) sender
{
	//[soundEngine playEffect:@"button.wav"];
	[g_GameUtils playSoundEffect:@"button.wav"];
	
	if (nFishType == nNewFishType - 1) return;
	nFishType++;
    
	[(FishSprite*)[self getChildByTag:kTagFish] releasefish];
	[(FishSprite*)[self getChildByTag:kTagFish] release];
    
	FishSprite *fish = [[FishSprite alloc] initWithType:newfishType[nFishType] flip:NO];
	
	fish.scaleX = g_fScaleX * MIN(1.f, 221 * 0.8f / fish.contentSize.width);
	fish.scaleY = g_fScaleY * MIN(1.f, 93 * 0.6f / fish.contentSize.height);
	fish.position = ccp(g_size.width / 2, 207 * g_fScaleY);
	[self addChild:fish z:2 tag:kTagFish];
	/*
     [[self getChildByTag:kTagFishString] removeAllChildrenWithCleanup:YES];
     [(CCLabelBMFont*)[self getChildByTag:kTagFishString] setString:[fish getString]];
     
     str = [NSString stringWithFormat:@"%d~", [fish getScore]];
     [[self getChildByTag:kTagFishScore] removeAllChildrenWithCleanup:YES];
     [(CCLabelBMFont*)[self getChildByTag:kTagFishScore] setString:str];
     */
}

-(void) OnGame : (id) sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
	if (fTrophies || fShop || fGame) {
		return;
	}
    
	fGame = YES;
	[(CCMenuItemImage*)[[self getChildByTag:kTagMenu] getChildByTag:kTagGame] setIsEnabled:NO];
	nTime = 0;
	[self performSelector:@selector(removeSlashFish)];
	[self performSelector:@selector(releaseObject) withObject:self afterDelay:0.6f];
    
	NSString *r = @"CCTransitionMoveInL";
	Class transion = NSClassFromString(r);
	[[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:0.5f scene:[GameScene scene]]];
}

-(void) OnShop : (id) sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
	if (fTrophies || fShop || fGame) {
		return;
	}
    
    fShop = YES;
    
	ShopScene1* layer_ShopScene = [[ShopScene1 alloc] init];
	layer_ShopScene.position = ccp(g_size.width, 0);
	[self addChild:layer_ShopScene];
    
	[self runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(-g_size.width, 0)]];
	[layer_ShopScene release];// layer_ShopScene = nil;
    
}

-(void) goTrophies : (id) sender
{
	if (fTrophies || fShop || fGame) {
		return;
	}
	
	[g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
	fTrophies = YES;
	
	Trophies* layer_Trophies = [[Trophies alloc] init];
	layer_Trophies.position = ccp(g_size.width, 0);
	[self addChild:layer_Trophies];
    
	[self runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(-g_size.width, 0)]];
	[layer_Trophies release];//layer_Trophies = nil;
}

-(void) removeSlashFish
{
	FishSprite *fish;
	
	if (slash_fishes) {
		while (slash_fishes.count > 0) {
			fish = [slash_fishes objectAtIndex:0];
			[slash_fishes removeObject:fish];
			[fish release];
		}
		
		[slash_fishes release]; slash_fishes = nil;
	}
}

-(void) releaseObject
{
	if ([self getChildByTag:kTagFish]) {
		[(FishSprite*)[self getChildByTag:kTagFish] releasefish];
		[(FishSprite*)[self getChildByTag:kTagFish] release];
	}
	
	int i;
	for (i = kTagLabel1; i <= kTagScoreBg; i++)
	{
		if ([self getChildByTag:i])
		{
			[[self getChildByTag:i] removeAllChildrenWithCleanup:YES];
			[[self getChildByTag:i] removeFromParentAndCleanup:YES];
		}
	}
	
	if ([self getChildByTag:kTagMenu]) {
		for (i = kTagGame; i <= kTagTrophies; i++) {
			[((CCMenuItemImage*)[[self getChildByTag:kTagMenu] getChildByTag:i]).normalImage removeFromParentAndCleanup:YES];
			[((CCMenuItemImage*)[[self getChildByTag:kTagMenu] getChildByTag:i]).selectedImage removeFromParentAndCleanup:YES];
		}
		
		[self removeAllChildrenWithCleanup:YES];
		[[self getChildByTag:kTagMenu] removeFromParentAndCleanup:YES];
	}
	
	if ([self getChildByTag:kTagShareMenu])
	{
		[((CCMenuItemImage*)[[self getChildByTag:kTagMenu] getChildByTag:kTagf]).normalImage removeFromParentAndCleanup:YES];
		[((CCMenuItemImage*)[[self getChildByTag:kTagMenu] getChildByTag:kTagf]).selectedImage removeFromParentAndCleanup:YES];
		[[self getChildByTag:kTagMenu] removeAllChildrenWithCleanup:YES];
		[[self getChildByTag:kTagShareMenu] removeFromParentAndCleanup:YES];
	}
	
	if ([self getChildByTag:kTagFishMenu]) {
		for (i = kTagPre; i <= kTagNext; i++) {
			[((CCMenuItemImage*)[[self getChildByTag:kTagMenu] getChildByTag:i]).normalImage removeFromParentAndCleanup:YES];
			[((CCMenuItemImage*)[[self getChildByTag:kTagMenu] getChildByTag:i]).selectedImage removeFromParentAndCleanup:YES];
		}
		[[self getChildByTag:kTagFishMenu] removeAllChildrenWithCleanup:YES];
		[[self getChildByTag:kTagFishMenu] removeFromParentAndCleanup:YES];
	}
	
	if ([self getChildByTag:kTagMessMenu]) {
		[[self getChildByTag:kTagMessMenu] removeFromParentAndCleanup:YES];
	}
	
	[self removeAllChildrenWithCleanup:YES];
	[self removeFromParentAndCleanup:YES];
	
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (void) dealloc
{
	[super dealloc];
}
@end
