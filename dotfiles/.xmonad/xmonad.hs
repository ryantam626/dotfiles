import Colors
import Control.Monad (liftM2)
import Data.Ratio
import System.IO
import XMonad
import XMonad.Actions.DynamicProjects
import XMonad.Actions.GridSelect
import XMonad.Actions.OnScreen
import XMonad.Actions.PerWorkspaceKeys
import XMonad.Actions.UpdatePointer
import XMonad.Actions.WindowBringer
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ShowWName
import XMonad.Operations
import XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.SpawnOnce(spawnOnce,spawnOnOnce)

import qualified Data.Map as M

myTerminal = "urxvt"
myTerminalWithTmux = "urxvt -e sh -c 'tmux'"
myBroswer = "google-chrome"
myMenu = "rofi -show run -theme Pop-Dark"

myModMask = mod4Mask
myWorkspace1 = "1"  -- Code Edtior
myWorkspace2 = "2"  -- Terminal
myWorkspace3 = "3"  -- Web
myWorkspace4 = "4"  -- Music and notes
myWorkspace5 = "5"  -- Telegram
myWorkspace6 = "6"
myWorkspaces = [myWorkspace1,myWorkspace2,myWorkspace3,myWorkspace4,myWorkspace5,myWorkspace6]
-- Workspace 2 (Terminal) is NOT meant to shift around, don't bother binding keys for it
myFlexibleWorkspace = Prelude.filter (\w -> w/=myWorkspace2) myWorkspaces
myStartupWorkspace = myWorkspace2

myProjects =
    [ Project { projectName = myWorkspace1
              , projectDirectory = "~/"
              , projectStartHook = Nothing
              }
    , Project { projectName = myWorkspace2
              , projectDirectory = "~/"
              , projectStartHook = Just $ do spawnOnOnce myWorkspace2 myTerminalWithTmux
              }
    , Project { projectName = myWorkspace3
              , projectDirectory = "~/"
              , projectStartHook = Just $ do spawnOnOnce myWorkspace3 myBroswer
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
              , projectDirectory = "~/notes"
              , projectStartHook = Nothing
              }
    ]

myScratchPads = [ (NS "notes" "/home/ryan/scripts/launch-sublime-notes.sh" (stringProperty "_NOTES" =? "true") defaultFloating)
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
    <+> namedScratchpadManageHook myScratchPads
    <+> myManageSpecific
    <+> manageHook defaultConfig



myBorderWidth = 3
myFont      = "-*-terminus-medium-*-*-*-*-160-*-*-*-*-*-*"
myBigFont   = "-*-terminus-medium-*-*-*-*-240-*-*-*-*-*-*"
myWideFont  = "xft:Eurostar Black Extended:"
            ++ "style=Regular:pixelsize=180:hinting=true"
myShowWNameTheme = def
    { swn_font = myWideFont
    , swn_fade = 0.1
    , swn_bgcolor = color8
    , swn_color = color7
    }
showWorkspaceName = showWName' myShowWNameTheme

myLayoutHook = showWorkspaceName
    $ avoidStruts
    $ onWorkspace myWorkspace2 Full
    $ smartBorders
    $ layoutHook defaultConfig
myHandleEventHook =
    handleEventHook defaultConfig
    <+> docksEventHook
    <+> fullscreenEventHook

restrcitedView ws
  | ws == myWorkspace2 = windows . (viewOnScreen 0)
  | ws == myWorkspace1 = windows . (viewOnScreen 0)
  | otherwise = windows . W.view

myKeys =
    [ ("M-n", namedScratchpadAction myScratchPads "notes")
    , ("M-g", goToSelected defaultGSConfig)
    , ("M-h", windows W.focusDown)
    , ("M-l", windows W.focusUp)
    , ("M-C-h", sendMessage Shrink)
    , ("M-C-l", sendMessage Expand)
    , ("M-p", spawn myMenu)
    , ("M1-<F4>", kill)
    , ("M1-C-l", spawn "i3lock-fancy")
    , ("M-b", bringMenuArgs' "rofi" ["-dmenu", "-i", "-theme", "Pop-Dark"])
    , ("M-s", windows $ W.shift "6")
    ] ++
    [ ("M-" ++ [key], restrcitedView tag $ tag)
    | (tag, key) <- zip myWorkspaces "123456789"
    ] ++
    [ ("M-S-" ++ [key], bindOn [(fws, windows . W.shift $ tag) | fws <- myFlexibleWorkspace])
    | (tag, key) <- zip myFlexibleWorkspace "13456789"
    ] ++
    [ ("M-" ++ [key], screenWorkspace screen >>= flip whenJust (windows .W.view))
    | (key, screen)  <- zip "ui" [0,1]
    ]

myKeysToRemove =
    [ (otherModMasks ++ "M-" ++ [key])
    | (key) <- "wer"
    , (otherModMasks) <- ["", "S-"]
    ] ++
    [ "M-S-2"
    , "M-S-c"
    ]

myStartupHook = do
    windows . viewOnScreen 1 $ myWorkspace3
    windows . viewOnScreen 0 $ myWorkspace2

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
        , startupHook = myStartupHook
        , logHook = myLogHook proc
        } `additionalKeysP` myKeys `removeKeysP` myKeysToRemove



main = do
    xmproc <- spawnPipe "xmobar"
    xmonad
        $ dynamicProjects myProjects
        $ myConfig xmproc