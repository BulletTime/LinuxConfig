import XMonad
import XMonad.Config.Azerty
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ResizableTile
import XMonad.Util.EZConfig
import XMonad.Util.Run

import Control.Monad(liftM2)
import qualified XMonad.StackSet as W

import Graphics.X11.ExtraTypes.XF86
import qualified Data.Map as M
import System.IO

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
    xmonad $ azertyConfig
	{ terminal = myTerminal
	, modMask = mod1Mask
	, borderWidth = 2
	, normalBorderColor = "#000000"
	, focusedBorderColor = "#508BEE"
	, workspaces = myWorkSpaces
        , layoutHook = avoidStruts $ myLayout
        , manageHook = myManageHook
        , logHook = myLogHook xmproc
	}

myTerminal = "urxvt"
myBar = "xmobar"

-- Custom PP log
myLogHook h = dynamicLogWithPP $ xmobarPP
    { ppCurrent = xmobarColor "#6274A3" "" . wrap "[" "]"
    , ppOutput = hPutStrLn h
    , ppHiddenNoWindows = xmobarColor "gray30" ""
    , ppSep = " "
    , ppTitle = xmobarColor "#93CDC9" "" .wrap "[" "]" . shorten 50
    , ppLayout = const ""
    }

-- WorkSpaces
myWorkSpaces = ["1:web","2","3","4","5","6","7","8","9"]

-- Layout
myLayout = noBordersLayout ||| tiled where
    noBordersLayout = noBorders $ Full
    tiled = ResizableTall nmaster delta ratio []
    nmaster = 1
    ratio = 3/5 
    delta = 5/100

-- ManageHook
myManageHook = composeAll
    [ manageDocks
    , (className =? "Firefox" <&&> title =? "Firefox Preferences") --> doFloat
    , (className =? "Firefox" <&&> title =? "Library") --> doFloat
    , resource =? "Dialog" --> doFloat
    , className =? "Firefox" --> viewShift "1:web"
    , manageHook defaultConfig
    ] where viewShift = doF . liftM2 (.) W.greedyView W.shift
