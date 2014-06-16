/*
 *  Tools.mm
 *  Infinity Control
 *
 *  Created by Kingdom Ltd. and Property of Kingdom Ltd.
 *
 */


#import "Tools.h"
#import "NinjaFishingAppDelegate.h"
#import <Foundation/Foundation.h>

@implementation Tools

static NSCache *cache = [[NSCache alloc] init];


+ (NSString*)imageNameForName:(NSString*)name
{
    NSString* imageName;
    
    imageName=[cache objectForKey:name];
    
    if (imageName==NULL)
    {
        if ([self isHighRes])
        {
            if (IS_IPAD())
                imageName= [NSString stringWithFormat:@"%@-iPad.png", name];
            else
                imageName= [NSString stringWithFormat:@"%@-hd.png", name];
        }
        else
        {
            if (IS_IPAD())
                imageName= [NSString stringWithFormat:@"%@-iPad.png", name];
            else
                imageName= [NSString stringWithFormat:@"%@.png", name];
        }
        [cache setObject:imageName forKey:name];
    }
    
    return imageName;
}

+(NSString *)jpegImageNameForName:(NSString *)name
{
    NSString* imageName;
    
    imageName=[cache objectForKey:name];
    
    if (imageName==NULL)
    {
        if ([self isHighRes])
        {
            if (IS_IPAD())
                imageName= [NSString stringWithFormat:@"%@-iPad.jpg", name];
            else
                imageName= [NSString stringWithFormat:@"%@-hd.jpg", name];
        }
        else
        {
            if (IS_IPAD())
                imageName= [NSString stringWithFormat:@"%@-iPad.jpg", name];
            else
                imageName= [NSString stringWithFormat:@"%@.jpg", name];
        }
        [cache setObject:imageName forKey:name];
    }
    
    return imageName;
}


+ (BOOL)isHighRes
{
    if ([(NinjaFishingAppDelegate*)[[UIApplication sharedApplication] delegate] isHighRes])
        return YES;
    else
        return NO;
}

+(BOOL)is4inchPhone
{
    if ([(NinjaFishingAppDelegate*)[[UIApplication sharedApplication] delegate] is4inchPhone])
        return YES;
    else
        return NO;
}

+ (CGPoint)nodePositionForPosition:(CGPoint)position
{
	if ([self isHighRes])
		return CGPointMake(position.x * 2, position.y * 2);
    
	return position;
}

+ (CGFloat)heightOfTextForHeight:(CGFloat)height
{
	if ([self isHighRes])
		return height * 2;
    
	return height;
}

+ (CGFloat)scaleFactorX
{
	if ([self isHighRes])
		return 2.0f;
    
    if (IS_IPAD())
        return 1024.0 / 480.0;
    
	return 1.0f;
}

+ (CGFloat)scaleFactorY
{
    if ([self isHighRes])
		return 2.0f;
    
    if (IS_IPAD())
        return 768.0 / 320.0;
    
	return 1;
}

+ (CGFloat)backscaleFactorX
{
    if (IS_IPAD())
        return 1024.0 / 480.0;
    else
        return 1.0;
}

+ (CGFloat)backscaleFactorY
{
    if (IS_IPAD())
        return 768.0 / 320.0;
    else
        return 1.0f;
}

@end
