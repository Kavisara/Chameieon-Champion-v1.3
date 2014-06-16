//
//  GameScene.m
//  NinjaFish
//
//  Created by Techintegrity Services on 9/9/11.
//  Copyright 2011 Techintegrity Services. All rights reserved.
//

#import "GameScene.h"
#import "MainMenuScene.h"
#import "ScoreScene.h"
#import "PauseGameSprite.h"
#import "FishSprite.h"
#import "NinjaFishingAppDelegate.h"
#import "Tools.h"

//CONSTANTS:
#define kBrushPixelStep		0.2

extern int m_nGameState;
extern int m_nCatchFishNum;
CCSprite *spShip[3];
CCSprite *spWave[3];

static NSString *message[] =
{
	@"FEED ME!",
	@"I WANT CANDY\nFOR DINNER!",
	@"GET GOODIES\nIN THE SHOP!",
	@"FISHIN`N TIME!\nCAST DEEP FOR\nMORE POINTS!",
	@"GET IN\nMY BELLY!",
	@"VISIT THE SHOP\nTO CAST DEEPER,\nAND CATCH MORE!",
};

enum TAG_MAIN {
	kTagMainMenu,	//0
	kTagPause,		//1
	kTagMoney,		//2
    kTagCoin,
	kTagLabelFuel,	//3
	kTagFuel,		//4
	kTagLabelCatchCount,	//5
	kTagCatchCount,	//6
	kTagDepth,		//7
	kTagMainBg,		//8
	kTagMainBg1,	//9
	kTagCloud1,		//10
	kTagCloud2,		//11
	kTagCloud3,		//12
	kTagCloud4,		//13
	kTagCloud5,		//14
	kTagCloud6,		//15
	kTagAnchor,		//16
	kTagWave1,		//17
	kTagWave2,		//18
	kTagWave3,		//19
	kTagShip1,		//20
	kTagShip2,		//21
	kTagShip3,		//22
	kTagMan0,		//23
	kTagMan1,		//24
	kTagMan2,		//25
	kTagMan3,		//26
	kTagMan4,		//27
	kTagMan5,		//28
	kTagMan6,		//29
	kTagMan7,		//30
	kTagMessage,	//31
	kTagFish1,		//32
	kTagFish2,		//33
	kTagFish3,		//34
	kTagLine0,		//35
	kTagLine,		//36
	kTagHook,		//37
	kTagDrill,		//38
	kTagMainBg2,
	kTagMainBg3
};

@implementation GameScene

+(id) scene
{
	CCScene *scene = [CCScene node];
	GameScene *layer = [GameScene node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init] )) {
		[[CCTextureCache sharedTextureCache] removeAllTextures];
        
		[g_GameUtils playBackgroundMusic:@"FishingMusic.wav"];
		
		fishes = [[NSMutableArray alloc] init];
		catched_fishes = [[NSMutableArray alloc] init];
		m_szWalls = [[NSMutableArray alloc] init];
		m_szMines = [[NSMutableArray alloc] init];
        
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		[self initGame];
		
        CCSprite *bgSprite1;

        bgSprite1 = [CCSprite spriteWithFile:[Tools imageNameForName:@"Background1"]];
        bgSprite1.scaleX = g_fScaleX;bgSprite1.scaleY = g_fScaleY;

        [self addChild:bgSprite1 z:-1 tag:kTagMainBg];
        bgSprite1.position = ccp(g_size.width / 2, g_size.height / 2);
        
        CCSprite *bgSprite2;
        bgSprite2 = [CCSprite spriteWithFile:[Tools imageNameForName:@"underwaterBG1"]];
        bgSprite2.scaleX = g_fScaleX;bgSprite2.scaleY = g_fScaleY;
        [self addChild:bgSprite2 z:-1 tag:kTagMainBg1];
        bgSprite2.position = ccp(g_size.width / 2, -300 * g_fScaleY);
        
        /*
		CCSprite *spAnchor = [[CCSprite alloc] initWithFile:@"anchor.png"];
		[spAnchor setScaleX:g_fScaleX]; spAnchor.scaleY = g_fScaleY;
		spAnchor.position = ccp(80 * g_fScaleX, -40 * g_fScaleY);
		[self addChild:spAnchor z:0 tag:kTagAnchor];
        spAnchor.visible = NO;[spAnchor release];
		*/
        [StaticClass saveToUserDefaults:@"man":@"CHARACTER"];
		[self loadTex];
		
        // modfified by Song.
        
		str = [[NSString alloc] initWithFormat:@"%d", g_UserInfo.nMoney];
		CCLabelTTF *label = [[CCLabelTTF alloc] initWithString:str fontName:@"BADABB_.TTF" fontSize:25.0f];
        label.color = ccc3(251, 0, 165);
        label.position = ccp(40 * g_fScaleX, 465 * g_fScaleY);
		//label.scale = 0.5f * g_fScaleX;
		[self addChild:label z:10 tag:kTagMoney];
		[label release];[str release];
        
		CCSprite *ccCoin = [[CCSprite alloc] initWithFile:@"coin.png"];
        ccCoin.position = ccp(70 * g_fScaleX, 465 * g_fScaleY);

		[self addChild:ccCoin z:10 tag:kTagCoin];
		[ccCoin release];
		
 		CCSprite* ccFuel = [[CCSprite alloc] initWithFile:@"fuel1.png"];
		ccFuel.position = ccp(25 * g_fScaleX, 15 * g_fScaleY);
        //label.color = ccc3(251, 0, 165);
		//label.scale = 0.5f * g_fScaleX;
		[self addChild:ccFuel z:10 tag:kTagLabelFuel];
		ccFuel.visible = NO;[ccFuel release];
        
		str = [[NSString alloc] initWithFormat:@"%d", g_UserInfo.nFuel];
		label = [[CCLabelTTF alloc] initWithString:str fontName:@"BADABB_.TTF" fontSize:25.0f];
		label.position = ccp(50 * g_fScaleX, 15 * g_fScaleY);
        label.color = ccc3(251, 0, 165);
		//label.scale = 0.5f * g_fScaleX;
		[self addChild:label z:10 tag:kTagFuel];
		label.visible = NO;	[label release]; [str release];
		
		label = [[CCLabelTTF alloc] initWithString:@"FISH COUNT" fontName:@"BADABB_.TTF" fontSize:25.0f];
		label.position = ccp(230 * g_fScaleX, 15 * g_fScaleY);
        label.color = ccc3(251, 0, 165);
		//label.scale = 0.5f * g_fScaleX;
		[self addChild:label z:10 tag:kTagLabelCatchCount];
		label.visible = NO;	[label release];
		
		str = [[NSString alloc] initWithFormat:@"%d", m_nCatchFishNum];
		label = [[CCLabelTTF alloc] initWithString:str fontName:@"BADABB_.TTF" fontSize:25.0f];
		label.position = ccp(285 * g_fScaleX, 15 * g_fScaleY);
        label.color = ccc3(251, 0, 165);
		//label.scale = 0.5f * g_fScaleX;
		[self addChild:label z:10 tag:kTagCatchCount];
		label.visible = NO;	[label release];[str release];
		
		str = [[NSString alloc] initWithFormat:@"%d/%dM", g_UserInfo.nCurDepth, g_UserInfo.nMaxDepth];
		label = [[CCLabelTTF alloc] initWithString:str fontName:@"BADABB_.TTF" fontSize:25.0f];
		label.position = ccp(g_size.width * 0.5f, 460 * g_fScaleY);
        label.color = ccc3(251, 0, 165);
		//label.scale = 0.75f * g_fScaleX;
		[self addChild:label z:10 tag:kTagDepth];
		label.visible = NO;	[label release];[str release];
        
        CCMenuItemImage *itemPause = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"pause"]
                                                            selectedImage:[Tools imageNameForName:@"pause"] target:self selector:@selector(pause:)];
        itemPause.anchorPoint = ccp(0.0, 1.0);
		itemPause.tag = 0;[itemPause setIsEnabled:NO];
        
        if(IS_IPAD())
        {
            itemPause.position = ccp(800, 173);
        }
        else if([Tools is4inchPhone])
        {
            itemPause.position = ccp(270, 560);
        }
        else
        {
            itemPause.position = ccp(270 * g_fScaleX, 470 * g_fScaleY);
        }
		
		CCMenu *menu = [CCMenu menuWithItems:itemPause, nil];
		menu.position = ccp(0, 0); [self addChild:menu z:10 tag:kTagMainMenu];
		
		//lines, points
		for (int i = 0; i < LINE_NUM; i ++) {
			m_spLine[i] = [[CCSprite alloc] initWithFile:@"line0.png"];
			[m_spLine[i] setPosition:ccp(-1000, -1000)];
			[m_spLine[i] setAnchorPoint:ccp(0, 0.5)];
			[m_spLine[i] setVisible:NO];
			[m_spLine[i] setScaleX:g_fScaleX * 0.3f];
			[m_spLine[i] setScaleY:g_fScaleY * 0.3f];
			//[self addChild:m_spLine[i]];[m_spLine[i] release]; //  modified by Song
			
			m_spPoint[i] = [[CCSprite alloc] initWithFile:@"point0.png"];
			[m_spPoint[i] setPosition:ccp(-1000, -1000)];
			[m_spPoint[i] setVisible:NO];
			[m_spPoint[i] setScale:g_fScaleX * 0.3f];
			//[self addChild:m_spPoint[i]];[m_spPoint[i] release]; // modified by Song
		}
		
		if (g_bSetup) {
			CCSprite *bg = [[CCSprite alloc] initWithFile:@"tap-to-fish.png"];  // modified by Song bg_message ---> tap-fo-fish
			[bg setScaleX:g_fScaleX*0.6f]; bg.scaleY = g_fScaleY*0.6f;
			bg.position = ccp(130 * g_fScaleX, 40 * g_fScaleY);
			bg.rotation = -10;bg.visible = NO;
			[self addChild:bg z:0 tag:kTagMessage];
			
            
			//label = [[CCLabelBMFont alloc] initWithString:@"TAP TO FISH!" fntFile:@"Welltron40Yellow.fnt"];
			//label.position = ccp(bg.contentSize.width / 2, bg.contentSize.height * 0.6f); // modified by Song.
			//[bg addChild:label z:2 tag:0];
			
			//[label release];
			[bg release];
		}
        
		[self schedule:@selector(loadCloud:) interval:0.15f];
		
		[[CCTextureCache sharedTextureCache] removeUnusedTextures];
		[[CCTextureCache sharedTextureCache] removeAllTextures];
	}
	
	return self;
}

-(void) initGame
{
	m_bTouch = YES; m_fTouch = YES;
	m_nGameState = GAME_START;
	m_nCatchFishNum = 0; m_nDepth = 0;
	m_nCurFuel = g_UserInfo.nFuel; g_UserInfo.nScore = 0;
	m_rSpeed = INTERVAL_CHANGEDEPTH * (100 - g_UserInfo.nSpeed) / 100;
}

-(void) loadTex
{
    // modified by song.
    /*
     for (int i = 0; i < 3; i++) {
     str = [[NSString alloc] initWithFormat:@"ship%d.png", i];
     spShip[i] = [[CCSprite alloc] initWithFile:str];[str release];
     [spShip[i] setScaleX:g_fScaleX]; spShip[i].scaleY = g_fScaleY;
     spShip[i].position = ccp(160 * g_fScaleX, -140 * g_fScaleY);
     [self addChild:spShip[i] z:3 tag:(kTagShip1 + i)];
     spShip[i].visible = NO;[spShip[i] release];
     
     str = [[NSString alloc] initWithFormat:@"wave%d.png", i];
     spWave[i] = [[CCSprite alloc] initWithFile:str];[str release];
     [spWave[i] setScaleX:g_fScaleX]; spWave[i].scaleY = g_fScaleY;
     spWave[i].position = ccp(160 * g_fScaleX, -148 * g_fScaleY);
     [self addChild:spWave[i] z:1 tag:(kTagWave1 + i)];
     spWave[i].visible = NO;[spWave[i] release];
     }*/
    
	//spWave[0].visible = YES; spShip[0].visible = YES;
    
	spMan[0] = [[CCSprite alloc] initWithFile:[NSString stringWithFormat:@"%@1.png",[StaticClass retrieveFromUserDefaults:@"CHARACTER"]]];
	//[spMan[0] setScaleX:g_fScaleX]; spMan[0].scaleY = g_fScaleY;
	//spMan[0].position = ccp(160 * g_fScaleX, -60 * g_fScaleY);
    spMan[0].position = ccp(140 * g_fScaleX, -80 * g_fScaleY);
    [self addChild:spMan[0] z:1 tag:kTagMan0];
	spMan[0].visible = NO;[spMan[0] release];
	
	spMan[1] = [[CCSprite alloc] initWithFile:[NSString stringWithFormat:@"%@2.png",[StaticClass retrieveFromUserDefaults:@"CHARACTER"]]];
	//[spMan[1] setScaleX:g_fScaleX]; spMan[1].scaleY = g_fScaleY;
	spMan[1].position = ccp(150 * g_fScaleX, 320 * g_fScaleY);
	[self addChild:spMan[1] z:1 tag:kTagMan1];
	spMan[1].visible = NO;[spMan[1] release];
    
	spMan[2] = [[CCSprite alloc] initWithFile:[NSString stringWithFormat:@"%@3.png",[StaticClass retrieveFromUserDefaults:@"CHARACTER"]]];
	//[spMan[2] setScaleX:g_fScaleX]; spMan[2].scaleY = g_fScaleY;
	spMan[2].position = ccp(140 * g_fScaleX, 240 * g_fScaleY);
	[self addChild:spMan[2] z:1 tag:kTagMan2];
	spMan[2].visible = NO;[spMan[2] release];
    
}

-(void) generateBomb : (int)idx
{
	FishSprite *fish = [[FishSprite alloc] initWithType:Bomb flip:(rand() % 2)];
	fish.position = ccp((50 + (rand() % 5) * 44) * g_fScaleX, -20 * g_fScaleY);
	//fish.scaleX = g_fScaleX ; fish.scaleY = g_fScaleY;
	
	int nIdx = MIN((idx + 1) * catched_fishes.count / (m_nBombNum + 1), catched_fishes.count);
	[catched_fishes insertObject:fish atIndex:nIdx];
	
	[self addChild:fish];
}

