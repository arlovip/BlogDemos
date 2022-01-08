//
//  CLAES128.h
//  01-Demo-AES128
//
//  Created by chenlong on 2022/1/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLAES128 : NSObject

+ (NSString *)cl_encrypt:(NSString *)text key:(NSString *)key;

+ (NSString *)cl_decrypt:(NSString *)text key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
