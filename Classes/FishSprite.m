//
//  FishSprite.m
//  NinjaFish
//
//  Created by Techintegrity Services on 9/26/11.
//  Copyright 2011 Techintegrity Services. All rights reserved.
//

#import "FishSprite.h"
#import "GameConfig.h"
#import "GameScene.h"
#import "Tools.h"

int m_nGameState;
int m_nCatchFishNum;

@implementation FishSprite

@synthesize state;
@synthesize type;
@synthesize slashnum;
@synthesize treasure_mode;

+(id)spriteWithFile:(NSString*)filename
{
	return [[[self alloc] initWithFile:filename] autorelease];
}
-(id)initWithType:(int)ntype flip:(BOOL)bflip
{
	if ((self = [super init])) {
		type = ntype;
		state = FISH_GENERATE;
		slashnum = 0;
		NSString *fish_path;
		
		if (ntype == Bomb) {
			fish_path = [NSString stringWithFormat:@"bomb%d", ntype];
		}
		else if (ntype == Treasure) {
            treasure_mode = rand()%5+1;
			fish_path = [NSString stringWithFormat:@"treasure%d",treasure_mode];
		}
		else if (ntype == Mine) {
			fish_path = [NSString stringWithFormat:@"mine%d", ntype];
		}
		else {
			fish_path = [NSString stringWithFormat:@"candy%02d", ntype];	// modified by Song.
		}

        fish_path = [Tools imageNameForName:fish_path];
        
		UIImage *imgFish =[[UIImage imageNamed:fish_path] retain];
		//UIImage *imgFish = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fish_path ofType:nil]];
		CCTexture2D	*tex = [[CCTexture2D alloc] initWithImage:imgFish]; 
		[self setTexture:tex];
		[self setTextureRect:CGRectMake(0, 0, tex.contentSize.width, tex.contentSize.height)];
        
        if(type == Treasure)
        {
            if(tex.contentSize.width == 100)
            {
                NSLog(@"%@",fish_path);
            }
        }
		[imgFish release];
		
        
		if (bflip) self.flipX = YES;
		else self.flipX = NO;
	}
	return self;
}

-(void) generateBubble : (id) sender
{
	time_t tv; time(&tv); srand(tv);
	[self unschedule:@selector(generateBubble:)];
	[g_GameUtils playSoundEffect:@"bubble.wav"];
	
	float dt =1.f + 2.f * CCRANDOM_0_1();
	
	CCSprite *spriteBubble = [[CCSprite alloc] initWithFile:@"bubble1.png"];
	
	if (self.flipX) spriteBubble.position = ccp(self.position.x + self.contentSize.width / 2, self.position.y);
	else spriteBubble.position = ccp(self.position.x - self.contentSize.width / 2, self.position.y);

	spriteBubble.scaleX = g_fScaleX / 2; spriteBubble.scaleY = g_fScaleY / 2;
	[self.parent addChild:spriteBubble];
	
	id action_rise = [CCMoveBy actionWithDuration:dt position:ccp(0, (g_size.height / 6))];
	id action_remove = [CCScaleTo actionWithDuration:dt scale:0.1f];
	[spriteBubble runAction:[CCSpawn actions:action_rise, action_remove, nil]]; 
	
	[self performSelector:@selector(removeBubble:) withObject:spriteBubble afterDelay:dt];
	[spriteBubble release];
}

