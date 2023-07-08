//
//  SocketControl.h
//  WebDriverAgentLib
//
//  Created by Anil Solanki on 01/07/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SocketControl : NSObject

- (instancetype)initSocketControl;
- (void) startServer;

@end

NS_ASSUME_NONNULL_END
