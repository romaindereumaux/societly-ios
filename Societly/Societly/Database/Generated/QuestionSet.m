#import "QuestionSet.h"
#import "Question.h"
#import "ManhattanDistance.h"

@interface QuestionSet ()

// Private interface goes here.

@end

@implementation QuestionSet

- (NSArray *)sortedQuestionsIncludeSkipped:(BOOL)includeSkipped {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(sortingIndex)) ascending:YES];

    NSSet *questionsSet = self.questions;
    if (!includeSkipped) {
        NSNumber *skipNumber = [NSNumber numberWithInteger:PositionTypeSkip];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"answer <> %@", skipNumber]];
        questionsSet = [self.questionsSet filteredSetUsingPredicate:predicate];
    }
    NSArray *sortedQuestions = [questionsSet sortedArrayUsingDescriptors:@[descriptor]];
    return sortedQuestions;
}

- (NSArray *)positionsArray {
    NSMutableArray *resultArray = [NSMutableArray array];
    NSArray *questions = [self sortedQuestionsIncludeSkipped:YES];
    for (Question *question in questions) {
        [resultArray addObject:question.answer];
    }
    return resultArray;
}

- (Question *)questionWithId:(NSString *)questionId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"questionId == %@", questionId];
    Question *returnQuestion = [[self.questions filteredSetUsingPredicate:predicate] anyObject];
    return returnQuestion;
}

- (NSInteger)indexOfFirstUnansweredQuestion {
    // Unanswered question has answer PositionTypeNothing
    NSArray *sortedQuestions = [self sortedQuestionsIncludeSkipped:YES];
    NSInteger returnIndex = [sortedQuestions count];
    for (int i = 0; i < [sortedQuestions count]; i++) {
        Question *question = sortedQuestions[i];
        if (question.answerValue == PositionTypeNothing) {
            returnIndex = i;
            break;
        }
    }
    return returnIndex;
}

- (NSArray *)resultsArray {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (Question *question in self.questions) {
        if (question.answerValue != PositionTypeSkip) {
            NSDictionary *questionDictionary = @{@"answer": question.answer,  @"question_id": question.questionId, @"balance": @1};
            [resultArray addObject:questionDictionary];
        }
    }
    return resultArray;
}

@end
