//
//  HelloWorldLayer.m
//  NinjaFishing
//
//  Created by Techintegrity Services on 11/7/11.
//  Copyright Techintegrity Services 2011. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "GameConfig.h"
#import "MainMenuScene.h"
#import "Tools.h"

// HelloWorld implementation

@implementation HelloWorld

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] ))
    {
	
    NSString *pszImageName;
	CCTexture2D *tex;
		
    for (int i = 0; i < 2; i++)
    {
        //modified by Song
//        if([Tools is4inchPhone])
//            pszImageName = [NSString stringWithFormat:@"loading%d-568h@2x.jpg", i+1];
//        else
            pszImageName = [Tools jpegImageNameForName:[NSString stringWithFormat:@"loading%d", i+1]];
        
        tex =  [[CCTextureCache sharedTextureCache] textureForKey:pszImageName];
        
        if (!tex)
            texture[i] = [[CCTextureCache sharedTextureCache] addImage:pszImageName];
        else
            texture[i] = tex;
    }
        
    CCSprite *bg;
        
//    if([Tools is4inchPhone])
//        bg = [[CCSprite alloc] initWithFile:@"loading1-568h@2x.jpg"];
//    else
    bg = [[CCSprite alloc] initWithFile:[Tools jpegImageNameForName:@"loading1"]];
    bg.scaleX = g_fScaleX;bg.scaleY = g_fScaleY;
        
    bg.position = ccp(g_size.width / 2, g_size.height / 2);
    [self addChild:bg z:-1 tag:0]; [bg release];
		
    [self schedule:@selector(loadTexture:) interval:0.35f];
	
    }
	
	return self;
}
-(void) loadTexture:(ccTime)dt
{
	m_nTick ++;
	if (m_nTick < 20) {
		[(CCSprite*)[self getChildByTag:0] setTexture:texture[m_nTick % 2]];
	}
	else {
		[self unschedule:@selector(loadTexture:)];
		[self performSelector:@selector(removeBG) withObject:self afterDelay:0.45f];
		
		NSString *r = @"CCTransitionFade";
		Class transion = NSClassFromString(r);
		[[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:0.5f scene:[MainMenuScene scene]]];	
	}
}

-(void) removeBG
{
	[self removeChildByTag:0 cleanup:YES];
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
}
@end
