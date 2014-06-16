//
//  HookScene.m
//  NinjaFishing
//
//  Created by JinJin on 7/9/13.
//
//

#import "HookScene.h"
#import "Tools.h"
#import "ShopScene1.h"

@implementation HookScene
+(id) scene
{
	CCScene *scene = [CCScene node];
	HookScene *layer = [HookScene node];
	[scene addChild: layer];
	return scene;
}

enum HOOK{
	HOOK25 = 25,
	HOOK35 = 35,
	HOOK50 = 50
};

-(id) init
{
    if( (self=[super init] ))
    {
        CCSprite *bgSprite;
        //  BG Sprite
        
        bgSprite = [CCSprite spriteWithFile:[Tools imageNameForName:@"hookBG"]];
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
        scroll.frame=CGRectMake(30*g_fScaleX,125*g_fScaleY,250*g_fScaleX,165*g_fScaleY);
        scroll.contentSize=CGSizeMake(250*g_fScaleX,155*g_fScaleY);
    }
    
    //--1
    UIButton *btnGetLine500 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine500.frame = CGRectMake(70*g_fScaleX, 0, 179*g_fScaleX, 73*g_fScaleY);
    [btnGetLine500 setImage:[UIImage imageNamed:@"hook-500.png"] forState:UIControlStateNormal];
    [btnGetLine500 addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine500.tag= 18;
    [scroll addSubview:btnGetLine500];
    
    UIButton *btnGetLine500A = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine500A.frame = CGRectMake(0, 0, 60*g_fScaleX, 66*g_fScaleY);
    
    if(g_ITEMSTATE[18] == IMPOSIBLE)
        [btnGetLine500A setImage:[UIImage imageNamed:[Tools imageNameForName:@"hook-locked"]] forState:UIControlStateNormal];
    else
        [btnGetLine500A setImage:[UIImage imageNamed:[Tools imageNameForName:@"hook-unlocked"]] forState:UIControlStateNormal];
    
    
    if(g_ITEMSTATE[18] == SOLD)
    {
        btnGetLine500.enabled = FALSE;
        btnGetLine500A.enabled = FALSE;
    }
    

    [btnGetLine500A addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine500A.tag= 18;
    [scroll addSubview:btnGetLine500A];
    
    //--2
    
    UIButton *btnGetLine2000 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine2000.frame = CGRectMake(70*g_fScaleX, 80*g_fScaleY, 179*g_fScaleX, 73*g_fScaleY);
    [btnGetLine2000 setImage:[UIImage imageNamed:@"hook-2000.png"] forState:UIControlStateNormal];
    [btnGetLine2000 addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine2000.tag =19;
    [scroll addSubview:btnGetLine2000];
    
    UIButton *btnGetLine2000A = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine2000A.frame = CGRectMake(0, 80*g_fScaleY, 60*g_fScaleX, 66*g_fScaleY);
    
    if(g_ITEMSTATE[19] == IMPOSIBLE)
        [btnGetLine2000A setImage:[UIImage imageNamed:[Tools imageNameForName:@"hook-locked"]] forState:UIControlStateNormal];
    else
        [btnGetLine2000A setImage:[UIImage imageNamed:[Tools imageNameForName:@"hook-unlocked"]] forState:UIControlStateNormal];
    
    
    if(g_ITEMSTATE[19] == SOLD)
    {
        btnGetLine2000.enabled = FALSE;
        btnGetLine2000A.enabled = FALSE;
    }
    

    [btnGetLine2000A addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine2000A.tag =19;
    [scroll addSubview:btnGetLine2000A];
    
    scroll.tag =4500;
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
	if (nItemTag == HOOK35_500) g_UserInfo.nHook = HOOK35;
	else if (nItemTag == HOOK50_1500) g_UserInfo.nHook = HOOK50;
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
