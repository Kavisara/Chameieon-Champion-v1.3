//
//  MainMenuScene.m
//  NinjaFish
//
//  Created by Techintegrity Services on 9/7/11.
//  Copyright 2011 Techintegrity Services. All rights reserved.
//

#import "MainMenuScene.h"
#import "NinjaFishingAppDelegate.h"
#import "GameScene.h"
#import "SelectionController.h"
#import "ConsultationEmail.h"
#import "Tools.h"
#import "PauseGameSprite.h"
#import "NinjaFishingAppDelegate.h"

int ITEMSTATE[SHOPITEM_COUNT] = {1,0,0,0,0,0,1,0,0,0,2,1,0,0,1,1,1,1,1,0,1,0,0,0,0,0};

enum TAG_MAIN {
	kTagMainBg,
	kTagLabel,
	kTagMenu,
	kTagOptionBg
};

enum TAG_MENU_ITEM {
	kTagPlay,
	kTagOption,
	kTagMail,
	kTagF,
	kTagT,
	kTagG,
	kTagL
};

enum TAG_OPTION {
	kTagLabelOption,
	kTagLabelSound,
	kTagSoundBg,
	kTagSoundVal,
	kTagLabelMusic,
	kTagMusicBg,
	kTagMusicVal,
	kTagOptionMenu
};

enum TAG_OPTIONMENU_ITEM {
	kTagSoundD,
	kTagSoundI,
	kTagMusicD,
	kTagMusicI,
	kTagReset,
	kTagGo
};

@implementation MainMenuScene

+(id) scene
{
	CCScene *scene = [CCScene node];
	MainMenuScene *layer = [MainMenuScene node];
	[scene addChild: layer];
	return scene;
}

- (void) actionFreeGame: (id) sender
{
    NinjaFishingAppDelegate* del = (NinjaFishingAppDelegate*)[UIApplication sharedApplication].delegate;
    [del dispFreeGames];
}

- (void) openMoreApps: (id) sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    NinjaFishingAppDelegate* del = (NinjaFishingAppDelegate*)[UIApplication sharedApplication].delegate;
    [del dispMoreGames];
}

-(id) init
{
	if( (self=[super init] )) {
        
		[[CCTextureCache sharedTextureCache] removeAllTextures];
		[g_GameUtils playBackgroundMusic:@"MenuMusic.mp3"];
        
        CCSprite *bgSprite;
        //  BG Sprite
        if([Tools is4inchPhone])
            bgSprite = [CCSprite spriteWithFile:@"MainScreen_BG-568h@2x.png"];
        else
            bgSprite = [CCSprite spriteWithFile:[Tools imageNameForName:@"MainScreen_BG"]];
        
        bgSprite.anchorPoint = ccp(0.0f, 0.0f);
        [self addChild:bgSprite];
        bgSprite.position = ccp(0.0f, 0.0f);
		
        
        //  Btns (FB, Not Now)
        btnItemPlay = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"play"]
                                             selectedImage:[Tools imageNameForName:@"play"] target:self selector:@selector(OnBtnPlay:)];
        btnItemPlay.anchorPoint = ccp(0.0, 1.0);
        
        btnItemOption = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"option"]
                                           selectedImage:[Tools imageNameForName:@"option"] target:self selector:@selector(OnOption:)];
        btnItemOption.anchorPoint = ccp(0.0, 1.0);

        btnItemGameCenter = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"g"]
                                               selectedImage:[Tools imageNameForName:@"g"] target:self selector:@selector(OnGameCenter:)];
        btnItemGameCenter.anchorPoint = ccp(0.0, 1.0);
        
        btnItemBonus = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"bonus"]
                                              selectedImage:[Tools imageNameForName:@"bonus"] target:self selector:@selector(OnBonus:)];
        btnItemBonus.anchorPoint = ccp(0.0, 1.0);
        btnItemBonus.scale =1.4;
        
        if(IS_IPAD())
        {
            btnItemPlay.position = ccp(-200, 410);
            btnItemOption.position = ccp(-100, 110);
            btnItemGameCenter.position = ccp(-100, 240);
            btnItemBonus.position = ccp(800, 173);
        }
        else if([Tools is4inchPhone])
        {
            btnItemPlay.position = ccp(-160, 240);
            btnItemOption.position = ccp(-50, 100);
            btnItemGameCenter.position = ccp(-50, 145);
            btnItemBonus.position = ccp(300, 80);
        }
        else
        {
            btnItemPlay.position = ccp(-160 * g_fScaleX, 230 * g_fScaleY);
            btnItemOption.position = ccp(-50 * g_fScaleX, 60 * g_fScaleY);
            btnItemGameCenter.position = ccp(-50 * g_fScaleX, 125 * g_fScaleY);
            btnItemBonus.position = ccp(300 * g_fScaleX, 80 * g_fScaleY);
        }
        
		CCMenu* menu = [CCMenu menuWithItems:btnItemPlay, btnItemOption, btnItemGameCenter,btnItemBonus, nil];
		menu.position = ccp(0, 0);
        [self addChild:menu];
		
		[self schedule:@selector(loadItem:) interval:0.5f];
		
		if ([self GetUserInfoFromFile] == NO)
        {
			[self initUserInfo];
			g_bSetup = TRUE;
		}
	}
	return self;
}

