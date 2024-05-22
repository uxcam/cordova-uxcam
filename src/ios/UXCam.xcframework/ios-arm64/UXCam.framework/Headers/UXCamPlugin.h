//
//  UXCamPlugin.h
//  UXCam
//
//  Created by Ankit Karna on 18/01/2024.
//  Copyright © 2024 UXCam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UXCam/UXCamPluginConfirmable.h>

NS_ASSUME_NONNULL_BEGIN

@interface UXCamPlugin : NSObject<UXCamPluginConfirmable>

- (instancetype)initWithPlugin:(NSString *)plugin;

@end

NS_ASSUME_NONNULL_END
