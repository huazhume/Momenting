//
//  MTMediaFileManager.m
//  SchoolSNS
//
//  Created by Huaral on 2017/4/25.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "MTMediaFileManager.h"
#import "MTSanboxFile.h"

#define IMAGE_DIR_NAME @"MT_IMAGE"
#define VEDIO_DIR_NAME @"MT_VIDEO"
#define AUDIO_DIR_NAME @"MT_AUDIO"
#define OTHER_DIR_NAME @"MT_OTHER"
#define DB_DIR_NAME @"MT_DB"

#define IMAGEBATE_DIR_NAME @"MT_IMAGEBATE"


@interface MTMediaFileManager ()

@end

@implementation MTMediaFileManager

/**
 管理者

 @return ClassInstance
 */
+ (MTMediaFileManager *)sharedManager {

  static MTMediaFileManager *sharedInstance = nil;
  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    //初始化
    sharedInstance = [[self alloc] init];
    //创建media文件
  });

  return sharedInstance;
}

- (void)config
{
    [[MTMediaFileManager sharedManager] createMediaFileWithSanboxType:SANBOX_DOCUMNET_TYPE AndWithMediaType:FILE_IMAGE_TYPE];
    [[MTMediaFileManager sharedManager] createMediaFileWithSanboxType:SANBOX_DOCUMNET_TYPE AndWithMediaType:FILE_DB_TYPE];
    [[MTMediaFileManager sharedManager] createMediaFileWithSanboxType:SANBOX_DOCUMNET_TYPE AndWithMediaType: FILE_IMAGEBATE_TYPE];
}

/**
 创建文件夹

 @param sanBoxType 沙盒Mode
 @param mediaType 媒体Mode
 @return 是否成功  1:创建成功 2:已存在
 */
- (NSInteger)createMediaFileWithSanboxType:(SANBOX_FILE_TYPEMODE)sanboxType
                          AndWithMediaType:(FILE_MEDIA_MODE)mediaType {

  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *filePath = @"";
  if (sanboxType == SANBOX_DOCUMNET_TYPE) {
    filePath = [MTSanboxFile getDocumentPath];
  } else if (sanboxType == SANBOX_TAMP_TYPE) {
    filePath = [MTSanboxFile getTmpPath];
  } else if (sanboxType == SANBOX_LIBRARY_TYPE) {
    filePath = [MTSanboxFile getLibraryPath];
  }
  NSString *mediaFileName = @"";
  if (mediaType == FILE_AUDIO_TYPE) {
    mediaFileName = AUDIO_DIR_NAME;
  } else if (mediaType == FILE_IMAGE_TYPE) {
    mediaFileName = IMAGE_DIR_NAME;
  } else if (mediaType == FILE_VIDEO_TYPE) {
    mediaFileName = VEDIO_DIR_NAME;
  }else if (mediaType == FILE_DB_TYPE){
    mediaFileName = DB_DIR_NAME;
  } else if (mediaType == FILE_IMAGEBATE_TYPE) {
      mediaFileName = IMAGEBATE_DIR_NAME;
  }
  NSString *createPath = [filePath
      stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",
                                                                mediaFileName]];
  // 判断文件夹是否存在，如果不存在，则创建
  NSInteger isSuccess = 0;
  if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
    isSuccess = [fileManager createDirectoryAtPath:createPath
                       withIntermediateDirectories:YES
                                        attributes:nil
                                             error:nil];
  } else {
    NSLog(@"FileDir is exists.");
    isSuccess = 2;
  }
  return isSuccess;
}

/**
 获取资源文件目录

 @param sanboxType 沙盒目录类型
 @param mediaType 媒体资源类型
 @return 资源目录文件夹目录
 */

- (NSString *)getMediaFilePathWithAndSanBoxType:(SANBOX_FILE_TYPEMODE)sanboxType
                                   AndMediaType:(FILE_MEDIA_MODE)mediaType {

  NSString *filePath = @"";
  if (sanboxType == SANBOX_DOCUMNET_TYPE) {
    filePath = [MTSanboxFile getDocumentPath];
  } else if (sanboxType == SANBOX_TAMP_TYPE) {
    filePath = [MTSanboxFile getTmpPath];
  } else if (sanboxType == SANBOX_LIBRARY_TYPE) {
    filePath = [MTSanboxFile getLibraryPath];
  }
  NSString *mediaFileName = @"";
  if (mediaType == FILE_AUDIO_TYPE) {
    mediaFileName = AUDIO_DIR_NAME;
  } else if (mediaType == FILE_IMAGE_TYPE) {
    mediaFileName = IMAGE_DIR_NAME;
  } else if (mediaType == FILE_VIDEO_TYPE) {
    mediaFileName =  VEDIO_DIR_NAME;
  }else if (mediaType == FILE_DB_TYPE){
    mediaFileName = DB_DIR_NAME;
  } else if (mediaType == FILE_IMAGEBATE_TYPE) {
    mediaFileName = IMAGEBATE_DIR_NAME;
  }
  
  return [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",mediaFileName]];
}

- (NSString *)getHomeStyleFilePath
{
    
    NSString * path =[[MTMediaFileManager sharedManager] getMediaFilePathWithAndSanBoxType:SANBOX_DOCUMNET_TYPE AndMediaType:FILE_IMAGE_TYPE];
    NSString *fileName = @"homeStyle";
    return [NSString stringWithFormat:@"%@/%@",path,fileName];
}

- (NSString *)getUserImageFilePath
{
    
    NSString * path =[[MTMediaFileManager sharedManager] getMediaFilePathWithAndSanBoxType:SANBOX_DOCUMNET_TYPE AndMediaType:FILE_IMAGE_TYPE];
    NSString *fileName = @"userImage";
    return [NSString stringWithFormat:@"%@/%@",path,fileName];
}
@end