-(void) generateTreasure
{
    NSLog(@"Test");
    int nStart;int fish_type;
	
	srand(clock());

    fish_type =Treasure;
    
	FishSprite *fish = [[FishSprite alloc] initWithType:fish_type flip:(rand() % 2)];
	if (m_nGameState == GAME_TILTDOWN) {
        
		fish.position = ccp(10 * (rand() % (int)(g_size.width / 10)), -g_fScaleY * 10 * (rand() % 5));
	}
	else if(m_nGameState == GAME_DOWNSTOP)
	{
		int k = rand() % 2;
		float x;
		
		if (k == 0)  x = -fish.contentSize.width * 1.2f;
		else  x = g_size.width + fish.contentSize.width * 1.2f;
		fish.position = ccp(x, g_fScaleY * (rand() % 480));

	}
	else if(m_nGameState == GAME_TILTUP)
	{
		fish.position = ccp(20 * (rand() % (int)(g_size.width / 20)), g_size.height + g_fScaleY * 10 * (rand() % 5));

	}
	
	[fish startMove];
	if (m_nDepth >= 500) {
		[fish setOpacity:((CCSprite*)[self getChildByTag:kTagMainBg1]).opacity];
	}
	
	[fishes addObject:fish]; [self addChild:fish];
}
-(void) generateFish
{
	int nStart;int fish_type;
	
	srand(clock());
	
	if (m_nDepth < 1)  fish_type = 0;
	else if(m_nDepth >= 1 && m_nDepth < 5) {
		fish_type = rand() % 2;
	}
	else if(m_nDepth >= 5 && m_nDepth < 45) {
		fish_type = rand() % 6;
	}
	else {
		nStart = (int)((m_nDepth - 45) / 25);
		fish_type = nStart + (rand() % 8);
		if (fish_type >= FISHTYPE_NUM) {
			fish_type = FISHTYPE_NUM - 1;
		}
	}
    
    if(m_nDepth >= g_UserInfo.nMaxDepth*0.8)
        [self generateTreasure];

	FishSprite *fish = [[FishSprite alloc] initWithType:fish_type flip:(rand() % 2)];
	if (m_nGameState == GAME_TILTDOWN) {
        
		fish.position = ccp(10 * (rand() % (int)(g_size.width / 10)), -g_fScaleY * 10 * (rand() % 5));
		if(m_nDepth > g_UserInfo.nWeight)
			[fish schedule:@selector(generateBubble:) interval:2.f];
	}
	else if(m_nGameState == GAME_DOWNSTOP)
	{
		int k = rand() % 2;
		float x;
		
		if (k == 0)  x = -fish.contentSize.width * 1.2f;
		else  x = g_size.width + fish.contentSize.width * 1.2f;
        
		fish.position = ccp(x, g_fScaleY * (rand() % 480));
		[fish schedule:@selector(generateBubble:) interval:4.f];
	}
	else if(m_nGameState == GAME_TILTUP)
	{
		fish.position = ccp(20 * (rand() % (int)(g_size.width / 20)), g_size.height + g_fScaleY * 10 * (rand() % 5));
		if(m_nCatchFishNum < g_UserInfo.nHook)
			[fish schedule:@selector(generateBubble:) interval:6.f];
	}
	
	//fish.scaleX = g_fScaleX ; fish.scaleY = g_fScaleY;
	[fish startMove];
	if (m_nDepth >= 500) {
		[fish setOpacity:((CCSprite*)[self getChildByTag:kTagMainBg1]).opacity];
	}
	
	[fishes addObject:fish]; [self addChild:fish];
}
-(void) loadWall
{
	int wallCount = rand() % 2; int wallDir = rand() % 2;
	int wallType = rand() % 2; int wallDiff = rand() % 10;
	int i; CCSprite *spGrass; NSString *path;
	
	if (wallCount == 1 ) {
		CCSprite *spWall1 = [[CCSprite alloc] initWithFile:@"wall1.png"/*@"wall_0.png"*/]; // modified by Song
		CCSprite *spWall2 = [[CCSprite alloc] initWithFile:@"wall2.png"/*@"wall_1.png"*/]; // modified by Song
		
		if (m_nDepth < 250) {
			[spWall1 setScaleX:g_fScaleX/ 2]; spWall1.scaleY = g_fScaleY;
			[spWall2 setScaleX:g_fScaleX/ 2]; spWall2.scaleY = g_fScaleY;
		}
		else if(m_nDepth >= 250 && m_nDepth < 500){
			[spWall1 setScaleX:g_fScaleX * 0.75f]; spWall1.scaleY = g_fScaleY;
			[spWall2 setScaleX:g_fScaleX * 0.75f]; spWall2.scaleY = g_fScaleY;
		}
		else if(m_nDepth >= 500){
			[spWall1 setScaleX:g_fScaleX]; spWall1.scaleY = g_fScaleY;
			[spWall2 setScaleX:g_fScaleX]; spWall2.scaleY = g_fScaleY;
		}
		
		if (wallDir == 0) {
			spWall1.position = ccp(320 * g_fScaleX, -(260 + wallDiff * 10)* g_fScaleY);
			spWall2.position = ccp(0, -260 * g_fScaleY);
			spWall2.flipX = YES;
		}
		else {
			spWall2.position = ccp(320 * g_fScaleX, -260 * g_fScaleY);
			spWall1.position = ccp(0, -(260 + wallDiff * 10)* g_fScaleY);
			spWall1.flipX = YES;
		}
		
		if (m_nGameState == GAME_TILTUP) {
			spWall1.position = ccp(spWall1.position.x, g_size.height - spWall1.position.y);
			spWall2.position = ccp(spWall2.position.x, g_size.height - spWall2.position.y);
		}
		
		if (wallDiff < 5) wallDiff = 5;
		for (i = 0; i < wallDiff; i++) {
			path = [[NSString alloc] initWithFormat:@"bubble%d.png", (rand() % 3) + 1];
			spGrass = [[CCSprite alloc] initWithFile:path]; [path release];
			
			if (wallDir == 0) {
				spGrass.position = ccp(320 * CCRANDOM_0_1(),
									   480 * CCRANDOM_0_1());
			}
			else {
				spGrass.position = ccp(320 * CCRANDOM_0_1(),
									   480 * CCRANDOM_0_1());
			}
			//[spWall1 addChild:spGrass]; [spGrass release];
		    [m_szWalls addObject:spGrass];[self addChild:spGrass z:0];
            
			path = [[NSString alloc] initWithFormat:@"bubble%d.png", (rand() % 3) + 1];
			spGrass = [[CCSprite alloc] initWithFile:path];[path release];
			
			if (wallDir == 0) {
				spGrass.position = ccp(spWall2.contentSize.width  * (0.4f + CCRANDOM_0_1() / 4),
									   spWall2.contentSize.height * CCRANDOM_0_1());
			}
			else {
				spGrass.position = ccp(spWall2.contentSize.width * (0.3f + CCRANDOM_0_1() / 4),
									   spWall2.contentSize.height * CCRANDOM_0_1());
			}
			//[spWall2 addChild:spGrass]; [spGrass release];
            [m_szWalls addObject:spGrass];[self addChild:spGrass z:0];
		}
		
		if (m_nDepth >= 500) {
			//[spWall1 setOpacity:((CCSprite*)[self getChildByTag:9]).opacity];
			//[spWall2 setOpacity:((CCSprite*)[self getChildByTag:9]).opacity];
		}
		
		//[m_szWalls addObject:spWall2];[self addChild:spWall2 z:0];
		//[m_szWalls addObject:spWall1];[self addChild:spWall1 z:0];
	}
	else if (wallCount == 0 ) {
		CCSprite *spWall;
		if (wallType == 0) {
			spWall = [[CCSprite alloc] initWithFile:@"wall1.png"];  // modified by Song wall_0.png --> wall0.png
		}
		else {
			spWall = [[CCSprite alloc] initWithFile:@"wall2.png"];  // modified by Song wall_1.png --> wall1.png
		}
		
		if (wallDir == 0) {
			spWall.position = ccp(320 * g_fScaleX, -260 * g_fScaleY);
		}
		else {
			spWall.position = ccp(0, -260 * g_fScaleY);
			spWall.flipX = YES;
		}
		
		if (wallDiff < 4) wallDiff = 4;
		for (i = 0; i < wallDiff; i++) {
			path = [[NSString alloc] initWithFormat:@"bubble%d.png", (rand() % 3) + 1];
			spGrass = [[CCSprite alloc] initWithFile:path];[path release];
			
			if (wallDir == 0) {
				spGrass.position = ccp(320 * CCRANDOM_0_1(),       // modified by Song  (0.3f + CCRANDOM_0_1() / 4 --->  CCRANDOM_0_1()
									   480 * CCRANDOM_0_1());
			}
			else {
				spGrass.position = ccp(320  * CCRANDOM_0_1(),  // modified by Song  (0.4f + CCRANDOM_0_1() / 4 --->  CCRANDOM_0_1()
									   480 * CCRANDOM_0_1());
			}
			//[self/*spWall*/ addChild:spGrass]; [spGrass release];
		}
		
		if (m_nDepth < 450) {
			//[spWall setScaleX:g_fScaleX/ 2]; spWall.scaleY = g_fScaleY;
            [spGrass setScaleX:g_fScaleX/ 2]; spGrass.scaleY = g_fScaleY;
		}
		else if(m_nDepth >= 450 && m_nDepth < 500){
			float rate = 0.5f + (m_nDepth - 400) / 100;
			//[spWall setScaleX:g_fScaleX * rate]; spWall.scaleY = g_fScaleY;
            [spGrass setScaleX:g_fScaleX * rate]; spGrass.scaleY = g_fScaleY;
		}
		else if(m_nDepth >= 500){
			//[spWall setScaleX:g_fScaleX]; spWall.scaleY = g_fScaleY;
            [spGrass setScaleX:g_fScaleX]; spGrass.scaleY = g_fScaleY;
		}
		
		if (m_nGameState == GAME_TILTUP) {
			//spWall.position = ccp(spWall.position.x, g_size.height - spWall.position.y);
            spGrass.position = ccp(spGrass.position.x, g_size.height - spGrass.position.y);
		}
		
		if (m_nDepth >= 500) {
			//[spWall setOpacity:((CCSprite*)[self getChildByTag:kTagMainBg1]).opacity];
            [spGrass setOpacity:((CCSprite*)[self getChildByTag:kTagMainBg1]).opacity];
		}
		//[m_szWalls addObject:spWall]; [self addChild:spWall z:0];
        [m_szWalls addObject:spGrass]; [self addChild:spGrass z:0];
	}
}
-(void) generateMine
{
	if (m_nGameState != GAME_TILTDOWN && m_nGameState != GAME_TILTUP) {
		return;
	}
	NSString *path = [[NSString alloc] initWithFormat:@"mine%d.png", 1 + (rand() % 3)];
	CCSprite *mine = [[CCSprite alloc] initWithFile:path];[path release];
	mine.scaleX = g_fScaleX; mine.scaleY = g_fScaleY;
	
	if (m_nGameState == GAME_TILTDOWN) {
		if ((rand()%2) == 0) {
			mine.position = ccp(40 * g_fScaleX, -64 * g_fScaleY);
		}
		else {
			mine.position = ccp(280 * g_fScaleX, -64 * g_fScaleY);
		}
	}
	
	if (m_nGameState == GAME_TILTUP) {
		if ((rand()%2) == 0) {
			mine.position = ccp(40 * g_fScaleX, 544 * g_fScaleY);
		}
		else {
			mine.position = ccp(280 * g_fScaleX, 544 * g_fScaleY);
		}
	}
	[m_szMines addObject:mine]; [self addChild:mine z:2];
}

