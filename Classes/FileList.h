//
//  FileList.h
//  Dudel
//
//  Created by Hao Xiaolei on 7/5/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FileListChanged @"FileListChanged"

@interface FileList : NSObject {
	NSMutableArray *allFiles;
	NSString *currentFile;
}

@property (nonatomic, readonly) NSArray *allFiles;
@property (nonatomic, copy) NSString *currentFile;

+ (FileList *)sharedFileList;

- (void)deleteCurrentFile;
- (void)renameFile:(NSString *)oldFilename to:(NSString *)newFilename;
- (void)renameCurrentFile:(NSString *)newFileName;
- (NSString *)createAndSelectNewUntitled;

@end
