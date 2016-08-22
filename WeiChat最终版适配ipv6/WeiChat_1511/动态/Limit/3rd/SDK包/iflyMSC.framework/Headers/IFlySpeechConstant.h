//
//  IFlySpeechConstant.h
//  MSCDemo
//
//  Created by iflytek on 5/9/14.
//  Copyright (c) 2014 iflytek. All rights reserved.
//

//#import <Foundation/Foundation.h>

/**
 公共常量，主要定义参数的key值
 */
@interface IFlySpeechConstant : NSObject

/**识别录音保存路径
 */
+(NSString*) ASR_AUDIO_PATH;

/**语言区域。
 */
+(NSString*)ACCENT;

/**语音应用ID
 
 通过开发者网站申请
 */
+(NSString*)APPID;

/**设置是否开启语义
 */
+(NSString*)ASR_SCH;


/**设置是否有标点符号
 */
+(NSString*)ASR_PTT;

/**
语言
 
支持：zh_cn，zh_tw，en_us<br>
 */
+(NSString*)LANGUAGE;

/**
 返回结果的数据格式，可设置为json，xml，plain，默认为json。
 */
+(NSString*) RESULT_TYPE;

/**应用领域。
 */
+(NSString*)IFLY_DOMAIN;

/**个性化数据上传类型
 */
+(NSString*)DATA_TYPE;

/** 语音输入超时时间
 
 单位：ms，默认30000
 */
+(NSString*) SPEECH_TIMEOUT;

/** 网络连接超时时间
 
 单位：ms，默认20000
 */
+(NSString*)NET_TIMEOUT;

/**开放语义协议版本号。
 
 如需使用请在http://osp.voicecloud.cn/上进行业务配置
 */
+(NSString*)NLP_VERSION;

/** 扩展参数。
 */
+(NSString*)PARAMS;

/**合成及识别采样率。
 */
+(NSString*)SAMPLE_RATE;

/** 语速（0~100）
 
 默认值:50
 */
+(NSString*)SPEED;

/**
音调（0~100）
 
默认值:50
 */
+(NSString*)PITCH;

/** 合成录音保存路径
 */
+(NSString*)TTS_AUDIO_PATH;

/** VAD前端点超时<br>
 
 可选范围：0-10000(单位ms)<br>
 */
+(NSString*)VAD_BOS;

/** 
VAD后端点超时 。<br>
 
可选范围：0-10000(单位ms)<br>
 */
+(NSString*)VAD_EOS;

/** 发音人。

  云端支持发音人：小燕（xiaoyan）、小宇（xiaoyu）、凯瑟琳（Catherine）、
  亨利（henry）、玛丽（vimary）、小研（vixy）、小琪（vixq）、
  小峰（vixf）、小梅（vixm）、小莉（vixl）、小蓉（四川话）、
  小芸（vixyun）、小坤（vixk）、小强（vixqa）、小莹（vixying）、 小新（vixx）、楠楠（vinn）老孙（vils）<br>
  对于网络TTS的发音人角色，不同引擎类型支持的发音人不同，使用中请注意选择。
 */
+(NSString*)VOICE_NAME;

/**音量（0~100） 默认值:50
 */
+(NSString*)VOLUME ;

/**合成音频缓冲时间，播放缓冲时间，即缓冲多少秒音频后开始播放，如tts_buffer_time=1000
   默认缓冲1000ms毫秒后播放。
 */
+(NSString*)TTS_BUFFER_TIME ;

/**引擎类型。
 可选：local，cloud，auto
 默认：auto
 */
+(NSString*)ENGINE_TYPE;

/**录音源。
 录音机的录音方式，默认为麦克风，设置为1；如果需要外部传送录音，设置为-1，通过WriteAudio接口送入音频。
 */
+(NSString*)AUDIO_SOURCE;

/////////////////////识别相关设置/////////////////////

/**本地语法名称。
 本地语法名称，对应云端的有CLOUD_GRAMMAR
 */
+(NSString*)LOCAL_GRAMMAR;

/**云端语法ID。
 云端编译语法返回的表示，早期版本使用GRAMMAR_ID，仍然兼容，但建议使用新的。
 */
+(NSString*)CLOUD_GRAMMAR;

/**语法类型。
 */
+(NSString*)GRAMMAR_TYPE;

/**语法内容。
 */
+(NSString*)GRAMMAR_CONTENT;

/**字典内容。
 */
+(NSString*)LEXICON_CONTENT;

/**字典名字。
 */
+(NSString*)LEXICON_NAME;


/**语法名称列表。
 */
+(NSString*)GRAMMAR_LIST;

/**编码格式。
 */
+(NSString*)TEXT_ENCODING;

/**结果编码格式。
 */
+(NSString*)RESULT_ENCODING;

/**本地识别引擎。
 */
+(NSString*)TYPE_LOCAL;

/**云端识别引擎。
 */
+(NSString*)TYPE_CLOUD;

/**混合识别引擎。
 */
+(NSString*)TYPE_MIX;

/**引擎根据当前配置进行选择。
 */
+(NSString*)TYPE_AUTO;

/**业务类型。
 */
+(NSString*)SUBJECT;

/**唤醒门限值。
 */
+(NSString*)IVW_THRESHOLD;

/**唤醒服务类型。
 */
+(NSString*)IVW_SST;

/**唤醒+识别。
 */
+(NSString*)IVW_ONESHOT;

/**唤醒工作方式，1：表示唤醒成功后继续录音，0：表示唤醒成功后停止录音。
 */
+(NSString*)KEEP_ALIVE;

@end
