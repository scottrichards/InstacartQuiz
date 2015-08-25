//
//  ImageCollectionViewCell.m
//  InstaCartQuiz
//
//  Created by Scott Richards on 8/24/15.
//  Copyright (c) 2015 Scott Richards. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@implementation ImageCollectionViewCell

- (id) initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self)
  {
    UIView *unselectedView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
    unselectedView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    unselectedView.layer.borderWidth = 1;
    self.backgroundView = unselectedView;
    UIView *bgView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
    bgView.backgroundColor = [UIColor orangeColor];
    bgView.layer.borderColor = [[UIColor grayColor] CGColor];
    bgView.layer.borderWidth = 1;
    self.selectedBackgroundView = bgView;
  }
  return self;
}
@end
