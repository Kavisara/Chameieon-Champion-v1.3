//
//  ScoreScene.h
//  NinjaFish
//
//  Created by Techintegrity Services on 9/11/11.
//  Copyright 2011 Techintegrity Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScoreScene : CCLayer {
	int nTime;
	int nIdx;
	int nNum;
	
	int nFishType;
	BOOL fMes;
	
	BOOL fScore;
	BOOL fFish;
	BOOL fMoney;
	BOOL fTotal;
	NSString *str;
}
+(id) scene;
-(BOOL) loadFish;
@end
