//
//  MazeViewController.h
//  iCastMaze
//
//  Created by JC on 5/3/14.
//  Copyright (c) 2014 xebia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MazeView.h"
  #import <GoogleCast/GoogleCast.h>

@interface MazeViewController : UIViewController<GCKDeviceScannerListener, GCKDeviceManagerDelegate, GCKMediaControlChannelDelegate, MazeViewDelegate>

@property(nonatomic, strong)MazeView   *view;

@end
