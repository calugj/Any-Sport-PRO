import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Communications;

// Show a nice green screen with app info
public class AboutView extends WatchUi.View {
    
    public function initialize() {
        View.initialize();

        // For 3.2
        //Communications.openWebPage("https://www.pastebin.com/CPS90MMe", {}, null);
    }

    
    public function onLayout(dc) {
    }

    
    public function onShow() {
    }

    
    public function onUpdate(dc) {
        View.onUpdate(dc);

        if(Toybox.Graphics.Dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }

        dc.setColor(0x005500, 0x005500);
        dc.clear();


        var bitmap = WatchUi.loadResource(Rez.Drawables.titleLogo);
        dc.drawBitmap(dc.getWidth()/2 - bitmap.getWidth()/2, dc.getHeight()*0.18 - bitmap.getHeight()/2, bitmap);


        var centerX = dc.getWidth()*0.5;
        var centerY = dc.getHeight()*0.42;
        var width = dc.getWidth()*0.78;
        var height = dc.getHeight()*0.2;
        dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_DK_GREEN);
        dc.fillRoundedRectangle(centerX - width/2, centerY - height/2, width, height, 15);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        var text = WatchUi.loadResource(Rez.Strings.AppName) + "  " + WatchUi.loadResource(Rez.Strings.version) +"\nby  Luca Boscolo Meneguolo" ;
        dc.drawText(centerX, centerY, Graphics.FONT_XTINY, text, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        text = "Donations\npaypal.me/LucaBoscoloMeneguolo";
        dc.drawText(centerX, dc.getWidth()*0.62, Graphics.FONT_XTINY, text, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

    }

    
    public function onHide() {
    }
}