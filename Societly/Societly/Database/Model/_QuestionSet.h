// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to QuestionSet.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class Candidate;
@class Question;

@interface QuestionSetID : NSManagedObjectID {}
@end

@interface _QuestionSet : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) QuestionSetID *objectID;

@property (nonatomic, strong, nullable) NSString* setId;

@property (nonatomic, strong, nullable) NSString* userId;

@property (nonatomic, strong, nullable) Candidate *candidate;

@property (nonatomic, strong, nullable) NSSet<Question*> *questions;
- (nullable NSMutableSet<Question*>*)questionsSet;

@end

@interface _QuestionSet (QuestionsCoreDataGeneratedAccessors)
- (void)addQuestions:(NSSet<Question*>*)value_;
- (void)removeQuestions:(NSSet<Question*>*)value_;
- (void)addQuestionsObject:(Question*)value_;
- (void)removeQuestionsObject:(Question*)value_;

@end

@interface _QuestionSet (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveSetId;
- (void)setPrimitiveSetId:(NSString*)value;

- (NSString*)primitiveUserId;
- (void)setPrimitiveUserId:(NSString*)value;

- (Candidate*)primitiveCandidate;
- (void)setPrimitiveCandidate:(Candidate*)value;

- (NSMutableSet<Question*>*)primitiveQuestions;
- (void)setPrimitiveQuestions:(NSMutableSet<Question*>*)value;

@end

@interface QuestionSetAttributes: NSObject 
+ (NSString *)setId;
+ (NSString *)userId;
@end

@interface QuestionSetRelationships: NSObject
+ (NSString *)candidate;
+ (NSString *)questions;
@end

NS_ASSUME_NONNULL_END
