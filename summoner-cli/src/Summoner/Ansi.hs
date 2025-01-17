{- |
Copyright: (c) 2017-2019 Kowainik
SPDX-License-Identifier: MPL-2.0
Maintainer: Kowainik <xrom.xkov@gmail.com>

This module contains functions for colorful printing into terminal.
-}

module Summoner.Ansi
       ( Color (..)
       , putStrFlush
       , beautyPrint
       , boldCode
       , blueCode
       , bold
       , boldText
       , boldDefault
       , italic
       , redCode
       , reset
       , resetCode
       , prompt
       , setColor
       , successMessage
       , warningMessage
       , errorMessage
       , infoMessage
       , skipMessage
       ) where

import System.Console.ANSI (Color (..), ColorIntensity (Vivid), ConsoleIntensity (BoldIntensity),
                            ConsoleLayer (Foreground), SGR (..), setSGR, setSGRCode)
import System.IO (hFlush)

import qualified Data.Text as T


-- | Explicit flush ensures prompt messages are in the correct order on all systems.
putStrFlush :: Text -> IO ()
putStrFlush msg = do
    putText msg
    hFlush stdout

setColor :: Color -> IO ()
setColor color = setSGR [SetColor Foreground Vivid color]

-- | Starts bold printing.
bold :: IO ()
bold = setSGR [SetConsoleIntensity BoldIntensity]

italic :: IO ()
italic = setSGR [SetItalicized True]

-- | Resets all previous settings.
reset :: IO ()
reset = do
    setSGR [Reset]
    hFlush stdout

-- | Takes list of formatting options, prints text using this format options.
beautyPrint :: [IO ()] -> Text -> IO ()
beautyPrint formats msg = do
    sequence_ formats
    putText msg
    reset

prompt :: IO Text
prompt = do
    setColor Blue
    putStrFlush "  ->   "
    reset
    T.strip <$> getLine

boldText :: Text -> IO ()
boldText message = bold >> putStrFlush message >> reset

boldDefault :: Text -> IO ()
boldDefault message = boldText (" [" <> message <> "]")

colorMessage :: Color -> Text -> IO ()
colorMessage color message = do
    setColor color
    putTextLn $ "  " <> message
    reset

errorMessage, warningMessage, successMessage, infoMessage, skipMessage :: Text -> IO ()
errorMessage   = colorMessage Red
warningMessage = colorMessage Yellow
successMessage = colorMessage Green
infoMessage    = colorMessage Blue
skipMessage    = colorMessage Cyan

blueCode, boldCode, redCode, resetCode :: String
redCode   = setSGRCode [SetColor Foreground Vivid Red]
blueCode  = setSGRCode [SetColor Foreground Vivid Blue]
boldCode  = setSGRCode [SetConsoleIntensity BoldIntensity]
resetCode = setSGRCode [Reset]
