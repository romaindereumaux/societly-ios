#import "_QuestionSet.h"

@class Question;

@interface QuestionSet : _QuestionSet {}
// Custom logic goes here.

- (NSArray *)sortedQuestionsIncludeSkipped:(BOOL)includeSkipped;

/** 
 return question with given ID from questionset
 **/
- (Question *)questionWithId:(NSString *)questionId;
/** 
 Return array of positions.
 **/
- (NSArray *)positionsArray;

/** 
 Return index of first unanswered question.
 **/
- (NSInteger)indexOfFirstUnansweredQuestion;

/**
 Create array of answer dictionaries for 'send results' network request
 [ {
 "answer": 100,
 "balance": 1,
 "question_id": 1
 },.....]
 **/
- (NSArray *)resultsArray;

@end
