//
//  Trophies.h
//  NinjaFish
//
//  Created by Techintegrity Services on 9/11/11.
//  Copyright 2011 Techintegrity Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"

@interface Trophies : CCLayer {
	//touch
	BOOL m_bTouch;
	CGPoint m_arrayTouch[MAX_TOUCH];
	int m_nTouchNum;
    
    CCLayer* viewer;
}
+(id) scene;

@end
