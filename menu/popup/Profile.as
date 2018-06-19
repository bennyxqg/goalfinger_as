package menu.popup
{
    import flash.events.*;
    import flash.geom.*;
    import menu.*;
    import menu.tools.*;
    import sparks.*;

    public class Profile extends MenuXXX
    {
        private var vScreen:ProfilScreen;
        public static var vId:String = "";

        public function Profile()
        {
            initMenu();
            return;
        }// end function

        override protected function init() : void
        {
            if (vId == "")
            {
                return;
            }
            showLoading();
            Global.vServer.loadProfile(this.onProfile, vId);
            Global.vStats.Stats_PageView("Profile");
            return;
        }// end function

        private function onProfile(param1:Object) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            cleanMenu();
            this.vScreen = new ProfilScreen();
            this.vScreen.txtName.htmlText = "<B>" + param1.displayName + "</B>";
            new MyFont(this.vScreen.mcLevel, "fontxptitle", param1.levelXP.toString(), this.vScreen.mcLevel.mcText.x, this.vScreen.mcLevel.mcText.y, true);
            _loc_2 = param1.trophies + " " + Global.getText("txtTrophyMax");
            _loc_2 = _loc_2.replace(/#/, param1.stats.maxTrophies);
            this.vScreen.txtTrophy.htmlText = "<B>" + _loc_2 + "</B>";
            Global.vLang.checkSans(this.vScreen.txtTrophy);
            _loc_2 = Global.getText("txtVictories");
            _loc_2 = _loc_2.replace(/#/, param1.stats.victories);
            this.vScreen.txtVictory.htmlText = "<B>" + _loc_2 + "</B>";
            Global.vLang.checkSans(this.vScreen.txtVictory);
            var _loc_6:* = 1;
            while (_loc_6 <= 3)
            {
                
                _loc_3 = this.getCharAtPos(param1, _loc_6);
                if (_loc_3 != null)
                {
                    _loc_5 = new Sparks_Char(Global.vServer.vUser, "X", _loc_3.Name);
                    _loc_5.vCharId = _loc_3.vCharId;
                    _loc_5.vCategory = _loc_3.Categ;
                    _loc_5.setForce(_loc_3.Attributes.Force);
                    _loc_5.setSpeed(_loc_3.Attributes.Speed);
                    _loc_5.setVitality(_loc_3.Attributes.Vitality);
                    _loc_4 = new PersoForm(_loc_5, null, false, 0, false, param1.ActiveShirt, true);
                    _loc_4.x = this.vScreen["mcT" + _loc_6].x;
                    _loc_4.y = this.vScreen["mcT" + _loc_6].y;
                    this.vScreen.addChild(_loc_4);
                }
                _loc_6++;
            }
            layerMenu.addChild(new ButtonGrafBitmap(this.vScreen));
            var _loc_7:* = new ButtonGrafBitmap(new MenuButton_Quit());
            addButton(layerMenu, _loc_7, new Point(this.vScreen.mcQuit.x, this.vScreen.mcQuit.y), this.goQuit, 1);
            Global.vSound.onSlide();
            return;
        }// end function

        private function getCharAtPos(param1:Object, param2:int) : Object
        {
            var _loc_4:* = undefined;
            var _loc_3:* = 0;
            while (_loc_3 < param1.team.length)
            {
                
                for (_loc_4 in param1.team[_loc_3])
                {
                    
                    if (_loc_6[_loc_4].Position == param2)
                    {
                        _loc_6[_loc_4].vCharId = _loc_4;
                        return _loc_6[_loc_4];
                    }
                }
                _loc_3++;
            }
            return null;
        }// end function

        private function goQuit(event:Event) : void
        {
            Global.vSound.onButton();
            Global.vRoot.quitPopup(0.3, false);
            return;
        }// end function

    }
}
