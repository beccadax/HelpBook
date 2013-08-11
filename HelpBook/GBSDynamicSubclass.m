//
//  GBSFauxSubclass.m
//  HelpBook
//
//  Created by Brent Royal-Gordon on 8/9/13.
//  Copyright (c) 2013 Groundbreaking Software. All rights reserved.
//

#import "GBSDynamicSubclass.h"
#import <objc/runtime.h>

@interface NSObject (DynamicClassesHaveThese)

- (Class)staticClass;
- (Class)dynamicClass;

@end

static void GBSCopyFromStaticClassToDynamicClass(Class staticClass, Class dynamicClass);

Class GBSDynamicClassForStaticClass(Class staticClass) {
    NSString * dynamicClassName = [@"GBSDynamicClass_" stringByAppendingString:NSStringFromClass(staticClass)];
    Class dynamicClass = NSClassFromString(dynamicClassName);
    if(dynamicClass) {
        return dynamicClass;
    }
    
    if([staticClass staticClass] == staticClass) {
        return [staticClass dynamicClass];
    }
    
    Class superclass = GBSDynamicClassForStaticClass([staticClass superclass]);
    if(!superclass) {
        superclass = [staticClass dynamicClass];
    }
    
    size_t extraBytes = class_getInstanceSize(staticClass) - class_getInstanceSize([staticClass superclass]);
    dynamicClass = objc_allocateClassPair(superclass, dynamicClassName.UTF8String, extraBytes);
    
    GBSCopyFromStaticClassToDynamicClass(staticClass, dynamicClass);
    GBSCopyFromStaticClassToDynamicClass(object_getClass(staticClass), object_getClass(dynamicClass));
    
    objc_registerClassPair(dynamicClass);
    
    return dynamicClass;
}

static void GBSCopyFromStaticClassToDynamicClass(Class staticClass, Class dynamicClass) {
    unsigned int count;
    
    Ivar * ivars = class_copyIvarList(staticClass, &count);
    for(unsigned int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        
        NSUInteger size, alignment;
        NSGetSizeAndAlignment(ivar_getTypeEncoding(ivar), &size, &alignment);
        
        class_addIvar(dynamicClass, ivar_getName(ivar), size, alignment, ivar_getTypeEncoding(ivar));
    }
    free(ivars);
    
    objc_property_t * properties = class_copyPropertyList(staticClass, &count);
    for(unsigned int i = 0; i < count; i++) {
        objc_property_t prop = properties[i];
        
        unsigned int attrCount;
        objc_property_attribute_t * attrs = property_copyAttributeList(prop, &attrCount);
        
        class_addProperty(dynamicClass, property_getName(prop), attrs, attrCount);
        
        free(attrs);
    }
    free(properties);
    
    Protocol *__unsafe_unretained* protocols = class_copyProtocolList(staticClass, &count);
    for(unsigned int i = 0; i < count; i++) {
        Protocol * proto = protocols[i];
        class_addProtocol(dynamicClass, proto);
    }
    free(protocols);
    
    Method * methods = class_copyMethodList(staticClass, &count);
    for(unsigned int i = 0; i < count; i++) {
        Method method = methods[i];
        class_addMethod(dynamicClass, method_getName(method), method_getImplementation(method), method_getTypeEncoding(method));
    }
    free(protocols);
}
