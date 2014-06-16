//
//  PauseGameSprite.m
//  NinjaFish
//
//  Created by Techintegrity Services on 9/14/11.
//  Copyright 2011 Techintegrity Services. All rights reserved.
//

#import "PauseGameSprite.h"
#import "GameConfig.h"
#import "MainMenuScene.h"
#import "FishSprite.h"
#import "GameScene.h"
#import "Tools.h"

int m_nGameState;

@implementation PauseGameSprite

-(id) initSprite
{
    return [self initSprite:0];
}

-(id) initSprite:(int) mode
{
    if(mode == 0)
        [self initWithFile:[Tools imageNameForName:@"pause-BG"]];
	else
        [self initWithFile:[Tools imageNameForName:@"option-BG"]];

	itemSoundD = [CCMenuItemImage itemFromNormalImage:@"-.png" selectedImage:@"-.png"
																target:self selector:@selector(soundD:)];
	itemSoundD.position = ccp(self.contentSize.width * 0.44f, self.contentSize.height * 0.72f);
	
	itemSoundI = [CCMenuItemImage itemFromNormalImage:@"+.png" selectedImage:@"+.png"
																target:self selector:@selector(soundI:)];
	itemSoundI.position = ccp(self.contentSize.width * 0.82f, self.contentSize.height * 0.72f);
	
	NSString *str = [NSString stringWithFormat:@"%d", (int)(g_rSound * 100)];
	
    label_Sound_Value = [[CCLabelTTF alloc] initWithString:str fontName:@"BADABB_.TTF" fontSize:24.0f];
	//label_Sound_Value.scaleX = 0.5f; label_Sound_Value.scaleY = 0.5f;
	label_Sound_Value.position = ccp(self.contentSize.width * 0.64f, self.contentSize.height * 0.72f);
	[self addChild:label_Sound_Value z:1 tag:3];[label_Sound_Value release];
    
	itemMusicD = [CCMenuItemImage itemFromNormalImage:@"-.png" selectedImage:@"-.png"
																target:self selector:@selector(musicD:)];
	itemMusicD.position = ccp(self.contentSize.width * 0.44f, self.contentSize.height * 0.54f);
	
	itemMusicI = [CCMenuItemImage itemFromNormalImage:@"+.png" selectedImage:@"+.png"
																target:self selector:@selector(musicI:)];
	itemMusicI.position = ccp(self.contentSize.width * 0.82f, self.contentSize.height * 0.54f);
	
	str = [NSString stringWithFormat:@"%d", (int)(g_rMusic * 100)];

    label_Music_Value = [[CCLabelTTF alloc] initWithString:str fontName:@"BADABB_.TTF" fontSize:24.0f];
	//label_Sound_Value.scaleX = 0.5f; label_Sound_Value.scaleY = 0.5f;
	label_Music_Value.position = ccp(self.contentSize.width * 0.64f, self.contentSize.height * 0.54f);
	[self addChild:label_Music_Value z:1 tag:4];[label_Music_Value release];
	
	itemReset = [CCMenuItemImage itemFromNormalImage:@"return-button.png" selectedImage:@"return-button.png"
															   target:self selector:@selector(returnGame:)];
	itemReset.position = ccp(self.contentSize.width * 0.5f, self.contentSize.height * 0.31f);
	itemReset.tag = 1;
	
	itemGo = [CCMenuItemImage itemFromNormalImage:@"exit-button.png" selectedImage:@"exit-button.png"
															target:self selector:@selector(goMenu:)];
	itemGo.position = ccp(self.contentSize.width * 0.5f, self.contentSize.height * 0.14f);
	itemGo.tag = 2;
	
	menu1 = [CCMenu menuWithItems:itemSoundD, itemSoundI, 
					itemMusicD, itemMusicI, itemReset, itemGo, nil];
	menu1.position = ccp(0, 0); [self addChild:menu1 z:1 tag:0];	
	
	return self;
}

-(void) soundD : (id)sender
{
	if (g_rSound <= 0) return;
	g_rSound -= 0.01f; 
	[g_GameUtils setSoundEffectVolume:g_rSound];
	[g_GameUtils playSoundEffect:@"button.wav"];
	
	NSString *str = [NSString stringWithFormat:@"%d", (int)(g_rSound * 100)];
	[label_Sound_Value setString:str];
}

-(void) soundI : (id)sender
{
	if (g_rSound >= 1) return;
	g_rSound += 0.01f;

	[g_GameUtils setSoundEffectVolume:g_rSound];
	[g_GameUtils playSoundEffect:@"button.wav"];
	NSString *str = [NSString stringWithFormat:@"%d", (int)(g_rSound * 100)];
	[label_Sound_Value setString:str];
}

-(void) musicD : (id)sender
{
	if (g_rMusic <= 0) return;
	g_rMusic -= 0.01f;

    [g_GameUtils playSoundEffect:@"button.wav"];
	[g_GameUtils setMusicVolume:g_rMusic];
	
	NSString *str = [NSString stringWithFormat:@"%d", (int)(g_rMusic * 100)];
	[label_Music_Value setString:str];
}

