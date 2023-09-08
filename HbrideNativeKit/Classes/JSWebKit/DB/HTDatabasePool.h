//
//  HTDatabasePool.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/20.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HTDatabase;
NS_ASSUME_NONNULL_BEGIN

@interface HTDatabasePool : NSObject

/** Database path */

@property (atomic, copy, nullable) NSString *path;

/** Delegate object */

@property (atomic, assign, nullable) id delegate;

/** Maximum number of databases to create */

@property (atomic, assign) NSUInteger maximumNumberOfDatabasesToCreate;

/** Open flags */

@property (atomic, readonly) int openFlags;

/**  Custom virtual file system name */

@property (atomic, copy, nullable) NSString *vfsName;


///---------------------
/// @name Initialization
///---------------------

/** Create pool using path.
 
 @param aPath The file path of the database.
 
 @return The `FMDatabasePool` object. `nil` on error.
 */

+ (instancetype)databasePoolWithPath:(NSString * _Nullable)aPath;

/** Create pool using file URL.
 
 @param url The file `NSURL` of the database.
 
 @return The `FMDatabasePool` object. `nil` on error.
 */

+ (instancetype)databasePoolWithURL:(NSURL * _Nullable)url;

/** Create pool using path and specified flags
 
 @param aPath The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database.
 
 @return The `FMDatabasePool` object. `nil` on error.
 */

+ (instancetype)databasePoolWithPath:(NSString * _Nullable)aPath flags:(int)openFlags;

/** Create pool using file URL and specified flags
 
 @param url The file `NSURL` of the database.
 @param openFlags Flags passed to the openWithFlags method of the database.
 
 @return The `FMDatabasePool` object. `nil` on error.
 */

+ (instancetype)databasePoolWithURL:(NSURL * _Nullable)url flags:(int)openFlags;

/** Create pool using path.
 
 @param aPath The file path of the database.
 
 @return The `FMDatabasePool` object. `nil` on error.
 */

- (instancetype)initWithPath:(NSString * _Nullable)aPath;

/** Create pool using file URL.
 
 @param url The file `NSURL of the database.
 
 @return The `FMDatabasePool` object. `nil` on error.
 */

- (instancetype)initWithURL:(NSURL * _Nullable)url;

/** Create pool using path and specified flags.
 
 @param aPath The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database
 
 @return The `FMDatabasePool` object. `nil` on error.
 */

- (instancetype)initWithPath:(NSString * _Nullable)aPath flags:(int)openFlags;

/** Create pool using file URL and specified flags.
 
 @param url The file `NSURL` of the database.
 @param openFlags Flags passed to the openWithFlags method of the database
 
 @return The `FMDatabasePool` object. `nil` on error.
 */

- (instancetype)initWithURL:(NSURL * _Nullable)url flags:(int)openFlags;

/** Create pool using path and specified flags.
 
 @param aPath The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database
 @param vfsName The name of a custom virtual file system
 
 @return The `FMDatabasePool` object. `nil` on error.
 */

- (instancetype)initWithPath:(NSString * _Nullable)aPath flags:(int)openFlags vfs:(NSString * _Nullable)vfsName;

/** Create pool using file URL and specified flags.
 
 @param url The file `NSURL` of the database.
 @param openFlags Flags passed to the openWithFlags method of the database
 @param vfsName The name of a custom virtual file system
 
 @return The `FMDatabasePool` object. `nil` on error.
 */

- (instancetype)initWithURL:(NSURL * _Nullable)url flags:(int)openFlags vfs:(NSString * _Nullable)vfsName;

/** Returns the Class of 'FMDatabase' subclass, that will be used to instantiate database object.

 Subclasses can override this method to return specified Class of 'FMDatabase' subclass.

 @return The Class of 'FMDatabase' subclass, that will be used to instantiate database object.
 */

+ (Class)databaseClass;

///------------------------------------------------
/// @name Keeping track of checked in/out databases
///------------------------------------------------

/** Number of checked-in databases in pool
 */

@property (nonatomic, readonly) NSUInteger countOfCheckedInDatabases;

/** Number of checked-out databases in pool
 */

@property (nonatomic, readonly) NSUInteger countOfCheckedOutDatabases;

/** Total number of databases in pool
 */

@property (nonatomic, readonly) NSUInteger countOfOpenDatabases;

/** Release all databases in pool */

- (void)releaseAllDatabases;

///------------------------------------------
/// @name Perform database operations in pool
///------------------------------------------

/** Synchronously perform database operations in pool.

 @param block The code to be run on the `FMDatabasePool` pool.
 */

- (void)inDatabase:(__attribute__((noescape)) void (^)(HTDatabase *db))block;

/** Synchronously perform database operations in pool using transaction.

 @param block The code to be run on the `FMDatabasePool` pool.
 */

- (void)inTransaction:(__attribute__((noescape)) void (^)(HTDatabase *db, BOOL *rollback))block;

/** Synchronously perform database operations in pool using deferred transaction.

 @param block The code to be run on the `FMDatabasePool` pool.
 */

- (void)inDeferredTransaction:(__attribute__((noescape)) void (^)(HTDatabase *db, BOOL *rollback))block;

/** Synchronously perform database operations in pool using save point.

 @param block The code to be run on the `FMDatabasePool` pool.
 
 @return `NSError` object if error; `nil` if successful.

 @warning You can not nest these, since calling it will pull another database out of the pool and you'll get a deadlock. If you need to nest, use `<[FMDatabase startSavePointWithName:error:]>` instead.
*/

- (NSError * _Nullable)inSavePoint:(__attribute__((noescape)) void (^)(HTDatabase *db, BOOL *rollback))block;

@end

/** FMDatabasePool delegate category
 
 This is a category that defines the protocol for the FMDatabasePool delegate
 */

@interface NSObject (HTDatabasePoolDelegate)

/** Asks the delegate whether database should be added to the pool.
 
 @param pool     The `FMDatabasePool` object.
 @param database The `FMDatabase` object.
 
 @return `YES` if it should add database to pool; `NO` if not.
 
 */

- (BOOL)databasePool:(HTDatabasePool*)pool shouldAddDatabaseToPool:(HTDatabase*)database;

/** Tells the delegate that database was added to the pool.
 
 @param pool     The `FMDatabasePool` object.
 @param database The `FMDatabase` object.

 */

- (void)databasePool:(HTDatabasePool*)pool didAddDatabase:(HTDatabase*)database;

@end
NS_ASSUME_NONNULL_END
