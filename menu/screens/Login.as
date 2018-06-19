package menu.screens
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;
    import globz.*;
    import menu.*;
    import menu.game.*;
    import menu.popup.*;
    import menu.tools.*;
    import tools.*;

    public class Login extends MenuXXX
    {
        private var vGuestUniqueId:String;
        private var vGuestOS:String = "W8";
        private var vGuestNewAccount:Boolean;
        private var vScreen:SettingsScreen;
        private var vFacebookToken:String = "";
        public static var vFacebookFirstChoice:Boolean = false;
        public static var vStatsDone:Object = new Object();

        public function Login()
        {
            vTag = "Login";
            return;
        }// end function

        private function addLoadingInfo(param1:String) : void
        {
            Global.addLogTrace("addLoadingInfo:" + param1, "Login");
            return;
        }// end function

        override protected function init() : void
        {
            Global.vStats.Stats_PageView("Login");
            this.doLogin();
            return;
        }// end function

        private function doLogin() : void
        {
            var _loc_1:* = SharedObject.getLocal(Global.SO_ID);
            this.vGuestOS = "Android";
            var _loc_2:* = _loc_1.data.login_type;
            Global.addLogTrace("login_type=" + _loc_2);
            this.addLoadingInfo("Login type:" + _loc_2);
            if (_loc_2 == "guest")
            {
                Global.addLogTrace("login_id=" + _loc_1.data.login_id);
                if (_loc_1.data.login_id != null)
                {
                    this.vGuestUniqueId = _loc_1.data.login_id;
                    this.vGuestOS = _loc_1.data.login_os;
                    Global.vServer.loginGuestAccount(this.onLoginGuest, this.vGuestOS, this.vGuestUniqueId);
                }
                else
                {
                    resetSO();
                    this.init();
                }
            }
            else if (_loc_2 == "facebook")
            {
                Global.addLogTrace("login_token=" + _loc_1.data.login_token);
                if (Global.vDev)
                {
                }
                Global.vServer.loginFacebook(this.onLoginFaceboook, _loc_1.data.login_token);
            }
            else if (_loc_2 == "tutorialdone")
            {
                Global.addLogTrace("Ask Guest or Facebook");
                this.goChooseAccount();
            }
            else
            {
                Global.vRoot.launchMenu(Tutorial);
            }
            return;
        }// end function

        private function onLoginFaceboook(param1:Boolean) : void
        {
            this.addLoadingInfo("onLoginFaceboook:" + param1);
            if (param1)
            {
                if (this.vFacebookToken != "")
                {
                    saveSOFacebook(this.vFacebookToken);
                }
                if (Global.vServer.vDisplayName.substr(0, 5) == "Guest")
                {
                    Global.vServer.vFacebookNewPlayer = true;
                }
                if (Global.vServer.vFacebookNewPlayer)
                {
                    Settings.vAskPseudo = true;
                    Global.vRoot.launchMenu(Settings);
                }
                else
                {
                    Home.vAccountFirstTime = false;
                    this.goSplash();
                }
            }
            else
            {
                Global.addLogTrace("Error loginFacebook", "Login");
                Global.addLogTrace("Rebuild facebook token", "Login");
                resetSO();
                if (Global.vMyFacebook == null)
                {
                    Global.vMyFacebook = new MyFacebook();
                }
                Global.vMyFacebook.getNewLogin(this.onNewLoginFaceboook);
            }
            return;
        }// end function

        private function onNewLoginFaceboook(param1:String) : void
        {
            Global.addLogTrace("onNewLoginFaceboook pToken=" + param1);
            Global.vServer.loginFacebook(this.onLoginFaceboook, param1);
            return;
        }// end function

        private function onLoginGuest(param1:String, param2:Boolean) : void
        {
            Global.addLogTrace("onLoginGuest vFacebookFirstChoice=" + vFacebookFirstChoice + " vGuestNewAccount=" + this.vGuestNewAccount);
            Global.addLogTrace("onLoginGuest DisplayName=" + param1 + " New=" + param2);
            if (this.vGuestNewAccount)
            {
                if (!param2)
                {
                    this.init();
                    return;
                }
            }
            var _loc_3:* = SharedObject.getLocal(Global.SO_ID);
            _loc_3.data.login_type = "guest";
            _loc_3.data.login_id = this.vGuestUniqueId;
            _loc_3.data.login_os = this.vGuestOS;
            _loc_3.flush();
            if (Settings.vFacebookDirect)
            {
                Global.vRoot.launchMenu(Settings);
            }
            else
            {
                this.goSplash();
            }
            return;
        }// end function

        private function goSplash() : void
        {
            if (Replay.vAutoStart)
            {
                Global.vRoot.launchMenu(Replay);
                return;
            }
            Global.vRoot.launchMenu(Home);
            return;
        }// end function

        private function onLogin(param1:Boolean) : void
        {
            if (param1)
            {
                this.goSplash();
            }
            else
            {
                resetSO();
                new MsgBox(this, Global.getText("txtLoginError"), this.init);
            }
            return;
        }// end function

        private function cleanScreen() : void
        {
            if (this.vScreen != null)
            {
                removeChild(this.vScreen);
                this.vScreen = null;
            }
            return;
        }// end function

        private function goChooseAccount() : void
        {
            var _loc_1:* = null;
            if (Global.vTopBar != null)
            {
                Global.vTopBar.hide();
            }
            Home.vAccountFirstTime = true;
            Global.vHitPoints = true;
            this.cleanScreen();
            Global.vRoot.removeLoading();
            this.vScreen = new SettingsScreen();
            this.vScreen.gotoAndStop(4);
            this.vScreen.x = Global.vSize.x / 2;
            this.vScreen.y = Global.vSize.y / 2;
            addChild(this.vScreen);
            this.vScreen.txtCongrats.htmlText = "<B>" + Global.getText("txtCongrats") + "</B>";
            Global.vLang.checkSans(this.vScreen.txtCongrats);
            Toolz.textReduce(this.vScreen.txtCongrats);
            this.vScreen.txtIntroQuestion.htmlText = "<B>" + Global.getText("txtIntroQuestion") + "</B>";
            Global.vLang.checkSans(this.vScreen.txtIntroQuestion);
            this.vScreen.txtIntroBenefits.htmlText = "<B>" + Global.getText("txtIntroBenefits") + "</B>";
            Global.vLang.checkSans(this.vScreen.txtIntroBenefits);
            this.vScreen.txtIntroBenefitsContents.htmlText = "<B>" + Global.getText("txtIntroBenefitsContents");
            Global.vLang.checkSans(this.vScreen.txtIntroBenefitsContents);
            this.vScreen.txtIntroNoPost.htmlText = "<B>" + Global.getText("txtIntroNoPost");
            Global.vLang.checkSans(this.vScreen.txtIntroNoPost);
            var _loc_2:* = addButton(this.vScreen, new FacebookButton(), new Point(this.vScreen.mcButtonFacebook.x, this.vScreen.mcButtonFacebook.y), this.onChoiceFacebook);
            var _loc_3:* = 0.75;
            _loc_2.scaleY = 0.75;
            _loc_2.scaleX = _loc_3;
            _loc_1 = new ButtonTextBitmap(Menu_TextButtonDoubleLine, Global.getText("txtFacebookConnect"), 1, true);
            addButton(this.vScreen, _loc_1, new Point(this.vScreen.mcButtonFacebookText.x, this.vScreen.mcButtonFacebookText.y), this.onChoiceFacebook);
            _loc_1 = new ButtonTextBitmap(Menu_TextButtonDoubleLine, Global.getText("txtIntroGuest").toLowerCase(), 1, true);
            addButton(this.vScreen, _loc_1, new Point(this.vScreen.mcButtonGuest.x, this.vScreen.mcButtonGuest.y), this.onChoiceGuest);
            this.doStats("ChooseAccount Start");
            return;
        }// end function

        private function onChoiceGuest(event:Event) : void
        {
            this.doStats("ChooseAccount goGuest");
            this.createGuestAccount();
            return;
        }// end function

        private function onChoiceFacebook(event:Event = null) : void
        {
            this.doStats("ChooseAccount goGuest");
            vFacebookFirstChoice = true;
            Settings.vFacebookDirect = true;
            this.createGuestAccount();
            return;
        }// end function

        private function createGuestAccount() : void
        {
            this.cleanScreen();
            this.vGuestNewAccount = true;
            this.vGuestUniqueId = Global.vServer.getUniqueId();
            var _loc_1:* = SharedObject.getLocal(Global.SO_ID);
            _loc_1.data.login_type = "guest";
            _loc_1.data.login_id = this.vGuestUniqueId;
            _loc_1.data.login_os = this.vGuestOS;
            _loc_1.flush();
            Global.vServer.loginGuestAccount(this.onLoginGuest, this.vGuestOS, this.vGuestUniqueId);
            return;
        }// end function

        private function onFacebookMsg(param1:String) : void
        {
            var _loc_2:* = param1.split(":");
            if (_loc_2[0] == "token")
            {
                this.vFacebookToken = _loc_2[1];
                Global.addLogTrace("Facebook token:" + this.vFacebookToken);
                saveSOFacebook(this.vFacebookToken);
                Global.vServer.loginFacebook(this.onLoginFaceboook, this.vFacebookToken);
                this.doStats("ChooseAccount FacebookSuccess");
            }
            else
            {
                Global.addLogTrace("onFacebookMsg:" + param1);
                new MsgBox(this, Global.getText("txtFacebookCancelled"), this.init);
                this.doStats("ChooseAccount FacebookFail");
            }
            return;
        }// end function

        private function doStats(param1:String) : void
        {
            if (vStatsDone[param1])
            {
                return;
            }
            vStatsDone[param1] = true;
            var _loc_2:* = Math.round((getTimer() - Tutorial.vFunnelTimer) / 1000);
            Tutorial.vFunnelTimer = getTimer();
            Global.vStats.Stats_Event("Funnel", param1, "Timer", _loc_2);
            return;
        }// end function

        public static function resetSO(param1:String = "") : void
        {
            Global.addLogTrace("resetSO");
            var _loc_2:* = SharedObject.getLocal(Global.SO_ID);
            _loc_2.data.login_type = param1;
            delete _loc_2.data.tuto_step;
            delete _loc_2.data.HelpCharDone;
            _loc_2.flush();
            return;
        }// end function

        public static function saveSOFacebook(param1:String) : void
        {
            Global.addLogTrace("saveSOFacebook");
            var _loc_2:* = SharedObject.getLocal(Global.SO_ID);
            _loc_2.data.login_type = "facebook";
            _loc_2.data.login_token = param1;
            _loc_2.flush();
            return;
        }// end function

        public static function isTutorialDone() : Boolean
        {
            var _loc_1:* = SharedObject.getLocal(Global.SO_ID);
            if (_loc_1.data.login_type == null)
            {
                return false;
            }
            if (_loc_1.data.login_type == "tutorial")
            {
                return false;
            }
            return true;
        }// end function

        public static function onTutorialDone() : void
        {
            Global.addLogTrace("onTutorialDone");
            var _loc_1:* = SharedObject.getLocal(Global.SO_ID);
            _loc_1.data.login_type = "tutorialdone";
            _loc_1.flush();
            return;
        }// end function

        public static function getSOGuestId() : String
        {
            var _loc_1:* = SharedObject.getLocal(Global.SO_ID);
            if (_loc_1.data.login_type != "guest")
            {
                return "SO_NoGuestId";
            }
            return _loc_1.data.login_id;
        }// end function

        public static function isFacebookLogged() : Boolean
        {
            var _loc_1:* = SharedObject.getLocal(Global.SO_ID);
            if (_loc_1.data.login_type == "facebook")
            {
                return true;
            }
            return false;
        }// end function

    }
}
