//
//  GBSHelpBookPaletteViewController.m
//  HelpBook
//
//  Created by Brent Royal-Gordon on 8/9/13.
//  Copyright (c) 2013 Groundbreaking Software. All rights reserved.
//

#import "GBSHelpBookPaletteViewController.h"
#import "GBSHelpBookPlugin.h"

@dynamic_implementation(VPUPaletteViewController)

@interface GBSHelpBookPaletteViewController ()

@property id <VPPluginDocument> visibleDocument;

@end

@implementation GBSHelpBookPaletteViewController

+ (id)makeContentViewController {
    return [[self alloc] initWithNibName:@"GBSHelpBookPaletteViewController" bundle:[NSBundle bundleWithIdentifier:@"com.groundbreakingsoftware.voodoopad.HelpBook"]];
}

+ (NSString *)displayName {
    return NSLocalizedString(@"Help Book", @"");
}

- (NSString *)displayName {
    return NSLocalizedString(@"Help Book", @"");
}

- (id<VPPluginDocument>)currentDocument {
    id <VPPluginDocument>doc = [[NSDocumentController sharedDocumentController] currentDocument];
    
    if (!doc && [[[NSDocumentController sharedDocumentController] documents] count]) {
        // wtf, appkit is holding out on us.
        doc = [[[NSDocumentController sharedDocumentController] documents] objectAtIndex:0];
        
        // sanity check.
        if (![(id)doc respondsToSelector:@selector(orderedPageKeysByCreateDate)]) {
            doc = nil;
        }
    }
    
    return doc;
}

- (void)export:(id)sender {
    NSSavePanel * panel = [NSSavePanel savePanel];
    panel.allowedFileTypes = @[ @"help" ];
    
    NSURL * outputURL = [GBSHelpBookPlugin outputURLForDocument:self.currentDocument];
    if(outputURL) {
        panel.directoryURL = outputURL.URLByDeletingLastPathComponent;
        panel.nameFieldStringValue = outputURL.lastPathComponent;
    }
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if(!result) {
            return;
        }
        
        NSError * error;
        
        if([GBSHelpBookPlugin writeHelpBookFromDocument:self.currentDocument toURL:panel.URL error:&error]) {
            [GBSHelpBookPlugin setOutputURL:panel.URL forDocument:self.currentDocument];
        }
        else {
            [self presentError:error];
        }
    }];
}

- (void)documentDidChange {
    self.visibleDocument = self.currentDocument;
}

+ (NSSet *)keyPathsForValuesAffectingHasDocument {
    return [NSSet setWithObject:@"visibleDocument"];
}

- (BOOL)hasDocument {
    return self.visibleDocument != nil;
}

+ (NSSet *)keyPathsForValuesAffectingBundleName {
    return [NSSet setWithObject:@"visibleDocument"];
}

- (NSString *)bundleName {
    return [GBSHelpBookPlugin bundleNameForDocument:self.visibleDocument];
}

- (void)setBundleName:(NSString *)bundleName {
    [GBSHelpBookPlugin setBundleName:bundleName forDocument:self.visibleDocument];
}

+ (NSSet *)keyPathsForValuesAffectingBundleIdentifier {
    return [NSSet setWithObject:@"visibleDocument"];
}

- (NSString *)bundleIdentifier {
    return [GBSHelpBookPlugin bundleIdentifierForDocument:self.visibleDocument];
}

- (void)setBundleIdentifier:(NSString *)bundleIdentifier {
    [GBSHelpBookPlugin setBundleIdentifier:bundleIdentifier forDocument:self.visibleDocument];
}

+ (NSSet *)keyPathsForValuesAffectingHelpBookTitle {
    return [NSSet setWithObject:@"visibleDocument"];
}

- (NSString *)helpBookTitle {
    return [GBSHelpBookPlugin helpBookTitleForDocument:self.visibleDocument];
}

- (void)setHelpBookTitle:(NSString *)helpBookTitle {
    [GBSHelpBookPlugin setHelpBookTitle:helpBookTitle forDocument:self.visibleDocument];
}

+ (NSSet *)keyPathsForValuesAffectingLocaleName {
    return [NSSet setWithObject:@"visibleDocument"];
}

- (NSString *)localeName {
    return [GBSHelpBookPlugin localeNameForDocument:self.visibleDocument];
}

- (void)setLocaleName:(NSString *)localeName {
    [GBSHelpBookPlugin setLocaleName:localeName forDocument:self.visibleDocument];
}

+ (NSSet *)keyPathsForValuesAffectingCanExport {
    return [NSSet setWithArray:@[ @"bundleName", @"bundleIdentifier", @"localeName" ]];
}

- (BOOL)canExport {
    return self.bundleName && self.bundleIdentifier && self.localeName;
}

@end
