//
//  Database+District.h
//  Societly
//
//  Created by Katrin Annuk on 27/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import "Database.h"
#import "District.h"

@interface Database (District)
- (NSArray *)listDistricts;
- (NSArray *)listDistrictsForState:(NSString *)stateId;
- (NSArray *)listDistrictsWithCandidatesForState:(NSString *)stateId;
- (District *)districtWithId:(NSString *)districtId;
- (void)addDistrictsFromArray:(NSArray *)districtsArray;
@end
