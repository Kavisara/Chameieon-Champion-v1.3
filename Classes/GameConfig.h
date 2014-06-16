//
//  GameConfig.h
//  NinjaFishing
//
//  Created by Techintegrity Services on 11/7/11.
//  Copyright Techintegrity Services 2011. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//
#define GAME_AUTOROTATION kGameAutorotationNone

#import "GameUtils.h"
CGSize g_size;

float g_fScaleX, g_fScaleY;
bool g_rScale;

float g_rSound, g_rMusic;
//bool g_bVib;
bool g_bSetup;

#define SCALE 1.2f
#define MAX_TOUCH	100

typedef struct{
	int nMoney;
	int nScore;
	int nTotalScore;
	int nFishTypeNum;
	int nCurDepth;
	int nTotalDepth;
	int nMaxDepth;
	int nBlade;
	int nFuel;
	int nSpeed;
	int nSale;
	int nLantern;
	int nHook;
	int nWeight;
	
} USER_INFO;

USER_INFO g_UserInfo;

#define SHOPITEM_COUNT	26
int g_ITEMSTATE[SHOPITEM_COUNT]; //= {1,0,0,0,0,1,0,1,1,1,1,1,1};

enum ITEMSTATE {
	IMPOSIBLE,
	POSIBLE,
	SOLD
};

enum SHOPITEMTYPE {
	LINE200_150,
	LINE300_400,
	LINE400_1200,
	LINE500_2000,
	LINE600_3500,
	LINE800_5000,	
	BLADE1_250,
	BLADE2_1000,
	BLADE3_2500,
	BLADE4_4000,
	FUEL100_50,
	FUEL125_300,
	FUEL150_1000,
	FUEL200_2500,
	SPEED25_400,
	SALE10_500,
	MBA25_2000,
	LANTERN500_1000,
	HOOK35_500,
	HOOK50_1500,
	WEIGHT30_30,
	WEIGHT90_500,
	WEIGHT190_1000,
	WEIGHT290_2500,
	WEIGHT390_4000,
	WEIGHT490_6000
};

typedef struct {
	int nIdx;
	int nCost;
	NSString *strFile;
	NSString *strTop;
	NSString *strBottom;
	NSString *strImpos;
	NSString *strBuy;
	CGPoint szTop;
	CGPoint szBottom;
	CGPoint szCoin;	
} SHOPITEM;

SHOPITEM m_ShopItem[SHOPITEM_COUNT];

enum GAMESTATE {
	GAME_START,
	GAME_TAPFIRST,
	GAME_TAPSECOND,
	GAME_TAPTHIRD,
	GAME_TILTDOWN,
	GAME_DOWNSTOP,
	GAME_TAPFOURTH,
	GAME_TILTUP,
	GAME_TAPFIFTH,
	GAME_SLASH,
	GAME_OVER
};

#define MOVELENGTH 80
#define INTERVAL_CHANGEDEPTH	0.3f
#define INTERVAL_MOVEBG			0.1f
#define INTERVAL_SPREADFISH		0.4f
#define INTERVAL_GENBUBBLE		3.f
#define INTERVAL_GENBOMB		2.f
#define INTERVAL_GENMINE		20.f
#define INTERVAL_WEIGHT			0.03f

float nInterval_generatefish;
int nStepDepth;
int nInterval_loadwall;

#define MOVE_SCALE 12.f
#define TILT_PRAM 100.f

BOOL fTrophies;
BOOL fShop;
BOOL fGame;

#define LINE_NUM		100
#define MESSAGE_COUNT	6

NSMutableArray* slash_fishes;
NSMutableArray* fishes;
NSMutableArray* catched_fishes;
NSMutableArray* m_szWalls;
NSMutableArray* m_szMines;

#define FISHTYPE_NUM 22
int fishType [FISHTYPE_NUM];

enum FISHSTATE {
	FISH_GENERATE,
	FISH_PASSDOWN,
	FISH_PASSUP
};

enum FISHTYPE {
	YellowMinnow,
	RedMinnow,
	RainbowFish,
	Seabass,
	ParrotFish,
	Eel,
	Crab,
	Turtle,
	Pufferfish,
	Squid,
	Jellyfish,
	Tuna,
	Barracuda,
	Lobster,
	Octopus,
	Swordfish,
	Shark,
	Plankton,
	Mantaray,
	Vampirefish,
	Ceolacanth,
	Giantsquid,
	Treasure = 50,
	Bomb = 100,
	Mine = 150
};

#endif // __GAME_CONFIG_H