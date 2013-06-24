import Control.Monad
import Data.IORef
import Graphics.Rendering.Cairo
import Graphics.UI.Gtk
import System.Process

data Node = Node
    { header :: String
    , body   :: String
    }

main :: IO ()
main = do
    initGUI
    setupMainWindow
    mainGUI

setupMainWindow = do
    mainWindow <- windowNew
    canvas <- drawingAreaNew
    set mainWindow [ windowTitle := "Node Editor", containerChild := canvas ]

    let header = "README.markdown"
    body <- readFile header
    let nodes = [Node header body]

    refNodes <- newIORef nodes

    mainWindow `onDestroy`  mainQuit
    mainWindow `onKeyPress` handleKeyPress refNodes
    canvas     `onExpose`   redraw refNodes canvas

    widgetShowAll mainWindow
    windowResize mainWindow 800 600
    return ()

handleKeyPress refNodes event = do
    nodes <- readIORef refNodes
    let [Node header body] = nodes

    readProcess "gvim" [header] ""

    body <- readFile header
    writeIORef refNodes [Node header body]

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

        let [Node header body] = nodes

        selectFontFace fontName FontSlantNormal FontWeightBold
        setFontSize fontSize
        setSourceRGBA 0 0 0 0.8
        moveTo 10 20
        showText header

        selectFontFace fontName FontSlantNormal FontWeightBold
        setFontSize fontSize
        setSourceRGBA 0 0 0 0.8
        forM (zip [0..] (lines body)) $ \(no, line) -> do
            moveTo 200 (20 + 20 * no)
            showText line

    return True
