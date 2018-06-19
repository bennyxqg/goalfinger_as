package 
{
    import com.adobe.crypto.*;
    import com.greensock.*;
    import com.greensock.easing.*;
    import com.mesmotronic.ane.*;
    import flash.desktop.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.net.*;
    import flash.system.*;
    import flash.ui.*;
    import flash.utils.*;
    import menu.*;
    import menu.game.*;
    import menu.popup.*;
    import menu.screens.*;
    import sparks.*;
    import tools.*;

    public class Main extends Sprite
    {
        public var vInit:Init;
        private var vGamesparksDisconnectedMsg:Boolean = false;
        private var vGamesparksDisconnectedFrom:String = "";
        private var vCantConnectMessageRunning:Boolean = false;
        public var vLocalFocus:Boolean = true;
        public var vKillOnDeactivate:Boolean = true;
        private var vTimerKill:int;
        private var vLastDeactivate:int = 0;
        public var vForceLogin:Boolean = false;
        private var vNbRestartApp:int = 0;
        public var layerMenu:Sprite;
        public var layerTop:Sprite;
        public var layerParticle:Sprite;
        public var layerPopup:Sprite;
        public var layerLogTrace:Sprite;
        private var vLastCleanLayers:int = 0;
        public var vMenu:MenuXXX;
        private var vNextMenu:Class;
        private var vPopupFrom:Point;
        private var vPopupCallbackClosed:Function;
        public var vLoaderFile:String;
        private var vSWFCallBack:Function;

        public function Main()
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = false;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.quality = StageQuality.MEDIUM;
            stage.addEventListener(Event.DEACTIVATE, this.deactivate);
            stage.addEventListener(Event.ACTIVATE, this.reactivate);
            Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
            SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
            NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
            _loc_1 = NativeApplication.nativeApplication.applicationDescriptor;
            _loc_2 = _loc_1.namespace();
            _loc_3 = _loc_2::versionNumber[0];
            Global.vVersion = _loc_3;
            if (!Global.vDebug)
            {
                Global.vDev = false;
                Global.vServerPreview = false;
                Global.vInAppSandBox = false;
                Global.vGlobzPing = false;
                Global.vAutoLaunch = true;
            }
            _loc_4 = _loc_2::id[0];
            _loc_4 = MD5.hash("o" + _loc_4);
            if (Global.vDebug)
            {
                _loc_4 = "feb948c29bafda6c570bbb88829c04dc";
            }
            if (_loc_4 != "feb948c29bafda6c570bbb88829c04dc")
            {
            }
            if (Global.vDebug)
            {
                Global.vLogInfo = true;
            }
            Global.vMyInApp = new MyInApp();
            if (Capabilities.os.charAt(0) == "i")
            {
                Global.vIOSVersion = parseInt(Capabilities.os.split(" ")[2].split(".")[0]);
            }
            if (Capabilities.os.indexOf("Windows") >= 0)
            {
                Global.vStats = new GAStats("");
            }
            else
            {
                _loc_5 = false;
                Global.vStats = new GAStats("UA-46920317-19");
                _loc_5 = true;
                if (!_loc_5)
                {
                    Global.vStats = new GAStats("");
                }
            }
            if (stage.fullScreenHeight / stage.fullScreenWidth > 1.7)
            {
                Global.v169e = true;
            }
            this.initReconnecting();
            Global.vSound = new SoundList();
            Global.addLogTrace("v" + Global.vVersion, "Main");
            Global.vRoot = this;
            stage.color = 3948885;
            this.vInit = new Init(this.entryPoint);
            return;
        }// end function

        private function doTracePing() : void
        {
            TweenMax.delayedCall(5, this.doTracePing);
            return;
        }// end function

        public function entryPoint() : void
        {
            while (numChildren > 0)
            {
                
                removeChildAt(0);
            }
            System.gc();
            TweenMax.killAll();
            this.cleanServer();
            this.initLayers();
            if (false && Global.vDev)
            {
                Login.resetSO();
            }
            if (Global.vDev)
            {
            }
            this.loadLang();
            return;
        }// end function

        private function cleanServer() : void
        {
            if (Global.vServer != null)
            {
                Global.vServer.destroy();
                Global.vServer = null;
            }
            return;
        }// end function

        private function loadLang() : void
        {
            this.vMenu = null;
            this.addLoadingInfo("loadLang");
            Global.vLang = new Lang("", this.onLangReady);
            return;
        }// end function

        public function changeLang(param1:String) : void
        {
            Global.addLogTrace("changeLang:" + param1, "Main");
            Global.vServer.setCurrentLang(param1);
            Global.vLang = new Lang(param1, this.afterChangeLang);
            return;
        }// end function

        private function afterChangeLang() : void
        {
            Global.vGeneralMessageLastLoad = 0;
            Global.vTopBar.onLangChanged();
            this.goMainMenu();
            return;
        }// end function

        private function onLangReady() : void
        {
            if (Global.vDev)
            {
            }
            if (Global.vBotOffline)
            {
                this.launchMenu(BotOffline);
                return;
            }
            if (Global.vGlobzPing)
            {
                this.initServer();
                return;
            }
            if (Login.isTutorialDone())
            {
                this.initServerLoading();
            }
            else
            {
                Global.vRoot.launchMenu(Tutorial);
            }
            return;
        }// end function

        public function initServerLoading() : void
        {
            Global.addLogTrace("initServerLoading", "Main");
            if (this.layerPopup == null)
            {
                return;
            }
            Global.vLoadingGlobe = new LoadingGlobe();
            this.layerPopup.addChild(Global.vLoadingGlobe);
            this.initServer();
            return;
        }// end function

        private function addLoadingInfo(param1:String) : void
        {
            Global.addLogTrace("addLoadingInfo:" + param1, "Main");
            return;
        }// end function

        public function removeLoading() : void
        {
            if (Global.vLoadingGlobe != null)
            {
                if (this.layerPopup.contains(Global.vLoadingGlobe))
                {
                    this.layerPopup.removeChild(Global.vLoadingGlobe);
                }
                Global.vLoadingGlobe = null;
            }
            return;
        }// end function

        private function initServer() : void
        {
            this.addLoadingInfo("initServer");
            if (Global.vServer != null)
            {
                Global.vServer.destroy();
            }
            Global.vServer = new Sparks();
            Global.vServer.init(this.onGamesparksConnect, this.onGamesparksDisconnect);
            if (Global.vLoadingGlobe != null)
            {
                Global.vLoadingGlobe.showInitStep(1);
            }
            Global.vServer.connect();
            return;
        }// end function

        private function onGamesparksConnect(param1:Boolean = true) : void
        {
            this.addLoadingInfo("onGamesparksConnect:" + param1);
            if (param1 == false)
            {
                this.onGamesparksCantConnect();
                return;
            }
            if (Global.vGlobzPing)
            {
                Global.vRoot.launchMenu(GlobzPing);
                return;
            }
            if (this.vForceLogin)
            {
                Global.addLogTrace("ForceLogin > go Login", "Main");
                this.vForceLogin = false;
                this.launchMenu(Login);
                return;
            }
            this.goMainMenu();
            return;
        }// end function

        private function onGamesparksDisconnect(param1:String) : void
        {
            Global.addLogTrace("onGamesparksDisconnect:" + param1, "Main");
            this.vGamesparksDisconnectedFrom = this.vGamesparksDisconnectedFrom + ":" + param1;
            if (Global.vGlobzPing)
            {
                if (this.vMenu != null)
                {
                    this.vMenu.onDisconnected();
                    return;
                }
            }
            this.vKillOnDeactivate = true;
            Global.addLogTrace("Global.vServer.vFocusActivate=" + Global.vServer.vFocusActivate);
            if (this.vLocalFocus == false)
            {
                this.afterGamesparksDisconnectMsg();
            }
            else if (!this.vGamesparksDisconnectedMsg)
            {
                this.vGamesparksDisconnectedMsg = true;
                Global.addLogTrace("onGamesparksDisconnect(pFrom=" + param1 + ") > txtDisconnected");
                new MsgBox(this, Global.getText("txtDisconnected"), this.afterGamesparksDisconnectMsg);
            }
            return;
        }// end function

        private function afterGamesparksDisconnectMsg() : void
        {
            Global.addLogTrace("afterGamesparksDisconnectMsg");
            this.vGamesparksDisconnectedMsg = false;
            this.restartApp("onGamesparksDisconnect" + this.vGamesparksDisconnectedFrom);
            this.vGamesparksDisconnectedFrom = "";
            return;
        }// end function

        private function onGamesparksCantConnect() : void
        {
            Global.addLogTrace("cantConnectInvite vCantConnectMessageRunning=" + this.vCantConnectMessageRunning);
            if (!this.vCantConnectMessageRunning)
            {
                this.vCantConnectMessageRunning = true;
                new MsgBox(this, Global.getText("txtCantConnectSimple"), this.afterCantConnectInvite, MsgBox.Type_TwoButtons, {labelYes:Global.getText("txtTraining"), labelNo:Global.getText("txtTryAgain")});
            }
            else
            {
                Global.addLogTrace("Warning : onCantConnect vCantConnectMessageRunning=" + this.vCantConnectMessageRunning);
            }
            return;
        }// end function

        private function afterCantConnectInvite(param1:Boolean, param2:Object) : void
        {
            if (param1)
            {
                this.launchMenu(Training);
            }
            else
            {
                this.restartAfterCantConnect();
            }
            return;
        }// end function

        public function restartAfterCantConnect() : void
        {
            this.vCantConnectMessageRunning = false;
            this.restartApp("afterCantConnect");
            return;
        }// end function

        private function deactivate(event:Event) : void
        {
            var _loc_3:* = null;
            Global.addEventTrace("Main.deactivate");
            Global.addLogTrace("deactivate vKillOnDeactivate=" + this.vKillOnDeactivate, "Main");
            this.vLocalFocus = false;
            var _loc_2:* = Math.round(getTimer() / 1000);
            if (Global.vStats != null)
            {
                Global.vStats.Stats_Event("Deactivate", Global.vStats.vLastPageView, "Timer", _loc_2);
            }
            if (Global.vSound != null)
            {
                Global.vSound.onDeactivate();
            }
            if (Global.vServer != null)
            {
                if (Global.vServer.isConnected() && Global.vServer.isLogged())
                {
                    _loc_3 = "0";
                    if (Global.vGame != null && !Global.vGame.vReplay && !Global.vGame.vAIRunning)
                    {
                        _loc_3 = Global.vServer.vMatchId;
                    }
                    Global.vServer.onFocusChange("deactivate", _loc_3);
                }
            }
            if (Global.vGame != null)
            {
                Global.vGame.onTimebankDeactivate();
            }
            if (this.vMenu != null)
            {
                this.vMenu.onDeactivate(event);
            }
            this.vLastDeactivate = getTimer();
            this.vTimerKill = getTimer();
            addEventListener(Event.ENTER_FRAME, this.onFrameDeactivate);
            return;
        }// end function

        private function onFrameDeactivate(event:Event) : void
        {
            Global.addEventTrace("Main.onFrameDeactivate");
            if (getTimer() - this.vTimerKill > 5 * 60 * 1000)
            {
                removeEventListener(Event.ENTER_FRAME, this.onFrameDeactivate);
                this.exitApplication();
            }
            return;
        }// end function

        private function reactivate(event:Event) : void
        {
            var _loc_4:* = null;
            Global.addEventTrace("Main.reactivate");
            Global.addLogTrace("reactivate", "Main");
            this.vLocalFocus = true;
            if (Global.vSound != null)
            {
                Global.vSound.onReactivate();
            }
            if (Global.vServer != null)
            {
                if (Global.vServer.isConnected() && Global.vServer.isLogged())
                {
                    _loc_4 = "0";
                    if (Global.vGame != null && !Global.vGame.vReplay && !Global.vGame.vAIRunning)
                    {
                        _loc_4 = Global.vServer.vMatchId;
                    }
                    Global.vServer.onFocusChange("reactivate", _loc_4);
                }
                else
                {
                    Global.addLogTrace("reactivate : Server not connected", "Main");
                    if (Global.vGame != null)
                    {
                        Global.addLogTrace("Force rejoin game", "Main");
                        this.restartApp("Force Rejoin game");
                        return;
                    }
                }
            }
            if (Global.vGame != null)
            {
                Global.vGame.onTimebankReactivate();
            }
            if (this.vMenu != null)
            {
                this.vMenu.onReactivate(event);
            }
            var _loc_2:* = (getTimer() - this.vLastDeactivate) / 1000;
            var _loc_3:* = 60 * 2;
            if (Global.vDev)
            {
            }
            if (_loc_2 > _loc_3)
            {
                TweenMax.delayedCall(0.1, this.restartAppAfterDeactivated);
                return;
            }
            removeEventListener(Event.ENTER_FRAME, this.onFrameDeactivate);
            return;
        }// end function

        private function restartAppAfterDeactivated() : void
        {
            return;
        }// end function

        public function exitApplication() : void
        {
            NativeApplication.nativeApplication.exit();
            return;
        }// end function

        public function restartApp(param1:String = "not set") : void
        {
            Global.addLogTrace("restartApp From " + param1, "Main");
            var _loc_2:* = this;
            var _loc_3:* = this.vNbRestartApp + 1;
            _loc_2.vNbRestartApp = _loc_3;
            Global.vStats.Stats_Event("RestartApp", "From " + param1, "Nb in session", this.vNbRestartApp);
            this.vForceLogin = true;
            this.vGamesparksDisconnectedMsg = false;
            this.vCantConnectMessageRunning = false;
            if (Global.vServer == null)
            {
                Global.vStats.Stats_Event("RestartApp", "vServer null");
            }
            this.entryPoint();
            return;
        }// end function

        public function forceReconnectDev() : void
        {
            if (Global.vDev)
            {
            }
            return;
        }// end function

        public function resizeMenu(param1:DisplayObject) : void
        {
            var _loc_2:* = NaN;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            var _loc_6:* = null;
            if (param1 == null)
            {
                return;
            }
            var _loc_5:* = 0;
            _loc_6 = AutoResize.doResize(stage, param1, Global.vSize.x, Global.vSize.y, false);
            Global.vResolution = _loc_6.scaleX;
            Global.vScreenDelta = new Point(_loc_6.deltaX, _loc_6.deltaY);
            return;
        }// end function

        public function getStageSize() : Point
        {
            var _loc_1:* = new Point(stage.fullScreenWidth, stage.fullScreenHeight);
            if (AndroidFullScreen.isSupported)
            {
                if (AndroidFullScreen.isImmersiveModeSupported)
                {
                    AndroidFullScreen.stage = stage;
                    AndroidFullScreen.fullScreen();
                    _loc_1.x = AndroidFullScreen.immersiveWidth;
                    _loc_1.y = AndroidFullScreen.immersiveHeight;
                }
            }
            return _loc_1;
        }// end function

        private function initLayers() : void
        {
            this.cleanLayers();
            this.layerMenu = this.newLayer();
            this.layerTop = this.newLayer();
            this.layerPopup = this.newLayer();
            this.layerLogTrace = this.newLayer();
            this.layerParticle = this.newLayer();
            if (Global.vDev)
            {
            }
            return;
        }// end function

        public function newLayer() : Sprite
        {
            var _loc_1:* = new Sprite();
            this.resizeMenu(_loc_1);
            addChild(_loc_1);
            return _loc_1;
        }// end function

        private function cleanLayers() : void
        {
            Global.addLogTrace("cleanLayers", "Main");
            if (Global.vTopBar != null)
            {
                if (Global.vTopBar.parent != null)
                {
                    Global.vTopBar.parent.removeChild(Global.vTopBar);
                }
                Global.vTopBar = null;
            }
            while (numChildren > 0)
            {
                
                removeChildAt(0);
            }
            this.layerMenu = null;
            this.layerTop = null;
            this.layerPopup = null;
            this.layerLogTrace = null;
            this.layerParticle = null;
            return;
        }// end function

        private function initReconnecting() : void
        {
            return;
        }// end function

        public function showReconnecting(param1:Boolean = true) : void
        {
            if (this.vMenu != null)
            {
                this.vMenu.showReconnection(param1);
            }
            return;
        }// end function

        private function cleanMenu() : void
        {
            if (this.vMenu != null)
            {
                if (this.layerMenu != null)
                {
                    if (this.layerMenu.contains(this.vMenu))
                    {
                        this.layerMenu.removeChild(this.vMenu);
                    }
                }
                this.vMenu = null;
            }
            System.gc();
            return;
        }// end function

        public function launchMenu(param1:Class, param2:Number = 0.01) : void
        {
            Global.addLogTrace("launchMenu:" + param1, "Main");
            if (this.vNextMenu != null)
            {
                return;
            }
            this.cleanMenu();
            this.vNextMenu = param1;
            TweenMax.delayedCall(param2, this.doLaunchMenu);
            Global.vRoot.stage.frameRate = 60;
            return;
        }// end function

        private function doLaunchMenu() : void
        {
            Global.addLogTrace("doLaunchMenu:" + this.vNextMenu, "Main");
            this.quitPopup();
            this.vMenu = new this.vNextMenu();
            this.vNextMenu = null;
            if (this.layerMenu == null)
            {
                return;
            }
            this.layerMenu.addChild(this.vMenu);
            return;
        }// end function

        public function goMainMenu() : void
        {
            Global.addLogTrace("goMainMenu", "Main");
            if (Global.vServer == null)
            {
                Global.addLogTrace("vServer=null", "Main");
                return;
            }
            if (Global.vServer.isLogged())
            {
                Global.vSound.playMusic(0.1);
                this.launchMenu(Home);
            }
            else
            {
                this.launchMenu(Login);
            }
            return;
        }// end function

        public function launchPopup(param1:Class, param2:Point = null, param3:Function = null) : void
        {
            var _loc_7:* = NaN;
            this.vPopupCallbackClosed = param3;
            var _loc_4:* = new MsgboxBG();
            _loc_4.x = Global.vSize.x / 2;
            _loc_4.y = Global.vSize.y / 2;
            _loc_4.width = Global.vSize.x + 2 * Global.vScreenDelta.x / Global.vResolution;
            _loc_4.height = Global.vSize.y + 2 * Global.vScreenDelta.y / Global.vResolution;
            this.layerPopup.addChild(_loc_4);
            TweenMax.from(_loc_4, 0.6, {alpha:0});
            if (Capabilities.isDebugger)
            {
                _loc_4.addEventListener(MouseEvent.CLICK, this.onClickPopupBG);
            }
            else
            {
                _loc_4.addEventListener(TouchEvent.TOUCH_TAP, this.onClickPopupBG);
            }
            var _loc_5:* = new param1;
            var _loc_6:* = new param1;
            this.layerPopup.addChild(_loc_6);
            if (param2 != null)
            {
                _loc_7 = 0.2;
                TweenMax.from(_loc_5, _loc_7, {alpha:0, x:param2.x, y:param2.y, scaleX:0, scaleY:0});
                this.vPopupFrom = param2;
            }
            else
            {
                this.vPopupFrom = new Point(Global.vSize.x / 2, Global.vSize.y / 2);
            }
            return;
        }// end function

        private function onClickPopupBG(event:Event) : void
        {
            Global.addEventTrace("Main.onClickPopupBG");
            this.quitPopup();
            return;
        }// end function

        public function quitPopup(param1:Number = 0.2, param2:Boolean = false) : void
        {
            var _loc_4:* = 0;
            var _loc_3:* = 0.05;
            if (this.layerPopup == null)
            {
                return;
            }
            if (this.layerPopup.numChildren < 2)
            {
                param2 = true;
            }
            if (param2)
            {
                if (this.layerPopup.numChildren > 0)
                {
                    TweenMax.to(this.layerPopup.getChildAt(0), param1, {delay:_loc_3, alpha:0});
                }
                _loc_4 = 1;
                while (_loc_4 < this.layerPopup.numChildren)
                {
                    
                    TweenMax.to(this.layerPopup.getChildAt(_loc_4), param1, {delay:_loc_3, alpha:0, x:this.vPopupFrom.x, y:this.vPopupFrom.y, scaleX:0, scaleY:0, ease:Quad.easeIn});
                    _loc_4++;
                }
                TweenMax.delayedCall(param1 + _loc_3, this.cleanPopup);
            }
            else
            {
                if (this.layerPopup.numChildren >= 2)
                {
                    if (this.vPopupFrom == null)
                    {
                        this.vPopupFrom = new Point(0, 0);
                    }
                    TweenMax.to(this.layerPopup.getChildAt((this.layerPopup.numChildren - 1)), param1, {delay:_loc_3, alpha:0, x:this.vPopupFrom.x, y:this.vPopupFrom.y, scaleX:0, scaleY:0, ease:Quad.easeIn});
                    TweenMax.to(this.layerPopup.getChildAt(this.layerPopup.numChildren - 2), param1, {delay:_loc_3, alpha:0});
                }
                TweenMax.delayedCall(param1 + _loc_3, this.cleanPopup2);
            }
            if (this.vPopupCallbackClosed != null)
            {
                TweenMax.delayedCall(param1 + 0.1, this.vPopupCallbackClosed);
                this.vPopupCallbackClosed = null;
            }
            if (Settings.vNeedRelog)
            {
            }
            return;
        }// end function

        private function cleanPopup2() : void
        {
            if (this.layerPopup == null)
            {
                return;
            }
            if (this.layerPopup.numChildren < 2)
            {
                this.cleanPopup();
                return;
            }
            this.layerPopup.removeChildAt((this.layerPopup.numChildren - 1));
            this.layerPopup.removeChildAt((this.layerPopup.numChildren - 1));
            return;
        }// end function

        private function cleanPopup() : void
        {
            if (this.layerPopup == null)
            {
                return;
            }
            while (this.layerPopup.numChildren > 0)
            {
                
                this.layerPopup.removeChildAt(0);
            }
            return;
        }// end function

        public function newMsgBox(param1:String) : void
        {
            if (this.vMenu != null)
            {
                new MsgBox(this.vMenu, param1, this.goMainMenu);
            }
            else
            {
                new MsgBox(this, param1, this.goMainMenu);
            }
            return;
        }// end function

        public function loadSWF(param1:String, param2:Function) : void
        {
            var _loc_3:* = null;
            var _loc_5:* = null;
            this.vSWFCallBack = param2;
            this.vLoaderFile = param1;
            if (Global.vSWFLoader)
            {
                Global.vSWFLoader.unloadAndStop();
                Global.vSWFLoader = null;
            }
            Global.vSWFLoader = new Loader();
            if (param1.indexOf("http") == -1)
            {
                _loc_5 = File.applicationDirectory.resolvePath(param1);
                _loc_3 = new URLRequest(_loc_5.url);
            }
            else
            {
                _loc_3 = new URLRequest(param1);
            }
            _loc_3.cacheResponse = false;
            _loc_3.useCache = false;
            var _loc_4:* = new LoaderContext(false, ApplicationDomain.currentDomain, null);
            Global.vSWFLoader = new Loader();
            Global.vSWFLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.SWFCompleteHandler, false, 0, true);
            Global.vSWFLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.SWFioErrorHandler);
            Global.vSWFLoader.load(_loc_3, _loc_4);
            return;
        }// end function

        private function SWFCompleteHandler(event:Event) : void
        {
            var _loc_2:* = null;
            Global.addEventTrace("Main.SWFCompleteHandler");
            Global.vSWFLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.SWFCompleteHandler, false);
            Global.vSWFLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.SWFioErrorHandler);
            Global.vSWFLoader.stopAllMovieClips();
            if (this.vSWFCallBack != null)
            {
                _loc_2 = this.vSWFCallBack;
                this.vSWFCallBack = null;
                this._loc_2();
            }
            return;
        }// end function

        private function SWFioErrorHandler(event:IOErrorEvent) : void
        {
            Global.addEventTrace("Main.SWFioErrorHandler");
            Global.vSWFLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.SWFCompleteHandler, false);
            Global.vSWFLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.SWFioErrorHandler);
            if (Global.vSWFLoader != null)
            {
                Global.vSWFLoader.unloadAndStop();
            }
            Global.vSWFLoader = null;
            new MsgBox(this, "Load error:" + this.vLoaderFile, this.errorCallback);
            return;
        }// end function

        private function errorCallback() : void
        {
            var _loc_1:* = null;
            if (this.vSWFCallBack != null)
            {
                _loc_1 = this.vSWFCallBack;
                this.vSWFCallBack = null;
                this._loc_1();
            }
            return;
        }// end function

    }
}
