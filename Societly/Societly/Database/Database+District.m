//
//  Database+District.m
//  Societly
//
//  Created by Katrin Annuk on 27/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import "Database+District.h"
#import "Database+Candidate.h"

@implementation Database (District)

- (NSArray *)listDistricts {
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  return [self listCoreObjectsNamed:NSStringFromClass([District class]) withPredicate:nil sortDescriptors:@[sortDescriptor]];
}

- (NSArray *)listDistrictsWithCandidatesForState:(NSString *)stateId {
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@ && %K != %@", @"stateId", stateId, @"candidate", nil];
  return [self listCoreObjectsNamed:NSStringFromClass([District class]) withPredicate:predicate sortDescriptors:@[sortDescriptor]];
}

- (NSArray *)listDistrictsForState:(NSString *)stateId {
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"stateId", stateId];
  return [self listCoreObjectsNamed:NSStringFromClass([District class]) withPredicate:predicate sortDescriptors:@[sortDescriptor]];
}

- (District *)districtWithId:(NSString *)districtId {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"districtId", districtId];
  
  District *district = [self findCoreDataObjectNamed:NSStringFromClass([District class]) withPredicate:predicate];
  
  if (!district) {
    district = [District insertInManagedObjectContext:self.managedObjectContext];
    district.districtId = districtId;
  }
  
  [self saveContext:nil];
  return district;
}

- (void)addDistrictsFromArray:(NSArray *)districtsArray {
  
  for (NSDictionary *districtDictionary in districtsArray) {
    
    NSString *districtId = [[districtDictionary objectForKey:kKeyId] stringValue];
    District *district = [self districtWithId:districtId];
    district.stateId = [[districtDictionary objectForKey:kKeyStateId] stringValue];
    district.districtId = districtId;
    NSString *name = [districtDictionary objectForKey:kKeyName];
    name = [name stringByReplacingOccurrencesOfString:@"Congressional" withString:@"Congr."];
    district.name = name;
    district.code = [districtDictionary objectForKey:kKeyCode];
    
    NSArray *candidates = [self listCandidatesForState:district.stateId andDistrict:districtId];
    
    for (Candidate *candidate in candidates) {
      candidate.district = district;
    }
  }
  [self saveContext:nil];
}

@end