-(void) loadItem:(ccTime)dt
{
	if (m_nTick == 1) {
		[btnItemPlay runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(g_size.width / 2,  220 * g_fScaleY)]];
        
        if(IS_IPAD())
        {
            [btnItemPlay runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(140, 410)]];
        }
        else if([Tools is4inchPhone])
        {
            [btnItemPlay runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(25, 240)]];
        }
        else
        {
            [btnItemPlay runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(25 * g_fScaleX, 230 * g_fScaleY)]];
        }
	}
	else if (m_nTick == 2) {
        
		[self unschedule:@selector(loadItem:)];
        
        if(IS_IPAD())
        {
            [btnItemOption runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(15, 110)]];
            [btnItemGameCenter runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(15, 240)]];
            [btnItemBonus runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(550, 173)]];
        }
        else if([Tools is4inchPhone])
        {
            [btnItemOption runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(10, 60)]];
            [btnItemGameCenter runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(10, 145)]];
            [btnItemBonus runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(170, 120)]];
        }
        else
        {
            [btnItemOption runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(10 * g_fScaleX, 60 * g_fScaleY)]];
            [btnItemGameCenter runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(10 * g_fScaleX, 125 * g_fScaleY)]];
            [btnItemBonus runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(170 * g_fScaleX, 120 * g_fScaleY)]];
        }
	}

	m_nTick ++;
}

-(BOOL) GetUserInfoFromFile
{
	NSString *szFile;
	NSArray * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [path objectAtIndex:0];
	
	szFile = [documentDirectory stringByAppendingPathComponent:@"ninjafish.dat"];
	
	FILE *fp = fopen([szFile cStringUsingEncoding:1], "rb");
	if(fp == nil) return NO;
	
	fread(&g_UserInfo, sizeof(USER_INFO), 1, fp);
	fread(g_ITEMSTATE, sizeof(int), SHOPITEM_COUNT, fp);
	fread(fishType, sizeof(int), FISHTYPE_NUM, fp);
	
	fclose(fp);
	return YES;
}

+(void)saveUserInfo
{
	NSArray * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [path objectAtIndex:0];
	NSString *szFile = [documentDirectory stringByAppendingPathComponent:@"ninjafish.dat"];
	
	FILE *fp = fopen([szFile cStringUsingEncoding:1], "wb");
	if(fp == nil) return;

	fwrite(&g_UserInfo, sizeof(USER_INFO), 1, fp);
	fwrite(g_ITEMSTATE, sizeof(int), SHOPITEM_COUNT, fp);
	fwrite(fishType, sizeof(int), FISHTYPE_NUM, fp);
	
	fclose(fp);
}

-(void) initUserInfo
{
	g_UserInfo.nMoney = 0;		g_UserInfo.nScore = 0;	
	g_UserInfo.nTotalScore = 0;	g_UserInfo.nTotalDepth = 0;
	g_UserInfo.nCurDepth = 0;	g_UserInfo.nMaxDepth = 75;
	g_UserInfo.nBlade = 1;		g_UserInfo.nFuel = 50;
	g_UserInfo.nSpeed = 0;		g_UserInfo.nSale = 0;
	g_UserInfo.nLantern = 0;	g_UserInfo.nHook = 25;
	g_UserInfo.nWeight = 0;		g_UserInfo.nFishTypeNum = 0;
	int i;
	for (i = 0; i < SHOPITEM_COUNT; i++) 
		g_ITEMSTATE[i] = ITEMSTATE[i];
	for (i = 0; i < FISHTYPE_NUM; i++)
		fishType[i] = -1;
	
	[MainMenuScene saveUserInfo];
}

-(void) OnBtnPlay : (id)sender
{
	[g_GameUtils playSoundEffect:@"PlayButton.wav"];
	
	id action = [CCScaleTo actionWithDuration:0.1f scaleX:SCALE * g_fScaleX scaleY:SCALE * g_fScaleY];
	id reaction = [CCScaleTo actionWithDuration:0.1f scaleX:g_fScaleX scaleY:g_fScaleY];

	[btnItemPlay runAction:[CCSequence actions: action, reaction, nil]];
	[self schedule:@selector(onPlay:) interval:0.3f];
}

