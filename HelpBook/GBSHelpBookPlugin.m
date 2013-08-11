//
//  GBSHelpBookPlugin.m
//  HelpBook
//
//  Created by Brent Royal-Gordon on 8/9/13.
//  Copyright (c) 2013 Groundbreaking Software. All rights reserved.
//

#import "GBSHelpBookPlugin.h"
#import "GBSHelpBookPaletteViewController.h"

static NSString * const GBSHelpBookOutputURLKey = @"GBSHelpBook.outputURL";

@interface NSObject (VPPluginManagerCurrentlyPrivate)

- (void)registerPaletteViewController:(Class)pvc;

@end

@implementation GBSHelpBookPlugin

- (void)didRegister {
    [(id)self.pluginManager registerPaletteViewController:GBSHelpBookPaletteViewController.class];
}

+ (NSURL *)outputURLForDocument:(id<VPPluginDocument>)doc {
    return [NSURL URLWithString:[doc extraObjectForKey:GBSHelpBookOutputURLKey]];
}

+ (void)setOutputURL:(NSURL *)outputURL forDocument:(id<VPPluginDocument>)doc {
    [doc setExtraObject:[outputURL absoluteString] forKey:GBSHelpBookOutputURLKey];
}

@end
