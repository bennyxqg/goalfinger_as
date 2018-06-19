package menu.popup
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import globz.*;
    import menu.*;
    import menu.game.*;
    import menu.tools.*;
    import tools.*;

    public class HistoryGames extends MenuXXX
    {
        private var vScreen:HistoryGamesScreen;
        private var vTab:Array;
        private var vPanel:SlidePanel;
        private var vLoading:Boolean = false;
        private var vOngletActive:int = 1;
        public static var vContentData:Object;
        public static var vContentPos:int = 0;
        public static var vOngletSave:int = 0;

        public function HistoryGames()
        {
            vTag = "HistoryGames";
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            vImages["button_play"] = new mcToBitmapAS3(new MenuButton_Speed_Play(), 0, Global.vResolution * 1, true, null, 0, param1);
            vImages["button_photo"] = new mcToBitmapAS3(new MenuButton_Photo(), 0, Global.vResolution * 1, true, null, 0, param1);
            return;
        }// end function

        override protected function init() : void
        {
            var _loc_1:* = 0;
            Global.vStats.Stats_PageView("HistoryGames");
            if (vOngletSave != 0)
            {
                _loc_1 = vOngletSave;
                vOngletSave = 0;
                this.showOnglet(_loc_1);
            }
            else
            {
                this.showOnglet(1);
            }
            return;
        }// end function

        private function showOnglet(param1:int) : void
        {
            this.vOngletActive = param1;
            this.vTab = new Array();
            this.showMenu();
            var _loc_2:* = "last";
            if (Global.vDev)
            {
            }
            if (this.vOngletActive == 2)
            {
                _loc_2 = "saved";
            }
            if (vContentData != null)
            {
                this.parseData();
            }
            else
            {
                this.vLoading = true;
                Global.vServer.getHistoryGames(this.onHistoryGames, _loc_2);
            }
            return;
        }// end function

        private function toggleOnglet(event:Event) : void
        {
            vContentData = null;
            if (this.vLoading)
            {
                return;
            }
            Global.vSound.onButton();
            this.showOnglet(3 - this.vOngletActive);
            return;
        }// end function

        private function onHistoryGames(param1:Object) : void
        {
            this.vLoading = false;
            if (param1 == null)
            {
                this.goQuit();
            }
            if (param1.gamesHistory == null)
            {
                this.goQuit();
            }
            vContentData = param1;
            this.parseData();
            return;
        }// end function

        private function parseData() : void
        {
            var _loc_1:* = vContentData.gamesHistory;
            this.vTab = _loc_1;
            this.showList();
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
            vContentData = null;
            vContentPos = 0;
            vOngletSave = 0;
            Global.vSound.onButton();
            Global.vRoot.quitPopup();
            return;
        }// end function

        private function showMenu() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            var _loc_4:* = null;
            Global.vSound.onSlide();
            this.cleanScreen();
            this.vScreen = new HistoryGamesScreen();
            this.vScreen.x = Global.vSize.x / 2;
            this.vScreen.y = Global.vSize.y / 2;
            this.vScreen.txtInfo.visible = false;
            addChild(this.vScreen);
            var _loc_3:* = new ButtonGrafBitmap(new MenuButton_Quit());
            addButton(this.vScreen, _loc_3, new Point(this.vScreen.mcQuit.x, this.vScreen.mcQuit.y), this.goQuit, 1);
            if (this.vOngletActive == 1)
            {
                _loc_2 = Global.getText("txtHistoryGamesTitle").replace(/#/, "10");
            }
            else if (this.vOngletActive == 2)
            {
                _loc_2 = Global.getText("txtHistoryGamesSaved");
            }
            this.vScreen.txtTitle.htmlText = "<B>" + _loc_2 + "</B>";
            Global.vLang.checkSans(this.vScreen.txtTitle);
            Toolz.textReduce(this.vScreen.txtTitle);
            _loc_1 = 1;
            while (_loc_1 <= 2)
            {
                
                if (_loc_1 == 1)
                {
                    _loc_2 = Global.getText("txtHistoryGameMenuHistory");
                }
                else if (_loc_1 == 2)
                {
                    _loc_2 = Global.getText("txtHistoryGameMenuSaved");
                }
                _loc_4 = this.vScreen["mcBehind" + _loc_1];
                _loc_4.gotoAndStop(2);
                _loc_4.txtTitle.htmlText = "<B>" + _loc_2 + "</B>";
                Global.vLang.checkSans(_loc_4.txtTitle);
                Toolz.textReduce(_loc_4.txtTitle);
                _loc_4 = this.vScreen["mcFront" + _loc_1];
                _loc_4.txtTitle.htmlText = "<B>" + _loc_2 + "</B>";
                Global.vLang.checkSans(_loc_4.txtTitle);
                Toolz.textReduce(_loc_4.txtTitle);
                _loc_1++;
            }
            _loc_1 = 1;
            while (_loc_1 <= 2)
            {
                
                if (_loc_1 == this.vOngletActive)
                {
                    _loc_4.visible = true;
                    this.vScreen["mcBehind" + _loc_1].visible = false;
                }
                else
                {
                    _loc_4.visible = false;
                    this.vScreen["mcBehind" + _loc_1].visible = true;
                }
                _loc_1++;
            }
            _loc_4 = this.vScreen["mcBehind" + (3 - this.vOngletActive)];
            if (Capabilities.isDebugger)
            {
                _loc_4.addEventListener(MouseEvent.MOUSE_DOWN, this.toggleOnglet);
            }
            else
            {
                _loc_4.addEventListener(TouchEvent.TOUCH_BEGIN, this.toggleOnglet);
            }
            return;
        }// end function

        private function showList() : void
        {
            var _loc_1:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_8:* = 0;
            var _loc_9:* = null;
            var _loc_10:* = 0;
            var _loc_2:* = new Sprite();
            var _loc_6:* = 0;
            _loc_1 = 0;
            while (_loc_1 < this.vTab.length)
            {
                
                _loc_5 = this.vTab[_loc_1];
                _loc_3 = new HistoryGamesLine();
                _loc_4 = "";
                if (_loc_5.result == "victory")
                {
                    _loc_4 = Global.getText("txtEndGameVictory");
                    _loc_3.gotoAndStop(1);
                }
                else if (_loc_5.result == "defeat")
                {
                    _loc_4 = Global.getText("txtEndGameDefeat");
                    _loc_3.gotoAndStop(2);
                }
                else if (_loc_5.result == "cancelled")
                {
                    _loc_4 = Global.getText("txtEndGameCancel");
                    _loc_3.gotoAndStop(3);
                }
                if (_loc_5.friendly == 1)
                {
                    _loc_3.gotoAndStop(3);
                    if (_loc_5.result == null)
                    {
                        _loc_4 = Global.getText("txtPrivateGameTitle");
                    }
                    else
                    {
                        _loc_4 = Global.getText("txtPrivateGameTitle") + " : " + _loc_4;
                    }
                }
                _loc_3.txtTitle.htmlText = "<B>" + _loc_4 + "</B>";
                Global.vLang.checkSans(_loc_3.txtTitle);
                Toolz.textReduce(_loc_3.txtTitle);
                _loc_3.txtPlayer1.htmlText = "<B>" + _loc_5.player1 + "</B>";
                Global.vLang.checkSans(_loc_3.txtPlayer1);
                Toolz.textReduce(_loc_3.txtPlayer1);
                _loc_3.txtPlayer2.htmlText = "<B>" + _loc_5.player2 + "</B>";
                Global.vLang.checkSans(_loc_3.txtPlayer2);
                Toolz.textReduce(_loc_3.txtPlayer2);
                if (_loc_5.startTrophies1 == null)
                {
                    _loc_5.startTrophies1 = 0;
                }
                _loc_3.txtTrophy1.htmlText = "<B>" + _loc_5.startTrophies1.toString() + "</B>";
                Global.vLang.checkSans(_loc_3.txtTrophy1);
                Toolz.textReduce(_loc_3.txtTrophy1);
                if (_loc_5.startTrophies2 == null)
                {
                    _loc_5.startTrophies2 = 0;
                }
                _loc_3.txtTrophy2.htmlText = "<B>" + _loc_5.startTrophies2.toString() + "</B>";
                Global.vLang.checkSans(_loc_3.txtTrophy2);
                Toolz.textReduce(_loc_3.txtTrophy2);
                if (_loc_5.score1 > 2)
                {
                    _loc_5.score1 = 2;
                }
                if (_loc_5.score2 > 2)
                {
                    _loc_5.score2 = 2;
                }
                _loc_3.txtScore.htmlText = "<B>" + _loc_5.score1 + " - " + _loc_5.score2 + "</B>";
                if (_loc_5.trophies1 == null)
                {
                    _loc_5.trophies1 = "0";
                }
                _loc_4 = _loc_5.trophies1.toString();
                if (_loc_5.trophies1 > 0)
                {
                    _loc_4 = "+" + _loc_4;
                }
                _loc_3.txtTrophy.htmlText = "<B>" + _loc_4 + "</B>";
                if (_loc_5.friendly == 1)
                {
                    _loc_3.mcTrophyIcon.visible = false;
                    _loc_3.txtTrophy.visible = false;
                }
                _loc_4 = "";
                if (_loc_5.status1 == "leaver")
                {
                    _loc_4 = Global.getText("txtEndGameConnectionIssueShort");
                    _loc_3.mcStatus.gotoAndStop(1);
                }
                else if (_loc_5.status1 == "forfeit")
                {
                    _loc_4 = Global.getText("txtEndGameForfeit");
                    _loc_3.mcStatus.gotoAndStop(1);
                }
                else if (_loc_5.status2 == "leaver")
                {
                    _loc_4 = Global.getText("txtEndGameConnectionIssueShort");
                    _loc_3.mcStatus.gotoAndStop(2);
                }
                else if (_loc_5.status2 == "forfeit")
                {
                    _loc_4 = Global.getText("txtEndGameForfeit");
                    _loc_3.mcStatus.gotoAndStop(2);
                }
                else
                {
                    _loc_3.mcStatus.visible = false;
                }
                _loc_3.txtStatus.htmlText = "<B>" + _loc_4 + "</B>";
                Global.vLang.checkSans(_loc_3.txtStatus);
                Toolz.textReduce(_loc_3.txtStatus);
                _loc_8 = Global.vServer.getTimeFrom(_loc_5.time_start / 1000);
                _loc_9 = Global.formatDuration(_loc_8);
                _loc_3.txtTimeStart.htmlText = Global.getText("txtDurationFrom").replace(/#/, _loc_9);
                Global.vLang.checkSans(_loc_3.txtTimeStart);
                Toolz.textReduce(_loc_3.txtTimeStart);
                _loc_3.mcButton1.vId = _loc_5.id1;
                _loc_3.mcButton2.vId = _loc_5.id2;
                if (Capabilities.isDebugger)
                {
                    _loc_3.mcButton1.addEventListener(MouseEvent.CLICK, this.onUserDetails);
                    _loc_3.mcButton2.addEventListener(MouseEvent.CLICK, this.onUserDetails);
                }
                else
                {
                    _loc_3.mcButton1.addEventListener(TouchEvent.TOUCH_TAP, this.onUserDetails);
                    _loc_3.mcButton2.addEventListener(TouchEvent.TOUCH_TAP, this.onUserDetails);
                }
                _loc_10 = 45;
                addButton(_loc_3, new bitmapClip(vImages["button_play"]), new Point(_loc_3.mcPlay.x + _loc_10, _loc_3.mcPlay.y), this.goReplay, 1, {gameId:_loc_5.gameId}, false);
                addButton(_loc_3, new bitmapClip(vImages["button_photo"]), new Point(_loc_3.mcPlay.x - _loc_10, _loc_3.mcPlay.y), this.goReplayDrawing, 1, {gameId:_loc_5.gameId, photo:1}, false);
                _loc_6 = _loc_6 + addMarge(_loc_2, 0, _loc_6);
                _loc_3.y = _loc_6 + 60;
                _loc_6 = _loc_6 + (_loc_3.height - 40);
                _loc_2.addChild(_loc_3);
                _loc_1++;
            }
            _loc_6 = _loc_6 + 0;
            _loc_6 = _loc_6 + addMarge(_loc_2, 0, _loc_6);
            if (this.vTab.length == 0)
            {
                _loc_4 = "";
                if (this.vOngletActive == 1)
                {
                    _loc_4 = Global.getText("txtHistoryGamesNoGameYet");
                }
                else if (this.vOngletActive == 2)
                {
                    _loc_4 = Global.getText("txtHistoryGamesNoSavedYet");
                }
                this.vScreen.txtInfo.htmlText = "<B>" + _loc_4 + "</B>";
                Global.vLang.checkSans(this.vScreen.txtInfo);
                Toolz.textReduce(this.vScreen.txtInfo);
                this.vScreen.txtInfo.visible = true;
            }
            var _loc_7:* = new Point(640, 700);
            this.vPanel = new SlidePanel(_loc_2, _loc_7);
            this.vPanel.x = 0;
            this.vPanel.y = 40;
            this.vScreen.addChild(this.vPanel);
            if (vContentPos != 0)
            {
                this.vPanel.vContent.y = vContentPos;
                vContentPos = 0;
            }
            return;
        }// end function

        private function goReplay(event:Event) : void
        {
            vContentPos = this.vPanel.vContent.y;
            vOngletSave = this.vOngletActive;
            if (this.vPanel.isSlideDone)
            {
                return;
            }
            Replay.vGameId = event.currentTarget.vArgs.gameId;
            Global.vSound.onButton();
            Global.vTopBar.hide();
            Global.vRoot.launchMenu(Replay);
            return;
        }// end function

        private function goReplayDrawing(event:Event) : void
        {
            if (this.vPanel.isSlideDone)
            {
                return;
            }
            vOngletSave = this.vOngletActive;
            ReplayDrawing.vGameId = event.currentTarget.vArgs.gameId;
            ReplayDrawing.vPhotoNum = event.currentTarget.vArgs.photo;
            Global.vSound.onButton();
            Global.vTopBar.hide();
            Global.vRoot.launchMenu(ReplayDrawing);
            return;
        }// end function

        private function onUserDetails(event:Event) : void
        {
            return;
        }// end function

        private function onPopupClosed() : void
        {
            this.vPanel.vPause = false;
            return;
        }// end function

    }
}
