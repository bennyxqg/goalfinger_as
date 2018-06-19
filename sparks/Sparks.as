package sparks
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.messages.*;
    import com.gamesparks.api.requests.*;
    import com.gamesparks.api.responses.*;
    import com.gamesparks.api.types.*;
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import gbl.*;
    import globz.*;
    import menu.game.*;
    import menu.popup.*;
    import menu.screens.*;
    import tools.*;

    public class Sparks extends Object
    {
        private var gs:GS;
        private var requestBuilder:GSRequestBuilder;
        private var vServiceUrlPreview:String = "wss://preview.gamesparks.net/ws/296608L7YCYP";
        private var vServiceUrlLive:String = "wss://live.gamesparks.net/ws/296608L7YCYP";
        private var vApiKey:String = "296608L7YCYP";
        private var vApiSecret:String = "V8K3fTWSCC3r4wZ6KNX2sZP4M7NdoCDv";
        private var vServiceUrlGlobzPingPreview:String = "wss://preview.gamesparks.net/ws/g299823ruifG";
        private var vServiceUrlGlobzPingLive:String = "wss://live.gamesparks.net/ws/g299823ruifG";
        private var vApiSecretGlobzPing:String = "dlJlKcfVBFzccvejmaFi2GBMT9cApRU5";
        private var vCallbackConnect:Function;
        private var vCallbackDisconnect:Function;
        private var vIsConnected:Boolean = false;
        private var vDestroyed:Boolean = false;
        private var vInitServerTimeout:Number;
        private var vInitServerTimeoutMC:MovieClip;
        private var vInitServerTimeoutDuration:int = 40;
        private var vLastReconnect:int = -1000000;
        public var vLastAvailable:Boolean = false;
        public var vReconnecting:Boolean = false;
        public var vReconnectingTimelast:int;
        private var vCheckConnectionKey:int = 0;
        private var vCheckConnectionError:int = 0;
        private var vCheckConnectionEnabled:Boolean = true;
        private var vDisconnecting:Boolean = false;
        private var vXPLevels:Array;
        public var vUpgradePrices:Array;
        public var vUpgradeTimes:Array;
        public var vSpeedUpSlots:Array;
        public var vSpeedUpPrices:Array;
        public var vCardsAvailability:Object;
        public var vTipsConfig:Object;
        private var vPing:Sparks_Ping;
        private var vGuestCallback:Function;
        private var vGuestUniqueId:Function;
        private var vGuestName:String;
        private var vGuestNewPlayer:Boolean;
        private var vFacebookCallback:Function;
        private var vFacebookLinkRunnging:Boolean = false;
        public var vFacebookNewPlayer:Boolean;
        private var vPseudoCallback:Function;
        private var vCallbackLogin:Function;
        public var vDisplayName:String = "";
        public var vUser:Sparks_User;
        public var vLoginType:String = "";
        private var vUserDetailsCallback:Function;
        private var vLoadUserDetailsXPUpdate:Boolean;
        private var vReposCountDone:int = 0;
        private var vRegisterCallback:Function;
        public var vFocusActivate:Boolean = true;
        private var vFocusLastType:String;
        private var vNowServer:Number;
        private var vNow0:Number;
        private var vReward:Object;
        private var vUpgradeCallback:Function;
        private var vRegCardCallback:Function;
        private var vVirtualGoodsCallback:Function;
        private var vRecoverCallback:Function;
        private var vRecoverCharId:String;
        private var vRecoverCard:String;
        private var vCharSellPriceCallback:Function;
        private var vCharSellCallback:Function;
        private var vTempCallback:Function;
        private var vMatchmakeInfoCallback:Function;
        public var vOpponentId:String = "";
        private var vMatchmakingSearching:Boolean = false;
        private var vMatchmakingLastAction:int = 0;
        private var vGameJoinCallback:Function;
        public var vFakeGame:Boolean = false;
        private var vFakeCallback:Function;
        public var vFakeData:Object;
        public var vMatchCallback:Function;
        private var vMatchForfeitCallback:Function;
        public var vMatchId:String;
        public var vSeat:int = 0;
        private var vServerCallRunning:Boolean = false;
        private var vSendReadyCallback:Function;
        private var vSendOrderCallback:Function;
        private var vSendOrderSaveRound:int;
        private var vSendOrderSaveOrders:String;
        private var vCheckLeaverCallback:Function;
        private var vShopCallback:Function;
        private var vSwapPositionCallback:Function;
        private var vShirtCallback:Function;
        private var vLeaderBoardNbPerPage:int = 50;
        private var vLeaderBoardShortCodeGeneral:String = "Trophies";
        private var vLeaderBoardShortCodeLocal:String = "TrophiesPerCountry.country.";
        private var vLeaderBoardLocal:Boolean = false;
        private var vLeaderBoardCallback:Function;
        private var vLeaderBoardData:Vector.<LeaderboardData>;
        private var vValidateCallback:Function;
        private var vTransitionId:String = "";
        private var vPromoPackCallback:Function;
        private var vProfileCallback:Function;
        private var vConsumeBooster:Function;
        private var vTradeCallback:Function;
        private var vTradeType:String;
        private var vHistoryGamesCallback:Function;
        private var vGeneralMessageCallback:Function;
        private var vReplayCallback:Function;
        private var vReplaySaveCallback:Function;
        private var vBGCallback:Function;
        private var vBGBitmapData:BitmapData;
        private var vCustomPingStarted:Boolean = false;
        private var vCustomPingLast:Number;
        private var vCustomPingCount:int;

        public function Sparks()
        {
            this.vMatchCallback = this.noMatchCallbackSet;
            return;
        }// end function

        public function init(param1:Function, param2:Function) : void
        {
            var _loc_3:* = false;
            var _loc_4:* = null;
            this.vCallbackConnect = param1;
            this.vCallbackDisconnect = param2;
            this.vServerCallRunning = false;
            Global.addLogTrace("********** GS Init **********", "Sparks.as");
            this.gs = new GS();
            this.gs.getMessageHandler().setHandler(".ScriptMessage", this.onScriptMessage);
            this.gs.getMessageHandler().setHandler(".SessionTerminatedMessage", this.onSessionTerminated);
            this.gs.getMessageHandler().setHandler(".MatchFoundMessage", this.onMatchFound);
            this.requestBuilder = this.gs.getRequestBuilder();
            if (Global.vServerPreview)
            {
                _loc_3 = false;
                _loc_4 = this.vServiceUrlPreview;
                if (Global.vGlobzPing)
                {
                    _loc_4 = this.vServiceUrlGlobzPingPreview;
                }
            }
            else
            {
                _loc_3 = true;
                _loc_4 = this.vServiceUrlLive;
                if (Global.vGlobzPing)
                {
                    _loc_4 = this.vServiceUrlGlobzPingLive;
                }
            }
            var _loc_5:* = this.vApiSecret;
            if (Global.vGlobzPing)
            {
                _loc_5 = this.vApiSecretGlobzPing;
            }
            this.gs.setAvailabilityCallback(this.availabilityCallback).setLogger(this.logger).setApiKey(this.vApiKey).setUseLiveServices(_loc_3).setApiSecret(_loc_5);
            return;
        }// end function

        public function connect() : void
        {
            if (this.vIsConnected)
            {
                Global.addLogTrace("connect : vIsConnected=" + this.vIsConnected, "Sparks.as");
                this.destroy();
            }
            this.initServerTimeout();
            this.gs.connect();
            return;
        }// end function

        public function destroy() : void
        {
            if (this.vDestroyed)
            {
                Global.addLogTrace("Warning : destroy vDestroyed=" + this.vDestroyed, "Sparks.as");
            }
            this.vDestroyed = true;
            this.gs.disconnect();
            this.vIsConnected = false;
            this.killGame("Sparks.destroy");
            return;
        }// end function

        public function killGame(param1:String = "not set") : void
        {
            Global.addLogTrace("killGame from : " + param1, "Sparks.as");
            if (Global.vGame != null)
            {
                Global.vGame.removeInfoBox();
                Global.vGame.stopRunning(false);
                Global.vGame = null;
                this.vMatchId = null;
            }
            return;
        }// end function

        private function initServerTimeout() : void
        {
            if (this.vIsConnected)
            {
                Global.addLogTrace("initServerTimeout error vIsConnected=" + this.vIsConnected);
                return;
            }
            this.stopInitServerTimeout();
            this.vInitServerTimeout = getTimer();
            if (this.vInitServerTimeoutMC == null)
            {
                this.vInitServerTimeoutMC = new MovieClip();
            }
            this.vInitServerTimeoutMC.addEventListener(Event.ENTER_FRAME, this.initServerTimeoutOnFrame);
            return;
        }// end function

        private function initServerTimeoutOnFrame(event:Event) : void
        {
            if (this.vIsConnected)
            {
                Global.addLogTrace("initServerTimeout error vIsConnected=" + this.vIsConnected);
                this.stopInitServerTimeout();
                return;
            }
            if (getTimer() - this.vInitServerTimeout > this.vInitServerTimeoutDuration * 1000)
            {
                Global.addLogTrace("ServerTimeout Raised !", "Sparks.as");
                this.gs.disconnect();
                this.stopInitServerTimeout();
                this.vCallbackConnect.call(0, false);
            }
            return;
        }// end function

        private function stopInitServerTimeout() : void
        {
            if (this.vInitServerTimeoutMC != null)
            {
                this.vInitServerTimeoutMC.removeEventListener(Event.ENTER_FRAME, this.initServerTimeoutOnFrame);
            }
            return;
        }// end function

        private function availabilityCallback(param1:Boolean) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = NaN;
            var _loc_4:* = null;
            if (this.vDestroyed)
            {
                return;
            }
            this.vDisconnecting = false;
            if (Global.vServer != this)
            {
                return;
            }
            this.vLastAvailable = param1;
            Global.addLogTrace("availabilityCallback vIsConnected=" + this.vIsConnected + " isAvailable=" + param1, "Sparks.as");
            if (Global.vLoadingGlobe != null)
            {
                if (param1)
                {
                    Global.vLoadingGlobe.showInitStep(2);
                }
                else
                {
                    Global.vLoadingGlobe.showInitStep(3);
                }
            }
            if (this.vReconnecting)
            {
                if (param1)
                {
                    this.vReconnecting = false;
                    this.vCheckConnectionEnabled = true;
                    Global.vRoot.showReconnecting(false);
                    Global.addLogTrace("Reconnecting Success", "Sparks.as");
                    _loc_2 = (getTimer() - this.vReconnectingTimelast) / 1000;
                }
                else
                {
                    Global.vRoot.showReconnecting(true);
                    Global.addLogTrace("Reconnecting Failed", "Sparks.as");
                }
            }
            if (this.vIsConnected == false)
            {
                if (param1)
                {
                    this.vIsConnected = true;
                    this.vCheckConnectionEnabled = true;
                    this.stopInitServerTimeout();
                    this.vCallbackConnect.call(0, true);
                    if (Global.vCustomPing)
                    {
                        this.initCustomPing();
                    }
                }
                else
                {
                    Global.addLogTrace("Warning : Connect fail, should not be called ");
                }
            }
            else
            {
                if (param1)
                {
                    Global.addLogTrace("Warning : Already connected");
                    return;
                }
                if (Global.vCustomPing)
                {
                    _loc_3 = (getTimer() - this.vCustomPingLast) / 1000;
                    _loc_3 = Math.round(10 * _loc_3) / 10;
                    _loc_4 = "GS SDK Disconnect. Last CustomPing Received : " + _loc_3.toString() + "s";
                    new MsgBox(Global.vRoot, _loc_4);
                }
                else
                {
                    this.gs.disconnect();
                    this.vIsConnected = false;
                }
            }
            return;
        }// end function

        public function isConnected() : Boolean
        {
            return this.vIsConnected;
        }// end function

        private function onSessionTerminated(param1:SessionTerminatedMessage) : void
        {
            if (this.vDestroyed)
            {
                return;
            }
            if (Global.vServer != this)
            {
                return;
            }
            Global.addLogTrace("onSessionTerminated error:" + param1.HasErrors() + " data:" + JSON.stringify(param1.getScriptData()) + " vIsConnected=" + this.vIsConnected, "Sparks.as");
            if (!this.vIsConnected)
            {
                return;
            }
            this.vIsConnected = false;
            return;
        }// end function

        public function stopAll() : void
        {
            this.vIsConnected = false;
            this.gs.disconnect();
            return;
        }// end function

        private function checkError(param1:GSResponse) : void
        {
            Global.addLogTrace("checkError:" + JSON.stringify(param1.getErrors()), "Sparks.as");
            if (param1.getErrors().authentication != null)
            {
                if (param1.getErrors().authentication == "NOTAUTHORIZED")
                {
                    Global.addLogTrace("checkError : NOTAUTHORIZED (entryPoint cancelled)", "Sparks.as");
                }
            }
            else if (param1.getErrors().error == "timeout")
            {
                this.checkConnection();
            }
            return;
        }// end function

        public function checkConnection() : void
        {
            var _loc_1:* = this.gs.getRequestBuilder().createLogEventRequest();
            var _loc_2:* = this;
            var _loc_3:* = this.vCheckConnectionKey + 1;
            _loc_2.vCheckConnectionKey = _loc_3;
            Global.addLogTrace("checkConnection vCheckConnectionKey=" + this.vCheckConnectionKey, "Sparks.as");
            _loc_1.setEventKey("Ping").setJSONEventAttribute("cKey", this.vCheckConnectionKey).send(this.onCheckConnection);
            return;
        }// end function

        private function onCheckConnection(param1:LogEventResponse) : void
        {
            Global.addLogTrace("onCheckConnection errors=" + JSON.stringify(param1.getErrors()), "Sparks.as");
            if (!this.vCheckConnectionEnabled)
            {
                return;
            }
            if (param1.getErrors() != null)
            {
                var _loc_2:* = this;
                var _loc_3:* = this.vCheckConnectionError + 1;
                _loc_2.vCheckConnectionError = _loc_3;
                Global.addLogTrace("onCheckConnection ERROR:" + this.vCheckConnectionError);
                if (this.vCheckConnectionError >= 3)
                {
                    this.vCheckConnectionError = 0;
                    Global.vRoot.restartApp("CheckConnectionError");
                    this.vCheckConnectionEnabled = false;
                }
                else
                {
                    this.checkConnection();
                }
            }
            else
            {
                Global.addLogTrace("onCheckConnection OK", "Sparks.as");
                this.vCheckConnectionError = 0;
            }
            return;
        }// end function

        private function onConfigLoaded(param1:LogEventResponse) : void
        {
            if (Global.vServer != this)
            {
                return;
            }
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            return;
        }// end function

        private function logger(param1:String) : void
        {
            Global.addLogTrace(param1, "Sparks Logger");
            return;
        }// end function

        public function forceDisconnect(param1:String) : void
        {
            var _loc_2:* = null;
            if (this.vDisconnecting)
            {
                return;
            }
            this.vDisconnecting = true;
            if (this.gs != null)
            {
                _loc_2 = "0";
                if (this.vMatchId != "" && this.vMatchId != null)
                {
                    _loc_2 = this.vMatchId;
                }
                this.vMatchId = "";
                this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Client_RequireDisconnect").setJSONEventAttribute("gameId", _loc_2).setJSONEventAttribute("msg", param1).send(this.afterForceDisconnect);
            }
            this.killGame("forceDisconnect");
            if (this.vPing != null)
            {
                this.vPing.stopPing();
            }
            return;
        }// end function

        private function afterForceDisconnect(param1:LogEventResponse) : void
        {
            Global.addLogTrace("afterForceDisconnect", "Sparks.as");
            if (param1.HasErrors())
            {
            }
            Global.vRoot.entryPoint();
            return;
        }// end function

        public function getXPForLevel(param1:int) : int
        {
            if (param1 < 1)
            {
                return 0;
            }
            if (param1 > this.vXPLevels.length)
            {
                param1 = this.vXPLevels.length;
            }
            return this.vXPLevels[(param1 - 1)];
        }// end function

        public function getSpeedUpCost(param1:int) : int
        {
            if (this.vSpeedUpSlots == null)
            {
                return 0;
            }
            if (param1 <= 0)
            {
                return 0;
            }
            var _loc_2:* = Math.floor(param1 / 60);
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            while (_loc_4 < this.vSpeedUpSlots.length)
            {
                
                if (_loc_2 <= this.vSpeedUpSlots[_loc_4])
                {
                    _loc_4 = this.vSpeedUpSlots.length;
                }
                else
                {
                    _loc_3 = _loc_4;
                }
                _loc_4++;
            }
            if (_loc_3 > (this.vSpeedUpPrices.length - 1))
            {
                _loc_3 = this.vSpeedUpPrices.length - 1;
            }
            return this.vSpeedUpPrices[_loc_3];
        }// end function

        private function startPing() : void
        {
            if (!this.vIsConnected)
            {
                return;
            }
            if (this.vPing != null)
            {
                this.vPing.stopPing();
            }
            this.vPing = new Sparks_Ping(this.gs);
            return;
        }// end function

        public function loginGuestAccount(param1:Function, param2:String, param3:String) : void
        {
            this.vGuestCallback = param1;
            this.vLoginType = "Guest";
            Global.addLogTrace("createDeviceAuthenticationRequest id=" + param3 + " os=" + param2, "Sparks.as");
            this.gs.getRequestBuilder().createDeviceAuthenticationRequest().setDeviceId(param3).setDeviceOS(param2).send(this.onGuestAccount);
            return;
        }// end function

        private function onGuestAccount(param1:AuthenticationResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("Error:" + JSON.stringify(param1.getAttribute("error")), "Sparks.as");
                if (Global.vGlobzPing)
                {
                    return;
                }
                Global.vRoot.launchMenu(Login);
            }
            else
            {
                if (!this.parseAuthenticationResponse(param1))
                {
                    return;
                }
                this.vGuestName = param1.getDisplayName();
                this.vGuestNewPlayer = param1.getNewPlayer();
                Global.addLogTrace("AuthenticationResponse DisplayName=" + this.vGuestName + " New=" + this.vGuestNewPlayer, "Sparks.as");
                if (Global.vGlobzPing)
                {
                    this.vGuestCallback.call(0, this.vGuestName, this.vGuestNewPlayer);
                    return;
                }
                if (this.vGuestNewPlayer)
                {
                    this.setCurrentLang(Global.vLang.vCur);
                }
                this.loadUserDetails(this.onGuestAccountDone);
            }
            return;
        }// end function

        private function onGuestAccountDone() : void
        {
            this.vGuestCallback.call(0, this.vGuestName, this.vGuestNewPlayer);
            return;
        }// end function

        public function getUniqueId() : String
        {
            var _loc_1:* = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
            var _loc_2:* = "UI_";
            var _loc_3:* = 0;
            while (_loc_3 < 12)
            {
                
                _loc_2 = _loc_2 + _loc_1[Math.floor(_loc_1.length * Math.random())];
                _loc_3++;
            }
            return _loc_2;
        }// end function

        public function isFacebookLinked() : Boolean
        {
            var _loc_1:* = SharedObject.getLocal(Global.SO_ID);
            if (_loc_1.data.login_type == "facebook")
            {
                return true;
            }
            return false;
        }// end function

        public function linkFacebook(param1:Function, param2:String) : void
        {
            this.vFacebookCallback = param1;
            Global.addLogTrace("linkFacebook createFacebookConnectRequest", "Sparks.as");
            this.vFacebookLinkRunnging = true;
            this.gs.getRequestBuilder().createFacebookConnectRequest().setAccessToken(param2).setDoNotLinkToCurrentPlayer(false).setTimeoutSeconds(15).send(this.onLinkFacebook);
            return;
        }// end function

        private function onLinkFacebook(param1:AuthenticationResponse) : void
        {
            var _loc_2:* = false;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            if (param1.HasErrors())
            {
                Global.addLogTrace("Error:" + JSON.stringify(param1.getAttribute("error")), "Sparks.as");
                this.vFacebookCallback.call(0, false, false, "", "");
            }
            else
            {
                _loc_2 = param1.getNewPlayer();
                _loc_3 = param1.getUserId();
                _loc_4 = param1.getDisplayName();
                _loc_5 = 1;
                _loc_6 = param1.getScriptData();
                if (_loc_6 != null)
                {
                    if (_loc_6.XPLevel != null)
                    {
                        _loc_5 = parseInt(_loc_6.XPLevel);
                    }
                }
                if (_loc_2)
                {
                    Global.addLogTrace("New account created. Id=" + _loc_3 + " DisplayName=" + _loc_4, "Sparks.as");
                    this.setCurrentLang(Global.vLang.vCur);
                }
                else if (this.vUser == null)
                {
                    Global.addLogTrace("Account facebook found. Id=" + _loc_3 + " DisplayName=" + _loc_4, "Sparks.as");
                }
                else if (this.vUser.vUserId != _loc_3)
                {
                    Global.addLogTrace("Another account linked to facebook found. Id=" + _loc_3 + " DisplayName=" + _loc_4, "Sparks.as");
                }
                else
                {
                    Global.addLogTrace("Guest account merged with facebook account.", "Sparks.as");
                }
                this.vFacebookCallback.call(0, true, _loc_2, _loc_3, _loc_4, _loc_5);
            }
            return;
        }// end function

        public function setNewPseudo(param1:Function, param2:String) : void
        {
            this.vPseudoCallback = param1;
            this.gs.getRequestBuilder().createChangeUserDetailsRequest().setDisplayName(param2).send(this.onNewPseudoSet);
            return;
        }// end function

        private function onNewPseudoSet(param1:ChangeUserDetailsResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                return;
            }
            this.vPseudoCallback.call();
            return;
        }// end function

        public function loginFacebook(param1:Function, param2:String) : void
        {
            Global.addLogTrace("loginFacebook createFacebookConnectRequest", "Sparks.as");
            this.vFacebookCallback = param1;
            this.gs.getRequestBuilder().createFacebookConnectRequest().setTimeoutSeconds(15).setAccessToken(param2).send(this.onFacebookLogin);
            return;
        }// end function

        private function onFacebookLogin(param1:AuthenticationResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("Error:" + JSON.stringify(param1.getAttribute("error")), "Sparks.as");
                this.vFacebookCallback.call(0, false);
            }
            else
            {
                Global.addLogTrace("Facebook logged Id=" + param1.getUserId() + " DisplayName=" + param1.getDisplayName() + " New=" + param1.getNewPlayer(), "Sparks.as");
                this.vFacebookNewPlayer = param1.getNewPlayer();
                if (this.vFacebookNewPlayer)
                {
                    this.setCurrentLang(Global.vLang.vCur);
                }
                if (!this.parseAuthenticationResponse(param1))
                {
                    return;
                }
                this.vCallbackLogin = this.vFacebookCallback;
                this.loadUserDetails(this.onLoginComplete);
            }
            return;
        }// end function

        public function login(param1:Function, param2:String, param3:String) : void
        {
            this.vLoginType = "Registered";
            this.vCallbackLogin = param1;
            if (this.vIsConnected)
            {
                this.logger("Attempting to authenticate");
                this.requestBuilder.createAuthenticationRequest().setUserName(param2).setPassword(param3).send(this.handleAuthenticationResponse);
            }
            else
            {
                Global.addLogTrace("Sparks.login not connected", "Sparks.as");
            }
            return;
        }// end function

        public function handleAuthenticationResponse(param1:AuthenticationResponse) : void
        {
            if (param1.HasErrors())
            {
                this.logger("Username or Password incorrect");
                this.vCallbackLogin.call(0, false);
            }
            else
            {
                if (!this.parseAuthenticationResponse(param1))
                {
                    return;
                }
                this.loadUserDetails(this.onLoginComplete);
            }
            return;
        }// end function

        private function onLoginComplete() : void
        {
            this.vCallbackLogin.call(0, true);
            return;
        }// end function

        private function parseAuthenticationResponse(param1:AuthenticationResponse) : Boolean
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_5:* = 0;
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return false;
            }
            this.vDisplayName = param1.getDisplayName();
            if (Global.vGlobzPing)
            {
                return true;
            }
            this.logger("Log in successful : " + this.vDisplayName);
            var _loc_4:* = param1.getScriptData();
            if (param1.getScriptData() == null)
            {
                Global.vRoot.launchMenu(Login);
                return false;
            }
            GBL_Main.parseDataSuddenDeath(_loc_4.suddendeath);
            this.vXPLevels = _loc_4.xpLevels;
            this.vUpgradePrices = _loc_4.upgrade.upgradePrices;
            this.vUpgradeTimes = _loc_4.upgrade.upgradeTimes;
            this.vSpeedUpSlots = _loc_4.speedup.timeSlots;
            this.vSpeedUpPrices = _loc_4.speedup.timePrices;
            GBL_Main.parseGameMisc(_loc_4.game_misc);
            Global.vReplayPrice = _loc_4.misc.replay_price;
            if (_loc_4.game_bots != null)
            {
                Global.vFakeStartMin = _loc_4.game_bots.min_timeout;
                Global.vFakeStartMax = _loc_4.game_bots.max_timeout;
            }
            this.parseConsecutiveWins(_loc_4.game_winnings);
            if (_loc_4.newShopCard == true)
            {
                Global.vNewShopCard = true;
                if (Global.vTopBar != null)
                {
                    Global.vTopBar.refreshNewShopCard();
                }
            }
            _loc_5 = this.compareVersion(_loc_4.misc.version_server, Global.vVersion);
            if (_loc_5 == -1)
            {
                if (_loc_4.misc.apple_reviewing == 1)
                {
                    Global.vServerPreview = true;
                    Global.vServerPreviewFlag = false;
                    Global.vServer = null;
                    Global.vRoot.restartApp("Apple Reviewing : " + Global.vVersion + " > " + _loc_4.misc.version_server);
                }
                else
                {
                    TweenMax.delayedCall(1.5, this.forceMaintenance);
                }
                return false;
            }
            if (_loc_5 == 1)
            {
                TweenMax.delayedCall(3, this.forceUpdate);
                return false;
            }
            if (_loc_4.misc.exchange_rate != null)
            {
                Global.vExchangeRate = _loc_4.misc.exchange_rate;
            }
            if (_loc_4.misc.gold_confirmation == 0)
            {
                Global.vGoldConfirmation = false;
            }
            this.vTipsConfig = new Object();
            if (_loc_4.misc.tip_hide != null)
            {
                this.vTipsConfig.delayHide = _loc_4.misc.tip_hide;
            }
            else
            {
                this.vTipsConfig.delayHide = 3;
            }
            if (_loc_4.misc.tip_show != null)
            {
                this.vTipsConfig.delayShow = _loc_4.misc.tip_show;
            }
            else
            {
                this.vTipsConfig.delayShow = 9;
            }
            if (_loc_4.energy.recovery_pace != null)
            {
                Sparks_Char.vEnergyRecoveryPace = _loc_4.energy.recovery_pace;
            }
            if (_loc_4.energy.game_threshold != null)
            {
                Sparks_Char.vEnergyThreshold = _loc_4.energy.game_threshold;
            }
            this.vCardsAvailability = _loc_4.cards_availability;
            this.vUser = new Sparks_User(param1.getUserId());
            this.startPing();
            return true;
        }// end function

        private function compareVersion(param1:String, param2:String) : int
        {
            var _loc_3:* = param1.split(".");
            if (_loc_3.length < 2)
            {
                return 0;
            }
            var _loc_4:* = param2.split(".");
            if (_loc_4.length < 2)
            {
                return 0;
            }
            if (parseInt(_loc_3[0]) > parseInt(_loc_4[0]))
            {
                return 1;
            }
            if (parseInt(_loc_3[0]) < parseInt(_loc_4[0]))
            {
                return -1;
            }
            if (parseInt(_loc_3[1]) > parseInt(_loc_4[1]))
            {
                return 1;
            }
            if (parseInt(_loc_3[1]) < parseInt(_loc_4[1]))
            {
                return -1;
            }
            return 0;
        }// end function

        private function forceUpdate() : void
        {
            var _loc_1:* = new MsgBox(Global.vRoot, Global.getText("txtUpdateNeeded"), this.forceUpdageGo);
            return;
        }// end function

        private function forceUpdageGo() : void
        {
            var _loc_1:* = "";
            _loc_1 = "https://play.google.com/store/apps/details?id=air.com.globz.goalfinger";
            if (_loc_1 != "")
            {
                navigateToURL(new URLRequest(_loc_1));
                this.forceUpdate();
            }
            return;
        }// end function

        private function forceMaintenance() : void
        {
            var _loc_1:* = new MsgBox(Global.vRoot, Global.getText("txtMaintenance"), this.afterForceMaintenance);
            return;
        }// end function

        private function afterForceMaintenance() : void
        {
            Global.vRoot.restartApp("onMaintenance");
            return;
        }// end function

        public function reloadUser(param1:Function, param2:String) : void
        {
            Global.vRewardAfterGame = null;
            this.vUser = new Sparks_User(param2);
            this.loadUserDetails(param1);
            return;
        }// end function

        private function loadUserDetails(param1:Function, param2:Boolean = true) : void
        {
            Global.addLogTrace("loadUserDetails", "Sparks.as");
            this.vLoadUserDetailsXPUpdate = param2;
            this.vUserDetailsCallback = param1;
            this.gs.getRequestBuilder().createAccountDetailsRequest().send(this.onDetails);
            return;
        }// end function

        private function onDetails(param1:AccountDetailsResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            var _loc_2:* = param1.getScriptData();
            if (_loc_2 == null)
            {
                return;
            }
            if (this.vUser == null)
            {
                return;
            }
            this.setNow(_loc_2.Now);
            GBL_Main.parseWeather(_loc_2.Weather);
            if (this.vUser.vUserId != param1.getUserId())
            {
                Global.addLogTrace("ERROR previous vUserId = " + this.vUser.vUserId, "Sparks.as");
            }
            this.vUser.vUserId = param1.getUserId();
            Global.addLogTrace("vUserId=" + this.vUser.vUserId, "Sparks.as");
            this.vDisplayName = param1.getDisplayName();
            Global.addLogTrace("vDisplayName=" + this.vDisplayName, "Sparks.as");
            this.vUser.parseDetails(param1, this.vLoadUserDetailsXPUpdate);
            this.vLoadUserDetailsXPUpdate = true;
            if (!this.vUser.isTeamComplete())
            {
                var _loc_3:* = this;
                var _loc_4:* = this.vReposCountDone + 1;
                _loc_3.vReposCountDone = _loc_4;
                if (this.vReposCountDone < 2)
                {
                    this.onClientLog("error", "Error in team positions");
                }
                else
                {
                    Login.onTutorialDone();
                    Global.vRoot.launchMenu(Login);
                }
                return;
            }
            else
            {
                this.vReposCountDone = 0;
            }
            Global.addLogTrace("MatchRunning:" + _loc_2.matchRunning, "Sparks.as");
            if (_loc_2.matchRunning == null)
            {
                Global.vMatchRunning = "0";
            }
            else
            {
                Global.vMatchRunning = _loc_2.matchRunning;
            }
            this.vUserDetailsCallback.call();
            return;
        }// end function

        public function onClientLog(param1:String, param2:String) : void
        {
            var _loc_3:* = "";
            if (this.vMatchId != null)
            {
                _loc_3 = this.vMatchId;
            }
            Global.addLogTrace("onClientLog:" + param2 + " (lGameId=" + _loc_3 + ")", "Sparks.as");
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Client_Log").setJSONEventAttribute("msg", param2).setJSONEventAttribute("level", param1).setJSONEventAttribute("gameId", _loc_3).send(this.afterClientLog);
            return;
        }// end function

        private function afterClientLog(param1:LogEventResponse) : void
        {
            return;
        }// end function

        public function isLogged() : Boolean
        {
            if (this.vUser != null)
            {
                return true;
            }
            return false;
        }// end function

        public function getDisplayName() : String
        {
            return this.vDisplayName;
        }// end function

        public function logout() : void
        {
            this.vUser = null;
            this.vLoginType = "";
            HistoryGames.vContentData = null;
            HistoryGames.vContentPos = 0;
            HistoryGames.vOngletSave = 0;
            Global.vGeneralMessageLastLoad = 0;
            Global.vGeneralMessageTab = null;
            Global.vGeneralMessagePerso = null;
            this.stopAll();
            return;
        }// end function

        public function registerUser(param1:String, param2:String, param3:String, param4:Function = null) : void
        {
            if (param4 != null)
            {
                this.vRegisterCallback = param4;
            }
            if (this.vIsConnected)
            {
                this.logger("Attempting to register");
                this.requestBuilder.createRegistrationRequest().setUserName(param1).setPassword(param2).setDisplayName(param3).send(this.handleRegistrationResponse);
            }
            else
            {
                Global.addLogTrace("Sparks.registerUser not connected", "Sparks.as");
            }
            return;
        }// end function

        public function handleRegistrationResponse(param1:RegistrationResponse) : void
        {
            if (this.vIsConnected)
            {
                if (param1.HasErrors())
                {
                    this.logger("There was a problem with the registration");
                    if (!param1.getNewPlayer())
                    {
                        this.logger("Username taken");
                    }
                    if (this.vRegisterCallback != null)
                    {
                        this.vRegisterCallback.call(0, false);
                        this.vRegisterCallback = null;
                    }
                }
                else
                {
                    this.logger("Registration successful");
                    this.logger(param1.getDisplayName());
                    if (this.vRegisterCallback != null)
                    {
                        this.vRegisterCallback.call(0, true);
                        this.vRegisterCallback = null;
                    }
                }
            }
            else
            {
                this.logger("Sparks.handleRegistrationResponse not connected");
            }
            return;
        }// end function

        public function onFocusChange(param1:String, param2:String) : void
        {
            var _loc_3:* = "";
            if (this.vMatchId != null)
            {
                _loc_3 = this.vMatchId;
            }
            Global.addLogTrace("onFocusChange:" + param1 + " (pGameId=" + param2 + ")", "Sparks.as");
            this.vFocusLastType = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Client_FocusChange").setJSONEventAttribute("focus", param1).setJSONEventAttribute("gameId", param2).send(this.afterFocusChange);
            return;
        }// end function

        private function afterFocusChange(param1:LogEventResponse) : void
        {
            var _loc_2:* = null;
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            if (Global.vGame != null && this.vMatchCallback != null)
            {
                if (this.vFocusLastType == "deactivate")
                {
                    this.vFocusActivate = false;
                }
                if (this.vFocusLastType == "reactivate")
                {
                    this.vFocusActivate = true;
                }
                _loc_2 = param1.getScriptData();
                if (_loc_2 != null)
                {
                    if (_loc_2.reward != null)
                    {
                        this.vMatchCallback.call(0, "GameAlreadyFinished", {reward:_loc_2.reward});
                    }
                }
            }
            return;
        }// end function

        public function setCurrentLang(param1:String) : void
        {
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("User_SetInfos").setJSONEventAttribute("languageCode", param1).send(this.onCurrentLang);
            return;
        }// end function

        private function onCurrentLang(param1:LogEventResponse) : void
        {
            return;
        }// end function

        private function setNow(param1:Number) : void
        {
            this.vNowServer = param1;
            this.vNow0 = getTimer();
            return;
        }// end function

        public function getTimeLeft(param1:Number, param2:Number) : Number
        {
            var _loc_3:* = this.vNowServer - param1;
            _loc_3 = _loc_3 + (getTimer() - this.vNow0);
            _loc_3 = Math.round(param2 - _loc_3 / 1000);
            return _loc_3;
        }// end function

        public function getTimeTo(param1:Number) : Number
        {
            var _loc_2:* = param1 * 1000 - this.vNowServer;
            _loc_2 = _loc_2 - (getTimer() - this.vNow0);
            if (_loc_2 < 0)
            {
                _loc_2 = 0;
            }
            _loc_2 = Math.round(_loc_2 / 1000);
            return _loc_2;
        }// end function

        public function getTimeFrom(param1:Number) : Number
        {
            var _loc_2:* = this.vNowServer - param1 * 1000;
            _loc_2 = _loc_2 + (getTimer() - this.vNow0);
            _loc_2 = Math.round(_loc_2 / 1000);
            return _loc_2;
        }// end function

        public function getTimeNow() : Number
        {
            var _loc_1:* = this.vNowServer;
            _loc_1 = _loc_1 + (getTimer() - this.vNow0) / 1000;
            return Math.round(_loc_1);
        }// end function

        public function startUpgrade(param1:Function, param2:String, param3:String) : void
        {
            this.vUpgradeCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Char_UpgradeAttribute").setJSONEventAttribute("cCode", param2).setJSONEventAttribute("cAttribute", param3).send(this.onStartUpgrade);
            return;
        }// end function

        private function onStartUpgrade(param1:LogEventResponse) : void
        {
            var _loc_3:* = null;
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            Global.addLogTrace("onStartUpgrade:" + JSON.stringify(param1.getScriptData()), "Sparks.as");
            var _loc_2:* = param1.getScriptData();
            if (_loc_2 != null)
            {
                if (_loc_2.NewXP != null)
                {
                    if (Global.vTopBar != null)
                    {
                        if (_loc_2.NewXP.GivenCard != null)
                        {
                            _loc_3 = _loc_2.NewXP.GivenCard;
                        }
                        Global.vTopBar.setNewXP(_loc_2.NewXP.level, _loc_2.NewXP.points, null, _loc_3);
                    }
                }
            }
            this.loadUserDetails(this.vUpgradeCallback, false);
            return;
        }// end function

        public function doSpeedUp(param1:Function, param2:Sparks_Char) : void
        {
            this.vUpgradeCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Char_SpeedUpJob").setJSONEventAttribute("cCode", param2.vCharId).send(this.afterSpeedUp);
            return;
        }// end function

        private function afterSpeedUp(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            var _loc_2:* = !param1.HasErrors();
            var _loc_3:* = param1.getScriptData();
            this.vUpgradeCallback.call(0, _loc_2, _loc_3);
            return;
        }// end function

        public function getRegCard(param1:Function) : void
        {
            this.vRegCardCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Shop_GetRegCard").send(this.onRegCard);
            return;
        }// end function

        private function onRegCard(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            var _loc_2:* = param1.getScriptData();
            this.vUser.vNextRegCardTime = Math.round(_loc_2.NextRegCardTime / 1000);
            this.vRegCardCallback.call(0, _loc_2.GivenCard);
            return;
        }// end function

        public function getVirtualGoods(param1:Function, param2:String) : void
        {
            this.vVirtualGoodsCallback = param1;
            this.gs.getRequestBuilder().createListVirtualGoodsRequest().send(this.onVirtualGood);
            return;
        }// end function

        private function onVirtualGood(param1:ListVirtualGoodsResponse) : void
        {
            var _loc_3:* = null;
            var _loc_5:* = null;
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            var _loc_2:* = param1.getVirtualGoods();
            var _loc_4:* = new Vector.<Sparks_Good>;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_2.length)
            {
                
                _loc_3 = _loc_2[_loc_6];
                _loc_5 = new Sparks_Good(_loc_3.getShortCode(), _loc_3.getPropertySet());
                _loc_4.push(_loc_5);
                _loc_6++;
            }
            this.vVirtualGoodsCallback.call(0, _loc_4);
            return;
        }// end function

        public function doPurchaseVirtualGood(param1:Function, param2:Sparks_Good) : void
        {
            this.vVirtualGoodsCallback = param1;
            this.gs.getRequestBuilder().createBuyVirtualGoodsRequest().setCurrencyType(1).setQuantity(1).setShortCode(param2.vShortCode).send(this.onPurchaseVirtualGood);
            return;
        }// end function

        private function onPurchaseVirtualGood(param1:BuyVirtualGoodResponse) : void
        {
            var _loc_4:* = null;
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            var _loc_2:* = param1.getBoughtItems();
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2.length)
            {
                
                _loc_4 = _loc_2[_loc_3];
                _loc_3++;
            }
            return;
        }// end function

        public function getCharsAvailable(param1:Function, param2:String) : void
        {
            this.vVirtualGoodsCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Char_GetList").setJSONEventAttribute("categ", param2).send(this.onCharsAvailable);
            return;
        }// end function

        private function onCharsAvailable(param1:LogEventResponse) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            var _loc_2:* = param1.getScriptData();
            var _loc_3:* = new Vector.<Sparks_Good>;
            if (_loc_2 == null)
            {
                return;
            }
            if (_loc_2.chars != null)
            {
                _loc_6 = 0;
                while (_loc_6 < _loc_2.chars.length)
                {
                    
                    _loc_4 = _loc_2.chars[_loc_6];
                    _loc_5 = new Sparks_Good(_loc_4.Code, _loc_4);
                    _loc_3.push(_loc_5);
                    _loc_6++;
                }
            }
            _loc_3.sort(this.sortCharRecruit);
            this.vVirtualGoodsCallback.call(0, _loc_2.categ, _loc_3);
            return;
        }// end function

        private function sortCharRecruit(param1:Sparks_Good, param2:Sparks_Good) : int
        {
            if (param1.vProperties.Categ < param2.vProperties.Categ)
            {
                return -1;
            }
            if (param1.vProperties.Categ > param2.vProperties.Categ)
            {
                return 1;
            }
            if (param1.vProperties.Price < param2.vProperties.Price)
            {
                return -1;
            }
            if (param1.vProperties.Price > param2.vProperties.Price)
            {
                return 1;
            }
            if (param1.vProperties.Name < param2.vProperties.Name)
            {
                return -1;
            }
            if (param1.vProperties.Name > param2.vProperties.Name)
            {
                return 1;
            }
            return 0;
        }// end function

        public function recruitChar(param1:Function, param2:String) : void
        {
            this.vVirtualGoodsCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Char_Recruit").setJSONEventAttribute("cCode", param2).send(this.onRecruitChar);
            return;
        }// end function

        private function onRecruitChar(param1:LogEventResponse) : void
        {
            var _loc_3:* = null;
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            Global.addLogTrace("onRecruitChar:" + JSON.stringify(param1.getScriptData()), "Sparks.as");
            var _loc_2:* = param1.getScriptData();
            if (_loc_2 != null)
            {
                if (_loc_2.NewXP != null)
                {
                    if (Global.vTopBar != null)
                    {
                        if (_loc_2.NewXP.GivenCard != null)
                        {
                            _loc_3 = _loc_2.NewXP.GivenCard;
                        }
                        Global.vTopBar.setNewXP(_loc_2.NewXP.level, _loc_2.NewXP.points, null, _loc_3);
                    }
                }
            }
            this.loadUserDetails(this.vVirtualGoodsCallback, false);
            return;
        }// end function

        public function charRecover(param1:Function, param2:String, param3:String) : void
        {
            this.vRecoverCallback = param1;
            this.vRecoverCharId = param2;
            this.vRecoverCard = param3;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Char_Recover").setJSONEventAttribute("cCode", this.vRecoverCharId).setJSONEventAttribute("vgCode", this.vRecoverCard).send(this.onRecover);
            return;
        }// end function

        private function onRecover(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            this.vUser.addCards(this.vRecoverCard, -1);
            var _loc_2:* = param1.getScriptData();
            this.vUser.getChar(this.vRecoverCharId).setNewEnergy(_loc_2.NewEnergy.Level, _loc_2.NewEnergy.TS);
            this.vRecoverCallback.call(0, this.vRecoverCharId);
            return;
        }// end function

        public function getCharSellPrice(param1:Function, param2:String) : void
        {
            this.vCharSellPriceCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Char_Sell").setJSONEventAttribute("cCode", param2).setJSONEventAttribute("action", "getPrice").send(this.onCharSellPrice);
            return;
        }// end function

        private function onCharSellPrice(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            var _loc_2:* = param1.getScriptData();
            if (_loc_2 == null)
            {
                return;
            }
            this.vCharSellPriceCallback.call(0, _loc_2.price);
            return;
        }// end function

        public function doCharSell(param1:Function, param2:String) : void
        {
            this.vCharSellCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Char_Sell").setJSONEventAttribute("cCode", param2).setJSONEventAttribute("action", "sell").send(this.onCharSell);
            return;
        }// end function

        private function onCharSell(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            var _loc_2:* = param1.getScriptData();
            if (_loc_2 == null)
            {
                return;
            }
            this.vCharSellCallback.call(0, _loc_2.NewBalance);
            return;
        }// end function

        public function tempUpdate(param1:Function, param2:String, param3:int = 0, param4:String = "", param5:String = "") : void
        {
            this.vTempCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Temp_Update").setJSONEventAttribute("todo", param2).setJSONEventAttribute("cCode", param4).setJSONEventAttribute("cAttribute", param5).setJSONEventAttribute("value", param3).send(this.afterTempCallback);
            return;
        }// end function

        private function afterTempCallback(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            this.loadUserDetails(this.vTempCallback);
            return;
        }// end function

        private function getMatchmakeGroup() : String
        {
            var _loc_2:* = null;
            var _loc_1:* = "";
            if (Global.vVersion == "nc")
            {
                _loc_1 = "1v8";
            }
            else
            {
                _loc_2 = Global.vVersion.split(".");
                _loc_1 = _loc_2[0] + "v" + _loc_2[1];
            }
            if (Matchmaking.vPrivatePass != "")
            {
                _loc_1 = "private_" + _loc_1 + "_" + Matchmaking.vPrivatePass;
            }
            return _loc_1;
        }// end function

        private function getMatchmakeCode() : String
        {
            var _loc_1:* = "Match_STD";
            if (Global.vServerPreview)
            {
                _loc_1 = "Match_Dev";
            }
            if (Matchmaking.vPrivatePass != "")
            {
                _loc_1 = "Match_Private";
            }
            return _loc_1;
        }// end function

        public function startMatchmake(param1:Function) : void
        {
            this.vMatchmakeInfoCallback = param1;
            this.vMatchmakingSearching = true;
            this.vFakeGame = false;
            Global.addLogTrace("startMatchmake", "Sparks.as");
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Game_CheckRunningGame").send(this.onCheckRunningGame);
            return;
        }// end function

        private function onCheckRunningGame(param1:LogEventResponse) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            if (param1.HasErrors())
            {
                if (param1.getErrors().error == "timeout")
                {
                    this.checkConnection();
                }
                this.vMatchmakingSearching = false;
                Matchmaking.vSynchroOnly = false;
                _loc_2 = param1.getAttribute("error");
                this.vMatchmakeInfoCallback.call(0, "onCheckRunningGame:" + JSON.stringify(_loc_2));
            }
            else
            {
                _loc_3 = param1.getScriptData();
                Global.addLogTrace("onCheckRunningGame lData:" + JSON.stringify(_loc_3));
                _loc_4 = "0";
                if (_loc_3 != null)
                {
                    if (_loc_3.GameRunning != null)
                    {
                        _loc_4 = _loc_3.GameRunning.MatchRunning;
                    }
                }
                Global.addLogTrace("lMatchId=" + _loc_4);
                if (_loc_4 != "0")
                {
                    this.vMatchmakeInfoCallback.call(0, "onGameAlreadyRunning:" + _loc_4);
                }
                else
                {
                    this.startMatchmakeDo();
                }
            }
            return;
        }// end function

        public function startMatchmakeDo() : void
        {
            if (Matchmaking.vSynchroOnly)
            {
                Matchmaking.vSynchroOnly = false;
                Global.vRoot.goMainMenu();
                return;
            }
            this.vMatchmakingSearching = true;
            this.vMatchmakeInfoCallback.call(0, "MatchmakingStarted");
            this.vMatchmakingLastAction = getTimer();
            Global.addLogTrace("startMatchmakeDo", "Sparks.as");
            var _loc_1:* = this.getMatchmakeGroup();
            this.vMatchmakeInfoCallback.call(0, "createMatchmakingRequest " + _loc_1);
            if (Matchmaking.vPrivatePass != "")
            {
                this.vMatchmakeInfoCallback.call(0, "PrivateGame Pass=" + Matchmaking.vPrivatePass);
            }
            this.gs.getRequestBuilder().createMatchmakingRequest().setMatchShortCode(this.getMatchmakeCode()).setSkill(this.vUser.vTrophy).setMatchGroup(_loc_1).send(this.onMatchmakingRequest);
            this.gs.getMessageHandler().setHandler(".MatchNotFoundMessage", this.handlerMatchNotFound);
            return;
        }// end function

        private function handlerMatchNotFound(param1:MatchNotFoundMessage) : void
        {
            this.vMatchmakingSearching = false;
            this.vMatchCallback.call(0, "MatchNotFound");
            return;
        }// end function

        private function goSplash() : void
        {
            Global.vRoot.goMainMenu();
            return;
        }// end function

        private function onMatchmakingRequest(param1:MatchmakingResponse) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = param1.getScriptData();
            if (param1.HasErrors())
            {
                this.vMatchmakingSearching = false;
                _loc_3 = param1.getAttribute("error");
                this.vMatchmakeInfoCallback.call(0, "onMatchFoundError:" + JSON.stringify(_loc_3));
                if (_loc_3.match == "CANCELLED")
                {
                    return;
                }
                this.checkError(param1);
                if (param1.getErrors().authentication == "NOTAUTHORIZED")
                {
                    Global.addLogTrace("onMatchmakingRequest : authentication NOTAUTHORIZED", "Sparks.as");
                    Global.vRoot.entryPoint();
                    return;
                }
                this.goSplash();
                return;
            }
            return;
        }// end function

        private function onMatchFound(param1:MatchFoundMessage) : void
        {
            var _loc_6:* = 0;
            if (this.vDestroyed)
            {
                return;
            }
            if (Global.vServer != this)
            {
                return;
            }
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            if (!this.vMatchmakingSearching)
            {
                _loc_6 = Math.round((getTimer() - this.vMatchmakingLastAction) / 1000);
                Global.vStats.Stats_Event("Matchmaking", "MatchFound while not searching !", "Previous Match Found", _loc_6);
                return;
            }
            this.vMatchmakingLastAction = getTimer();
            this.vMatchmakingSearching = false;
            this.vMatchCallback.call(0, "MatchFound");
            var _loc_2:* = param1.getScriptData();
            var _loc_3:* = param1.getAttribute("participants");
            var _loc_4:* = "";
            var _loc_5:* = 0;
            while (_loc_5 < _loc_3.length)
            {
                
                if (_loc_3[_loc_5].id != this.vUser.vUserId)
                {
                    _loc_4 = _loc_3[_loc_5].id;
                }
                _loc_5++;
            }
            this.vOpponentId = _loc_4;
            this.vMatchId = String(param1.getAttribute("matchId").toString());
            Global.addLogTrace("onMatchFound MatchId=" + this.vMatchId + " OpponentId=" + this.vOpponentId, "Sparks.as");
            if (this.vUser.vUserId < this.vOpponentId)
            {
                this.vSeat = 1;
            }
            else
            {
                this.vSeat = 2;
            }
            if (this.vSeat == 1)
            {
                this.doCreateGame();
            }
            else
            {
                Global.addLogTrace("Wait Player " + _loc_4 + " to execute Game_Create (MatchId=" + this.vMatchId + ")", "Sparks.as");
            }
            return;
        }// end function

        public function getSeatOnMatchJoined(param1:String, param2:String, param3:String) : int
        {
            this.vSeat = 0;
            if (this.vUser == null)
            {
                return 0;
            }
            if (this.vUser.vUserId == param2)
            {
                this.vSeat = 1;
                this.vMatchId = param1;
                this.vOpponentId = param3;
            }
            else if (this.vUser.vUserId == param3)
            {
                this.vSeat = 2;
                this.vMatchId = param1;
                this.vOpponentId = param3;
            }
            return this.vSeat;
        }// end function

        private function doCreateGame() : void
        {
            Global.addLogTrace("Game_Create Player1=" + this.vUser.vUserId + " Player2=" + this.vOpponentId + " MatchId=" + this.vMatchId, "Sparks.as");
            this.vFakeGame = false;
            var _loc_1:* = 0;
            if (Matchmaking.vPrivatePass != "")
            {
                _loc_1 = 1;
            }
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Game_Create").setJSONEventAttribute("Player1", this.vUser.vUserId).setJSONEventAttribute("Player2", this.vOpponentId).setJSONEventAttribute("Terrain", "Foot2").setJSONEventAttribute("MatchId", this.vMatchId).setJSONEventAttribute("Private", _loc_1).send(this.onGameCreated);
            if (Global.vDev)
            {
            }
            return;
        }// end function

        private function cancelMatchmakingWhenWaitingForOtherToCreate() : void
        {
            this.vMatchmakeInfoCallback.call(0, "Error:TimeoutOtherToCreate");
            return;
        }// end function

        public function stopMatchmake() : void
        {
            if (this.vMatchmakeInfoCallback == null)
            {
                return;
            }
            this.vMatchmakeInfoCallback.call(0, "Cancel Matchmake");
            this.gs.getRequestBuilder().createMatchmakingRequest().setAction("cancel").setMatchShortCode(this.getMatchmakeCode()).setMatchGroup(this.getMatchmakeGroup()).send(this.onMatchCancel);
            return;
        }// end function

        private function onMatchCancel(param1:MatchmakingResponse) : void
        {
            var _loc_2:* = null;
            this.vMatchmakeInfoCallback.call(0, "Cancel Matchmake Done");
            if (param1.HasErrors())
            {
                _loc_2 = param1.getAttribute("error");
                this.vMatchmakeInfoCallback.call(0, "onMatchCancelError:" + JSON.stringify(_loc_2));
            }
            return;
        }// end function

        public function gameJoin(param1:Function, param2:String) : void
        {
            this.vGameJoinCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setJSONEventAttribute("MatchId", param2).setEventKey("Game_Join").send(this.onGameJoin);
            this.vMatchId = "";
            return;
        }// end function

        private function onGameJoin(param1:LogEventResponse) : void
        {
            var _loc_2:* = param1.getScriptData();
            if (_loc_2.success != 1)
            {
                this.vGameJoinCallback.call(0, false);
            }
            else
            {
                this.vGameJoinCallback.call(0, true, _loc_2.game);
            }
            return;
        }// end function

        public function createFakeGame(param1:Function) : void
        {
            this.vFakeGame = true;
            this.vSeat = 1;
            this.vFakeCallback = param1;
            var _loc_2:* = Global.vFakeLevel;
            this.gs.getRequestBuilder().createLogEventRequest().setJSONEventAttribute("level", _loc_2).setEventKey("Game_GetFakePlayer").send(this.onFakePlayer);
            return;
        }// end function

        private function onFakePlayer(param1:LogEventResponse) : void
        {
            var _loc_4:* = undefined;
            if (param1.HasErrors())
            {
                this.vFakeCallback.call(0, false);
                return;
            }
            this.vFakeData = param1.getScriptData();
            var _loc_2:* = new Object();
            _loc_2.boosters = [];
            _loc_2.shirt = this.vFakeData.Shirt;
            var _loc_3:* = 1;
            while (_loc_3 <= 3)
            {
                
                for (_loc_4 in this.vFakeData.Characters)
                {
                    
                    if (_loc_6[_loc_4].Position == _loc_3)
                    {
                        _loc_2["player" + _loc_3] = {code:_loc_4, name:_loc_6[_loc_4].Name, category:_loc_6[_loc_4].Categ, force:_loc_6[_loc_4].Attributes.Force, vitality:_loc_6[_loc_4].Attributes.Vitality, speed:_loc_6[_loc_4].Attributes.Speed, infos:{Kill:0, KO:0, ArrowSum:0}};
                    }
                }
                _loc_3++;
            }
            this.vFakeData.Team = _loc_2;
            this.vFakeCallback.call(0, true);
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Game_Create").setJSONEventAttribute("Player1", this.vUser.vUserId).setJSONEventAttribute("Player2", this.vFakeData.Id).setJSONEventAttribute("Terrain", "Foot2").setJSONEventAttribute("MatchId", "fake").send(this.onFakeGameCreated);
            return;
        }// end function

        private function onFakeGameCreated(param1:LogEventResponse) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (param1.HasErrors())
            {
                _loc_2 = param1.getAttribute("error");
                this.vMatchmakeInfoCallback.call(0, "onFakeGameCreated:" + JSON.stringify(_loc_2));
            }
            else
            {
                _loc_3 = param1.getScriptData();
                this.vMatchmakeInfoCallback.call(0, "onGameCreated " + JSON.stringify(_loc_3));
                if (!_loc_3.success)
                {
                    this.vMatchCallback.call(0, "onError:Match creation failed");
                }
            }
            return;
        }// end function

        public function getFakeSkill() : int
        {
            if (this.vFakeData == null)
            {
                return 1;
            }
            return this.vFakeData.SkillLevel;
        }// end function

        public function initMatch(param1:Function) : void
        {
            this.vMatchCallback = param1;
            return;
        }// end function

        private function noMatchCallbackSet(param1:String, param2 = null) : void
        {
            Global.addLogTrace("[noMatchCallbackSet] " + param1, "Sparks.as");
            return;
        }// end function

        private function onScriptMessage(param1:ScriptMessage) : void
        {
            var _loc_2:* = param1.getData();
            if (_loc_2 == null)
            {
                Global.addLogTrace("onScriptMessage:null", "Sparks.as");
            }
            else
            {
                Global.addLogTrace("onScriptMessage:" + JSON.stringify(_loc_2), "Sparks.as");
            }
            if (_loc_2.FatalError != null)
            {
                new MsgBox(Global.vRoot.vMenu, _loc_2.FatalError, this.reloadPlayer);
            }
            else if (_loc_2.OnConnected != null)
            {
            }
            else if (_loc_2.ServerInfo != null)
            {
                if (_loc_2.ServerInfo == "onGameCancelled")
                {
                    if (this.vMatchCallback != null)
                    {
                        this.vMatchCallback.call(0, _loc_2.ServerInfo);
                    }
                    return;
                }
                if (Global.vGame != null && this.vMatchCallback != null)
                {
                    if (this.vMatchId != _loc_2.gameId)
                    {
                        if (this.vMatchId == null)
                        {
                            this.cancelMatchmaking(_loc_2.gameId);
                        }
                        else
                        {
                            this.onClientLog("error", "onScriptMessage gameId error expected=" + this.vMatchId + " received=" + _loc_2.gameId + " message=" + JSON.stringify(_loc_2));
                        }
                        return;
                    }
                    if (_loc_2.Args != null)
                    {
                        this.vMatchCallback.call(0, _loc_2.ServerInfo, _loc_2.Args);
                    }
                    else
                    {
                        this.vMatchCallback.call(0, _loc_2.ServerInfo);
                    }
                }
                else if (_loc_2.ServerInfo == "onSeatChange")
                {
                    if (this.vFakeGame)
                    {
                        this.vMatchId = _loc_2.gameId;
                        this.vMatchCallback.call(0, _loc_2.ServerInfo, _loc_2.Args);
                    }
                    else
                    {
                        this.cancelMatchmaking(_loc_2.gameId);
                    }
                }
                else if (_loc_2.ServerInfo == "onOrders")
                {
                    Global.addLogTrace("onOrders UNEXPECTED", "Sparks.as");
                }
            }
            else if (_loc_2.FinishNotification)
            {
                if (_loc_2.FinishNotification != null)
                {
                    this.onNotification(_loc_2);
                }
            }
            else if (_loc_2.chatMsg)
            {
                if (this.vMatchCallback != null)
                {
                    this.vMatchCallback.call(0, "ChatMsg", _loc_2);
                }
            }
            else if (_loc_2.TraceServer)
            {
                this.onClientLog("debug", "Message received");
            }
            else
            {
                Toolz.traceObject(_loc_2);
            }
            return;
        }// end function

        private function cancelMatchmaking(param1:String) : void
        {
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Game_CancelMatchMaking").setJSONEventAttribute("MatchId", param1).send(this.afterCancelMatchmaking);
            return;
        }// end function

        private function afterCancelMatchmaking(param1:LogEventResponse) : void
        {
            return;
        }// end function

        private function onNotification(param1:Object) : void
        {
            var _loc_2:* = null;
            if (param1 == null)
            {
                return;
            }
            if (param1.Code == null)
            {
                return;
            }
            if (this.vUser == null)
            {
                return;
            }
            _loc_2 = this.vUser.getChar(param1.Code);
            if (_loc_2 != null)
            {
                _loc_2.finishCurJob();
                if (Global.vRoot.vMenu != null)
                {
                    Global.vRoot.vMenu.onNotify(_loc_2, param1.FinishNotification);
                }
            }
            return;
        }// end function

        private function reloadPlayer() : void
        {
            this.loadUserDetails(this.afterReloadPlayer);
            return;
        }// end function

        private function afterReloadPlayer() : void
        {
            Global.vRoot.goMainMenu();
            return;
        }// end function

        public function forfeitMatch(param1:Function) : void
        {
            Global.addLogTrace("forfeitMatch", "Sparks.as");
            this.vMatchForfeitCallback = param1;
            if (this.vMatchId == null || this.vMatchId == "")
            {
                Global.vRoot.goMainMenu();
                return;
            }
            this.traceClient("Game_Forfeit MatchId=" + this.vMatchId);
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Game_Forfeit").setJSONEventAttribute("MatchId", this.vMatchId).send(this.onForfeitMatchDone);
            return;
        }// end function

        private function onForfeitMatchDone(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("onForfeitMatchDone error:" + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            this.vMatchForfeitCallback.call(0, param1.getScriptData());
            return;
        }// end function

        private function onGameCreated(param1:LogEventResponse) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (param1.HasErrors())
            {
                _loc_2 = param1.getAttribute("error");
                this.vMatchmakeInfoCallback.call(0, "onGameCreatedError:" + JSON.stringify(_loc_2));
            }
            else
            {
                _loc_3 = param1.getScriptData();
                this.vMatchmakeInfoCallback.call(0, "onGameCreated " + JSON.stringify(_loc_3));
                if (!_loc_3.success)
                {
                    this.vMatchCallback.call(0, "onError:Match creation failed");
                }
            }
            return;
        }// end function

        private function traceClient(param1:String) : void
        {
            if (this.vMatchCallback == null)
            {
                Global.addLogTrace("traceClient (vMatchCallback=null) pTrace=" + param1);
                return;
            }
            this.vMatchCallback.call(0, "Trace", {trace:param1});
            return;
        }// end function

        private function traceResponse(param1:String, param2:LogEventResponse) : void
        {
            if (param2.HasErrors())
            {
                this.traceClient(param1 + " Error=" + JSON.stringify(param2.getAttribute("error")));
            }
            else
            {
                this.traceClient(param1 + " data:" + JSON.stringify(param2.getScriptData()));
            }
            return;
        }// end function

        public function sendReady(param1:Function) : void
        {
            var _loc_2:* = null;
            this.vSendReadyCallback = param1;
            this.traceClient("call Game_PlayerReady vMatchId=" + this.vMatchId + " vFakeGame=" + this.vFakeGame);
            if (this.vServerCallRunning)
            {
                Global.addLogTrace("ERROR sendReady : vServerCallRunning=true", "Sparks.as");
                this.vSendReadyCallback.call(0, false);
                return;
            }
            if (Global.vServer.vUser.getTeamDesc() == "")
            {
                Global.addLogTrace("Not ready : cancel");
                return;
            }
            this.vServerCallRunning = true;
            _loc_2 = this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Game_PlayerReady").setJSONEventAttribute("SuddendeathVersion", GBL_Main.vSuddenDeathVersion).setJSONEventAttribute("Suddendeath", GBL_Main.vSuddenDeathDatas).setJSONEventAttribute("TeamDesc", JSON.parse(Global.vServer.vUser.getTeamDesc())).setJSONEventAttribute("MatchId", this.vMatchId);
            if (this.vFakeGame)
            {
                this.vSeat = 1;
                _loc_2 = _loc_2.setJSONEventAttribute("FakeId", this.vFakeData.Id);
                _loc_2 = _loc_2.setJSONEventAttribute("FakeTeam", this.vFakeData.Team);
            }
            _loc_2.send(this.onSendReady);
            return;
        }// end function

        private function onSendReady(param1:LogEventResponse) : void
        {
            Global.addLogTrace("onSendReady");
            this.vServerCallRunning = false;
            if (param1.HasErrors())
            {
                this.vSendReadyCallback.call(0, false);
            }
            else
            {
                this.vSendReadyCallback.call(0, true);
            }
            this.traceResponse("onSendReady", param1);
            return;
        }// end function

        public function sendOrders(param1:Function, param2:int, param3:String, param4:String = "") : void
        {
            var _loc_5:* = null;
            if (this.vMatchId == "")
            {
                return;
            }
            this.vSendOrderCallback = param1;
            this.traceClient("sendOrders MatchId=" + this.vMatchId + " Round=" + param2);
            this.vSendOrderSaveRound = param2;
            this.vSendOrderSaveOrders = param3;
            _loc_5 = this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Game_Orders").setJSONEventAttribute("MatchId", this.vMatchId).setJSONEventAttribute("Round", param2).setJSONEventAttribute("Orders", param3).setJSONEventAttribute("Infos", Global.vGame.getEnergyRoundInfos());
            if (this.vFakeGame)
            {
                _loc_5.setJSONEventAttribute("FakeId", this.vFakeData.Id);
                _loc_5.setJSONEventAttribute("FakeOrders", param4);
            }
            _loc_5.send(this.onSendOrders);
            return;
        }// end function

        private function onSendOrders(param1:LogEventResponse) : void
        {
            this.traceResponse("onSendOrders", param1);
            var _loc_2:* = param1.getScriptData();
            if (_loc_2 != null)
            {
                if (_loc_2.running == false)
                {
                    this.vMatchCallback.call(0, "GameAlreadyFinished", {reward:_loc_2.reward});
                }
                else if (_loc_2.needSynchro == true)
                {
                    this.vSendOrderCallback.call(0, false, true);
                    return;
                }
            }
            if (param1.HasErrors())
            {
                this.vSendOrderCallback.call(0, false);
            }
            else
            {
                this.vSendOrderCallback.call(0, true);
            }
            return;
        }// end function

        public function sendSynchro(param1:int, param2:String) : void
        {
            this.traceClient("sendSynchro MatchId=" + this.vMatchId + " Round=" + param1);
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Game_Synchro").setJSONEventAttribute("MatchId", this.vMatchId).setJSONEventAttribute("Round", param1).setJSONEventAttribute("Synchro", param2).send(this.onSendSynchro);
            return;
        }// end function

        private function onSendSynchro(param1:LogEventResponse) : void
        {
            this.traceResponse("onSendSynchro", param1);
            return;
        }// end function

        public function checkLeaver(param1:Function) : void
        {
            this.vCheckLeaverCallback = param1;
            if (this.vServerCallRunning)
            {
                Global.addLogTrace("ERROR checkLeaver : vServerCallRunning=true", "Sparks.as");
                this.vCheckLeaverCallback.call(0, false);
                return;
            }
            this.vServerCallRunning = true;
            if (this.vIsConnected == false)
            {
                return;
            }
            if (this.vMatchId == "")
            {
                Global.addLogTrace("checkLeaver error vMatchId isNull", "Sparks.as");
                return;
            }
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Game_CheckLeaver").setJSONEventAttribute("MatchId", this.vMatchId).send(this.onCheckLeaver);
            return;
        }// end function

        private function onCheckLeaver(param1:LogEventResponse) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            this.vServerCallRunning = false;
            if (param1.HasErrors())
            {
                Global.addLogTrace("onCheckLeaver error:" + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.vCheckLeaverCallback.call(0, false);
            }
            else
            {
                _loc_2 = param1.getScriptData();
                Global.addLogTrace("onCheckLeaver ok data=" + JSON.stringify(_loc_2), "Sparks.as");
                if (_loc_2 != null)
                {
                    if (_loc_2.running == false)
                    {
                        this.vMatchCallback.call(0, "GameAlreadyFinished");
                        return;
                    }
                    if (_loc_2.lastOrder != null)
                    {
                        _loc_3 = _loc_2.lastOrder;
                    }
                }
                this.vCheckLeaverCallback.call(0, true, _loc_3);
            }
            return;
        }// end function

        public function sendChatMessage(param1:String) : void
        {
            if (this.vOpponentId == "")
            {
                this.vOpponentId = Global.vServer.vUser.vUserId;
            }
            var _loc_2:* = "";
            if (this.vMatchId != null)
            {
                _loc_2 = this.vMatchId;
            }
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Game_Chat").setJSONEventAttribute("msgCode", param1).setJSONEventAttribute("opponentId", this.vOpponentId).setJSONEventAttribute("MatchId", _loc_2).send(this.onChatMessage);
            return;
        }// end function

        private function onChatMessage(param1:LogEventResponse) : void
        {
            return;
        }// end function

        public function getShopVirtualGoods(param1:Function) : void
        {
            this.vShopCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Shop_GetVG").send(this.onGetShopVirtualGoods);
            return;
        }// end function

        private function onGetShopVirtualGoods(param1:LogEventResponse) : void
        {
            var _loc_2:* = 0;
            var _loc_5:* = null;
            if (param1.HasErrors())
            {
                this.vShopCallback.call(0, false, new Array());
                return;
            }
            var _loc_3:* = new Array();
            var _loc_4:* = new Array();
            if (param1.getScriptData() != null)
            {
                _loc_5 = param1.getScriptData();
                if (_loc_5.Cards != null)
                {
                    _loc_2 = 0;
                    while (_loc_2 < _loc_5.Cards.length)
                    {
                        
                        _loc_3.push({type:"Card", price:_loc_5.Cards[_loc_2].Price, code:_loc_5.Cards[_loc_2]._id, time:_loc_5.Cards[_loc_2].Time, nb:1});
                        _loc_2++;
                    }
                }
                if (_loc_5.Packs != null)
                {
                    _loc_2 = 0;
                    while (_loc_2 < _loc_5.Packs.length)
                    {
                        
                        _loc_3.push({type:"Pack", price:_loc_5.Packs[_loc_2].Price, code:_loc_5.Packs[_loc_2]._id, time:0, nb:_loc_5.Packs[_loc_2].Nb});
                        _loc_2++;
                    }
                }
                if (_loc_5.Gold != null)
                {
                    _loc_2 = 0;
                    while (_loc_2 < _loc_5.Gold.length)
                    {
                        
                        _loc_3.push({type:"Gold", price:_loc_5.Gold[_loc_2].Price, code:_loc_5.Gold[_loc_2]._id, time:0, nb:_loc_5.Gold[_loc_2].Nb});
                        _loc_4.push(_loc_5.Gold[_loc_2]._id);
                        _loc_2++;
                    }
                }
            }
            _loc_2 = 0;
            while (_loc_2 < _loc_3.length)
            {
                
                if (_loc_3[_loc_2].type == "Gold")
                {
                    _loc_3[_loc_2].price = "dev:" + parseInt(_loc_3[_loc_2].price) / 100 + "€";
                }
                _loc_2++;
            }
            _loc_3 = _loc_3.sort(this.sortGoodsForShop);
            this.vShopCallback.call(0, true, _loc_3);
            return;
        }// end function

        private function sortGoodsForShop(param1:Object, param2:Object) : int
        {
            if (param1.type != param2.type && (param1.type == "Gold" || param2.type == "Gold"))
            {
                if (param1.type == "Gold")
                {
                    return 1;
                }
                if (param2.type == "Gold")
                {
                    return -1;
                }
                return 0;
            }
            if (param1.time < param2.time)
            {
                return 1;
            }
            if (param1.time > param2.time)
            {
                return -1;
            }
            if (param1.type == "Gold")
            {
                if (param1.nb < param2.nb)
                {
                    return -1;
                }
                if (param1.nb > param2.nb)
                {
                    return 1;
                }
            }
            if (param1.price < param2.price)
            {
                return -1;
            }
            if (param1.price > param2.price)
            {
                return 1;
            }
            return 0;
        }// end function

        public function buyVirtualGood(param1:Function, param2:String) : void
        {
            this.vShopCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Shop_Buy").setJSONEventAttribute("vgCode", param2).send(this.onBuyVirtualGood);
            return;
        }// end function

        private function onBuyVirtualGood(param1:LogEventResponse) : void
        {
            var _loc_2:* = null;
            if (param1.HasErrors())
            {
                Global.onError("Sparks.onBuyVirtualGood : " + JSON.stringify(param1.getErrors()));
                this.vShopCallback.call(0, false);
            }
            else
            {
                _loc_2 = param1.getScriptData();
                if (_loc_2.NewBalance != null)
                {
                    this.vUser.vHardCurrency = _loc_2.NewBalance;
                }
                this.vShopCallback.call(0, true, _loc_2.BoughtCards);
            }
            return;
        }// end function

        public function swapPosition(param1:Function, param2:Sparks_Char, param3:Sparks_Char) : void
        {
            var _loc_4:* = param2.vPosition;
            param2.vPosition = param3.vPosition;
            param3.vPosition = _loc_4;
            this.vSwapPositionCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Char_SwapPos").setJSONEventAttribute("cCode1", param2.vCharId).setJSONEventAttribute("cCode2", param3.vCharId).send(this.onSwapPosition);
            return;
        }// end function

        private function onSwapPosition(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            this.vSwapPositionCallback.call();
            return;
        }// end function

        public function getShirtList(param1:Function) : void
        {
            this.vShirtCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Shirt_GetList").send(this.onShirtList);
            return;
        }// end function

        private function onShirtList(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            this.vShirtCallback.call(0, param1.getScriptData());
            return;
        }// end function

        public function buyShirt(param1:Function, param2:String) : void
        {
            this.vShirtCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Shirt_Buy").setJSONEventAttribute("sCode", param2).send(this.onShirtBuy);
            return;
        }// end function

        private function onShirtBuy(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            this.loadUserDetails(this.vShirtCallback);
            return;
        }// end function

        public function selectShirt(param1:Function, param2:String) : void
        {
            Global.addLogTrace("createLogEventRequest:" + "Shirt_Use");
            this.vShirtCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Shirt_Use").setJSONEventAttribute("sCode", param2).send(this.onShirtSelect);
            return;
        }// end function

        private function onShirtSelect(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            this.loadUserDetails(this.vShirtCallback);
            return;
        }// end function

        public function getLeaderBoardGeneral(param1:Function) : void
        {
            this.vLeaderBoardCallback = param1;
            this.vLeaderBoardLocal = false;
            this.gs.getRequestBuilder().createLeaderboardDataRequest().setEntryCount(this.vLeaderBoardNbPerPage).setLeaderboardShortCode(this.vLeaderBoardShortCodeGeneral).send(this.onLeaderBoardData);
            return;
        }// end function

        public function getLeaderBoardLocal(param1:Function) : void
        {
            this.vLeaderBoardCallback = param1;
            this.vLeaderBoardLocal = true;
            this.gs.getRequestBuilder().createLeaderboardDataRequest().setEntryCount(this.vLeaderBoardNbPerPage).setLeaderboardShortCode(this.vLeaderBoardShortCodeLocal + this.vUser.vCountry).send(this.onLeaderBoardData);
            return;
        }// end function

        public function getLeaderBoardFriends(param1:Function) : void
        {
            this.vLeaderBoardCallback = param1;
            if (!Login.isFacebookLogged())
            {
                this.vLeaderBoardCallback.call(0, "NoFacebook");
                return;
            }
            this.gs.getRequestBuilder().createSocialLeaderboardDataRequest().setEntryCount(this.vLeaderBoardNbPerPage).setLeaderboardShortCode(this.vLeaderBoardShortCodeGeneral).send(this.onLeaderBoardData);
            return;
        }// end function

        private function onLeaderBoardData(param1:LeaderboardDataResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            this.vLeaderBoardData = param1.getData();
            var _loc_2:* = new Vector.<String>;
            if (this.vLeaderBoardLocal)
            {
                _loc_2.push(this.vLeaderBoardShortCodeLocal + this.vUser.vCountry);
            }
            else
            {
                _loc_2.push(this.vLeaderBoardShortCodeGeneral);
            }
            this.gs.getRequestBuilder().createLeaderboardsEntriesRequest().setLeaderboards(_loc_2).send(this.onLeaderBoardUserData);
            return;
        }// end function

        private function onLeaderBoardUserData(param1:LeaderboardsEntriesResponse) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            if (this.vLeaderBoardLocal)
            {
                _loc_3 = param1.getAttribute(this.vLeaderBoardShortCodeLocal + this.vUser.vCountry);
            }
            else
            {
                _loc_3 = param1.getAttribute(this.vLeaderBoardShortCodeGeneral);
            }
            if (_loc_3 != null)
            {
                _loc_2 = _loc_3[0];
            }
            this.vLeaderBoardCallback.call(0, "Data", this.vLeaderBoardData, _loc_2);
            return;
        }// end function

        public function validatePurchase(param1:Function, param2:String, param3:String) : void
        {
            this.vValidateCallback = param1;
            this.vTransitionId = param2;
            this.gs.getRequestBuilder().createGooglePlayBuyGoodsRequest().setTimeoutSeconds(20).setSignature(param3).setSignedData(param2).send(this.onValidatePurchase);
            return;
        }// end function

        private function onValidatePurchase(param1:BuyVirtualGoodResponse) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            Global.addLogTrace("onValidatePurchase", "Sparks.as");
            if (param1.HasErrors())
            {
                Global.vStats.Stats_Event("InAppPurchase", "IAP_Gamesparks_Validate_Error", JSON.stringify(param1.getErrors()));
                this.vValidateCallback.call(0, "error");
            }
            else
            {
                _loc_2 = param1.getCurrency1Added();
                Global.vStats.Stats_Event("InAppPurchase", "IAP_Gamesparks_Validate_Ok", "Gold", _loc_2);
                _loc_3 = param1.getScriptData();
                Global.vMyInApp.manualFinishTransaction();
                this.vValidateCallback.call(0, "ok", _loc_2, _loc_3);
            }
            return;
        }// end function

        public function loadPromoPackInfos(param1:Function, param2:String) : void
        {
            this.vPromoPackCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Shop_GetPromoPack").setJSONEventAttribute("packId", param2).send(this.onPromoPackInfos);
            return;
        }// end function

        private function onPromoPackInfos(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            var _loc_2:* = param1.getScriptData();
            this.vPromoPackCallback.call(0, _loc_2);
            return;
        }// end function

        public function shopTrace(param1:Object) : void
        {
            Global.addLogTrace("ShopTrace:" + JSON.stringify(param1));
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Shop_Trace").setJSONEventAttribute("trace", param1).send(this.onShopTrace);
            return;
        }// end function

        private function onShopTrace(param1:LogEventResponse) : void
        {
            return;
        }// end function

        public function loadProfile(param1:Function, param2:String) : void
        {
            this.vProfileCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("User_GetInfos").setJSONEventAttribute("uid", param2).send(this.onLoadProfile);
            return;
        }// end function

        private function onLoadProfile(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            var _loc_2:* = param1.getScriptData();
            this.vProfileCallback.call(0, _loc_2);
            return;
        }// end function

        public function consumeBooster(param1:Function, param2:String) : void
        {
            this.vConsumeBooster = param1;
            var _loc_3:* = "";
            if (this.vMatchId != null)
            {
                _loc_3 = this.vMatchId;
            }
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Game_UseBooster").setJSONEventAttribute("vgCode", param2).setJSONEventAttribute("MatchId", _loc_3).send(this.onConsumeBooster);
            return;
        }// end function

        private function onConsumeBooster(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            var _loc_2:* = param1.getScriptData();
            if (_loc_2 == null)
            {
                this.vConsumeBooster.call(0, false);
            }
            else
            {
                this.vUser.setCards(_loc_2.RemainingVG.Card, _loc_2.RemainingVG.NewBalance);
                this.vConsumeBooster.call(0, true);
            }
            return;
        }// end function

        public function rewardDisplayed() : void
        {
            var _loc_1:* = "";
            if (this.vMatchId != null)
            {
                _loc_1 = this.vMatchId;
            }
            Global.addLogTrace("rewardDisplayed lMatchId=" + _loc_1);
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Client_RewardDisplayed").setJSONEventAttribute("MatchId", _loc_1).send(this.onRewardDisplayed);
            this.killGame("rewardDisplayed");
            return;
        }// end function

        private function onRewardDisplayed(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            return;
        }// end function

        public function startTrade(param1:Function, param2:String) : void
        {
            this.vTradeCallback = param1;
            this.vTradeType = param2;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Card_Exchange").setJSONEventAttribute("vgCode", param2).send(this.onTradeResult);
            return;
        }// end function

        private function onTradeResult(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            var _loc_2:* = param1.getScriptData();
            if (_loc_2 == null)
            {
                this.vTradeCallback.call(0, false);
            }
            else
            {
                if (this.vTradeType == "PA")
                {
                    this.vUser.addCards("PA", -Global.vExchangeRate);
                    this.vUser.addCards("PB", 1);
                }
                else if (this.vTradeType == "PB")
                {
                    this.vUser.addCards("PB", -Global.vExchangeRate);
                    this.vUser.addCards("PC", 1);
                }
                else if (this.vTradeType == "SA")
                {
                    this.vUser.addCards("SA", -Global.vExchangeRate);
                    this.vUser.addCards("SB", 1);
                }
                else if (this.vTradeType == "SB")
                {
                    this.vUser.addCards("SB", -Global.vExchangeRate);
                    this.vUser.addCards("SC", 1);
                }
                this.vTradeCallback.call(0, true);
            }
            return;
        }// end function

        public function getHistoryGames(param1:Function, param2:String) : void
        {
            this.vHistoryGamesCallback = param1;
            var _loc_3:* = "Games_History";
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey(_loc_3).setJSONEventAttribute("type", param2).send(this.onHistoryGamesResult);
            return;
        }// end function

        private function onHistoryGamesResult(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            var _loc_2:* = param1.getScriptData();
            this.vHistoryGamesCallback.call(0, _loc_2);
            return;
        }// end function

        public function temp2() : void
        {
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Temp2").setJSONEventAttribute("param", "TooManyLeaver").send(this.onTemp2);
            return;
        }// end function

        private function onTemp2(param1:LogEventResponse) : void
        {
            return;
        }// end function

        public function temp3() : void
        {
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Temp3").send(this.onTemp3);
            return;
        }// end function

        private function onTemp3(param1:LogEventResponse) : void
        {
            Global.vRoot.goMainMenu();
            return;
        }// end function

        public function loadGeneralMessage(param1:Function) : void
        {
            this.vGeneralMessageCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("User_GetMsg").send(this.onGeneralMessageResult);
            return;
        }// end function

        private function onGeneralMessageResult(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                return;
            }
            var _loc_2:* = param1.getScriptData();
            if (_loc_2 == null)
            {
                return;
            }
            if (_loc_2.Msg == null)
            {
                return;
            }
            this.vGeneralMessageCallback.call(0, _loc_2.Msg, _loc_2.MsgPerso);
            return;
        }// end function

        public function loadReplay(param1:Function, param2:String) : void
        {
            this.vReplayCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Game_Replay").setJSONEventAttribute("action", "get").setJSONEventAttribute("MatchId", param2).send(this.onReplay);
            return;
        }// end function

        private function onReplay(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                Global.vRoot.goMainMenu();
                return;
            }
            var _loc_2:* = param1.getScriptData();
            if (_loc_2 == null)
            {
                return;
            }
            if (_loc_2.game == null)
            {
                return;
            }
            this.vReplayCallback.call(0, _loc_2.game);
            return;
        }// end function

        public function saveReplay(param1:Function, param2:String) : void
        {
            this.vReplaySaveCallback = param1;
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Game_Replay").setJSONEventAttribute("action", "save").setJSONEventAttribute("MatchId", param2).send(this.onReplaySaved);
            return;
        }// end function

        private function onReplaySaved(param1:LogEventResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("response error : " + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.checkError(param1);
                Global.vRoot.goMainMenu();
                return;
            }
            var _loc_2:* = param1.getScriptData();
            if (_loc_2 == null)
            {
                return;
            }
            if (_loc_2.NewBalance == null)
            {
                return;
            }
            this.vReplaySaveCallback.call(0, _loc_2.NewBalance);
            return;
        }// end function

        private function parseConsecutiveWins(param1:Object) : void
        {
            var _loc_2:* = null;
            Global.vConsecutiveWins = new Array();
            if (param1 == null)
            {
                return;
            }
            var _loc_3:* = 0;
            while (_loc_3 < param1.cards.length)
            {
                
                _loc_2 = new Object();
                _loc_2.cards = parseInt(param1.cards[_loc_3]);
                _loc_2.trophies = parseInt(param1.trophies[_loc_3]);
                Global.vConsecutiveWins.push(_loc_2);
                _loc_3++;
            }
            return;
        }// end function

        public function loadBG(param1:Function) : void
        {
            this.vBGCallback = param1;
            if (this.vBGBitmapData != null)
            {
                this.vBGCallback.call(0, this.vBGBitmapData);
                return;
            }
            this.gs.getRequestBuilder().createGetDownloadableRequest().setShortCode("bg_classic").send(this.onLoadBG);
            return;
        }// end function

        private function onLoadBG(param1:GetDownloadableResponse) : void
        {
            if (param1.HasErrors())
            {
                Global.addLogTrace("onLoadBG Error=" + JSON.stringify(param1.getErrors()), "Sparks.as");
                this.vBGCallback.call(0, null);
                return;
            }
            var _loc_2:* = param1.getUrl();
            var _loc_3:* = new Loader();
            _loc_3.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onLoadBGComplete);
            _loc_3.load(new URLRequest(_loc_2));
            return;
        }// end function

        private function onLoadBGComplete(event:Event) : void
        {
            this.vBGBitmapData = Bitmap(LoaderInfo(event.target).content).bitmapData;
            this.vBGCallback.call(0, this.vBGBitmapData);
            return;
        }// end function

        private function initCustomPing() : void
        {
            if (this.vCustomPingStarted)
            {
                return;
            }
            this.vCustomPingStarted = true;
            this.vCustomPingCount = 0;
            TweenMax.delayedCall(0.5, this.nextCustomPing);
            return;
        }// end function

        private function nextCustomPing() : void
        {
            var _loc_1:* = this;
            var _loc_2:* = this.vCustomPingCount + 1;
            _loc_1.vCustomPingCount = _loc_2;
            this.vCustomPingLast = getTimer();
            this.gs.getRequestBuilder().createLogEventRequest().setEventKey("Custom_Ping").setJSONEventAttribute("Count", this.vCustomPingCount).send(this.onCustomPing);
            return;
        }// end function

        private function onCustomPing(param1:LogEventResponse) : void
        {
            if (param1.getScriptData().Count != this.vCustomPingCount)
            {
                Global.addLogTrace("Custom Ping ERROR !");
                return;
            }
            if (Global.vTopBar != null)
            {
                Global.vTopBar.forceGold(this.vCustomPingCount);
            }
            var _loc_2:* = getTimer() - this.vCustomPingLast;
            this.vCustomPingLast = this.vCustomPingLast + _loc_2;
            _loc_2 = 0.5 - _loc_2 / 1000;
            if (_loc_2 < 0)
            {
                _loc_2 = 0;
            }
            TweenMax.delayedCall(_loc_2, this.nextCustomPing);
            return;
        }// end function

    }
}
