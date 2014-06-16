//
//  ShopScene.m
//  NinjaFish
//
//  Created by Techintegrity Services on 9/11/11.
//  Copyright 2011 Techintegrity Services. All rights reserved.
//

#import "ShopScene.h"
#import "ScoreScene.h"

enum LINE {
	LINE200 = 150,
	LINE300 = 400,
	LINE400 = 1200,
	LINE500 = 2000,
	LINE600 = 3500,
	LINE800 = 5000
};

enum BLADE {
	BLADE0 = 1,
	BLADE1 = 2,
	BLADE2 = 6,
	BLADE3 = 12,
	BLADE4 = 20
};

enum FUEL {
	FUEL50 = 50,
	FUEL100 = 100,
	FUEL125 = 125,
	FUEL150 = 150,
	FUEL200 = 200
};

enum SPEED {
	SPEED0 = 0,
	SPEED25 = 50
};

enum SALE {
	SALE0 = 0,
	SALE10 = 10
};

enum MBA {
	MBA0 = 0,
	MBA25 = 25
};

enum LANTERN {
	LANTERN0 = 0,
	LANTERN500 = 500
};

enum HOOK{
	HOOK25 = 25,
	HOOK35 = 35,
	HOOK50 = 50
};

enum WEIGHT {
	WEIGHT0 = 0,
	WEIGHT30 = 30,
	WEIGHT90 = 90,
	WEIGHT190 = 190,
	WEIGHT290 = 290,
	WEIGHT390 = 390,
	WEIGHT490 = 490
};

