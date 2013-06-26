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

    nodes <- nodesFromDir "test_data/nodes/"
    refNodes <- newIORef nodes

    let forceRedraw = postGUIAsync $ widgetQueueDraw canvas

    mainWindow `onDestroy`  mainQuit
    mainWindow `on`         keyPressEvent $ tryEvent $ do
                                "Return" <- eventKeyName
                                liftIO $ handleEnter refNodes
    mainWindow `on`         keyPressEvent $ tryEvent $ do
                                "j" <- eventKeyName
                                liftIO $ modifyIORef refNodes moveDown >> forceRedraw >> putStrLn "down"
    mainWindow `on`         keyPressEvent $ tryEvent $ do
                                "k" <- eventKeyName
                                liftIO $ modifyIORef refNodes moveUp >> forceRedraw >> putStrLn "up"
    canvas     `onExpose`   redraw refNodes canvas

    widgetShowAll mainWindow
    windowResize mainWindow 800 600
    return ()

handleEnter :: IORef Nodes -> IO ()
handleEnter refNodes = do
    -- Get selected
    nodes <- readIORef refNodes
    let node = getSelected nodes
    -- Edit it
    readProcess "gvim" [header node] ""
    -- Save it
    newBody <- readFile (header node)
    modifyIORef refNodes (updateBody newBody)

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

        selectFontFace fontName FontSlantNormal FontWeightBold
        setFontSize fontSize
        setSourceRGBA 0 0 0 0.8
        forM (zip [0..] (getTopLevelNodes nodes)) $ \(no, node) -> do
            moveTo 10 (20 + 20 * no)
            showText (header node)

        selectFontFace fontName FontSlantNormal FontWeightBold
        setFontSize fontSize
        setSourceRGBA 0 0 0 0.8
        forM (zip [0..] (lines (body (getSelected nodes)))) $ \(no, line) -> do
            moveTo 200 (20 + 20 * no)
            showText line

    return True
