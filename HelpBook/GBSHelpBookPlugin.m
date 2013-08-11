//
//  GBSHelpBookPlugin.m
//  HelpBook
//
//  Created by Brent Royal-Gordon on 8/9/13.
//  Copyright (c) 2013 Groundbreaking Software. All rights reserved.
//

#import "GBSHelpBookPlugin.h"
#import "GBSHelpBookPaletteViewController.h"
#import "GBSHelpBookWriter.h"

static NSString * const GBSHelpBookOutputURLKey = @"GBSHelpBook.outputURL";
static NSString * const GBSHelpBookBundleNameKey = @"GBSHelpBook.bundleName";
static NSString * const GBSHelpBookBundleIdentifierKey = @"GBSHelpBook.bundleIdentifier";
static NSString * const GBSHelpBookHelpBookTitleKey = @"GBSHelpBook.helpBookTitle";
static NSString * const GBSHelpBookLocaleNameKey = @"GBSHelpBook.localeName";

@interface NSObject (VPPluginManagerCurrentlyPrivate)

- (void)registerPaletteViewController:(Class)pvc;

@end

@implementation GBSHelpBookPlugin

- (void)didRegister {
    [(id)self.pluginManager registerPaletteViewController:GBSHelpBookPaletteViewController.class];
}

+ (BOOL)writeHelpBookFromDocument:(id<VPPluginDocument>)document toURL:(NSURL *)URL error:(NSError *__autoreleasing *)error {
    GBSHelpBookWriter * writer = [GBSHelpBookWriter new];
    
    writer.document = document;
    
    writer.bundleIdentifier = [self bundleIdentifierForDocument:document];
    writer.bundleName = [self bundleNameForDocument:document];
    writer.helpBookTitle = [self helpBookTitleForDocument:document] ?: [NSString stringWithFormat:NSLocalizedString(@"%@ Help", @""), writer.bundleName];
    writer.locale = [self localeNameForDocument:document];
    
    return [writer writeToURL:URL error:error];
}

+ (NSURL *)outputURLForDocument:(id<VPPluginDocument>)doc {
    return [NSURL URLWithString:[doc extraObjectForKey:GBSHelpBookOutputURLKey]];
}

+ (void)setOutputURL:(NSURL *)outputURL forDocument:(id<VPPluginDocument>)doc {
    [doc setExtraObject:[outputURL absoluteString] forKey:GBSHelpBookOutputURLKey];
}

+ (NSString*)bundleNameForDocument:(id<VPPluginDocument>)doc {
    return [doc extraObjectForKey:GBSHelpBookBundleNameKey];
}

+ (void)setBundleName:(NSString*)bundleName forDocument:(id <VPPluginDocument>)doc {
    [doc setExtraObject:bundleName forKey:GBSHelpBookBundleNameKey];
}

+ (NSString*)bundleIdentifierForDocument:(id<VPPluginDocument>)doc {
    return [doc extraObjectForKey:GBSHelpBookBundleIdentifierKey];
}

+ (void)setBundleIdentifier:(NSString*)bundleIdentifier forDocument:(id <VPPluginDocument>)doc {
    [doc setExtraObject:bundleIdentifier forKey:GBSHelpBookBundleIdentifierKey];
}

+ (NSString*)helpBookTitleForDocument:(id<VPPluginDocument>)doc {
    return [doc extraObjectForKey:GBSHelpBookHelpBookTitleKey];
}

+ (void)setHelpBookTitle:(NSString*)helpBookTitle forDocument:(id <VPPluginDocument>)doc {
    [doc setExtraObject:helpBookTitle forKey:GBSHelpBookHelpBookTitleKey];
}

+ (NSString*)localeNameForDocument:(id<VPPluginDocument>)doc {
    return [doc extraObjectForKey:GBSHelpBookLocaleNameKey];
}

+ (void)setLocaleName:(NSString*)localeName forDocument:(id <VPPluginDocument>)doc {
    [doc setExtraObject:localeName forKey:GBSHelpBookLocaleNameKey];
}

@end
