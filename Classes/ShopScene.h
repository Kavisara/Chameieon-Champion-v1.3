//
//  ShopScene.h
//  NinjaFish
//
//  Created by Techintegrity Services on 9/11/11.
//  Copyright 2011 Techintegrity Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"

@interface ShopScene : CCLayer {
	CCTexture2D *texItem;
	CCTexture2D *texSelItem;
	CCTexture2D *texSold;
	
	CCMenu *menu;	
	CCMenuItemImage *itemClose;
	
	int nIdx;
	int szItemIndex[SHOPITEM_COUNT]; // = {0,5,7,8,9,10,11,12,1,2,3,4,6};
	
	//touch
	BOOL m_bTouch;
	CGPoint m_arrayTouch[MAX_TOUCH];
	int m_nTouchNum;
}
+(id) scene;
-(void) updateInfo:(int)nItemTag;
@end
