//
//  NSFileManager+URLForTemporaryItem.h
//  Typesetter
//
//  Created by Brent Royal-Gordon on 2/6/12.
//  Copyright (c) 2012 Architechies. All rights reserved.
//



@interface NSFileManager (URLForTemporaryItem)

- (NSURL*)URLForTemporaryItemOfType:(NSString*)itemType error:(NSError**)error;

@end
