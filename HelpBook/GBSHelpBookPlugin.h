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

+ (NSURL*)outputURLForDocument:(id<VPPluginDocument>)doc;
+ (void)setOutputURL:(NSURL*)outputURL forDocument:(id <VPPluginDocument>)doc;

@end
