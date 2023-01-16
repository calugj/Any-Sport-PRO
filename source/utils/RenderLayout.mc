import Toybox.Graphics;
import Toybox.System;
import Toybox.Attention;

public class RenderLayout {
    
    private var height;
    private var width;
    private var screenShape;
    private var foregroundColor;
    private var backgroundColor;
    private var accentColor;
    
    
    public function initialize() {
        height = System.getDeviceSettings().screenHeight;
        width = System.getDeviceSettings().screenWidth;
        screenShape = System.getDeviceSettings().screenShape;
    }



    public function update() {
        var theme = getPropertyNumber("Theme", 1);

        if(theme == 0) {
            backgroundColor = Graphics.COLOR_BLACK;
            accentColor = Graphics.COLOR_DK_GREEN;
        } else {
            backgroundColor = Graphics.COLOR_WHITE;
            accentColor = 0x005500;
        }

    }


    


    private function clearScreen(dc as Graphics.Dc) {
        dc.setColor(backgroundColor, backgroundColor);
        dc.clear();
    }
    



    public function sixFields(dc as Graphics.Dc) {
        clearScreen(dc);
        
        dc.setColor(accentColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawLine(0, height/4, width, height/4);
        dc.drawLine(0, height/2, width, height/2);
        dc.drawLine(0, height*3/4, width, height*3/4);
        dc.drawLine(width/2, height/4, width/2, height*3/4);

        dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(dc.getWidth()/12);
        dc.drawCircle(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2);
    }

    public function fiveFields(dc as Graphics.Dc) {
        clearScreen(dc);

        dc.setColor(accentColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawLine(0, height/4, width, height/4);
        dc.drawLine(0, height/2, width, height/2);
        dc.drawLine(0, height*3/4, width, height*3/4);
        dc.drawLine(width/2, height/2, width/2, height*3/4);

        dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(dc.getWidth()/12);
        dc.drawCircle(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2);
    }

    public function fourFields(dc as Graphics.Dc) {
        clearScreen(dc);

        dc.setColor(accentColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawLine(0, height/3, width, height/3);
        dc.drawLine(0, height*2/3, width, height*2/3);
        dc.drawLine(width/2, height/3, width/2, height*2/3);

        dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(dc.getWidth()/12);
        dc.drawCircle(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2);
    }

    public function threeFields(dc as Graphics.Dc) {
        clearScreen(dc);

        dc.setColor(accentColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawLine(0, height/3, width, height/3);
        dc.drawLine(0, height*2/3, width, height*2/3);

        dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(dc.getWidth()/12);
        dc.drawCircle(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2);
    }

    public function twoFields(dc as Graphics.Dc) {
        clearScreen(dc);

        dc.setColor(accentColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawLine(0, height/2, width, height/2);

        dc.setColor(backgroundColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(dc.getWidth()/12);
        dc.drawCircle(dc.getWidth()/2, dc.getHeight()/2, dc.getWidth()/2);
    }

    public function oneField(dc as Graphics.Dc) {
        clearScreen(dc);
    }


}