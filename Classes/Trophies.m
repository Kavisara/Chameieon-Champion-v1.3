//
//  Trophies.m
//  NinjaFish
//
//  Created by Techintegrity Services on 9/11/11.
//  Copyright 2011 Techintegrity Services. All rights reserved.
//

#import "Trophies.h"
#import "GameConfig.h"
#import "ScoreScene.h"
#import "FishSprite.h"
#import "Tools.h"


int nNewFishType;
int newfishType [FISHTYPE_NUM];

@implementation Trophies
+(id) scene
{
	CCScene *scene = [CCScene node];
	Trophies *layer = [Trophies node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init] )) {
		self.isTouchEnabled = YES; m_bTouch = NO;
		
		CCSprite *bg = [[CCSprite alloc] initWithFile:[Tools imageNameForName:@"TrophiesBG-t"]];
		[bg setScaleX:g_fScaleX]; bg.scaleY = g_fScaleY;
		bg.position = ccp(g_size.width / 2, g_size.height / 2);
		[self addChild:bg z:1000 tag:25];
		[[CCTextureCache sharedTextureCache] removeTexture:[bg texture]];
		[bg release];
        
        CCMenuItemImage* btnBack = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"back-button"]
                                                          selectedImage:[Tools imageNameForName:@"back-button"] target:self selector:@selector(OnBack:)];
        btnBack.anchorPoint = ccp(0.0, 1.0);
        btnBack.position = ccp(25 * g_fScaleX, 475 * g_fScaleY);
        
        CCMenu* back = [CCMenu menuWithItems:btnBack,nil];
        back.tag = 1000;
		back.position = ccp(0, 0);
        [self addChild:back z:1001];

        
        CCLabelTTF *lbl = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%d",g_UserInfo.nMoney]
                                                    fontName:@"BADABB_.TTF"
                                                    fontSize:18];
        lbl.anchorPoint = ccp(1,0);
        lbl.position = ccp(50*g_fScaleX,0);
        [lbl setColor:ccGREEN]; [self addChild:lbl z:2000];[lbl release];
        
		[self performSelector:@selector(loadfishes)];
	}
    
	return self;
}

-(void) OnBack : (id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    NSString *r = @"CCTransitionFade";
	Class transion = NSClassFromString(r);
    [[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:1.0f scene:[ScoreScene scene]]];
}

-(void) loadfishes
{
	int i, j;
	FishSprite *fish; CCSprite *spBg; CCLabelTTF *label; NSString *str;
	for (i = 0; i < FISHTYPE_NUM; i ++) {
		spBg = [[CCSprite alloc] initWithFile:[Tools imageNameForName:@"Trophies-cell"]];
		spBg.scaleX = g_fScaleX; spBg.scaleY = g_fScaleY;
		spBg.position = ccp(16*g_fScaleX,g_size.height-93* g_fScaleY - i * 60 * g_fScaleY);
		spBg.anchorPoint = ccp(0,0);
        [self addChild:spBg z:0 tag:(2 + i)];
		
		str = [NSString stringWithFormat:@"candy%02d.png", i];
		fish = [[FishSprite alloc] initWithType:i flip:NO];
		
		fish.position = ccp(spBg.contentSize.width / 4, spBg.contentSize.height * 0.5);
		fish.scaleX =0.5;
		fish.scaleY =0.5;
		[spBg addChild:fish z:0 tag:0];
        
		for (j = 0; j < g_UserInfo.nFishTypeNum; j++)
		{
			if (i == fishType[j])
			{
                NSString* str = [NSString stringWithFormat:@"%d", [fish getScore]];
				label = [[CCLabelTTF alloc] initWithString:str fontName:@"BADABB_.TTF"
                                                  fontSize:18];
				label.position = ccp(spBg.contentSize.width * 0.85f, spBg.contentSize.height * 0.25f);
				[label setColor:ccWHITE];
				[spBg addChild:label z:0 tag:1];[label release];

				break;
			}
		}
    
		[[CCTextureCache sharedTextureCache] removeTexture:[fish texture]];
		[fish release];
		
		[spBg release];
	}
	
	[[CCTextureCache sharedTextureCache] removeAllTextures];
}
-(void) goScore : (id) sender
{
	[g_GameUtils playSoundEffect:@"button.wav"];
	[(CCMenuItemImage*)[[self getChildByTag:1] getChildByTag:0] setIsEnabled:NO];
	
	[self.parent runAction:[CCMoveTo actionWithDuration:0.5f position:ccp(0, 0)]];
	[self performSelector:@selector(release:) withObject:self afterDelay:0.6f];
}

-(void) release : (id) sender
{
	for (int i = 0; i < FISHTYPE_NUM; i++) {
		[(FishSprite*)[[self getChildByTag:(2 + i)] getChildByTag:0] releasefish];
		
		for (int j = 1; j < 5; j++) {
			if ([[self getChildByTag:(2 + i)] getChildByTag:j]) {
				[[[self getChildByTag:(2 + i)] getChildByTag:j] stopAllActions];
				[[[self getChildByTag:(2 + i)] getChildByTag:j] removeAllChildrenWithCleanup:YES];
				[[[self getChildByTag:(2 + i)] getChildByTag:j] removeFromParentAndCleanup:YES];
			}
		}
        
		[[self getChildByTag:(2 + i)] removeFromParentAndCleanup:YES];
	}
	
	[[self getChildByTag:0] removeAllChildrenWithCleanup:YES];
	[[self getChildByTag:0] removeFromParentAndCleanup:YES];
	
	[((CCMenuItemImage*)[[self getChildByTag:1] getChildByTag:0]).normalImage removeFromParentAndCleanup:YES];
	[((CCMenuItemImage*)[[self getChildByTag:1] getChildByTag:0]).selectedImage removeFromParentAndCleanup:YES];
	[[self getChildByTag:1] removeAllChildrenWithCleanup:YES];
	[[self getChildByTag:1] removeFromParentAndCleanup:YES];
	
	[[self getChildByTag:25] removeFromParentAndCleanup:YES];
	[[self getChildByTag:26] removeFromParentAndCleanup:YES];
	
	[self removeFromParentAndCleanup:YES];
	
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
	[[CCTextureCache sharedTextureCache] removeAllTextures];
	
	fTrophies = NO;
}
- (void) dealloc
{
	[super dealloc];
}
#pragma mark touchFunc
- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	if (m_bTouch)  return;
	m_nTouchNum = 0;
	
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	m_arrayTouch[m_nTouchNum++] = location;	m_bTouch = YES;
}

- (void)ccTouchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	
	if(m_bTouch && (m_nTouchNum < MAX_TOUCH)) m_arrayTouch[m_nTouchNum ++] = location;
}

- (void)ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	if (!m_bTouch) return;
	m_bTouch = NO;
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	if (m_nTouchNum >= 2) {
		int dy = location.y - m_arrayTouch[0].y;
		if (dy > 0 && ([self getChildByTag:2].position.y - dy) <= 387 * g_fScaleY) {
			dy = [self getChildByTag:2].position.y - 387 * g_fScaleY;
		}
		if (dy < 0 && ([self getChildByTag:FISHTYPE_NUM+1].position.y - dy) >= 93 * g_fScaleY) {
			dy = [self getChildByTag:FISHTYPE_NUM+1].position.y - 93 * g_fScaleY;
		}
		int x, y;
		for (int i = 0; i < FISHTYPE_NUM; i++) {
			x = [self getChildByTag:i + 2].position.x;
			y = [self getChildByTag:i + 2].position.y;
			[self getChildByTag:i + 2].position = ccp(x, y - dy);
		}
	}
    
    
}

@end
