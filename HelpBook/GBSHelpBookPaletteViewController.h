//
//  GBSHelpBookPaletteViewController.h
//  HelpBook
//
//  Created by Brent Royal-Gordon on 8/9/13.
//  Copyright (c) 2013 Groundbreaking Software. All rights reserved.
//

#import <VPPlugin/VPPlugin.h>
#import "GBSPlaceholderClass.h"

@interface placeholder_class(VPUPaletteViewController) : NSViewController {
    id _vprivate;
}

+ (NSString*)displayName;
- (NSImage*)pickerImage;

- (id<VPPluginDocument>)currentDocument;
- (id<VPPluginWindowController>)currentWindowController;
- (id<VPData>)currentItem;

- (void)documentDidChange;
- (void)itemDidChange;

- (float)minimumWidth;

@end

@interface GBSHelpBookPaletteViewController : placeholder_class(VPUPaletteViewController)

@property (readonly) BOOL hasDocument;

@property (copy) NSString * bundleIdentifier;
@property (copy) NSString * bundleName;
@property (copy) NSString * helpBookTitle;
@property (copy) NSString * localeName;

@property (readonly) BOOL canExport;
- (IBAction)export:(id)sender;

@end
