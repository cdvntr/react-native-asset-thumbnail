//
//  Created by Emre Yavuz on 20.07.2016.
//  Copyright © 2016 Codeventure. All rights reserved.
//

#import "RNAssetThumbnail.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
@import Photos;

@implementation RNAssetThumbnail

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(generateThumbnail:(NSURL *)filepath width:(NSInteger)width height:(NSInteger)height
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    PHAsset *_asset = [[PHAsset fetchAssetsWithALAssetURLs:@[filepath] options:nil] firstObject];
    PHImageRequestOptions *option = [PHImageRequestOptions new];
    option.synchronous = YES;
    
    [[PHImageManager defaultManager]
     requestImageForAsset:_asset
     targetSize:CGSizeMake(width, height)
     contentMode:PHImageContentModeAspectFill
     options:option
     resultHandler:^(UIImage *result, NSDictionary *info) {
         NSData *data = UIImagePNGRepresentation([self imageWithImage:result scaledToSize:CGSizeMake(70, 70)]);
         NSString *base = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
         
         if(base) {
             resolve(base);
         } else {
             reject(@"Error", nil, nil);
         }
     }];
}

@end
