//
//  PBEwithMD5andDes.m
//  com.altura
//
//  Created by adrian aguilar on 11/7/18.
//  Copyright © 2018 Altura S.A. All rights reserved.
//

#import "PBEwithMD5andDes.h"
#include <openssl/md5.h>
#include <openssl/sha.h>
#include <openssl/x509.h>
#include <openssl/err.h>
#include <openssl/evp.h>

@implementation PBEwithMD5andDes


/*+ (NSData *)encryptPBEWithMD5AndDESData:(NSData *)inData password:(NSString *)password  iterations:(int)iterations{
    return [self encodePBEWithMD5AndDESData:inData password:password direction:1 iterations:iterations];
}

+ (NSData *)decryptPBEWithMD5AndDESData:(NSData *)inData password:(NSString *)password  iterations:(int)iterations {
    return [self encodePBEWithMD5AndDESData:inData password:password direction:0 iterations:iterations];
}

+ (NSData *)encodePBEWithMD5AndDESData:(NSData *)inData password:(NSString *)password direction:(int)direction iterations:(int)iterations
{
    
    // Change salt and number of iterations for your project !!!
    
    static const char gSalt[] =
    {
        
        (unsigned char) 'A', (unsigned char) 'l', (unsigned char) 'T', (unsigned char) 'u',
        (unsigned char) 'R', (unsigned char) 'a', (unsigned char) 'S', (unsigned char) 'a',
        //        (unsigned char) 0xA9, (unsigned char) 0x9B, (unsigned char) 0xC8, (unsigned char) 0x32,
        //        (unsigned char) 0x56, (unsigned char) 0x35, (unsigned char) 0xE3, (unsigned char) 0x03,
        (unsigned char) 0x00
    };
    
    unsigned char *salt = (unsigned char *)gSalt;
    int saltLen = strlen(gSalt);
    
    
    EVP_CIPHER_CTX cipherCtx;
    
    
    unsigned char *mResults;         // allocated storage of results
    int mResultsLen = 0;
    
    const char *cPassword = [password UTF8String];
    
    unsigned char *mData = (unsigned char *)[inData bytes];
    int mDataLen = [inData length];
    
    SSLeay_add_all_algorithms();
    X509_ALGOR *algorithm = PKCS5_pbe_set(NID_pbeWithMD5AndDES_CBC, iterations, salt, saltLen);
    
    
    
    
    memset(&cipherCtx, 0, sizeof(cipherCtx));
    
    if (algorithm != NULL)
    {
        EVP_CIPHER_CTX_init(&(cipherCtx));
        
        if (EVP_PBE_CipherInit(algorithm->algorithm, cPassword, strlen(cPassword),
                               algorithm->parameter, &(cipherCtx), direction))
        {
            
            EVP_CIPHER_CTX_set_padding(&cipherCtx, 1);
            
            int blockSize = EVP_CIPHER_CTX_block_size(&cipherCtx);
            int allocLen = mDataLen + blockSize + 1; // plus 1 for null terminator on decrypt
            mResults = (unsigned char *)OPENSSL_malloc(allocLen);
            
            
            unsigned char *in_bytes = mData;
            int inLen = mDataLen;
            unsigned char *out_bytes = mResults;
            int outLen = 0;
            
            
            
            int outLenPart1 = 0;
            if (EVP_CipherUpdate(&(cipherCtx), out_bytes, &outLenPart1, in_bytes, inLen))
            {
                out_bytes += outLenPart1;
                int outLenPart2 = 0;
                if (EVP_CipherFinal(&(cipherCtx), out_bytes, &outLenPart2))
                {
                    outLen += outLenPart1 + outLenPart2;
                    mResults[outLen] = 0;
                    mResultsLen = outLen;
                }
            } else {
                unsigned long err = ERR_get_error();
                ERR_load_crypto_strings();
                ERR_load_ERR_strings();
                char errbuff[256];
                errbuff[0] = 0;
                ERR_error_string_n(err, errbuff, sizeof(errbuff));
                NSLog(@"OpenSLL ERROR:\n\tlib:%s\n\tfunction:%s\n\treason:%s\n",
                      ERR_lib_error_string(err),
                      ERR_func_error_string(err),
                      ERR_reason_error_string(err));
                ERR_free_strings();
            }
            
            
            NSData *encryptedData = [NSData dataWithBytes:mResults length:mResultsLen];
            
            
            return encryptedData;
        }
    }
    return nil;
    
}*/
@end

