//
//  GBSHelpBookPlugin.m
//  HelpBook
//
//  Created by Brent Royal-Gordon on 8/9/13.
//  Copyright (c) 2013 Groundbreaking Software. All rights reserved.
//

#import "GBSHelpBookPlugin.h"
#import "GBSHelpBookPaletteViewController.h"

static NSString * const GBSHelpBookOutputURLKey = @"GBSHelpBook.outputURLBookmark";

@interface NSObject (VPPluginManagerCurrentlyPrivate)

- (void)registerPaletteViewController:(Class)pvc;

@end

@implementation GBSHelpBookPlugin

- (void)didRegister {
    [(id)self.pluginManager registerPaletteViewController:GBSHelpBookPaletteViewController.class];
}

+ (BOOL)securityScoped {
    return YES;
}

+ (BOOL)getOutputURL:(NSURL**)outputURL forDocument:(id<VPPluginDocument>)doc error:(NSError**)error {
    NSData * bookmark = [doc extraObjectForKey:GBSHelpBookOutputURLKey];
    
    if(!bookmark) {
        *outputURL = nil;
        return YES;
    }
    
    BOOL dataIsStale = NO;
    
    *outputURL = [NSURL URLByResolvingBookmarkData:bookmark options:(self.securityScoped ? NSURLBookmarkResolutionWithSecurityScope : 0) relativeToURL:[(NSDocument*)doc fileURL] bookmarkDataIsStale:&dataIsStale error:error];
    return *outputURL != nil;
}

+ (BOOL)setOutputURL:(NSURL *)outputURL forDocument:(id<VPPluginDocument>)doc error:(NSError *__autoreleasing *)error {
    BOOL createdTemporary = NO;
    
    if(![outputURL checkResourceIsReachableAndReturnError:NULL]) {
        [[[NSFileWrapper alloc] initDirectoryWithFileWrappers:@{}] writeToURL:outputURL options:0 originalContentsURL:0 error:NULL];
        createdTemporary = YES;
    }
    
    NSData * bookmark = [outputURL bookmarkDataWithOptions:(self.securityScoped ? NSURLBookmarkCreationWithSecurityScope : 0) includingResourceValuesForKeys:nil relativeToURL:[(NSDocument*)doc fileURL] error:error];
    
    if(createdTemporary) {
        [[NSFileManager new] removeItemAtURL:outputURL error:NULL];
    }
    
    if(!bookmark) {
        return NO;
    }
    
    [doc setExtraObject:bookmark forKey:GBSHelpBookOutputURLKey];
    return YES;
}

@end
