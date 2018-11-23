// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Candidate.m instead.

#import "_Candidate.h"

@implementation CandidateID
@end

@implementation _Candidate

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Candidate" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Candidate";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Candidate" inManagedObjectContext:moc_];
}

- (CandidateID*)objectID {
	return (CandidateID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"distanceFromUserValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"distanceFromUser"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic candidateDescription;

@dynamic candidateId;

@dynamic distanceFromUser;

- (float)distanceFromUserValue {
	NSNumber *result = [self distanceFromUser];
	return [result floatValue];
}

- (void)setDistanceFromUserValue:(float)value_ {
	[self setDistanceFromUser:@(value_)];
}

- (float)primitiveDistanceFromUserValue {
	NSNumber *result = [self primitiveDistanceFromUser];
	return [result floatValue];
}

- (void)setPrimitiveDistanceFromUserValue:(float)value_ {
	[self setPrimitiveDistanceFromUser:@(value_)];
}

@dynamic districtId;

@dynamic imageUrl;

@dynamic level;

@dynamic name;

@dynamic party;

@dynamic stateId;

@dynamic district;

@dynamic questionSet;

@dynamic state;

@end

@implementation CandidateAttributes 
+ (NSString *)candidateDescription {
	return @"candidateDescription";
}
+ (NSString *)candidateId {
	return @"candidateId";
}
+ (NSString *)distanceFromUser {
	return @"distanceFromUser";
}
+ (NSString *)districtId {
	return @"districtId";
}
+ (NSString *)imageUrl {
	return @"imageUrl";
}
+ (NSString *)level {
	return @"level";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)party {
	return @"party";
}
+ (NSString *)stateId {
	return @"stateId";
}
@end

@implementation CandidateRelationships 
+ (NSString *)district {
	return @"district";
}
+ (NSString *)questionSet {
	return @"questionSet";
}
+ (NSString *)state {
	return @"state";
}
@end

