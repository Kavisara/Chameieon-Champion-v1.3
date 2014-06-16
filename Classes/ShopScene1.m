//
//  ShopScene1.m
//  NinjaFishing
//
//  Created by lion on 7/4/13.
//
//

#import "ShopScene1.h"
#import "Tools.h"
#import "ScoreScene.h"
#import "GoldScene.h"
#import "LineScene.h"
#import "SwordScene.h"
#import "WeightScene.h"
#import "HookScene.h"
#import "FuelScene.h"
#import "MKStoreManager.h"

@implementation ShopScene1

+(id) scene
{
	CCScene *scene = [CCScene node];
	ShopScene1 *layer = [ShopScene1 node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
    if( (self=[super init] ))
    {
        
        CCSprite *bgSprite;
        //  BG Sprite
        bgSprite = [CCSprite spriteWithFile:[Tools imageNameForName:@"shopBG"]];
        bgSprite.position = ccp(0.0f, 0.0f);
        bgSprite.scaleX = g_fScaleX;bgSprite.scaleY =g_fScaleY;
        bgSprite.anchorPoint = ccp(0.0f, 0.0f);
        [self addChild:bgSprite];
        
        //  Btns (FB, Not Now)
        CCMenuItemImage* btnGetGold = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"gold-button"]
                                                             selectedImage:[Tools imageNameForName:@"gold-button"] target:self selector:@selector(OnGetGold:)];
        btnGetGold.anchorPoint = ccp(0.0, 1.0);
        
        CCMenuItemImage* btnGetLine = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"line-button"]
                                               selectedImage:[Tools imageNameForName:@"line-button"] target:self selector:@selector(OnGetLine:)];
        btnGetLine.anchorPoint = ccp(0.0, 1.0);
        
        CCMenuItemImage* btnGetSwords = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"swords-button"]
                                                   selectedImage:[Tools imageNameForName:@"swords-button"] target:self selector:@selector(OnGetSwords:)];
        btnGetSwords.anchorPoint = ccp(0.0, 1.0);
        
        CCMenuItemImage* btnGetWeight = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"weight-button"]
                                              selectedImage:[Tools imageNameForName:@"weight-button"] target:self selector:@selector(OnGetWeight:)];
        btnGetWeight.anchorPoint = ccp(0.0, 1.0);
        
        CCMenuItemImage* btnGetHook = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"hook-button"]
                                                               selectedImage:[Tools imageNameForName:@"hook-button"] target:self selector:@selector(OnGetHook:)];
        btnGetHook.anchorPoint = ccp(0.0, 1.0);

        CCMenuItemImage* btnGetFuel = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"fuel-button"]
                                                             selectedImage:[Tools imageNameForName:@"fuel-button"] target:self selector:@selector(OnGetFuel:)];
        btnGetFuel.anchorPoint = ccp(0.0, 1.0);
        
        CCMenuItemImage* btnUnLockAll = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"unlock-button"]
                                                             selectedImage:[Tools imageNameForName:@"unlock-button"] target:self selector:@selector(OnUnLockAll:)];
        btnUnLockAll.anchorPoint = ccp(0.0, 1.0);
        
        CCMenuItemImage* btnRestore = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"restore_purchases"]
                                                             selectedImage:[Tools imageNameForName:@"restore_purchases"] target:self selector:@selector(OnRestore:)];
        btnRestore.anchorPoint = ccp(0.0, 1.0);
        
        CCMenuItemImage* btnBack = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"back-button"]
                                                               selectedImage:[Tools imageNameForName:@"back-button"] target:self selector:@selector(OnBack:)];
        btnBack.anchorPoint = ccp(0.0, 1.0);

            btnGetGold.position = ccp(32 * g_fScaleX, 352 * g_fScaleY);
            btnGetLine.position = ccp(165 * g_fScaleX, 352 * g_fScaleY);
            btnGetSwords.position = ccp(32 * g_fScaleX, 290 * g_fScaleY);
            btnGetWeight.position = ccp(165 * g_fScaleX, 290 * g_fScaleY);
            btnGetHook.position = ccp(32 * g_fScaleX, 226 * g_fScaleY);
            btnGetFuel.position = ccp(165 * g_fScaleX, 226 * g_fScaleY);
            btnUnLockAll.position = ccp(20 * g_fScaleX, 155 * g_fScaleY);
            btnBack.position = ccp(15 * g_fScaleX, 475 * g_fScaleY);
            btnRestore.position = ccp(170 * g_fScaleX, 50 * g_fScaleY);        
        //}
        
        //g_UserInfo.nMoney
        
        //

        CCLabelTTF *lbl = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%d",g_UserInfo.nMoney]
                                                    fontName:@"BADABB_.TTF"
                                                    fontSize:18];
        lbl.anchorPoint = ccp(1,0);
        lbl.position = ccp(55*g_fScaleX,0);
        [lbl setColor:ccGREEN]; [self addChild:lbl];[lbl release];
        

        CCMenuItemImage*   btnCollect = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"Weight-collection"] selectedImage:[Tools imageNameForName:@"Weight-collection"] target:nil selector:nil];
        btnCollect.anchorPoint =ccp(0,0);
        btnCollect.position =ccp(10*g_fScaleX,0);
        
        //
        CCMenu* menu = [CCMenu menuWithItems:btnGetGold, btnGetLine, btnGetSwords, btnGetWeight, btnGetHook, btnGetFuel, btnUnLockAll,btnCollect,btnBack, btnRestore, nil];
		menu.position = ccp(0, 0);
        [self addChild:menu];
        
    }
    
    return self;
}

-(void) OnGetGold : (id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
    NSString *r = @"CCTransitionMoveInR";
	Class transion = NSClassFromString(r);
	[[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:0.5f scene:[GoldScene scene]]];
    
}

-(void) OnGetLine : (id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
    NSString *r = @"CCTransitionMoveInR";
	Class transion = NSClassFromString(r);
	[[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:0.5f scene:[LineScene scene]]];
}

-(void) OnGetSwords : (id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
    NSString *r = @"CCTransitionMoveInR";
	Class transion = NSClassFromString(r);
	[[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:0.5f scene:[SwordScene scene]]];
}

-(void) OnGetWeight : (id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
    NSString *r = @"CCTransitionMoveInR";
	Class transion = NSClassFromString(r);
	[[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:0.5f scene:[WeightScene scene]]];
}

-(void) OnGetHook : (id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
    NSString *r = @"CCTransitionMoveInR";
	Class transion = NSClassFromString(r);
	[[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:0.5f scene:[HookScene scene]]];
}

-(void) OnGetFuel : (id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
    NSString *r = @"CCTransitionMoveInR";
	Class transion = NSClassFromString(r);
	[[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:0.5f scene:[FuelScene scene]]];
}

-(void) OnUnLockAll : (id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
    [[MKStoreManager sharedManager] buyUnloadAll];
}

-(void) OnRestore : (id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
    [[MKStoreManager sharedManager] restoreFunc];
}

-(void) OnBack : (id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
	NSString *r = @"CCTransitionMoveInL";
	Class transion = NSClassFromString(r);
	[[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:0.5f scene:[ScoreScene scene]]];
    
}

@end
