// 只有 iOS 构建时才会被 cgo 编译进包里。
// TARGET_OS_IPHONE 守卫是双保险：万一被别的 Apple 平台（macOS/tvOS）
// 拉进来，也不会误改桌面端的音频会话。

#include <TargetConditionals.h>

#if defined(__APPLE__) && TARGET_OS_IPHONE

// 用 @import 让 clang modules 自动带上 framework 链接信息；
// cgo 侧也已显式声明 -framework AVFoundation，双保险。
@import AVFoundation;

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
