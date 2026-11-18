//go:build ios

package audiounit

/*
// #import 不会像 @import 那样自动链接 framework，必须显式声明。
#cgo LDFLAGS: -framework AVFoundation
#include <TargetConditionals.h>
int music_dl_configure_playback_audio_session(void);
*/
import "C"

// ConfigurePlaybackAudioSession 把 App 的音频会话切到 playback 类别。
//
// 必须在任何声音播放之前调用（建议放在 main 的最开头）。
//
// 为什么需要这一步：iOS 上的 WKWebView 播放 <audio> 时用的是 App 自己的
// AVAudioSession。系统默认给的是 SoloAmbient，这个类别在 App 进入后台或
// 锁屏时会直接被静音。只有显式设成 Playback，再配合 Info.plist 里的
// UIBackgroundModes=audio，锁屏和切后台才能继续出声。
//
// 返回 0 表示成功；非 0 是 NSError.code（-1 / -2 表示没有 error 对象）。
func ConfigurePlaybackAudioSession() int {
	return int(C.music_dl_configure_playback_audio_session())
}