#pragma mark action
-(void) loadCloud:(ccTime)dt
{
	int x, y, i;
	int between =80;
    
	for (i = kTagCloud1; i <= kTagCloud6; i++) {
		x = [self getChildByTag:i].position.x;
		y = [self getChildByTag:i].position.y;
		[self getChildByTag:i].position = ccp(x, (y / g_fScaleY + MOVELENGTH) * g_fScaleY);
	}
	
	if (m_nTick >= 6) {
		for (i = kTagAnchor; i < kTagMan1; i++) {
			[self getChildByTag:i].visible = YES;
			x = [self getChildByTag:i].position.x;
			y = [self getChildByTag:i].position.y;
			[self getChildByTag:i].position = ccp(x, (y / g_fScaleY + MOVELENGTH) * g_fScaleY);
		}
		
		if (g_bSetup) {
			[self getChildByTag:kTagMessage].visible = YES;
			x = [self getChildByTag:kTagMessage].position.x;
			y = [self getChildByTag:kTagMessage].position.y;
			[self getChildByTag:kTagMessage].position = ccp(x, (y / g_fScaleY + MOVELENGTH) * g_fScaleY);
		}
	}
	
	if (m_nTick == 8)
	{
		int nFishType; CCSprite* fish;
		for (i = 0; i < 3; i++) {
			nFishType = rand() % 4;
			if(nFishType == YellowMinnow)
				fish = [[CCSprite alloc] initWithFile:@"candy02.png"];
			else if(nFishType == RedMinnow)
				fish = [[CCSprite alloc] initWithFile:@"candy37.png"];
			else if(nFishType == RainbowFish)
				fish = [[CCSprite alloc] initWithFile:@"candy51.png"];
			else  fish = [[CCSprite alloc] initWithFile:@"candy43.png"];
			
			fish.scaleX = g_fScaleX; fish.scaleY = g_fScaleY;
			if (rand() % 2 == 0) fish.flipX = YES;
			fish.position = ccp (rand() % 32 * 10 * g_fScaleX, -rand() % 5 * 10 * g_fScaleY);
			[self addChild:fish z:0 tag:(kTagFish1 + i)];
			[fish release];
		}
		
		for (i = kTagMainBg; i <= kTagMainBg1; i++) {
			x = [self getChildByTag:i].position.x;
			y = [self getChildByTag:i].position.y;
            
			if(i == kTagMainBg && UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
                between = 50;
            else
                between = 80;
            
            [self getChildByTag:i].position = ccp(x, y + between * g_fScaleY);
		}
	}
	
	if (++ m_nTick > 9) {
		[self unschedule:@selector(loadCloud:)];
		
		for (i = kTagMainBg; i <= kTagMainBg1; i++) {
			x = [self getChildByTag:i].position.x;
			y = [self getChildByTag:i].position.y;
			if(i == kTagMainBg && UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
                between = 50;
            else
                between = 80;
            
            [self getChildByTag:i].position = ccp(x, y + between * g_fScaleY);
		}
		
		CCSprite* fish;
		for (i = kTagFish1; i <= kTagFish3 ; i++) {
			fish = (CCSprite*)[self getChildByTag:i];
			x = fish.position.x;
			y = (fish.position.y / g_fScaleY + MOVELENGTH) * g_fScaleY;
			fish.position = ccp(x, y);
		}
		
		[self schedule:@selector(actionMove)];
		
		[(CCMenuItemImage*)[[self getChildByTag:kTagMainMenu] getChildByTag:0] setIsEnabled:YES];
		m_nTick = 0; m_nGameState = GAME_TAPFIRST;
		m_bTouch = NO;m_fTouch = NO;
		
		for (i = 0; i < 3; i++) {
			[self performSelector:@selector(removeOther:) withObject:[self getChildByTag:(kTagCloud1 + i)]];
		}
    
		[self schedule:@selector(swing:) interval:0.15f];
		
		if (!g_bSetup) {
            
            int n = rand() % MESSAGE_COUNT;
            NSString* strPath = [NSString stringWithFormat:@"bg_message_%d.png",n];
			CCSprite *bg = [[CCSprite alloc] initWithFile:strPath];
			[bg setScaleX:g_fScaleX]; bg.scaleY = g_fScaleY;
			bg.position = ccp(140 * g_fScaleX, 380 * g_fScaleY);
			
			[self addChild:bg z:2 tag:kTagMessage]; [bg release];
		}
	}
}

-(void)actionMove
{
	CCSprite *moveFish;
	for (int i = kTagFish1; i <= kTagFish3; i++) {
		moveFish = (CCSprite*)[self getChildByTag:i];
		
		if (moveFish.flipX) {
			moveFish.position = ccp(moveFish.position.x + nStepDepth * g_fScaleX, moveFish.position.y);
			if (moveFish.position.x >= 320) {
				moveFish.flipX = NO;
			}
		}
		else {
			moveFish.position = ccp(moveFish.position.x - nStepDepth * g_fScaleX, moveFish.position.y);
			if (moveFish.position.x <= 0) {
				moveFish.flipX = YES;
			}
		}
	}
}

-(void) loadTapMes
{
	float x, y; int i; CCSprite *sp;
	
	for (i = kTagMainBg; i < kTagLine; i++) {
		sp = (CCSprite*)[self getChildByTag:i];
		if (sp) {
			if (i == kTagMessage) {
				sp.visible = NO;
				sp.position = ccp(g_size.width / 2, 320 * g_fScaleY);
				continue;
			}
			x = sp.position.x;
			y = sp.position.y;
            
			[sp runAction:[CCMoveTo actionWithDuration:1.f position:ccp(x, (y / g_fScaleY + 190) * g_fScaleY)]];
		}
	}
	
	[self performSelector:@selector(showMessage) withObject:self afterDelay:1.f];
	
	x = spLine.position.x;
	y = spLine.position.y;
	[spLine runAction:[CCSpawn actions:[CCScaleTo actionWithDuration:1.f scaleX:g_fScaleX scaleY:g_fScaleY * 1.2f],
					   [CCMoveTo actionWithDuration:1.f position:ccp(x, (y / g_fScaleY + 202) * g_fScaleY)], nil]];
	[spDrill runAction:[CCMoveTo actionWithDuration:1.f position:ccp(x, 165 * g_fScaleY)]];
	x = spHook.position.x;
	[spHook runAction:[CCMoveTo actionWithDuration:1.f position:ccp(x, 190 * g_fScaleY)]];
	
	if (!g_bSetup)  return;
	
	CCSprite *spMes = [[CCSprite alloc] initWithFile:@"tilt-avoid-fishes.png"]; // modifiled by Song bg_message1.png -->  tilt-avoid-fished.png
	spMes.position = ccp(spLine.contentSize.width / 2, spLine.contentSize.height * 0.9f);
	spMes.rotation = 180;
	
   	[spLine addChild:spMes z:0 tag:2];
	spMes.visible = NO; [spMes release];
	
	m_nTime = 0;
	[self schedule:@selector(hintMessage:) interval:INTERVAL_CHANGEDEPTH];
	[self performSelector:@selector(changeMessage:) withObject:[self getChildByTag:kTagMessage] afterDelay:2.f];
}

-(void) moveWall
{
	int i; CCSprite* wall;
	
	int nStep = nStepDepth * (100 + g_UserInfo.nSpeed) / 100;
	
	if (m_nGameState == GAME_TILTUP) {
		for (i = 0; i < m_szWalls.count; i++) {
			wall = (CCSprite*)[m_szWalls objectAtIndex:i];
			
			if (wall.position.y <= -2600 * g_fScaleY) {
				[m_szWalls removeObjectAtIndex:i];
				[wall removeAllChildrenWithCleanup:YES];
				[self removeChild:wall cleanup:YES];
				[wall release]; i--;
			}
			else {
				if (m_nCatchFishNum >= g_UserInfo.nHook) {
					wall.position = ccp(wall.position.x, (wall.position.y / g_fScaleY - nStep * MOVE_SCALE / INTERVAL_WEIGHT ) * g_fScaleY);
				}
				else wall.position = ccp(wall.position.x, (wall.position.y / g_fScaleY - nStep) * MOVE_SCALE * g_fScaleY);
			}
		}
	}
	else if (m_nGameState == GAME_TILTDOWN) {
		if (m_szWalls) {
			for (i = 0; i < m_szWalls.count; i++) {
				wall = (CCSprite*)[m_szWalls objectAtIndex:i];
				if (wall.position.y >= 7400 * g_fScaleY) {
					[m_szWalls removeObjectAtIndex:i];
					[wall removeAllChildrenWithCleanup:YES];
					[self removeChild:wall cleanup:YES];
					[wall release];i--;
				}
				else {
					if (m_nDepth < g_UserInfo.nWeight) {
						wall.position = ccp(wall.position.x, (wall.position.y / g_fScaleY + nStep / INTERVAL_WEIGHT ) * g_fScaleY);
					}
					else wall.position = ccp(wall.position.x, (wall.position.y / g_fScaleY + nStep) * g_fScaleY);
				}
			}
		}
	}
}
-(void) moveMine
{
	int i; CCSprite* mine;
	int nStep = nStepDepth * (100 + g_UserInfo.nSpeed) / 100;
	
	if (m_nGameState == GAME_TILTUP) {
		for (i = 0; i < m_szMines.count; i++) {
			mine = (CCSprite*)[m_szMines objectAtIndex:i];
			
			if (mine.position.y <= -64 * g_fScaleY) {
				[m_szMines removeObjectAtIndex:i];
				[self removeChild:mine cleanup:YES];
				[mine release];i--;
			}
			else {
				mine.position = ccp(mine.position.x, (mine.position.y / g_fScaleY - nStep * MOVE_SCALE) * g_fScaleY);
			}
		}
	}
	else if (m_nGameState == GAME_TILTDOWN) {
		if (m_szMines) {
			for (i = 0; i < m_szMines.count; i++) {
				mine = (CCSprite*)[m_szMines objectAtIndex:i];
				if (mine.position.y >= 550 * g_fScaleY) {
					[m_szMines removeObjectAtIndex:i];
					[self removeChild:mine cleanup:YES];
					[mine release];i--;
				}
				else {
					if (m_nDepth < g_UserInfo.nWeight) {
						mine.position = ccp(mine.position.x, (mine.position.y / g_fScaleY + nStep / INTERVAL_WEIGHT ) * g_fScaleY);
					}
					else mine.position = ccp(mine.position.x, (mine.position.y / g_fScaleY + nStep) * g_fScaleY);
				}
			}
		}
	}
}
-(void) moveBg
{
	int y;
	if (m_nGameState == GAME_TILTUP)
	{
		y = ((CCSprite*)[self getChildByTag:kTagMainBg1]).position.y;
		if (y <= g_size.height / 2) {
			((CCSprite*)[self getChildByTag:kTagMainBg1]).position = ccp(g_size.width / 2, g_size.height / 2 );
			[self unschedule:@selector(moveBg)];
			[[CCTextureCache sharedTextureCache] removeTexture:[(CCSprite*)[self getChildByTag:kTagMainBg2] texture]];
			[self removeChildByTag:kTagMainBg2 cleanup:YES];
			return;
		}
		
		((CCSprite*)[self getChildByTag:kTagMainBg1]).position = ccp(g_size.width / 2,
																	 y  - nStepDepth * MOVE_SCALE  * g_fScaleY);
		
		y = ((CCSprite*)[self getChildByTag:kTagMainBg2]).position.y;
		((CCSprite*)[self getChildByTag:kTagMainBg2]).position = ccp(g_size.width / 2,
																	 y - nStepDepth * MOVE_SCALE  * g_fScaleY);
	}
	else if (m_nGameState == GAME_TILTDOWN)
	{
		y = ((CCSprite*)[self getChildByTag:kTagMainBg2]).position.y;
		if (y >= g_size.height / 2) {
			((CCSprite*)[self getChildByTag:kTagMainBg1]).position = ccp(g_size.width / 2, g_size.height * 1.5f - 30 * g_fScaleY);
			((CCSprite*)[self getChildByTag:kTagMainBg2]).position = ccp(g_size.width / 2, g_size.height / 2);
			[self unschedule:@selector(moveBg)];
			return;
		}
		
		((CCSprite*)[self getChildByTag:kTagMainBg2]).position = ccp(g_size.width / 2,
																	 (y / g_fScaleY + nStepDepth) * g_fScaleY);
        
		y = ((CCSprite*)[self getChildByTag:kTagMainBg1]).position.y;
		((CCSprite*)[self getChildByTag:kTagMainBg1]).position = ccp(g_size.width / 2,
																	 (y / g_fScaleY + nStepDepth) * g_fScaleY);
        
	}
}

-(void) swing:(ccTime)dt
{
	int j = m_nTick % 3;
	[self getChildByTag:kTagAnchor].rotation = -j * 3;
    
	for (int i = 0; i < 3; i++) {
		if (i == j)  {
			[self getChildByTag:(kTagShip1 + i)].visible = YES;
			[self getChildByTag:(kTagWave1 + i)].visible = YES;
		}
		else {
			[self getChildByTag:(kTagShip1 + i)].visible = NO;
			[self getChildByTag:(kTagWave1 + i)].visible = NO;
		}
	}
	m_nTick ++;
}

-(void) hintMessage : (ccTime) dt
{
    /*
     int k = m_nTime % 2; int i;
     
     for (i = 0; i < 3; i++) {
     spHelpTilt[i].visible = NO;
     }
     for (i = 0; i < 2; i++) {
     spHelpTap[i].visible = NO;
     spHelpSlash[i].visible = NO;
     }
     
     if ((m_nGameState == GAME_TAPSECOND) || (m_nGameState == GAME_TAPFOURTH)) {
     spHelpTilt[m_nTime % 3].visible = YES;
     }
     else if (m_nGameState == GAME_TAPTHIRD) {
     spHelpTap[k].visible = YES;
     }
     else if (m_nGameState == GAME_TAPFIFTH) {
     spHelpSlash[k].visible = YES;
     }
     
     if (k == 0) [[self getChildByTag:kTagMessage] getChildByTag:1].visible = YES;
     else {
     [[self getChildByTag:kTagMessage] getChildByTag:1].visible = NO;
     }
     
     m_nTime++;
     */
    
	int k = m_nTime % 2; int i;
    
	for (i = 0; i < 3; i++) {
		spHelpTilt[i].visible = NO;
	}
	for (i = 0; i < 2; i++) {
		spHelpTap[i].visible = NO;
		spHelpSlash[i].visible = NO;
	}
	
	if ((m_nGameState == GAME_TAPSECOND) || (m_nGameState == GAME_TAPFOURTH)) {
		spHelpTilt[m_nTime % 3].visible = NO;
	}
	else if (m_nGameState == GAME_TAPTHIRD) {
		spHelpTap[k].visible = NO;
	}
	else if (m_nGameState == GAME_TAPFIFTH) {
		spHelpSlash[k].visible = NO;
	}
	
	if (k == 0) [[self getChildByTag:kTagMessage] getChildByTag:1].visible = YES;
	else {
		[[self getChildByTag:kTagMessage] getChildByTag:1].visible = NO;
	}
	
	m_nTime++;
    
}

-(void) throw:(ccTime)dt
{
	if (m_nTime < 3/*7*/) { // modified by Song
		spMan[m_nTime++].visible = NO;
		spMan[m_nTime].visible = YES;
	}
	else if (m_nTime < 5 /*9*/ && m_nTime >= 3/*7*/ ) {
		int x, y, i;
		CCSprite *sp;
		for (i = kTagMainBg; i <= kTagLine0; i++) {
			sp = (CCSprite*)[self getChildByTag:i];
			x = sp.position.x;
			y = sp.position.y;
			sp.position = ccp(x, (y / g_fScaleY + MOVELENGTH) * g_fScaleY);
		}
		
		[self getChildByTag:kTagLine0].rotation += 40;
		
		if (m_nTime == 3 /*7*/ ) {
			[g_GameUtils playSoundEffect:@"hookHittingwater.wav"];
			
			spMan[0].visible = YES;
			for (i = 1; i <= 2/*3*/ /*7*/; i++) {
				[self performSelector:@selector(removeOther:) withObject:spMan[i]];
			}
			
			[self getChildByTag:kTagShip1].visible = YES;
			[self getChildByTag:kTagWave1].visible = YES;
			[self performSelector:@selector(removeOther:) withObject:[self getChildByTag:kTagShip2]];
			[self performSelector:@selector(removeOther:) withObject:[self getChildByTag:kTagShip3]];
			[self performSelector:@selector(removeOther:) withObject:[self getChildByTag:kTagWave2]];
			[self performSelector:@selector(removeOther:) withObject:[self getChildByTag:kTagWave3]];
			
			[self getChildByTag:kTagLabelFuel].visible = YES;
			[self getChildByTag:kTagFuel].visible = YES;
			[self getChildByTag:kTagDepth].visible = YES;
			[self getChildByTag:kTagLine0].visible = YES;
			[self getChildByTag:kTagLine0].scaleY = g_fScaleY;
            
			[fishes removeAllObjects];
			[catched_fishes removeAllObjects];
			[self schedule:@selector(generateFish) interval:nInterval_generatefish];
		}
		
		m_nTime++;
	}
	else {
		[self unschedule:@selector(throw:)]; m_nTime = 0;
		[self getChildByTag:kTagLine0].rotation += 20;
		[self performSelector:@selector(removeOther:) withObject:[[self getChildByTag:kTagLine0] getChildByTag:0]];
		
		spLine = [[CCSprite alloc] initWithFile:@"hookline.png"];
		spLine.scaleX = g_fScaleX; spLine.scaleY = g_fScaleY ;
		spLine.anchorPoint = ccp(0, 0);spLine.rotation = 180; spLine.scaleY = g_fScaleY/3;
		[self addChild:spLine z:0 tag:kTagLine];
		[spLine release];
		
		spHook = [[CCSprite alloc] initWithFile:@"hook.png"];
		spHook.scaleX = g_fScaleX / 1.2f; spHook.scaleY = g_fScaleY / 1.2f;
		[self addChild:spHook z:0 tag:kTagHook];
		[spHook release];
		
		spDrill = [[CCSprite alloc] initWithFile:@"drill1.png"]; // modified by Song
		spDrill.scaleX = g_fScaleX;	spDrill.scaleY = g_fScaleY;
		[self addChild:spDrill z:0 tag:kTagDrill];
		spDrill.visible = NO;[spDrill release];
		
		if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            
            if([Tools is4inchPhone])
            {
                spLine.position = ccp(200 * g_fScaleX, 278  * g_fScaleY);
                spHook.position = ccp(195 * g_fScaleX, 190 * g_fScaleY);
                spDrill.position = ccp(200 * g_fScaleX, 190 * g_fScaleY);
            }else{
                spLine.position = ccp(209 * g_fScaleX, 278  * g_fScaleY);
                spHook.position = ccp(205 * g_fScaleX, 190 * g_fScaleY);
                spDrill.position = ccp(209 * g_fScaleX, 190 * g_fScaleY);
            }

		}
		else {
			spLine.position = ccp(213 * g_fScaleX, 278  * g_fScaleY);
			spHook.position = ccp(209 * g_fScaleX, 190 * g_fScaleY);
			spDrill.position = ccp(213 * g_fScaleX, 190 * g_fScaleY);
		}
		
		if (g_bSetup) {
			CCSprite *spMes = [[CCSprite alloc] initWithFile:@"tilt-the-device.png"]; // modified by Song. bg_message0 ---> tilt-the-device
			[spMes setScaleX:g_fScaleX]; spMes.scaleY = g_fScaleY;
			spMes.position = ccp(145 * g_fScaleX, 155 * g_fScaleY);
			
            
			for (int i = 0; i < 3; i++) {
				if (i < 2) {
					str = [[NSString alloc] initWithFormat:@"helpTap%d.png", i];
					spHelpTap[i] = [[CCSprite alloc] initWithFile:str];[str release];
					spHelpTap[i].position = ccp(spMes.contentSize.width / 3, spMes.contentSize.height * 1.3f);
					spHelpTap[i].visible = NO;
                    [spMes addChild:spHelpTap[i] z:0];
                    [spHelpTap[i] release];
					
					str = [[NSString alloc] initWithFormat:@"helpSlash%d.png", i];
					spHelpSlash[i] = [[CCSprite alloc] initWithFile:str];[str release];
					spHelpSlash[i].position = ccp(spMes.contentSize.width / 3, spMes.contentSize.height * 1.3f);
					spHelpSlash[i].visible = NO;
                    [spMes addChild:spHelpSlash[i] z:0];
                    [spHelpSlash[i] release];
				}
				
				str = [[NSString alloc] initWithFormat:@"helpTilt%d.png", i];
				spHelpTilt[i] = [[CCSprite alloc] initWithFile:str];[str release];
				spHelpTilt[i].position = ccp(spMes.contentSize.width / 3, spMes.contentSize.height * 1.3f);
				spHelpTilt[i].visible = NO;
                [spMes addChild:spHelpTilt[i] z:0];
                [spHelpTilt[i] release];
			}
			
			spHelpTilt[1].tag = 0;spHelpTilt[1].visible = NO; //modified by Song.
			
            CCLabelTTF* label = [[CCLabelTTF alloc] initWithString:@"TAP TO CONTINUE" fontName:@"BADABB_.TTF" fontSize:20];
			label.position = ccp(spMes.contentSize.width / 2, spMes.contentSize.height * 0.05f);
			label.scale = 0.8f;[spMes addChild:label z:2 tag:1]; [label release];
			
			[self addChild:spMes z:2 tag:kTagMessage];[spMes release];
			
			[self unschedule:@selector(changeDepth:)];
			[self unschedule:@selector(generateFish)];
			for (FishSprite *spfish in fishes) {
				[spfish stopMove];
			}
			m_nTime = 0;
			[self schedule:@selector(hintMessage:) interval:INTERVAL_CHANGEDEPTH];
		}
		else {
			m_nGameState = GAME_TILTDOWN;
			[self schedule:@selector(catchFish)];
			
			[self unschedule:@selector(changeDepth:)];
			if (g_UserInfo.nWeight == 0) {
				[self schedule:@selector(changeDepth:) interval:m_rSpeed];
			}
			else {
				[self schedule:@selector(changeDepth:) interval:INTERVAL_WEIGHT];
			}
            
			[self performSelector:@selector(loadTapMes)];
		}
		
		m_bTouch = NO;
	}
}

-(void) changeMessage : (id) sender
{
	CCSprite *spMes = (CCSprite*)sender;
	spMes.visible = YES;
	float x = spMes.contentSize.width;
	float y = spMes.contentSize.height;
	
	for (int i = 2; i < 7; i ++) {
		[[spMes getChildByTag:i] removeAllChildrenWithCleanup:YES];
	}
	
	if (m_nGameState == GAME_TAPTHIRD) {
        
        CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:[Tools imageNameForName:@"tap-the-screen"]];
        
        if (texture)
        {
            // Get the size of the new texture:
            CGSize size = [texture contentSize];
            
            [spMes setTexture:texture];
            // use the size of the new texture:
            [spMes setTextureRect:CGRectMake(0.0f, 0.0f, size.width,size.height)];
        }

		[self unschedule:@selector(changeDepth:)];
		[self unschedule:@selector(generateFish)];
		for (FishSprite* spfish in fishes) {
			[spfish stopMove];
		}
	}
	else if (m_nGameState == GAME_TAPFOURTH) {
        
        CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:[Tools imageNameForName:@"now-catch"]];
        
        if (texture)
        {
            // Get the size of the new texture:
            CGSize size = [texture contentSize];
            
            [spMes setTexture:texture];
            // use the size of the new texture:
            [spMes setTextureRect:CGRectMake(0.0f, 0.0f, size.width,size.height)];
        }

		[self unschedule:@selector(changeDepth:)];
		[self unschedule:@selector(generateFish)];
		for (FishSprite* spfish in fishes) {
			[spfish stopMove];
		}
	}
	else if (m_nGameState == GAME_TAPFIFTH) {
        
        CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:@"Touch&Slash.png"];
        
        if (texture)
        {
            // Get the size of the new texture:
            CGSize size = [texture contentSize];
            
            [spMes setTexture:texture];
            // use the size of the new texture:
            [spMes setTextureRect:CGRectMake(0.0f, 0.0f, size.width,size.height)];
        }
        

		for (FishSprite* spfish in catched_fishes) {
			[spfish pauseSchedulerAndActions];
		}
	}
    
	m_nTime = 0;
}

