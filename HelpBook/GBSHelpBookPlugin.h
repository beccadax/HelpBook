//
//  GBSHelpBookPlugin.h
//  HelpBook
//
//  Created by Brent Royal-Gordon on 8/9/13.
//  Copyright (c) 2013 Groundbreaking Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <VPPlugin/VPPlugin.h>

@interface GBSHelpBookPlugin: VPPlugin

+ (BOOL)getOutputURL:(NSURL**)outputURL forDocument:(id<VPPluginDocument>)doc error:(NSError**)error;
+ (BOOL)setOutputURL:(NSURL*)outputURL forDocument:(id <VPPluginDocument>)doc error:(NSError**)error;

@end
