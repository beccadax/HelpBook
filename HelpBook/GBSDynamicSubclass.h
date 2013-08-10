//
//  GBSDynamicSubclass.h
//  HelpBook
//
//  Created by Brent Royal-Gordon on 8/9/13.
//  Copyright (c) 2013 Groundbreaking Software. All rights reserved.
//

#import <Foundation/Foundation.h>

// Use this to subclass something that isn't available at link time.

@interface GBSDynamicSubclass : NSObject

// The class we actually want to be a subclass of.
+ (NSString*)dynamicSuperclassName;

// These are overridden to use a runtime-created subclass of the dynamicSuperclass named above...
+ (Class)class;
+ (id)allocWithZone:(NSZone *)zone;

@end

// Use this whenever you want to refer to the superclass.
#define dyn_superclass(superclassName) GBSDynamicSubclassOf##superclassName

// Declare a @dyn_interface(superclassName). Include any superclass methods you want to call before the matching @end.
#define dyn_class(className) interface dyn_superclass(className) : GBSDynamicSubclass 

#define dyn_interface(className) end @interface dyn_superclass(className) (DeclaredByRealSuperclass)

// Use this in the .m file matching the @dyn_interface. No need for an @end.
#define dyn_implementation(className) implementation dyn_superclass(className) + (NSString*)dynamicSuperclassName { return @#className; } @end
