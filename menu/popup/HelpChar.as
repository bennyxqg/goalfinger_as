package menu.popup
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import globz.*;
    import menu.tools.*;
    import sparks.*;
    import tools.*;

    public class HelpChar extends Sprite
    {

        public function HelpChar()
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_7:* = null;
            _loc_1 = new HelpCharGraf();
            _loc_1.txtTitle.htmlText = "<B>" + Global.getText("txtHelpCharTitle") + "</B>";
            Global.vLang.checkSans(_loc_1.txtTitle);
            this.addChild(_loc_1);
            _loc_4 = new HelpCharGrafContent();
            _loc_2 = _loc_4.mcLineEnergy;
            _loc_2.txtTitle.htmlText = "<b>" + Global.getText("txtEnergy") + "</b>";
            Global.vLang.checkSans(_loc_2.txtTitle);
            Toolz.textReduce(_loc_2.txtTitle);
            _loc_2.txtContent.htmlText = "<b>" + Global.getText("txtEnergyHelp").replace(/#/, Sparks_Char.vEnergyThreshold) + "</b>";
            Global.vLang.checkSans(_loc_2.txtContent);
            Toolz.textReduce(_loc_2.txtContent);
            _loc_2.txtContent.y = _loc_2.txtContent.y - _loc_2.txtContent.textHeight / 2;
            _loc_2 = _loc_4.mcLineEnergyCard;
            _loc_2.txtTitle.htmlText = "<b>" + Global.getText("txtCharRecuperation") + "</b>";
            Global.vLang.checkSans(_loc_2.txtTitle);
            Toolz.textReduce(_loc_2.txtTitle);
            _loc_2.txtContent.htmlText = "<b>" + Global.getText("txtRecuperationHelp") + "</b>";
            Global.vLang.checkSans(_loc_2.txtContent);
            Toolz.textReduce(_loc_2.txtContent);
            _loc_2.txtContent.y = _loc_2.txtContent.y - _loc_2.txtContent.textHeight / 2;
            var _loc_5:* = 1;
            while (_loc_5 <= 3)
            {
                
                _loc_2 = _loc_4["mcLine" + _loc_5];
                if (_loc_5 == 1)
                {
                    _loc_3 = "Force";
                }
                if (_loc_5 == 2)
                {
                    _loc_3 = "Speed";
                }
                if (_loc_5 == 3)
                {
                    _loc_3 = "Vitality";
                }
                _loc_2.txtTitle.htmlText = "<b>" + Global.getText("txtAttribute" + _loc_3) + "</b>";
                Global.vLang.checkSans(_loc_2.txtTitle);
                Toolz.textReduce(_loc_2.txtTitle);
                _loc_2.txtContent.htmlText = "<b>" + Global.getText("txtHelpChar" + _loc_3) + "</b>";
                Global.vLang.checkSans(_loc_2.txtContent);
                Toolz.textReduce(_loc_2.txtContent);
                _loc_2.txtContent.y = _loc_2.txtContent.y - _loc_2.txtContent.textHeight / 2;
                _loc_5++;
            }
            _loc_4.txtHitPoints.htmlText = "<b>" + Global.getText("txtHelpChatHitPoints") + "</b>";
            Global.vLang.checkSans(_loc_4.txtHitPoints);
            Toolz.textReduce(_loc_4.txtHitPoints);
            _loc_4.txtHitPoints.y = _loc_4.txtHitPoints.y - _loc_4.txtHitPoints.textHeight / 2;
            _loc_4.txtTraining.htmlText = "<b>" + Global.getText("txtHelpCharTraining") + "</b>";
            Global.vLang.checkSans(_loc_4.txtTraining);
            Toolz.textReduce(_loc_4.txtTraining);
            _loc_4.txtTraining.y = _loc_4.txtTraining.y - _loc_4.txtTraining.textHeight / 2;
            var _loc_6:* = new SlidePanel(_loc_4, new Point(Global.vSize.x, Global.vSize.y * 0.82));
            _loc_6.y = 40;
            this.addChild(_loc_6);
            _loc_5 = 1;
            while (_loc_5 <= 3)
            {
                
                if (_loc_5 == 1)
                {
                    _loc_7 = new Card("Card", "AS");
                }
                if (_loc_5 == 2)
                {
                    _loc_7 = new Card("Card", "AF");
                }
                if (_loc_5 == 3)
                {
                    _loc_7 = new Card("Card", "AV");
                }
                var _loc_10:* = 0.7;
                _loc_7.scaleY = 0.7;
                _loc_7.scaleX = _loc_10;
                _loc_7.x = _loc_4.mcCardTraining.x + (_loc_5 - 2) * 30;
                _loc_7.y = _loc_4.mcCardTraining.y;
                _loc_7.rotation = (_loc_5 - 2) * 10;
                _loc_4.addChild(_loc_7);
                _loc_5++;
            }
            var _loc_8:* = new ButtonGrafBitmap(new MenuButton_Quit());
            _loc_8.x = _loc_1.mcQuit.x;
            _loc_8.y = _loc_1.mcQuit.y;
            _loc_1.addChild(_loc_8);
            if (Capabilities.isDebugger)
            {
                _loc_8.addEventListener(MouseEvent.MOUSE_DOWN, this.onQuit);
            }
            else
            {
                _loc_8.addEventListener(TouchEvent.TOUCH_BEGIN, this.onQuit);
            }
            this.x = Global.vSize.x / 2;
            this.y = Global.vSize.y / 2;
            Global.vSound.onSlide();
            var _loc_9:* = SharedObject.getLocal(Global.SO_ID);
            _loc_9.data.HelpCharDone = 1;
            _loc_9.flush();
            return;
        }// end function

        private function onQuit(event:Event) : void
        {
            Global.vSound.onButton();
            Global.vRoot.quitPopup();
            return;
        }// end function

    }
}
