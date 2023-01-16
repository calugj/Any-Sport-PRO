import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;

public class MenuBuilder {

    

    public function initialize() {
    }


    public function saveMenu(focus) {
        if(System.getDeviceSettings().isTouchScreen) { focus--; }
        
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.menuEndSession_title), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.menu_continue), null, :back, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.menu_save), null, :save, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.menu_discard), null, :delete, {} ) );

        return menu;
    }








// MainMenu

    public function mainMenu(focus) {        
        var activityName = getPropertyString("ActivityName", "null");
        var numberOfPages = getPropertyNumber("NumberOfPages", 3).toString() + " " + WatchUi.loadResource(Rez.Strings.Pages);
        var theme = getPropertyNumber("Theme", 1);
        if(theme == 0) {theme = WatchUi.loadResource(Rez.Strings.dark);} else {theme = WatchUi.loadResource(Rez.Strings.light);}
        var backlight = getPropertyFloat("Backlight", 0.0) == 1.0;
        var backlightString;
        if(!backlight) {backlightString = WatchUi.loadResource(Rez.Strings.off);} else {backlightString = WatchUi.loadResource(Rez.Strings.sub_backlight);}
        var disableGesture = getPropertyBoolean("DisableGesture", false);
        var active = getPropertyBoolean("Autolap", false);
        if(active) {active = WatchUi.loadResource(Rez.Strings.menu_autolap) + " " + WatchUi.loadResource(Rez.Strings.active);} else {active = null;}
        var paceUnits = getPropertyBoolean("PaceUnits500", false);
        if(System.getDeviceSettings().paceUnits == System.UNIT_METRIC) {
            if(paceUnits) {paceUnits = "500 m";} else {paceUnits = "1000 m";}
        } else {
            if(paceUnits) {paceUnits = "0.5 mi";} else {paceUnits = "1.0 mi";}
        }
        var satellites = getPropertyNumber("Satellites", 1);
        if(satellites == 0) {satellites = WatchUi.loadResource(Rez.Strings.NOsatellites);}
        else if(satellites == 1 || satellites == 2 || satellites == 6) {satellites = "GPS";}
        else if(satellites == 3 || satellites == 7) {satellites = "GPS + GLONASS";}
        else if(satellites == 4 || satellites == 8) {satellites = "GPS + GALILEO";}
        else if(satellites == 5) {satellites = "GPS + GLONASS + GALILEO";}
        else if(satellites == 9) {satellites = "GPS + BEIDOU";}
        else if(satellites == 10) {satellites = "All Systems";}
        else if(satellites == 11) {satellites = "All Systems + Dual Band";}
        else if(satellites == 12) {satellites = "SAT IQ";}
        var autopause = getPropertyBoolean("Autopause", false);
        var version = WatchUi.loadResource(Rez.Strings.version);


        var menu = new WatchUi.Menu2({:title=> new DrawableMenuTitle(), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.ActivityType), activityName, :activity, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.dataFields), numberOfPages, :datafields, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.menu_satellites_selection), satellites, :satellites, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.menu_lap), active, :lap, {} ) );
        menu.addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.autopause), null, :autopause, autopause, {} ) );
        if(Toybox.System.DeviceSettings has :requiresBurnInProtection && !(System.getDeviceSettings().requiresBurnInProtection)) {
            menu.addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.menu_backlight), backlightString, :backlight, backlight, {} ) );
        }
        if(Toybox.System.DeviceSettings has :requiresBurnInProtection && System.getDeviceSettings().requiresBurnInProtection) {
            menu.addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.disableGesture), WatchUi.loadResource(Rez.Strings.experimental), :gesture, disableGesture, {} ) );
        }
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.theme), theme, :theme, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.paceUnits), paceUnits, :paceunits, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.about), version, :about, {} ) );
        
        return menu;
    }





