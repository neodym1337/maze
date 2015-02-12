//
//  MazeChannel.h
//  iCastMaze
//
//  Created by JC on 5/4/14.
//  Copyright (c) 2014 xebia. All rights reserved.
//

#import <Foundation/Foundation.h>
   #import <GoogleCast/GoogleCast.h>

@class MazePlayer;

@interface MazeChannel : GCKCastChannel

@property(nonatomic, strong, readonly)MazePlayer    *player;

- (id)init UNAVAILABLE_ATTRIBUTE;
- (id)initWithNamespace:(NSString *)protocolNamespace UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithPlayer:(MazePlayer *)player;

- (void)move:(MazeMove)movment;

@end
