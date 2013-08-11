//
//  NSFileManager+URLForTemporaryItem.m
//  Typesetter
//
//  Created by Brent Royal-Gordon on 2/6/12.
//  Copyright (c) 2012 Architechies. All rights reserved.
//

#import "NSFileManager+URLForTemporaryItem.h"
#import "NSURL+UTI.h"

@implementation NSFileManager (URLForTemporaryItem)

- (NSURL*)URLForTemporaryItemOfType:(NSString*)itemType error:(NSError**)error {
    NSURL * cacheDir = [self URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:error];
    if(!cacheDir) {
        return nil;
    }
    
    NSURL * tempURL;
    
    do {
        NSString * name = [[NSProcessInfo processInfo].globallyUniqueString stringByAppendingPathExtensionForType:itemType];
        tempURL = [cacheDir URLByAppendingPathComponent:name];
    } while ([tempURL checkResourceIsReachableAndReturnError:NULL]);
    
//    if(UTTypeConformsTo((__bridge CFStringRef)itemType, kUTTypeFolder)) {
//        if(![self createDirectoryAtURL:tempURL withIntermediateDirectories:YES attributes:nil error:error]) {
//            return nil;
//        }
//    }
    
    return tempURL;

}

@end
