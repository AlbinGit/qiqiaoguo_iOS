//
//  NSString+BLUAddition.m
//  Blue
//
//  Created by Bowen on 26/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "NSString+BLUAddition.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (BLUEAddition)

- (NSString *)MD5String {
    NSString *inPutText = [NSString stringWithString:self];
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

- (NSNumber *)stringToNSNumber {
    NSNumberFormatter* tmpFormatter = [[NSNumberFormatter alloc] init];
    [tmpFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber* theNumber = [tmpFormatter numberFromString:self];
    return theNumber;
}

- (BOOL)isEmpty {
    if ([self length] <= 0 || self == (id)[NSNull null] || self == nil) {
        return YES;
    }
    return NO;
}

- (NSString *)sha256 {
    uint8_t digest [CC_SHA256_DIGEST_LENGTH];
    NSData *src = [self dataUsingEncoding:NSUTF8StringEncoding];
    CC_SHA256([src bytes], (CC_LONG)[src length], digest);
    NSMutableString *resultString = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for (int i= 0; i<CC_SHA256_DIGEST_LENGTH; i++) {
        
        [resultString appendFormat:@"%02x",digest[i]];
    }
    return  resultString;
}

+ (NSString *)lorumIpsum {
    static NSString *lorumIpsum = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lorumIpsum = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent non quam ac massa viverra semper. Maecenas mattis justo ac augue volutpat congue. Maecenas laoreet, nulla eu faucibus gravida, felis orci dictum risus, sed sodales sem eros eget risus. Morbi imperdiet sed diam et sodales. Vestibulum ut est id mauris ultrices gravida. Nulla malesuada metus ut erat malesuada, vitae ornare neque semper. Aenean a commodo justo, vel placerat odio. Curabitur vitae consequat tortor. Aenean eu magna ante. Integer tristique elit ac augue laoreet, eget pulvinar lacus dictum. Cras eleifend lacus eget pharetra elementum. Etiam fermentum eu felis eu tristique. Integer eu purus vitae turpis blandit consectetur. Nulla facilisi. Praesent bibendum massa eu metus pulvinar, quis tristique nunc commodo. Ut varius aliquam elit, a tincidunt elit aliquam non. Nunc ac leo purus. Proin condimentum placerat ligula, at tristique neque scelerisque ut. Suspendisse ut congue enim. Integer id sem nisl. Nam dignissim, lectus et dictum sollicitudin, libero augue ullamcorper justo, nec consectetur dolor arcu sed justo. Proin rutrum pharetra lectus, vel gravida ante venenatis sed. Mauris lacinia urna vehicula felis aliquet venenatis. Suspendisse non pretium sapien. Proin id dolor ultricies, dictum augue non, euismod ante. Vivamus et luctus augue, a luctus mi. Maecenas sit amet felis in magna vestibulum viverra vel ut est. Suspendisse potenti. Morbi nec odio pretium lacus laoreet volutpat sit amet at ipsum. Etiam pretium purus vitae tortor auctor, quis cursus metus vehicula. Integer ultricies facilisis arcu, non congue orci pharetra quis. Vivamus pulvinar ligula neque, et vehicula ipsum euismod quis. Aliquam ut mi elementum, malesuada velit ac, placerat leo. Donec vel neque condimentum, congue justo a, posuere tortor. Etiam mollis id ligula nec dapibus. Etiam tincidunt, nisi non cursus adipiscing, enim neque tincidunt leo, vel tincidunt quam leo non ligula. Proin a felis tellus. Pellentesque quis purus est. Nam consectetur erat quam, non ultricies tortor venenatis ac. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Pellentesque at laoreet arcu. Mauris odio lorem, luctus facilisis ligula eget, malesuada pellentesque nulla.";
    });
    return lorumIpsum;
}

+ (NSString *)randomLorumIpsumWithLength:(NSInteger)length {
    NSString *randomLorumIpsum = @"";
    if (length > 0) {
        NSString *lorumIpsum = [NSString lorumIpsum];
        NSArray *lorumIpsumArray = [lorumIpsum componentsSeparatedByString:@" "];
        while (1) {
            int randomIdx = arc4random() % [lorumIpsumArray count];
            NSString *str = lorumIpsumArray[randomIdx];
            if (str.length + randomLorumIpsum.length + 1 >= length) {
                NSInteger lastLength = str.length - (str.length + randomLorumIpsum.length + 1 - length);
                lastLength = lastLength > 0 ? lastLength : 0;
                str = [str substringWithRange:NSMakeRange(0, lastLength)];
                if (randomLorumIpsum.length > 0) {
                    randomLorumIpsum = [NSString stringWithFormat:@"%@ %@", randomLorumIpsum, str];
                } else {
                    randomLorumIpsum = str;
                }
                break;
            } else {
                if (randomLorumIpsum.length > 0) {
                    randomLorumIpsum = [NSString stringWithFormat:@"%@ %@", randomLorumIpsum, str];
                } else {
                    randomLorumIpsum = str;
                }
            }
        }
    }
    return randomLorumIpsum;
}

+ (NSString *)randomLorumIpsum {
    
    NSString *lorumIpsum = [NSString lorumIpsum];
    
    // Split lorum ipsum words into an array
    //
    NSArray *lorumIpsumArray = [lorumIpsum componentsSeparatedByString:@" "];
    
    // Randomly choose words for variable length
    //
    int r = arc4random() % [lorumIpsumArray count];
//    int r = arc4random() % 100;
    NSArray *lorumIpsumRandom = [lorumIpsumArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, r)]];
    
    // Array to string. Adding '!!!' to end of string to ensure all text is visible.
    //
    return [NSString stringWithFormat:@"%@!!!", [lorumIpsumRandom componentsJoinedByString:@" "]];
}


+ (NSString *)appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

+ (NSString *)appBuild {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleVersion"];
}

+ (NSString *)build {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}

+ (NSString *)versionBuild {
    NSString * version = [self appVersion];
    NSString * build = [self build];
    
    NSString * versionBuild = [NSString stringWithFormat: @"v%@", version];
    
    if (![version isEqualToString: build]) {
        versionBuild = [NSString stringWithFormat: @"%@(%@)", versionBuild, build];
    }
    
    return versionBuild;
}@end
