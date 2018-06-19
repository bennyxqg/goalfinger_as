package menu.screens
{
    import flash.desktop.*;
    import flash.net.*;
    import flash.system.*;
    import globz.*;
    import menu.*;
    import menu.game.*;
    import tools.*;

    public class MenuOptions extends MenuXXX
    {
        private var vShare:MyShare;

        public function MenuOptions()
        {
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            return;
        }// end function

        override protected function init() : void
        {
            this.showMenu();
            return;
        }// end function

        private function showMenu(param1:int = 0) : void
        {
            while (numChildren > 0)
            {
                
                removeChildAt(0);
            }
            new SimpleText(this, "Options", Global.vSize.x * 0.5, 50);
            new SimpleText(this, "Air : " + Capabilities.version, Global.vSize.x * 0.5, 90);
            new SimpleText(this, "Runtime : " + NativeApplication.nativeApplication.runtimeVersion, Global.vSize.x * 0.5, 130);
            var _loc_2:* = "AutoLaunch : " + Global.vAutoLaunch;
            new SimpleText(this, _loc_2, Global.vSize.x * 0.5, 230);
            new SimpleButton(this, "Changer", Global.vSize.x / 2, 260, this.changeAutolaunch);
            if (Global.vServer.vUser != null)
            {
                new SimpleButton(this, "Ajouter 20 XP", Global.vSize.x / 2, 350, this.tempAddXP20);
                new SimpleButton(this, "Ajouter 200 XP", Global.vSize.x / 2, 400, this.tempAddXP200);
                new SimpleButton(this, "Ajouter 1 level", Global.vSize.x / 2, 450, this.tempAddLevel1);
                new SimpleButton(this, "Ajouter 5 level", Global.vSize.x / 2, 500, this.tempAddLevel5);
                new SimpleButton(this, "Ajouter 1000 HC", Global.vSize.x / 2, 550, this.tempGiveMoney);
                new SimpleButton(this, "Tonnes de cartes", Global.vSize.x / 2, 600, this.tempGiveFullCards);
            }
            var _loc_3:* = "Fake Level : ";
            if (Global.vFakeLevel == 0)
            {
                _loc_3 = _loc_3 + "Random";
            }
            else
            {
                _loc_3 = _loc_3 + Global.vFakeLevel.toString();
            }
            new SimpleText(this, _loc_3, Global.vSize.x * 0.5, 700);
            new SimpleButton(this, "Changer", Global.vSize.x / 2, 730, this.changeFakeLevel);
            new SimpleButton(this, "Retour", Global.vSize.x / 2, 860, this.goBack);
            return;
        }// end function

        private function goBack() : void
        {
            Global.vRoot.goMainMenu();
            return;
        }// end function

        private function goWait() : void
        {
            while (numChildren > 0)
            {
                
                removeChildAt(0);
            }
            new SimpleText(this, "Loading", Global.vSize.x * 0.5, Global.vSize.y / 2);
            return;
        }// end function

        private function goOptions() : void
        {
            Global.vRoot.launchMenu(DemoSolo);
            return;
        }// end function

        private function changePerso() : void
        {
            var _loc_2:* = Global;
            var _loc_3:* = _loc_2.vPersoType + 1;
            _loc_2.vPersoType = _loc_3;
            if (_loc_2.vPersoType >= _loc_2.vPersoTab.length)
            {
                _loc_2.vPersoType = 0;
            }
            var _loc_1:* = SharedObject.getLocal(_loc_2.SO_ID);
            _loc_1.data.persotype = _loc_2.vPersoType;
            _loc_1.flush();
            this.showMenu();
            return;
        }// end function

        private function changeAiming() : void
        {
            Global.vAiming = !Global.vAiming;
            var _loc_1:* = SharedObject.getLocal(Global.SO_ID);
            _loc_1.data.aiming = Global.vAiming;
            _loc_1.flush();
            this.showMenu();
            return;
        }// end function

        private function changeAutolaunch() : void
        {
            Global.vAutoLaunch = !Global.vAutoLaunch;
            this.showMenu();
            return;
        }// end function

        private function changeFakeLevel() : void
        {
            if (Global.vFakeLevel == 5)
            {
                Global.vFakeLevel = 0;
            }
            else
            {
                var _loc_2:* = Global;
                var _loc_3:* = _loc_2.vFakeLevel + 1;
                _loc_2.vFakeLevel = _loc_3;
            }
            var _loc_1:* = SharedObject.getLocal(_loc_2.SO_ID);
            _loc_1.data.fake_level = _loc_2.vFakeLevel;
            _loc_1.flush();
            this.showMenu();
            return;
        }// end function

        private function tempAddXP20() : void
        {
            this.goWait();
            Global.vServer.tempUpdate(this.goBack, "addxp", 20);
            return;
        }// end function

        private function tempAddXP200() : void
        {
            this.goWait();
            Global.vServer.tempUpdate(this.goBack, "addxp", 200);
            return;
        }// end function

        private function tempAddLevel1() : void
        {
            this.goWait();
            Global.vServer.tempUpdate(this.goBack, "xp", (Global.vServer.vUser.vLevel + 1));
            return;
        }// end function

        private function tempAddLevel5() : void
        {
            this.goWait();
            Global.vServer.tempUpdate(this.goBack, "xp", Global.vServer.vUser.vLevel + 5);
            return;
        }// end function

        private function tempGiveMoney() : void
        {
            this.goWait();
            Global.vServer.tempUpdate(this.goBack, "money", 1000);
            return;
        }// end function

        private function tempGiveFullCards() : void
        {
            this.goWait();
            Global.vServer.tempUpdate(this.goBack, "fullcards");
            return;
        }// end function

        private function testShare() : void
        {
            this.vShare = new MyShare(1, "");
            addChild(this.vShare);
            return;
        }// end function

        private function testFacebook() : void
        {
            if (Global.vMyFacebook == null)
            {
                Global.vMyFacebook = new MyFacebook();
            }
            Global.vMyFacebook.getLogin(this.onFacebookMsg);
            return;
        }// end function

        private function onFacebookMsg(param1:String) : void
        {
            var _loc_2:* = "mailto:fabien@globz.com";
            _loc_2 = _loc_2 + "?subject=[Goal Finger - Facebook token]";
            _loc_2 = _loc_2 + ("&body=" + param1);
            var _loc_3:* = new URLRequest(_loc_2);
            navigateToURL(_loc_3);
            new MsgBox(this, param1);
            return;
        }// end function

    }
}
