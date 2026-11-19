// 只有 iOS 构建时才会被 cgo 编译进包里。
// TARGET_OS_IPHONE 守卫是双保险：万一被别的 Apple 平台（macOS/tvOS）
// 拉进来，也不会误改桌面端的音频会话。
//
// 注意：必须用 #import 而不是 @import。cgo 传给 clang 的参数里没有
// -fmodules，@import 会直接报 "use of '@import' when modules are
// disabled" 导致编译失败。framework 的链接由 session_ios.go 里的
// #cgo LDFLAGS: -framework AVFoundation 负责。

#include <TargetConditionals.h>

#if defined(__APPLE__) && TARGET_OS_IPHONE

#import <AVFoundation/AVFoundation.h>

int music_dl_configure_playback_audio_session(void) {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;

    // Playback 类别：锁屏、静音键拨下、切到后台都能继续出声，
    // 且不像 PlayAndRecord 那样抢占麦克风。
    if (![session setCategory:AVAudioSessionCategoryPlayback
                         mode:AVAudioSessionModeDefault
                      options:0
                        error:&error]) {
        return error == nil ? -1 : (int)error.code;
    }

    if (![session setActive:YES error:&error]) {
        return error == nil ? -2 : (int)error.code;
    }

    return 0;
}

#else

int music_dl_configure_playback_audio_session(void) {
    return 0;
}

#endif
