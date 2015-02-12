//
//  MazeViewController.m
//  iCastMaze
//
//  Created by JC on 5/3/14.
//  Copyright (c) 2014 xebia. All rights reserved.
//

#import "MazeViewController.h"

#import "MazeChannel.h"
#import "MazePlayer.h"

#define APP_ID @"4B446701"

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

// @TODO Create a Ctor (choose the right one)
// and instantiate a scanner



//_----

- (void)viewDidLoad {
   self.view.delegate = self;

   // @TODO Start scanning for any Chromecast device
  self.deviceScanner = [[GCKDeviceScanner alloc] init];
  [self.deviceScanner addListener:self];
  [self.deviceScanner startScan];
  NSLog(@"Scanning for devices");
  //_----
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

   // @TODO
   // @FIXME launch workshop using its app id
  
  [self.deviceManager launchApplication:APP_ID];
  //_----
  
   [self reloadNavbar];
}

- (void)deviceManager:(GCKDeviceManager *)deviceManager
didConnectToCastApplication:(GCKApplicationMetadata *)applicationMetadata
            sessionID:(NSString *)sessionID
  launchedApplication:(BOOL)launchedApp {
   NSLog(@"Joined <%@>. Enjoy!", applicationMetadata.applicationName);

    self.player = [MazePlayer new];
  
  // @TODO Create a maze channel with our player
  // and add it to the device manager
  
  self.mazeChannel = [[MazeChannel alloc] initWithPlayer:self.player];
  [self.deviceManager addChannel:self.mazeChannel];
  //_----

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

#pragma mark - View

- (void)mazeView:(MazeView *)view selectedMove:(MazeMove)move {
   // @TODO Send move to Chromecast
  [self.mazeChannel move:move];
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
    // @TODO Implement me :)
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
  
  

   // @TODO Build a device manager for the selected device
   // @TODO Connect to the device through the manager
  
  //DLog(@"Device address: %@:%d", device.ipAddress, (unsigned int) device.servicePort);
  self.selectedDevice = device;
  
  NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
  NSString *appIdentifier = [info objectForKey:@"CFBundleIdentifier"];
  
  self.deviceManager = [[GCKDeviceManager alloc] initWithDevice:self.selectedDevice clientPackageName:appIdentifier];
  self.deviceManager.delegate = self;
  [self.deviceManager connect];
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
