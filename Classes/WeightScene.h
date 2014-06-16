//
//  WeightScene.h
//  NinjaFishing
//
//  Created by JinJin on 7/9/13.
//
//

#import "CCLayer.h"
#import "CCUIViewWrapper.h"
#import "GameConfig.h"

@interface WeightScene : CCLayer
{
    CCUIViewWrapper *wrapper;
	UIView *view;
	UIScrollView *scroll;
    
}

+(id) scene;

@end
