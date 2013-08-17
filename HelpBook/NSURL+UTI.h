//
//  NSURL+UTI.h
//  Typesetter
//
//  Created by Brent Royal-Gordon on 12/25/11.
//  Copyright (c) 2011 Architechies. All rights reserved.
//

BOOL NPKPathExtensionConformsToType(NSString * extension, NSString * type);
BOOL NPKPathExtensionConformsToUTType(NSString * extension, CFStringRef typeRef);

NSString * NPKPathExtensionForType(NSString * type);
NSString * NPKPathExtensionForUTType(CFStringRef typeRef);
NSArray * NPKPathExtensionsForType(NSString * type);
NSArray * NPKPathExtensionsForUTType(CFStringRef typeRef);

NSString * NPKMIMETypeForType(NSString * type);
NSString * NPKMIMETypeForUTType(CFStringRef typeRef);

NSString * NPKTypeForPathExtension(NSString * extension);
CFStringRef NPKUTTypeForPathExtension(NSString * extension);

NSString * NPKTypeForMIMEType(NSString * mimeType);
CFStringRef NPKUTTypeForMIMEType(NSString * mimeType);

@interface NSURL (UTI)

- (NSString*)type;
- (CFStringRef)UTType;

- (NSString*)MIMEType;

- (BOOL)conformsToUTType:(CFStringRef)typeRef;
- (BOOL)conformsToType:(NSString*)type;

@end

@interface NSFileWrapper (UTI)

- (NSString*)type;
- (CFStringRef)UTType;

- (NSString*)MIMEType;

- (BOOL)conformsToUTType:(CFStringRef)typeRef;
- (BOOL)conformsToType:(NSString*)type;

@end

@interface NSString (UTI)

- (NSString*)typeForPathExtension;
- (CFStringRef)UTTypeForPathExtension;

- (NSString*)MIMETypeForPathExtension;

- (BOOL)pathExtensionConformsToUTType:(CFStringRef)typeRef;
- (BOOL)pathExtensionConformsToType:(NSString*)type;

- (NSString*)stringByAppendingPathExtensionForType:(NSString *)type;
- (NSString*)stringByAppendingPathExtensionForUTType:(CFStringRef)typeRef;

@end