//
//  NetworkConstants.m
//  Societly
//
//  Created by Lauri Eskor on 28/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "NetworkConstants.h"

//NSString *const kBaseUrl = @"https://api.societly.com/us2016congress/en";
NSString *const kBaseUrl = @"https://api.societly.com/brazil2018demo/en";

NSString *const kPathCandidates = @"candidates";
NSString *const kPathQuestions = @"questions";
NSString *const kPathPostResults = @"submit";
NSString *const kPathCustomers = @"customers";
NSString *const kPathLogin = @"customers/login";
NSString *const kPathLogout = @"customers/logout";
NSString *const kPathSubmissionPrivate = @"customers/current/submissions";
NSString *const kPathSubmissionPublic = @"submissions";
NSString *const kPathStates = @"states";
NSString *const kPathDistricts = @"districts";

NSString *const kKeyDescription = @"description";
NSString *const kKeyId = @"id";
NSString *const kKeyParameters = @"params";

NSString *const kApiUsername = @"societly";
NSString *const kApiPassword = @"Elections";

// Question object keys
NSString *const kKeySortingIndex = @"position";

// Candidate object keys
NSString *const kKeyAnswers = @"answers";
NSString *const kKeyAnswer = @"answer";
NSString *const kKeyQuestionId = @"question_id";
NSString *const kKeyAnswerSource = @"source";
NSString *const kKeyAnswerSourceDescription = @"source_desc";
NSString *const kKeyImageUrl = @"image";
NSString *const kKeyName = @"name";
NSString *const kKeyParty = @"party";
NSString *const kKeyStateId = @"state_id";
NSString *const kKeyDistrictId = @"district_id";
NSString *const kKeyLevel = @"level";

// Customer keys
NSString *const kKeyPassword = @"password";
NSString *const kKeyEmail = @"email";
NSString *const kKeyAccessToken = @"access_token";
NSString *const kKeyProvider = @"provider";

// State and District keys
NSString *const kKeyCode = @"code";

