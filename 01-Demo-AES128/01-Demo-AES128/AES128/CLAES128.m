//
//  CLAES128.m
//  01-Demo-AES128
//
//  Created by chenlong on 2022/1/8.
//

#import "CLAES128.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation CLAES128

#pragma mark - Public methods

+ (NSString *)cl_encrypt:(NSString *)text key:(NSString *)key {
    
    key = [self stringFromHexString:key];
    
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    const void *bytesOfData = data.bytes;
    NSUInteger lengthOfData = data.length;
    
    size_t bufferSize = lengthOfData + kCCBlockSizeAES128;
    unsigned char *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode | kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          bytesOfData,
                                          lengthOfData,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return [resultData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    
    free(buffer);
    
    return @"";
}

+ (NSString *)cl_decrypt:(NSString *)text key:(NSString *)key {
    
    key = [self stringFromHexString:key];
    
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:text options:NSDataBase64DecodingIgnoreUnknownCharacters];
    const void *bytesOfData = data.bytes;
    NSUInteger lengthOfData = data.length;
     
    size_t bufferSize = lengthOfData + kCCBlockSizeAES128;
    unsigned char *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode | kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          bytesOfData,
                                          lengthOfData,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    
    free(buffer);
    
    return @"";
}

#pragma mark - Private methods

+ (NSString *)stringFromHexString:(NSString *)hexString {

    NSMutableString *mString = [[NSMutableString alloc] init];
    int i = 0;
    do {
        NSString *hexCharString = [hexString substringWithRange:NSMakeRange(i, 2)];
        int value = 0;
        sscanf([hexCharString cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
        // If hex value is "00", it means that the ASCII value is null as shown in the standard ASCII characters table. See
        // https://www.ibm.com/docs/en/xl-fortran-aix/16.1.0?topic=appendix-ascii-ebcdic-character-sets. For example, a
        // hex string like 395ef0005f29586a5bc5f4a0d6c55591 contains hex value "00". In this case, the hexCharString is equal
        // to "00" and the value is 0. So we have to fix this code by appending a string containing a single null.
        // Note: don't use `[mString appendString:@"\0"]` directly that is not going to work as expected!
        if (value == 0) {
            [mString appendFormat:@"\0", (char)value];
        } else {
            [mString appendFormat:@"%c", (char)value];
        }
        i += 2;
    } while (i < hexString.length);

    return mString;
}

@end
