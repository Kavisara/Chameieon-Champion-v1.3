#import "CCUIViewWrapper.h"

@implementation CCUIViewWrapper

@synthesize uiItem;

+ (id) wrapperForUIView:(UIView*)ui
{
	return [[[self alloc] initForUIView:ui] autorelease];
}

- (id) initForUIView:(UIView*)ui
{
	if((self = [self init]))
	{
		self.uiItem = ui;
		return self;
	}
	return nil;
}

- (void) dealloc
{
	self.uiItem = nil;
	[super dealloc];
}

@end