-(void) onPlay:(ccTime)dt
{
	[self unschedule:@selector(onPlay:)];
	[self performSelector:@selector(removeBg) withObject:self afterDelay:0.9f];
	
	NSString *r = @"CCTransitionFade";
	Class transion = NSClassFromString(r);
    
  	//[[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:1.0f scene:[SelectionController scene]]];
    [[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:1.0f scene:[GameScene scene]]];
}

-(void) OnOption: (id)sender
{
	
	self.isTouchEnabled = NO;
	[g_GameUtils playSoundEffect:@"Button_All.mp3"];
	//[g_GameUtils playSoundEffect:@"window.wav"];
	
	[self pauseSchedulerAndActions];

    
	PauseGameSprite *bgOptionSP = [[PauseGameSprite alloc] initSprite:1];
	bgOptionSP.scaleX = g_fScaleX; bgOptionSP.scaleY = g_fScaleY;
	bgOptionSP.position = ccp(g_size.width * 3 / 2, g_size.height / 2);
	
	[self addChild:bgOptionSP];
	[bgOptionSP runAction:[CCMoveTo actionWithDuration:0.2f position:ccp(g_size.width / 2, g_size.height / 2)]];
	[bgOptionSP release];
}

-(void) soundD : (id)sender
{
	if (g_rSound <= 0.f) return;
	g_rSound -= 0.01f; 
	
	[g_GameUtils setSoundEffectVolume:g_rSound];
	[g_GameUtils playSoundEffect:@"Button_All.mp3"];
	
	NSString *str = [NSString stringWithFormat:@"%d%%%", (int)(g_rSound * 100)];
	[(CCLabelBMFont*)[bgOption getChildByTag:kTagSoundVal] setString:str];
}

-(void) soundI : (id)sender
{
	if (g_rSound >= 1.f) return;
	g_rSound += 0.01f;
	
	[g_GameUtils setSoundEffectVolume:g_rSound];
	[g_GameUtils playSoundEffect:@"Button_All.mp3"];
	
	NSString *str = [NSString stringWithFormat:@"%d%%%", (int)(g_rSound * 100)];
	[(CCLabelBMFont*)[bgOption getChildByTag:kTagSoundVal] setString:str];
}

-(void) musicD : (id)sender
{
	if (g_rMusic <= 0.f) return;
	g_rMusic -= 0.01f;
	[g_GameUtils setMusicVolume:g_rMusic];
	
	NSString *str = [NSString stringWithFormat:@"%d%%%", (int)(g_rMusic * 100)];
	[(CCLabelBMFont*)[bgOption getChildByTag:kTagMusicVal] setString:str];
}

-(void) musicI : (id)sender
{
	if (g_rMusic >= 1.f) return;
	g_rMusic += 0.01f;
	[g_GameUtils setMusicVolume:g_rMusic];
	
	NSString *str = [NSString stringWithFormat:@"%d%%%", (int)(g_rMusic * 100)];
	[(CCLabelBMFont*)[bgOption getChildByTag:kTagMusicVal] setString:str];
}

-(void) reset : (id)sender
{
	[(CCMenuItemImage*)[[bgOption getChildByTag:kTagOptionMenu] getChildByTag:kTagReset] setIsEnabled:NO];
	[g_GameUtils playSoundEffect:@"button.wav"];
	id action = [CCScaleTo actionWithDuration:0.1f scaleX:SCALE scaleY:SCALE];
	id reaction = [CCScaleTo actionWithDuration:0.1f scaleX:1.f scaleY:1.f];
	
	[[[bgOption getChildByTag:kTagOptionMenu] getChildByTag:kTagReset] runAction:[CCSequence actions: action, reaction, nil]];
	 
	NSString *str = [NSString stringWithFormat:@"Are you really sure!\nThis will reset all your progress and upgrades and reset tokens to zero."];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"WARNING!" message:str delegate:self 
											  cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
	[alertView show]; [alertView release]; alertView = nil;
}

-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[g_GameUtils playSoundEffect:@"Button_All.mp3"];
	if (buttonIndex != 0) {
		[self initUserInfo];
	}
}

-(void) goMenu : (id)sender
{
	[(CCMenuItemImage*)[[bgOption getChildByTag:kTagOptionMenu] getChildByTag:kTagGo] setIsEnabled:NO];
	[g_GameUtils playSoundEffect:@"Button_All.mp3"];
	//[g_GameUtils playSoundEffect:@"window.wav"];
	
	id action = [CCScaleTo actionWithDuration:0.1f scaleX:SCALE scaleY:SCALE];
	id reaction = [CCScaleTo actionWithDuration:0.1f scaleX:1.f scaleY:1.f];
	
	[[[bgOption getChildByTag:kTagOptionMenu] getChildByTag:kTagGo]	runAction:[CCSequence actions: action, reaction, nil]];	
	[bgOption runAction:[CCMoveTo actionWithDuration:0.2f 
									position:ccp(g_size.width * 3 / 2, g_size.height / 2)]];
	
	[self schedule:@selector(removeOption:) interval:0.3f];
}

