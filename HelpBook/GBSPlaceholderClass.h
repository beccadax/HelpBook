//
//  GBSPlaceholderClass.h
//  HelpBook
//
//  Created by Brent Royal-Gordon on 8/9/13.
//  Copyright (c) 2013 Groundbreaking Software. All rights reserved.
//

#import <Foundation/Foundation.h>

// GBSPlaceholderClass is used to work with classes that are not available at link time.
// Declare your class with @interface placeholder_class(RealClassName) : ASuperclassYouHaveAvailable,
// then declare all ivars of the class and all methods you want to call. Then in a .m file,
// use @placeholder_implementation(RealClassName).
// 
// If you want to make a subclass of RealClassName, instead subclass placeholder_class(RealClassName).
// If you want to call a class method of RealClassName, instead call it on 
// [placeholder_class(RealClassName) class]. If you want to allocate a RealClassName, instead call 
// [placeholder_class(RealClassName) alloc].

// Use this whenever you want to refer to the class.
#define placeholder_class(className) className##_GBSPlaceholderClass

// Use this in a .m file. Match it with an @end. The only use for anything between the two is if you need to declare a property @dynamic.
#define placeholder_implementation(className) implementation \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wincomplete-implementation\"") \
placeholder_class(className) \
+ (Class)gbs_rootRuntimeClass { return NSClassFromString(@#className); } \
+ (Class)gbs_rootPlaceholderClass { return NSClassFromString(@#className"_GBSPlaceholderClass"); } \
+ (Class)class { return GBSRuntimeClassForPlaceholderClass(self); } \
+ (instancetype)allocWithZone:(NSZone*)zone { return [[self class] allocWithZone:zone]; } \
_Pragma("clang diagnostic pop") 

// Returns the runtime class object represented by the passed-in compile time class object.
extern Class GBSRuntimeClassForPlaceholderClass(Class placeholderClass);

