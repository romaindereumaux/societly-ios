// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to District.m instead.

#import "_District.h"

@implementation DistrictID
@end

@implementation _District

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"District" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"District";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"District" inManagedObjectContext:moc_];
}

- (DistrictID*)objectID {
	return (DistrictID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic code;

@dynamic districtId;

@dynamic name;

@dynamic stateId;

@dynamic candidate;

@end

@implementation DistrictAttributes 
+ (NSString *)code {
	return @"code";
}
+ (NSString *)districtId {
	return @"districtId";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)stateId {
	return @"stateId";
}
@end

@implementation DistrictRelationships 
+ (NSString *)candidate {
	return @"candidate";
}
@end

