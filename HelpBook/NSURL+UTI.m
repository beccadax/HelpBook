//
//  NSURL+UTI.m
//  Typesetter
//
//  Created by Brent Royal-Gordon on 12/25/11.
//  Copyright (c) 2011 Architechies. All rights reserved.
//

#import "NSURL+UTI.h"

BOOL NPKPathExtensionConformsToType(NSString * extension, NSString * type) {
    return NPKPathExtensionConformsToUTType(extension, (__bridge CFStringRef)type);
}

BOOL NPKPathExtensionConformsToUTType(NSString * extension, CFStringRef typeRef) {
    CFStringRef thisType = NPKUTTypeForPathExtension(extension);
    return UTTypeConformsTo(thisType, typeRef);
}

NSString * NPKPathExtensionForType(NSString * type) {
    return NPKPathExtensionForUTType((__bridge CFStringRef)type);
}

NSString * NPKPathExtensionForUTType(CFStringRef typeRef) {
    return (__bridge_transfer NSString*)UTTypeCopyPreferredTagWithClass(typeRef, kUTTagClassFilenameExtension);
}

NSArray * NPKPathExtensionsForType(NSString * type) {
    return NPKPathExtensionsForUTType((__bridge CFStringRef)type);
}

NSArray * NPKPathExtensionsForUTType(CFStringRef typeRef) {
    NSDictionary * typeDef = (__bridge_transfer NSDictionary*)UTTypeCopyDeclaration(typeRef);
    return typeDef[(__bridge NSString*)kUTTypeTagSpecificationKey][(__bridge NSString*)kUTTagClassFilenameExtension];
}

NSString * NPKTypeForPathExtension(NSString * extension) {
    if([extension isEqual:@"css"]) {
        return @"org.w3.cascading-style-sheet";
    }
    
    return (__bridge_transfer NSString*)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
}

CFStringRef NPKUTTypeForPathExtension(NSString * extension) {
    return (__bridge CFStringRef)NPKTypeForPathExtension(extension);
}

NSString * NPKMIMETypeForType(NSString * type) {
    return NPKMIMETypeForUTType((__bridge CFStringRef)type);
}

NSString * NPKMIMETypeForUTType(CFStringRef typeRef) {
    return (__bridge_transfer NSString*)UTTypeCopyPreferredTagWithClass(typeRef, kUTTagClassMIMEType);
}

NSString * NPKTypeForMIMEType(NSString * mimeType) {
    return (__bridge_transfer NSString*)UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)mimeType, NULL);
}

CFStringRef NPKUTTypeForMIMEType(NSString * mimeType) {
    return (__bridge CFStringRef)NPKTypeForMIMEType(mimeType);
}

@implementation NSURL (UTI)

- (NSString *)type {
    return NPKTypeForPathExtension(self.pathExtension);
}

- (CFStringRef)UTType {
    return NPKUTTypeForPathExtension(self.pathExtension);
}

- (NSString *)MIMEType {
    return NPKMIMETypeForUTType(self.UTType);
}

- (BOOL)conformsToType:(NSString*)type {
    return NPKPathExtensionConformsToType(self.pathExtension, type);
}

- (BOOL)conformsToUTType:(CFStringRef)typeRef {
    return NPKPathExtensionConformsToUTType(self.pathExtension, typeRef);
}

@end

@implementation NSFileWrapper (UTI)

- (NSString *)type {
    return NPKTypeForPathExtension((self.filename ?: self.preferredFilename).pathExtension);
}

- (CFStringRef)UTType {
    return NPKUTTypeForPathExtension((self.filename ?: self.preferredFilename).pathExtension);
}

- (NSString *)MIMEType {
    return NPKMIMETypeForUTType(self.UTType);
}

- (BOOL)conformsToType:(NSString*)type {
    return NPKPathExtensionConformsToType((self.filename ?: self.preferredFilename).pathExtension, type);
}

- (BOOL)conformsToUTType:(CFStringRef)typeRef {
    return NPKPathExtensionConformsToUTType((self.filename ?: self.preferredFilename).pathExtension, typeRef);
}

@end

@implementation NSString (UTI)

- (NSString*)typeForPathExtension {
    return (__bridge NSString*)self.UTTypeForPathExtension;
}

- (CFStringRef)UTTypeForPathExtension {
    return NPKUTTypeForPathExtension(self.pathExtension);
}

- (NSString*)MIMETypeForPathExtension {
    return NPKMIMETypeForUTType(NPKUTTypeForPathExtension(self.pathExtension));
}

- (BOOL)pathExtensionConformsToUTType:(CFStringRef)typeRef {
    return NPKPathExtensionConformsToUTType(self.pathExtension, typeRef);
}

- (BOOL)pathExtensionConformsToType:(NSString*)type {
    return NPKPathExtensionConformsToType(self.pathExtension, type);
}

- (NSString*)stringByAppendingPathExtensionForType:(NSString *)type {
    if(!NPKPathExtensionForType(type)) {
        return self;
    }
    
    return [self stringByAppendingPathExtension:NPKPathExtensionForType(type)];
}

- (NSString*)stringByAppendingPathExtensionForUTType:(CFStringRef)typeRef {
    if(!NPKPathExtensionForUTType(typeRef)) {
        return self;
    }
    
    return [self stringByAppendingPathExtension:NPKPathExtensionForUTType(typeRef)];
}

@end
