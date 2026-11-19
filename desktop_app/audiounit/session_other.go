//go:build !ios

package audiounit

// ConfigurePlaybackAudioSession 在非 iOS 平台是空操作。
// Android 走前台 Service + WakeLock，Windows/macOS 桌面端不需要单独的
// 音频会话配置。
func ConfigurePlaybackAudioSession() int {
	return 0
}

// ReassertPlaybackAudioSession 在非 iOS 平台不需要处理。
func ReassertPlaybackAudioSession() int {
	return 0
}