-(void)	onMoving
{
	if (m_nGameState > GAME_TILTUP) {
		[self unschedule:@selector(onMoving)];
		return;
	}
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	if (m_nGameState == GAME_DOWNSTOP) 
	{
		if (self.flipX)
			self.position = ccp(self.position.x + nStepDepth * g_fScaleX / 2, self.position.y);	
		else 
			self.position = ccp(self.position.x - nStepDepth * g_fScaleX / 2, self.position.y);			
	}
	else if (m_nGameState < GAME_DOWNSTOP) 
	{
		if (self.position.y >= 610 * g_fScaleY) 
		{
			[self performSelector:@selector(destroyFish)];
			return;
		}
		
		if (self.position.y > 200 * g_fScaleY) {
			state = FISH_PASSDOWN;
		}
		
		if (self.flipX)
			self.position = ccp(self.position.x + nStepDepth * g_fScaleX / 2, self.position.y + nStepDepth * g_fScaleY * 2);	
		else 
			self.position = ccp(self.position.x - nStepDepth * g_fScaleX / 2, self.position.y + nStepDepth * g_fScaleY * 2);			
	}
	else if (m_nGameState > GAME_DOWNSTOP) 
	{
		if (self.position.y <= -130 * g_fScaleY) 
		{
			[self performSelector:@selector(destroyFish)];
			return;
		}
		
		if (self.position.y < 200 * g_fScaleY) 
		{
			state = FISH_PASSUP;
		}
		
		if (self.flipX)
			self.position = ccp(self.position.x + nStepDepth * g_fScaleX / 2, self.position.y - nStepDepth * MOVE_SCALE * g_fScaleY * 2);	
		else 
			self.position = ccp(self.position.x - nStepDepth * g_fScaleX / 2, self.position.y - nStepDepth * MOVE_SCALE * g_fScaleY * 2);			
	}	
	
	if(m_nGameState != GAME_DOWNSTOP)
	{
		if (self.position.x > s.width) 
			self.flipX = !self.flipX;//[self performSelector:@selector(destroyFish)];//
		else if (self.position.x < 0)
			self.flipX = !self.flipX;//[self performSelector:@selector(destroyFish)];//		
	}
	else if(m_nGameState == GAME_DOWNSTOP){
		if (self.position.x > s.width * 1.5f) 
			self.flipX = !self.flipX;//[self performSelector:@selector(destroyFish)];//
		else if (self.position.x < -s.width * 0.5f)
			self.flipX = !self.flipX;//[self performSelector:@selector(destroyFish)];//		
	}
}

-(void)	onStrike
{	
	if (m_nGameState > GAME_TILTUP) {
		[self unschedule:@selector(onStrike)];
		return;
	}
	srand(clock());
	int r = CCRANDOM_0_1() * 10;
	if (m_nGameState == GAME_TILTUP) {
		if (r > 3) 
			self.flipX = !self.flipX;
	}
	else {
		if (r > 6) 
			self.flipX = !self.flipX;
	}
}

-(void)	startMove
{	
	[self schedule:@selector(onMoving) interval:1/30.f];
	srand(clock());
	if (m_nGameState == GAME_TILTUP) {
		[self schedule:@selector(onStrike) interval:(0.3f + CCRANDOM_0_1())];
	}
	else {
		[self schedule:@selector(onStrike) interval:(1.f + CCRANDOM_0_1())];
	}
}

-(void)	stopMove
{	
	[self unschedule:@selector(onMoving)];
	[self unschedule:@selector(onStrike)];
	[self stopAllActions];
}

-(void)	stopRun
{	
	[self unschedule:@selector(onRunUp)];
	[self stopAllActions];
}

-(void) startRun
{
	float dt = 60 * (1.f + CCRANDOM_0_1());
	float dx = (rand() % 10) * 10 * g_fScaleX;
	float dy = (360.f + (rand() % 8) * 10) * g_fScaleY + self.contentSize.height / 2; 

	if (self.position.x >= g_size.width / 2) 
		nStepX = MIN(-1, (int)(-dx / dt));	
	else 
		nStepX = MAX(1, (int)(dx / dt));			
	
	nStepY = (int)(dy / dt);
	nAngle = (int)(480 / dt);
	nMaxHeight = (int)((360.f + (rand() % 8) * 10) * g_fScaleY);
	fUp = NO;
	
	if (m_nCatchFishNum > 0) m_nCatchFishNum--;

	[self schedule:@selector(onRunUp)];
}

-(void) onRunUp
{
	float x = self.position.x;
	float y = self.position.y;
	
	self.rotation += nAngle;
	if (fUp) 
	{
		self.position = ccp(x + nStepX, y - nStepY);
		
		if (self.position.y <= -self.contentSize.height / 2) {
			[self unschedule:@selector(onRunUp)];
			[self performSelector:@selector(destroyCatchFish)];
		}
	}
	else 
	{
		self.position = ccp(x + nStepX, y + nStepY);
		if (self.position.y >= nMaxHeight) fUp = YES;
	}	

	if (g_bSetup) [self getChildByTag:0].rotation = -self.rotation;	
}

-(void) destroyCatchFish
{ 
	[catched_fishes removeObject:self];
	[self stopRun];
	[self releasefish];
	[self release];
}