CCMenuItemImage *item;
@implementation ShopScene
+(id) scene
{
	CCScene *scene = [CCScene node];
	ShopScene *layer = [ShopScene node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init] )) {
		self.isTouchEnabled = YES; m_bTouch = NO;

		CCSprite *bg = [[CCSprite alloc] initWithFile:@"bg_Shop0.jpg"];
		[bg setScaleX:g_fScaleX]; bg.scaleY = g_fScaleY;
		bg.position = ccp(g_size.width / 2, g_size.height / 2);
		[self addChild:bg z:-1 tag:4];
		[[CCTextureCache sharedTextureCache] removeTexture:[bg texture]];
		[bg release];
		
		CCSprite *bg1 = [[CCSprite alloc] initWithFile:@"bg_Shop1.png"];
		[bg1 setScaleX:g_fScaleX]; bg1.scaleY = g_fScaleY;
		bg1.position = ccp(g_size.width / 2, g_size.height / 2);
		[self addChild:bg1 z:1 tag:5];
		[[CCTextureCache sharedTextureCache] removeTexture:[bg1 texture]];
		[bg1 release];
		
		CCSprite *bg2 = [[CCSprite alloc] initWithFile:@"scroll.png"];
		[bg2 setScaleX:g_fScaleX]; bg2.scaleY = g_fScaleY;
		bg2.position = ccp(g_size.width / 2, 33 * g_fScaleY);
		[self addChild:bg2 z:2 tag:3];
		[[CCTextureCache sharedTextureCache] removeTexture:[bg2 texture]];
		[bg2 release]; 
		
		NSString *str = [NSString stringWithFormat:@"%d~", g_UserInfo.nMoney];
		CCLabelBMFont *label_Money = [[CCLabelBMFont alloc] initWithString:str fntFile:@"Welltron40.fnt"];
		label_Money.position = ccp(80 * g_fScaleX, 455 * g_fScaleY); 
		label_Money.scale = 0.5f * g_fScaleX;
		[self addChild:label_Money z:2 tag:2];[label_Money release];
		
		itemClose = [CCMenuItemImage itemFromNormalImage:@"closebutton.png" selectedImage:@"closebutton.png"
																  target:self selector:@selector(goScore:)];
		itemClose.scaleX = g_fScaleX; itemClose.scaleY = g_fScaleY;
		itemClose.position = ccp(254 * g_fScaleX, 450 * g_fScaleY);
		
		menu = [CCMenu menuWithItems:itemClose, nil];
		menu.position = ccp(0, 0); [self addChild:menu z:0 tag:0];
		
		CCSprite *sp; CCLabelBMFont *label;
		int i = 0;
		for ( ; i < SHOPITEM_COUNT ; i ++) {
			if (g_ITEMSTATE[i] == IMPOSIBLE) continue;
			
			item = [CCMenuItemImage itemFromNormalImage:@"bg_impositem.png" selectedImage:@"bg_impositem.png"
												 target:self selector:@selector(select:)];
			item.scaleX = g_fScaleX; item.scaleY = g_fScaleY;
			item.position = ccp(160 * g_fScaleX, (385 - nIdx * 65) * g_fScaleY);
			
			sp = [[CCSprite alloc] initWithFile:m_ShopItem[i].strFile];
			sp.position = ccp(item.contentSize.width * 0.105f, item.contentSize.height / 2);
			[item addChild:sp z:1 tag:1];[sp release];
			
			if (g_ITEMSTATE[i] == POSIBLE) sp = [[CCSprite alloc] initWithFile:@"bg_item.png"];
			else sp = [[CCSprite alloc] initWithFile:@"bg_selecteditem.png"];
			sp.position = ccp(item.contentSize.width / 2, item.contentSize.height / 2);
			[item addChild:sp z:0 tag:0];[sp release]; 

			label = [[CCLabelBMFont  alloc] initWithString:m_ShopItem[i].strTop fntFile:@"VAGRound48.fnt"];
			label.position = m_ShopItem[i].szTop;label.scaleX = 0.24f;label.scaleY = 0.35f;
			if(g_ITEMSTATE[i] == POSIBLE) label.color = ccYELLOW; 
			else  label.color = ccGRAY;
			[item addChild:label z:1 tag:3];[label release];
		
			label = [[CCLabelBMFont alloc] initWithString:@"~" fntFile:@"Welltron40.fnt"];
			label.position = m_ShopItem[i].szCoin;
			label.scale = 0.35f; 
			[item addChild:label z:1 tag:4];[label release];

			label = [[CCLabelBMFont alloc] initWithString:m_ShopItem[i].strBottom fntFile:@"VAGRound48.fnt"];
			label.position = m_ShopItem[i].szBottom;
			label.scaleX = 0.24f;label.scaleY = 0.35f;
			if(g_ITEMSTATE[i] != POSIBLE) label.color = ccGRAY; 
			[item addChild:label z:1 tag:5];[label release];

			sp = [[CCSprite alloc] initWithFile:@"soldmark.png"];
			sp.position = ccp(item.contentSize.width * 0.105f, item.contentSize.height / 2);
			if(g_ITEMSTATE[i] == POSIBLE) sp.visible = FALSE;
			[item addChild:sp z:2 tag:2]; [sp release];
			
			[menu addChild:item z:0 tag:i]; [item setIsEnabled:NO];
			m_ShopItem[i].nIdx = nIdx; szItemIndex[nIdx++] = i; 
		}
		
		for (i = 0 ; i < SHOPITEM_COUNT ; i ++) {
			if (g_ITEMSTATE[i] != IMPOSIBLE) continue;
			
			item = [CCMenuItemImage itemFromNormalImage:@"bg_impositem.png" selectedImage:@"bg_impositem.png"
												 target:self selector:@selector(select:)];
			item.scaleX = g_fScaleX; item.scaleY = g_fScaleY;
			item.position = ccp(160 * g_fScaleX, (385 - nIdx * 65) * g_fScaleY);
			
			sp = [[CCSprite alloc] initWithFile:m_ShopItem[i].strFile];
			sp.position = ccp(item.contentSize.width * 0.105f, item.contentSize.height / 2);
			[item addChild:sp z:1 tag:1]; [sp release];
			
			sp = [[CCSprite alloc] initWithFile:@"bg_item.png"];
			sp.position = ccp(item.contentSize.width / 2, item.contentSize.height / 2);
			sp.visible = FALSE; 
			[item addChild:sp z:0 tag:0];[sp release]; 

			label = [[CCLabelBMFont alloc] initWithString:m_ShopItem[i].strTop fntFile:@"VAGRound48.fnt"];
			label.position = m_ShopItem[i].szTop;label.scaleX = 0.24f;label.scaleY = 0.35f;
			label.color = ccGRAY; 
			[item addChild:label z:1 tag:3];[label release];
			
			label = [[CCLabelBMFont alloc] initWithString:@"~" fntFile:@"Welltron40.fnt"];
			label.position = m_ShopItem[i].szCoin;
			label.scale = 0.35f; 
			[item addChild:label z:1 tag:4];[label release];

			label = [[CCLabelBMFont alloc] initWithString:m_ShopItem[i].strImpos fntFile:@"VAGRound48.fnt"];
			label.position = m_ShopItem[i].szBottom;
			label.scaleX = 0.24f;label.scaleY = 0.35f;
			if(g_ITEMSTATE[i] != POSIBLE) label.color = ccGRAY; 
			[item addChild:label z:1 tag:5];[label release];

			sp = [[CCSprite alloc] initWithFile:@"lock.png"];
			sp.position = ccp(item.contentSize.width * 0.105f, item.contentSize.height / 2);
			if(g_ITEMSTATE[i] == POSIBLE) sp.visible = FALSE;
			[item addChild:sp z:2 tag:2]; [sp release];
			
			[menu addChild:item z:0 tag:i]; [item setIsEnabled:NO];
			m_ShopItem[i].nIdx = nIdx; szItemIndex[nIdx++] = i; 
		}
	}
	[[CCTextureCache sharedTextureCache] removeAllTextures];

	return self;
}

