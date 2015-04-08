import XMonad
import XMonad.Config.Azerty
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
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
	, modMask = mod4Mask
	, borderWidth = 2
	, normalBorderColor = "#000000"
	, focusedBorderColor = "#508BEE"
	, workspaces = myWorkSpaces
        , layoutHook = avoidStruts $ myLayout
        , manageHook = myManageHook
        , logHook = myLogHook xmproc
        , keys = myKeys
        , handleEventHook = fullscreenEventHook
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
myWorkSpaces = ["1:web","2:edit","3:dev","4:vid","5:mus"]

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
    , resource =? "Dialog" --> doFloat
    , className =? "Google-chrome-stable" --> viewShift "1:web"
    , className =? "Eclipse" --> viewShift "3:dev"
    , className =? "jetbrains-pycharm" --> viewShift "3:dev"
    , className =? "Spotify" --> viewShift "5:mus"
    , className =? "Vlc" --> viewShift "4:vid"
    , className =? "Notepadqq" --> viewShift "2:edit"
    , manageHook defaultConfig
    ] where viewShift = doF . liftM2 (.) W.greedyView W.shift

-- Keys
keysToAdd x = 
    [ ((mod4Mask .|. shiftMask, xK_comma), spawn ("echo \"" ++ my_help ++ "\" | xmessage -file -"))
    , ((mod4Mask .|. shiftMask, xK_n), refresh)
    , ((mod4Mask, xK_b), sendMessage ToggleStruts)
    , ((mod4Mask .|. shiftMask, xK_F5), spawn "sudo shutdown -h now")
    , ((mod4Mask .|. shiftMask, xK_F6), spawn "sudo reboot")
    , ((mod4Mask .|. shiftMask, xK_l), spawn "xscreensaver-command --lock")
    , ((mod4Mask, xK_c), spawn "chromium")
    , ((mod4Mask, xK_n), spawn "nemo")
    , ((0, xF86XK_KbdBrightnessUp), spawn "sudo asus-kbd-backlight up")
    , ((0, xF86XK_KbdBrightnessDown), spawn "sudo asus-kbd-backlight down")
    , ((0, xF86XK_AudioMute), spawn "amixer sset Master toggle")
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer sset Master 5%-")
    , ((0, xF86XK_AudioRaiseVolume), spawn "amixer sset Master 5%+")
    , ((0, xK_Print), spawn "scrot -e 'mv $f ~/Dropbox/Screenshots' & notify-send 'Screenshot saved in Dropbox'")
    ]

keysToDel x = 
    [ (mod4Mask, xK_n)
    ]

defaultKeys x = foldr M.delete (keys azertyConfig x) (keysToDel x)
myKeys x = M.union (defaultKeys x) (M.fromList (keysToAdd x))

-- Help
my_help = unlines
    [ "The modifier key is the super key (windows key)."
    , ""
    , "-- launching and killing programs"
    , "mod-Shift-Enter  Launch urxvt terminal"
    , "mod-P            Launch dmenu"
    , "mod-Shift-C      Close/kill the focused window"
    , ""
    , "-- layout of window manager"
    , "mod-Space        Rotate through the available layout algorithms"
    , "mod-Shift-Space  Reset the layouts on the current workspace to default"
    , "mod-Shift-N      Resize/refresh viewed windows to the correct size"
    , ""
    , "-- move focus up or daown the window stack"
    , "mod-Tab          Move focus to the next window"
    , "mod-Shift-Tab    Move focus to the previous window"
    , "mod-J            Move focus to the next window"
    , "mod-K            Move focus to the previous window"
    , "mod-M            Move focus to the master window"
    , ""
    , "-- modifying the window order"
    , "mod-Return       Swap the focused window and the master window"
    , "mod-Shift-J      Swap the focused window and the next window"
    , "mod-Shift-K      Swap the focused window and the previous window"
    , ""
    , "-- resizing the master/slave ratio"
    , "mod-B            Show/hide xmobar"
    , "mod-H            Shrink the master area"
    , "mod-L            Expand the master area"
    , ""
    , "-- floating layer support"
    , "mod-T            Push window back into tiling; unfloat and re-tile it"
    , ""
    , "-- increase or decrease number of windows in the master area"
    , "mod-Comma        Increment the number of windows in the master area"
    , "mod-Period       Decrement the number of windows in the master area"
    , ""
    , "-- quick commands"
    , "mod-Shift-Q      Quit xmonad"
    , "mod-Q            Restart xmonad"
    , "mod-Shift-F5     Shutdown"
    , "mod-Shift-F6     Reboot"
    , ""
    , "-- workspaces"
    , "mod-[1..9]       Switch to workspace N"
    , "mod-Shift-[1..9] Move client to workspace N"
    , ""
    , "-- screenshots"
    , "PrtScr           Takes a snapshot of the screen"
    , "Control-PrtScr   Takes a snapshot of the current window"
    , ""
    , "-- applications"
    , "mod-C            Start chrome (browser)"
    , "mod-N            Start nemo (file manager)"
    ]
