package 
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import gbl.*;
    import gbl.perso.*;
    import globz.*;
    import menu.*;
    import menu.screens.*;
    import sparks.*;
    import tools.*;

    final public class Global extends Object
    {
        public static var vDebug:Boolean = false;
        public static var vBotOffline:Boolean = false;
        public static var vDev:Boolean = false;
        public static var vResolutionForced:Boolean = false;
        public static var vServerPreview:Boolean = true;
        public static var vInAppSandBox:Boolean = true;
        public static var vGlobzPing:Boolean = false;
        public static var vAutolog:Boolean = false;
        public static var vAutologName:String = "";
        public static var vAutoLaunch:Boolean = true;
        public static var vFakeLevel:int = 0;
        public static var vLogTrace:String = "";
        public static var vLogInfo:Boolean = false;
        public static var vLogTraceLastSecond:String = "";
        public static var vCustomPing:Boolean = false;
        public static var vMatchRunning:String = "0";
        public static var SO_ID:String = "GF_SO_1_0_0";
        public static var vRoot:Main;
        public static var vVersion:String = "nc";
        public static var vServer:Sparks;
        public static var vLang:Lang;
        public static var vLangOpen:Array = ["en", "fr", "de", "it", "ja", "ko", "pt", "ru", "zh", "es"];
        public static var vStats:GAStats;
        public static var vIOSVersion:int = -1;
        public static var vForceLog:String = "";
        public static var vMyFacebook:MyFacebook;
        public static var vMyInApp:MyInApp;
        public static var vTopBar:TopBar;
        public static var vLoadingGlobe:LoadingGlobe;
        public static var vImages:Object;
        public static var vSound:SoundList;
        public static var v169e:Boolean = false;
        public static var vServerPreviewFlag:Boolean = true;
        public static var vClientTrace:MyLogTrace;
        public static var vGoldConfirmation:Boolean = true;
        public static var vExchangeRate:int = 10;
        public static var vGeneralMessageTab:Array;
        public static var vGeneralMessagePerso:String;
        public static var vGeneralMessageLastLoad:Number = 0;
        public static var vReplayPrice:int = 10;
        public static var vConsecutiveWins:Array;
        public static var vMyPushNotification:MyPushNotification;
        public static var vNewShopCard:Boolean = false;
        public static var vFakeStartMin:int = 5;
        public static var vFakeStartMax:int = 30;
        public static var vGame:GBL_Main;
        public static var vPseudo:String = "";
        public static var vAiming:Boolean = false;
        public static var vPersoTab:Array = [GBL_Perso_Simple, GBL_Perso_Puppet];
        public static var vPersoType:int = 1;
        public static var vInitiative:Boolean = false;
        public static var vKick:Boolean = false;
        public static var vHitPoints:Boolean = true;
        public static var vRewardAfterGame:Object;
        public static var vErgoReverse:Boolean = false;
        public static var vWeather:int = 1;
        public static var vWeatherSave:Object;
        public static var vSize:Point = new Point(640, 960);
        public static var vResolution:Number = 1;
        public static var vScreenDelta:Point;
        public static var vSWFLoader:Loader;
        public static var vSWFImages:Object;

        public function Global()
        {
            return;
        }// end function

        public static function addEventTrace(param1:String) : void
        {
            return;
        }// end function

        public static function addLogTrace(param1:String, param2:String = "") : void
        {
            var _loc_6:* = null;
            if (!vDebug)
            {
                return;
            }
            if (param1.indexOf("header") >= 0)
            {
                param1 = "\'Header\'>trace muted";
                return;
            }
            var _loc_3:* = "";
            if (param2 != "")
            {
                _loc_3 = param2;
            }
            else if (Global.vRoot.vMenu != null)
            {
                if (Global.vRoot.vMenu.vTag != "")
                {
                    _loc_3 = Global.vRoot.vMenu.vTag;
                }
            }
            if (_loc_3 != "")
            {
                param1 = "[" + _loc_3 + "] " + param1;
            }
            var _loc_4:* = Toolz.getDate(false);
            if (vLogTraceLastSecond == "")
            {
                vLogTraceLastSecond = _loc_4;
            }
            if (_loc_4 != vLogTraceLastSecond)
            {
                _loc_6 = "-------------------------";
                vLogTrace = vLogTrace + (_loc_6 + "\n");
                vLogTraceLastSecond = _loc_4;
            }
            var _loc_5:* = _loc_4 + " " + param1;
            param1 = Toolz.getDate(false) + " " + param1;
            if (!vLogInfo)
            {
                return;
            }
            vLogTrace = vLogTrace + (param1 + "\n");
            return;
        }// end function

        public static function getText(param1:String, param2:Boolean = true) : String
        {
            if (vLang == null)
            {
                return "[" + param1 + "]";
            }
            return vLang.getText(param1, param2);
        }// end function

        public static function adjustPos(param1:DisplayObject, param2:Number = 0, param3:Number = 0) : void
        {
            param1.x = param1.x + param2 * Global.vScreenDelta.x / Global.vResolution;
            param1.y = param1.y + param3 * Global.vScreenDelta.y / Global.vResolution;
            return;
        }// end function

        public static function getCoord(param1:Number, param2:Number, param3:Boolean = true) : Point
        {
            var _loc_4:* = (param1 - Global.vScreenDelta.x) / Global.vResolution;
            var _loc_5:* = (param2 - Global.vScreenDelta.y) / Global.vResolution;
            _loc_4 = _loc_4 - Global.vSize.x / 2;
            _loc_5 = _loc_5 - Global.vSize.y / 2;
            if (Global.v169e)
            {
                _loc_4 = _loc_4 - GBL_Main.vDelta169;
            }
            if (param3)
            {
                _loc_4 = _loc_4 / GBL_Main.vZoomCoef;
                _loc_5 = _loc_5 / GBL_Main.vZoomCoef;
            }
            return new Point(_loc_4, _loc_5);
        }// end function

        public static function onError(param1:String, param2:Boolean = false) : void
        {
            var _loc_4:* = null;
            var _loc_3:* = param1;
            if (param2)
            {
                _loc_3 = " [FATAL] " + _loc_3;
            }
            if (Global.vServer != null)
            {
                _loc_4 = "";
                if (Global.vServer.vUser != null)
                {
                    _loc_4 = Global.vServer.vUser.vUserId;
                }
                _loc_3 = "(" + Global.vVersion + ")[userId:" + _loc_4 + "] " + _loc_3;
            }
            Global.vStats.Stats_Error(_loc_3);
            return;
        }// end function

        public static function onLCStatus(event:Event) : void
        {
            return;
        }// end function

        public static function addParticle(param1:DisplayObjectContainer, param2:String, param3:Point) : void
        {
            if (Global.vImages[param2] == null)
            {
                return;
            }
            particleManager.getInstance().showParticles(param1, param3, Global.vImages[param2], 1, 0, false, true, true, false, 1);
            return;
        }// end function

        public static function ConvertPoint(param1:Number = 0, param2:Number = 0, param3:DisplayObject = null, param4:DisplayObject = null) : Point
        {
            var _loc_5:* = new Point(param1, param2);
            _loc_5 = param3.localToGlobal(_loc_5);
            _loc_5 = param4.globalToLocal(_loc_5);
            return _loc_5;
        }// end function

        public static function startParticles(param1:DisplayObjectContainer, param2, param3 = null, param4:int = 1, param5:int = 0, param6:int = 0, param7:int = 0, param8:Number = 0, param9 = true, param10:Number = 1, param11:Number = 0.5, param12:Number = 0, param13:Number = 0, param14:Number = 0, param15:Number = 0, param16:Number = 0, param17:Number = 0.98, param18:String = "normal", param19 = false, param20:Boolean = true) : particles
        {
            if (param1 == null)
            {
                param1 = new Sprite();
            }
            return particleManager.getInstance().startParticles(param1, param2, param3, param4, param5, param6, param7, param8, param9, param10, param11, param12, param13, param14, param15, param16, param17, param18, param19, param20);
        }// end function

        public static function setTint(param1:DisplayObject, param2:uint, param3:Number = 0) : void
        {
            var _loc_4:* = null;
            if (param3 == 0)
            {
                param1.transform.colorTransform = new ColorTransform();
            }
            else
            {
                _loc_4 = new ColorTransform();
                var _loc_5:* = 1 - param3;
                _loc_4.blueMultiplier = 1 - param3;
                _loc_4.greenMultiplier = _loc_5;
                _loc_4.redMultiplier = _loc_5;
                _loc_4.redOffset = Math.round(((param2 & 16711680) >> 16) * param3);
                _loc_4.greenOffset = Math.round(((param2 & 65280) >> 8) * param3);
                _loc_4.blueOffset = Math.round((param2 & 255) * param3);
                param1.transform.colorTransform = _loc_4;
            }
            return;
        }// end function

        public static function formatDuration(param1:int) : String
        {
            var _loc_2:* = param1;
            var _loc_3:* = Math.floor(_loc_2 / 60);
            _loc_2 = _loc_2 - _loc_3 * 60;
            var _loc_4:* = Math.floor(_loc_3 / 60);
            _loc_3 = _loc_3 - _loc_4 * 60;
            var _loc_5:* = Math.floor(_loc_4 / 24);
            _loc_4 = _loc_4 - _loc_5 * 24;
            var _loc_6:* = 2;
            var _loc_7:* = "";
            var _loc_8:* = 1;
            while (_loc_8 <= 4)
            {
                
                if (_loc_8 == 1)
                {
                    if (_loc_5 > 0)
                    {
                        _loc_7 = _loc_7 + _loc_5.toString() + Global.getText("txtCountdownDay");
                        _loc_6 = _loc_6 - 1;
                    }
                }
                else if (_loc_8 == 2)
                {
                    if (_loc_4 > 0)
                    {
                        if (_loc_7 != "")
                        {
                            _loc_7 = _loc_7 + " ";
                        }
                        _loc_7 = _loc_7 + _loc_4.toString() + Global.getText("txtCountdownHour");
                        _loc_6 = _loc_6 - 1;
                    }
                }
                else if (_loc_8 == 3)
                {
                    if (_loc_3 > 0)
                    {
                        if (_loc_7 != "")
                        {
                            _loc_7 = _loc_7 + " ";
                        }
                        _loc_7 = _loc_7 + _loc_3.toString() + Global.getText("txtCountdownMinut");
                        _loc_6 = _loc_6 - 1;
                    }
                }
                else if (_loc_8 == 4)
                {
                    if (_loc_2 > 0)
                    {
                        if (_loc_7 != "")
                        {
                            _loc_7 = _loc_7 + " ";
                        }
                        _loc_7 = _loc_7 + _loc_2.toString() + Global.getText("txtCountdownSecond");
                        _loc_6 = _loc_6 - 1;
                    }
                }
                if (_loc_6 == 0)
                {
                    _loc_8 = 4;
                }
                _loc_8++;
            }
            if (_loc_7 == "")
            {
                _loc_7 = "0" + Global.getText("txtCountdownSecond");
            }
            return _loc_7;
        }// end function

    }
}
