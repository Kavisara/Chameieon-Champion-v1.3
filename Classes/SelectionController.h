//
//  LevelSelectionController.h
//  TrafficLight
//
//  Created by Rupen Makhecha on 04/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCUIViewWrapper.h"
#import "GameConfig.h"

@interface SelectionController : CCLayer {
	CCSprite *logo;
	CCSprite *level1;
	
	CCUIViewWrapper *wrapper;
	UIView *view;
	UIScrollView *scroll;
	
    UIPageControl   *pageControl;
    BOOL pageControlIsChangingPage;
    
	UIImageView *level1img;
	UIButton *level1PlayBtn;
	UIButton *level1BestScoreBtn;
	
	UIImageView *level2img;
	UIButton *level2PlayBtn;
	UIButton *level2BestScoreBtn;
	
	UIImageView *level3img;
	UIButton *level3PlayBtn;
	UIButton *level3BestScoreBtn;
}
@property (nonatomic, retain) UIPageControl   *pageControl;

+(id)scene;

@end