-(void) destroyFish
{ 
	[fishes removeObject:self];
	[self stopMove];
	[self releasefish];
	[self release];
}

-(void)removeBubble : (id)sender
{
	CCSprite *bubble = (CCSprite*)sender;
	[bubble stopAllActions];
	[bubble removeFromParentAndCleanup:YES];
}
-(void) removefromArray
{ 
	if (m_nCatchFishNum == 0) return;
	m_nCatchFishNum--;
}
-(int) getMaxSlashNum
{
	int nNum ;
	if (type == Bomb)  nNum = 1;
	else if(type == Treasure) nNum = 1;
	else nNum = type + 1;

	return nNum;
}
-(int) getScore
{
	int nScore;

	switch (type) {
		case YellowMinnow:
			nScore = 4;
			break;
		case RedMinnow:
			nScore = 5;
			break;
		case RainbowFish:
			nScore = 7;
			break;
		case Seabass:
			nScore = 10;
			break;
		case ParrotFish:
			nScore = 18;
			break;
		case Eel:
			nScore = 13;
			break;
		case Crab:
			nScore = 15;
			break;
		case Turtle:
			nScore = 40;
			break;
		case Pufferfish:
			nScore = 30;
			break;
		case Squid:
			nScore = 45;
			break;
		case Jellyfish:
			nScore = 25;
			break;
		case Tuna:
			nScore = 50;
			break;
		case Barracuda:
			nScore = 42;
			break;
		case Lobster:
			nScore = 48;
			break;
		case Octopus:
			nScore = 54;
			break;
		case Swordfish:
			nScore = 63;
			break;
		case Shark:
			nScore = 69;
			break;
		case Plankton:
			nScore = 52;
			break;
		case Mantaray:
			nScore = 75;
			break;
		case Vampirefish:
			nScore = 82;
			break;
		case Ceolacanth:
			nScore = 94;
			break;
		case Giantsquid:
			nScore = 96;
			break;
		case Treasure:
			nScore = 300;
			break;
		default:
			break;
	}
	
	if (g_UserInfo.nSale == 0) {
		return nScore;
	}
	else {
		return (int)(nScore * (100 + g_UserInfo.nSale) / 100) + 1;
	}
}

-(NSString*) getString
{
	NSString *str;
	
	switch (type) {
		case YellowMinnow:
			str = @"Yellow Minnow : ";
			break;
		case RedMinnow:
			str = @"Red Minnow : ";
			break;
		case RainbowFish:
			str = @"Rainbow Fish : ";
			break;
		case Seabass:
			str = @"Seabass : ";
			break;
		case ParrotFish:
			str = @"Parrot Fish : ";
			break;
		case Eel:
			str = @"Eel : ";
			break;
		case Crab:
			str = @"Crab : ";
			break;
		case Turtle:
			str = @"Turtle : ";
			break;
		case Pufferfish:
			str = @"Pufferfish : ";
			break;
		case Squid:
			str = @"Squid : ";
			break;
		case Jellyfish:
			str = @"Jellyfish : ";
			break;
		case Tuna:
			str = @"Tuna : ";
			break;
		case Barracuda:
			str = @"Barracuda : ";
			break;
		case Lobster:
			str = @"Lobster : ";
			break;
		case Octopus:
			str = @"Octopus : ";
			break;
		case Swordfish:
			str = @"Swordfish : ";
			break;
		case Shark:
			str = @"Shark : ";
			break;
		case Plankton:
			str = @"Plankton : ";
			break;
		case Mantaray:
			str = @"Mantaray : ";
			break;
		case Vampirefish:
			str = @"Vampirefish : ";
			break;
		case Ceolacanth:
			str = @"Ceolacanth : ";
			break;
		case Giantsquid:
			str = @"Giantsquid : ";
			break;
		default:
			break;
	}
	return str;
}

-(void) releasefish
{
	[[self texture] release];
	
	if (g_bSetup) {
		[[self getChildByTag:0] removeAllChildrenWithCleanup:YES];
		[[self getChildByTag:0] removeFromParentAndCleanup:YES];
	}
	
	[self removeAllChildrenWithCleanup:YES];
	[self removeFromParentAndCleanup:YES];
}

-(void) dealloc
{
	[super dealloc];
}

@end
