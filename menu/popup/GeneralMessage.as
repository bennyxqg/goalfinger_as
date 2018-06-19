package menu.popup
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import globz.*;
    import menu.*;
    import menu.screens.*;
    import menu.tools.*;
    import tools.*;

    public class GeneralMessage extends MenuXXX
    {
        private var vScreen:GeneralMessageScreen;
        private var vTab:Array;
        private var vPanel:SlidePanel;
        public static var vHome:Home;

        public function GeneralMessage()
        {
            vTag = "GeneralMessage";
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            return;
        }// end function

        override protected function init() : void
        {
            Global.vStats.Stats_PageView("GeneralMessage");
            this.showMenu();
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

        private function goQuit(event:Event = null) : void
        {
            Global.vSound.onButton();
            Global.vRoot.quitPopup();
            return;
        }// end function

        private function showMenu() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            Global.vSound.onSlide();
            this.cleanScreen();
            this.vScreen = new GeneralMessageScreen();
            this.vScreen.x = Global.vSize.x / 2;
            this.vScreen.y = Global.vSize.y / 2;
            addChild(this.vScreen);
            var _loc_1:* = new ButtonGrafBitmap(new MenuButton_Quit());
            addButton(this.vScreen, _loc_1, new Point(this.vScreen.mcQuit.x, this.vScreen.mcQuit.y), this.goQuit, 1);
            this.vScreen.txtTitle.htmlText = "<B>" + Global.getText("txtGeneralMessageTitle");
            Global.vLang.checkSans(this.vScreen.txtTitle);
            Toolz.textReduce(this.vScreen.txtTitle);
            _loc_2 = new Sprite();
            var _loc_6:* = 0;
            var _loc_7:* = 10;
            var _loc_8:* = 20;
            if (Global.vGeneralMessagePerso != null)
            {
                _loc_4 = Global.getText("txtMsgPerso_" + Global.vGeneralMessagePerso);
                if (_loc_4 != null && _loc_4 != "")
                {
                    _loc_3 = new GeneralMessageLine();
                    _loc_3.mcBG.gotoAndStop(2);
                    _loc_3.txtMsg.htmlText = "<B>" + _loc_4 + "</B>";
                    Global.vLang.checkSans(_loc_3.txtMsg);
                    Toolz.textReduce(_loc_3.txtMsg);
                    _loc_3.mcBG.height = 2 * _loc_7 + _loc_3.txtMsg.textHeight;
                    _loc_3.y = _loc_6;
                    _loc_6 = _loc_6 + (_loc_3.mcBG.height + _loc_8);
                    _loc_2.addChild(_loc_3);
                }
            }
            var _loc_9:* = 0;
            while (_loc_9 < Global.vGeneralMessageTab.length)
            {
                
                _loc_5 = Global.vGeneralMessageTab[_loc_9];
                _loc_3 = new GeneralMessageLine();
                _loc_4 = _loc_5.msg;
                _loc_3.txtMsg.htmlText = "<B>" + _loc_4 + "</B>";
                Global.vLang.checkSans(_loc_3.txtMsg);
                Toolz.textReduce(_loc_3.txtMsg);
                _loc_3.mcBG.height = 2 * _loc_7 + _loc_3.txtMsg.textHeight;
                _loc_3.y = _loc_6;
                _loc_6 = _loc_6 + (_loc_3.mcBG.height + _loc_8);
                _loc_2.addChild(_loc_3);
                _loc_9++;
            }
            var _loc_10:* = new Point(640, 700);
            this.vPanel = new SlidePanel(_loc_2, _loc_10);
            this.vPanel.x = 0;
            this.vPanel.y = 40;
            this.vScreen.addChild(this.vPanel);
            return;
        }// end function

    }
}