-(void) hideBg
{
	[[CCTextureCache sharedTextureCache] removeTexture:[(CCSprite*)[self getChildByTag:kTagMainBg1] texture]];
	[self removeChildByTag:kTagMainBg1 cleanup:YES];
}

-(void) showFishNum
{
	[[self getChildByTag:kTagDepth] removeAllChildrenWithCleanup:YES];
	
	str = [[NSString alloc] initWithFormat:@"CANDY INCOMING : %d", m_nCatchFishNum];
	[(CCLabelTTF*)[self getChildByTag:kTagDepth] setString:str]; [str release];
	[self schedule:@selector(onShowFishNum)];
}

-(void) onShowFishNum
{
	[[self getChildByTag:kTagDepth] removeAllChildrenWithCleanup:YES];
	
	str = [[NSString alloc] initWithFormat:@"CANDY INCOMING : %d", m_nCatchFishNum];
	[(CCLabelTTF*)[self getChildByTag:kTagDepth] setString:str];[str release];
}

-(void) changeDepth:(ccTime)dt
{
	float x, y; int i;
    
	str = [[NSString alloc] initWithFormat:@"%d/%dM", m_nDepth, g_UserInfo.nMaxDepth];
	[[self getChildByTag:kTagDepth] removeAllChildrenWithCleanup:YES];
	[(CCLabelTTF*)[self getChildByTag:kTagDepth] setString:str];
	[str release];
	
	if (m_nGameState >= GAME_TAPFIRST && m_nGameState < GAME_DOWNSTOP) {
		if (m_nDepth == 5){
			[[self getChildByTag:kTagLine0] removeAllChildrenWithCleanup:YES];
			[self removeChild:[self getChildByTag:kTagLine0] cleanup:YES];
			
			[m_szWalls removeAllObjects];
			
			if (m_nDepth < g_UserInfo.nWeight) {
				[self schedule:@selector(loadWall) interval:nInterval_loadwall * INTERVAL_WEIGHT * 4];
			}
			else [self schedule:@selector(loadWall) interval:nInterval_loadwall];
			[self schedule:@selector(moveWall)];
		}
		
		if (g_UserInfo.nWeight > 0 && m_nDepth == g_UserInfo.nWeight) {
			[self unschedule:@selector(changeDepth:)];
			[self schedule:@selector(changeDepth:) interval:m_rSpeed];
			[self unschedule:@selector(loadWall)];
			[self schedule:@selector(loadWall) interval:nInterval_loadwall];
			
			if(m_nDepth > 300){
				[self unschedule:@selector(generateMine)];
				[self schedule:@selector(generateMine) interval:INTERVAL_GENMINE];
			}
		}
		
		if (m_nDepth == g_UserInfo.nMaxDepth) {
			m_nGameState = GAME_DOWNSTOP;
			
//			[self schedule:@selector(generateTreasure) interval:0.1];
			[self unschedule:@selector(loadWall)];
			[self unschedule:@selector(moveWall)];
			[self unschedule:@selector(changeDepth:)];
			
			[self unschedule:@selector(generateMine)];
			[self unschedule:@selector(moveMine)];
			return;
		}
		
		if (m_nDepth == 300){
			[m_szMines removeAllObjects];
			
            //			if (m_nDepth < g_UserInfo.nWeight) {
            //				[self schedule:@selector(generateMine) interval:INTERVAL_GENMINE];
            //			}
            //			else
            [self schedule:@selector(generateMine) interval:INTERVAL_GENMINE];
			[self schedule:@selector(moveMine)];
		}
		if (m_nDepth == 5/*400*/) {
			CCSprite* spBg2 = [[CCSprite alloc] initWithFile:@"underwaterBG1.png"];
			spBg2.scaleX= g_fScaleX; spBg2.scaleY = g_fScaleY;
			spBg2.position = ccp(g_size.width / 2, -g_size.height / 2 - 0 * g_fScaleY);  // modified by Song
			
			[self addChild:spBg2 z:-1 tag:kTagMainBg2];
			[self schedule:@selector(moveBg) interval:INTERVAL_MOVEBG * (100 - g_UserInfo.nSpeed) / 100];
			[spBg2 release];
		}
		
		if (g_UserInfo.nLantern == 500) {
			if (m_nDepth == 500) {
				CCSprite* spBg3 = [[CCSprite alloc] initWithFile:@"underwaterBG2.png"];
				spBg3.scaleX= g_fScaleX * 2; spBg3.scaleY = g_fScaleY * 2;
				spBg3.position = ccp(spLine.position.x, g_size.height / 2);
				[self addChild:spBg3 z:4 tag:kTagMainBg3];	[spBg3 release];
			}
		}
		else {
			if (m_nDepth >= 500) {
                /*
				[(CCSprite*)[self getChildByTag:kTagMainBg1] setOpacity:0];
				[(CCSprite*)[self getChildByTag:kTagMainBg2] setOpacity:0];
				for (FishSprite *fish in fishes)  [(CCSprite*)fish setOpacity:0];
				for (FishSprite *fish in catched_fishes) [(CCSprite*)fish setOpacity:0];
				for (CCSprite *wall in m_szWalls) [(CCSprite*)wall setOpacity:0];
				for (CCSprite *mine in m_szMines) [(CCSprite*)mine setOpacity:0];
                 */
			}
		}
		m_nDepth++;
	}
	else {
		if (m_nDepth == 0)
		{
			[self unschedule:@selector(changeDepth:)];
			
			if (g_bSetup) {
				m_bTouch = YES;m_nGameState = GAME_TAPFIFTH;
				
				[self performSelector:@selector(onTouchEnable) withObject:nil afterDelay:1.f];
				[self getChildByTag:kTagMessage].position = ccp(g_size.width / 2, 200 * g_fScaleY);
				
				m_nTime = 0;
				[self performSelector:@selector(changeMessage:) withObject:[self getChildByTag:kTagMessage]];
				[self schedule:@selector(hintMessage:) interval:INTERVAL_CHANGEDEPTH];
				
			}
			else m_nGameState = GAME_SLASH;
			
			[self performSelector:@selector(removeOther:) withObject:spHook];
			[self performSelector:@selector(removeOther:) withObject:[spLine getChildByTag:2]];
			[self performSelector:@selector(removeOther:) withObject:spLine];
			[self performSelector:@selector(removeOther:) withObject:spDrill];
			
			[self performSelector:@selector(showFishNum) withObject:[self getChildByTag:kTagDepth] afterDelay:m_rSpeed / 2];
			
			CCSprite *sp;
			for (i = kTagLabelFuel; i < kTagDepth; i ++) {
				sp = (CCSprite*)[self getChildByTag:i];
				[sp removeAllChildrenWithCleanup:YES];
				[self removeChild:sp cleanup:YES];
			}
            
			for ( i = kTagMan0; i <= kTagMan2; i++) // modified by song
			{
				sp = (CCSprite*)[self getChildByTag:i];
				[sp setVisible:NO];
			}
			
			[[self getChildByTag:kTagMainBg] runAction:[CCMoveTo actionWithDuration:m_rSpeed / 2 position:ccp(g_size.width / 2, g_size.height / 2)]];
			[[self getChildByTag:kTagMainBg1] runAction:[CCMoveTo actionWithDuration:m_rSpeed / 2 position:ccp(g_size.width / 2, -270 * g_fScaleY)]];
			[self getChildByTag:kTagMainBg2].visible = FALSE;
            [self getChildByTag:kTagMainBg3].visible = FALSE;
			m_nCatchFishNum = catched_fishes.count;
			m_nBombNum = (catched_fishes.count + 4) / 15;
			if (!g_bSetup)
				for (i = 0; i < m_nBombNum; i ++ )
					[self generateBomb:i];
			
			int j; srand(clock());
			FishSprite* fish;
			for ( j = 0; j < catched_fishes.count; j++ ) {
				fish = [catched_fishes objectAtIndex:j];
				[fish stopAllActions];
				fish.position = ccp((50 + (rand() % 5) * 44) * g_fScaleX, - fish.contentSize.height / 2);
				
				fish.rotation = 180 * rand() % 2 ;
				if (g_bSetup) {
					CCSprite *spMes = [[CCSprite alloc] initWithFile:@"slash-the-candy.png"];
					spMes.position = ccp(fish.contentSize.width / 2, fish.contentSize.height);
					spMes.rotation = 0;

					[fish addChild:spMes z:0 tag:0];[spMes release];
				}
				else {
					//[g_GameUtils playSoundEffect:@"splash.wav"];
					[fish resumeSchedulerAndActions];
					[fish performSelector:@selector(startRun) withObject:nil afterDelay:INTERVAL_SPREADFISH * j];
				}
			}
            
			slash_fishes = [[NSMutableArray alloc] init];
			[self performSelector:@selector(hideBg) withObject:nil afterDelay:m_rSpeed];
			[self schedule:@selector(isGameOver)];
		}
		else {
			if (m_nDepth == 1) {
				[self unschedule:@selector(catchFish)];
				[self unschedule:@selector(moveWall)];
				
				CCSprite* sp;
				while (m_szWalls.count > 0) {
					sp = [m_szWalls objectAtIndex:0];
					[m_szWalls removeObject:sp];
					[self performSelector:@selector(removeOther:) withObject:sp];
					[sp release];
				}
                
				[m_szWalls release]; m_szWalls = nil;
				
				[self getChildByTag:kTagMainBg].visible = YES;
				for (i = kTagMainBg; i < kTagMessage; i++)
				{
					sp = (CCSprite*)[self getChildByTag:i];
					if (sp) {
						sp.visible = YES;
						x = sp.position.x;
						y = sp.position.y;
						
						[sp runAction:[CCMoveTo actionWithDuration:m_rSpeed position:ccp(x, (y / g_fScaleY - 270) * g_fScaleY)]]; // 270
					}
				}
				
				x = spLine.position.x;y = spLine.position.y;
				[spLine getChildByTag:2].visible = NO;
				[spLine runAction:[CCSpawn actions:[CCScaleTo actionWithDuration:m_rSpeed scaleX:g_fScaleX scaleY:0.3f],
								   [CCMoveTo actionWithDuration:m_rSpeed position:ccp(x, (y / g_fScaleY - 202) * g_fScaleY)], nil]];
				
				x = spHook.position.x;
				[spHook runAction:[CCMoveTo actionWithDuration:m_rSpeed position:ccp(x, 190 * g_fScaleY)]];
				
				[self unschedule:@selector(changeDepth:)];
				[self schedule:@selector(changeDepth:) interval:m_rSpeed];
				
				[self performSelector:@selector(removeAllFishes)];
			}
			
			if (m_nDepth <= (8 / (1 - g_UserInfo.nSpeed / 100))) {
				[self unschedule:@selector(generateFish)];
			}
            
			if (m_nDepth <= (45 / (1 - g_UserInfo.nSpeed / 100))){
				[self unschedule:@selector(loadWall)];
			}
			
			if (m_nDepth == 300) {
				CCSprite *sp;
				while (m_szMines.count > 0) {
					sp = [m_szMines objectAtIndex:0];
					[self performSelector:@selector(removeOther:) withObject:sp];
					[sp release];
				}
                
				[m_szMines release];m_szMines = nil;
			}
			
			if(m_nDepth <= 350) [self unschedule:@selector(generateMine)];
            
			if (m_nDepth == 440){
				[self schedule:@selector(moveBg) interval:INTERVAL_MOVEBG * (100 - g_UserInfo.nSpeed) / 100];
			}
			if (m_nDepth == 500){
				if (g_UserInfo.nLantern == 500) {
					[self removeChild:[self getChildByTag:kTagMainBg3] cleanup:YES];
				}
				else {
					[(CCSprite*)[self getChildByTag:kTagMainBg1] setOpacity:255];
					[(CCSprite*)[self getChildByTag:kTagMainBg2] setOpacity:255];
					for (FishSprite *fish in fishes)
						[(CCSprite*)fish setOpacity:255];
					for (FishSprite *fish in catched_fishes)
						[(CCSprite*)fish setOpacity:255];
					for (CCSprite *wall in m_szWalls)
						[(CCSprite*)wall setOpacity:255];
				}
			}
		}
		m_nDepth--;
	}
}

