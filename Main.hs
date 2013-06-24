import Control.Monad
import Data.IORef
import Graphics.Rendering.Cairo
import Graphics.UI.Gtk
import System.Process
import Node

main :: IO ()
main = do
    initGUI
    setupMainWindow
    mainGUI

setupMainWindow = do
    mainWindow <- windowNew
    canvas <- drawingAreaNew
    set mainWindow [ windowTitle := "Node Editor", containerChild := canvas ]

    node <- nodeFromFile "README.markdown"
    refNodes <- newIORef (nodesFromNodes [node])

    mainWindow `onDestroy`  mainQuit
    mainWindow `onKeyPress` handleKeyPress refNodes
    canvas     `onExpose`   redraw refNodes canvas

    widgetShowAll mainWindow
    windowResize mainWindow 800 600
    return ()

handleKeyPress refNodes event = do
    nodes <- readIORef refNodes

    let node = getSelected nodes
    readProcess "gvim" [header node] ""

    newBody <- readFile (header node)
    modifyIORef refNodes (updateBody newBody)

    putStrLn "key pressed"
    return True

fontName = "Monospace"
fontSize = 14.0

redraw refNodes canvas event = do
    (w, h) <- widgetGetSize canvas
    drawing <- widgetGetDrawWindow canvas

    nodes <- readIORef refNodes

    renderWithDrawable drawing $ do
        let (r, g, b, a) = (1.0, 0.5, 0.5, 1.0)
        setSourceRGBA r g b a
        paint

        let node = getSelected nodes

        selectFontFace fontName FontSlantNormal FontWeightBold
        setFontSize fontSize
        setSourceRGBA 0 0 0 0.8
        moveTo 10 20
        showText (header node)

        selectFontFace fontName FontSlantNormal FontWeightBold
        setFontSize fontSize
        setSourceRGBA 0 0 0 0.8
        forM (zip [0..] (lines (body node))) $ \(no, line) -> do
            moveTo 200 (20 + 20 * no)
            showText line

    return True
