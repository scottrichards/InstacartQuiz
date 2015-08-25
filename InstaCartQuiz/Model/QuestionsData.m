//
//  QuestionsData.m
//  InstaCartQuiz
//
//  Created by Scott Richards on 8/24/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "QuestionsData.h"
#import "QuestionInfo.h"

@implementation QuestionsData

// parse the data as a JSON string
- (void)parseJSONData:(NSData *)data
{
  NSError *error = nil;
  NSJSONReadingOptions options = NSJSONReadingMutableContainers;
  id object = [NSJSONSerialization JSONObjectWithData:data options:options error:&error];
  if (error) {
    NSLog(@"Error Parsing JSON Data");
    [self performSelectorOnMainThread:@selector(outputResults:) withObject:@"Error Parsing JSON Data. Make sure the url points to a valid JSON file." waitUntilDone:0];
  } else {
    if ([object isKindOfClass:[NSDictionary class]]) {
      [self parseJSONDictionary:(NSDictionary *)object depth:0];
    } else if ([object isKindOfClass:[NSArray class]]) {
//      [self parseJSONArray:(NSArray *)object depth:0];
    }

//    [self performSelectorOnMainThread:@selector(outputResults:) withObject:_prettyString waitUntilDone:0];
  }

}



- (void)parseJSONDictionary:(NSDictionary *)dictionary depth:(uint)depth
{
  _questions = [NSMutableArray new];
  for (NSString *key in dictionary) {
    QuestionInfo *question = [QuestionInfo new];
    question.product = key;
    question.imagesArray = dictionary[key];
    [_questions addObject:question];
  }
}

- (NSUInteger)questionCount
{
  return [_questions count];
}
@end
