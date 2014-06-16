//
//  GameUtils.h
//  MonkeyTime
//
//  Created by OCH on 11/01/16.
//  Copyright 2011 Techintegrity Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface GameUtils : NSObject {
	BOOL	m_bSound;
	SimpleAudioEngine*		m_SoundEngine;
}

@property (nonatomic,readonly,assign) BOOL		sound;

-(void) setSound:(BOOL)sound;
-(void) playBackgroundMusic:(NSString*)str;
-(ALuint) playSoundEffect:(NSString*)str;
-(void) stopBackgroundMusic;
-(void) setSoundEffectVolume:(float)nVolume;
-(void) stopSoundEffect : (ALuint) soundId;
-(void) setMusicVolume : (float) rVolume;
	
@end

extern GameUtils*	g_GameUtils;