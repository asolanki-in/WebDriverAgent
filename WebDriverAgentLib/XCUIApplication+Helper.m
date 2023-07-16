//
//  XCUIApplication+Helper.m
//  WebDriverAgentLib
//
//  Created by Anil Solanki on 09/07/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

#import "XCUIApplication+Helper.h"
#import "XCUICoordinate.h"

@implementation XCUIApplication (Helper)

-(void) openDeck {
  XCUICoordinate *start = [self coordinateWithNormalizedOffset:(CGVectorMake(0.5, 0.999))];
  XCUICoordinate *end = [self coordinateWithNormalizedOffset:(CGVectorMake(0.5, 0.555))];
  [start pressForDuration:0.2 thenDragToCoordinate:end];
}
@end
