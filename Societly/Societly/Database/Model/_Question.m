// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Question.m instead.

#import "_Question.h"

@implementation QuestionID
@end

@implementation _Question

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Question";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Question" inManagedObjectContext:moc_];
}

- (QuestionID*)objectID {
	return (QuestionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"answerValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"answer"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sortingIndexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sortingIndex"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic answer;

- (int16_t)answerValue {
	NSNumber *result = [self answer];
	return [result shortValue];
}

- (void)setAnswerValue:(int16_t)value_ {
	[self setAnswer:@(value_)];
}

- (int16_t)primitiveAnswerValue {
	NSNumber *result = [self primitiveAnswer];
	return [result shortValue];
}

- (void)setPrimitiveAnswerValue:(int16_t)value_ {
	[self setPrimitiveAnswer:@(value_)];
}

@dynamic answerSource;

@dynamic answerSourceDescription;

@dynamic answerSourceLink;

@dynamic name;

@dynamic questionDescription;

@dynamic questionId;

@dynamic sortingIndex;

- (int16_t)sortingIndexValue {
	NSNumber *result = [self sortingIndex];
	return [result shortValue];
}

- (void)setSortingIndexValue:(int16_t)value_ {
	[self setSortingIndex:@(value_)];
}

- (int16_t)primitiveSortingIndexValue {
	NSNumber *result = [self primitiveSortingIndex];
	return [result shortValue];
}

- (void)setPrimitiveSortingIndexValue:(int16_t)value_ {
	[self setPrimitiveSortingIndex:@(value_)];
}

@dynamic set;

- (NSMutableSet<QuestionSet*>*)setSet {
	[self willAccessValueForKey:@"set"];

	NSMutableSet<QuestionSet*> *result = (NSMutableSet<QuestionSet*>*)[self mutableSetValueForKey:@"set"];

	[self didAccessValueForKey:@"set"];
	return result;
}

@end

@implementation QuestionAttributes 
+ (NSString *)answer {
	return @"answer";
}
+ (NSString *)answerSource {
	return @"answerSource";
}
+ (NSString *)answerSourceDescription {
	return @"answerSourceDescription";
}
+ (NSString *)answerSourceLink {
	return @"answerSourceLink";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)questionDescription {
	return @"questionDescription";
}
+ (NSString *)questionId {
	return @"questionId";
}
+ (NSString *)sortingIndex {
	return @"sortingIndex";
}
@end

@implementation QuestionRelationships 
+ (NSString *)set {
	return @"set";
}
@end

