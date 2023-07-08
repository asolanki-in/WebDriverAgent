//
//  SocketControl.m
//  WebDriverAgentLib
//
//  Created by Anil Solanki on 01/07/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

#import "SocketControl.h"
#import "GCDAsyncSocket.h"
#import "FBConfiguration.h"
#import "XCUIDevice+CmdHandler.h"
#import "XCUIDevice+FBHelpers.h"
#import "FBKeyboard.h"
#import "FBApplication.h"
#import "FBApplication+Helper.h"

@interface SocketControl() <GCDAsyncSocketDelegate>
{
  NSArray *handledCommand;
}

@property (atomic, assign) BOOL keepAlive;
@property (readonly, nonatomic) dispatch_queue_t socketQueue;
@property (readonly, nonatomic) GCDAsyncSocket *socketServer;
@property (atomic, strong) GCDAsyncSocket *socketClient;

@end

@implementation SocketControl

- (instancetype)initSocketControl
{
  if ((self = [super init])) {
    _socketQueue = dispatch_queue_create("socketQueue", NULL);
    _socketServer = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_socketQueue];
    handledCommand = @[@"tap",@"swipe",@"home",@"key",@"home_hold", @"tap_hold"];
  }
  return self;
}

- (void) startServer {
  uint16_t port = (uint16_t) FBConfiguration.bindingPortRange.location;
  NSError *error;
  BOOL started = [self.socketServer acceptOnPort:port error: &error];
  if (started == false) {
    NSLog(@"Error Starting Server %@", error);
    return;
  }
  NSLog(@"Started Server on port: %d", port);
  self.keepAlive = YES;
  NSRunLoop *runLoop = [NSRunLoop mainRunLoop];
  while (self.keepAlive && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}


- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
  self.socketClient = newSocket;
  [self.socketClient readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
  NSLog(@"%s %@", __FUNCTION__, err);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self processData:data];
  });
  if (sock == self.socketClient) {
    [self.socketClient readDataWithTimeout:-1 tag:0];
  }
}

-(void) processData:(NSData *) data {
  NSLog(@"%s %@", __FUNCTION__, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
  id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
  NSString *cmd = [NSString stringWithFormat:@"%@", [json objectForKey:@"cmd"]];
  NSUInteger cmdIndex = [handledCommand indexOfObject:cmd];
  switch (cmdIndex) {
    case 0: {
      CGFloat x = [[json objectForKey:@"x"] floatValue];
      CGFloat y = [[json objectForKey:@"y"] floatValue];
      [XCUIDevice.sharedDevice cmd_tap:x y:y];
      break;
    }
    case 1:{
      CGFloat x1 = [[json objectForKey:@"x1"] floatValue];
      CGFloat y1 = [[json objectForKey:@"y1"] floatValue];
      CGFloat x2 = [[json objectForKey:@"x2"] floatValue];
      CGFloat y2 = [[json objectForKey:@"y2"] floatValue];
      [XCUIDevice.sharedDevice cmd_swipe:x1 y1:y1 x2:x2 y2:y2 delay:0.05];
      break;
    }
    case 2:{
      NSError *error;
      [XCUIDevice.sharedDevice fb_pressButton:@"home" forDuration:@0.05 error:&error];
      break;
    }
    case 3:{
      NSString *key = [[json objectForKey:@"key"] stringValue];
      [FBKeyboard typeText:key error:nil];
      break;
    }
    case 4:{
      FBApplication *_app = [[FBApplication alloc] initWithBundleIdentifier:@"com.apple.springboard"];
      if( [_app state] < 2 ) {
        [_app launch];
      } else {
        [_app activate];
      }
      [_app openDeck];
      break;
    }
    case 5:{
      CGFloat x = [[json objectForKey:@"x"] floatValue];
      CGFloat y = [[json objectForKey:@"y"] floatValue];
      CGFloat p = [[json objectForKey:@"p"] floatValue];
      [XCUIDevice.sharedDevice cmd_tapFirm:x y:y pressure:p];
      break;
    }
    default:
      break;
  }
}


@end
