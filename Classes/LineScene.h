//
//  LineScene.h
//  NinjaFishing
//
//  Created by lion on 7/4/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"
#import "CCUIViewWrapper.h"

@interface LineScene : CCLayer
{
    CCUIViewWrapper *wrapper;
	UIView *view;
	UIScrollView *scroll;
    
}

+(id) scene;

@end
