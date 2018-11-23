// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to State.m instead.

#import "_State.h"

@implementation StateID
@end

@implementation _State

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"State" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"State";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"State" inManagedObjectContext:moc_];
}

- (StateID*)objectID {
	return (StateID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic code;

@dynamic name;

@dynamic stateId;

@dynamic candidate;

@end

@implementation StateAttributes 
+ (NSString *)code {
	return @"code";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)stateId {
	return @"stateId";
}
@end

@implementation StateRelationships 
+ (NSString *)candidate {
	return @"candidate";
}
@end

