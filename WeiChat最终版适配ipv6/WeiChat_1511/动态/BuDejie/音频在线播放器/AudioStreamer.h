//
//  AudioStreamer.h
//  StreamingAudioPlayer
//
//  Created by Matt Gallagher on 27/09/08.
//  Copyright 2008 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//
#define SHOUTCAST_METADATA

#if TARGET_OS_IPHONE			
#import <UIKit/UIKit.h>
#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_4_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_4_0 550.32
#endif
#else
#import <Cocoa/Cocoa.h>
#endif TARGET_OS_IPHONE			

#import <Foundation/Foundation.h>
#include <pthread.h>
#include <AudioToolbox/AudioToolbox.h>

#define LOG_QUEUED_BUFFERS 0

#define kNumAQBufs 16			// Number of audio queue buffers we allocate.
								// Needs to be big enough to keep audio pipeline
								// busy (non-zero number of queued buffers) but
								// not so big that audio takes too long to begin
								// (kNumAQBufs * kAQBufSize of data must be
								// loaded before playback will start).
								//
								// Set LOG_QUEUED_BUFFERS to 1 to log how many
								// buffers are queued at any time -- if it drops
								// to zero too often, this value may need to
								// increase. Min 3, typical 8-24.
								
#define kAQDefaultBufSize 2048	// Number of bytes in each audio queue buffer
								// Needs to be big enough to hold a packet of
								// audio from the audio file. If number is too
								// large, queuing of audio before playback starts
								// will take too long.
								// Highly compressed files can use smaller
								// numbers (512 or less). 2048 should hold all
								// but the largest packets. A buffer size error
								// will occur if this number is too small.

#define kAQMaxPacketDescs 512	// Number of packet descriptions in our array

typedef enum
{
	AS_INITIALIZED = 0,
	AS_STARTING_FILE_THREAD,
	AS_WAITING_FOR_DATA,
	AS_FLUSHING_EOF,
	AS_WAITING_FOR_QUEUE_TO_START,
	AS_PLAYING,
	AS_BUFFERING,
	AS_STOPPING,
	AS_STOPPED,
	AS_PAUSED
} AudioStreamerState;

typedef enum
{
	AS_NO_STOP = 0,
	AS_STOPPING_EOF,
	AS_STOPPING_USER_ACTION,
	AS_STOPPING_ERROR,
	AS_STOPPING_TEMPORARILY
} AudioStreamerStopReason;

typedef enum
{
	AS_NO_ERROR = 0,
	AS_NETWORK_CONNECTION_FAILED,
	AS_FILE_STREAM_GET_PROPERTY_FAILED,
	AS_FILE_STREAM_SEEK_FAILED,
	AS_FILE_STREAM_PARSE_BYTES_FAILED,
	AS_FILE_STREAM_OPEN_FAILED,
	AS_FILE_STREAM_CLOSE_FAILED,
	AS_AUDIO_DATA_NOT_FOUND,
	AS_AUDIO_QUEUE_CREATION_FAILED,
	AS_AUDIO_QUEUE_BUFFER_ALLOCATION_FAILED,
	AS_AUDIO_QUEUE_ENQUEUE_FAILED,
	AS_AUDIO_QUEUE_ADD_LISTENER_FAILED,
	AS_AUDIO_QUEUE_REMOVE_LISTENER_FAILED,
	AS_AUDIO_QUEUE_START_FAILED,
	AS_AUDIO_QUEUE_PAUSE_FAILED,
	AS_AUDIO_QUEUE_BUFFER_MISMATCH,
	AS_AUDIO_QUEUE_DISPOSE_FAILED,
	AS_AUDIO_QUEUE_STOP_FAILED,
	AS_AUDIO_QUEUE_FLUSH_FAILED,
	AS_AUDIO_STREAMER_FAILED,
	AS_GET_AUDIO_TIME_FAILED,
	AS_AUDIO_BUFFER_TOO_SMALL
} AudioStreamerErrorCode;

extern NSString * const ASStatusChangedNotification;
extern NSString * const ASPresentAlertWithTitleNotification;
#ifdef SHOUTCAST_METADATA
extern NSString * const ASUpdateMetadataNotification;
#endif

@interface AudioStreamer : NSObject
{
#if TARGET_OS_IPHONE    
	UIBackgroundTaskIdentifier bgTaskId;
#endif    
	NSURL *url;