//Activities

    public function activityCategoryMenu(focus) {
        var category = WatchUi.loadResource(Rez.Strings.Category);

        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.ActivityType), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Running), category, :running, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Cycling), category, :cycling, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.FitnessEquipment), category, :fitnessequipment, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Swimming), category, :swimming, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Field), category, :field, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Training), category, :training, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Walking), category, :walking, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.WinterSports), category, :wintersports, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.WaterSports), category, :watersports, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Flying), category, :flying, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Motor), category, :motor, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.RockClimbing), category, :rockclimbing, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Diving), category, :diving, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Extra), category, :extra, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Custom), category, :custom, {} ) );

        return menu;
    }

    public function runningMenu(focus) {
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.Running), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Running), null, "1.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Trail), null, "1.3", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Ultra), null, "1.67", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Treadmill), null, "1.1", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Street), null, "1.2", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Track), null, "1.4", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.IndoorRunning), null, "1.5", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.VirtualRun), null, "1.58", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.ObstacleRun), null, "1.59", {} ) );

        return menu;
    }

    public function cyclingMenu(focus) {
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.Cycling), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Cycling), null, "2.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Mountain), null, "2.8", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Road), null, "2.7", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.GravelCycling), null, "2.46", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Spin), null, "2.5", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.IndoorCycling), null, "2.6", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.TrackCycling), null, "2.13", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.BMX), null, "2.29", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.EBikeFitness), null, "21.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.EBikeMountain), null, "2.47", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.AdventureRace), null, "2.82", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Cyclocross), null, "2.11", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.MixedSurface), null, "2.49", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Commuting), null, "2.48", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Recumbent), null, "2.10", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Downhill), null, "2.9", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.VirtualBike), null, "2.58", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.HandCycling), null, "2.12", {} ) );





        return menu;
    }

    public function fitnessEquipmentMenu(focus) {
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.FitnessEquipment), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.FitnessEquipment), null, "4.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Treadmill), null, "4.1", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.IndoorCycling), null, "4.6", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.IndoorRowing), null, "4.14", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Elliptical), null, "4.15", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.StairClimbing), null, "4.16", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.IndoorSkiing), null, "4.25", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.IndoorWalking), null, "4.27", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Pilates), null, "4.44", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.FloorClimbing), null, "48.0", {} ) );


        return menu;
    }

    public function swimmingMenu(focus) {
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.Swimming), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Swimming), null, "5.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.LapSwimming), null, "5.15", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.OpenWater), null, "5.18", {} ) );

        return menu;
    }

    public function fieldMenu(focus) {
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.Field), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Soccer), null, "7.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Basketball), null, "6.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Tennis), null, "8.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Volleyball), null, "75.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Cricket), null, "71.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Rugby), null, "72.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.AmericanFootball), null, "8.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Baseball), null, "49.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.SoftballFastPitch), null, "50.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.SoftballSlowPitch), null, "51.0", {} ) );

        return menu;
    }

    public function trainingMenu(focus) {
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.Training), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Training), null, "10.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.FlexibilityTraining), null, "10.19", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.StrengthTraining), null, "10.20", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Yoga), null, "10.43", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.HIIT), null, "62.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Breathing), null, "10.62", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.AMRAP), null, "10.73", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.EMOM), null, "10.74", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.TABATA), null, "10.75", {} ) );

        return menu;
    }

    public function walkingMenu(focus) {
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.Walking), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Hiking), null, "17.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Mountaineering), null, "16.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Walking), null, "11.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.SpeedWalking), null, "11.31", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.IndoorWalking), null, "11.27", {} ) );

        return menu;
    }

    public function winterSportsMenu(focus) {
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.WinterSports), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.WinterSports), null, "58.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.AlpineSkiing), null, "13.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Classic), null, "12.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.SkateSkiing), null, "12.42", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.BackcountrySkiing), null, "13.37", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.ResortSkiing), null, "13.38", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Snowboarding), null, "14.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.BackcountrySnowboarding), null, "14.37", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.ResortSnowboarding), null, "14.38", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Snowshoeing), null, "35.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.IceSkating), null, "33.0", {} ) );

        return menu;
    }

    public function waterSportsMenu(focus) {
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.WaterSports), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Surfing), null, "38.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Rowing), null, "15.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Paddling), null, "19.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Kayaking), null, "41.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.WhitewaterKayaking), null, "41.41", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Rafting), null, "42.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.WhitewaterRafting), null, "42.41", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.StandUpPaddleboarding), null, "37.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Windsurfing), null, "43.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Kitesurfing), null, "44.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Sailing), null, "32.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.SailRace), null, "32.65", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.WaterTubing), null, "76.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Wakesurfing), null, "77.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Wakeboarding), null, "39.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.WaterSkiing), null, "40.0", {} ) );



        return menu;
    }

    public function flyingMenu(focus) {
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.Flying), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Flying), null, "20.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Wingsuit), null, "20.40", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.HangGliding), null, "26.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Jumpmaster), null, "46.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.RCDrone), null, "20.39", {} ) );


        return menu;
    }

    public function motorMenu(focus) {
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.Motor), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Motorcycling), null, "22.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Motocross), null, "22.36", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Snowmobiling), null, "36.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.ATV), null, "22.35", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.AutoRacing), null, "57.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Driving), null, "24.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Boating), null, "23.0", {} ) );

        return menu;
    }

    public function climbingMenu(focus) {
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.RockClimbing), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.RockClimbing), null, "31.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.IndoorClimbing), null, "31.68", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Bouldering), null, "31.69", {} ) );

        return menu;
    }

    public function divingMenu(focus) {
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.Diving), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Diving), null, "53.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.SingleGas), null, "53.53", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.MultiGas), null, "53.54", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.GaugeDiving), null, "53.55", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.ApneaDiving), null, "53.56", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.ApneaHunting), null, "53.57", {} ) );

        return menu;
    }

    public function extraMenu(focus) {
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.Extra), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.InlineSkating), null, "30.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.OffshoreGrinding), null, "59.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.OnshoreGrinding), null, "59.71", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.eSport), null, "63.77", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Tactical), null, "45.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Boxing), null, "47.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Shooting), null, "56.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Golf), null, "25.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.HorsebackRiding), null, "27.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Hunting), null, "28.0", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.HuntingDogs), null, "28.72", {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Fishing), null, "29.0", {} ) );

        return menu;
    }

    public function customMenu(focus) {
        var activityType1 = getPropertyNumber("CustomActivityType1", 0);
        var subSport1 = getPropertyNumber("CustomSubSport1", 0);
        var activityName1 = getPropertyString("CustomActivityName1", "Custom 1");
        
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.Custom), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(activityName1, "Sport: " + activityType1 + "  Subsport: " + subSport1, activityType1.toString() + "." + subSport1, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Customize), null, :edit, {} ) );

        return menu;
    }

    public function customizeMenu(focus) {
        var activityName1 = getPropertyString("CustomActivityName1", "Custom 1");
        var activityType1 = getPropertyNumber("CustomActivityType1", 0);
        var subSport1 = getPropertyNumber("CustomSubSport1", 0);
        
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.Customize), :focus => focus});
        menu.addItem(new WatchUi.MenuItem("Name:", activityName1, :name, {} ) );
        menu.addItem(new WatchUi.MenuItem("Sport: " + activityType1, WatchUi.loadResource(Rez.Strings.know), :sport, {} ) );
        menu.addItem(new WatchUi.MenuItem("Subsport: " + subSport1, WatchUi.loadResource(Rez.Strings.know), :subsport, {} ) );

        return menu;
    }



