
#import "MazeViewController.h"

#import "MazeChannel.h"
#import "MazePlayer.h"

#define APP_ID @"5E68080B"

@interface MazeViewController () <UIActionSheetDelegate>
/**
 * Scanner object to look for Chromecast devices on network
 */
@property(nonatomic, strong) GCKDeviceScanner       *deviceScanner;
/**
 * Manage the chromecast device on which we are connected
 */
@property(nonatomic, strong) GCKDeviceManager       *deviceManager;
/**
 * Channel object to send messages to our Maze game
 */
@property(nonatomic, strong) MazeChannel            *mazeChannel;
/**
 * Player which is currently (or not) playing the game
 */
@property(nonatomic, strong) MazePlayer              *player;
/**
 * Chromecast button into the navigation bar
 */
@property(nonatomic, strong) IBOutlet UIButton      *castBtn;

/** Selected device */
@property GCKDevice *selectedDevice;

@end

@implementation MazeViewController


- (void)viewDidLoad {
   self.view.delegate = self;

    //TODO: 1. Init device scanner, add listener and start scanning
    

  NSLog(@"Scanning for devices");

  [self reloadNavbar];
}

#pragma mark - Cast delegates

- (void)deviceDidComeOnline:(GCKDevice *)device {
   NSLog(@"Device <%@> found", device.friendlyName);

   [self reloadNavbar];
}

- (void)deviceDidGoOffline:(GCKDevice *)device {
   [self reloadNavbar];
}

- (void)deviceManagerDidConnect:(GCKDeviceManager *)deviceManager {
   NSLog(@"Connected to device!");

    //TODO: 3. Launch app w device manager


  
   [self reloadNavbar];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didConnectToCastApplication:(GCKApplicationMetadata *)applicationMetadata
            sessionID:(NSString *)sessionID
  launchedApplication:(BOOL)launchedApp {
   NSLog(@"Joined <%@>. Enjoy!", applicationMetadata.applicationName);

    self.player = [MazePlayer new];
  
  //TODO: 4. create channel and add to devicemanager
    


}

- (void)deviceManager:(GCKDeviceManager *)deviceManager didDisconnectFromApplicationWithError:(NSError *)error {
    self.player = nil;
    self.mazeChannel = nil;
    
    [self.view reload];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager didDisconnectWithError:(NSError *)error {
   [self reloadNavbar];
   self.deviceManager = nil;
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager didFailToConnectWithError:(NSError *)error {
   [self reloadNavbar];
   self.deviceManager = nil;
}

#pragma mark - Game UI view

- (void)mazeView:(MazeView *)view selectedMove:(MazeMove)move {
   //TODO: 5. Send move to Chromecast
    

}

- (MazePlayer *)mazeViewPlayer:(MazeView *)view {
    return self.player;
}

- (void)reloadNavbar {
   self.castBtn.hidden = (self.deviceScanner.devices.count == 0);
   self.castBtn.selected = self.deviceManager.isConnected;
}

#pragma mark - Listener

/** CC button */
- (IBAction)onCast:(id)sender {
   if (!self.deviceManager.device)
      [self onChooseCastDevice:sender];
   else
      [self onShowSelectedDevice:sender];
}

- (void)onChooseCastDevice:(UIButton *)sender {

  NSLog(@"CC button pressed");
  
  NSArray *devices = self.deviceScanner.devices;
  
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Found devices:"                                                     delegate:self
                                            cancelButtonTitle:nil
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:nil];
  
  for (GCKDevice *device in self.deviceScanner.devices) {
    [sheet addButtonWithTitle:device.friendlyName];
  }
  
  sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];
  
  [sheet showInView:self.view];

}

- (void)onShowSelectedDevice:(id)sender {
   UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:self.deviceManager.device.friendlyName
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];

   [sheet addButtonWithTitle:@"Disconnect"];
   sheet.destructiveButtonIndex = 0;

   [sheet addButtonWithTitle:@"Cancel"];
   sheet.cancelButtonIndex = 1;

   [sheet showInView:self.view];
}

#pragma mark - ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (!self.deviceManager.device) {
    if (buttonIndex < self.deviceScanner.devices.count)
      [self onConnectToCastDevice:self.deviceScanner.devices[buttonIndex]];
  }
  else {
    if (buttonIndex == 0)
      [self onDisconnectToDevice];
  }
}

#pragma mark - Connect

- (void)onConnectToCastDevice:(GCKDevice *)device {
   NSBundle *bundle = [NSBundle mainBundle];

    NSLog(@"Connecting to device <%@>", device.friendlyName);


  
  NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
  NSString *appIdentifier = [info objectForKey:@"CFBundleIdentifier"];
  
    
    // TODO: 2. Init device manager w the selected device, set delegate & connect

}

- (void)onDisconnectToDevice {
   [self.deviceManager leaveApplication];
   [self.deviceManager disconnect];
}

#pragma mark - Accessors

- (void)setPlayer:(MazePlayer *)player {
    if (player == _player)
        return;

    [_player removeObserver:self forKeyPath:@"color"];
    _player = player;
    [_player addObserver:self forKeyPath:@"color" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self.view reload];
}

@end
