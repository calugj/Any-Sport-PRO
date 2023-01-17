import Toybox.WatchUi;
import Toybox.Position;
import Toybox.Timer;
import Toybox.Graphics;
import Toybox.Time;

// Main purpose: Avoid a bug in FR 55 that doesn't allow to enable GPS in AppClass.mc
// Secondary: Add a nice splash screen animation. This is overcomplicated but looks nice.
public class GPSStarter extends WatchUi.View {
    
    private var timer;
    private var counter;
    private var index;
    private var radius;

    private var backgroundColor;
    private var palette;
    private var bitmap;
    private var string;

    private var nextView;
    
    public function initialize() {
        View.initialize();
        index = 0;

        // Recurrencies easter eggs
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        if(today.month == 3 && today.day == 22) {
            counter = 0;
            backgroundColor = 0x000055;
            palette = [backgroundColor, 0x0055ff, 0x00aaff, Graphics.COLOR_WHITE];
            bitmap = WatchUi.loadResource(Rez.Drawables.titleLogo);
            string = "Happy " + (today.year - 2021).toString() + "° Birthday,\nAny Sport PRO!";
        } else if(today.month == 10 && today.day == 31) {
            counter = 0;
            backgroundColor = Graphics.COLOR_DK_GRAY;
            palette = [backgroundColor, 0xaa5500, 0xffaa55, 0xff5500];
            bitmap = WatchUi.loadResource(Rez.Drawables.titleLogoOrange);
            string = "Trick or Treat?";
        } else if(today.month == 12 && today.day >= 24 && today.day <= 26) {
            counter = 0;
            backgroundColor = Graphics.COLOR_WHITE;
            palette = [backgroundColor, 0xffaa00, 0xff5500, 0xff0000];
            bitmap = WatchUi.loadResource(Rez.Drawables.titleLogoRed);
            string = "Merry Christmas!";
        } else {
            counter = 11;
            backgroundColor = 0x005500;
            palette = [backgroundColor, 0x00aa55, 0x00ff55, Graphics.COLOR_WHITE];
            bitmap = WatchUi.loadResource(Rez.Drawables.titleLogo);
            string = WatchUi.loadResource(Rez.Strings.AppName) + "\n" + WatchUi.loadResource(Rez.Strings.version);
        }
    }

    // Initialize all utilities
    public function onLayout(dc) {
        renderLayout = new RenderLayout();
        renderLayout.update();

        renderValues = new RenderValues();
        renderValues.update();

        renderTitles = new RenderTitles();
        renderTitles.update();

        stringGetter = new StringGetter();

        sessionData = new SessionData();


        radius = dc.getHeight() - 0.2*dc.getHeight();
    }


    public function onShow() {
    	timer = new Timer.Timer();
   		timer.start(method(:end), 50, true);

        setSatellites(getPropertyNumber("Satellites", 1));



        nextView = new SportView(1);
    }
    

    public function onUpdate(dc) {
    	View.onUpdate(dc);

        if(Toybox.Graphics.Dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }

        if(counter <= 31) {
            dc.setColor(backgroundColor, backgroundColor);
            dc.clear();

            dc.drawBitmap(dc.getWidth()/2 - bitmap.getWidth()/2, dc.getHeight()/2 - bitmap.getHeight()/2, bitmap);

            dc.setColor(palette[index], Graphics.COLOR_TRANSPARENT);
            dc.drawText(dc.getWidth()/2, dc.getHeight()*0.75, Graphics.FONT_XTINY, string, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
        else if(counter >= 32) {
            if(counter == 32) {
                nextView.updateLayout();
            }
            nextView.onUpdate(dc);

            dc.setColor(backgroundColor, backgroundColor);
            dc.setPenWidth(radius);
            dc.drawCircle(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2);
        }
    }


    public function onHide() {
        if(timer != null) {
            timer.stop();
        }
    }

    public function end() {
        if(counter == 12) {
            index++;
        }
        else if(counter == 14) {
            index++;
        }
        else if(counter == 16) {
            index++;
        }
        else if(counter >= 32 && counter < 40) {
            radius = radius - 0.35f*radius;
        }
        else if(counter == 40) {
            timer.stop();
            timer = null;

            sessionData.setView(nextView);
            WatchUi.switchToView(nextView, new SportViewDelegate(nextView), WatchUi.SLIDE_IMMEDIATE);
            return;
        }
        counter = counter + 1;
        WatchUi.requestUpdate();
    }
    
    
    
}




public class GPSStarterDelegate extends WatchUi.BehaviorDelegate {
    
    public function initialize() {
        BehaviorDelegate.initialize();
    }
    
    public function onMenu() {
    	return true;
    }
    
    public function onSelect() {
        return true;
    }
    
}
