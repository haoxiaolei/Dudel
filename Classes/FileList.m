//
//  FileList.m
//  Dudel
//
//  Created by Hao Xiaolei on 7/5/11.
//  Copyright 2011 SVS. All rights reserved.
//

#import "FileList.h"
#import "SynthesizeSingleton.h"

#define DEFAULT_FILENAME_KEY @"defaultFilenameKey"

@implementation FileList
@synthesize allFiles;
@synthesize currentFile;

SYNTHESIZE_SINGLETON_FOR_CLASS(FileList)

- init {
	if (self = [super init]) {
		NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *dirPath = [dirs objectAtIndex:0];
		NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:NULL];
		NSArray *sortedFiles = [[files pathsMatchingExtensions:[NSArray arrayWithObject:@"dudeldoc"]] sortedArrayUsingSelector:@selector(compare:)];
		allFiles = [[NSMutableArray array] retain];
		
		// add a full path to every file
		for (NSString *file in sortedFiles) {
			[allFiles addObject:[dirPath stringByAppendingPathComponent:file]];
		}
		
		currentFile = [[[NSUserDefaults standardUserDefaults] stringForKey:DEFAULT_FILENAME_KEY] retain];
		if ([allFiles count] == 0) {
			// No Documents Exists, Create One.
			[self createAndSelectNewUntitled];
		} else if (![allFiles containsObject:currentFile]) {
			self.currentFile = [allFiles objectAtIndex:0];
		}
	}
	return self;
}

- (void)setCurrentFile:(NSString *)filename
{
	if (![currentFile isEqual:filename]) {
		[currentFile release];
		currentFile = [filename copy];
		[[NSUserDefaults standardUserDefaults] setObject:currentFile forKey:DEFAULT_FILENAME_KEY];
		[[NSNotificationCenter defaultCenter] postNotificationName:FileListChanged object:self];
	}
}

- (void)deleteCurrentFile {
	if (self.currentFile) {
		NSUInteger filenameIndex = [self.allFiles indexOfObject:self.currentFile];
		NSError *error = nil;
		BOOL result = [[NSFileManager defaultManager] removeItemAtPath:self.currentFile error:&error];
		
		if (filenameIndex != NSNotFound) {
			[allFiles removeObjectAtIndex:filenameIndex];
			// firgue out which file to make current
			if ([self.allFiles count] == 0) {
				[self createAndSelectNewUntitled];
			} else {
				if ([self.allFiles count] == filenameIndex) {
					filenameIndex--;
				}
				self.currentFile = [self.allFiles objectAtIndex:filenameIndex];
			}
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:FileListChanged object:self];
	}
}
- (void)renameFile:(NSString *)oldFilename to:(NSString *)newFilename {
	[[NSFileManager defaultManager] moveItemAtPath:oldFilename toPath:newFilename error:NULL];
	if ([self.currentFile isEqual:oldFilename]) {
		self.currentFile = newFilename;
	}
	int nameIndex = [self.allFiles indexOfObject:oldFilename];
	if (nameIndex != NSNotFound) {
		[allFiles replaceObjectAtIndex:nameIndex withObject:newFilename];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:FileListChanged object:self];
}
- (void)renameCurrentFile:(NSString *)newFileName {
	[self renameFile:self.currentFile to:newFileName];
}
- (NSString *)createAndSelectNewUntitled {
	NSString *defaultFilename = [NSString stringWithFormat:@"Dudel %@.dudeldoc", [NSDate date]];
	NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *filename =  [[dirs objectAtIndex:0] stringByAppendingPathComponent:defaultFilename];
	[[NSFileManager defaultManager] createFileAtPath:filename contents:nil attributes:nil];
	[allFiles addObject:filename];
	[allFiles sortUsingSelector:@selector(compare:)];
	self.currentFile = filename;
	[[NSNotificationCenter defaultCenter] postNotificationName:FileListChanged object:self];
	return self.currentFile;
}


@end
