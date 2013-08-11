//
//  GBSDynamicSubclass.h
//  HelpBook
//
//  Created by Brent Royal-Gordon on 8/9/13.
//  Copyright (c) 2013 Groundbreaking Software. All rights reserved.
//

#import <Foundation/Foundation.h>

// Use this to subclass something that isn't available at link time.

extern Class GBSDynamicClassForStaticClass(Class staticClass);

// Use this whenever you want to refer to the superclass.
#define dynamic_class(className) GBSStaticClass_##className

// Use this in the .m file matching the @dyn_interface. No need for an @end.
#define dynamic_implementation(className) implementation \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wincomplete-implementation\"") \
dynamic_class(className) + (Class)dynamicClass { return NSClassFromString(@#className); } + (Class)staticClass { return NSClassFromString(@"GBSStaticClass_"#className); } + (Class)class { return GBSDynamicClassForStaticClass(self); } + (instancetype)allocWithZone:(NSZone*)zone { return [[self class] allocWithZone:zone]; } \
@end \
_Pragma("clang diagnostic pop") 