	//
	// Special threading consideration:
	//	The audioQueue property should only ever be accessed inside a
	//	synchronized(self) block and only *after* checking that ![self isFinishing]
	//
	AudioQueueRef audioQueue;
	AudioFileStreamID audioFileStream;	// the audio file stream parser
	AudioStreamBasicDescription asbd;	// description of the audio
	NSThread *internalThread;			// the thread where the download and
										// audio file stream parsing occurs
	
	AudioQueueBufferRef audioQueueBuffer[kNumAQBufs];		// audio queue buffers
	AudioStreamPacketDescription packetDescs[kAQMaxPacketDescs];	// packet descriptions for enqueuing audio
	unsigned int fillBufferIndex;	// the index of the audioQueueBuffer that is being filled
	UInt32 packetBufferSize;
	size_t bytesFilled;				// how many bytes have been filled
	size_t packetsFilled;			// how many packets have been filled
	bool inuse[kNumAQBufs];			// flags to indicate that a buffer is still in use
	NSInteger buffersUsed;
	NSDictionary *httpHeaders;
	
	AudioStreamerState state;
	AudioStreamerStopReason stopReason;
	AudioStreamerErrorCode errorCode;
	OSStatus err;
	
	bool discontinuous;			// flag to indicate middle of the stream
	
	pthread_mutex_t queueBuffersMutex;			// a mutex to protect the inuse flags
	pthread_cond_t queueBufferReadyCondition;	// a condition varable for handling the inuse flags

	CFReadStreamRef stream;
	NSNotificationCenter *notificationCenter;
	
	UInt32 bitRate;				// Bits per second in the file
	NSInteger dataOffset;		// Offset of the first audio packet in the stream
	NSInteger fileLength;		// Length of the file in bytes
	NSInteger seekByteOffset;	// Seek offset within the file in bytes
	UInt64 audioDataByteCount;  // Used when the actual number of audio bytes in
								// the file is known (more accurate than assuming
								// the whole file is audio)

	UInt64 processedPacketsCount;		// number of packets accumulated for bitrate estimation
	UInt64 processedPacketsSizeTotal;	// byte size of accumulated estimation packets

	double seekTime;
	BOOL seekWasRequested;
	double requestedSeekTime;
	double sampleRate;			// Sample rate of the file (used to compare with
								// samples played by the queue for current playback
								// time)
	double packetDuration;		// sample rate times frames per packet
	double lastProgress;		// last calculated progress point
	UInt32 numberOfChannels;	// Number of audio channels in the stream (1 = mono, 2 = stereo)

#ifdef SHOUTCAST_METADATA
	BOOL foundIcyStart;
	BOOL foundIcyEnd;
	BOOL parsedHeaders;
	unsigned int metaDataInterval;					// how many data bytes between meta data
	unsigned int metaDataBytesRemaining;	// how many bytes of metadata remain to be read
	unsigned int dataBytesRead;							// how many bytes of data have been read
	NSMutableString *metaDataString;			// the metaDataString
#endif
	BOOL vbr; // indicates VBR (or not) stream
}
@property AudioStreamerErrorCode errorCode;
@property (readonly) AudioStreamerState state;//开始
@property (readonly) AudioStreamerStopReason stopReason;//停止，但是读取中无法终止，需要先cancel
@property (readonly) double progress;//总体进度
@property (readonly) double bufferFillPercentage;
@property (readonly) double duration;//当前进度
@property (readwrite) UInt32 bitRate;
@property (readonly) NSDictionary *httpHeaders;
@property (readonly) UInt32 numberOfChannels;
@property (assign, getter=isMeteringEnabled) BOOL meteringEnabled;
@property (readonly) BOOL vbr;

- (id)initWithURL:(NSURL *)aURL;//设置url
- (void)start;
- (void)stop;
- (void)pause;
- (void)cancel;
- (BOOL)isPlaying;
- (BOOL)isPaused;
- (BOOL)isWaiting;
- (BOOL)isIdle;
- (void)seekToTime:(double)newSeekTime;
- (double)calculatedBitRate;
- (void)volume:(double)value;



// level metering
- (float)peakPowerForChannel:(NSUInteger)channelNumber;
- (float)averagePowerForChannel:(NSUInteger)channelNumber;


@end






