//
//  HelloWorldLayer.h
//  NinjaFishing
//
//  Created by Techintegrity Services on 11/7/11.
//  Copyright Techintegrity Services 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorld Layer
@interface HelloWorld : CCLayer
{
	CCTexture2D *texture[3];
	int m_nTick;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

-(void) loadTexture:(ccTime)dt;

@end
