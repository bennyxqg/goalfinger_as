package menu.popup
{
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import globz.*;
    import menu.*;
    import menu.screens.*;
    import menu.tools.*;
    import tools.*;

    public class Settings extends MenuXXX
    {
        private var vScreen:SettingsScreen;
        private var vFacebookToken:String;
        private var vNewPseudo:String = "";
        public static var vFacebookDirect:Boolean = false;
        public static var vAskPseudo:Boolean = false;
        public static var vNeedRelog:Boolean = false;

        public function Settings()
        {
            vTag = "Settings";
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            return;
        }// end function

        override protected function init() : void
        {
            if (vAskPseudo)
            {
                vAskPseudo = false;
                this.askPseudo();
                return;
            }
            if (vFacebookDirect)
            {
                vFacebookDirect = false;
                this.doConnectFacebook();
                return;
            }
            this.showMenu();
            Global.vStats.Stats_PageView("Settings");
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

        private function showScreen(param1:int) : void
        {
            var _loc_2:* = null;
            this.cleanScreen();
            this.vScreen = new SettingsScreen();
            this.vScreen.gotoAndStop(param1);
            this.vScreen.x = Global.vSize.x / 2;
            this.vScreen.y = Global.vSize.y / 2;
            addChild(this.vScreen);
            if (param1 != 2)
            {
                _loc_2 = new ButtonGrafBitmap(new MenuButton_Quit());
                addButton(this.vScreen, _loc_2, new Point(this.vScreen.mcQuit.x, this.vScreen.mcQuit.y), this.goQuit, 1);
            }
            return;
        }// end function

        private function goQuit(event:Event) : void
        {
            if (Capabilities.isDebugger)
            {
                if (this.vScreen.btMusic != null)
                {
                    this.vScreen.btMusic.removeEventListener(MouseEvent.MOUSE_DOWN, this.toggleMusic);
                }
                if (this.vScreen.btSound != null)
                {
                    this.vScreen.btSound.removeEventListener(MouseEvent.MOUSE_DOWN, this.toggleSounds);
                }
                if (this.vScreen.btMail != null)
                {
                    this.vScreen.btMail.removeEventListener(MouseEvent.MOUSE_DOWN, this.SendMail);
                }
                if (this.vScreen.btFacebook != null)
                {
                    this.vScreen.btFacebook.removeEventListener(MouseEvent.MOUSE_DOWN, this.goFacebook);
                }
                if (this.vScreen.btTwitter != null)
                {
                    this.vScreen.btTwitter.removeEventListener(MouseEvent.MOUSE_DOWN, this.goTwitter);
                }
            }
            else
            {
                if (this.vScreen.btMusic != null)
                {
                    this.vScreen.btMusic.removeEventListener(TouchEvent.TOUCH_BEGIN, this.toggleMusic);
                }
                if (this.vScreen.btSound != null)
                {
                    this.vScreen.btSound.removeEventListener(TouchEvent.TOUCH_BEGIN, this.toggleSounds);
                }
                if (this.vScreen.btMail != null)
                {
                    this.vScreen.btMail.removeEventListener(TouchEvent.TOUCH_BEGIN, this.SendMail);
                }
                if (this.vScreen.btFacebook != null)
                {
                    this.vScreen.btFacebook.removeEventListener(TouchEvent.TOUCH_BEGIN, this.goFacebook);
                }
                if (this.vScreen.btTwitter != null)
                {
                    this.vScreen.btTwitter.removeEventListener(TouchEvent.TOUCH_BEGIN, this.goTwitter);
                }
            }
            if (vNeedRelog)
            {
                vNeedRelog = false;
                this.cleanScreen();
                Global.vServer.logout();
                Global.vRoot.entryPoint();
                return;
            }
            Global.vSound.onButton();
            Global.vRoot.quitPopup();
            return;
        }// end function

        private function showMenu() : void
        {
            Global.vSound.onSlide();
            this.showScreen(1);
            this.vScreen.txtName.htmlText = "<B>" + Global.vServer.vDisplayName + "</B>";
            if (Global.vServer.isFacebookLinked())
            {
                this.vScreen.txtFacebookStatus.htmlText = "<B>" + Global.getText("txtFacebookConnected") + "</B>";
                Global.vLang.checkSans(this.vScreen.txtFacebookStatus);
            }
            else
            {
                this.vScreen.txtFacebookStatus.htmlText = "<B>" + Global.getText("txtFacebookNotConnected") + "</B>";
                Global.vLang.checkSans(this.vScreen.txtFacebookStatus);
                addButton(this.vScreen, new FacebookButton(), new Point(this.vScreen.mcButton.x, this.vScreen.mcButton.y), this.doConnectFacebook);
            }
            var _loc_1:* = new LangChoice();
            _loc_1.x = this.vScreen.mcLang.x;
            _loc_1.y = this.vScreen.mcLang.y;
            this.vScreen.addChild(_loc_1);
            var _loc_2:* = "v";
            if (!Global.vServerPreviewFlag)
            {
                _loc_2 = "p";
            }
            this.vScreen.txtVersion.htmlText = _loc_2 + Global.vVersion;
            this.vScreen.btSFX.visible = false;
            if (Capabilities.isDebugger)
            {
                this.vScreen.btMusic.addEventListener(MouseEvent.MOUSE_DOWN, this.toggleMusic);
                this.vScreen.btSound.addEventListener(MouseEvent.MOUSE_DOWN, this.toggleSounds);
                this.vScreen.btMail.addEventListener(MouseEvent.MOUSE_DOWN, this.SendMail);
                this.vScreen.btFacebook.addEventListener(MouseEvent.MOUSE_DOWN, this.goFacebook);
                this.vScreen.btTwitter.addEventListener(MouseEvent.MOUSE_DOWN, this.goTwitter);
            }
            else
            {
                this.vScreen.btMusic.addEventListener(TouchEvent.TOUCH_BEGIN, this.toggleMusic);
                this.vScreen.btSound.addEventListener(TouchEvent.TOUCH_BEGIN, this.toggleSounds);
                this.vScreen.btMail.addEventListener(TouchEvent.TOUCH_BEGIN, this.SendMail);
                this.vScreen.btFacebook.addEventListener(TouchEvent.TOUCH_BEGIN, this.goFacebook);
                this.vScreen.btTwitter.addEventListener(TouchEvent.TOUCH_BEGIN, this.goTwitter);
            }
            this.refreshSoundButton();
            if (Capabilities.isDebugger)
            {
                this.vScreen.btErgoNormal.addEventListener(MouseEvent.MOUSE_DOWN, this.toggleErgoNormal);
                this.vScreen.btErgoReverse.addEventListener(MouseEvent.MOUSE_DOWN, this.toggleErgoReverse);
            }
            else
            {
                this.vScreen.btErgoNormal.addEventListener(TouchEvent.TOUCH_BEGIN, this.toggleErgoNormal);
                this.vScreen.btErgoReverse.addEventListener(TouchEvent.TOUCH_BEGIN, this.toggleErgoReverse);
            }
            this.refreshErgo();
            return;
        }// end function

        private function toggleErgoReverse(event:Event) : void
        {
            this.toggleErgo();
            return;
        }// end function

        private function toggleErgoNormal(event:Event) : void
        {
            this.toggleErgo();
            return;
        }// end function

        private function toggleErgo() : void
        {
            var _loc_1:* = SharedObject.getLocal(Global.SO_ID);
            if (_loc_1.data.ergo == null)
            {
                _loc_1.data.ergo = -1;
            }
            else
            {
                _loc_1.data.ergo = -_loc_1.data.ergo;
            }
            _loc_1.flush();
            if (_loc_1.data.ergo < 0)
            {
                Global.vErgoReverse = true;
            }
            else
            {
                Global.vErgoReverse = false;
            }
            this.refreshErgo();
            if (Global.vDev)
            {
            }
            return;
        }// end function

        private function refreshErgo() : void
        {
            if (Global.vErgoReverse)
            {
                this.vScreen.btErgoNormal.gotoAndStop(2);
                this.vScreen.btErgoReverse.gotoAndStop(1);
            }
            else
            {
                this.vScreen.btErgoNormal.gotoAndStop(1);
                this.vScreen.btErgoReverse.gotoAndStop(2);
            }
            return;
        }// end function

        private function toggleMusic(event:Event) : void
        {
            var _loc_2:* = SharedObject.getLocal(Global.SO_ID);
            if (_loc_2.data.music == null)
            {
                _loc_2.data.music = 1;
            }
            _loc_2.data.music = 1 - _loc_2.data.music;
            _loc_2.flush();
            Global.vSound.refreshConfig();
            Global.vSound.onButton();
            this.refreshSoundButton();
            Global.vSound.afterToggleMusic();
            return;
        }// end function

        private function toggleSounds(event:Event) : void
        {
            var _loc_2:* = SharedObject.getLocal(Global.SO_ID);
            if (_loc_2.data.sound == null)
            {
                _loc_2.data.sound = 1;
            }
            _loc_2.data.sound = 1 - _loc_2.data.sound;
            _loc_2.flush();
            Global.vSound.refreshConfig();
            Global.vSound.onButton();
            this.refreshSoundButton();
            return;
        }// end function

        private function refreshSoundButton() : void
        {
            var _loc_1:* = SharedObject.getLocal(Global.SO_ID);
            if (_loc_1.data.music == 0)
            {
                this.vScreen.btMusic.gotoAndStop(2);
            }
            else
            {
                this.vScreen.btMusic.gotoAndStop(1);
            }
            if (_loc_1.data.sound == 0)
            {
                this.vScreen.btSound.gotoAndStop(2);
            }
            else
            {
                this.vScreen.btSound.gotoAndStop(1);
            }
            return;
        }// end function

        private function doConnectFacebook(event:Event = null) : void
        {
            Global.addLogTrace("doConnectFacebook");
            Global.vSound.onButton();
            this.cleanScreen();
            if (Global.vDev)
            {
            }
            if (Global.vMyFacebook == null)
            {
                Global.vMyFacebook = new MyFacebook();
            }
            Global.vMyFacebook.getLogin(this.onFacebookMsg);
            return;
        }// end function

        private function onFacebookMsg(param1:String) : void
        {
            var _loc_2:* = param1.split(":");
            if (_loc_2[0] == "token")
            {
                this.vFacebookToken = _loc_2[1];
                Global.addLogTrace("Facebook token:" + this.vFacebookToken);
                this.cleanScreen();
                Global.vServer.linkFacebook(this.onFacebookLink, this.vFacebookToken);
            }
            else
            {
                Global.addLogTrace("onFacebookMsg:" + param1);
                Settings.vFacebookDirect = false;
                Global.vRoot.launchMenu(Login);
            }
            return;
        }// end function

        private function goLogin() : void
        {
            Global.vRoot.launchMenu(Login);
            return;
        }// end function

        private function resetLogin() : void
        {
            Login.resetSO("tutorial");
            Global.vRoot.launchMenu(Login);
            return;
        }// end function

        private function onFacebookLink(param1:Boolean, param2:Boolean, param3:String, param4:String, param5:int) : void
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            if (!param1)
            {
                Global.vRoot.entryPoint();
                return;
            }
            if (param2)
            {
                Login.saveSOFacebook(this.vFacebookToken);
                Global.vServer.reloadUser(this.onFaceboookLogin, param3);
            }
            else if (param3 == Global.vServer.vUser.vUserId)
            {
                Login.saveSOFacebook(this.vFacebookToken);
                Global.vServer.reloadUser(this.onFaceboookLogin, param3);
            }
            else if (vFacebookDirect)
            {
                vFacebookDirect = false;
                Login.saveSOFacebook(this.vFacebookToken);
                this.chooseFacebook();
            }
            else
            {
                vNeedRelog = true;
                if (Login.vFacebookFirstChoice)
                {
                    Login.vFacebookFirstChoice = false;
                    Home.vAccountFirstTime = false;
                    this.chooseFacebook();
                }
                else
                {
                    this.showScreen(3);
                    this.vScreen.txtFacebookAlreadyLinked.htmlText = Global.getText("txtFacebookAlreadyLinked").replace(/#/, param4);
                    Global.vLang.checkSans(this.vScreen.txtFacebookAlreadyLinked);
                    _loc_7 = new ButtonTextBitmap(Menu_TextButtonMini, param4);
                    _loc_6 = param4 + "<br>(" + Global.getText("txtLevel") + " " + param5 + ")";
                    _loc_7 = new ButtonTextBitmap(Menu_TextButtonMiniDouble, _loc_6);
                    addButton(this.vScreen, _loc_7, new Point(this.vScreen.mcButtonFacebook.x, this.vScreen.mcButtonFacebook.y), this.chooseFacebook);
                    _loc_6 = Global.vServer.vDisplayName + "<br>(" + Global.getText("txtLevel") + " " + Global.vServer.vUser.vLevel.toString() + ")";
                    _loc_7 = new ButtonTextBitmap(Menu_TextButtonMiniDouble, _loc_6);
                    addButton(this.vScreen, _loc_7, new Point(this.vScreen.mcButtonGuest.x, this.vScreen.mcButtonGuest.y), this.chooseGuest);
                }
            }
            return;
        }// end function

        private function chooseFacebook(event:Event = null) : void
        {
            Login.saveSOFacebook(this.vFacebookToken);
            Global.vServer.reloadUser(this.goSplash, this.vFacebookToken);
            return;
        }// end function

        private function chooseGuest(event:Event) : void
        {
            this.cleanScreen();
            Global.vServer.logout();
            Global.vRoot.entryPoint();
            return;
        }// end function

        private function goSplash() : void
        {
            Global.vRoot.launchMenu(Home);
            return;
        }// end function

        private function onFaceboookLogin(param1:Boolean = true) : void
        {
            if (param1)
            {
                this.askPseudo();
            }
            return;
        }// end function

        private function askPseudo() : void
        {
            Global.vSound.onSlide();
            this.showScreen(2);
            this.vScreen.txtChoosePseudo.htmlText = "<B>" + Global.getText("txtChoosePseudo") + "</B>";
            Global.vLang.checkSans(this.vScreen.txtChoosePseudo);
            this.vScreen.txtPseudoLengthMin.htmlText = "<B>" + Global.getText("txtPseudoLengthMin") + "</B>";
            Global.vLang.checkSans(this.vScreen.txtPseudoLengthMin);
            this.vScreen.txtPseudo.needsSoftKeyboard = true;
            if (stage != null)
            {
                stage.focus = this.vScreen.txtPseudo;
            }
            addButton(this.vScreen, new MenuButton_Ok(), new Point(this.vScreen.mcButton.x, this.vScreen.mcButton.y), this.onPseudo, 0.6);
            return;
        }// end function

        private function onPseudo(event:Event) : void
        {
            Global.vSound.onButton();
            var _loc_2:* = this.vScreen.txtPseudo.text;
            _loc_2 = Toolz.trim(_loc_2);
            if (_loc_2.length < 5)
            {
                this.vScreen.txtPseudo.text = _loc_2;
                new MsgBox(this, Global.getText("txtPseudoLengthMin"));
                return;
            }
            this.cleanScreen();
            this.vNewPseudo = _loc_2;
            Global.vServer.setNewPseudo(this.onNewPseudo, this.vNewPseudo);
            return;
        }// end function

        private function onNewPseudo() : void
        {
            Global.vServer.vDisplayName = this.vNewPseudo;
            if (vFacebookDirect)
            {
                vFacebookDirect = false;
                Global.vRoot.launchMenu(Login);
                return;
            }
            Global.vSound.onSlide();
            Global.vRoot.launchMenu(Home);
            return;
        }// end function

        private function SendMail(event:Event = null) : void
        {
            var _loc_2:* = "mailto:goalfinger@globz.com";
            _loc_2 = _loc_2 + "?body=" + Global.getText("txtMailInviteId") + " [" + Global.vServer.vUser.vUserId + ":" + Global.vServer.vDisplayName + "] ";
            _loc_2 = _loc_2 + Global.getText("txtMailInviteMessage");
            var _loc_3:* = new URLRequest(_loc_2);
            navigateToURL(_loc_3, "_blank");
            return;
        }// end function

        private function goFacebook(event:Event = null) : void
        {
            var _loc_2:* = new URLRequest("https://www.facebook.com/goalfingergame/");
            navigateToURL(_loc_2, "_blank");
            return;
        }// end function

        private function goTwitter(event:Event = null) : void
        {
            var _loc_2:* = new URLRequest("https://twitter.com/goalfingergame");
            navigateToURL(_loc_2, "_blank");
            return;
        }// end function

    }
}
