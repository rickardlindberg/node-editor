import Graphics.UI.Gtk
import Graphics.Rendering.Cairo

main :: IO ()
main = do
    initGUI
    setupMainWindow
    mainGUI

setupMainWindow = do
    mainWindow <- windowNew
    canvas <- drawingAreaNew
    set mainWindow [ windowTitle := "Node Editor", containerChild := canvas ]

    mainWindow `onDestroy`  mainQuit
    mainWindow `onKeyPress` handleKeyPress
    canvas     `onExpose`   redraw canvas

    widgetShowAll mainWindow
    return ()

handleKeyPress event = do
    putStrLn "key pressed"
    return True

redraw canvas event = do
    (w, h) <- widgetGetSize canvas
    drawing <- widgetGetDrawWindow canvas

    renderWithDrawable drawing $ do
        let (r, g, b, a) = (1.0, 0.5, 0.5, 1.0)
        setSourceRGBA r g b a
        paint

    return True
