/*
 *  SynthesizeSingleton.h
 *  Dudel
 *
 *  Created by Hao Xiaolei on 7/1/11.
 *  Copyright 2011 SVS. All rights reserved.
 *
 */

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
	@synchronized(self) \
	{ \
		if (shared##classname == nil) \
		{ \
			shared##classname = [[self alloc] init]; \
		} \
	} \
\
	return shared##classname; \
}\
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
	@synchronized(self) \
	{ \
		if (shared##classname == nil) \
		{ \
			shared##classname = [super allocWithZone:zone]; \
			return shared##classname; \
		} \
\
	} \
\
	return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
	return zone; \
} \
\
- (id)retain \
{ \
	return self; \
} \
\
- (NSUInteger)retainCount \
{ \
	return NSUIntegerMax; \
} \
\
- (void)release \
{ \
} \
\
- (id)autorelease \
{ \
	return self; \
} 
			