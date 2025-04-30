export function getOperatingSystem() {
	const userAgent = window.navigator.userAgent.toLowerCase()
	const macosPlatforms = /(macintosh|macintel|macppc|mac68k|macppc64|mac68k64)/i
	const windowsPlatforms = /(win32|win64|windows|wince)/i
	const iosPlatforms = /(iphone|ipad|ipod)/i
	if (iosPlatforms.test(userAgent)) {
		return 'ios'
	} else if (windowsPlatforms.test(userAgent)) {
		return 'windows'
	} else if (macosPlatforms.test(userAgent)) {
		return 'macos'
	} else if (/android/i.test(userAgent)) {
		return 'android'
	}
}