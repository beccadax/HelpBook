//
//  GBSHelpBookPaletteViewController.h
//  HelpBook
//
//  Created by Brent Royal-Gordon on 8/9/13.
//  Copyright (c) 2013 Groundbreaking Software. All rights reserved.
//

#import <VPPlugin/VPPlugin.h>
#import "GBSDynamicSubclass.h"

@dyn_interface(VPUPaletteViewController) {
    id _nextResponder;
    NSString *_nibName;
    NSBundle *_nibBundle;
    id _representedObject;
    NSString *_title;
    IBOutlet NSView *view;
    NSArray *_topLevelObjects;
    NSPointerArray *_editors;
    id _autounbinder;
    NSString *_designNibBundleIdentifier;
    id _reserved[2];
    id _vprivate;
}

// NSResponder
- (void)presentError:(NSError *)error modalForWindow:(NSWindow *)window delegate:(id)delegate didPresentSelector:(SEL)didPresentSelector contextInfo:(void *)contextInfo;
- (BOOL)presentError:(NSError *)error;
- (NSError *)willPresentError:(NSError *)error;

// NSViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (NSView *)view;
- (void)loadView;
- (NSString *)nibName;
- (NSBundle *)nibBundle;
- (void)setView:(NSView *)view;

+ (NSString*)displayName;
- (NSImage*)pickerImage;

// VPUPaletteViewController
- (id<VPPluginDocument>)currentDocument;
- (id<VPPluginWindowController>)currentWindowController;
- (id<VPData>)currentItem;

- (void)documentDidChange;
- (void)itemDidChange;

- (float)minimumWidth;

@end

@interface GBSHelpBookPaletteViewController : dyn_superclass(VPUPaletteViewController)

@property (assign) BOOL hasDocument;

@property (assign) BOOL canExport;
- (IBAction)export:(id)sender;

@property (strong) NSString * exportFileString;
- (IBAction)chooseOutputFile:(id)sender;

@end
