import Graphics.X11.Xlib
import Graphics.X11.Xlib.Extras
import System.Environment
import System.IO
import Data.Char

main :: IO ()
main = parse True "XMONAD_COMMAND" =<< getArgs

parse :: Bool -> String -> [String] -> IO ()
parse input addr args = case args of
        ("--":xs)     -> sendAll addr xs
        ("-a":a:xs)   -> parse input a xs
        ("-h":_)      -> showHelp
        ("--help":_)  -> showHelp
        (a@('-':_):_) -> hPutStrLn stderr ("Unknown option: " ++ a)
        (x:xs)        -> sendCommand addr x >> parse False addr xs
        []            -> return ()



sendAll :: String -> [String] -> IO ()
sendAll addr ss = foldr (\a b -> sendCommand addr a >> b) (return ()) ss

sendCommand :: String -> String -> IO ()
sendCommand addr s = do
  d   <- openDisplay ""
  rw  <- rootWindow d $ defaultScreen d
  a <- internAtom d addr False
  m <- internAtom d s False
  allocaXEvent $ \e -> do
                  setEventType e clientMessage
                  setClientMessageEvent e rw a 32 m currentTime
                  sendEvent d rw False structureNotifyMask e
                  sync d False

showHelp :: IO ()
showHelp = do pn <- getProgName
              putStrLn ("\
			  \Send commands to a running instance of xmonad.\n\
			  \xmonad.hs must be configured with XMonad.Hooks.ServerMode to work.\n\
			  \ \n\
			  \    -a    Atomname can be used at any point in the command line arguments,\n\
			  \          to change which atom it is sending on.\n\
			  \ \n\
			  \ If sent with no arguments or only -a atom arguments,\n\
			  \ it will read commands from stdin.\n\
			  \ \n\
			  \Ex:\n" ++ pn ++ " cmd1 cmd2\n" ++ pn ++ " -a XMONAD_COMMAND cmd1 cmd2 cmd3 -a XMONAD_PRINT hello world\n" ++ pn ++ "\ \n\
			  \ -a XMONAD_PRINT # will read data from stdin.\nThe atom defaults to XMONAD_COMMAND.")
