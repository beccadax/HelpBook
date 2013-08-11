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

+ (NSString*)bundleNameForDocument:(id<VPPluginDocument>)doc;
+ (void)setBundleName:(NSString*)bundleName forDocument:(id <VPPluginDocument>)doc;

+ (NSString*)bundleIdentifierForDocument:(id<VPPluginDocument>)doc;
+ (void)setBundleIdentifier:(NSString*)bundleIdentifier forDocument:(id <VPPluginDocument>)doc;

+ (NSString*)helpBookTitleForDocument:(id<VPPluginDocument>)doc;
+ (void)setHelpBookTitle:(NSString*)helpBookTitle forDocument:(id <VPPluginDocument>)doc;

+ (NSString*)localeNameForDocument:(id<VPPluginDocument>)doc;
+ (void)setLocaleName:(NSString*)localeName forDocument:(id <VPPluginDocument>)doc;

@end