-(void) pause : (id)sender
{
	int i;
	self.isTouchEnabled = NO;
	[g_GameUtils playSoundEffect:@"button.wav"];
	[g_GameUtils playSoundEffect:@"window.wav"];
	
	[self pauseSchedulerAndActions];
	
	for (i = kTagMainMenu; i <= kTagMainBg3; i++) {
		if ([self getChildByTag:i]) {
			[(CCSprite*)[self getChildByTag:i] pauseSchedulerAndActions];
			[(CCSprite*)[self getChildByTag:i] setOpacity:20];
		}
	}
    
	if (m_nGameState >= GAME_TILTDOWN)
        for(i = 0; i < fishes.count; i++)
        {
            [(FishSprite*)[fishes objectAtIndex:i] stopMove];
            ((CCSprite*)[fishes objectAtIndex:i]).opacity = 20;
        }
	
	if (m_nGameState >= GAME_TILTUP)
        for(i = 0; i < catched_fishes.count; i++)
        {
            [(FishSprite*)[catched_fishes objectAtIndex:i] pauseSchedulerAndActions];
            ((CCSprite*)[catched_fishes objectAtIndex:i]).opacity = 20;
        }
	
	if (m_nGameState >= GAME_SLASH)
        for(i = 0; i < slash_fishes.count; i++)
        {
            [(FishSprite*)[slash_fishes objectAtIndex:i] pauseSchedulerAndActions];
            ((CCSprite*)[slash_fishes objectAtIndex:i]).opacity = 20;
        }
	
	if (m_nGameState >= GAME_TILTDOWN)
        for(i = 0; i < m_szWalls.count; i++)
        {
            [(CCSprite*)[m_szWalls objectAtIndex:i] pauseSchedulerAndActions];
            ((CCSprite*)[m_szWalls objectAtIndex:i]).opacity = 20;
        }
	
	if (m_nGameState >= GAME_TILTDOWN && m_nDepth >= 300)
        if (m_szMines) {
            for(i = 0; i < m_szMines.count; i++)
            {
                [(CCSprite*)[m_szMines objectAtIndex:i] pauseSchedulerAndActions];
                ((CCSprite*)[m_szMines objectAtIndex:i]).opacity = 20;
            }
        }
    
	[(CCMenuItemImage*)[[self getChildByTag:kTagMainMenu] getChildByTag:0] setIsEnabled:NO];
	
	PauseGameSprite *bgOption = [[PauseGameSprite alloc] initSprite];
	bgOption.scaleX = g_fScaleX; bgOption.scaleY = g_fScaleY;
	bgOption.position = ccp(g_size.width * 3 / 2, g_size.height / 2);
	
	[self addChild:bgOption z:11 tag:kTagPause];
	[bgOption runAction:[CCMoveTo actionWithDuration:0.2f position:ccp(g_size.width / 2, g_size.height / 2)]];
	[bgOption release];
}

-(int) searchLine
{
	for (int i = 0; i < LINE_NUM; i++)
	{
		if (!m_fLines[i])
		{
			m_fLines[i] = YES;
			m_nCurLines++;
            
			return i;
		}
	}
	
	return -1;
}

-(void) disappearLines
{
	for (int i = 0; i < LINE_NUM; i++)
	{
		if (m_fLines[i])
		{
			m_spPoint[i].visible = NO;
			m_spLine[i].visible = NO;
			m_fLines[i] = NO;
			m_nCurLines--;
		}
	}
}

-(void) drawSword:(CGPoint)pt
{
	if (m_fSword)
	{
		if (m_nCurLines > 0)
			return;
		else
			m_fSword = NO;
	}
	
	m_nFreeLine = [self searchLine];
	if (m_nFreeLine == -1)
		return;
	
	m_ptCur = pt;
	
	if (m_nCurLines == 1)
		m_ptBef = m_ptCur;
    
	[m_spPoint[m_nFreeLine] setPosition:m_ptCur];
	m_spPoint[m_nFreeLine].visible = YES;
	
	float rLineWidth = hypotf(m_ptCur.x - m_ptBef.x, m_ptCur.y - m_ptBef.y);
	if (rLineWidth < 1.0f)
		rLineWidth = 1.0f;
	[m_spLine[m_nFreeLine] setPosition:m_ptBef];
	[m_spLine[m_nFreeLine] setVisible:YES];
	[m_spLine[m_nFreeLine] setScaleX:(rLineWidth/m_spLine[m_nFreeLine].contentSize.width)];
	[m_spLine[m_nFreeLine] setRotation:CC_RADIANS_TO_DEGREES(atan2(m_ptCur.y - m_ptBef.y, m_ptCur.x - m_ptBef.x))*(-1)];
	
	m_ptBef = m_ptCur;
}

#pragma mark touchFunc
- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	if ( m_bTouch || m_fTouch) {
		return;
	}
	m_nTouchNum = 0; m_fTouch = YES;
	time_t tv; time(&tv); srand(tv);
	if (m_nGameState == GAME_TAPFIRST) {
		m_bTouch = YES;
		[g_GameUtils playSoundEffect:@"rodCasting.wav"];
		
		[self performSelector:@selector(removeOther:) withObject:[[self getChildByTag:kTagMessage] getChildByTag:0]];
		[self performSelector:@selector(removeOther:) withObject:[self getChildByTag:kTagMessage]];
		
		if (g_bSetup) m_nGameState = GAME_TAPSECOND;
		
		[self unschedule:@selector(swing:)];
		[self unschedule:@selector(actionMove)];
		
		int x, i;
		id move = nil;
		CCSprite *spFish;
		
		for (i = kTagFish1; i <= kTagFish3; i++) {
			spFish = (CCSprite*)[self getChildByTag:i];
            
			x = spFish.position.x;
			
			if (spFish.flipX) {
				move = [CCMoveBy actionWithDuration:(g_size.width * 1.2f - x) / g_size.width position:ccp(g_size.width * 1.2f - x, 0)];
			}
			else {
				move = [CCMoveBy actionWithDuration:(x + g_size.width * 0.2f) / g_size.width position:ccp(-(x + g_size.width * 0.2f), 0)];
			}
            
			[spFish runAction:[CCSequence actions:move,
                               [CCCallFuncN actionWithTarget:self selector:@selector(removeOther:)],
                               nil]];
		}
		
		[self schedule:@selector(throw:) interval:0.15f];
		[self schedule:@selector(changeDepth:) interval:(3 * m_rSpeed)];
		
		CCSprite *spLine1 = [[CCSprite alloc] initWithFile:@"hookline.png"];
		spLine1.scaleX = g_fScaleX; spLine1.scaleY = g_fScaleY ;
		spLine1.anchorPoint = ccp(0, 0);
		spLine1.visible = NO;spLine1.rotation = 90;
		spLine1.position = ccp(250 * g_fScaleX, 354 * g_fScaleY); // modified by song
		
		CCSprite *spHook1 = [[CCSprite alloc] initWithFile:@"hook.png"];
		spHook1.position = ccp(spLine1.contentSize.width / 2, spLine1.contentSize.height);
		[spLine1 addChild:spHook1 z:0 tag:0];
		spHook1.rotation = 180; [spHook1 release];
		
		[self addChild:spLine1 z:2 tag:kTagLine0];	[spLine1 release];
	}
	else if (m_nGameState == GAME_TAPSECOND){
		m_bTouch = YES;m_nGameState = GAME_TAPTHIRD;
		[self unschedule:@selector(hintMessage:)];
		
		[self schedule:@selector(changeDepth:) interval:m_rSpeed];
		for (FishSprite *spfish in fishes) {
			[spfish startMove];
		}
		[self schedule:@selector(generateFish) interval:nInterval_generatefish];
		
		[self performSelector:@selector(loadTapMes)];
		[self performSelector:@selector(onTouchEnable) withObject:nil afterDelay:2.5f];
	}
	else if (m_nGameState == GAME_TAPTHIRD){
		m_nGameState = GAME_TILTDOWN;
		[self unschedule:@selector(hintMessage:)];
		
		[self schedule:@selector(changeDepth:) interval:m_rSpeed];
		for (FishSprite *spfish in fishes) {
			[spfish startMove];
		}
		[self schedule:@selector(generateFish) interval:nInterval_generatefish];
		
		[self getChildByTag:kTagMessage].visible = NO;
		[self schedule:@selector(catchFish)];
	}
	else if(m_nGameState == GAME_TILTDOWN){
		if (m_nCurFuel > 0 && m_nDepth >= g_UserInfo.nWeight)
			[self performSelector:@selector(drill)];
	}
	else  if(m_nGameState == GAME_TAPFOURTH){
		[self unschedule:@selector(hintMessage:)];
		m_nGameState = GAME_TILTUP;
		
		for (FishSprite *spfish in fishes) {
			[spfish startMove];
		}
		
		[self schedule:@selector(generateFish) interval:nInterval_generatefish / MOVE_SCALE];
        
		[self schedule:@selector(changeDepth:) interval:m_rSpeed / MOVE_SCALE];
		[self getChildByTag:kTagMessage].visible = NO;
		[self schedule:@selector(catchFish)];
	}
	else if(m_nGameState == GAME_TILTUP){
		if (m_nCurFuel > 0) [self performSelector:@selector(drill)];
	}
	else  if(m_nGameState == GAME_TAPFIFTH){
		[self unschedule:@selector(hintMessage:)];
		[g_GameUtils playSoundEffect:@"splash.wav"];
		m_nGameState = GAME_SLASH;
        
		int i ;
		FishSprite *fish;
		for (i = 0; i < catched_fishes.count; i++)
		{
			fish = [catched_fishes objectAtIndex:i];
			[fish resumeSchedulerAndActions];
			[fish performSelector:@selector(startRun) withObject:nil afterDelay:INTERVAL_SPREADFISH * i];
		}
		
		for (i = 0; i < 3; i++) {
			//[self performSelector:@selector(removeOther:) withObject:spHelpTilt[i]];
		}
		for (i = 0; i < 2; i ++) {
			//[self performSelector:@selector(removeOther:) withObject:spHelpTap[i]];
			//[self performSelector:@selector(removeOther:) withObject:spHelpSlash[i]];;
		}
		
		for (i = 0; i < 7; i++) {
			if ([[self getChildByTag:kTagMessage] getChildByTag:i]) {
				[self performSelector:@selector(removeOther:) withObject:[[self getChildByTag:kTagMessage] getChildByTag:i]];
			}
		}
        
		[self performSelector:@selector(removeOther:) withObject:[self getChildByTag:kTagMessage]];
	}
	else if(m_nGameState == GAME_SLASH){
		UITouch *touch = [touches anyObject];
		CGPoint location = [touch locationInView:[touch view]];
		CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
        
		[g_GameUtils playSoundEffect:@"slash_air.wav"];
		ptOld = convertedLocation; ptNew = convertedLocation;
	}
}