// Fields

    public function pageSelectorMenu(focus) {
        var numberOfPages = getPropertyNumber("NumberOfPages", 3);
        var numberOfPagesString = numberOfPages + " ";
        if(numberOfPages == 1) { numberOfPagesString += WatchUi.loadResource(Rez.Strings.Page); } else { numberOfPagesString += WatchUi.loadResource(Rez.Strings.Pages); }
        
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.Pages), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.NumberOfPages), numberOfPagesString, :numberofpages, {} ) );
        for(var i = 1 ; i <= numberOfPages ; i++ ) {
            var fieldNumber = getPropertyNumber("FieldsPage" + i.toString(), 4);
            var fieldNumberString = fieldNumber + " ";
            if (fieldNumber == 1) { fieldNumberString += WatchUi.loadResource(Rez.Strings.dataField); } else { fieldNumberString += WatchUi.loadResource(Rez.Strings.dataFields); }
            menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Page) + " " + i, fieldNumberString, i, {} ) );
        }

        return menu;
    }

    public function pageMenu(focus, page) {
        var fieldNumber = getPropertyNumber("FieldsPage" + page.toString(), 4);
        var fieldNumberString = fieldNumber + " ";
        if (fieldNumber == 1) { fieldNumberString += WatchUi.loadResource(Rez.Strings.dataField); } else { fieldNumberString += WatchUi.loadResource(Rez.Strings.dataFields); }

        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.Page) + " " + page, :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.NumberOfFields), fieldNumberString, :numberoffields, {} ) );

        for(var i = 1 ; i <= fieldNumber ; i++) {
            var fieldId = getPropertyNumber(page.toString() + i.toString(), 1);
            menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.Field) + " " + i.toString(), stringGetter.getString(fieldId), i.toString(), {} ) );
        }
        

        return menu;
    }

    public function fieldsMenu(focus) {
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.dataField) , :focus => focus});

        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.timer),null,1,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.timerLap),null,2,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.distance),null,3,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.distanceLap),null,4,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.heartRate),null,5,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.avgHR),null,14,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.maxHR),null,15,{}));
        menu.addItem(new WatchUi.MenuItem("% "+ WatchUi.loadResource(Rez.Strings.maxHR),null,35,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.pace),null,6,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.avgPace),null,13,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.maxPace),null,11,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.avgLapPace),null,18,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.speed),null,9,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.avgSpeed),null,12,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.maxSpeed),null,10,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.avgLapSpeed),null,19,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.menu_lap),null,36,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.calories),null,8,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.caloriez),null,16,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.cadence),null,17,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.altitude),null,20,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.totalAscent),null,21,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.totalDescent),null,22,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.heading),null,7,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.battery),null,32,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.accuracy),null,33,{}));

        if(Toybox has :Weather) {
        	menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.temperature),null,23,{}));
        	menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.feelsLike),null,25,{}));
        	menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.windSpeed),null,24,{}));
        	menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.windBearing),null,26,{}));
        	menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.humidity),null,27,{}));
        	menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.lowHigh),null,28,{}));
        
		}
		if(Toybox.Activity.Info has :ambientPressure) {
		    menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.ambientPressure),null,29,{}));
		}
		if(Toybox.Activity.Info has :currentOxygenSaturation) {
		    menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.oxygen),null,30,{}));
		}
		menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.time),null,31,{}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.trainingEffect),null,34,{}));

        return menu;
    }





