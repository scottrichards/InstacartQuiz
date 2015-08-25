//
//  QuestionsData.h
//  InstaCartQuiz
//
//  Created by Scott Richards on 8/24/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionsData : NSObject
@property (strong, nonatomic) NSMutableArray *questions;

-(void)parseJSONTestData:(NSArray *)jsonArray;
- (void)parseJSONData:(NSData *)data;

- (NSUInteger)questionCount;
@end
