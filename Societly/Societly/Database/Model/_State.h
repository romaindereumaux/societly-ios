// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to State.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class Candidate;

@interface StateID : NSManagedObjectID {}
@end

@interface _State : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) StateID *objectID;

@property (nonatomic, strong, nullable) NSString* code;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSString* stateId;

@property (nonatomic, strong, nullable) Candidate *candidate;

@end

@interface _State (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCode;
- (void)setPrimitiveCode:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveStateId;
- (void)setPrimitiveStateId:(NSString*)value;

- (Candidate*)primitiveCandidate;
- (void)setPrimitiveCandidate:(Candidate*)value;

@end

@interface StateAttributes: NSObject 
+ (NSString *)code;
+ (NSString *)name;
+ (NSString *)stateId;
@end

@interface StateRelationships: NSObject
+ (NSString *)candidate;
@end

NS_ASSUME_NONNULL_END