- (void)ccTouchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	if(!m_fTouch || m_nGameState != GAME_SLASH) return;
	
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
    
	int k = [self sliceFish:ptNew secondPoint:convertedLocation];
	if (k > -1) {
		CCSprite *spSlash = [[CCSprite alloc] initWithFile:@"slice.png"];
		spSlash.scaleX = g_fScaleX; spSlash.scaleY = g_fScaleY;
		spSlash.rotation = CC_RADIANS_TO_DEGREES(atan2(convertedLocation.y - ptNew.y, convertedLocation.x - ptNew.x))*(-1);
        
		if (k == 0)  {
			//[g_GameUtils playSoundEffect:@"slash_fish.wav"];
			spSlash.position = ccpMidpoint(ptNew, convertedLocation);
		}
        
		[self addChild:spSlash z:2];
		[self performSelector:@selector(removeOther:) withObject:spSlash afterDelay:0.1f];
		[spSlash release];
	}
	else {
		[self drawSword:convertedLocation];
	}
    
	if (k == -2) {
		[self unschedule:@selector(isGameOver)];
		[self performSelector:@selector(loadScoreScene:) withObject:self afterDelay:2.f];
	}
	ptNew = convertedLocation;
}

- (void)ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	if (m_fTouch) {
		m_fTouch = NO;
		if (m_nGameState == GAME_SLASH) {
			m_fSword = YES;
			[self disappearLines];
		}
	}
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
	if (m_nGameState > GAME_TAPTHIRD && m_nGameState < GAME_TAPFIFTH){
		float accel = acceleration.x * TILT_PRAM * g_fScaleX;
		
		spLine.position = ccpAdd(spLine.position, ccp(accel, 0));
		spHook.position = ccpAdd(spHook.position, ccp(accel, 0));
		spDrill.position = ccpAdd(spDrill.position, ccp(accel, 0));
		
		for (int i = 0; i < catched_fishes.count; i ++ ) {
			((CCSprite*)[catched_fishes objectAtIndex:i]).position = ccpAdd(((CCSprite*)[catched_fishes objectAtIndex:i]).position, ccp(accel, 0));
		}
		
		if (g_UserInfo.nLantern >= 500 && [self getChildByTag:kTagMainBg3]) {
			[self getChildByTag:kTagMainBg3].position = ccpAdd([self getChildByTag:kTagMainBg3].position, ccp(accel, 0));
		}
		
		float dx;
		
		if(spLine.position.x + accel < 0) {
			dx = spLine.position.x;
			spLine.position = ccp(0, spLine.position.y);
            
		}
		else if(spLine.position.x + accel > 320 * g_fScaleX){
			dx = spLine.position.x - 320 * g_fScaleX;
			spLine.position = ccp(320 * g_fScaleX, spLine.position.y);
		}
		else {
			return;
		}
		
		spHook.position = ccp(spHook.position.x - dx, spHook.position.y);
		spDrill.position = ccp(spDrill.position.x - dx, spDrill.position.y);
		for (int i = 0; i < catched_fishes.count; i ++ ) {
			((CCSprite*)[catched_fishes objectAtIndex:i]).position = ccp(((CCSprite*)[catched_fishes objectAtIndex:i]).position.x - dx,
																		 ((CCSprite*)[catched_fishes objectAtIndex:i]).position.y);
		}
		
		if (g_UserInfo.nLantern >= 500 && [self getChildByTag:kTagMainBg3]) {
			[self getChildByTag:kTagMainBg3].position = ccp([self getChildByTag:kTagMainBg3].position.x - dx,
															[self getChildByTag:kTagMainBg3].position.y);
		}
	}
}

-(void) removeAllFishes
{
	FishSprite* fish;
	while (fishes.count > 0) {
		fish = [fishes objectAtIndex:0];
		[fish stopMove];
		[fishes removeObject:fish];
		[self performSelector:@selector(removefish:) withObject:fish];
	}
	
	[fishes release]; fishes = nil;
}

-(void)removeOther : (id)sender
{
	CCSprite *Object = (CCSprite*)sender;
	[Object stopAllActions];
	[Object removeAllChildrenWithCleanup:YES];
	[[CCTextureCache sharedTextureCache] removeTexture:[Object texture]];
	[Object removeFromParentAndCleanup:YES];
}

-(void)removefish : (id)sender
{
	FishSprite *fish = (FishSprite*)sender;
	[fish stopAllActions];
	[fish releasefish];
	[fish release];
}

-(void) hideTrail
{
	m_nTouchNum = 0;
}

-(void) showMessage
{
	[self getChildByTag:kTagMainBg].visible = NO;
	for (int i = kTagCloud1; i < kTagLine; i ++) {
		if ([self getChildByTag:i]) {
			[self getChildByTag:i].visible = NO;
		}
	}
	
	if (g_bSetup) [spLine getChildByTag:2].visible = YES;
}
-(void) hideDrill
{
	[spDrill setVisible:NO];
	m_fDrill = NO;
    
	[g_GameUtils stopSoundEffect:szDug];
}
-(void) onTouchEnable
{
	m_bTouch = NO;
}

-(void) isGameOver
{
	if (catched_fishes.count == 0) {
		[self unschedule:@selector(isGameOver)];
		[self performSelector:@selector(loadScoreScene:) withObject:self afterDelay:2.f];
	}
}

-(void)loadScoreScene : (id) sender
{
	m_nGameState = GAME_OVER;
	[MainMenuScene saveUserInfo];

	//[g_GameUtils playSoundEffect:@"window.wav"];
	[g_GameUtils playSoundEffect:@"Results.wav"];
    
    [self performSelector:@selector(releaseObject) withObject:self afterDelay:0.6f];
    
	NSString *r = @"CCTransitionMoveInR";
	Class transion = NSClassFromString(r);
    [g_GameUtils playBackgroundMusic:@"MenuMusic.mp3"];
	[[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:0.5f scene:[ScoreScene scene]]];
}

#pragma mark particle
-(void) drill
{
	[g_GameUtils playSoundEffect:@"lotsBubble.wav"];
	szDug = [g_GameUtils playSoundEffect:@"bubble.wav"];
	
	spDrill.visible = YES; m_fDrill = YES;
	[self performSelector:@selector(hideDrill) withObject:spDrill afterDelay:1.f];
	
	CCParticleFire *emitter = [[CCParticleFire alloc] initWithTotalParticles:300];
	[spDrill addChild:emitter z:5];
	emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"waterdrop.png"];
	[emitter setDuration:2.f];emitter.scaleX = 0.8f;
	emitter.speed = 50;emitter.life = 2;
	emitter.startSize = 15.0f; emitter.endSize = kCCParticleStartSizeEqualToEndSize;
	emitter.startSizeVar = emitter.endSizeVar = 0.f;
	emitter.position = ccp(spDrill.contentSize.width / 2, 0);
	emitter.autoRemoveOnFinish = YES;
	[self performSelector:@selector(hideParticle:) withObject:emitter afterDelay:1.f];
	
	m_nCurFuel -= 6;
	if (m_nCurFuel < 0) m_nCurFuel = 0;
	
	str = [[NSString alloc] initWithFormat:@"%d", m_nCurFuel];
	[[self getChildByTag:kTagFuel] removeAllChildrenWithCleanup:YES];
	[(CCLabelTTF*)[self getChildByTag:kTagFuel] setString:str];	[str release];
}
-(void) onBlood : (CCSprite*)fish dir:(BOOL)fDir
{
	CCParticleFire *emitter = [[CCParticleFire alloc] init];
	[fish addChild:emitter];
	emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"blood.png"];
	
	if (spLine.position.x >= 160 * g_fScaleX) emitter.rotation = 110;
	else emitter.rotation = -110;
	
	[emitter setDuration:0.5f]; emitter.life = 2; emitter.speed = 10;
    emitter.totalParticles = 6;
	ccColor4F color = {1.f, 0.1f, 0.1f, 1.f}; emitter.startColor = color;
	ccColor4F color0 = {1.f, 0.1f, 0.1f, 0.7f}; emitter.endColor = color0;
	ccColor4F color1 = {0.f, 0.0f, 0.f, 0.0f};
	emitter.startColorVar = color1; emitter.endColorVar = color1;
	emitter.startSize = 15.0f; emitter.endSize = 40.f;
	emitter.startSizeVar = 5.0f; emitter.endSizeVar = 0.f;
	
	if (fDir) emitter.position = ccp(0, fish.contentSize.height/2);
	else emitter.position = ccp(fish.contentSize.width, fish.contentSize.height/2);
	
	emitter.posVar = ccp(10.f, 20.f);
	emitter.blendAdditive = YES;
	[self performSelector:@selector(hideParticle:) withObject:emitter afterDelay:1.f];
	emitter.autoRemoveOnFinish = YES; //[emitter release];
}

-(void) onSlash : (CGPoint)pt
{
	CCParticleExplosion *emitter = [[CCParticleExplosion alloc] initWithTotalParticles:200];
	[self addChild:emitter z:2];
	
	emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"blooddrop.png"];
	emitter.scale = g_fScaleX;
	[emitter setDuration:0.1f]; emitter.life = 1.f;emitter.speed = 40;
	
	ccColor4F color = {0.2f, 1.0f, 0.f, 1.f};
	emitter.startColor = color; emitter.endColor = color;
	ccColor4F color1 = {0.f, 0.0f, 0.f, 0.0f};
	emitter.startColorVar = color1; emitter.endColorVar = color1;
	emitter.startSize = 15.0f;  emitter.startSizeVar = 3.0f;
	emitter.endSize = kCCParticleStartSizeEqualToEndSize;
	emitter.position = pt;emitter.blendAdditive = YES;
	[self performSelector:@selector(hideParticle:) withObject:emitter afterDelay:1.f];
	emitter.autoRemoveOnFinish = YES; //[emitter release];
}

-(void) hideParticle : (id) sender
{
	CCParticleSystem *emitter = (CCParticleSystem*)sender;
	emitter.visible = NO;
	[[CCTextureCache sharedTextureCache] removeTexture:[emitter texture]];
	[emitter removeFromParentAndCleanup:YES];
	[emitter release];
}

