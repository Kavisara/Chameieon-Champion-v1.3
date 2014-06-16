//
//  GoldScene.m
//  NinjaFishing
//
//  Created by lion on 7/4/13.
//
//

#import "GoldScene.h"
#import "Tools.h"
#import "ShopScene1.h"
#import "MKStoreManager.h"

@implementation GoldScene

+(id) scene
{
	CCScene *scene = [CCScene node];
	GoldScene *layer = [GoldScene node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
    if( (self=[super init] ))
    {
        CCSprite *bgSprite;
        //  BG Sprite
        bgSprite = [CCSprite spriteWithFile:[Tools imageNameForName:@"GoldBG"]];
        bgSprite.scaleX = g_fScaleX;bgSprite.scaleY =g_fScaleY;
        bgSprite.anchorPoint = ccp(0.0f, 0.0f);
        [self addChild:bgSprite];
        bgSprite.position = ccp(0.0f, 0.0f);
		
        
        //  Btns (FB, Not Now)
        CCMenuItemImage* btnGetGold1000 = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"gold-1000-button"]
                                                             selectedImage:[Tools imageNameForName:@"gold-1000-button"] target:self selector:@selector(OnGetGold1000:)];
        btnGetGold1000.anchorPoint = ccp(0.0, 1.0);
        
        CCMenuItemImage* btnGetGold5000 = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"gold-5000-button"]
                                                             selectedImage:[Tools imageNameForName:@"gold-5000-button"] target:self selector:@selector(OnGetGold5000:)];
        btnGetGold5000.anchorPoint = ccp(0.0, 1.0);
        
        CCMenuItemImage* btnGetGold10000 = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"gold-10000-button"]
                                                               selectedImage:[Tools imageNameForName:@"gold-10000-button"] target:self selector:@selector(OnGetGold10000:)];
        btnGetGold10000.anchorPoint = ccp(0.0, 1.0);
        
        CCMenuItemImage* btnGetGold25000 = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"gold-25000-button"]
                                                               selectedImage:[Tools imageNameForName:@"gold-25000-button"] target:self selector:@selector(OnGetGold25000:)];
        btnGetGold25000.anchorPoint = ccp(0.0, 1.0);
        
        CCMenuItemImage* btnGetGold100000 = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"gold-100000-button"]
                                                             selectedImage:[Tools imageNameForName:@"gold-100000-button"] target:self selector:@selector(OnGetGold100000:)];
        btnGetGold100000.anchorPoint = ccp(0.0, 1.0);
        
        CCMenuItemImage* btnBack = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"back-button"]
                                                          selectedImage:[Tools imageNameForName:@"back-button"] target:self selector:@selector(OnBack:)];
        btnBack.anchorPoint = ccp(0.0, 1.0);
        
//        {
            btnGetGold1000.position = ccp(98 * g_fScaleX, 396 * g_fScaleY);
            btnGetGold5000.position = ccp(98 * g_fScaleX, 322 * g_fScaleY);
            btnGetGold10000.position = ccp(98 * g_fScaleX, 255 * g_fScaleY);
            btnGetGold25000.position = ccp(98 * g_fScaleX, 173 * g_fScaleY);
            btnGetGold100000.position = ccp(98 * g_fScaleX, 105 * g_fScaleY);
            btnBack.position = ccp(3 * g_fScaleX, 475 * g_fScaleY);
        //}
        
        CCMenu* menu = [CCMenu menuWithItems:btnGetGold1000, btnGetGold5000, btnGetGold10000, btnGetGold25000, btnGetGold100000, btnBack, nil];
		menu.position = ccp(0, 0);
        [self addChild:menu];
        
        
        
    }
    
    return self;
}

-(void) OnGetGold1000 : (id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
    [[MKStoreManager sharedManager] buyFeatureA];
    //
    //g_UserInfo.nMoney +=1000;
}

-(void) OnGetGold5000 : (id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
    
    [[MKStoreManager sharedManager] buyFeatureB];

}

-(void) OnGetGold10000 : (id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
    [[MKStoreManager sharedManager] buyFeatureC];

}

-(void) OnGetGold25000 : (id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
    [[MKStoreManager sharedManager] buyFeatureD];

}

-(void) OnGetGold100000 : (id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
    [[MKStoreManager sharedManager] buyFeatureE];
}

-(void) OnBack : (id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
	NSString *r = @"CCTransitionMoveInL";
	Class transion = NSClassFromString(r);
	[[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:0.5f scene:[ShopScene1 scene]]];
}

@end