// Satellites

    public function satellitesMenu(focus) {
        var GPSCompatibility = checkSatellitesCompatibility();

        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.menu_satellites_selection), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.NOsatellites), null, 0, {} ) );
        
        // GPS
        if(GPSCompatibility[6]){
            menu.addItem(new WatchUi.MenuItem("GPS", null, 6, {} ) );
        } else if(GPSCompatibility[2]) {
            menu.addItem(new WatchUi.MenuItem("GPS", null, 2, {} ) );
        } else if(GPSCompatibility[1]) {
            menu.addItem(new WatchUi.MenuItem("GPS", null, 1, {} ) );
        }

        // GPS GLONASS
        if(GPSCompatibility[7]){
            menu.addItem(new WatchUi.MenuItem("GPS + GLONASS", null, 7, {} ) );
        } else if(GPSCompatibility[3]) {
            menu.addItem(new WatchUi.MenuItem("GPS + GLONASS", null, 3, {} ) );
        }

        // GPS GALILEO
        if(GPSCompatibility[8]){
            menu.addItem(new WatchUi.MenuItem("GPS + GALILEO", null, 8, {} ) );
        } else if(GPSCompatibility[4]) {
            menu.addItem(new WatchUi.MenuItem("GPS + GALILEO", null, 4, {} ) );
        }

        // GPS GLONASS GALILEO
        if(GPSCompatibility[5]){
            menu.addItem(new WatchUi.MenuItem("GPS + GLONASS + GALILEO", null, 5, {} ) );
        }

        // GPS BEIDOU
        if(GPSCompatibility[9]){
            menu.addItem(new WatchUi.MenuItem("GPS + BEIDOU", null, 9, {} ) );
        }

        // ALL SYSTEMS
        if(GPSCompatibility[10]){
            menu.addItem(new WatchUi.MenuItem("All Systems", null, 10, {} ) );
        }

        // ALL SYSTEMS + Dual Band
        if(GPSCompatibility[11]){
            menu.addItem(new WatchUi.MenuItem("All Systems + Dual Band", null, 11, {} ) );
        }

        // SAT IQ
        if(GPSCompatibility[12]){
            menu.addItem(new WatchUi.MenuItem("SAT IQ", null, 12, {} ) );
        }


        return menu;
    }








