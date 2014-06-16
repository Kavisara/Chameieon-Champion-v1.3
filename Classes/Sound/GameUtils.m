//
//  GameUtils.m
//  MonkeyTime
//
//  Created by OCH on 11/01/16.
//  Copyright 2011 Techintegrity Services. All rights reserved.
//

#import "GameUtils.h"
#import "GameConfig.h"

GameUtils*		g_GameUtils = nil;

@implementation GameUtils

@synthesize sound			= m_bSound;


// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self = [super init] )) {
		m_bSound			= YES;
		
		m_SoundEngine = [SimpleAudioEngine sharedEngine];
	}
	return self;
}

-(void) playBackgroundMusic:(NSString*)str
{
	[m_SoundEngine setBackgroundMusicVolume:g_rMusic];
	[m_SoundEngine playBackgroundMusic:str];
}

-(void) stopBackgroundMusic
{
	[m_SoundEngine stopBackgroundMusic];
}

-(ALuint) playSoundEffect:(NSString*)str
{
	[m_SoundEngine setEffectsVolume:g_rSound];
	ALuint nIn = [m_SoundEngine playEffect:str];
	return nIn;
}

-(void) stopSoundEffect : (ALuint)soundId
{
	if (m_bSound) {
		[m_SoundEngine stopEffect:(ALuint)soundId];
	}
}
-(void) setSoundEffectVolume:(float)nVolume
{
	[m_SoundEngine setEffectsVolume:nVolume];
}
-(void) setMusicVolume : (float) rVolume
{
	[m_SoundEngine setBackgroundMusicVolume:rVolume];
}

-(BOOL) sound
{
	return m_bSound;
}

-(void) setSound:(BOOL)sound
{
	if (m_bSound == sound)
		return;
	m_bSound = sound;
	if (sound) {
		[m_SoundEngine setMute:NO];
	}
	else {
		[m_SoundEngine setMute:YES];
	}
}



@end
