hs.loadSpoon("SpoonInstall")

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs
	.loadSpoon("AppWindowSwitcher")
	-- :setLogLevel("debug") -- uncomment for console debug log
	:bindHotkeys({
		["com.apple.Terminal"] = { hyper, "x" },
		[{
			"com.apple.Safari",
			"com.google.Chrome",
			"com.microsoft.edgemac",
			"org.mozilla.firefox",
		}] = { hyper, "q" },
		["Hammerspoon"] = { hyper, "h" },
	})