// Lap

    public function lapMenu(focus) {
        var autolap = getPropertyBoolean("Autolap", false);
        if(autolap) {
            var value = getPropertyFloat("AutolapValue", 1.0);
            autolap = value.format("%1.2f");
            if(System.getDeviceSettings().distanceUnits == System.UNIT_METRIC) {
                autolap += " km";
            } else {
                autolap += " mi";
            }
        } else {autolap = WatchUi.loadResource(Rez.Strings.off);}


        var lapbutton = getPropertyBoolean("lapbutton", true);
        var lapPage = getPropertyNumber("LapPage", 2);
        if(lapPage == 0) {lapPage = WatchUi.loadResource(Rez.Strings.off);} else if(lapPage == 1) {
            var field = getPropertyNumber("LapData", 1);
            lapPage = lapPage.toString() + " " + WatchUi.loadResource(Rez.Strings.second) + " - " + stringGetter.getString(field);
        } else {
            var field = getPropertyNumber("LapData", 1);
            lapPage = lapPage.toString() + " " + WatchUi.loadResource(Rez.Strings.seconds) + " - " + stringGetter.getString(field);
        }

        


        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.menu_lap), :focus => focus});
        menu.addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.lapbutton), null, :lapbutton, lapbutton, {}));
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.menu_autolap), autolap, :autolap, {} ) );
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.menu_lapScreen), lapPage , :lapscreen, {} ) );

        return menu;
    }

    public function autolapMenu(focus) {
        var active = getPropertyBoolean("Autolap", false);
        var value = getPropertyFloat("AutolapValue", 1.0);

        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.menu_autolap), :focus => focus});
        menu.addItem(new WatchUi.ToggleMenuItem(WatchUi.loadResource(Rez.Strings.active), null, :active, active, {}));
        if(active) {
            var string = value.format("%1.2f");
            var metric = System.getDeviceSettings().distanceUnits;
            if(metric == System.UNIT_METRIC) {
                string += " km";
            } else {
                string += " mi";
            }
            menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.autolapValue), string, :value, {} ) );
        }

        return menu;

    }

    public function lapPageMenu(focus) {
        var value = getPropertyNumber("LapPage", 2);
        var field = getPropertyNumber("LapData", 1);
        if(value == 0) {value = "OFF";} else if(value == 1) {value = value.toString() + " " + WatchUi.loadResource(Rez.Strings.second); } else { value = value.toString() + " " + WatchUi.loadResource(Rez.Strings.seconds); }

        
        var menu = new WatchUi.Menu2({:title=>WatchUi.loadResource(Rez.Strings.menu_lapScreen), :focus => focus});
        menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.menu_lapScreenValue), value, :value, {} ) );
        if(getPropertyNumber("LapPage", 2) > 0) {
            menu.addItem(new WatchUi.MenuItem(WatchUi.loadResource(Rez.Strings.menu_lapScreenField), stringGetter.getString(field), :field, {} ) );
        }

        return menu;
    }


}








public class DrawableMenuTitle extends WatchUi.Drawable {

    public function initialize() {
        Drawable.initialize({});
    }

    public function draw(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var btmpw = WatchUi.loadResource(Rez.Drawables.LauncherIcon).getWidth();
        dc.drawBitmap(dc.getWidth() - btmpw , dc.getHeight()/2 - btmpw/2, WatchUi.loadResource(Rez.Drawables.LauncherIcon));
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(0, dc.getHeight()/2 - dc.getFontHeight(Graphics.FONT_XTINY)*0.55, Graphics.FONT_XTINY, "Any Sport", Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(0, dc.getHeight()/2 + dc.getFontHeight(Graphics.FONT_XTINY)*0.5, Graphics.FONT_XTINY, "PRO", Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}