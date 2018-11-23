// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to QuestionSet.m instead.

#import "_QuestionSet.h"

@implementation QuestionSetID
@end

@implementation _QuestionSet

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"QuestionSet" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"QuestionSet";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"QuestionSet" inManagedObjectContext:moc_];
}

- (QuestionSetID*)objectID {
	return (QuestionSetID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic setId;

@dynamic userId;

@dynamic candidate;

@dynamic questions;

- (NSMutableSet<Question*>*)questionsSet {
	[self willAccessValueForKey:@"questions"];

	NSMutableSet<Question*> *result = (NSMutableSet<Question*>*)[self mutableSetValueForKey:@"questions"];

	[self didAccessValueForKey:@"questions"];
	return result;
}

@end

@implementation QuestionSetAttributes 
+ (NSString *)setId {
	return @"setId";
}
+ (NSString *)userId {
	return @"userId";
}
@end

@implementation QuestionSetRelationships 
+ (NSString *)candidate {
	return @"candidate";
}
+ (NSString *)questions {
	return @"questions";
}
@end

