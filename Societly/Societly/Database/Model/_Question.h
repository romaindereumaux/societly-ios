// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Question.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class QuestionSet;

@interface QuestionID : NSManagedObjectID {}
@end

@interface _Question : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) QuestionID *objectID;

@property (nonatomic, strong, nullable) NSNumber* answer;

@property (atomic) int16_t answerValue;
- (int16_t)answerValue;
- (void)setAnswerValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSString* answerSource;

@property (nonatomic, strong, nullable) NSString* answerSourceDescription;

@property (nonatomic, strong, nullable) NSString* answerSourceLink;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSString* questionDescription;

@property (nonatomic, strong, nullable) NSString* questionId;

@property (nonatomic, strong, nullable) NSNumber* sortingIndex;

@property (atomic) int16_t sortingIndexValue;
- (int16_t)sortingIndexValue;
- (void)setSortingIndexValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSSet<QuestionSet*> *set;
- (nullable NSMutableSet<QuestionSet*>*)setSet;

@end

@interface _Question (SetCoreDataGeneratedAccessors)
- (void)addSet:(NSSet<QuestionSet*>*)value_;
- (void)removeSet:(NSSet<QuestionSet*>*)value_;
- (void)addSetObject:(QuestionSet*)value_;
- (void)removeSetObject:(QuestionSet*)value_;

@end

@interface _Question (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveAnswer;
- (void)setPrimitiveAnswer:(NSNumber*)value;

- (int16_t)primitiveAnswerValue;
- (void)setPrimitiveAnswerValue:(int16_t)value_;

- (NSString*)primitiveAnswerSource;
- (void)setPrimitiveAnswerSource:(NSString*)value;

- (NSString*)primitiveAnswerSourceDescription;
- (void)setPrimitiveAnswerSourceDescription:(NSString*)value;

- (NSString*)primitiveAnswerSourceLink;
- (void)setPrimitiveAnswerSourceLink:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveQuestionDescription;
- (void)setPrimitiveQuestionDescription:(NSString*)value;

- (NSString*)primitiveQuestionId;
- (void)setPrimitiveQuestionId:(NSString*)value;

- (NSNumber*)primitiveSortingIndex;
- (void)setPrimitiveSortingIndex:(NSNumber*)value;

- (int16_t)primitiveSortingIndexValue;
- (void)setPrimitiveSortingIndexValue:(int16_t)value_;

- (NSMutableSet<QuestionSet*>*)primitiveSet;
- (void)setPrimitiveSet:(NSMutableSet<QuestionSet*>*)value;

@end

@interface QuestionAttributes: NSObject 
+ (NSString *)answer;
+ (NSString *)answerSource;
+ (NSString *)answerSourceDescription;
+ (NSString *)answerSourceLink;
+ (NSString *)name;
+ (NSString *)questionDescription;
+ (NSString *)questionId;
+ (NSString *)sortingIndex;
@end

@interface QuestionRelationships: NSObject
+ (NSString *)set;
@end

NS_ASSUME_NONNULL_END
