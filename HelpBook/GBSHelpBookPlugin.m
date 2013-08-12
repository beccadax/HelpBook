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

NSString * const GBSHelpBookPluginWillIncreaseBundleVersionAutomaticallyNotification = @"GBSHelpBookPluginWillIncreaseBundleVersionAutomatically";
NSString * const GBSHelpBookPluginDidIncreaseBundleVersionAutomaticallyNotification = @"GBSHelpBookPluginDidIncreaseBundleVersionAutomatically";

static NSString * const GBSHelpBookOutputURLKey = @"GBSHelpBook.outputURL";
static NSString * const GBSHelpBookBundleNameKey = @"GBSHelpBook.bundleName";
static NSString * const GBSHelpBookBundleIdentifierKey = @"GBSHelpBook.bundleIdentifier";
static NSString * const GBSHelpBookHelpBookTitleKey = @"GBSHelpBook.helpBookTitle";
static NSString * const GBSHelpBookLocaleNameKey = @"GBSHelpBook.localeName";
static NSString * const GBSHelpBookBundleVersionKey = @"GBSHelpBook.bundleVersion";
static NSString * const GBSHelpBookIncreasesBundleVersionManuallyKey = @"GBSHelpBook.increasesBundleVersionManually";

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
    writer.bundleVersion = [self bundleVersionForDocument:document] ?: @"0.00.1";
    
    BOOL ok = [writer writeToURL:URL error:error];
    
    if(ok && ![self increasesBundleVersionManuallyForDocument:document]) {
        [NSNotificationCenter.defaultCenter postNotificationName:GBSHelpBookPluginWillIncreaseBundleVersionAutomaticallyNotification object:document];
        NSMutableString * version = [writer.bundleVersion mutableCopy];
        BOOL done = NO;
        
        // We loop backwards through the string, looking for a digit we can increment.
        for(NSInteger i = version.length - 1; !done && i >= 0; i--) {
            unichar ch = [version characterAtIndex:i];
            if(ch >= '0' && ch <= '8') {
                // This digit can be incremented without carrying.
                ch += 1;
                [version replaceCharactersInRange:NSMakeRange(i, 1) withString:[NSString stringWithCharacters:(const unichar []){ ch } length:1]];
                done = YES;
            }
            else if(ch == '9') {
                // This digit needs to change, but we'll have a 1 to carry. We'll zero this digit and keep looking.
                [version replaceCharactersInRange:NSMakeRange(i, 1) withString:@"0"];
            }
            else {
                // This is something else, probably a decimal point. Ignore it.
            }
        }
        
        if(!done) {
            // We didn't find a usable digit before we ran out of string, so let's add one.
            [version insertString:@"1" atIndex:0];
        }
        
        [self setBundleVersion:version.copy forDocument:document];
        [NSNotificationCenter.defaultCenter postNotificationName:GBSHelpBookPluginDidIncreaseBundleVersionAutomaticallyNotification object:document];
    }
    
    return ok;
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

+ (NSString*)bundleVersionForDocument:(id<VPPluginDocument>)doc {
    return [doc extraObjectForKey:GBSHelpBookBundleVersionKey];
}

+ (void)setBundleVersion:(NSString *)localeName forDocument:(id<VPPluginDocument>)doc {
    [doc setExtraObject:localeName forKey:GBSHelpBookBundleVersionKey];
}

+ (BOOL)increasesBundleVersionManuallyForDocument:(id<VPPluginDocument>)doc {
    return [[doc extraObjectForKey:GBSHelpBookIncreasesBundleVersionManuallyKey] boolValue];
}

+ (void)setIncreasesBundleVersionManually:(BOOL)increasesManually forDocument:(id<VPPluginDocument>)doc {
    [doc setExtraObject:@(increasesManually) forKey:GBSHelpBookIncreasesBundleVersionManuallyKey];
}

@end
