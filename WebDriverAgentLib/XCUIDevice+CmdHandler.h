//
//  XCUIDevice+CmdHandler.h
//  WebDriverAgentLib
//
//  Created by Anil Solanki on 02/07/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCPointerEventPath.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCUIDevice (CmdHandler)

@property (readonly) id accessibilityInterface;

- (void)runEventPath:(XCPointerEventPath*)path;
- (void)cmd_tap:(CGFloat)x y:(CGFloat)y;
- (void)cmd_swipe:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2 delay:(CGFloat)delay;
- (void)cmd_holdHomeButtonForDuration:(CGFloat)dur;
- (void)cmd_tapFirm:(CGFloat)x y:(CGFloat)y pressure:(CGFloat) pressure;

@end

NS_ASSUME_NONNULL_END
