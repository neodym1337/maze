

#import <UIKit/UIKit.h>

#import "MazeView.h"
  #import <GoogleCast/GoogleCast.h>

@interface MazeViewController : UIViewController<GCKDeviceScannerListener, GCKDeviceManagerDelegate, GCKMediaControlChannelDelegate, MazeViewDelegate>

@property(nonatomic, strong)MazeView   *view;

@end