-(void) removeOption:(ccTime)dt
{
	[self unschedule:@selector(removeOption:)];
	
	[self removeSprite:(CCSprite*)[bgOption getChildByTag:kTagSoundBg]];
	[self removeSprite:(CCSprite*)[bgOption getChildByTag:kTagMusicBg]];
	[self removeMenuItem:(CCMenuItemImage*)[[bgOption getChildByTag:kTagOptionMenu] getChildByTag:kTagSoundI]];
	[self removeMenuItem:(CCMenuItemImage*)[[bgOption getChildByTag:kTagOptionMenu] getChildByTag:kTagSoundD]];
	[self removeMenuItem:(CCMenuItemImage*)[[bgOption getChildByTag:kTagOptionMenu] getChildByTag:kTagMusicI]];
	[self removeMenuItem:(CCMenuItemImage*)[[bgOption getChildByTag:kTagOptionMenu] getChildByTag:kTagMusicD]];
	[self removeMenuItem:(CCMenuItemImage*)[[bgOption getChildByTag:kTagOptionMenu] getChildByTag:kTagReset]];
	[self removeMenuItem:(CCMenuItemImage*)[[bgOption getChildByTag:kTagOptionMenu] getChildByTag:kTagGo]];
	[[bgOption getChildByTag:kTagOptionMenu] removeFromParentAndCleanup:YES];
	[self removeLabel:(CCLabelBMFont*)[bgOption getChildByTag:kTagLabelOption]];
	[self removeLabel:(CCLabelBMFont*)[bgOption getChildByTag:kTagLabelSound]];
	[self removeLabel:(CCLabelBMFont*)[bgOption getChildByTag:kTagLabelMusic]];
	[self removeLabel:(CCLabelBMFont*)[bgOption getChildByTag:kTagSoundVal]];
	[self removeLabel:(CCLabelBMFont*)[bgOption getChildByTag:kTagMusicVal]];
	[self removeSprite:bgOption];
	
	[(CCSprite*)[self getChildByTag:kTagMainBg] setOpacity:255];
	[(CCLabelBMFont*)[self getChildByTag:kTagLabel] setOpacity:255];
	[(CCMenu*)[self getChildByTag:kTagMenu] setOpacity:255];
	for (int i = 1; i < 8; i++) {
		[(CCMenuItemImage*)[[self getChildByTag:kTagMenu] getChildByTag:i] setIsEnabled:YES];
	}
	
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
	[[CCTextureCache sharedTextureCache] removeAllTextures];
}

-(void) OnGameCenter : (id)sender
{
	[g_GameUtils playSoundEffect:@"button.wav"];
	
	NinjaFishingAppDelegate *delegate = [NinjaFishingAppDelegate sharedAppDelegate];
    [delegate abrirLDB];
}

-(void) OnBonus : (id)sender
{
    NinjaFishingAppDelegate* del = (NinjaFishingAppDelegate*)[UIApplication sharedApplication].delegate;
    [del dispAdvertise];
}

-(void) removeBg
{
	//[self removeSprite:(CCSprite*)[self getChildByTag:kTagMainBg]];
	//[self removeSprite:(CCSprite*)[self getChildByTag:kTagLabel]];
	//[self removeMenuItem:itemPlay];
	//[self removeMenuItem:itemOption];
	//[self removeMenuItem:itemG];
    //[self removeChild:[self getChildByTag:kTagMenu] cleanup:YES];
	
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
	[[CCTextureCache sharedTextureCache] removeAllTextures];
}

-(void) removeLabel : (CCLabelBMFont*)label
{
	[[CCTextureCache sharedTextureCache] removeTexture:[label texture]];
	[label removeFromParentAndCleanup:YES];	
}

-(void) removeSprite : (CCSprite*)sprite
{
	[[CCTextureCache sharedTextureCache] removeTexture:[sprite texture]];
	[sprite removeFromParentAndCleanup:YES];	
}

-(void) removeMenuItem : (CCMenuItemImage*)item
{
	[self removeSprite:(CCSprite*)[item normalImage]];
	[self removeSprite:(CCSprite*)[item selectedImage]];
	[item removeFromParentAndCleanup:YES];
}
- (void) dealloc
{
	[super dealloc];
}
@end
