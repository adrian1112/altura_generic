//
//  PBEwithMD5andDes.h
//  com.altura
//
//  Created by adrian aguilar on 11/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface PBEwithMD5andDes : NSObject

+ (NSData *)encryptPBEWithMD5AndDESData:(NSData *)inData password:(NSString *)password iterations:(int)iterations;
+ (NSData *)decryptPBEWithMD5AndDESData:(NSData *)inData password:(NSString *)password iterations:(int)iterations;
+ (NSData *)encodePBEWithMD5AndDESData:(NSData *)inData password:(NSString *)password direction:(int)direction iterations:(int)iterations;

@end

