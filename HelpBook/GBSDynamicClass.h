//
//  GBSDynamicSubclass.h
//  HelpBook
//
//  Created by Brent Royal-Gordon on 8/9/13.
//  Copyright (c) 2013 Groundbreaking Software. All rights reserved.
//

#import <Foundation/Foundation.h>

// GBSDynamicClass is used to work with classes that are not available at link time.
// Declare your class with @interface dynamic_class(RealClassName) : ASuperclassYouHaveAvailable,
// then declare all ivars of the class and all methods you want to call. Then in a .m file,
// call @dynamic_implementation(RealClassName).
// 
// If you want to make a subclass of RealClassName, instead subclass dynamic_class(RealClassName).
// If you want to call a class method of RealClassName, instead call it on 
// [dynamic_class(RealClassName) class]. If you want to allocate RealClassName, instead call 
// [dynamic_class(RealClassName) alloc].

// Use this whenever you want to refer to the class.
#define dynamic_class(className) GBSStaticClass_##className

// Use this in a .m file. No need for an @end.
#define dynamic_implementation(className) implementation \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wincomplete-implementation\"") \
dynamic_class(className) + (Class)dynamicClass { return NSClassFromString(@#className); } + (Class)staticClass { return NSClassFromString(@"GBSStaticClass_"#className); } + (Class)class { return GBSDynamicClassForStaticClass(self); } + (instancetype)allocWithZone:(NSZone*)zone { return [[self class] allocWithZone:zone]; } \
@end \
_Pragma("clang diagnostic pop") 

// Returns the runtime class object represented by the passed-in compile time class object.
extern Class GBSDynamicClassForStaticClass(Class staticClass);