-(void) select:(id)sender
{
	if ([self getChildByTag:1]) return;
	item = (CCMenuItemImage*)sender;
	
	if(m_ShopItem[item.tag].nCost > g_UserInfo.nMoney) {
		[g_GameUtils playSoundEffect:@"buttonfalse.wav"];
		return;
	}
	
	if (g_ITEMSTATE[item.tag] == POSIBLE) {
		[g_GameUtils playSoundEffect:@"button.wav"];
		
		CCSprite *spBuy = [[CCSprite alloc] initWithFile:@"buy.png"];
		spBuy.scaleX = g_fScaleX; spBuy.scaleY = g_fScaleY;
		spBuy.position = ccp(g_size.width * 1.5f, g_size.height / 2);
		[self addChild:spBuy z:0 tag:1];
		
		CCSprite *spItem = [[CCSprite alloc] initWithFile:m_ShopItem[item.tag].strFile];
		spItem.position = ccp(spBuy.contentSize.width / 2, 175);
		[spBuy addChild:spItem z:0 tag:1];[spItem release];
		
		CCLabelBMFont *lbl = [[CCLabelBMFont alloc] initWithString:m_ShopItem[item.tag].strBuy fntFile:@"Welltron40.fnt"];
		lbl.position = ccp(spBuy.contentSize.width / 2, 280);
		lbl.scale = 0.5; lbl.color = ccWHITE; 
		[spBuy addChild:lbl z:0 tag:2];[lbl release];
		
		NSString *str = [NSString stringWithFormat:@"%d~", m_ShopItem[item.tag].nCost];
		lbl = [[CCLabelBMFont alloc] initWithString:str fntFile:@"Welltron40.fnt"];
		lbl.position = ccp(spBuy.contentSize.width / 2, 240); 
		lbl.scale = 0.5;
		[spBuy addChild:lbl z:0 tag:3];[lbl release];
		
		CCMenuItemImage *itemOk= [CCMenuItemImage itemFromNormalImage:@"ok.png" selectedImage:@"ok.png"
																 target:self selector:@selector(ok:)];
		itemOk.position = ccp(60, 60); itemOk.tag = 1;
		
		CCMenuItemImage *itemCancel = [CCMenuItemImage itemFromNormalImage:@"cancel.png" selectedImage:@"cancel.png"
																	  target:self selector:@selector(cancel:)];
		itemCancel.position = ccp(160, 60); itemCancel.tag = 2;
		
		CCMenu *menu1 = [CCMenu menuWithItems:itemOk, itemCancel, nil];
		menu1.position = ccp(0, 0); [spBuy addChild:menu1 z:0 tag:0];
		
		[menu runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(-g_size.width, 0)]];
		[spBuy runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(g_size.width / 2, g_size.height / 2)]];
		[spBuy release];
	}
	else {
		[g_GameUtils playSoundEffect:@"buttonfalse.wav"];
	}
}
- (void) dealloc
{
	[super dealloc];
}

