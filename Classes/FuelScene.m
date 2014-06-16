//
//  FuelScene.m
//  NinjaFishing
//
//  Created by JinJin on 7/9/13.
//
//

#import "FuelScene.h"
#import "Tools.h"
#import "ShopScene1.h"

@implementation FuelScene
+(id) scene
{
	CCScene *scene = [CCScene node];
	FuelScene *layer = [FuelScene node];
	[scene addChild: layer];
	return scene;
}

enum FUEL {
	FUEL50 = 50,
	FUEL100 = 100,
	FUEL125 = 125,
	FUEL150 = 150,
	FUEL200 = 200
};

-(id) init
{
    if( (self=[super init] ))
    {
        CCSprite *bgSprite;
        //  BG Sprite
        
        bgSprite = [CCSprite spriteWithFile:[Tools imageNameForName:@"fuelBG"]];
        bgSprite.scaleX = g_fScaleX;bgSprite.scaleY =g_fScaleY;
        bgSprite.anchorPoint = ccp(0.0f, 0.0f);
        [self addChild:bgSprite];
        bgSprite.position = ccp(0.0f, 0.0f);
        
        CCMenuItemImage* btnBack = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"back-button"]
                                                          selectedImage:[Tools imageNameForName:@"back-button"] target:self selector:@selector(OnBack:)];
        btnBack.anchorPoint = ccp(0.0, 1.0);
        btnBack.position = ccp(5 * g_fScaleX, 475 * g_fScaleY);
        
        CCMenu* back = [CCMenu menuWithItems:btnBack,nil];
        back.tag = 1000;
		back.position = ccp(0, 0);
        [self addChild:back];
        
        CCLabelTTF *lbl = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%d",g_UserInfo.nMoney]
                                                    fontName:@"BADABB_.TTF"
                                                    fontSize:18];
        lbl.anchorPoint = ccp(1,0);
        lbl.position = ccp(60*g_fScaleX,0);
        lbl.tag=2;
        [lbl setColor:ccGREEN]; [self addChild:lbl];[lbl release];
        
        [self performSelector:@selector(loadScroll:) withObject:self afterDelay:0.6];
    }
    
    return self;
}

