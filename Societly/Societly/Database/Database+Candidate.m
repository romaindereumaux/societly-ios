//
//  Database+Candidate.m
//  Societly
//
//  Created by Lauri Eskor on 28/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "Database+Candidate.h"
#import "Database+QuestionSet.h"
#import "Question.h"

@implementation Database (Candidate)

- (Candidate *)candidateWithId:(NSString *)candidateId {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"candidateId", candidateId];
  
  Candidate *candidate = [self findCoreDataObjectNamed:NSStringFromClass([Candidate class]) withPredicate:predicate];
  
  if (!candidate) {
    candidate = [Candidate insertInManagedObjectContext:self.managedObjectContext];
    candidate.candidateId = candidateId;
  }
  
  [self saveContext:nil];
  return candidate;
}

- (NSArray *)listCandidates {
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distanceFromUser" ascending:NO];
  return [self listCoreObjectsNamed:NSStringFromClass([Candidate class]) withPredicate:nil sortDescriptors:@[sortDescriptor]];
}

- (NSArray *)listPresidentalCandidates {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distanceFromUser" ascending:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"level", @"country"];

    return [self listCoreObjectsNamed:NSStringFromClass([Candidate class]) withPredicate:predicate sortDescriptors:@[sortDescriptor]];
}

- (NSArray *)listSenateCandidatesForState:(NSString *)stateId {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distanceFromUser" ascending:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"stateId", stateId, @"level", @"state"];
    
    return [self listCoreObjectsNamed:NSStringFromClass([Candidate class]) withPredicate:predicate sortDescriptors:@[sortDescriptor]];
}

- (NSArray *)listHorCandidatesForState:(NSString *)stateId andDistrict:(NSString *)districtId {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distanceFromUser" ascending:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@ && %K == %@", @"stateId", stateId, @"districtId", districtId, @"level", @"district"];
    
    return [self listCoreObjectsNamed:NSStringFromClass([Candidate class]) withPredicate:predicate sortDescriptors:@[sortDescriptor]];
}

- (NSArray *)listCandidatesForState:(NSString *)stateId {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"stateId", stateId];
  return [self listCoreObjectsNamed:NSStringFromClass([Candidate class]) withPredicate:predicate sortDescriptors:nil];
}

- (NSArray *)listCandidatesForState:(NSString *)stateId andDistrict:(NSString *)districtId {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"stateId", stateId, @"districtId", districtId];
  return [self listCoreObjectsNamed:NSStringFromClass([Candidate class]) withPredicate:predicate sortDescriptors:nil];
}

// A dictionary in this form:
//{
//    answers =     (
//                   {
//                       answer = 25;
//                       "question_id" = 1;
//                       source = "";
//                       "source_desc" = "";
//                   },
//                   {
//                       answer = 50;
//                       "question_id" = 2;
//                       source = "";
//                       "source_desc" = "";
//                   },
//    description = Description;
//    id = 1;
//    image = "<null>";
//    name = "Jeb Bush";
//    params = "<null>";
//},

- (void)addCandidatesFromArray:(NSArray *)candidatesArray {
  for (NSDictionary *candidateDictionary in candidatesArray) {
    
    NSString *candidateId = [[candidateDictionary objectForKey:kKeyId] stringValue];
    Candidate *candidate = [self candidateWithId:candidateId];
    
    candidate.candidateDescription = [candidateDictionary objectForKey:kKeyDescription];
    candidate.name = [candidateDictionary objectForKey:kKeyName];
    candidate.imageUrl = [candidateDictionary objectForKey:kKeyImageUrl];
    candidate.party = [candidateDictionary objectForKey:kKeyParty];
    candidate.districtId = [[candidateDictionary objectForKey:kKeyDistrictId] stringValue];
    candidate.stateId = [[candidateDictionary objectForKey:kKeyStateId] stringValue];
    candidate.level = [candidateDictionary objectForKey:kKeyLevel];
    NSArray *answersArray = [candidateDictionary objectForKey:kKeyAnswers];
    
    QuestionSet *currentQuestionSet = [self latestQuestionSet];
    QuestionSet *candidateQuestionSet = [self questionSetWithId:currentQuestionSet.setId andUser:candidateId];
    if (!candidateQuestionSet) {
      candidateQuestionSet = [self questionSetWithSet:currentQuestionSet andUserId:candidateId];
      
      [candidate setQuestionSet:candidateQuestionSet];
      
      for (NSDictionary *answerDictionary in answersArray) {
        NSString *questionId = [[answerDictionary objectForKey:kKeyQuestionId] stringValue];
        Question *question = [candidateQuestionSet questionWithId:questionId];
        if (!question) {
          question = [Question insertInManagedObjectContext:self.managedObjectContext];
          question.questionId = questionId;
          [candidateQuestionSet addQuestionsObject:question];
        }
        
        question.answerValue = [[answerDictionary objectForKey:kKeyAnswer] integerValue];
        question.answerSource = [answerDictionary objectForKey:kKeyAnswerSource];
        question.answerSourceDescription = [answerDictionary objectForKey:kKeyAnswerSourceDescription];
      }
    }
  }
  
  [self saveContext:nil];
}

@end
