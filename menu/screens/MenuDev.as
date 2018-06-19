package menu.screens
{
    import flash.net.*;
    import globz.*;
    import menu.*;
    import menu.game.*;
    import tools.*;

    public class MenuDev extends MenuXXX
    {
        private var vMode:int = 0;
        private var vInputReplay:SimpleText;

        public function MenuDev()
        {
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            return;
        }// end function

        override protected function init() : void
        {
            this.goWait();
            if (Global.vServer.isLogged())
            {
                this.showMenu();
            }
            else if (Global.vAutologName == "Homer")
            {
                Global.vAutolog = false;
                this.loginHomer();
            }
            else if (Global.vAutologName == "Marge")
            {
                Global.vAutolog = false;
                this.loginMarge();
            }
            else if (Global.vAutolog)
            {
                Global.vAutolog = false;
                this.loginHomer();
            }
            else
            {
                this.showMenu();
            }
            return;
        }// end function

        private function showMenu(param1:int = 0) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            while (numChildren > 0)
            {
                
                removeChildAt(0);
            }
            this.vMode = param1;
            if (this.vMode >= 0)
            {
                new SimpleText(this, "Goal Finger", Global.vSize.x * 0.5, 50);
                new SimpleText(this, Global.vVersion, Global.vSize.x * 0.5, 70);
            }
            if (this.vMode == -1)
            {
                return;
            }
            if (Global.vServer.isLogged())
            {
                new SimpleText(this, "Logged as : " + Global.vServer.getDisplayName(), Global.vSize.x / 2, 120);
                new SimpleText(this, "Level " + Global.vServer.vUser.vLevel + " (xp:" + Global.vServer.vUser.vXP + ")", Global.vSize.x / 2, 150);
                new SimpleButton(this, "Logout", Global.vSize.x / 2, 180, this.logout);
                if (Global.vServer.vLoginType == "Guest")
                {
                    new SimpleButton(this, "Delete Guest account", Global.vSize.x / 2, 250, this.logoutGuestDelete);
                }
                _loc_2 = "";
                _loc_2 = "<GameId>";
                this.vInputReplay = new SimpleText(this, _loc_2, Global.vSize.x / 2, 340, 3);
                new SimpleButton(this, "Load Replay (Live)", Global.vSize.x / 2, 380, this.loadReplay);
                new SimpleButton(this, "Temp2 (Debug History)", Global.vSize.x / 2, 450, this.goTemp2);
                new SimpleButton(this, "Temp3 (Reset MatchRunning)", Global.vSize.x / 2, 500, this.goTemp3);
                new SimpleButton(this, "Splash", Global.vSize.x / 2, 580, this.goSplash, null, false, 1.5);
                new SimpleButton(this, "Demo Solo", Global.vSize.x / 2, 800, this.goDemoSolo);
            }
            else
            {
                _loc_3 = ["fabien1", "fabien2", "fabien3", "alex1", "alex2", "eric1", "eric2", "jeremy1", "jeremy2", "laurent1", "laurent2"];
                _loc_4 = "Simpson";
                if (Global.vServer.vLoginType == "Guest")
                {
                    new SimpleButton(this, "Log as " + Global.vServer.vDisplayName, Global.vSize.x / 2, 180 - 1 * 50, this.loginGuest);
                }
                new SimpleButton(this, "Go Login", Global.vSize.x / 2, 180 + 3 * 50, this.loginGuest);
                new SimpleButton(this, "Demo Offline", Global.vSize.x / 2, 800, this.goDemoOffline);
            }
            new SimpleButton(this, "Options", Global.vSize.x / 2, 860, this.goOptions);
            return;
        }// end function

        private function loginPseudo(param1:String) : void
        {
            this.goWait();
            Global.vServer.login(this.onLogin, param1, "Simpson");
            return;
        }// end function

        private function loginGuest() : void
        {
            Global.vRoot.launchMenu(Login);
            return;
        }// end function

        private function goWait() : void
        {
            this.showMenu(-1);
            return;
        }// end function

        private function loginHomer() : void
        {
            this.goWait();
            Global.vServer.login(this.onLogin, "Homer", "Simpson");
            return;
        }// end function

        private function loginMarge() : void
        {
            this.goWait();
            Global.vServer.login(this.onLogin, "Marge", "Simpson");
            return;
        }// end function

        private function onLogin(param1:Boolean) : void
        {
            if (!param1)
            {
                new MsgBox(this, "Login Error", this.showMenu);
                return;
            }
            if (Global.vDev)
            {
            }
            Global.vRoot.launchMenu(Home);
            return;
        }// end function

        private function logout() : void
        {
            Login.resetSO();
            Global.vServer.logout();
            this.showMenu();
            return;
        }// end function

        private function logoutGuestDelete() : void
        {
            new MsgBox(this, "Le compte " + Global.vServer.vDisplayName + " ne sera plus accessible. Confirmer ?", this.logoutGuestDeleteConfirm, MsgBox.TYPE_YesNo);
            return;
        }// end function

        private function logoutGuestDeleteConfirm(param1:Boolean) : void
        {
            var _loc_2:* = null;
            if (param1)
            {
                _loc_2 = SharedObject.getLocal(Global.SO_ID);
                _loc_2.data.login_type = "";
                _loc_2.flush();
                Global.vServer.logout();
                this.showMenu();
            }
            return;
        }// end function

        private function goDemoSolo() : void
        {
            var _loc_1:* = Global.vServer.vUser.getTeamDesc();
            if (_loc_1 == "")
            {
                new MsgBox(this, "Votre équipe n\'est pas complète.");
                return;
            }
            Global.vRoot.launchMenu(DemoSolo);
            return;
        }// end function

        private function goDemoOffline() : void
        {
            Global.vRoot.launchMenu(DemoOffline);
            return;
        }// end function

        private function goOptions() : void
        {
            Global.vRoot.launchMenu(MenuOptions);
            return;
        }// end function

        private function goSplash() : void
        {
            Global.vRoot.launchMenu(Home);
            return;
        }// end function

        private function goTemp2() : void
        {
            Global.vServer.temp2();
            return;
        }// end function

        private function goTemp3() : void
        {
            Global.vServer.temp3();
            return;
        }// end function

        private function loadReplay() : void
        {
            var _loc_1:* = this.vInputReplay.getInput();
            Replay.vGameId = _loc_1;
            Replay.vAutoStart = true;
            Global.vServerPreview = false;
            Global.vServer = null;
            Global.vRoot.restartApp("Restart for replay : " + _loc_1);
            return;
        }// end function

    }
}
