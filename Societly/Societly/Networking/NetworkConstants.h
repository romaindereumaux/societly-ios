//
//  NetworkConstants.h
//  Societly
//
//  Created by Lauri Eskor on 28/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//


typedef void (^ArraySuccessBlock)(NSArray *array);
typedef void (^DictionarySuccessBlock)(NSDictionary *dictionary);
typedef void (^ObjectSuccessBlock)(NSObject *responseObject);
typedef void (^FailureBlock)(NSError *error);
typedef void (^EmptyBlock)(void);
typedef void (^BooleanBlock)(BOOL boolValue);


extern NSString *const kBaseUrl;

extern NSString *const kPathCandidates;
extern NSString *const kPathQuestions;
extern NSString *const kPathPostResults;
extern NSString *const kPathCustomers;
extern NSString *const kPathSubmissionPrivate;
extern NSString *const kPathSubmissionPublic;
extern NSString *const kPathLogin;
extern NSString *const kPathLogout;
extern NSString *const kPathStates;
extern NSString *const kPathDistricts;

extern NSString *const kKeyDescription;
extern NSString *const kKeyId;
extern NSString *const kKeyParameters;

extern NSString *const kApiUsername;
extern NSString *const kApiPassword;

// Question object keys
extern NSString *const kKeySortingIndex;

// Candidate object keys
extern NSString *const kKeyAnswers;
extern NSString *const kKeyAnswer;
extern NSString *const kKeyQuestionId;
extern NSString *const kKeyAnswerSource;
extern NSString *const kKeyAnswerSourceDescription;
extern NSString *const kKeyImageUrl;
extern NSString *const kKeyName;
extern NSString *const kKeyParty;
extern NSString *const kKeyStateId;
extern NSString *const kKeyDistrictId;
extern NSString *const kKeyLevel;

// Customer keys
extern NSString *const kKeyPassword;
extern NSString *const kKeyEmail;
extern NSString *const kKeyAccessToken;
extern NSString *const kKeyProvider;

// State and District keys
extern NSString *const kKeyCode;
