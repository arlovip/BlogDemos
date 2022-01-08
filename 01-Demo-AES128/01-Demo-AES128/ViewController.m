//
//  ViewController.m
//  01-Demo-AES128
//
//  Created by chenlong on 2022/1/8.
//

#import "ViewController.h"
#import "CLAES128.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self aes128];
}

- (void)aes128 {
    
    NSString *text = @"hello world";
    NSString *key = @"a21be01f00eac3f7d184d86f40e19d6a";
    
    NSString *encryptedResult = [CLAES128 cl_encrypt:text key:key];
    NSLog(@"Encrypted result: %@", encryptedResult);
    
    NSString *decryptedResult = [CLAES128 cl_decrypt:encryptedResult key:key];
    NSLog(@"Decrypted result: %@", decryptedResult);
}

@end
