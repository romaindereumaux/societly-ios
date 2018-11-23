//
//  Database.m
//  Societly
//
//  Created by Lauri Eskor on 16/02/15.
//  Copyright (c) 2015 MobiLab. All rights reserved.
//

#import "Database.h"

@interface Database ()
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (id)findCoreDataObjectNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate limit:(int)limit;

@end

@implementation Database

@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectContext = _managedObjectContext;

static Database *sharedInstance = nil;

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSavePrivateQueueContext:) name:NSManagedObjectContextDidSaveNotification object:[self bgManagedObjectContext]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSaveMainQueueContext:) name:NSManagedObjectContextDidSaveNotification object:[self managedObjectContext]];
    }
    return self;
}

+ (Database *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [Database new];
    }
    return sharedInstance;
}

- (void)contextDidSavePrivateQueueContext:(NSNotification *)notification {
    @synchronized(self) {
        [self.managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:) withObject:notification waitUntilDone:NO];
    }
}

- (void)contextDidSaveMainQueueContext:(NSNotification *)notification {
    @synchronized(self) {
        [self.bgManagedObjectContext performBlock:^{
            [self.bgManagedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

#pragma mark - Core Data stack
- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Societly" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    // Create the coordinator and store

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [self storeUrl];
    NSError *error = nil;

    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        MLLog(@"Recreating local database");
        [self resetDB];
        return [self persistentStoreCoordinator];
    }

    return _persistentStoreCoordinator;
}

- (void)deleteObjects:(NSArray *)objects {
    for (NSManagedObject *object in objects) {
        [object.managedObjectContext deleteObject:object];
    }
}

/** 
 reset local store, delete all entries.
 */
- (void)resetDB {
    _managedObjectContext = nil;
    _managedObjectModel = nil;
    _persistentStoreCoordinator = nil;
    _bgManagedObjectContext = nil;

    NSURL *storeURL = [self storeUrl];
    NSError *error = nil;

    NSFileManager *filemanager = [[NSFileManager alloc] init];
    if ([filemanager fileExistsAtPath:storeURL.path]) {
        [filemanager removeItemAtURL:storeURL error:&error];
    }

    [self managedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    [_managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    return _managedObjectContext;
}

- (NSManagedObjectContext *)bgManagedObjectContext {
    if (_bgManagedObjectContext) {
        return _bgManagedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }

    _bgManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_bgManagedObjectContext setPersistentStoreCoordinator:coordinator];
    [_bgManagedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    [_bgManagedObjectContext setUndoManager:nil];

    return _bgManagedObjectContext;
}

- (NSURL *)storeUrl {
   return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Database.sqlite"];
}

- (NSArray *)objectsInMainContext:(NSArray *)objectsArray {
    NSMutableArray *returnArray = [NSMutableArray array];

    for (NSManagedObject *object in objectsArray) {
        NSManagedObjectID *objectId = object.objectID;
        NSManagedObject *objectInMainContext = [self.managedObjectContext objectWithID:objectId];
        [returnArray addObject:objectInMainContext];
    }
    return returnArray;
}

- (NSManagedObject *)objectInMainContext:(NSManagedObject *)object {
    NSManagedObject *objectInMainContext = [self.managedObjectContext objectWithID:object.objectID];
    return objectInMainContext;
}

- (id)findCoreDataObjectNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate {
    return [self findCoreDataObjectNamed:coreName withPredicate:predicate limit:0];
}

- (id)findCoreDataObjectNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate limit:(int)limit {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:coreName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];

    if (limit > 0) {
        [fetchRequest setFetchLimit:limit];
    }

    NSError *error = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error != nil) {
        MLLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    if ([objects count] != 1) {
        if ([objects count] > 1) {
            MLLog(@"findCoreDataObjectNamed:%@ withPredicate:%@ - found %lu items", coreName, predicate, (unsigned long)[objects count]);
        }
        return nil;
    } else {
        return [objects objectAtIndex:0];
    }
}

- (NSArray *)listCoreObjectsNamed:(NSString *)coreName {
    return [self listCoreObjectsNamed:coreName withPredicate:nil];
}

- (NSArray *)listCoreObjectsNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate {
    return [self listCoreObjectsNamed:coreName withPredicate:predicate sortDescriptors:nil];
}


- (NSArray *)listCoreObjectsNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sDescriptors {
    return [self listCoreObjectsNamed:coreName withPredicate:predicate sortDescriptors:sDescriptors inContext:self.managedObjectContext];
}

- (NSArray *)listCoreObjectsNamed:(NSString *)modelName inContext:(NSManagedObjectContext *)context {
    return [self listCoreObjectsNamed:modelName withPredicate:nil inContext:context];
}

- (NSArray *)listCoreObjectsNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context {
    return [self listCoreObjectsNamed:coreName withPredicate:predicate sortDescriptors:nil inContext:context];
}

- (NSArray *)listCoreObjectsNamed:(NSString *)coreName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sDescriptors inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [self fetchRequestFor:coreName withPredicate:predicate sortDescriptors:sDescriptors inContext:context];

    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];

    if (error != nil) {
        MLLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return objects;
}

- (NSFetchRequest *)fetchRequestFor:(NSString *)coreName withPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sDescriptors inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:coreName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];

    if (predicate != nil) {
        [fetchRequest setPredicate:predicate];
    }

    if (sDescriptors != nil) {
        [fetchRequest setSortDescriptors:sDescriptors];
    }

    return fetchRequest;
}

#pragma mark - Core Data Saving support
- (void)saveContext:(NSManagedObjectContext *)context {
    if (context == nil) {
        context = self.managedObjectContext;
    }

    if (context != nil) {
        if ([context hasChanges]) {
            NSError *error = nil;
            BOOL success = [context save:&error];
            if (!success) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }
}


@end
