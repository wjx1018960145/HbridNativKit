//
//  HTThreadSafeMutableArray.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/13.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTThreadSafeMutableArray : NSMutableArray
/* WXThreadSafeMutableArray inherites from NSMutableArray for backward capability.
 Keep in mind that only the following methods are thread safe guaranteed.
 And MUST not use other methods provideded by NSMutableArray. */

- (instancetype)init;
- (instancetype)initWithCapacity:(NSUInteger)numItems;
- (instancetype)initWithArray:(NSArray *)array;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (instancetype)initWithObjects:(const id [])objects count:(NSUInteger)cnt;

- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
- (id)objectAtIndexedSubscript:(NSUInteger)index;
- (id)firstObject;
- (id)lastObject;
- (BOOL)containsObject:(id)anObject;
- (NSEnumerator *)objectEnumerator;
- (NSEnumerator *)reverseObjectEnumerator;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index;
- (void)addObject:(id)anObject;
- (void)removeObject:(id)anObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeAllObjects;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
- (NSUInteger)indexOfObject:(id)anObject;

@end

NS_ASSUME_NONNULL_END
