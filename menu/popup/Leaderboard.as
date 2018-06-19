package menu.popup
{
    import __AS3__.vec.*;
    import com.gamesparks.api.types.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import globz.*;
    import menu.*;
    import menu.screens.*;
    import menu.tools.*;
    import tools.*;

    public class Leaderboard extends MenuXXX
    {
        private var vCurCategory:int = 0;
        private var vPanel:SlidePanel;
        private var vBG:LeaderBoardBG;

        public function Leaderboard()
        {
            return;
        }// end function

        override protected function rasterizeImages(param1:mcToBitmapQueue) : void
        {
            return;
        }// end function

        override protected function init() : void
        {
            initMenu();
            Global.vSound.onSlide();
            this.loadLeaderboard(0);
            Global.vStats.Stats_PageView("Leaderboard");
            return;
        }// end function

        private function loadLeaderboard(param1:int = 0) : void
        {
            this.vCurCategory = param1;
            cleanMenu();
            this.initScreen();
            if (this.vCurCategory == 0)
            {
                Global.vServer.getLeaderBoardGeneral(this.onData);
            }
            if (this.vCurCategory == 1)
            {
                Global.vServer.getLeaderBoardLocal(this.onData);
            }
            if (this.vCurCategory == 2)
            {
                Global.vServer.getLeaderBoardFriends(this.onData);
            }
            return;
        }// end function

        private function initScreen() : void
        {
            var _loc_1:* = null;
            var _loc_3:* = null;
            this.vBG = new LeaderBoardBG();
            if (this.vCurCategory == 2)
            {
                this.vBG.gotoAndStop(2);
                this.vBG.txtInvite.htmlText = "";
                this.vBG.txtTitle.htmlText = "";
                this.vBG.txtContent.htmlText = "";
                this.vBG.txtComment.htmlText = "";
            }
            this.vBG.x = 0;
            this.vBG.y = -299;
            layerMenu.addChild(this.vBG);
            var _loc_2:* = new ButtonGrafBitmap(new MenuButton_Quit());
            addButton(this.vBG, _loc_2, new Point(this.vBG.mcQuit.x, this.vBG.mcQuit.y), this.goQuit, 1);
            var _loc_4:* = 0;
            while (_loc_4 < 3)
            {
                
                _loc_3 = new OngletTitle();
                _loc_3.vId = _loc_4;
                if (_loc_4 == this.vCurCategory)
                {
                    _loc_3.gotoAndStop(2);
                }
                else if (Capabilities.isDebugger)
                {
                    _loc_3.addEventListener(MouseEvent.MOUSE_DOWN, this.onClickOnglet);
                }
                else
                {
                    _loc_3.addEventListener(TouchEvent.TOUCH_BEGIN, this.onClickOnglet);
                }
                if (_loc_4 == 0)
                {
                    _loc_1 = Global.getText("txtLeaderboardGeneral");
                }
                if (_loc_4 == 1)
                {
                    _loc_1 = Global.getText("txtLeaderboardLocal");
                }
                if (_loc_4 == 2)
                {
                    _loc_1 = Global.getText("txtLeaderboardFriends");
                }
                _loc_3.txtTitle.htmlText = "<B>" + _loc_1 + "</B>";
                Global.vLang.checkSans(_loc_3.txtTitle);
                _loc_3.x = 168 * (_loc_4 - 1) - 44;
                _loc_3.y = this.vBG.y;
                layerMenu.addChild(_loc_3);
                _loc_4++;
            }
            return;
        }// end function

        private function onData(param1:String, param2:Vector.<LeaderboardData> = null, param3:Object = null) : void
        {
            var _loc_4:* = null;
            var _loc_6:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = 0;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_14:* = null;
            var _loc_5:* = new Sprite();
            var _loc_7:* = 0;
            var _loc_8:* = 50;
            if (param1 == "Data")
            {
                _loc_11 = 0;
                while (_loc_11 < param2.length)
                {
                    
                    _loc_4 = param2[_loc_11];
                    _loc_6 = new LeaderBoardLine();
                    if (_loc_4.getUserId() == Global.vServer.vUser.vUserId)
                    {
                        _loc_6.gotoAndStop(2);
                    }
                    _loc_6.txtRank.htmlText = "<B>" + _loc_4.getRank() + "</B>";
                    _loc_6.txtLevel.htmlText = "<B>" + _loc_4.getAttribute("XP") + "</B>";
                    _loc_6.txtTrophy.htmlText = "<B>" + _loc_4.getAttribute("trophies") + "</B>";
                    _loc_6.txtUsername.htmlText = "<B>" + _loc_4.getUserName() + "</B>";
                    if (_loc_11 % 2)
                    {
                        _loc_6.mcBG.visible = false;
                    }
                    _loc_10 = new ButtonGrafBitmap(_loc_6);
                    _loc_12 = new MovieClip();
                    _loc_12.addChild(_loc_10);
                    _loc_12.vId = _loc_4.getUserId();
                    if (Capabilities.isDebugger)
                    {
                        _loc_12.addEventListener(MouseEvent.CLICK, this.onUserDetails);
                    }
                    else
                    {
                        _loc_12.addEventListener(TouchEvent.TOUCH_TAP, this.onUserDetails);
                    }
                    _loc_12.y = _loc_7;
                    _loc_5.addChild(_loc_12);
                    addMarge(_loc_5, 0, _loc_7 - 25);
                    _loc_7 = _loc_7 + _loc_8;
                    _loc_11++;
                }
            }
            if (this.vCurCategory == 2)
            {
                if (param1 == "NoFacebook")
                {
                    this.vBG.txtInvite.htmlText = "<b>" + Global.getText("txtLeaderboardFacebookInvite") + "</b>";
                    Global.vLang.checkSans(this.vBG.txtInvite);
                    Toolz.textReduce(this.vBG.txtInvite);
                    addButton(this.vBG, new FacebookButton(), new Point(this.vBG.mcButtonFacebook.x, this.vBG.mcButtonFacebook.y), this.goConnectFacebook);
                    this.vBG.txtTitle.htmlText = "<b>" + Global.getText("txtIntroBenefits") + "</b>";
                    Global.vLang.checkSans(this.vBG.txtTitle);
                    Toolz.textReduce(this.vBG.txtTitle);
                    this.vBG.txtContent.htmlText = "<b>" + Global.getText("txtIntroBenefitsContents") + "</b>";
                    Global.vLang.checkSans(this.vBG.txtContent);
                    Toolz.textReduce(this.vBG.txtContent);
                    this.vBG.txtComment.htmlText = "<b>" + Global.getText("txtIntroNoPost") + "</b>";
                    Global.vLang.checkSans(this.vBG.txtComment);
                    Toolz.textReduce(this.vBG.txtComment);
                    _loc_13 = new ButtonTextBitmap(Menu_TextButtonDoubleLine, Global.getText("txtFacebookConnect"), 1, true);
                    addButton(this.vBG, _loc_13, new Point(this.vBG.mcButtonFacebookText.x, this.vBG.mcButtonFacebookText.y), this.goConnectFacebook);
                }
                else
                {
                    this.vBG.txtInvite.htmlText = "";
                    this.vBG.txtTitle.htmlText = "";
                    this.vBG.txtContent.htmlText = "";
                    this.vBG.txtComment.htmlText = "";
                }
            }
            this.vPanel = new SlidePanel(_loc_5, new Point(550, 550));
            this.vPanel.x = 0;
            this.vPanel.y = 0;
            layerMenu.addChild(this.vPanel);
            this.vPanel.forceX(275);
            if (param3 == null)
            {
            }
            else if (this.vCurCategory != 2)
            {
                _loc_6 = new LeaderBoardLine();
                _loc_6.gotoAndStop(2);
                _loc_6.txtRank.htmlText = "<B>" + param3.rank + "</B>";
                _loc_6.txtTrophy.htmlText = "<B>" + param3.trophies + "</B>";
                _loc_6.txtUsername.htmlText = "<B>" + param3.userName + "</B>";
                _loc_6.txtLevel.htmlText = "<B>" + Global.vServer.vUser.vLevel + "</B>";
                _loc_6.y = 300;
                _loc_6.vId = Global.vServer.vUser.vUserId;
                if (Capabilities.isDebugger)
                {
                    _loc_6.addEventListener(MouseEvent.CLICK, this.onUserDetails);
                }
                else
                {
                    _loc_6.addEventListener(TouchEvent.TOUCH_TAP, this.onUserDetails);
                }
                _loc_14 = new SlidePanel(_loc_6, new Point(550, 50));
                _loc_14.forceX(275);
                _loc_14.forceY(-272);
                _loc_14.y = 325;
                layerMenu.addChild(_loc_14);
                if (Home.vTrophyRank != null)
                {
                    Home.vTrophyRank.text = Global.vServer.vUser.vTrophy.toString();
                }
                if (Home.vTrophyMax != null)
                {
                    if (Global.vServer.vUser.vTrophyMax < Global.vServer.vUser.vTrophy)
                    {
                        Global.vServer.vUser.vTrophyMax = Global.vServer.vUser.vTrophy;
                    }
                    Home.vTrophyMax.htmlText = Global.getText("txtTrophyMax").replace(/#/, Global.vServer.vUser.vTrophyMax);
                    Global.vLang.checkSans(Home.vTrophyMax);
                }
            }
            return;
        }// end function

        private function onUserDetails(event:Event) : void
        {
            if (this.vPanel.isSlideDone)
            {
                return;
            }
            this.vPanel.vPause = true;
            Global.vSound.onButton();
            var _loc_2:* = event.currentTarget.vId;
            Profile.vId = _loc_2;
            Global.vRoot.launchPopup(Profile, null, this.onPopupClosed);
            return;
        }// end function

        private function onPopupClosed() : void
        {
            this.vPanel.vPause = false;
            return;
        }// end function

        private function goQuit(event:Event) : void
        {
            Global.vSound.onButton();
            Global.vRoot.quitPopup();
            return;
        }// end function

        private function onClickOnglet(event:Event) : void
        {
            Global.vSound.onButton();
            this.loadLeaderboard(event.currentTarget.vId);
            return;
        }// end function

        private function goConnectFacebook(event:Event) : void
        {
            Global.vSound.onButton();
            Settings.vFacebookDirect = true;
            Global.vTopBar.hide();
            Global.vRoot.launchMenu(Settings);
            return;
        }// end function

    }
}
