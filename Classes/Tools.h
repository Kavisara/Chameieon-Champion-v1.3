/*
 *  Tools.h
 *  Infinity Control
 *
 *  Copyright 2010-2011 Daniel Kostadinoski. Licensed to Rob McRady. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "DeviceSettings.h"

//#include <vector>

//struct b2Vec2
//{
//	/// Default constructor does nothing (for performance).
//	b2Vec2() {}
//    
//	/// Construct using coordinates.
//	b2Vec2(float x, float y) : x(x), y(y) {}
//    
//	/// Set this vector to all zeros.
//	void SetZero() { x = 0.0f; y = 0.0f; }
//    
//	/// Set this vector to some specified coordinates.
//	void Set(float x_, float y_) { x = x_; y = y_; }
//    
//	/// Negate this vector.
//	b2Vec2 operator -() const { b2Vec2 v; v.Set(-x, -y); return v; }
//	
//	/// Read from and indexed element.
//	float operator () (int i) const
//	{
//		return (&x)[i];
//	}
//    
//	/// Write to an indexed element.
//	float& operator () (int i)
//	{
//		return (&x)[i];
//	}
//    
//	/// Add a vector to this vector.
//	void operator += (const b2Vec2& v)
//	{
//		x += v.x; y += v.y;
//	}
//	
//	/// Subtract a vector from this vector.
//	void operator -= (const b2Vec2& v)
//	{
//		x -= v.x; y -= v.y;
//	}
//    
//	/// Multiply this vector by a scalar.
//	void operator *= (float a)
//	{
//		x *= a; y *= a;
//	}    
//    
//	/// Get the length squared. For performance, use this instead of
//	/// b2Vec2::Length (if possible).
//	float LengthSquared() const
//	{
//		return x * x + y * y;
//	}
//    
//    CGPoint returnPoint() const
//    {
//        return CGPointMake(x, y);
//    }
//	/// Convert this vector into a unit vector. Returns the length.
//    
//	float x, y;
//};

@interface Tools : NSObject
{
    
}

+ (NSString*)imageNameForName:(NSString*)name;
+ (NSString*)jpegImageNameForName:(NSString*)name;

+ (BOOL)isHighRes;
// added by KKJ
+(BOOL)is4inchPhone;



+ (CGPoint)nodePositionForPosition:(CGPoint)position;
+ (CGFloat)heightOfTextForHeight:(CGFloat)height;

+ (CGFloat)scaleFactorX;
+ (CGFloat)scaleFactorY;

+ (CGFloat)backscaleFactorX;
+ (CGFloat)backscaleFactorY;

@end
