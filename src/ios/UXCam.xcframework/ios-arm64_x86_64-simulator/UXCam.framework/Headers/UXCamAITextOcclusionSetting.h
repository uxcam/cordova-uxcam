//
//  UXCamAITextOcclusionSetting.h
//  UXCamFramework
//
//  Created by Rajendra Karki on 06/03/2025.
//  Copyright © 2025 UXCam. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UXCam/UXCamOcclusionSetting.h>

NS_ASSUME_NONNULL_BEGIN

@interface UXCamAITextOcclusionSetting : NSObject<UXCamOcclusionSetting, UXGestureRecordable>

@property (nonatomic) NSArray * recognitionLanguage;
@property (nonatomic) BOOL hideGestures;

- (instancetype)initWithLanguage:(NSArray <NSString *> *)language;

@end

NS_ASSUME_NONNULL_END
