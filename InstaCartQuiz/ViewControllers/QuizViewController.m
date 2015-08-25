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
#import "ImageCollectionViewCell.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) // Background thread constant for convenience

@interface QuizViewController ()
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *currentQuestionLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalQuestionsLabel;
@property (strong, nonatomic) QuestionsData *questionsData;
@property (assign, nonatomic) NSUInteger currrentQuestion;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (strong, nonatomic) QuestionInfo *currentQuestionInfo;
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
    [self performSelectorOnMainThread:@selector(parsedData:) withObject:nil waitUntilDone:0];
  });
}

// parsed the Data update the
- (void)parsedData:(NSString *)results
{
  _currrentQuestion = 0;
  [self updateDisplay];
  [_imagesCollectionView reloadData];
}

- (void)updateDisplay
{
  _currentQuestionLabel.text = [_numberFormatter stringFromNumber:[NSNumber numberWithInteger:_currrentQuestion]];
  _totalQuestionsLabel.text = [_numberFormatter stringFromNumber:[NSNumber numberWithInteger:[_questionsData questionCount]]];
  _currentQuestionInfo = [_questionsData.questions objectAtIndex:_currrentQuestion];
  _questionLabel.text = _currentQuestionInfo.product;
}

- (IBAction)onNext:(id)sender {
  _currrentQuestion++;
  [self updateDisplay];
  [_imagesCollectionView reloadData];
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
  QuestionInfo *questionInfo = [_questionsData.questions objectAtIndex:_currrentQuestion];
  if (questionInfo)
    return [questionInfo.imagesArray count];
  else
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
  return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  ImageCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  NSString *imagePath = [_currentQuestionInfo.imagesArray objectAtIndex:indexPath.row];
  NSLog(@"Path: %@",imagePath);
  cell.imageLabel.text = [self labelForImage:indexPath.row];
  [cell.imageView setImage:nil];
  if (imagePath) {
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:imagePath]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError) {
                              [cell.imageView setImage:[UIImage imageWithData:data]];
                           }];
  }
  return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
 
}


- (NSString *)labelForImage:(NSUInteger)index
{
  switch (index) {
    case 0:
      return @"A";
      break;
    case 1:
      return @"B";
      break;
    case 2:
      return @"C";
      break;
    case 3:
      return @"D";
      break;
  }
  return  @"";
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
