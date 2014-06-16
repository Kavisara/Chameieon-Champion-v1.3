//
//  WeightScene.m
//  NinjaFishing
//
//  Created by JinJin on 7/9/13.
//
//

#import "WeightScene.h"
#import "Tools.h"
#import "ShopScene1.h"

@implementation WeightScene
+(id) scene
{
	CCScene *scene = [CCScene node];
	WeightScene *layer = [WeightScene node];
	[scene addChild: layer];
	return scene;
}

enum WEIGHT {
	WEIGHT0 = 0,
	WEIGHT30 = 30,
	WEIGHT90 = 90,
	WEIGHT190 = 190,
	WEIGHT290 = 290,
	WEIGHT390 = 390,
	WEIGHT490 = 490
};

-(id) init
{
    if( (self=[super init] ))
    {
        CCSprite *bgSprite;
        //  BG Sprite
        
        bgSprite = [CCSprite spriteWithFile:[Tools imageNameForName:@"Weight-BG"]];
        bgSprite.scaleX = g_fScaleX;bgSprite.scaleY =g_fScaleY;
        bgSprite.anchorPoint = ccp(0.0f, 0.0f);
        [self addChild:bgSprite];
        bgSprite.position = ccp(0.0f, 0.0f);
        
        CCMenuItemImage* btnBack = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"back-button"]
                                                          selectedImage:[Tools imageNameForName:@"back-button"] target:self selector:@selector(OnBack:)];
        btnBack.anchorPoint = ccp(0.0, 1.0);
        btnBack.position = ccp(5 * g_fScaleX, 475 * g_fScaleY);
        
        CCMenuItemImage*   btnCollect = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"Weight-collection"] selectedImage:[Tools imageNameForName:@"Weight-collection"] target:nil selector:nil];
        btnCollect.anchorPoint =ccp(0,0);
        btnCollect.position =ccp(10*g_fScaleX,0);
        
        CCMenu* back = [CCMenu menuWithItems:btnBack,btnCollect,nil];
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
        scroll.frame=CGRectMake(32*g_fScaleX,110*g_fScaleY,250*g_fScaleX,300*g_fScaleY);
        scroll.contentSize=CGSizeMake(250*g_fScaleX,480*g_fScaleY);
    }
    
    //--1
    UIButton *btnGetLine30 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine30.frame = CGRectMake(70*g_fScaleX, 0, 179*g_fScaleX, 73*g_fScaleY);
    [btnGetLine30 setImage:[UIImage imageNamed:@"Weight-30.png"] forState:UIControlStateNormal];
    [btnGetLine30 addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine30.tag= 20;
    [scroll addSubview:btnGetLine30];
    
    UIButton *btnGetLine30A = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine30A.frame = CGRectMake(0, 0, 60*g_fScaleX, 66*g_fScaleY);
    
    if(g_ITEMSTATE[20] == IMPOSIBLE)
        [btnGetLine30A setImage:[UIImage imageNamed:@"Weight-locked.png"] forState:UIControlStateNormal];
    else
        [btnGetLine30A setImage:[UIImage imageNamed:@"Weight-unlocked.png"] forState:UIControlStateNormal];
    
    
    if(g_ITEMSTATE[20] == SOLD)
    {
        btnGetLine30.enabled = FALSE;
        btnGetLine30A.enabled = FALSE;
    }
    

    [btnGetLine30A addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine30A.tag= 20;
    [scroll addSubview:btnGetLine30A];
    
    //--2
    
    UIButton *btnGetLine500 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine500.frame = CGRectMake(70*g_fScaleX, 80*g_fScaleY, 179*g_fScaleX, 73*g_fScaleY);
    [btnGetLine500 setImage:[UIImage imageNamed:@"Weight-500.png"] forState:UIControlStateNormal];
    [btnGetLine500 addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine500.tag =21;
    [scroll addSubview:btnGetLine500];
    
    UIButton *btnGetLine500A = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine500A.frame = CGRectMake(0, 80*g_fScaleY, 60*g_fScaleX, 66*g_fScaleY);
    
    if(g_ITEMSTATE[21] == IMPOSIBLE)
        [btnGetLine500A setImage:[UIImage imageNamed:@"Weight-locked.png"] forState:UIControlStateNormal];
    else
        [btnGetLine500A setImage:[UIImage imageNamed:@"Weight-unlocked.png"] forState:UIControlStateNormal];
    
    
    if(g_ITEMSTATE[21] == SOLD)
    {
        btnGetLine500.enabled = FALSE;
        btnGetLine500A.enabled = FALSE;
    }
    

    [btnGetLine500A addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine500A.tag =21;
    [scroll addSubview:btnGetLine500A];
    
    //--3
    
    UIButton *btnGetLine1000 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine1000.frame = CGRectMake(70*g_fScaleX, 160*g_fScaleY, 179*g_fScaleX, 73*g_fScaleY);
    [btnGetLine1000 setImage:[UIImage imageNamed:@"Weight-1000.png"] forState:UIControlStateNormal];
    [btnGetLine1000 addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine1000.tag =22;
    [scroll addSubview:btnGetLine1000];
    
    UIButton *btnGetLine1000A = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine1000A.frame = CGRectMake(0, 160*g_fScaleY, 60*g_fScaleX, 66*g_fScaleY);
    
    if(g_ITEMSTATE[22] == IMPOSIBLE)
        [btnGetLine1000A setImage:[UIImage imageNamed:@"Weight-locked.png"] forState:UIControlStateNormal];
    else
        [btnGetLine1000A setImage:[UIImage imageNamed:@"Weight-unlocked.png"] forState:UIControlStateNormal];
    
    
    if(g_ITEMSTATE[22] == SOLD)
    {
        btnGetLine1000.enabled = FALSE;
        btnGetLine1000A.enabled = FALSE;
    }
    

    [btnGetLine1000A addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine1000A.tag =22;
    [scroll addSubview:btnGetLine1000A];
    
    //--4
    
    UIButton *btnGetLine2500 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine2500.frame = CGRectMake(70*g_fScaleX, 240*g_fScaleY, 179*g_fScaleX, 73*g_fScaleY);
    [btnGetLine2500 setImage:[UIImage imageNamed:@"Weight-2500.png"] forState:UIControlStateNormal];
    [btnGetLine2500 addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine2500.tag =23;
    [scroll addSubview:btnGetLine2500];
    
    UIButton *btnGetLine2500A = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine2500A.frame = CGRectMake(0, 240*g_fScaleY, 60*g_fScaleX, 66*g_fScaleY);
    
    if(g_ITEMSTATE[23] == IMPOSIBLE)
        [btnGetLine2500A setImage:[UIImage imageNamed:@"Weight-locked.png"] forState:UIControlStateNormal];
    else
        [btnGetLine2500A setImage:[UIImage imageNamed:@"Weight-unlocked.png"] forState:UIControlStateNormal];
    
    
    if(g_ITEMSTATE[23] == SOLD)
    {
        btnGetLine2500.enabled = FALSE;
        btnGetLine2500A.enabled = FALSE;
    }
    

    [btnGetLine2500A addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine2500A.tag =23;
    [scroll addSubview:btnGetLine2500A];
    
    //--5
    
    UIButton *btnGetLine4000 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine4000.frame = CGRectMake(70*g_fScaleX, 320*g_fScaleY, 179*g_fScaleX, 73*g_fScaleY);
    [btnGetLine4000 setImage:[UIImage imageNamed:@"Weight-4000.png"] forState:UIControlStateNormal];
    [btnGetLine4000 addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine4000.tag =24;
    [scroll addSubview:btnGetLine4000];
    
    UIButton *btnGetLine4000A = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine4000A.frame = CGRectMake(0, 320*g_fScaleY, 60*g_fScaleX, 66*g_fScaleY);
    
    if(g_ITEMSTATE[24] == IMPOSIBLE)
        [btnGetLine4000A setImage:[UIImage imageNamed:@"Weight-locked.png"] forState:UIControlStateNormal];
    else
        [btnGetLine4000A setImage:[UIImage imageNamed:@"Weight-unlocked.png"] forState:UIControlStateNormal];
    
    
    if(g_ITEMSTATE[24] == SOLD)
    {
        btnGetLine4000.enabled = FALSE;
        btnGetLine4000A.enabled = FALSE;
    }
    

    [btnGetLine4000A addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine4000A.tag =24;
    [scroll addSubview:btnGetLine4000A];
    
    //--6
    
    UIButton *btnGetLine6000 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine6000.frame = CGRectMake(70*g_fScaleX, 400*g_fScaleY, 179*g_fScaleX, 73*g_fScaleY);
    [btnGetLine6000 setImage:[UIImage imageNamed:@"Weight-6000.png"] forState:UIControlStateNormal];
    [btnGetLine6000 addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine6000.tag =25;
    [scroll addSubview:btnGetLine6000];
    
    UIButton *btnGetLine6000A = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine6000A.frame = CGRectMake(0, 400*g_fScaleY, 60*g_fScaleX, 66*g_fScaleY);
    
    if(g_ITEMSTATE[25] == IMPOSIBLE)
        [btnGetLine6000A setImage:[UIImage imageNamed:@"Weight-locked.png"] forState:UIControlStateNormal];
    else
        [btnGetLine6000A setImage:[UIImage imageNamed:@"Weight-unlocked.png"] forState:UIControlStateNormal];
    
    
    if(g_ITEMSTATE[25] == SOLD)
    {
        btnGetLine6000.enabled = FALSE;
        btnGetLine6000A.enabled = FALSE;
    }
    

    [btnGetLine6000A addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine6000A.tag =25;
    [scroll addSubview:btnGetLine6000A];

    scroll.tag=3500;
    [view addSubview:scroll];
    
    wrapper = [CCUIViewWrapper wrapperForUIView:view];
    [self addChild:wrapper];
    [scroll release];
    
}

-(void) onGetLine:(id)sender
{
    UIButton* item = (UIButton*) sender;
    
    if( g_ITEMSTATE[item.tag] == POSIBLE && m_ShopItem[item.tag].nCost <= g_UserInfo.nMoney) {
        [g_GameUtils playSoundEffect:@"Button_All.mp3"];
        g_ITEMSTATE[item.tag] = SOLD;
        g_ITEMSTATE[item.tag+1] = POSIBLE;
        [self updateInfo:item.tag];
		
	}else
        [g_GameUtils playSoundEffect:@"buttonfalse.wav"];
}

-(void) updateInfo:(int)nItemTag
{
	if (nItemTag == WEIGHT30_30) g_UserInfo.nWeight = WEIGHT30;
	else if (nItemTag == WEIGHT90_500) g_UserInfo.nWeight = WEIGHT90;
	else if (nItemTag == WEIGHT190_1000) g_UserInfo.nWeight = WEIGHT190;
	else if (nItemTag == WEIGHT290_2500) g_UserInfo.nWeight = WEIGHT290;
	else if (nItemTag == WEIGHT390_4000) g_UserInfo.nWeight = WEIGHT390;
	else if (nItemTag == WEIGHT490_6000) g_UserInfo.nWeight = WEIGHT490;
    
	g_UserInfo.nMoney -= m_ShopItem[nItemTag].nCost;
	
	NSString *str = [NSString stringWithFormat:@"%d", g_UserInfo.nMoney];
	[[self getChildByTag:2] removeAllChildrenWithCleanup:YES];
	[(CCLabelBMFont*)[self getChildByTag:2] setString:str];

    [[view viewWithTag:3500] removeFromSuperview];
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
