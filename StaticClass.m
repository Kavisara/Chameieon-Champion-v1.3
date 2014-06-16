
//
//  StaticClass.m
//  PocketRealty
//
//  Created by TISMobile on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StaticClass.h"

static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@implementation StaticClass

// MD5 generating
+(NSString *) returnMD5Hash:(NSString *)concat
{
	const char *concat_str = [concat UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(concat_str, strlen(concat_str), result);
	NSMutableString *hash = [NSMutableString string];
	for (int i = 0; i < 16; i++)
		[hash appendFormat:@"%02X", result[i]];
	return [hash lowercaseString];
}

+(void)saveToUserDefaults:(NSString*)myString : (NSString *) pref
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	if (standardUserDefaults) {
		[standardUserDefaults setObject:myString forKey:pref];
		[standardUserDefaults synchronize];
	}
}

+(NSString*)retrieveFromUserDefaults: (NSString *) pref
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *val = nil;
	
	if (standardUserDefaults) 
		val = [standardUserDefaults objectForKey: pref];
	
	return val;
}

+(UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
	UIGraphicsBeginImageContext( newSize );
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

// String Encoding
+(NSString * ) urlEncoding : (NSString *) raw 
{
	NSString *preparedString = [raw stringByReplacingOccurrencesOfString: @" " withString: @"%20"];
//	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"&" withString: @"%26"];
    preparedString = [preparedString stringByReplacingOccurrencesOfString: @"/" withString: @"%2F"];
	return preparedString ;
}

// String Decoding 
+(NSString * ) urlDecode : (NSString *) raw 
{
	NSString *preparedString = [raw stringByReplacingOccurrencesOfString: @"%20" withString: @" "];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%7B" withString: @"{"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%2F" withString: @"/"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%3A" withString: @":"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%2C" withString: @","];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%7D" withString: @"}"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%22" withString: @" "];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%0A" withString: @""];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"+" withString: @" "];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%5C" withString: @""];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%27" withString: @"'"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%24" withString: @"$"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%3F" withString: @"?"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%3A" withString: @":"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%2F" withString: @"/"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%3F" withString: @"?"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%3D" withString: @"="];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%26" withString: @"&"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%3B" withString: @";"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"&amp;" withString: @"&"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%28" withString: @"("];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%29" withString: @")"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%2A" withString: @"*"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%2B" withString: @"+"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%2E" withString: @"."];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%2D" withString: @"-"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%40" withString: @"@"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%3C" withString: @"<"];
	//preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%C3" withString: @""];
	//preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%83" withString: @""];
	//preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%C2" withString: @""];
	//preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%A9" withString: @""];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%21" withString: @"!"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%0D" withString: @" "];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%09" withString: @" "];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%3E" withString: @">"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%7E" withString: @"~"];
	
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%C3%B6" withString: @"ö"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%C3%96" withString: @"Ö"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%C4%B0" withString: @"İ"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%C4%B1" withString: @"ı"];

	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%C3%9C" withString: @"Ü"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%C3%BC" withString: @"ü"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%C3%87" withString: @"Ç"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%C3%A7" withString: @"ç"];
	
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%C4%9E" withString: @"Ğ"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%C4%9F" withString: @"ğ"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%C5%9E" withString: @"Ş"];
	preparedString = [preparedString stringByReplacingOccurrencesOfString: @"%C5%9F" withString: @"ş"];
	
	return preparedString;
	
}

+(NSString *) genRandStringLength: (int) len {
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
		[randomString appendFormat: @"%c", [letters characterAtIndex: rand()%[letters length] ] ]  ;
	}
	NSDate *date = [NSDate date];
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"ddMMyyyyhhmmss"];
	NSString *dateStr = [formatter stringFromDate:date];
	return [NSString stringWithFormat:@"%@%@.caf",randomString,dateStr];
}
//ends here

+(NSString *) genrandimagefilename: (int) len {
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
		[randomString appendFormat: @"%c", [letters characterAtIndex: rand()%[letters length] ] ]  ;
	}
	NSDate *date = [NSDate date];
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"ddMMyyyyhhmmss"];
	NSString *dateStr = [formatter stringFromDate:date];
	return [NSString stringWithFormat:@"%@%@.jpg",randomString,dateStr];
}

//+ (UIColor *)colorWithHexString:(NSString *)str {
//    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
//    long x = strtol(cStr+1, NULL, 16);
//    return [self colorWithHex:x];
//}
//
//// takes 0x123456
//+ (UIColor *)colorWithHex:(UInt32)col {
//    unsigned char r, g, b;
//    b = col & 0xFF;
//    g = (col >> 8) & 0xFF;
//    r = (col >> 16) & 0xFF;
//    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
//}

@end
