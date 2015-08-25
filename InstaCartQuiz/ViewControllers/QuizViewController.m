//
//  QuizViewController.m
//  InstaCartQuiz
//
//  Created by Scott Richards on 8/24/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "QuizViewController.h"
#import "QuestionsData.h"
#import "QuestionInfo.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) // Background thread constant for convenience

@interface QuizViewController ()
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *currentQuestionLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalQuestionsLabel;
@property (strong, nonatomic) QuestionsData *questionsData;
@property (assign, nonatomic) NSUInteger currrentQuestion;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@end

@implementation QuizViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadQuestions];
  if (_numberFormatter == nil) {
    _numberFormatter = [NSNumberFormatter new];
    [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadQuestions
{
  dispatch_async(kBgQueue, ^{

    NSString *feedBundlePath = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"json"];
    NSData* data = [NSData dataWithContentsOfFile:feedBundlePath];
    NSError* error;
    _questionsData = [QuestionsData new];
    [_questionsData parseJSONData:data];
//    NSArray* jsonArray = [NSJSONSerialization
//                          JSONObjectWithData:data
//                          options:kNilOptions
//                          error:&error];
//    _questionsData = [QuestionsData new];
//    [_questionsData parseJSONTestData:jsonArray];
    [self performSelectorOnMainThread:@selector(parsedData:) withObject:nil waitUntilDone:0];
  });
}

// parsed the Data update the
- (void)parsedData:(NSString *)results
{
  _currrentQuestion = 0;
  [self updateDisplay];
}

- (void)updateDisplay
{
  _currentQuestionLabel.text = [_numberFormatter stringFromNumber:[NSNumber numberWithInteger:_currrentQuestion]];
  _totalQuestionsLabel.text = [_numberFormatter stringFromNumber:[NSNumber numberWithInteger:[_questionsData questionCount]]];
  QuestionInfo *questionInfo = [_questionsData.questions objectAtIndex:_currrentQuestion];
  _questionLabel.text = questionInfo.product;
}

- (IBAction)onNext:(id)sender {
  _currrentQuestion++;
  [self updateDisplay];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
