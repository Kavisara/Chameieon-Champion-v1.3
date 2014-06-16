//
//  TreasureScene.m
//  NinjaFishing
//
//  Created by JinJin on 7/9/13.
//
//

#import "TreasureScene.h"
#import "Tools.h"
#import "ScoreScene.h"


@implementation TreasureScene
+(id) scene
{
	CCScene *scene = [CCScene node];
	TreasureScene *layer = [TreasureScene node];
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
        
        bgSprite = [CCSprite spriteWithFile:[Tools imageNameForName:@"TreasuresBG"]];
        bgSprite.scaleX = g_fScaleX;bgSprite.scaleY =g_fScaleY;
        bgSprite.anchorPoint = ccp(0.0f, 0.0f);
        [self addChild:bgSprite];
        bgSprite.position = ccp(0.0f, 0.0f);
        
        CCMenuItemImage* btnBack = [CCMenuItemImage itemFromNormalImage:[Tools imageNameForName:@"back-button"]
                                                          selectedImage:[Tools imageNameForName:@"back-button"] target:self selector:@selector(OnBack:)];
        btnBack.anchorPoint = ccp(0.0, 1.0);
        btnBack.position = ccp(20 * g_fScaleX, 475 * g_fScaleY);
        
        CCMenu* back = [CCMenu menuWithItems:btnBack,nil];
        back.tag = 1000;
		back.position = ccp(0, 0);
        [self addChild:back];
        
        CCLabelTTF *lbl = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%d",g_UserInfo.nMoney]
                                                    fontName:@"BADABB_.TTF"
                                                    fontSize:18];
        lbl.anchorPoint = ccp(1,0);
        lbl.position = ccp(60*g_fScaleX,0);
        [lbl setColor:ccGREEN]; [self addChild:lbl z:2000];[lbl release];
        
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
        scroll.frame=CGRectMake(30*g_fScaleX,93*g_fScaleY,258*g_fScaleX,315*g_fScaleY);
        scroll.contentSize=CGSizeMake(256*g_fScaleX,600*g_fScaleY);
    }
    
    //--1
    UIButton *btnGetbelt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetbelt.frame = CGRectMake(0, 0, 125*g_fScaleX, 58*g_fScaleY);
    [btnGetbelt setImage:[UIImage imageNamed:@"Treasures-belt.png"] forState:UIControlStateNormal];
    [btnGetbelt addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetbelt.tag= 0;
    [scroll addSubview:btnGetbelt];
    
    UIButton *btnGetbeer= [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetbeer.frame = CGRectMake(128, 0, 125*g_fScaleX, 58*g_fScaleY);
    [btnGetbeer setImage:[UIImage imageNamed:@"Treasures-beer.png"] forState:UIControlStateNormal];
    [btnGetbeer addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetbeer.tag= 1;
    [scroll addSubview:btnGetbeer];
    
    //--2
    
    UIButton *btnGetguitar = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetguitar.frame = CGRectMake(0, 63, 125*g_fScaleX, 58*g_fScaleY);
    [btnGetguitar setImage:[UIImage imageNamed:@"Treasures-guitar.png"] forState:UIControlStateNormal];
    [btnGetguitar addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetguitar.tag= 2;
    [scroll addSubview:btnGetguitar];
    
    UIButton *btnGethotdog= [UIButton buttonWithType:UIButtonTypeCustom];
    btnGethotdog.frame = CGRectMake(128, 63, 125*g_fScaleX, 58*g_fScaleY);
    [btnGethotdog setImage:[UIImage imageNamed:@"Treasures-hotdog.png"] forState:UIControlStateNormal];
    [btnGethotdog addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGethotdog.tag= 3;
    [scroll addSubview:btnGethotdog];
    
    //--3
    
    UIButton *btnGetmailbox = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetmailbox.frame = CGRectMake(0, 126, 125*g_fScaleX, 58*g_fScaleY);
    [btnGetmailbox setImage:[UIImage imageNamed:@"Treasures-mailbox.png"] forState:UIControlStateNormal];
    [btnGetmailbox addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetmailbox.tag= 4;
    [scroll addSubview:btnGetmailbox];
    
    UIButton *btnGetball= [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetball.frame = CGRectMake(128, 126, 125*g_fScaleX, 58*g_fScaleY);
    [btnGetball setImage:[UIImage imageNamed:@"Treasures-ball.png"] forState:UIControlStateNormal];
    [btnGetball addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetball.tag= 5;
    [scroll addSubview:btnGetball];

    //--4
    
    UIButton *btnGetsandwich = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetsandwich.frame = CGRectMake(0, 189, 125*g_fScaleX, 58*g_fScaleY);
    [btnGetsandwich setImage:[UIImage imageNamed:@"Treasures-sandwich.png"] forState:UIControlStateNormal];
    [btnGetsandwich addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetsandwich.tag= 6;
    [scroll addSubview:btnGetsandwich];
    
    UIButton *btnGetround= [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetround.frame = CGRectMake(128, 189, 125*g_fScaleX, 58*g_fScaleY);
    [btnGetround setImage:[UIImage imageNamed:@"Treasures-round.png"] forState:UIControlStateNormal];
    [btnGetround addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetround.tag= 7;
    [scroll addSubview:btnGetround];

    
    //--5
    
    UIButton *btnGetmouse = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetmouse.frame = CGRectMake(0, 252, 125*g_fScaleX, 58*g_fScaleY);
    [btnGetmouse setImage:[UIImage imageNamed:@"Treasures-mouse.png"] forState:UIControlStateNormal];
    [btnGetmouse addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetmouse.tag= 8;
    [scroll addSubview:btnGetmouse];
    
    UIButton *btnGetfootball= [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetfootball.frame = CGRectMake(128, 252, 125*g_fScaleX, 58*g_fScaleY);
    [btnGetfootball setImage:[UIImage imageNamed:@"Treasures-football.png"] forState:UIControlStateNormal];
    [btnGetfootball addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetfootball.tag= 9;
    [scroll addSubview:btnGetfootball];

    //--6
    
    UIButton *btnGetbag = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetbag.frame = CGRectMake(0, 315, 125*g_fScaleX, 58*g_fScaleY);
    [btnGetbag setImage:[UIImage imageNamed:@"Treasures-bag.png"] forState:UIControlStateNormal];
    [btnGetbag addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetbag.tag= 10;
    [scroll addSubview:btnGetbag];
    
    UIButton *btnGetbread= [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetbread.frame = CGRectMake(128, 315, 125*g_fScaleX, 58*g_fScaleY);
    [btnGetbread setImage:[UIImage imageNamed:@"Treasures-bread.png"] forState:UIControlStateNormal];
    [btnGetbread addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetbread.tag= 11;
    [scroll addSubview:btnGetbread];

    //--7
    
    UIButton *btnGetapple = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetapple.frame = CGRectMake(0, 378, 125*g_fScaleX, 58*g_fScaleY);
    [btnGetapple setImage:[UIImage imageNamed:@"Treasures-apple.png"] forState:UIControlStateNormal];
    [btnGetapple addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetapple.tag= 12;
    [scroll addSubview:btnGetapple];
    
    UIButton *btnGetphone= [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetphone.frame = CGRectMake(128, 378, 125*g_fScaleX, 58*g_fScaleY);
    [btnGetphone setImage:[UIImage imageNamed:@"Treasures-phone.png"] forState:UIControlStateNormal];
    [btnGetphone addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetphone.tag= 13;
    [scroll addSubview:btnGetphone];

    //--8
    
    UIButton *btnGetrecycle = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetrecycle.frame = CGRectMake(0, 441, 125*g_fScaleX, 58*g_fScaleY);
    [btnGetrecycle setImage:[UIImage imageNamed:@"Treasures-recycle.png"] forState:UIControlStateNormal];
    [btnGetrecycle addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetrecycle.tag= 14;
    [scroll addSubview:btnGetrecycle];
    
    UIButton *btnGettooth= [UIButton buttonWithType:UIButtonTypeCustom];
    btnGettooth.frame = CGRectMake(128, 441, 125*g_fScaleX, 58*g_fScaleY);
    [btnGettooth setImage:[UIImage imageNamed:@"Treasures-football.png"] forState:UIControlStateNormal];
    [btnGettooth addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGettooth.tag= 15;
    [scroll addSubview:btnGettooth];
    
    
    //--9
    
    UIButton *btnGetpresent = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetpresent.frame = CGRectMake(0, 504, 125*g_fScaleX, 58*g_fScaleY);
    [btnGetpresent setImage:[UIImage imageNamed:@"Treasures-present.png"] forState:UIControlStateNormal];
    [btnGetpresent addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetpresent.tag= 16;
    [scroll addSubview:btnGetpresent];
    
    UIButton *btnGettoy= [UIButton buttonWithType:UIButtonTypeCustom];
    btnGettoy.frame = CGRectMake(128, 504, 125*g_fScaleX, 58*g_fScaleY);
    [btnGettoy setImage:[UIImage imageNamed:@"Treasures-toy.png"] forState:UIControlStateNormal];
    [btnGettoy addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGettoy.tag= 17;
    [scroll addSubview:btnGettoy];
    [view addSubview:scroll];
    
    //--10
    
    UIButton *btnGetbanana = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetbanana.frame = CGRectMake(0, 567, 125*g_fScaleX, 58*g_fScaleY);
    [btnGetbanana setImage:[UIImage imageNamed:@"Treasures-banana.png"] forState:UIControlStateNormal];
    [btnGetbanana addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetbanana.tag= 18;
    [scroll addSubview:btnGetbanana];
    
    UIButton *btnGetheart= [UIButton buttonWithType:UIButtonTypeCustom];
    btnGetheart.frame = CGRectMake(128, 567, 125*g_fScaleX, 58*g_fScaleY);
    [btnGetheart setImage:[UIImage imageNamed:@"Treasures-heart.png"] forState:UIControlStateNormal];
    [btnGetheart addTarget:self action:@selector(onGetLine:)forControlEvents:UIControlEventTouchUpInside];
    btnGetheart.tag= 19;
    [scroll addSubview:btnGetheart];
    [view addSubview:scroll];
    
    wrapper = [CCUIViewWrapper wrapperForUIView:view];
    [self addChild:wrapper];
    [scroll release];
    
}

-(void) onGetLine:(id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
}

-(void) OnBack : (id)sender
{
    [g_GameUtils playSoundEffect:@"Button_All.mp3"];
    
    scroll.hidden=YES;
    NSString *r = @"CCTransitionFade";
	Class transion = NSClassFromString(r);
    [[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:1.0f scene:[ScoreScene scene]]];
}

@end