#pragma mark engine
-(int) sliceFish:(CGPoint)ptFirst secondPoint:(CGPoint)ptSecond
{
	CGRect rect ;
	FishSprite* spfish;
	int nIx;
	CGPoint ptMid;
	for( nIx = 0; nIx < catched_fishes.count; nIx++ )
	{
		spfish = [catched_fishes objectAtIndex:nIx];
		rect = spfish.boundingBox;
		ptMid = ccpMidpoint(ptFirst, ptSecond);
		
		while (ccpDistance(ptMid, ptSecond) > 1.f)
		{
			if (CGRectContainsPoint(rect, ptMid))
			{
				spfish.slashnum += g_UserInfo.nBlade;
				if (spfish.slashnum < [spfish getMaxSlashNum]) {
					id action = [CCScaleTo actionWithDuration:0.1f scaleX:SCALE * g_fScaleX scaleY:SCALE * g_fScaleY];
					id reaction = [CCScaleTo actionWithDuration:0.1f scaleX:g_fScaleX scaleY:g_fScaleY];
					
					[spfish runAction:[CCSequence actions: action, reaction, nil]];
					
					return 0;
				}
				
				[catched_fishes removeObject:spfish];
				[spfish stopRun]; nIx --;
				
				if (spfish.type == Bomb) {
					[self bomb:spfish.position];
					[self performSelector:@selector(removefish:) withObject:spfish afterDelay:1.5f];
					return -2;
				}
                
				[g_GameUtils playSoundEffect:@"coin.mp3"];
				CGPoint ptMid = ccpMidpoint(ptFirst, ptSecond);
				[self onSlash:ptMid];
				
				g_UserInfo.nTotalScore += [spfish getScore];
				g_UserInfo.nMoney += [spfish getScore];
				str = [[NSString alloc] initWithFormat:@"%d", g_UserInfo.nMoney];
				[[self getChildByTag:kTagMoney] removeAllChildrenWithCleanup:YES];
				[(CCLabelTTF*)[self getChildByTag:kTagMoney] setString:str];[str release];
				
				g_UserInfo.nScore +=  [spfish getScore];
				str = [[NSString alloc] initWithFormat:@"+%d~", g_UserInfo.nScore];
				CCLabelTTF *lblScore = [[CCLabelTTF alloc] initWithString:str fontName:@"BADABB_.TTF" fontSize:30.0f];
				lblScore.scaleX = 0.75f * g_fScaleX; lblScore.scaleY = 0.75f * g_fScaleY;
				lblScore.position = ptMid;
                lblScore.color = ccc3(98, 179, 229);
                //[self addChild:lblScore z:1];
				[self performSelector:@selector(removeOther:) withObject:lblScore afterDelay:2.f];
				[lblScore release];[str release];
				
				if (spfish.type != Treasure) {
					
					[slash_fishes addObject:spfish];
					
					CCSprite *spBloodtrace = [[CCSprite alloc] initWithFile:@"Slash.png"];   // modified by Song bloodtrace -->Slash
					spBloodtrace.scaleX = g_fScaleX; spBloodtrace.scaleY = g_fScaleY;
					spBloodtrace.position = ptMid; spBloodtrace.rotation = spfish.rotation;
					[self performSelector:@selector(removeOther:) withObject:spBloodtrace afterDelay:2.f];
					
					[self addChild:spBloodtrace z:0];[spBloodtrace release];
					
					NSString *fish_path = [[NSString alloc] initWithFormat:@"candy%02d.png", spfish.type];	// modified by song fish --> candy
					CCSprite *fishseg = [[CCSprite alloc] initWithFile:fish_path];[fish_path release];
					fishseg.scaleX = g_fScaleX; fishseg.scaleY = g_fScaleY;
					[self addChild:fishseg]; fishseg.rotation = -spfish.rotation;
					
					if(spfish.flipX) {
						fishseg.flipX = YES;
						[fishseg setTextureRect:CGRectMake(spfish.contentSize.width / 2, 0, spfish.contentSize.width / 2, spfish.contentSize.height)];
						[spfish setTextureRect:CGRectMake(0, 0, spfish.contentSize.width / 2, spfish.contentSize.height)];
					}
					else{
						[fishseg setTextureRect:CGRectMake(0, 0, spfish.contentSize.width / 2, spfish.contentSize.height)];
						[spfish setTextureRect:CGRectMake(spfish.contentSize.width / 2, 0, spfish.contentSize.width / 2, spfish.contentSize.height)];
					}
					
					fishseg.position = ccp(spfish.position.x - 30 * g_fScaleX, spfish.position.y);
					spfish.position = ccp(spfish.position.x + 30 * g_fScaleX, spfish.position.y);
					
					id act_mov_l = [CCMoveBy actionWithDuration:1.5f position:ccp(-10 * g_fScaleX, -100 * g_fScaleY)];
					id act_mov_r = [CCMoveBy actionWithDuration:1.5f position:ccp(10 * g_fScaleX, -100 * g_fScaleY)];
					id act_rot_l = [CCRotateBy actionWithDuration:1.5f angle:540];
					id act_rot_r = [CCRotateBy actionWithDuration:1.5f angle:-540];
					id act_fade = [CCFadeOut actionWithDuration:1.5f];
					[fishseg runAction:[CCSpawn actions:act_mov_l, act_fade, act_rot_l, nil]];
					[spfish runAction:[CCSpawn actions:act_mov_r, act_fade, act_rot_r, nil]];
					
					[self performSelector:@selector(removeOther:) withObject:spfish afterDelay:1.6f];
					[self performSelector:@selector(removeOther:) withObject:fishseg afterDelay:1.6f];
					[fishseg release];
				}
				else {
                    [slash_fishes addObject:spfish];
					
					CCSprite *spBloodtrace = [[CCSprite alloc] initWithFile:@"Slash.png"];   // modified by Song bloodtrace -->Slash
					spBloodtrace.scaleX = g_fScaleX; spBloodtrace.scaleY = g_fScaleY;
					spBloodtrace.position = ptMid; spBloodtrace.rotation = spfish.rotation;
					[self performSelector:@selector(removeOther:) withObject:spBloodtrace afterDelay:2.f];
					
					[self addChild:spBloodtrace z:0];[spBloodtrace release];
					
                    NSString* str2 = [NSString stringWithFormat:@"treasure%d",spfish.treasure_mode];
					//NSString *fish_path = [[NSString alloc] initWithFormat:@"candy%02d.png", spfish.type];	// modified by song fish --> candy
					CCSprite *fishseg = [[CCSprite alloc] initWithFile:[Tools imageNameForName:str2]];//[fish_path release];
					fishseg.scaleX = g_fScaleX; fishseg.scaleY = g_fScaleY;
					[self addChild:fishseg]; fishseg.rotation = -spfish.rotation;
					
					if(spfish.flipX) {
						fishseg.flipX = YES;
						[fishseg setTextureRect:CGRectMake(spfish.contentSize.width / 2, 0, spfish.contentSize.width / 2, spfish.contentSize.height)];
						[spfish setTextureRect:CGRectMake(0, 0, spfish.contentSize.width / 2, spfish.contentSize.height)];
					}
					else{
						[fishseg setTextureRect:CGRectMake(0, 0, spfish.contentSize.width / 2, spfish.contentSize.height)];
						[spfish setTextureRect:CGRectMake(spfish.contentSize.width / 2, 0, spfish.contentSize.width / 2, spfish.contentSize.height)];
					}
					
					fishseg.position = ccp(spfish.position.x - 30 * g_fScaleX, spfish.position.y);
					spfish.position = ccp(spfish.position.x + 30 * g_fScaleX, spfish.position.y);
					
					id act_mov_l = [CCMoveBy actionWithDuration:1.5f position:ccp(-10 * g_fScaleX, -100 * g_fScaleY)];
					id act_mov_r = [CCMoveBy actionWithDuration:1.5f position:ccp(10 * g_fScaleX, -100 * g_fScaleY)];
					id act_rot_l = [CCRotateBy actionWithDuration:1.5f angle:540];
					id act_rot_r = [CCRotateBy actionWithDuration:1.5f angle:-540];
					id act_fade = [CCFadeOut actionWithDuration:1.5f];
					[fishseg runAction:[CCSpawn actions:act_mov_l, act_fade, act_rot_l, nil]];
					[spfish runAction:[CCSpawn actions:act_mov_r, act_fade, act_rot_r, nil]];
					
					[self performSelector:@selector(removeOther:) withObject:spfish afterDelay:1.6f];
					[self performSelector:@selector(removeOther:) withObject:fishseg afterDelay:1.6f];
					[fishseg release];

//                   NSString* str2 = [NSString stringWithFormat:@"treasure%d",spfish.treasure_mode];
//					CCSprite *sptreasure = [[CCSprite alloc] initWithFile:[Tools imageNameForName:str2]];
//					sptreasure.scaleX = g_fScaleX; sptreasure.scaleY = g_fScaleY;
//					sptreasure.rotation = spfish.rotation;
//					sptreasure.position = spfish.position;
//					[self addChild:sptreasure];
//					
//					id act_mov_l = [CCMoveBy actionWithDuration:1.5f position:ccp(-10 * g_fScaleX, -100 * g_fScaleY)];
//					id act_fade = [CCFadeOut actionWithDuration:1.5f];
//					[sptreasure runAction:[CCSpawn actions:act_mov_l, act_fade, nil]];
//					
//					[self performSelector:@selector(removefish:) withObject:spfish];
//					[self performSelector:@selector(removeOther:) withObject:sptreasure afterDelay:1.6f];
//					[sptreasure release];
				}
				
				return 0;
			}
			else {
				ptMid = ccpMidpoint(ptMid, ptSecond);
			}
		}
	}
    
	return -1;
}

-(void) bomb : (CGPoint)pt
{
	NSString *fish_path;
	CCSprite *spBloodtrace;
	CCSprite *fishseg;
	int i, nExplode = (rand() % 5) + 5;
	
	[g_GameUtils playSoundEffect:@"bomb.wav"];
	
	for (i = 0; i < nExplode; i ++) {
		spBloodtrace = [[CCSprite alloc] initWithFile:@"explode.png"];
		spBloodtrace.scaleX = g_fScaleX * (rand() % 10) * 2;
		spBloodtrace.scaleY = g_fScaleY;
		spBloodtrace.position = pt;
		spBloodtrace.rotation = (rand() % 18) * i * 10;
		[self addChild:spBloodtrace];
		
		[spBloodtrace runAction:[CCScaleTo actionWithDuration:1.f scaleX:spBloodtrace.scaleX scaleY:g_fScaleY * 580]];
		[self performSelector:@selector(removeOther:) withObject:spBloodtrace afterDelay:2.f];
		[spBloodtrace release];
	}
	
	CCLabelBMFont *lblScore = [[CCLabelBMFont alloc] initWithString:@"BOOM!" fntFile:@"Welltron40Yellow.fnt"];
	lblScore.scaleX = 0.75f * g_fScaleX; lblScore.scaleY = 0.75f * g_fScaleY;
	lblScore.position = pt;  [self addChild:lblScore z:1];
	
	[self performSelector:@selector(removeOther:) withObject:lblScore afterDelay:2.f];
	[lblScore release];
	
	FishSprite *sp;
	while (catched_fishes.count > 0) {
		sp = [catched_fishes objectAtIndex:0];
		[catched_fishes removeObject:sp];
		[sp stopRun];
		
		if (sp.type != Bomb && sp.type != Treasure)
		{
			spBloodtrace = [[CCSprite alloc] initWithFile:@"Slash.png"];   // modified by Song bloodtrace ---> Slash
			spBloodtrace.scaleX = g_fScaleX; spBloodtrace.scaleY = g_fScaleY;
			spBloodtrace.position = sp.position;
			spBloodtrace.rotation = sp.rotation;
			[self addChild:spBloodtrace z:0];
			[self performSelector:@selector(removeOther:) withObject:spBloodtrace afterDelay:2.f];
			[spBloodtrace release];
			[self onSlash:sp.position];
            
			fish_path = [[NSString alloc] initWithFormat:@"candy%02d.png", sp.type];	/// modified by Song fish ---> candy
			fishseg = [[CCSprite alloc] initWithFile:fish_path]; [fish_path release];
			fishseg.scaleX = g_fScaleX; fishseg.scaleY = g_fScaleY;
			[self addChild:fishseg]; fishseg.rotation = -sp.rotation;
            
			if(sp.flipX) {
				fishseg.flipX = YES;
				[fishseg setTextureRect:CGRectMake(sp.contentSize.width / 2, 0, sp.contentSize.width / 2, sp.contentSize.height)];
				[sp setTextureRect:CGRectMake(0, 0, sp.contentSize.width / 2, sp.contentSize.height)];
			}
			else{
				[fishseg setTextureRect:CGRectMake(0, 0, sp.contentSize.width / 2, sp.contentSize.height)];
				[sp setTextureRect:CGRectMake(sp.contentSize.width / 2, 0, sp.contentSize.width / 2, sp.contentSize.height)];
			}
            
			fishseg.position = ccp(sp.position.x - 30 * g_fScaleX, sp.position.y);
			sp.position = ccp(sp.position.x + 30 * g_fScaleX, sp.position.y);
			id act_mov_l = [CCMoveBy actionWithDuration:1.5f position:ccp(-10 * g_fScaleX, -100 * g_fScaleY)];
			id act_mov_r = [CCMoveBy actionWithDuration:1.5f position:ccp(10 * g_fScaleX, -100 * g_fScaleY)];
			id act_fade = [CCFadeOut actionWithDuration:1.5f];
			[fishseg runAction:[CCSpawn actions:act_mov_l, act_fade, nil]];
			[sp runAction:[CCSpawn actions:act_mov_r, act_fade, nil]];
            
			[self performSelector:@selector(removefish:) withObject:sp afterDelay:1.6f];
			[self performSelector:@selector(removeOther:) withObject:fishseg afterDelay:1.6f];
			[fishseg release];
		}
		else if(sp.type == Bomb){
			[self performSelector:@selector(removefish:) withObject:sp afterDelay:1.5f];
		}
        
	}
}

