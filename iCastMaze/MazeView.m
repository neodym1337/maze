//
//  MazeView.m
//  iCastMaze
//
//  Created by JC on 5/3/14.
//  Copyright (c) 2014 xebia. All rights reserved.
//

#import "MazeView.h"

#import "MazePlayer.h"

@interface MazeView ()
@property(nonatomic, strong)IBOutlet UIButton   *upBtn;
@property(nonatomic, strong)IBOutlet UIButton   *downBtn;
@property(nonatomic, strong)IBOutlet UIButton   *leftBtn;
@property(nonatomic, strong)IBOutlet UIButton   *rightBtn;

@property(nonatomic, strong)IBOutlet UIView     *playerColorView;
@end

@implementation MazeView

- (void)awakeFromNib {
   self.upBtn.tag = MazeMoveUp;
   self.downBtn.tag = MazeMoveDown;
   self.leftBtn.tag = MazeMoveLeft;
   self.rightBtn.tag = MazeMoveRight;
}

- (void)reload {
    MazePlayer *player = [self.delegate mazeViewPlayer:self];

    self.playerColorView.backgroundColor = player.color ?: [UIColor clearColor];
}

- (IBAction)onPadTouched:(UIButton *)sender {
   [self.delegate mazeView:self selectedMove:sender.tag];
}

- (void)setDelegate:(id<MazeViewDelegate>)delegate {
   if (delegate == _delegate)
      return;

   _delegate = delegate;
   [self reload];
}

@end