-(void) loadScroll:(id) sender
{
    view = [[CCDirector sharedDirector] openGLView];
    scroll=[[UIScrollView alloc] init];
    scroll.showsHorizontalScrollIndicator=NO;
    scroll.showsVerticalScrollIndicator=NO;
    scroll.bounces = FALSE;
    
    if(UI_USER_INTERFACE_IDIOM() !=UIUserInterfaceIdiomPad)
    {
        scroll.frame=CGRectMake(30*g_fScaleX,125*g_fScaleY,250*g_fScaleX,240*g_fScaleY);
        scroll.contentSize=CGSizeMake(250*g_fScaleX,235*g_fScaleY);
    }
    
    //--1
    UIButton *btnGetLine300 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine300.frame = CGRectMake(70*g_fScaleX, 0, 179*g_fScaleX, 73*g_fScaleY);
    [btnGetLine300 setImage:[UIImage imageNamed:@"fuel-300.png"] forState:UIControlStateNormal];
    [btnGetLine300 addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine300.tag= 11;
    [scroll addSubview:btnGetLine300];
    
    UIButton *btnGetLine300A = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine300A.frame = CGRectMake(0, 0, 60*g_fScaleX, 66*g_fScaleY);
    
    if(g_ITEMSTATE[11] == IMPOSIBLE)
        [btnGetLine300A setImage:[UIImage imageNamed:[Tools imageNameForName:@"fuel-locked"]] forState:UIControlStateNormal];
    else
        [btnGetLine300A setImage:[UIImage imageNamed:[Tools imageNameForName:@"fuel-unlocked"]] forState:UIControlStateNormal];
    
    
    if(g_ITEMSTATE[11] == SOLD)
    {
        btnGetLine300.enabled = FALSE;
        btnGetLine300A.enabled = FALSE;
    }
    

    [btnGetLine300A addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine300A.tag= 11;
    [scroll addSubview:btnGetLine300A];
    
    //--2
    
    UIButton *btnGetLine1000 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine1000.frame = CGRectMake(70*g_fScaleX, 80*g_fScaleY, 179*g_fScaleX, 73*g_fScaleY);
    [btnGetLine1000 setImage:[UIImage imageNamed:@"fuel-1000.png"] forState:UIControlStateNormal];
    [btnGetLine1000 addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine1000.tag =12;
    [scroll addSubview:btnGetLine1000];
    
    UIButton *btnGetLine1000A = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine1000A.frame = CGRectMake(0, 80*g_fScaleY, 60*g_fScaleX, 66*g_fScaleY);
    
    if(g_ITEMSTATE[12] == IMPOSIBLE)
        [btnGetLine1000A setImage:[UIImage imageNamed:[Tools imageNameForName:@"fuel-locked"]] forState:UIControlStateNormal];
    else
        [btnGetLine1000A setImage:[UIImage imageNamed:[Tools imageNameForName:@"fuel-unlocked"]] forState:UIControlStateNormal];
    
    
    if(g_ITEMSTATE[12] == SOLD)
    {
        btnGetLine1000.enabled = FALSE;
        btnGetLine1000A.enabled = FALSE;
    }
    
    [btnGetLine1000A addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine1000A.tag =12;
    [scroll addSubview:btnGetLine1000A];
    
    //--3
    
    UIButton *btnGetLine2500 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine2500.frame = CGRectMake(70*g_fScaleX, 160*g_fScaleY, 179*g_fScaleX, 73*g_fScaleY);
    [btnGetLine2500 setImage:[UIImage imageNamed:@"fuel-2500.png"] forState:UIControlStateNormal];
    [btnGetLine2500 addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine2500.tag =13;
    [scroll addSubview:btnGetLine2500];
    
    UIButton *btnGetLine2500A = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine2500A.frame = CGRectMake(0, 160*g_fScaleY, 60*g_fScaleX, 66*g_fScaleY);
    
    if(g_ITEMSTATE[13] == IMPOSIBLE)
        [btnGetLine2500A setImage:[UIImage imageNamed:[Tools imageNameForName:@"fuel-locked"]] forState:UIControlStateNormal];
    else
        [btnGetLine2500A setImage:[UIImage imageNamed:[Tools imageNameForName:@"fuel-unlocked"]] forState:UIControlStateNormal];
    
    
    if(g_ITEMSTATE[13] == SOLD)
    {
        btnGetLine2500.enabled = FALSE;
        btnGetLine2500A.enabled = FALSE;
    }
    

    [btnGetLine2500A addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine2500A.tag =13;
    [scroll addSubview:btnGetLine2500A];

    scroll.tag = 5500;
    [view addSubview:scroll];
    
    wrapper = [CCUIViewWrapper wrapperForUIView:view];
    [self addChild:wrapper];
    
}

-(void) onGetLine:(id)sender
{
    UIButton* item = (UIButton*) sender;
    
    if(item.tag == 0)
        return;
    
    if(m_ShopItem[item.tag].nCost > g_UserInfo.nMoney) {
		[g_GameUtils playSoundEffect:@"buttonfalse.wav"];
		return;
	}
    
    if (g_ITEMSTATE[item.tag] == POSIBLE) {
		//
        g_ITEMSTATE[item.tag] = SOLD;
        g_ITEMSTATE[item.tag+1] = POSIBLE;
        [self updateInfo:item.tag];
        [g_GameUtils playSoundEffect:@"Button_All.mp3"];
        //
    }
	else {
		[g_GameUtils playSoundEffect:@"buttonfalse.wav"];
	}
    
}

-(void) updateInfo:(int)nItemTag
{

    if (nItemTag == FUEL100_50) g_UserInfo.nFuel = FUEL100;
	else if (nItemTag == FUEL125_300) g_UserInfo.nFuel = FUEL125;
	else if (nItemTag == FUEL150_1000) g_UserInfo.nFuel = FUEL150;
	else if (nItemTag == FUEL200_2500) g_UserInfo.nFuel = FUEL200;
    
	g_UserInfo.nMoney -= m_ShopItem[nItemTag].nCost;
	
	NSString *str = [NSString stringWithFormat:@"%d", g_UserInfo.nMoney];
	[[self getChildByTag:2] removeAllChildrenWithCleanup:YES];
	[(CCLabelBMFont*)[self getChildByTag:2] setString:str];
	

    [scroll removeFromSuperview];
    [self loadScroll:Nil];
}

-(void) OnBack : (id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
    scroll.hidden=YES;
    NSString *r = @"CCTransitionFade";
	Class transion = NSClassFromString(r);
    [[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:1.0f scene:[ShopScene1 scene]]];
}

@end
