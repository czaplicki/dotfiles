-- Imports
import Data.Monoid
import System.Exit

import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import XMonad.Hooks.ServerMode

import XMonad.Util.Scratchpad

import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.LayoutModifier

import qualified Data.Map        as M
import qualified XMonad.StackSet as W

import Data.List (sort)

--
myTerminal      = "st"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = True

-- Width of the window border in pixels.
--
myBorderWidth   = 1

myModMask       = mod1Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
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
        , ("swap-with-prev"            , windows W.swapUp                                 )
        , ("swap-with-next"            , windows W.swapDown                               )
        , ("swap-with-master"          , windows W.swapMaster                             )
        , ("kill-window"               , kill                                             )
        , ("quit"                      , io $ exitWith ExitSuccess                        )
        , ("restart"                   , spawn "xmonad --recompile; xmonad --restart"     )
        , ("toggle-scratchpad"         , scratchpadSpawnActionTerminal myTerminal         )
        ]
        ---  , ("xterm"               , spawn =<< asks (terminal .  config)              )
------------------------------------------------------------------------
-- Bindings: default actions bound to inputt events
myKeyboardBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, xK_space), scratchpadSpawnActionTerminal myTerminal ) ]
myMouseBindings    (XConfig {XMonad.modMask = modm}) = M.fromList $

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
-- Layouts:

-- Master Stack layout and Monolific (fullscreen)
myLayout = (customBorders tiled) ||| noBorders Full
  where
    masterCount     = 1
    masterSize      = 0.55
    delta           = 0.05
    tiled           = Tall masterCount delta masterSize
    borders         = Border 0 0 0 0
    customBorders   = spacingRaw True (Border 0 0 0 0) False borders True
------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = manageScratchpad

manageScratchpad :: ManageHook
manageScratchpad = scratchpadManageHook ( W.RationalRect l t w h)
    where
        h = 0.5
        w = 0.5
        t = 0.25
        l = 0.25

------------------------------------------------------------------------
-- Event handling
myEventHook = myServerModeEventHook


-----------------------------------------------------------------------
-- Custom server mode
myServerModeEventHook = serverModeEventHookCmd' myCommands'
myCommands' = ( do
    wscmds <- workspaceCommands'
    return $(("list-commands", myServerModeListCommand) : myCommands ++ wscmds ++ screenCommands' ))
        where
            workspaceCommands' = asks (workspaces . config) >>= \spaces -> return
                                   [((m ++ s), windows $f s)
                                   | s      <- spaces
                                   , (f, m) <- [(W.view, "focus-workspace-"), (W.shift, "send-to-workspace-")] ]
            screenCommands' = [((m ++ show sc), screenWorkspace (fromIntegral sc) >>= flip whenJust (windows . f))
                      | sc     <- [0..2] -- increase range to allow for more screens
                      , (f, m) <- [(W.view, "focus-screen-"), (W.shift, "send-to-screen-")]]
myServerModeListCommand = ( do
                               allCommands <- myCommands'
                               let asmc = unlines $ "Available commands:": sort [ "    " ++ fst cmd | cmd <- allCommands ]
                               spawn ("echo '" ++ asmc ++ "' | xmessage -file -"))
------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
--- Main
main = xmonad $ docks defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
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
        startupHook        = return ()
}
