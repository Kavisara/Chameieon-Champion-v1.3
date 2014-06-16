//
//  FishSprite.h
//  NinjaFish
//
//  Created by Techintegrity Services on 9/26/11.
//  Copyright 2011 Techintegrity Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FishSprite : CCSprite{
	int		state;
	int		type;
	int		slashnum;
	int		nStepX;
	int		nStepY;
	int		nMaxHeight;
	int		nAngle;
	BOOL	fUp;
}

@property(readwrite) int state;
@property(readwrite) int type;
@property(readwrite) int slashnum;
@property(readwrite) int treasure_mode;

+(id) spriteWithFile:(NSString*)filename;
-(id)initWithType:(int)ntype flip:(BOOL)bflip;
-(void)	startMove;
-(void)	stopMove;
-(void)	stopRun;
-(void)	startRun;
-(int) getScore;
-(NSString*) getString;
-(int) getMaxSlashNum;
-(void) releasefish;
@end