-(void) catchFish
{
	if (m_nDepth <= g_UserInfo.nWeight + 1 && m_nGameState == GAME_TILTDOWN)  return;
    
	if(catched_fishes.count >= g_UserInfo.nHook) {
		[self unschedule:@selector(catchFish)];
		if (m_nDepth >= 40) {
			[self unschedule:@selector(loadWall)];
			[self unschedule:@selector(changeDepth:)];
			[self schedule:@selector(loadWall) interval:nInterval_loadwall * INTERVAL_WEIGHT * 4];
			[self schedule:@selector(changeDepth:) interval:INTERVAL_WEIGHT];
		}
		return;
	}
	
	FishSprite *spfish;
	
	CGRect rectHook = CGRectMake(spHook.position.x - spHook.contentSize.width / 4,
                                 spHook.position.y - spHook.contentSize.height / 2,
                                 spHook.contentSize.width / 2,
                                 spHook.contentSize.height * 0.5f);
	
	CGRect rectDrill = CGRectMake(spDrill.position.x - spDrill.contentSize.width * g_fScaleX / 4,
                                  spDrill.position.y - spDrill.contentSize.height / 2,
                                  spDrill.contentSize.width / 2,
                                  spDrill.contentSize.height * 0.7f);
	
	if (m_szMines && m_szMines.count > 0)
	{
		for (int j = 0; j < m_szMines.count; j++)
		{
			spfish = (FishSprite *)[m_szMines objectAtIndex:j];
			
			CGRect rect = CGRectMake(spfish.position.x - spfish.contentSize.width / 2,
                                     spfish.position.y + spfish.contentSize.height / 6,
                                     spfish.contentSize.width,
                                     spfish.contentSize.height / 3);
			if (CGRectIntersectsRect(rect, rectHook))
			{
				CCSprite *spBloodtrace;
				int i, nExplode = (rand() % 5) + 5;
                
				[g_GameUtils playSoundEffect:@"bomb.wav"];
				
				for (i = 0; i < nExplode; i ++) {
					spBloodtrace = [[CCSprite alloc] initWithFile:@"explode.png"];
					spBloodtrace.scaleX = g_fScaleX * (rand() % 10) * 2;
					spBloodtrace.scaleY = g_fScaleY;
					spBloodtrace.position = spfish.position;
					spBloodtrace.rotation = (rand() % 18) * i * 10;
					[self addChild:spBloodtrace z:3];
					
					[spBloodtrace runAction:[CCScaleTo actionWithDuration:1.f scaleX:spBloodtrace.scaleX scaleY:g_fScaleY * 580]];
					[self performSelector:@selector(removeOther:) withObject:spBloodtrace afterDelay:2.f];
					[spBloodtrace release];
				}
				
				CCLabelBMFont *lblScore = [[CCLabelBMFont alloc] initWithString:@"BOOM!" fntFile:@"Welltron40Yellow.fnt"];
				lblScore.scaleX = 0.75f * g_fScaleX; lblScore.scaleY = 0.75f * g_fScaleY;
				lblScore.position = spfish.position;  [self addChild:lblScore z:3];
				
				[self performSelector:@selector(removeOther:) withObject:lblScore afterDelay:2.f];
				[lblScore release];
				
				if(m_nGameState == GAME_TILTDOWN) g_UserInfo.nCurDepth = m_nDepth;
				[self unscheduleAllSelectors];
				m_nGameState = GAME_OVER;
				
				[spfish setVisible:NO];
				
				FishSprite *sp;
				CCSprite *fishseg;
				NSString *fish_path;
				while (fishes.count > 0) {
					sp = [fishes objectAtIndex:0];
					[fishes removeObject:sp];
					[sp stopMove];
					
					CCSprite* spBloodtrace = [[CCSprite alloc] initWithFile:@"Slash.png"]; // bloodtrace ---> Slash
					spBloodtrace.scaleX = g_fScaleX; spBloodtrace.scaleY = g_fScaleY;
					spBloodtrace.position = sp.position;
					spBloodtrace.rotation = sp.rotation;
					[self addChild:spBloodtrace z:0];
					[self performSelector:@selector(removeOther:) withObject:spBloodtrace afterDelay:2.f];
					[spBloodtrace release];
					
					fish_path = [[NSString alloc] initWithFormat:@"candy%02d.png", sp.type];	/// modified by song fish ---> candy
					fishseg = [[CCSprite alloc] initWithFile:fish_path]; [fish_path release];
					fishseg.scaleX = g_fScaleX; fishseg.scaleY = g_fScaleY;
					[self addChild:fishseg]; fishseg.rotation = -sp.rotation;
					
					if(sp.flipX) {
						fishseg.flipX = YES;
						[fishseg setTextureRect:CGRectMake(sp.contentSize.width / 2, 0, sp.contentSize.width / 2, sp.contentSize.height)];
						[sp setTextureRect:CGRectMake(0, 0, sp.contentSize.width / 2, sp.contentSize.height)];
					}
					else{
						[fishseg setTextureRect:CGRectMake(0, 0, sp.contentSize.width / 2, sp.contentSize.height)];
						[sp setTextureRect:CGRectMake(sp.contentSize.width / 2, 0, sp.contentSize.width / 2, sp.contentSize.height)];
					}
					
					fishseg.position = ccp(sp.position.x - 30 * g_fScaleX, sp.position.y);
					sp.position = ccp(sp.position.x + 30 * g_fScaleX, sp.position.y);
					id act_mov_l = [CCMoveBy actionWithDuration:1.5f position:ccp(-10 * g_fScaleX, -100 * g_fScaleY)];
					id act_mov_r = [CCMoveBy actionWithDuration:1.5f position:ccp(10 * g_fScaleX, -100 * g_fScaleY)];
					id act_fade = [CCFadeOut actionWithDuration:1.5f];
					[fishseg runAction:[CCSpawn actions:act_mov_l, act_fade, nil]];
					[sp runAction:[CCSpawn actions:act_mov_r, act_fade, nil]];
					
					[self performSelector:@selector(removefish:) withObject:sp afterDelay:1.6f];
					[self performSelector:@selector(removeOther:) withObject:fishseg afterDelay:1.6f];
					[fishseg release];
				}
				
				while (catched_fishes.count > 0) {
					sp = [catched_fishes objectAtIndex:0];
					[catched_fishes removeObject:sp];
					[sp stopMove];
					
					CCSprite* spBloodtrace = [[CCSprite alloc] initWithFile:@"Slash.png"]; // modified by song bloodtrace ---> Slash
					spBloodtrace.scaleX = g_fScaleX; spBloodtrace.scaleY = g_fScaleY;
					spBloodtrace.position = sp.position;
					[self addChild:spBloodtrace z:0];
					[self performSelector:@selector(removeOther:) withObject:spBloodtrace afterDelay:2.f];
					[spBloodtrace release];
					
					fish_path = [[NSString alloc] initWithFormat:@"candy%02d.png", sp.type];	// modified by song fish ----> candy
					fishseg = [[CCSprite alloc] initWithFile:fish_path]; [fish_path release];
					fishseg.scaleX = g_fScaleX; fishseg.scaleY = g_fScaleY;
					[self addChild:fishseg]; fishseg.rotation = -sp.rotation;
					
					if(sp.flipX) {
						fishseg.flipX = YES;
						[fishseg setTextureRect:CGRectMake(sp.contentSize.width / 2, 0, sp.contentSize.width / 2, sp.contentSize.height)];
						[sp setTextureRect:CGRectMake(0, 0, sp.contentSize.width / 2, sp.contentSize.height)];
					}
					else{
						[fishseg setTextureRect:CGRectMake(0, 0, sp.contentSize.width / 2, sp.contentSize.height)];
						[sp setTextureRect:CGRectMake(sp.contentSize.width / 2, 0, sp.contentSize.width / 2, sp.contentSize.height)];
					}
					
					fishseg.position = ccp(sp.position.x - 30 * g_fScaleX, sp.position.y);
					sp.position = ccp(sp.position.x + 30 * g_fScaleX, sp.position.y);
					id act_mov_l = [CCMoveBy actionWithDuration:1.5f position:ccp(-10 * g_fScaleX, -100 * g_fScaleY)];
					id act_mov_r = [CCMoveBy actionWithDuration:1.5f position:ccp(10 * g_fScaleX, -100 * g_fScaleY)];
					id act_fade = [CCFadeOut actionWithDuration:1.5f];
					[fishseg runAction:[CCSpawn actions:act_mov_l, act_fade, nil]];
					[sp runAction:[CCSpawn actions:act_mov_r, act_fade, nil]];
					
					[self performSelector:@selector(removefish:) withObject:sp afterDelay:1.6f];
					[self performSelector:@selector(removeOther:) withObject:fishseg afterDelay:1.6f];
					[fishseg release];
				}
				
				[self performSelector:@selector(loadScoreScene:) withObject:self afterDelay:2.f];
				//[self unschedule:@selector(catchFish)];
				return;
			}
		}
	}
	
	if(m_nCatchFishNum == 1) {
		[self getChildByTag:kTagLabelCatchCount].visible = YES;
		[self getChildByTag:kTagCatchCount].visible = YES;
		
		if (m_nGameState == GAME_TILTDOWN || m_nGameState == GAME_DOWNSTOP)
		{
			[self unschedule:@selector(loadWall)];
			[self unschedule:@selector(moveWall)];
			
			if (m_nDepth > 300) {

				[self unschedule:@selector(generateMine)];
				[self unschedule:@selector(moveMine)];
			}
            
			g_UserInfo.nCurDepth = m_nDepth;
			
			if (g_bSetup) {
				[self unschedule:@selector(generateFish)];
				for (FishSprite *fish in fishes) {
					[fish stopMove];
				}
				m_nGameState = GAME_TAPFOURTH;m_bTouch = YES;
				
				[self unschedule:@selector(catchFish)];
				[self performSelector:@selector(onTouchEnable) withObject:nil afterDelay:0.5f];
				
				[(CCLabelTTF*)[[spLine getChildByTag:2] getChildByTag:1] removeAllChildrenWithCleanup:YES];
				[(CCLabelTTF*)[[spLine getChildByTag:2] getChildByTag:1] setString:@"CATCH"];
				[(CCLabelTTF*)[[spLine getChildByTag:2] getChildByTag:1] setColor:ccBLUE];
				[self getChildByTag:kTagMessage].position = ccp(g_size.width / 2, 200 * g_fScaleY);
				
				m_nTime = 0;
				[self performSelector:@selector(changeMessage:) withObject:[self getChildByTag:kTagMessage]];
				[self schedule:@selector(hintMessage:) interval:INTERVAL_CHANGEDEPTH];
				//[self performSelector:@selector(changeMessage:) withObject:[self getChildByTag:kTagMessage] afterDelay:0.5f];
			}
			else {
				m_nGameState = GAME_TILTUP;
				[self unschedule:@selector(changeDepth:)];
				[self schedule:@selector(changeDepth:) interval:m_rSpeed / MOVE_SCALE];
				
				[self unschedule:@selector(generateFish)];
				[self schedule:@selector(generateFish) interval:nInterval_generatefish / MOVE_SCALE];
				
				[self schedule:@selector(loadWall) interval:nInterval_loadwall / MOVE_SCALE];
				[self schedule:@selector(moveWall)];
                //				if (m_nDepth == g_UserInfo.nMaxDepth) {
                //					[self schedule:@selector(changeDepth:) interval:m_rSpeed];
                //				}
			}
			
			if (m_nDepth > 300) {
				[self schedule:@selector(generateMine) interval:INTERVAL_GENMINE / MOVE_SCALE];
				[self schedule:@selector(moveMine)];
			}
		}
	}
	
	if (!g_bSetup && catched_fishes.count > 1) {
		m_nGameState = GAME_TILTUP;
	}
	
	for (int i = 0; i < fishes.count; i++)
	{
		spfish = (FishSprite *)[fishes objectAtIndex:i];
		
		if (m_fDrill)
		{
			CGRect t = spfish.boundingBox;
			if (CGRectIntersectsRect(t, rectDrill))
			{
				[g_GameUtils playSoundEffect:@"fishkill.wav"];
				[fishes removeObject:spfish];
				[spfish stopMove];i--;
				
				NSString *fish_path = [[NSString alloc] initWithFormat:@"candy%02d.png", spfish.type];
				CCSprite *fishseg = [[CCSprite alloc] initWithFile:fish_path];[fish_path release];
				fishseg.scaleX = g_fScaleX; fishseg.scaleY = g_fScaleY;
				[self addChild:fishseg];
				
				spfish.rotation = 45; fishseg.rotation = -45;
				
				if(spfish.flipX) {
					fishseg.flipX = YES;
					[fishseg setTextureRect:CGRectMake(spfish.contentSize.width / 2, 0, spfish.contentSize.width / 2, spfish.contentSize.height)];
					[spfish setTextureRect:CGRectMake(0, 0, spfish.contentSize.width / 2, spfish.contentSize.height)];
				}
				else{
					[fishseg setTextureRect:CGRectMake(0, 0, spfish.contentSize.width / 2, spfish.contentSize.height)];
					[spfish setTextureRect:CGRectMake(spfish.contentSize.width / 2, 0, spfish.contentSize.width / 2, spfish.contentSize.height)];
				}
				
				fishseg.position = ccp(spfish.position.x - 30 * g_fScaleX, spfish.position.y);
				spfish.position = ccp(spfish.position.x + 30 * g_fScaleX, spfish.position.y);
				
				id act_mov_l = [CCMoveBy actionWithDuration:1.f position:ccp(-30 * g_fScaleX, -50 * g_fScaleY)];
				id act_mov_r = [CCMoveBy actionWithDuration:1.f position:ccp(30 * g_fScaleX, -50 * g_fScaleY)];
				id act_fade = [CCFadeOut actionWithDuration:1.f];
				
				[fishseg runAction:[CCSpawn actions:act_mov_l, act_fade, nil]];
				[spfish runAction:[CCSpawn actions:act_mov_r, act_fade, nil]];
				
				[self performSelector:@selector(removefish:) withObject:spfish afterDelay:1.1f];
				[self performSelector:@selector(removeOther:) withObject:fishseg afterDelay:1.1f];
				
				[self onBlood:spfish dir:YES];
				[self onBlood:fishseg dir:NO];[fishseg release];
			}
		}
		else
		{
			if (CGRectIntersectsRect(spfish.boundingBox, rectHook))
			{
				[g_GameUtils playSoundEffect:@"hook.wav"];
				[fishes removeObject:spfish];
				[spfish stopMove];i--;
				
				[catched_fishes addObject:spfish];
				m_nCatchFishNum ++;
				[[self getChildByTag:kTagCatchCount] removeAllChildrenWithCleanup:YES];
				[(CCLabelTTF*)[self getChildByTag:kTagCatchCount] setString:[NSString stringWithFormat:@"%d", m_nCatchFishNum]];
                
				if(spfish.flipX)  {
					[spfish setAnchorPoint:ccp(1.f, 0.5f)];
					[spfish setRotation:-(50 + (rand() % 3) * 6)];
					id act_swing_down = [CCRotateTo actionWithDuration:0.2f angle:-(40 + (rand() % 3) * 6)];
					id act_swing_up = [CCRotateTo actionWithDuration:0.2f angle:-(60 + (rand() % 3) * 6)];
					[spfish runAction:[CCRepeatForever actionWithAction:[CCSequence actions:act_swing_down, act_swing_up, nil]]];
				}
				else {
					[spfish setAnchorPoint:ccp(0, 0.5f)];
					[spfish setRotation:(50 + (rand() % 3) * 6)];
					id act_swing_down = [CCRotateTo actionWithDuration:0.2f angle:(40 + (rand() % 3) * 6)];
					id act_swing_up = [CCRotateTo actionWithDuration:0.2f angle:(60 + (rand() % 3) * 6)];
					[spfish runAction:[CCRepeatForever actionWithAction:[CCSequence actions:act_swing_down, act_swing_up, nil]]];
				}
				spfish.position = spHook.position;
			}
		}
	}
}

-(void) releaseObject
{
	[self stopAllActions];
    
	int i;
	[((CCMenuItemImage*)[[self getChildByTag:kTagMainMenu] getChildByTag:0]).normalImage removeFromParentAndCleanup:YES];
	[((CCMenuItemImage*)[[self getChildByTag:kTagMainMenu] getChildByTag:0]).selectedImage removeFromParentAndCleanup:YES];
	
	for (i = kTagMainMenu; i <= kTagMainBg3; i++) {
		if ([self getChildByTag:i]) {			
			[[self getChildByTag:i] removeAllChildrenWithCleanup:YES];
			[self removeChildByTag:i cleanup:YES];
		}
	}
	
	for (i = 0; i < LINE_NUM; i ++) {
		[[CCTextureCache sharedTextureCache] removeTexture:[m_spLine[i] texture]];
		[self removeChild:m_spLine[i] cleanup:YES];
		[[CCTextureCache sharedTextureCache] removeTexture:[m_spPoint[i] texture]];
		[self removeChild:m_spPoint[i] cleanup:YES];
	}
    
	FishSprite* fish;
	
	if (slash_fishes) 
	{		
		for (i = 0; i < slash_fishes.count; i++) {
			fish = [slash_fishes objectAtIndex:i];
			[fish stopAllActions];
			[fish releasefish];
		}
	}
    
	if (fishes) {
		while (fishes.count > 0) {
			fish = [fishes objectAtIndex:0];
			[fishes removeObject:fish];
			[self removefish:fish];
		}
		
		[fishes release]; fishes = nil;
	}
    
	if (catched_fishes) {
		while (catched_fishes.count > 0) {
			fish = [catched_fishes objectAtIndex:0];
			[catched_fishes removeObject:fish];
			[self removefish:fish];
		}
		
		[catched_fishes release]; catched_fishes = nil;
	}
	
	CCSprite* sp;
	if (m_szWalls) {
		while (m_szWalls.count > 0) {
			sp = [m_szWalls objectAtIndex:0];
			[m_szWalls removeObject:sp];
			[self removeOther:sp];
			[sp release];
		}
		
		[m_szWalls release];m_szWalls = nil;
	}
    
	if (m_szMines) {
		while (m_szMines.count > 0) {
			sp = [m_szMines objectAtIndex:0];
			[m_szMines removeObject:sp];
			[self removeOther:sp];
			[sp release];
		}
		
		[m_szMines release];m_szMines = nil;
	}
    
	//[g_GameUtils stopBackgroundMusic];
    
	[self removeFromParentAndCleanup:YES];
	
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (void) dealloc
{	
	[super dealloc];
}

@end
