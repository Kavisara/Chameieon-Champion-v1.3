//
//  LevelSelectionController.m
//  TrafficLight
//
//  Created by Rupen Makhecha on 04/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectionController.h"
#import "GameScene.h"

@implementation SelectionController

+(id)scene {
	CCScene *scene = [CCScene node];
	SelectionController *layer = [SelectionController node];
	[scene addChild: layer];
	return scene;
}

-(id) init {
	if((self=[super init])) {
		// add the background image
		CCSprite *backdrop = [CCSprite spriteWithFile: @"bg1.png"];
        [backdrop setScaleX:g_fScaleX]; backdrop.scaleY = g_fScaleY;
		backdrop.position = ccp(g_size.width / 2, g_size.height / 2);
//		[backdrop setPosition:ccp(320,480)];
		[self addChild:backdrop];
		
//		//Add Back Button
//		CCMenuItem *BackButton = [CCMenuItemImage itemFromNormalImage:@"BackButton.png" 
//		selectedImage:@"BackButton.png" target:self selector:@selector(BackButtonClick)];
//		BackButton.position = ccp(30,30);
//		CCMenu *back = [CCMenu menuWithItems:BackButton, nil];
//		back.position = CGPointZero;
//		[self addChild:back];
		
		view = [[CCDirector sharedDirector] openGLView];
		scroll=[[UIScrollView alloc] init];
		scroll.frame=CGRectMake(0,50,320,380);
		scroll.contentSize=CGSizeMake(1000,380);
		scroll.showsHorizontalScrollIndicator=NO;
		scroll.showsVerticalScrollIndicator=NO;
		//LEVEL 1
		level1PlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		level1PlayBtn.frame = CGRectMake(85.0, 7.0, 235, 365.0);
		[level1PlayBtn setImage:[UIImage imageNamed:@"b_m.png"] forState:UIControlStateNormal];
		[level1PlayBtn addTarget:self action:@selector(playBtnLevel1Click)forControlEvents:UIControlEventTouchUpInside];
		[scroll addSubview:level1PlayBtn];
		//OVER
		
		//LEVEL 2
		level2PlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		level2PlayBtn.frame = CGRectMake(405.0, 7.0, 235, 365.0);
		[level2PlayBtn setImage:[UIImage imageNamed:@"fighter.png"] forState:UIControlStateNormal];
		[level2PlayBtn addTarget:self action:@selector(playBtnLevel2Click)forControlEvents:UIControlEventTouchUpInside];
		[scroll addSubview:level2PlayBtn];
		//OVER
		
		//LEVEL 3
		level3PlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		level3PlayBtn.frame = CGRectMake(720.0, 7.0, 235, 365.0);
		[level3PlayBtn setImage:[UIImage imageNamed:@"ninja_new.png"] forState:UIControlStateNormal];
		[level3PlayBtn addTarget:self action:@selector(playBtnLevel3Click)forControlEvents:UIControlEventTouchUpInside];
		[scroll addSubview:level3PlayBtn];
		//OVER
//		
//        UIButton *foreward = [UIButton buttonWithType:UIButtonTypeCustom];
//		foreward.frame = CGRectMake(720.0, 7.0, 235, 365.0);
//		[foreward setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//		[foreward addTarget:self action:@selector(playBtnLevel3Click)forControlEvents:UIControlEventTouchUpInside];
//        [scroll addSubview:foreward];
//        
//        UIButton *backword = [UIButton buttonWithType:UIButtonTypeCustom];
//		backword.frame = CGRectMake(720.0, 7.0, 235, 365.0);
//		[backword setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//		[backword addTarget:self action:@selector(playBtnLevel3Click)forControlEvents:UIControlEventTouchUpInside];
//        [scroll addSubview:backword];
//        
		[view addSubview:scroll];
		wrapper = [CCUIViewWrapper wrapperForUIView:view];
		[self addChild:wrapper];
		[scroll release];
	}
	return self;
}

-(void)BackButtonClick {
	scroll.hidden=YES;
    NSString *r = @"CCTransitionFade";
	Class transion = NSClassFromString(r);
    [[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:1.0f scene:[GameScene scene]]];
}

-(void)playBtnLevel1Click {
	scroll.hidden=YES;
    NSString *r = @"CCTransitionFade";
	Class transion = NSClassFromString(r);
    [StaticClass saveToUserDefaults:@"b_man":@"CHARACTER"];
    [[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:1.0f scene:[GameScene scene]]];
}

-(void)playBtnLevel2Click {
	scroll.hidden=YES;
    NSString *r = @"CCTransitionFade";
	Class transion = NSClassFromString(r);
    [StaticClass saveToUserDefaults:@"f_man":@"CHARACTER"];
    [[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:1.0f scene:[GameScene scene]]];
}

-(void)playBtnLevel3Click {
	scroll.hidden=YES;
    NSString *r = @"CCTransitionFade";
	Class transion = NSClassFromString(r);
    [StaticClass saveToUserDefaults:@"man":@"CHARACTER"];
    [[CCDirector sharedDirector] replaceScene:[transion transitionWithDuration:1.0f scene:[GameScene scene]]];
}

@end