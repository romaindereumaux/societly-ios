// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Candidate.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class District;
@class QuestionSet;
@class State;

@interface CandidateID : NSManagedObjectID {}
@end

@interface _Candidate : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CandidateID *objectID;

@property (nonatomic, strong, nullable) NSString* candidateDescription;

@property (nonatomic, strong, nullable) NSString* candidateId;

@property (nonatomic, strong, nullable) NSNumber* distanceFromUser;

@property (atomic) float distanceFromUserValue;
- (float)distanceFromUserValue;
- (void)setDistanceFromUserValue:(float)value_;

@property (nonatomic, strong, nullable) NSString* districtId;

@property (nonatomic, strong, nullable) NSString* imageUrl;

@property (nonatomic, strong, nullable) NSString* level;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSString* party;

@property (nonatomic, strong, nullable) NSString* stateId;

@property (nonatomic, strong, nullable) District *district;

@property (nonatomic, strong, nullable) QuestionSet *questionSet;

@property (nonatomic, strong, nullable) State *state;

@end

@interface _Candidate (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCandidateDescription;
- (void)setPrimitiveCandidateDescription:(NSString*)value;

- (NSString*)primitiveCandidateId;
- (void)setPrimitiveCandidateId:(NSString*)value;

- (NSNumber*)primitiveDistanceFromUser;
- (void)setPrimitiveDistanceFromUser:(NSNumber*)value;

- (float)primitiveDistanceFromUserValue;
- (void)setPrimitiveDistanceFromUserValue:(float)value_;

- (NSString*)primitiveDistrictId;
- (void)setPrimitiveDistrictId:(NSString*)value;

- (NSString*)primitiveImageUrl;
- (void)setPrimitiveImageUrl:(NSString*)value;

- (NSString*)primitiveLevel;
- (void)setPrimitiveLevel:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveParty;
- (void)setPrimitiveParty:(NSString*)value;

- (NSString*)primitiveStateId;
- (void)setPrimitiveStateId:(NSString*)value;

- (District*)primitiveDistrict;
- (void)setPrimitiveDistrict:(District*)value;

- (QuestionSet*)primitiveQuestionSet;
- (void)setPrimitiveQuestionSet:(QuestionSet*)value;

- (State*)primitiveState;
- (void)setPrimitiveState:(State*)value;

@end

@interface CandidateAttributes: NSObject 
+ (NSString *)candidateDescription;
+ (NSString *)candidateId;
+ (NSString *)distanceFromUser;
+ (NSString *)districtId;
+ (NSString *)imageUrl;
+ (NSString *)level;
+ (NSString *)name;
+ (NSString *)party;
+ (NSString *)stateId;
@end

@interface CandidateRelationships: NSObject
+ (NSString *)district;
+ (NSString *)questionSet;
+ (NSString *)state;
@end

NS_ASSUME_NONNULL_END
