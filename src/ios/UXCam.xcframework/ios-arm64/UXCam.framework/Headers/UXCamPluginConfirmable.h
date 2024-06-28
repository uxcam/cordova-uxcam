//
//  UXCamPluginConfirmable.h
//  UXCam
//
//  Created by Ankit Karna on 17/01/2024.
//  Copyright © 2024 UXCam. All rights reserved.
//

#ifndef UXCamPlugin_h
#define UXCamPlugin_h

#import <Foundation/Foundation.h>

@protocol UXCamPluginConfirmable <NSObject>

- (void)tagScreenName:(NSString*)screenName;

@end


#endif /* UXCamPlugin_h */
