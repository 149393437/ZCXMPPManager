//
//  IFlySpeechRecognizer.h
//  MSC
//
//  Created by iflytek on 13-3-19.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFlySpeechRecognizerDelegate.h"

#define IFLY_AUDIO_SOURCE_MIC    @"1"
#define IFLY_AUDIO_SOURCE_STREAM @"-1"

/** 语音识别类
 
 此类现在设计为单例，你在使用中只需要创建此对象，不能调用release/dealloc函数去释放此对象。所有关于语音识别的操作都在此类中。
 */
@interface IFlySpeechRecognizer : NSObject<IFlySpeechRecognizerDelegate>

/** 设置委托对象 */
@property(nonatomic,assign) id<IFlySpeechRecognizerDelegate> delegate ;


/** 返回识别对象的单例
 */
+ (id) sharedInstance;

/**
 销毁识别对象。
 */
- (BOOL) destroy;

/** 设置识别引擎的参数
 
 识别的引擎参数(key)取值如下：
 
 1. domain：应用的领域； 取值为iat、at、search、video、poi、music、asr；iat：普通文本听写； search：热词搜索； video：视频音乐搜索； asr：关键词识别;
 2. vad_bos：前端点检测；静音超时时间，即用户多长时间不说话则当做超时处理； 单位：ms； engine指定iat识别默认值为5000； 其他情况默认值为 4000，范围 0-10000。
 3. vad_eos：后断点检测；后端点静音检测时间，即用户停止说话多长时间内即认为不再输入， 自动停止录音；单位:ms，sms 识别默认值为 1800，其他默认值为 700，范围 0-10000。
 4. speech_timeout:最长录音时间，默认不设置，范围0-6000ms。
 5. sample_rate：采样率，目前支持的采样率设置有 16000 和 8000。
 6. asr_ptt：否返回无标点符号文本； 默认为 1，当设置为 0 时，将返回无标点符号文本。
 7. asr_sch：是否需要进行语义处理，默认为0，即不进行语义识别，对于需要使用语义的应用，需要将asr_sch设为1。
 8. result_type：返回结果的数据格式，可设置为json，xml，plain，默认为json。
 9. grammarID：识别的语法 id，只针对 domain 设置为”asr”的应用。
 10. asr_audio_path：音频文件名；设置此参数后，将会自动保存识别的录音文件。路径为Documents/(指定值)。不设置或者设置为nil，则不保存音频。
 11. params：扩展参数，对于一些特殊的参数可在此设置，一般用于设置语义。
 @param key 识别引擎参数
 @param value 参数对应的取值
 
 @return 设置的参数和取值正确返回YES，失败返回NO
 */
-(BOOL) setParameter:(NSString *) value forKey:(NSString*)key;

/** 开始识别
 
 同时只能进行一路会话，这次会话没有结束不能进行下一路会话，否则会报错。若有需要多次回话，请在onError回调返回后请求下一路回话。
 */
- (BOOL) startListening;

/** 停止录音
 
 调用此函数会停止录音，并开始进行语音识别
 */
- (void) stopListening;

/** 取消本次会话 */
- (void) cancel;

/** 上传语法 */
- (int) buildGrammarCompletionHandler:(IFlyOnBuildFinishCompletionHandler)completionHandler grammarType:(NSString *)grammarType grammarContent:(NSString *)grammarContent;


/** 是否正在识别
 */
@property (nonatomic, readonly) BOOL isListening;

@end

/** 音频流识别
 
 音频流识别可以将文件分段写入
 */
@interface IFlySpeechRecognizer(IFlyStreamRecognizer)

/** 写入音频流
 
 @param audioData 音频数据
 此方法的使用示例如下:
 <pre><code>[_iFlySpeechRecognizer setParameter:@"audio_source" value:@"-1"];
 [_iFlySpeechRecognizer startListening];
 [_iFlySpeechRecognizer writeAudio:audioData1];
 [_iFlySpeechRecognizer writeAudio:audioData2];
 ...
 [_iFlySpeechRecognizer stopListening];
 </code></pre>
 @return 写入成功返回YES，写入失败返回NO
 */
- (BOOL) writeAudio:(NSData *) audioData;

@end

