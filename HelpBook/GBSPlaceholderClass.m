//
//  GBSPlaceholderClass.h
//  HelpBook
//
//  Created by Brent Royal-Gordon on 8/9/13.
//  Copyright (c) 2013 Groundbreaking Software. All rights reserved.
//

#import "GBSPlaceholderClass.h"
#import <objc/runtime.h>

@interface NSObject (PlaceholderClassesHaveThese)

// Even for subclasses, these still return info for the @placeholder_implementation'd class.
// This means that if [self gbs_rootPlaceholderClass] == self, we're looking at the root class,
// otherwise we're looking at a subclass.
- (Class)gbs_rootPlaceholderClass;

// Returns the matching runtime class, or nil if it doesn't exist.
- (Class)gbs_rootRuntimeClass;

@end

static void GBSCopyFromPlaceholderClassToRuntimeClass(Class placeholderClass, Class runtimeClass);

Class GBSRuntimeClassForPlaceholderClass(Class placeholderClass) {
    if(![placeholderClass respondsToSelector:@selector(gbs_rootPlaceholderClass)]) {
        // WTF? This is already a runtime class.
        return placeholderClass;
    }
    
    if([placeholderClass gbs_rootPlaceholderClass] == placeholderClass) {
        // This placeholder class directly represents a class that already exists, so let's just return that.
        return [placeholderClass gbs_rootRuntimeClass];
    }
    
    // N.B. If I cared about thread safety, I'd put a lock or something here.
    
    // If we reach here, we're dealing with a subclass of a placeholder class. 
    // We want to find (or create) a matching subclass of that runtime class.
    NSString * runtimeClassName = [NSStringFromClass(placeholderClass) stringByAppendingString:@"_GBSRuntimeClass"];
    Class runtimeClass = NSClassFromString(runtimeClassName);
    if(runtimeClass) {
        // We've already created it. Return the already-created class.
        return runtimeClass;
    }
    
    // Gotta create the class.
    Class superclass = GBSRuntimeClassForPlaceholderClass([placeholderClass superclass]);
    if(!superclass) {
        // The superclass doesn't exist, so let's not try to create a subclass.
        return nil;
    }
    size_t extraBytes = class_getInstanceSize(placeholderClass) - class_getInstanceSize([placeholderClass superclass]);
    runtimeClass = objc_allocateClassPair(superclass, runtimeClassName.UTF8String, extraBytes);
    
    // Copy everything over from the placeholder class to the runtime class (and their metaclasses too).
    GBSCopyFromPlaceholderClassToRuntimeClass(placeholderClass, runtimeClass);
    GBSCopyFromPlaceholderClassToRuntimeClass(object_getClass(placeholderClass), object_getClass(runtimeClass));
    
    // XXX This does not adjust ivar offsets for fragile base class handling, because I don't know how that's done.
    // I suspect class_setIvarLayout() is involved, but I don't really know.
    // Send help!
    
    // Okay, freeze the runtime class.
    objc_registerClassPair(runtimeClass);
    
    return runtimeClass;
}

// This has to be called separately for the classes and metaclasses.
static void GBSCopyFromPlaceholderClassToRuntimeClass(Class placeholderClass, Class runtimeClass) {
    unsigned int count;
    
    // Copy instance variables.
    Ivar * ivars = class_copyIvarList(placeholderClass, &count);
    for(unsigned int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        
        NSUInteger size, alignment;
        NSGetSizeAndAlignment(ivar_getTypeEncoding(ivar), &size, &alignment);
        
        class_addIvar(runtimeClass, ivar_getName(ivar), size, alignment, ivar_getTypeEncoding(ivar));
    }
    free(ivars);
    
    // Copy properties.
    objc_property_t * properties = class_copyPropertyList(placeholderClass, &count);
    for(unsigned int i = 0; i < count; i++) {
        objc_property_t prop = properties[i];
        
        unsigned int attrCount;
        objc_property_attribute_t * attrs = property_copyAttributeList(prop, &attrCount);
        
        class_addProperty(runtimeClass, property_getName(prop), attrs, attrCount);
        
        free(attrs);
    }
    free(properties);
    
    // Copy protocols.
    Protocol *__unsafe_unretained* protocols = class_copyProtocolList(placeholderClass, &count);
    for(unsigned int i = 0; i < count; i++) {
        Protocol * proto = protocols[i];
        class_addProtocol(runtimeClass, proto);
    }
    free(protocols);
    
    // Copy methods.
    Method * methods = class_copyMethodList(placeholderClass, &count);
    for(unsigned int i = 0; i < count; i++) {
        Method method = methods[i];
        class_addMethod(runtimeClass, method_getName(method), method_getImplementation(method), method_getTypeEncoding(method));
    }
    free(protocols);
    
    // I hope that's everything.
}
