//
//  MazeChannel.m
//  iCastMaze
//
//  Created by JC on 5/4/14.
//  Copyright (c) 2014 xebia. All rights reserved.
//

#import "MazeChannel.h"
#import "MazePlayer.h"
#import "UIColor+Hex.h"

//#define MAZE_NAMESPACE @"urn:x-cast:se.johan.maze"
#define MAZE_NAMESPACE @"urn:x-cast:fr.xebia.workshop.cast.maze"


@interface MazeChannel ()
@property(nonatomic, strong) MazePlayer *player;
@end

@implementation MazeChannel

- (id)initWithPlayer:(MazePlayer *)player {

   if (!(self = [super initWithNamespace:MAZE_NAMESPACE]))
        return nil;

    self.player = player;

    return self;
}

- (void)didReceiveTextMessage:(NSString *)message {
    NSDictionary *data = [GCKJSONUtils parseJSON:message];

   if (data[@"color"])
    self.player.color = [UIColor colorFromHexString:data[@"color"]];
}

- (void)move:(MazeMove)movement {
    // TODO: 6. send Movement text message to device
    NSString *moveString = [self getStringFrom:movement];
    
}

- (NSString*)getStringFrom:(MazeMove)movement {
  NSString *result = nil;
  
  switch(movement) {
    case MazeMoveDown:
      result = @"down";
      break;
    case MazeMoveLeft:
      result = @"left";
      break;
    case MazeMoveRight:
      result = @"right";
      break;
    case MazeMoveUp:
      result = @"up";
      break;
    default:
      [NSException raise:NSGenericException format:@"Unexpected input."];
  }
  
  return result;
}

@end
