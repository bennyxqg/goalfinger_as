package menu.popup
{
    import com.greensock.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import globz.*;
    import menu.*;
    import menu.game.*;
    import menu.tools.*;
    import tools.*;

    public class CreatePrivateGame extends MenuXXX
    {
        private var vScreen:PrivateGameScreen;

        public function CreatePrivateGame()
        {
            initMenu();
            return;
        }// end function

        override protected function init() : void
        {
            Global.vStats.Stats_PageView("CreatePrivateGame");
            this.showMenu();
            return;
        }// end function

        private function showMenu() : void
        {
            cleanMenu();
            this.vScreen = new PrivateGameScreen();
            layerMenu.addChild(this.vScreen);
            this.vScreen.txtTitle.htmlText = "<B>" + Global.getText("txtPrivateGameButton") + "</B>";
            Global.vLang.checkSans(this.vScreen.txtTitle);
            Toolz.textReduce(this.vScreen.txtTitle);
            this.vScreen.txtInvite.htmlText = "<B>" + Global.getText("txtPrivateGameHelp") + "&nbsp;:</B>";
            Global.vLang.checkSans(this.vScreen.txtInvite);
            Toolz.textReduce(this.vScreen.txtInvite);
            this.vScreen.bPlay.mcTXT.txtPlay.htmlText = "<B>" + Global.getText("txtMenuPlay") + "</B>";
            Global.vLang.checkSans(this.vScreen.bPlay.mcTXT.txtPlay);
            Toolz.textReduce(this.vScreen.bPlay.mcTXT.txtPlay);
            if (Capabilities.isDebugger)
            {
                this.vScreen.bPlay.addEventListener(MouseEvent.MOUSE_DOWN, this.createPrivateGame);
            }
            else
            {
                this.vScreen.bPlay.addEventListener(TouchEvent.TOUCH_BEGIN, this.createPrivateGame);
            }
            var _loc_1:* = new ButtonGrafBitmap(new MenuButton_Quit());
            addButton(this.vScreen, _loc_1, new Point(this.vScreen.mcQuit.x, this.vScreen.mcQuit.y), this.goQuit, 1);
            var _loc_2:* = SharedObject.getLocal(Global.SO_ID);
            if (_loc_2.data.private_pass != null)
            {
                this.vScreen.txtInput.text = _loc_2.data.private_pass;
            }
            TweenMax.delayedCall(1, this.setFocus);
            Global.vSound.onSlide();
            return;
        }// end function

        private function setFocus() : void
        {
            Global.addLogTrace("setFocus:" + stage);
            if (stage != null)
            {
                this.vScreen.txtInput.needsSoftKeyboard = true;
                stage.focus = this.vScreen.txtInput;
            }
            return;
        }// end function

        private function goQuit(event:Event) : void
        {
            Global.vSound.onButton();
            Global.vRoot.quitPopup(0.3, false);
            return;
        }// end function

        private function goHelp(event:Event) : void
        {
            Global.vSound.onButton();
            new MsgBox(this, Global.getText("txtPrivateGameHelp"));
            return;
        }// end function

        private function createPrivateGame(event:Event) : void
        {
            var _loc_2:* = this.vScreen.txtInput.text;
            Global.vSound.onButton();
            _loc_2 = Toolz.trim(_loc_2);
            if (_loc_2.length == 0)
            {
                return;
            }
            var _loc_3:* = SharedObject.getLocal(Global.SO_ID);
            _loc_3.data.private_pass = _loc_2;
            _loc_3.flush();
            Matchmaking.vPrivatePass = _loc_2.toLowerCase();
            Global.vTopBar.hide();
            Global.vRoot.launchMenu(Matchmaking);
            return;
        }// end function

    }
}
