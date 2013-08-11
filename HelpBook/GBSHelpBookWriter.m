//
//  GBSHelpBookWriter.m
//  HelpBook
//
//  Created by Brent Royal-Gordon on 8/10/13.
//  Copyright (c) 2013 Groundbreaking Software. All rights reserved.
//

#import "GBSHelpBookWriter.h"
#import "NSFileManager+URLForTemporaryItem.h"

static NSString * const GBSHelpIndexName = @"Index.helpindex";

static NSString * const GBSVPWebExportControllerOutputKey = @"output";  // NSString
static NSString * const GBSVPWebExportControllerLinkedItemKeysKey = @"linkedItemKeys";  // NSArray

@protocol GBSVPWebExportController <NSObject>

- (NSDictionary*)renderItem:(id <VPData>)item options:(NSDictionary*)opts;

@end

@implementation GBSHelpBookWriter

- (id <GBSVPWebExportController>)webExportController {
    return [(id)self.document valueForKey:@"webExportController"];
}

- (BOOL)writeToURL:(NSURL *)URL error:(NSError *__autoreleasing *)error {
    NSFileWrapper * wrapper = [self fileWrapper:error];
    return [wrapper writeToURL:URL options:NSFileWrapperWritingAtomic originalContentsURL:nil error:error];
}

- (NSFileWrapper*)fileWrapper:(NSError**)error {
    NSFileWrapper * contentsWrapper = [self contentsFileWrapper:error];
    if(!contentsWrapper) {
        return nil;
    }
    return [[NSFileWrapper alloc] initDirectoryWithFileWrappers:@{ @"Contents": contentsWrapper }];
}

- (NSFileWrapper*)contentsFileWrapper:(NSError**)error {
    NSFileWrapper * infoPlistWrapper = [self infoPlistWrapper:error];
    NSFileWrapper * resourcesWrapper = [self resourcesWrapper:error];
    
    if(!infoPlistWrapper || !resourcesWrapper) {
        return nil;
    }
    
    return [[NSFileWrapper alloc] initDirectoryWithFileWrappers:@{ @"Info.plist": infoPlistWrapper, @"Resources": resourcesWrapper }];
}

- (NSFileWrapper*)infoPlistWrapper:(NSError**)error {
    NSDictionary * plist = [self infoPlist];
    NSData * data = [NSPropertyListSerialization dataWithPropertyList:plist format:NSPropertyListXMLFormat_v1_0 options:0 error:error];
    if(!data) {
        return nil;
    }
    
    return [[NSFileWrapper alloc] initRegularFileWithContents:data];
}

- (NSDictionary*)infoPlist {
    return @{
             @"CFBundleDevelopmentRegion": self.locale,
             @"CFBundleIdentifier": self.bundleIdentifier,
             @"CFBundleInfoDictionaryVersion": @6.0,
             @"CFBundleName": self.bundleName,
             @"CFBundlePackageType": @"BNDL",
             @"CFBundleShortVersionString": @"1",
             @"CFBundleSignature": @"hbwr",
             @"CFBundleVersion": @"1",
             @"HPDBookAccessPath": [[(id)self.document valueForKey:@"defaultPageName"] stringByAppendingPathExtension:@"html"],
//             @"HPDBookIconPath": ...,
             @"HPDBookIndexPath": GBSHelpIndexName,
             @"HPDBookTitle": self.helpBookTitle,
             @"HPDBookType": @3,
             };
}

- (NSFileWrapper*)resourcesWrapper:(NSError**)error {
    NSFileWrapper * wrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:@{}];
    
    // Perhaps someday we'll get a multi-language mechanism.
    NSFileWrapper * lprojWrapper = [self lprojWrapperForPageUUIDs:self.document.pageUUIDs error:error];
    if(!lprojWrapper) {
        return nil;
    }
    lprojWrapper.preferredFilename = [self.locale stringByAppendingPathExtension:@"lproj"];
    [wrapper addFileWrapper:lprojWrapper];
    
    return wrapper;
}

- (NSFileWrapper*)lprojWrapperForPageUUIDs:(NSArray*)uuids error:(NSError**)error {
    NSFileWrapper * wrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:@{}];
    
    for(NSString * uuid in uuids) {
        id <VPData> page = [self.document pageForUUID:uuid];
        NSDictionary * exportedPage = [self.webExportController renderItem:page options:@{}];
        NSMutableString * HTML = [exportedPage[GBSVPWebExportControllerOutputKey] mutableCopy];
        
        if([page.key isEqualToString:[(id)self.document valueForKey:@"defaultPageName"]]) {
            NSString * metaTags = [NSString stringWithFormat:@"<meta name=\"AppleTitle\" content=\"%@\"><meta name=\"AppleIcon\" content=\"appicon16.png\">", self.helpBookTitle];
            [HTML replaceOccurrencesOfString:@"</head>" withString:metaTags options:0 range:NSMakeRange(0, HTML.length)];
        }
        
        [wrapper addRegularFileWithContents:[HTML dataUsingEncoding:NSUTF8StringEncoding] preferredFilename:[page.key stringByAppendingPathExtension:@"html"]];
    }
    
    NSURL * temporaryURL = [[NSFileManager new] URLForTemporaryItemOfType:(id)kUTTypeFolder error:error];
    if(!temporaryURL) {
        return nil;
    }
    
    if(![wrapper writeToURL:temporaryURL options:0 originalContentsURL:nil error:error]) {
        return nil;
    }
    
    NSTask * task = [NSTask launchedTaskWithLaunchPath:@"/usr/bin/hiutil" arguments:@[ @"--create", temporaryURL.path, @"--file", [temporaryURL.path stringByAppendingPathComponent:GBSHelpIndexName] ]];
    [task waitUntilExit];
    
    if(task.terminationReason != NSTaskTerminationReasonExit || task.terminationStatus != 0) {
        if(error) {
            *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadCorruptFileError userInfo:@{ NSLocalizedDescriptionKey: NSLocalizedString(@"The help indexer exited with an error.", @""), NSLocalizedRecoverySuggestionErrorKey: [NSString stringWithFormat:(task.terminationStatus == NSTaskTerminationReasonExit ? NSLocalizedString(@"The process terminated with status %d.", @"") : NSLocalizedString(@"The process terminated with signal %d.", @"")), task.terminationStatus] }];
        }
        return nil;
    }
    
    return [[NSFileWrapper alloc] initWithURL:temporaryURL options:0 error:error];
}

@end
