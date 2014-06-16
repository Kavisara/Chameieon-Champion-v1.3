//
//  LineScene.m
//  NinjaFishing
//
//  Created by lion on 7/4/13.
//
//

#import "LineScene.h"
#import "Tools.h"
#import "ShopScene1.h"

@implementation LineScene
+(id) scene
{
	CCScene *scene = [CCScene node];
	LineScene *layer = [LineScene node];
	[scene addChild: layer];
	return scene;
}

enum LINE {
	LINE75 = 75,
	LINE125 = 125,
	LINE200 = 200,
	LINE300 = 300,
	LINE400 = 400,
	LINE500 = 500,
	LINE600 = 600,
	LINE800 = 800
};

-(id) init
{
    if( (self=[super init] ))
    {
        CCSprite *bgSprite;
        //  BG Sprite

        bgSprite = [CCSprite spriteWithFile:[Tools imageNameForName:@"lineBG"]];
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
    UIButton *btnGetLine150 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine150.frame = CGRectMake(70*g_fScaleX, 0, 179*g_fScaleX, 73*g_fScaleY);
    [btnGetLine150 setImage:[UIImage imageNamed:[Tools imageNameForName:@"line-150"]] forState:UIControlStateNormal];
    [btnGetLine150 addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine150.tag= 0;
    [scroll addSubview:btnGetLine150];
    
    UIButton *btnGetLine150A = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine150A.frame = CGRectMake(0, 0, 60*g_fScaleX, 66*g_fScaleY);
    
    if(g_ITEMSTATE[0] == IMPOSIBLE)
        [btnGetLine150A setImage:[UIImage imageNamed:[Tools imageNameForName:@"line-locked"]] forState:UIControlStateNormal];
    else 
        [btnGetLine150A setImage:[UIImage imageNamed:[Tools imageNameForName:@"line-unlocked"]] forState:UIControlStateNormal];
    

    if(g_ITEMSTATE[0] == SOLD)
    {
        btnGetLine150.enabled = FALSE;
        btnGetLine150A.enabled = FALSE;
    }
    
    [btnGetLine150A addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine150A.tag= 0;
    [scroll addSubview:btnGetLine150A];
    
    //--2
    
    UIButton *btnGetLine400 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine400.frame = CGRectMake(70*g_fScaleX, 80*g_fScaleY, 179*g_fScaleX, 73*g_fScaleY);
    [btnGetLine400 setImage:[UIImage imageNamed:[Tools imageNameForName:@"line-400"]] forState:UIControlStateNormal];
    [btnGetLine400 addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine400.tag =1;
    [scroll addSubview:btnGetLine400];
    
    UIButton *btnGetLine400A = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine400A.frame = CGRectMake(0, 80*g_fScaleY, 60*g_fScaleX, 66*g_fScaleY);
    
    if(g_ITEMSTATE[1] == IMPOSIBLE)
        [btnGetLine400A setImage:[UIImage imageNamed:[Tools imageNameForName:@"line-locked"]] forState:UIControlStateNormal];
    else 
        [btnGetLine400A setImage:[UIImage imageNamed:[Tools imageNameForName:@"line-unlocked"]] forState:UIControlStateNormal];
    
    if(g_ITEMSTATE[1] == SOLD)
    {
        btnGetLine400.enabled = FALSE;
        btnGetLine400A.enabled = FALSE;
    }
    
    [btnGetLine400A addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine400A.tag =1;
    [scroll addSubview:btnGetLine400A];
    
    //--3
    
    UIButton *btnGetLine1200 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine1200.frame = CGRectMake(70*g_fScaleX, 160*g_fScaleY, 179*g_fScaleX, 73*g_fScaleY);
    [btnGetLine1200 setImage:[UIImage imageNamed:[Tools imageNameForName:@"line-1200"]] forState:UIControlStateNormal];
    [btnGetLine1200 addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine1200.tag =2;
    [scroll addSubview:btnGetLine1200];
    
    UIButton *btnGetLine1200A = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine1200A.frame = CGRectMake(0, 160*g_fScaleY, 60*g_fScaleX, 66*g_fScaleY);
    
    if(g_ITEMSTATE[2] == IMPOSIBLE)
        [btnGetLine1200A setImage:[UIImage imageNamed:[Tools imageNameForName:@"line-locked"]] forState:UIControlStateNormal];
    else 
        [btnGetLine1200A setImage:[UIImage imageNamed:[Tools imageNameForName:@"line-unlocked"]] forState:UIControlStateNormal];
    
    if(g_ITEMSTATE[2] == SOLD)
    {
        btnGetLine1200.enabled = FALSE;
        btnGetLine1200A.enabled = FALSE;
    }

    [btnGetLine1200A addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine1200A.tag =2;
    [scroll addSubview:btnGetLine1200A];
    
    //--4
    
    UIButton *btnGetLine2000 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine2000.frame = CGRectMake(70*g_fScaleX, 240*g_fScaleY, 179*g_fScaleX, 73*g_fScaleY);
    [btnGetLine2000 setImage:[UIImage imageNamed:[Tools imageNameForName:@"line-2000"]] forState:UIControlStateNormal];
    [btnGetLine2000 addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine2000.tag =3;
    [scroll addSubview:btnGetLine2000];
    
    UIButton *btnGetLine2000A = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine2000A.frame = CGRectMake(0, 240*g_fScaleY, 60*g_fScaleX, 66*g_fScaleX);
    
    if(g_ITEMSTATE[3] == IMPOSIBLE)
        [btnGetLine2000A setImage:[UIImage imageNamed:[Tools imageNameForName:@"line-locked"]] forState:UIControlStateNormal];
    else 
        [btnGetLine2000A setImage:[UIImage imageNamed:[Tools imageNameForName:@"line-unlocked"]] forState:UIControlStateNormal];
    
    if(g_ITEMSTATE[3] == SOLD)
    {
        btnGetLine2000.enabled = FALSE;
        btnGetLine2000A.enabled = FALSE;
    }


    [btnGetLine2000A addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine2000A.tag =3;
    [scroll addSubview:btnGetLine2000A];
    
    //--5
    UIButton *btnGetLine3500 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine3500.frame = CGRectMake(70*g_fScaleX, 320*g_fScaleY, 179*g_fScaleX, 73*g_fScaleY);
    [btnGetLine3500 setImage:[UIImage imageNamed:[Tools imageNameForName:@"line-3500"]] forState:UIControlStateNormal];
    [btnGetLine3500 addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine3500.tag =4;
    [scroll addSubview:btnGetLine3500];
    
    UIButton *btnGetLine3500A = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine3500A.frame = CGRectMake(0, 320*g_fScaleY, 60*g_fScaleX, 66*g_fScaleY);
    
    if(g_ITEMSTATE[4] == IMPOSIBLE)
        [btnGetLine3500A setImage:[UIImage imageNamed:[Tools imageNameForName:@"line-locked"]] forState:UIControlStateNormal];
    else 
        [btnGetLine3500A setImage:[UIImage imageNamed:[Tools imageNameForName:@"line-unlocked"]] forState:UIControlStateNormal];
    
    if(g_ITEMSTATE[4] == SOLD)
    {
        btnGetLine3500.enabled = FALSE;
        btnGetLine3500A.enabled = FALSE;
    }


    [btnGetLine3500A addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine3500A.tag =4;
    [scroll addSubview:btnGetLine3500A];
    
    //--6
    UIButton *btnGetLine5000 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine5000.frame = CGRectMake(70*g_fScaleX, 400*g_fScaleY, 179*g_fScaleX, 73*g_fScaleY);
    [btnGetLine5000 setImage:[UIImage imageNamed:[Tools imageNameForName:@"line-5000"]] forState:UIControlStateNormal];
    [btnGetLine5000 addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine5000.tag =5;
    [scroll addSubview:btnGetLine5000];
    
    UIButton *btnGetLine5000A = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetLine5000A.frame = CGRectMake(0, 400*g_fScaleY, 60*g_fScaleX, 66*g_fScaleY);
    
    if(g_ITEMSTATE[5] == IMPOSIBLE)
        [btnGetLine5000A setImage:[UIImage imageNamed:[Tools imageNameForName:@"line-locked"]] forState:UIControlStateNormal];
    else 
        [btnGetLine5000A setImage:[UIImage imageNamed:[Tools imageNameForName:@"line-unlocked"]] forState:UIControlStateNormal];
    
    if(g_ITEMSTATE[5] == SOLD)
    {
        btnGetLine5000.enabled = FALSE;
        btnGetLine5000A.enabled = FALSE;
    }


    [btnGetLine5000A addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetLine5000A.tag =5;
    [scroll addSubview:btnGetLine5000A];
    
    scroll.tag=8500;
    [view addSubview:scroll];

    wrapper = [CCUIViewWrapper wrapperForUIView:view];
    [self addChild:wrapper];

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
	if (nItemTag == LINE200_150) g_UserInfo.nMaxDepth = LINE200;
	else if (nItemTag == LINE300_400) g_UserInfo.nMaxDepth = LINE300;
	else if (nItemTag == LINE400_1200) g_UserInfo.nMaxDepth = LINE400;
	else if (nItemTag == LINE500_2000) g_UserInfo.nMaxDepth = LINE500;
	else if (nItemTag == LINE600_3500) g_UserInfo.nMaxDepth = LINE600;
	else if (nItemTag == LINE800_5000) g_UserInfo.nMaxDepth = LINE800;
    
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
/*
 
 */
@end
