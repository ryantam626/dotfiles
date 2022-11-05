import Colors
import Control.Monad (liftM2)
import Data.Ratio
import System.IO
import XMonad
import XMonad.Actions.DynamicProjects
import XMonad.Actions.GridSelect
import XMonad.Actions.OnScreen
import XMonad.Actions.PerWorkspaceKeys
import XMonad.Actions.FloatKeys
import XMonad.Actions.UpdatePointer
import XMonad.Actions.WindowBringer
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.SimplestFloat
import XMonad.Layout.ShowWName
import XMonad.Operations
import XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.SpawnOnce(spawnOnce,spawnOnOnce)

import qualified Data.Map as M

myTerminal = "urxvt"
myTerminalWithTmux = "urxvt -e sh -c 'tmux'"
myBroswer = "google-chrome"
myMenu = "rofi -show run"

myModMask = mod4Mask
myWorkspace1 = "1"  -- Code Edtior
myWorkspace2 = "2"  -- Terminal
myWorkspace3 = "3"  -- Web
myWorkspace4 = "4"  -- Music and notes
myWorkspace5 = "5"  -- Telegram
myWorkspace6 = "6"
myWorkspaces = [myWorkspace1,myWorkspace2,myWorkspace3,myWorkspace4,myWorkspace5,myWorkspace6]

myProjects =
    [ Project { projectName = myWorkspace1
              , projectDirectory = "~/"
              , projectStartHook = Nothing
              }
    , Project { projectName = myWorkspace2
              , projectDirectory = "~/"
              , projectStartHook = Nothing
              }
    , Project { projectName = myWorkspace3
              , projectDirectory = "~/"
              , projectStartHook = Nothing
              }
    , Project { projectName = myWorkspace4
              , projectDirectory = "~/"
              , projectStartHook = Nothing
              }
    , Project { projectName = myWorkspace5
              , projectDirectory = "~/"
              , projectStartHook = Nothing
              }
    , Project { projectName = myWorkspace6
              , projectDirectory = "~/"
              , projectStartHook = Nothing
              }
    ]


myManageSpecific = composeOne
    [ isRole =? "GtkFileChooserDialog" -?> doRectFloat (RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2))
    , className =? "Google-chrome" -?> viewShift myWorkspace3
    , (className /=? "URxvt" <&&> currentWs =? myWorkspace2) -?> viewShift myWorkspace1
    ]
    where viewShift = doF . liftM2 (.) W.view W.shift
          isRole = stringProperty "WM_WINDOW_ROLE"

myManageHook :: ManageHook
myManageHook = manageDocks
    <+> myManageSpecific
    <+> manageHook defaultConfig

myBorderWidth = 3
myFont      = "-*-terminus-medium-*-*-*-*-160-*-*-*-*-*-*"
myBigFont   = "-*-terminus-medium-*-*-*-*-240-*-*-*-*-*-*"
myWideFont  = "xft:Eurostar Black Extended:"
            ++ "style=Regular:pixelsize=180:hinting=true"

myLayoutHook = avoidStruts
    $ smartBorders
    $ layoutHook defaultConfig
myHandleEventHook =
    handleEventHook defaultConfig
    <+> docksEventHook
    <+> fullscreenEventHook

myKeys =
    [ ("M-g", goToSelected defaultGSConfig)
    , ("M-h", sendMessage Shrink)
    , ("M-l", sendMessage Expand)
    , ("M-p", spawn myMenu)
    , ("M1-<F4>", kill)
    , ("M1-C-l", spawn "i3lock-fancy")
    , ("M-<F10>", spawn "shutter -s -e")
    , ("M-b", bringMenuArgs' "rofi" ["-dmenu", "-i", "-theme", "Pop-Dark"])
    , ("M-s", windows $ W.shift "6")
    , ("M-<Tab>", windows focusUp >> windows shiftMaster)
    , ("M-f", withFocused $ XMonad.Operations.float)
    , ("M-S-h", withFocused (keysResizeWindow (-35, 0) (0, 0)))
    , ("M-S-l", withFocused (keysResizeWindow (35, 0) (0, 0)))
    , ("M-S-k", withFocused (keysResizeWindow (0, -35) (0, 0)))
    , ("M-S-j", withFocused (keysResizeWindow (0, 35) (0, 0)))
    , ("M-M1-h", withFocused (keysMoveWindow (-35, 0)))
    , ("M-M1-l", withFocused (keysMoveWindow (35, 0)))
    , ("M-M1-k", withFocused (keysMoveWindow (0, -35)))
    , ("M-M1-j", withFocused (keysMoveWindow (0, 35)))
    ] ++
    [ ("M-" ++ [key], screenWorkspace screen >>= flip whenJust (windows .W.view))
    | (key, screen)  <- zip "iu" [0,1]
    ] ++
    [ ("M-S-" ++ [key], screenWorkspace screen >>= flip whenJust (windows .W.shift))
    | (key, screen)  <- zip "iu" [0,1]
    ]

myKeysToRemove =
    [ (otherModMasks ++ "M-" ++ [key])
    | (key) <- "wer"
    , (otherModMasks) <- ["", "S-"]
    ] ++
    [ "M-S-c"
    ]

-- Color of current window title in xmobar.
xmobarTitleColor = "#FFB6B0"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#CEFFAC"

myLogHook proc = dynamicLogWithPP xmobarPP
    { ppOutput = hPutStrLn proc
    , ppTitle = xmobarColor xmobarTitleColor "" . shorten 70
    , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
    , ppSep = "   "
    } >> updatePointer (0.5, 0.5) (0, 0) -- Move pointer to centre on window focus change.

myConfig proc =
    defaultConfig
        { terminal = myTerminal
        , modMask = myModMask
        -- manageHook, layoutHook and handleEventHook must be in this order for avoidStruts to work
        , manageHook = myManageHook
        , layoutHook = myLayoutHook
        , borderWidth = myBorderWidth
        , handleEventHook = myHandleEventHook
        , normalBorderColor = background
        , focusedBorderColor = color12
        , XMonad.workspaces = myWorkspaces
        , logHook = myLogHook proc
        } `additionalKeysP` myKeys `removeKeysP` myKeysToRemove



main = do
    xmproc <- spawnPipe "xmobar"
    xmonad
        $ dynamicProjects myProjects
        $ myConfig xmproc