-(void) musicI : (id)sender
{
	if (g_rMusic >= 1) return;
	g_rMusic += 0.01f;
	[g_GameUtils playSoundEffect:@"button.wav"];
	[g_GameUtils setMusicVolume:g_rMusic];
	
	NSString *str = [NSString stringWithFormat:@"%d", (int)(g_rMusic * 100)];
	[label_Music_Value setString:str];
}

-(void) returnGame : (id)sender
{
	[itemReset setIsEnabled:NO];
	[g_GameUtils playSoundEffect:@"button.wav"];
	id action = [CCScaleTo actionWithDuration:0.1f scaleX:SCALE scaleY:SCALE];
	id reaction = [CCScaleTo actionWithDuration:0.1f scaleX:1.f scaleY:1.f];
	
	[itemReset runAction:[CCSequence actions: action, reaction, nil]];
	[self schedule:@selector(removeOption:) interval:0.3f];
}

-(void) removeOption:(ccTime)dt
{
	[self unschedule:@selector(removeOption:)];
	[self runAction:[CCMoveTo actionWithDuration:0.2f position:ccp(g_size.width * 3 / 2, g_size.height / 2)]];

	int i;
	for (i = 0; i <= 40; i++) {
		if ([self.parent getChildByTag:i]) {
			[[self.parent getChildByTag:i] resumeSchedulerAndActions];
			[(CCSprite *)[self.parent getChildByTag:i] setOpacity:255];
		}		
	}

	if (m_nGameState >= GAME_TILTDOWN) 
	for(FishSprite* fish in fishes)
	{
		[fish setOpacity:255];
		[fish startMove];
	}
	if (m_nGameState >= GAME_TILTUP) 
	for(FishSprite* fish in catched_fishes)
	{
		[fish setOpacity:255];
		[fish resumeSchedulerAndActions];	
	}
	
	if (m_nGameState >= GAME_SLASH) 
	for(FishSprite* fish in slash_fishes)
	{
		[fish setOpacity:255];
		[fish resumeSchedulerAndActions];		
	}
	if (m_nGameState >= GAME_TILTDOWN) 
	for(CCSprite* wall in m_szWalls)
	{
		[wall setOpacity:255];
		[wall resumeSchedulerAndActions];		
	}

	if (m_nGameState >= GAME_TILTDOWN)
	if (m_szMines) {
		for (CCSprite *mine in m_szMines) {
			[mine resumeSchedulerAndActions];
			mine.opacity = 255;
		}
	}

	[self.parent resumeSchedulerAndActions];
	
	((CCLayer*)self.parent).isTouchEnabled = YES;
	[(CCMenuItemImage*)[[self.parent getChildByTag:0] getChildByTag:0] setIsEnabled:YES];
	
	[self performSelector:@selector(freeMemory) withObject:self afterDelay:0.3f];
}

-(void) goMenu : (id)sender
{
	[itemGo setIsEnabled:NO];
	[g_GameUtils playSoundEffect:@"button.wav"];
	id action = [CCScaleTo actionWithDuration:0.1f scaleX:SCALE scaleY:SCALE];
	id reaction = [CCScaleTo actionWithDuration:0.1f scaleX:1.f scaleY:1.f];
	
	[itemGo runAction:[CCSequence actions: action, reaction, nil]];	
	[self schedule:@selector(onGoMenu:) interval:0.3f];
}

-(void) onGoMenu : (ccTime)dt
{
	[self unschedule:@selector(onGoMenu:)];
	
	[self performSelector:@selector(freeMemory)];	
	[self.parent performSelector:@selector(releaseObject)];
	
	NSString *r = @"CCTransitionFade";
	Class transion = NSClassFromString(r);
	[[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:1.0f scene:[MainMenuScene node]]];			
}

-(void) freeMemory
{
	[self removeSprite:spBox0];
	[self removeSprite:spBox1];
	[self removeMenuItem:itemSoundD];
	[self removeMenuItem:itemSoundI];
	[self removeMenuItem:itemMusicD];
	[self removeMenuItem:itemMusicI];
	[self removeMenuItem:itemReset];
	[self removeMenuItem:itemGo];
	[menu1 removeFromParentAndCleanup:YES];
	[self removeLabel:label_Option];
	[self removeLabel:label_Sound];
	[self removeLabel:label_Music];
	[self removeLabelTTF:label_Sound_Value];
	[self removeLabelTTF:label_Music_Value];
	
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
	[[CCTextureCache sharedTextureCache] removeAllTextures];
	
	[self removeAllChildrenWithCleanup:YES];
	[self removeFromParentAndCleanup:YES];
}

-(void) removeLabel : (CCLabelBMFont*)label
{
	[[CCTextureCache sharedTextureCache] removeTexture:[label texture]];
	[label removeAllChildrenWithCleanup:YES];
	[label removeFromParentAndCleanup:YES];	
}

-(void) removeLabelTTF : (CCLabelTTF*)label
{
	[[CCTextureCache sharedTextureCache] removeTexture:[label texture]];
	[label removeAllChildrenWithCleanup:YES];
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

@end