-(void) updateInfo:(int)nItemTag
{
	if (nItemTag == LINE200_150) g_UserInfo.nMaxDepth = LINE200;
	else if (nItemTag == LINE300_400) g_UserInfo.nMaxDepth = LINE300;
	else if (nItemTag == LINE400_1200) g_UserInfo.nMaxDepth = LINE400;
	else if (nItemTag == LINE500_2000) g_UserInfo.nMaxDepth = LINE500;
	else if (nItemTag == LINE600_3500) g_UserInfo.nMaxDepth = LINE600;
	else if (nItemTag == LINE800_5000) g_UserInfo.nMaxDepth = LINE800;
	else if (nItemTag == BLADE1_250) g_UserInfo.nBlade = BLADE1;
	else if (nItemTag == BLADE2_1000) g_UserInfo.nBlade = BLADE2;
	else if (nItemTag == BLADE3_2500) g_UserInfo.nBlade = BLADE3;
	else if (nItemTag == BLADE4_4000) g_UserInfo.nBlade = BLADE4;
	else if (nItemTag == FUEL100_50) g_UserInfo.nFuel = FUEL100;
	else if (nItemTag == FUEL125_300) g_UserInfo.nFuel = FUEL125;
	else if (nItemTag == FUEL150_1000) g_UserInfo.nFuel = FUEL150;
	else if (nItemTag == FUEL200_2500) g_UserInfo.nFuel = FUEL200;
	else if (nItemTag == SPEED25_400) g_UserInfo.nSpeed = SPEED25;
	else if (nItemTag == SALE10_500) g_UserInfo.nSale = SALE10;
	else if (nItemTag == MBA25_2000) g_UserInfo.nSale = MBA25;
	else if (nItemTag == LANTERN500_1000) g_UserInfo.nLantern = LANTERN500;
	else if (nItemTag == HOOK35_500) g_UserInfo.nHook = HOOK35;
	else if (nItemTag == HOOK50_1500) g_UserInfo.nHook = HOOK50;
	else if (nItemTag == WEIGHT30_30) g_UserInfo.nWeight = WEIGHT30;
	else if (nItemTag == WEIGHT90_500) g_UserInfo.nWeight = WEIGHT90;
	else if (nItemTag == WEIGHT190_1000) g_UserInfo.nWeight = WEIGHT190;
	else if (nItemTag == WEIGHT290_2500) g_UserInfo.nWeight = WEIGHT290;
	else if (nItemTag == WEIGHT390_4000) g_UserInfo.nWeight = WEIGHT390;
	else if (nItemTag == WEIGHT490_6000) g_UserInfo.nWeight = WEIGHT490;

	g_UserInfo.nMoney -= m_ShopItem[nItemTag].nCost;
	
	NSString *str = [NSString stringWithFormat:@"%d~", g_UserInfo.nMoney];
	[[self getChildByTag:2] removeAllChildrenWithCleanup:YES];
	[(CCLabelBMFont*)[self getChildByTag:2] setString:str];
	
	[[self.parent getChildByTag:10] removeAllChildrenWithCleanup:YES];
	[(CCLabelBMFont*)[self.parent getChildByTag:10] setString:str];
   
}

@end
