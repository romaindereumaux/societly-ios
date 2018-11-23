//
//  Database+Question.h
//  Societly
//
//  Created by Lauri Eskor on 23/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "Database.h"
#import "Question.h"

@interface Database (Question)

- (NSArray *)allQuestions;
- (Question *)copyOfCuestion:(Question *)question;

// Add a question from server response to database
- (Question *)questionFromDictionary:(NSDictionary *)questionDictionary;
@end
