-- Imports
import Data.Monoid
import System.Exit

import XMonad

import XMonad.Util.Run

import XMonad.Hooks.ServerMode
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.RefocusLast

import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.LayoutModifier

import qualified Data.Map        as M
import qualified XMonad.StackSet as W

import Data.List (sortOn,isPrefixOf)

--
myTerminal      = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = True

-- Width of the window border in pixels.
myBorderWidth   = 1

-- Main modifyer Key
myModMask       = mod4Mask

-- How meny screens to map externaly
myMaxScreenCount  = 3

-- Workspace names, used for logging and external binds
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Colors to use
myNormalBorderColor  = "#3d2d41"
myFocusedBorderColor = "#ed773d"

------------------------------------------------------------------------
-- External commands
myCommands :: [(String, X ())]
myCommands =
        [ ("toggle-fullscreen"         , sendMessage NextLayout                           )
        , ("decrease-master-size"      , sendMessage Shrink                               )
        , ("increase-master-size"      , sendMessage Expand                               )
        , ("decrease-master-count"     , sendMessage $ IncMasterN (-1)                    )
        , ("increase-master-count"     , sendMessage $ IncMasterN ( 1)                    )
        , ("focus-prev"                , windows W.focusUp                                )
        , ("focus-next"                , windows W.focusDown                              )
        , ("focus-master"              , windows W.focusMaster                            )
        , ("focus-last"                , toggleFocus                                      )
        , ("swap-with-prev"            , windows W.swapUp                                 )
        , ("swap-with-next"            , windows W.swapDown                               )
        , ("swap-with-master"          , windows W.swapMaster                             )
        , ("swap-with-last"            , swapWithLast                                     )
        , ("kill-window"               , kill                                             )
        , ("quit"                      , io $ exitWith ExitSuccess                        )
        , ("tile"                      , withFocused $ windows . W.sink                   )
        , ("restart"                   , spawn "xmonad --recompile; xmonad --restart"     )
        ]
------------------------------------------------------------------------
-- Bindings: default actions bound to inputt events

myKeyboardBindings (XConfig {XMonad.modMask = modm}) = M.fromList
    [ ((modm .|. shiftMask .|. controlMask, xK_grave ), io $ exitWith ExitSuccess)
    ]

myMouseBindings    (XConfig {XMonad.modMask = modm}) = M.fromList

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:  Master Stack layout and Monolific (fullscreen)

myLayout = (smartBorders tiled) ||| noBorders Full
  where
    masterCount     = 1
    masterSize      = 0.55
    delta           = 0.05
    tiled           = Tall masterCount delta masterSize

------------------------------------------------------------------------
-- Window rules:

-- myManageHook = namedScratchpadManageHook myScratchpads
myManageHook = composeAll
    [ manageDocks
    , className =? "Xmessage"   --> doCenterFloat
    , className ^=? "eww-"       --> doIgnore
    , className ^=? "sspt-"     --> doFloatDep (\_-> W.RationalRect (1/6) (1/6) (2/3) (2/3))
    , className ^=? "ssp-"      --> doFloatDep (\_-> W.RationalRect (1/6) (1/6) (2/3) (2/3))
    ]

(^=?) :: Query String -> String -> Query Bool
q ^=? x = fmap (isPrefixOf x) q

------------------------------------------------------------------------
-- Event handling

myEventHook = ewmhDesktopsEventHook <+> myServerModeEventHook

-------------------------------------------------------------------------
-- Startup Hook

myStartupHook = ewmhDesktopsStartup

--------------------------------------------------------------------------
-- Status bars and logging

-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
myLogHook = refocusLastLogHook <+> ewmhDesktopsLogHook

-------------------------------------------------------------------------
-- Custom server mode
myServerModeEventHook = serverModeEventHookCmd' $ return myCommands'
myCommands' = ("list-commands", listMyServerCmds) : myCommands ++ sortOn fst (wscs ++ sccs) -- (wscs ++ sccs ++ spcs)
    where
        wscs = [((m ++ s), windows $f s) | s <- myWorkspaces
               , (f, m) <- [(W.view, "focus-workspace-"), (W.shift, "send-to-workspace-")] ]

        sccs = [((m ++ show sc), screenWorkspace (fromIntegral sc) >>= flip whenJust (windows . f))
               | sc <- [0..myMaxScreenCount], (f, m) <- [(W.view, "focus-screen-"), (W.shift, "send-to-screen-")]]


listMyServerCmds :: X ()
listMyServerCmds = spawn ("echo '" ++ asmc ++ "' | xmessage -file -")
    where asmc = unlines $ "Available commands:" : map (\(x, _)-> "    " ++ x) myCommands'

--------------------------------------------------------------------------
--- Main
main = xmonad $ docks defaults

defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeyboardBindings,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
}
