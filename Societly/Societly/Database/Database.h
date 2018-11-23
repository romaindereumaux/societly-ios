//
//  Database.h
//  Societly
//
//  Created by Lauri Eskor on 16/02/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NetworkConstants.h"

@interface Database : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *bgManagedObjectContext;

+ (Database *)sharedInstance;

/** 
 Save a managed object context. If context == nil, save main context.
 */
- (void)saveContext:(NSManagedObjectContext *)context;

/** 
 Delete persistent store and create a new one
 */
- (void)resetDB;

- (NSArray *)listCoreObjectsNamed:(NSString *)modelName;
- (NSArray *)listCoreObjectsNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate;
- (NSArray *)listCoreObjectsNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sDescriptors;

- (NSArray *)listCoreObjectsNamed:(NSString *)modelName inContext:(NSManagedObjectContext *)context;
- (NSArray *)listCoreObjectsNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
- (NSArray *)listCoreObjectsNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sDescriptors inContext:(NSManagedObjectContext *)context;


- (id)findCoreDataObjectNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate;

/** 
 Delete objects from |objects|.
 */
- (void)deleteObjects:(NSArray *)objects;

@end
