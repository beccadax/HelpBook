//
//  GBSHelpBookPaletteViewController.h
//  HelpBook
//
//  Created by Brent Royal-Gordon on 8/9/13.
//  Copyright (c) 2013 Groundbreaking Software. All rights reserved.
//

#import <VPPlugin/VPPlugin.h>
#import "GBSDynamicClass.h"

@interface dynamic_class(VPUPaletteViewController) : NSViewController {
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

@interface GBSHelpBookPaletteViewController : dynamic_class(VPUPaletteViewController)

@property (assign) BOOL hasDocument;

@property (assign) BOOL canExport;
- (IBAction)export:(id)sender;

@property (strong) NSString * exportFileString;
- (IBAction)chooseOutputFile:(id)sender;

@end
