//
//  FBApplication+Helper.m
//  WebDriverAgentLib
//
//  Created by Anil Solanki on 07/07/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

#import "FBApplication+Helper.h"
#import "XCUICoordinate.h"

@implementation FBApplication (Helper)

-(void) openDeck {
  XCUICoordinate *start = [self coordinateWithNormalizedOffset:(CGVectorMake(0.5, 0.999))];
  XCUICoordinate *end = [self coordinateWithNormalizedOffset:(CGVectorMake(0.5, 0.222))];
  [start pressForDuration:0 thenDragToCoordinate:end];
}
@end
