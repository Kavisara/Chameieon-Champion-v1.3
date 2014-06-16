//
//  PauseGameSprite.h
//  NinjaFish
//
//  Created by Techintegrity Services on 9/14/11.
//  Copyright 2011 Techintegrity Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PauseGameSprite : CCSprite {
	CCSprite *spBox0;
	CCSprite *spBox1;
	CCMenuItemImage *itemSoundD;
	CCMenuItemImage *itemSoundI;
	CCMenuItemImage *itemMusicD;
	CCMenuItemImage *itemMusicI;
	CCMenuItemImage *itemReset;
	CCMenuItemImage *itemGo;
	CCMenu* menu1;
	CCLabelBMFont *label_Option;
	CCLabelBMFont *label_Sound;
	CCLabelBMFont *label_Music;
	CCLabelBMFont *label_Sound_Val;
	CCLabelBMFont *label_Music_Val;
    CCLabelTTF* label_Sound_Value;
    CCLabelTTF* label_Music_Value;
}

-(id) initSprite;
-(id) initSprite:(int) mode;
-(void) removeLabel : (CCLabelBMFont*)label;
-(void) removeLabelTTF : (CCLabelTTF*)label;
-(void) removeSprite : (CCSprite*)sprite;
-(void) removeMenuItem : (CCMenuItemImage*)item;
@end
