using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Time.Gregorian as Cal;
using Toybox.Application as App;

class arcsinView extends Ui.WatchFace {
    var r;
    var is12;
    var atime = true;
    var adate = true;
    var aday = false;
    var marks = true;
    var short = false;
    var on = true;
    var load = true;
    var s;
    var all;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        r = dc.getWidth() >> 1;
    }

    function onShow() {
    }

    function onUpdate(dc) {
        if (load) {
            loadSet();
            load = false;
        }
        //atime = false;
        bg(dc);
        if (atime) {
            atimes(dc);
        } else {
            times(dc);
        }
    }

    function bg(dc) {
        dc.setColor(0, Gfx.COLOR_BLACK);
        dc.clear();
    }

    function times(dc) {
        var now = Cal.info(Time.now(), Time.FORMAT_SHORT);
        var ho = now.hour;
        var mi = now.min;
        if (is12 && ho > 12) {
            ho = ho - 12;
        }
        hours(dc, ho);
        mins(dc, mi);
        if (adate || on) {
            var d = now.day;
            var m = now.month;
            if (d < 10) {
                rpad(dc, d%10, 88, 1, -78);
            } else {
                lpad(dc, d%10, 108, 1, -78);
                rpad(dc, d/10, 108, 1, -78);
            }
            if (m < 10) {
                lpad(dc, m%10, 78, 1, 78);
            } else {
                lpad(dc, m%10, 108, 1, 78);
                rpad(dc, 1, 108, 1, 78);
            }
        }
    }

    function atimes(dc) {
        if (marks || on || all) {
            dc.setPenWidth(5);
            dc.setColor(Gfx.COLOR_WHITE, -1);
            for (var i = 0; i < 60; i++) {
                if (i%5 == 0) {
                    dc.drawArc(r, r, r - 8, 1, i*6+1, i*6-1);
                }
                dc.drawArc(r, r, r - 2, 1, i*6+1, i*6-1);
            }
        }
        var now = Cal.info(Time.now(), Time.FORMAT_SHORT);
        if ((on && adate) || all) {
            dc.setColor(Gfx.COLOR_WHITE, -1);
            var d = now.day;
            var m = now.month;
            if (d < 10) {
                rpad(dc, d%10, 78, 1.5, -38);
            } else {
                rpad(dc, d%10, 48, 1.5, -38);
                rpad(dc, d/10, 108, 1.5, -38);
            }
            if (m < 10) {
                lpad(dc, m%10, 78, 1.5, 14);
            } else {
                lpad(dc, m%10, 108, 1.5, 14);
                lpad(dc, 1, 48, 1.5, 14);
            }
        }
        if ((on && aday) || all) {
            rpad(dc, now.day_of_week + 10, 104, 1, 60);
        }
        var mi = now.min/60.0;
        var ho = 90.0 - 360*(now.hour%12)/12.0 - 30*mi;
        mi = 90.0 - mi*360;
        if ((on && short)) {
            dc.setPenWidth(29);
            if (Sys.getSystemStats().battery < 15) {
                dc.setColor(Gfx.COLOR_RED, -1);
            } else {
                dc.setColor(Gfx.COLOR_LT_GRAY, -1);
            }
            dc.drawArc(r, r, r - 28, 0, ho - 1.0, ho + 1.0);
            if (Sys.getDeviceSettings().notificationCount) {
                dc.setColor(~Gfx.COLOR_YELLOW, -1);
            } else {
                dc.setColor(Gfx.COLOR_YELLOW, -1);
            }
            dc.drawArc(r, r, r - 17, 0, mi - 1.0, mi + 1.0);
        } else {
            dc.setPenWidth(59); //99
            if (Sys.getSystemStats().battery < 15) {
                dc.setColor(Gfx.COLOR_RED, -1);
            } else {
                dc.setColor(Gfx.COLOR_LT_GRAY, -1);
            }
            dc.drawArc(r, r, r - 42, 0, ho - 1.0, ho + 1.0);
            dc.setPenWidth(99);
            if (Sys.getDeviceSettings().notificationCount) {
                dc.setColor(~Gfx.COLOR_YELLOW, -1);
            } else {
                dc.setColor(Gfx.COLOR_YELLOW, -1);
            }
            dc.drawArc(r, r, r - 27, 0, mi - 1.0, mi + 1.0);
        }
        if (on && s) {
            var sec = 90 - now.sec*6;
            dc.setPenWidth(99);
            dc.setColor(Gfx.COLOR_GREEN, -1);
            dc.drawArc(r, r, r - 27, 0, sec - 1.0, sec + 1.0);
        }
    }

    function hours(dc, ho) {
        lpad(dc, ho/10, 0, 3.5, 0);
        lpad(dc, ho%10, 48, 3.8, 0);
    }

    function mins(dc, mi) {
        rpad(dc, mi/10, 48, 4, 0);
        rpad(dc, mi%10, 0, 3.8, 0);
    }

    // left of center, hours
    function lpad(dc, ho, pad, mul, y) {
        dc.setColor(Gfx.COLOR_WHITE, -1);
        if (ho != 1) {
            dc.setPenWidth(43);
            dc.drawArc(r*mul + pad, r + y, r*mul - 32, 0, 172, 188);
            dc.setColor(0, -1);
        }
        if (ho == 0) {
            dc.setPenWidth(30);
            dc.drawArc(r*mul + pad, r + y, r*mul - 35, 0, 174, 186);
        } else if (ho == 1) {
            dc.setPenWidth(11);
            dc.drawArc(r*mul + pad, r + y, r*mul - 32, 0, 172, 188);
        } else if (ho == 2) {
            dc.setPenWidth(37);
            dc.drawArc(r*mul + pad, r + y, r*mul - 29, 0, 174, 179);
            dc.drawArc(r*mul + pad, r + y, r*mul - 35, 0, 180, 186);
        } else if (ho == 3) {
            dc.setPenWidth(37);
            dc.drawArc(r*mul + pad, r + y, r*mul - 29, 0, 174, 179);
            dc.drawArc(r*mul + pad, r + y, r*mul - 29, 0, 180, 186);
        } else if (ho == 4) {
            dc.setPenWidth(30);
            dc.drawArc(r*mul + pad, r + y, r*mul - 35, 0, 171, 179);
            dc.setPenWidth(37);
            dc.drawArc(r*mul + pad, r + y, r*mul - 29, 0, 180, 189);
        } else if (ho == 5) {
            dc.setPenWidth(37);
            dc.drawArc(r*mul + pad, r + y, r*mul - 35, 0, 174, 179);
            dc.drawArc(r*mul + pad, r + y, r*mul - 29, 0, 180, 186);
        } else if (ho == 6) {
            dc.setPenWidth(37);
            dc.drawArc(r*mul + pad, r + y, r*mul - 35, 0, 171, 179);
            dc.setPenWidth(30);
            dc.drawArc(r*mul + pad, r + y, r*mul - 35, 0, 180, 186);
        } else if (ho == 7) {
            dc.setPenWidth(37);
            dc.drawArc(r*mul + pad, r + y, r*mul - 29, 0, 174, 189);
        } else if (ho == 8) {
            dc.setPenWidth(30);
            dc.drawArc(r*mul + pad, r + y, r*mul - 35, 0, 174, 179);
            dc.drawArc(r*mul + pad, r + y, r*mul - 35, 0, 180, 186);
        } else if (ho == 9) {
            dc.setPenWidth(30);
            dc.drawArc(r*mul + pad, r + y, r*mul - 35, 0, 174, 179);
            dc.setPenWidth(37);
            dc.drawArc(r*mul + pad, r + y, r*mul - 29, 0, 180, 186);
        } else if (ho == 11) {
            dc.setPenWidth(30);
            dc.drawArc(r*mul + pad, r + y, r*mul - 35, 0, 171, 186);
        } else if (ho == 12) {
            dc.setPenWidth(27);
            dc.drawArc(r*mul + pad, r + y, r*mul - 35, 0, 174, 186);
            dc.drawArc(r*mul + pad, r + y, r*mul - 20, 0, 174, 187);
        } else if (ho == 14) {
            dc.setPenWidth(37);
            dc.drawArc(r*mul + pad, r + y, r*mul - 35, 0, 174, 179);
            dc.drawArc(r*mul + pad, r + y, r*mul - 35, 0, 180, 186);
        } else if (ho == 15) {
            dc.setPenWidth(30);
            dc.drawArc(r*mul + pad, r + y, r*mul - 35, 0, 171, 179);
            dc.drawArc(r*mul + pad, r + y, r*mul - 35, 0, 180, 188);
        } else if (ho == 16) {
            dc.setPenWidth(30);
            dc.drawArc(r*mul + pad, r + y, r*mul - 35, 0, 174, 179);
            dc.setPenWidth(26);
            dc.drawArc(r*mul + pad, r + y, r*mul - 33, 0, 180, 188);
            dc.setPenWidth(8);
            dc.drawArc(r*mul + pad, r + y, r*mul - 53, 0, 180, 189);
        } else if (ho == 17) {
            dc.setPenWidth(30);
            dc.drawArc(r*mul + pad, r + y, r*mul - 35, 0, 174, 179);
            dc.drawArc(r*mul + pad, r + y, r*mul - 35, 0, 180, 188);
        }
    }

    // right of center
    function rpad(dc, ho, pad, mul, y) {
        dc.setColor(Gfx.COLOR_WHITE, -1);
        if (ho != 1) {
            dc.setPenWidth(43);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 32, 1, 8, 352);
            dc.setColor(0, -1);
        }
        if (ho == 0) {
            dc.setPenWidth(30);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 35, 1, 6, 354);
        } else if (ho == 1) {
            dc.setPenWidth(11);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 32, 1, 8, 352);
        } else if (ho == 2) {
            dc.setPenWidth(37);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 35, 1, 6, 1);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 29, 1, 0, 354);
        } else if (ho == 3) {
            dc.setPenWidth(37);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 35, 1, 6, 1);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 35, 1, 0, 354);
        } else if (ho == 4) {
            dc.setPenWidth(30);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 35, 1, 9, 1);
            dc.setPenWidth(37);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 35, 1, 0, 351);
        } else if (ho == 5) {
            dc.setPenWidth(37);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 29, 1, 6, 1);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 35, 1, 0, 354);
        } else if (ho == 6) {
            dc.setPenWidth(37);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 35, 1, 9, 1);
            dc.setPenWidth(30);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 35, 1, 0, 354);
        } else if (ho == 7) {
            dc.setPenWidth(37);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 35, 1, 6, 351);
        } else if (ho == 8) {
            dc.setPenWidth(30);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 35, 1, 6, 1);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 35, 1, 0, 354);
        } else if (ho == 9) {
            dc.setPenWidth(30);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 35, 1, 6, 1);
            dc.setPenWidth(37);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 35, 1, 0, 354);
        } else if (ho == 11) {
            rpad(dc, 5, pad, mul, y);
            lpad(dc, 11, pad, mul, y);
        } else if (ho == 12) {
            dc.setPenWidth(10);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 45, 1, 6, 351);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 25, 1, 6, 351);
            lpad(dc, 0, pad, mul, y);
        } else if (ho == 13) {
            dc.setPenWidth(17);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 48, 1, 6, 351);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 16, 1, 6, 351);
            lpad(dc, 11, pad, mul, y);
        } else if (ho == 14) {
            dc.setPenWidth(10);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 45, 1, 9, 354);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 25, 1, 9, 354);
            lpad(dc, 14, pad, mul, y);
        } else if (ho == 15) {
            dc.setPenWidth(17);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 48, 1, 6, 351);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 16, 1, 6, 351);
            lpad(dc, 15, pad, mul, y);
        } else if (ho == 16) {
            dc.setPenWidth(37);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 25, 1, 6, 1);
            dc.drawArc(r*(2-mul) - pad, r + y, r*mul - 25, 1, 0, 351);
            lpad(dc, 16, pad, mul, y);
        } else if (ho == 17) {
            rpad(dc, 5, pad, mul, y);
            lpad(dc, 17, pad, mul, y);
        }
        dc.setColor(Gfx.COLOR_WHITE, -1);
    }

    function onHide() {
    }

    function onExitSleep() {
        on = true;
    }

    function onEnterSleep() {
        on = false;
    }

    function loadSet() {
        var app = App.getApp();
        atime = app.getProperty("a");
        adate = app.getProperty("adate");
        aday = app.getProperty("aday");
        marks = app.getProperty("marks");
        s = app.getProperty("s");
        short = app.getProperty("sh");
        all = app.getProperty("all");
        is12 = !Sys.getDeviceSettings().is24Hour;
    }
}
