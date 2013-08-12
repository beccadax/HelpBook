//
//  GBSHelpBookWriter.h
//  HelpBook
//
//  Created by Brent Royal-Gordon on 8/10/13.
//  Copyright (c) 2013 Groundbreaking Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VPPlugin/VPPlugin.h>

@interface GBSHelpBookWriter : NSObject

@property id <VPPluginDocument> document;
@property NSString * helpBookTitle;
@property NSString * bundleName;
@property NSString * bundleIdentifier;
@property NSString * bundleVersion;
@property NSString * locale;

- (BOOL)writeToURL:(NSURL*)URL error:(NSError**)error;

@end
