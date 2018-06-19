package menu
{
    import com.greensock.*;
    import com.greensock.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import globz.*;
    import menu.screens.*;
    import menu.tools.*;
    import sparks.*;
    import tools.*;

    public class TopBar extends MenuXXX
    {
        private var vTopBar:TopBarGraf;
        private var vPosTopBar:Point;
        private var vLowBar:LowBarGraf;
        private var vPosLowBar:Point;
        private var vGoldFont:MyFont;
        private var vXPFontInside:MyFont;
        private var vXPFontTitle:MyFont;
        private var vGoldBGDone:Boolean = false;
        private var vActive:Boolean = true;
        private var vHideDelay:Number = 0.6;
        private var vLowWidth:Number;
        private var vLowSizeSmall:Number;
        private var vLowSizeBig:Number;
        private var vNewShopCardGraf:Sprite;
        private var vLastTeamChecksum:String = "";
        public var vTransitionRunning:Boolean = false;
        private var vCurTab:int = -1;
        private var vCurTitle:ButtonTextBitmap;
        private var vNbIconPerXP:int = 2;
        private var vNewLevel:int;
        private var vNewXP:int;
        private var vNbItemXP:int;
        private var vNewGivenCardsArray:Array;
        private var vPreviousLevel:int;
        private var vNbIconPerTrophy:int = 2;
        private var vNewTrophy:int;
        private var vNewTrophyFinal:int;
        private var vNbItemTrophy:int;
        private var vNbIconPerGold:int = 2;
        private var vNbItemGold:int;
        private var vNewGold:int;
        private var vNewGoldFinal:int;
        public var vPackWon:Array;
        private var vOpeningRunning:Boolean = false;

        public function TopBar()
        {
            Global.vRoot.layerTop.addChild(this);
            this.vTopBar = new TopBarGraf();
            addChild(this.vTopBar);
            this.vPosTopBar = new Point(Global.vSize.x / 2, (-Global.vScreenDelta.y) / Global.vResolution);
            this.vTopBar.x = this.vPosTopBar.x;
            this.vTopBar.y = this.vPosTopBar.y;
            this.vTopBar.mcXP.x = this.vTopBar.mcXP.x - Global.vScreenDelta.x / Global.vResolution;
            this.vTopBar.mcGold.x = this.vTopBar.mcGold.x + Global.vScreenDelta.x / Global.vResolution;
            this.initButtons();
            this.vLowBar = new LowBarGraf();
            addChild(this.vLowBar);
            this.vPosLowBar = new Point(Global.vSize.x / 2, Global.vSize.y + Global.vScreenDelta.y / Global.vResolution);
            this.vLowBar.x = this.vPosLowBar.x;
            this.vLowBar.y = this.vPosLowBar.y;
            this.initButtonsLowBar();
            this.initSwipe();
            if (Global.vLogInfo)
            {
                addButton(this.vTopBar, new MenuButton_Info(), new Point(this.vTopBar.mcXP.x + 200, this.vTopBar.mcXP.y), this.toggleTrace, 1);
            }
            return;
        }// end function

        private function toggleTrace(event:Event) : void
        {
            if (Global.vClientTrace == null)
            {
                Global.vClientTrace = new MyLogTrace();
            }
            else
            {
                Global.vClientTrace.toggle();
            }
            return;
        }// end function

        public function refresh() : void
        {
            var _loc_2:* = null;
            if (Global.vServer == null)
            {
                return;
            }
            if (Global.vServer.vUser == null)
            {
                this.hide();
                return;
            }
            if (this.vXPFontTitle != null)
            {
                this.vTopBar.mcXP.removeChild(this.vXPFontTitle);
                this.vXPFontTitle = null;
            }
            this.vXPFontTitle = new MyFont(this.vTopBar.mcXP, "fontxptitle", Global.vServer.vUser.vLevel.toString(), this.vTopBar.mcXP.mcXPTitle.x, this.vTopBar.mcXP.mcXPTitle.y, true);
            if (this.vXPFontInside != null)
            {
                this.vTopBar.mcXP.removeChild(this.vXPFontInside);
                this.vXPFontInside = null;
            }
            while (_loc_3.vXP >= Global.vServer.getXPForLevel((_loc_3.vLevel + 1)))
            {
                
                Global.vServer.vUser.vXP = Global.vServer.vUser.vXP - Global.vServer.getXPForLevel((Global.vServer.vUser.vLevel + 1));
                var _loc_3:* = Global.vServer.vUser;
                var _loc_4:* = _loc_3.vLevel + 1;
                _loc_3.vLevel = _loc_4;
            }
            var _loc_1:* = _loc_3.vXP.toString() + "/" + Global.vServer.getXPForLevel((_loc_3.vLevel + 1)).toString();
            this.vXPFontInside = new MyFont(this.vTopBar.mcXP, "fontxpinside", _loc_1, this.vTopBar.mcXP.mcXPInside.x, this.vTopBar.mcXP.mcXPInside.y, true, 0.85);
            this.vTopBar.mcXP.mcMask.scaleX = _loc_3.vXP / Global.vServer.getXPForLevel((_loc_3.vLevel + 1));
            if (this.vGoldFont != null)
            {
                this.vTopBar.mcGold.removeChild(this.vGoldFont);
                this.vGoldFont = null;
            }
            this.vGoldFont = new MyFont(this.vTopBar.mcGold, "fontgold", _loc_3.vHardCurrency.toString(), this.vTopBar.mcGold.mcGoldFont.x, this.vTopBar.mcGold.mcGoldFont.y);
            if (!this.vGoldBGDone)
            {
                this.vTopBar.mcGold.mcBG.visible = false;
                this.vTopBar.mcGold.mcButton.visible = false;
                this.vTopBar.mcGold.mcButtonBG.visible = false;
                this.vTopBar.mcGold.mcIcon.visible = false;
                this.vGoldBGDone = true;
                _loc_2 = new GoldGraf();
                this.vTopBar.mcGold.addChildAt(new ButtonGrafBitmap(_loc_2), 0);
            }
            return;
        }// end function

        public function onLangChanged() : void
        {
            Global.vSound.onButton();
            this.vCurTab = -1;
            this.setTab(this.vCurTab);
            return;
        }// end function

        private function goShop(event:Event) : void
        {
            if (!this.vActive)
            {
                return;
            }
            this.setTab(1);
            Global.vSound.onButton();
            Shop.vDirectGold = true;
            Global.vRoot.launchMenu(Shop);
            return;
        }// end function

        private function showHelpXP(event:Event) : void
        {
            if (!this.vActive)
            {
                return;
            }
            Global.vSound.onButton();
            var _loc_2:* = new LevelXPGraf();
            _loc_2.gotoAndStop("StarOnly");
            _loc_2.txtLevel.htmlText = "<B>" + Global.vServer.vUser.vLevel.toString() + "</B>";
            var _loc_3:* = 2;
            _loc_2.scaleY = 2;
            _loc_2.scaleX = _loc_3;
            new MsgBox(this, Global.getText("txtXPHelp"), null, MsgBox.TYPE_TextWithGraf, {graf:_loc_2});
            return;
        }// end function

        private function goHome(event:Event) : void
        {
            Global.vRoot.launchMenu(Home);
            return;
        }// end function

        public function hide(param1:Boolean = false) : void
        {
            this.vActive = false;
            if (param1)
            {
                visible = false;
            }
            TweenMax.to(this.vTopBar, this.vHideDelay, {delay:0.05, x:this.vPosTopBar.x, y:this.vPosTopBar.y - 120, ease:Quad.easeIn});
            TweenMax.to(this.vLowBar, this.vHideDelay, {delay:0.05, x:this.vPosLowBar.x, y:this.vPosLowBar.y + 150, ease:Quad.easeIn});
            TweenMax.delayedCall(this.vHideDelay, this.refreshVisible);
            return;
        }// end function

        public function appear() : void
        {
            this.vActive = true;
            this.refreshVisible();
            TweenMax.to(this.vTopBar, this.vHideDelay, {x:this.vPosTopBar.x, y:this.vPosTopBar.y, ease:Quad.easeOut});
            TweenMax.to(this.vLowBar, this.vHideDelay, {x:this.vPosLowBar.x, y:this.vPosLowBar.y, ease:Quad.easeOut});
            TweenMax.delayedCall(this.vHideDelay, this.refreshVisible);
            return;
        }// end function

        private function refreshVisible() : void
        {
            visible = this.vActive;
            return;
        }// end function

        private function initButtons() : void
        {
            if (Capabilities.isDebugger)
            {
                this.vTopBar.mcGold.addEventListener(MouseEvent.MOUSE_DOWN, this.goShop);
                this.vTopBar.mcXP.addEventListener(MouseEvent.MOUSE_DOWN, this.showHelpXP);
            }
            else
            {
                this.vTopBar.mcGold.addEventListener(TouchEvent.TOUCH_BEGIN, this.goShop);
                this.vTopBar.mcXP.addEventListener(TouchEvent.TOUCH_BEGIN, this.showHelpXP);
            }
            return;
        }// end function

        private function initButtonsLowBar() : void
        {
            var _loc_2:* = null;
            var _loc_4:* = null;
            this.vLowWidth = Global.vSize.x + 2 * Global.vScreenDelta.x / Global.vResolution;
            this.vLowWidth = this.vLowWidth - 2 * 8;
            var _loc_1:* = 176 / 112;
            this.vLowSizeSmall = this.vLowWidth / (_loc_1 + 4);
            this.vLowSizeBig = _loc_1 * this.vLowSizeSmall;
            var _loc_3:* = 1;
            while (_loc_3 <= 5)
            {
                
                _loc_2 = this.vLowBar["mcButton" + _loc_3];
                _loc_2.vNum = _loc_3;
                while (_loc_2.mcIcon.numChildren > 0)
                {
                    
                    _loc_2.mcIcon.removeChildAt(0);
                }
                _loc_4 = new LowBar_Icons();
                _loc_4.gotoAndStop(_loc_3);
                _loc_4.name = "mcIcon";
                _loc_2.mcIcon.addChild(new ButtonGrafBitmap(_loc_4));
                if (_loc_3 == 1)
                {
                    this.vNewShopCardGraf = new ButtonGrafBitmap(new WarningGraf());
                    _loc_2.mcIcon.addChild(this.vNewShopCardGraf);
                    this.vNewShopCardGraf.x = this.vNewShopCardGraf.x + 30;
                    this.vNewShopCardGraf.y = this.vNewShopCardGraf.y - 30;
                    this.refreshNewShopCard();
                }
                if (Capabilities.isDebugger)
                {
                    _loc_2.addEventListener(MouseEvent.MOUSE_DOWN, this.onTabAction);
                }
                else
                {
                    _loc_2.addEventListener(TouchEvent.TOUCH_BEGIN, this.onTabAction);
                }
                _loc_3++;
            }
            this.vLowBar.mcShadow.width = this.vLowWidth + 24;
            this.refreshTeamIcon();
            return;
        }// end function

        public function refreshTeamIcon() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            var _loc_6:* = null;
            if (Global.vServer == null)
            {
                return;
            }
            var _loc_3:* = Global.vServer.vUser.vCurShirt;
            _loc_1 = 3;
            while (_loc_1 >= 1)
            {
                
                _loc_2 = Global.vServer.vUser.getCharAtPosition(_loc_1);
                if (_loc_2 == null)
                {
                    return;
                }
                Global.vServer.vUser.getCharAtPosition(_loc_1);
                _loc_3 = _loc_3 + "_" + _loc_2.vCharId;
                _loc_1 = _loc_1 - 1;
            }
            if (this.vLastTeamChecksum == _loc_3)
            {
                return;
            }
            this.vLastTeamChecksum = _loc_3;
            while (this.vLowBar.mcButton4.mcIcon.numChildren > 0)
            {
                
                this.vLowBar.mcButton4.mcIcon.removeChildAt(0);
            }
            var _loc_4:* = new LowBar_Icons();
            _loc_4.gotoAndStop(4);
            var _loc_5:* = _loc_4.mcGraf;
            _loc_1 = 3;
            while (_loc_1 >= 1)
            {
                
                _loc_6 = Global.vServer.vUser.getPersoGraf(_loc_1, true);
                var _loc_7:* = 1.1;
                _loc_6.scaleY = 1.1;
                _loc_6.scaleX = _loc_7;
                if (_loc_1 == 1)
                {
                    _loc_6.y = _loc_5.mcPerso1.y;
                }
                else if (_loc_1 == 2)
                {
                    _loc_6.x = _loc_5.mcPerso2.x;
                    _loc_6.y = _loc_5.mcPerso2.y;
                }
                else if (_loc_1 == 3)
                {
                    _loc_6.x = _loc_5.mcPerso3.x;
                    _loc_6.y = _loc_5.mcPerso3.y;
                }
                _loc_5.addChild(_loc_6);
                _loc_1 = _loc_1 - 1;
            }
            this.vLowBar.mcButton4.mcIcon.addChild(new ButtonGrafBitmap(_loc_4));
            return;
        }// end function

        public function refreshNewShopCard() : void
        {
            this.vNewShopCardGraf.visible = Global.vNewShopCard;
            return;
        }// end function

        private function onTabAction(event:Event) : void
        {
            if (!this.vActive)
            {
                return;
            }
            var _loc_2:* = event.currentTarget.vNum;
            Global.vSound.onButton();
            this.changeTab(_loc_2);
            return;
        }// end function

        public function getPosTab(param1:int) : Point
        {
            var _loc_2:* = new Point(0, 0);
            _loc_2.x = this.vLowBar.x + this.vLowBar["mcButton" + param1].x;
            _loc_2.y = this.vLowBar.y + this.vLowBar["mcButton" + param1].y;
            return _loc_2;
        }// end function

        private function changeTab(param1:int) : void
        {
            if (this.vCurTab == param1)
            {
                return;
            }
            if (this.vTransitionRunning)
            {
                return;
            }
            this.vTransitionRunning = true;
            this.setTab(param1);
            if (this.vCurTab == 1)
            {
                Global.vRoot.launchMenu(Shop);
            }
            if (this.vCurTab == 2)
            {
                Global.vRoot.launchMenu(CardManager);
            }
            if (this.vCurTab == 3)
            {
                Global.vRoot.launchMenu(Home);
            }
            if (this.vCurTab == 4)
            {
                Global.vRoot.launchMenu(TeamManager);
            }
            if (this.vCurTab == 5)
            {
                Global.vRoot.launchMenu(ShirtManager);
            }
            return;
        }// end function

        public function setTab(param1:int) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            if (this.vCurTab == param1)
            {
                return;
            }
            this.vCurTab = param1;
            if (this.vCurTab == 3)
            {
                Global.vSound.playMusic(0.1);
            }
            else
            {
                Global.vSound.playMusic(0.04);
            }
            var _loc_4:* = (-this.vLowWidth) / 2;
            var _loc_5:* = 1;
            while (_loc_5 <= 5)
            {
                
                _loc_2 = this.vLowBar["mcButton" + _loc_5];
                if (_loc_5 == this.vCurTab)
                {
                    _loc_4 = _loc_4 + this.vLowSizeBig / 2;
                }
                else
                {
                    _loc_4 = _loc_4 + this.vLowSizeSmall / 2;
                }
                _loc_2.x = _loc_4;
                if (_loc_5 == this.vCurTab)
                {
                    _loc_4 = _loc_4 + this.vLowSizeBig / 2;
                }
                else
                {
                    _loc_4 = _loc_4 + this.vLowSizeSmall / 2;
                }
                if (_loc_5 == 1)
                {
                    _loc_3 = 1;
                }
                else if (_loc_5 == 5)
                {
                    _loc_3 = 5;
                }
                else
                {
                    _loc_3 = 3;
                }
                if (_loc_5 == this.vCurTab)
                {
                    _loc_3 = _loc_3 + 1;
                }
                _loc_2.mcButton.gotoAndStop(_loc_3);
                if (_loc_5 == this.vCurTab)
                {
                    _loc_2.mcButton.width = this.vLowSizeBig;
                }
                else
                {
                    _loc_2.mcButton.width = this.vLowSizeSmall;
                }
                _loc_2.mcButton.width = _loc_2.mcButton.width + 2;
                if (_loc_5 == this.vCurTab)
                {
                    _loc_2.mcIcon.y = -26;
                    if (this.vCurTab == 3)
                    {
                        _loc_2.mcIcon.y = _loc_2.mcIcon.y - 8;
                    }
                }
                else
                {
                    _loc_2.mcIcon.y = 0;
                }
                if (_loc_5 == this.vCurTab)
                {
                    if (this.vCurTitle != null)
                    {
                        this.vLowBar.removeChild(this.vCurTitle);
                        this.vCurTitle = null;
                    }
                    this.vCurTitle = new ButtonTextBitmap(LowBar_Title, Global.getText("txtLowBarTab" + _loc_5));
                    this.vCurTitle.x = _loc_2.x;
                    this.vCurTitle.y = _loc_2.y + 32;
                    this.vLowBar.addChild(this.vCurTitle);
                }
                _loc_5++;
            }
            return;
        }// end function

        public function checkRewards() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            if (Global.vRewardAfterGame == null)
            {
                return;
            }
            Global.addLogTrace("checkRewards:" + JSON.stringify(Global.vRewardAfterGame), "TopBar");
            if (Global.vRewardAfterGame.vWinnings != null)
            {
                if (Global.vRewardAfterGame.vWinnings.length == 0)
                {
                    delete Global.vRewardAfterGame.vWinnings;
                    this.checkRewards();
                    return;
                }
                _loc_1 = new Array();
                _loc_2 = 0;
                while (_loc_2 < Global.vRewardAfterGame.vWinnings.length)
                {
                    
                    if (Global.vRewardAfterGame.vWinnings[_loc_2].card != null)
                    {
                        _loc_1.push(Global.vRewardAfterGame.vWinnings[_loc_2]);
                    }
                    else if (Global.vRewardAfterGame.vWinnings[_loc_2].trophies != null)
                    {
                        _loc_3 = Global.vRewardAfterGame.vWinnings[_loc_2].trophies;
                        if (Global.vRewardAfterGame.vNewTrophy == null)
                        {
                            Global.vRewardAfterGame.vNewTrophy = {add:_loc_3};
                        }
                        else
                        {
                            Global.vRewardAfterGame.vNewTrophy.add = Global.vRewardAfterGame.vNewTrophy.add + _loc_3;
                        }
                    }
                    _loc_2++;
                }
                new MsgBox(this, "", this.afterNewCards, MsgBox.TYPE_NewCard, {cards:_loc_1, direct:false});
                delete Global.vRewardAfterGame.vWinnings;
                return;
            }
            if (Global.vRewardAfterGame.vNewTrophy != null)
            {
                _loc_4 = parseInt(Global.vRewardAfterGame.vNewTrophy.add);
                delete Global.vRewardAfterGame.vNewTrophy;
                this.setNewTrophy(_loc_4, Home.vTrophyPos);
                TweenMax.delayedCall(0.5, this.checkRewards);
                return;
            }
            if (Global.vRewardAfterGame.vXP != null)
            {
                Toolz.traceObject(Global.vRewardAfterGame, "TopBar:Global.vRewardAfterGame");
                if (Global.vRewardAfterGame.vXP.GivenCard != null)
                {
                    _loc_1 = Global.vRewardAfterGame.vXP.GivenCard;
                }
                this.setNewXP(Global.vRewardAfterGame.vXP.level, Global.vRewardAfterGame.vXP.points, null, _loc_1);
                delete Global.vRewardAfterGame.vXP;
                return;
            }
            if (Global.vRewardAfterGame.vRewardDone != null)
            {
                delete Global.vRewardAfterGame.vRewardDone;
                if (Global.vGame != null)
                {
                    return;
                }
                Global.vServer.reloadUser(this.onRefreshRewardDone, Global.vServer.vUser.vUserId);
            }
            return;
        }// end function

        private function onRefreshRewardDone() : void
        {
            Global.addLogTrace("onRefreshRewardDone");
            return;
        }// end function

        private function afterNewCards(param1) : void
        {
            this.checkRewards();
            return;
        }// end function

        public function getDeltaXP(param1:int, param2:int) : int
        {
            var _loc_3:* = 0;
            if (param1 > Global.vServer.vUser.vLevel)
            {
                _loc_3 = Global.vServer.getXPForLevel(param1) - Global.vServer.vUser.vXP;
                _loc_3 = _loc_3 + param2;
            }
            else
            {
                _loc_3 = param2 - Global.vServer.vUser.vXP;
            }
            return _loc_3;
        }// end function

        public function forceNewXP(param1:int, param2:int) : void
        {
            this.vNewLevel = param1;
            this.vNewXP = param2;
            return;
        }// end function

        public function setNewXP(param1:int, param2:int, param3:Point = null, param4:Array = null) : void
        {
            Global.addLogTrace("setNewXP pNewLevel=" + param1 + " pNewXP=" + param2 + " pGivenCardsArray=" + param4, "TopBar");
            this.vNbIconPerXP = 2;
            this.vPreviousLevel = Global.vServer.vUser.vLevel;
            this.vNewLevel = param1;
            this.vNewXP = param2;
            if (this.vNewXP >= Global.vServer.getXPForLevel((param1 + 1)))
            {
                this.vNewXP = this.vNewXP - Global.vServer.getXPForLevel((param1 + 1));
                var _loc_9:* = this;
                var _loc_10:* = this.vNewLevel + 1;
                _loc_9.vNewLevel = _loc_10;
            }
            var _loc_5:* = this.getDeltaXP(this.vNewLevel, this.vNewXP);
            if (param4 != null)
            {
                this.vNewGivenCardsArray = param4;
            }
            var _loc_6:* = Math.ceil(_loc_5 / this.vNbIconPerXP);
            while (_loc_6 > 15)
            {
                
                var _loc_9:* = this;
                var _loc_10:* = this.vNbIconPerXP + 1;
                _loc_9.vNbIconPerXP = _loc_10;
                _loc_6 = Math.ceil(_loc_5 / this.vNbIconPerXP);
            }
            if (param3 == null)
            {
                param3 = new Point(Global.vSize.x / 2, Global.vSize.y / 2);
            }
            var _loc_7:* = new Point(this.vPosTopBar.x + this.vTopBar.mcXP.x, this.vPosTopBar.y + this.vTopBar.mcXP.y);
            this.vNbItemXP = _loc_6;
            var _loc_8:* = 0;
            while (_loc_8 < _loc_6)
            {
                
                new AddIcon(Global.vRoot.layerParticle, "icon_xp", param3, _loc_7, this.onStarReceived);
                _loc_8++;
            }
            return;
        }// end function

        private function onStarReceived() : void
        {
            if (Global.vServer.vUser == null)
            {
                return;
            }
            Global.vSound.onXP();
            var _loc_1:* = this;
            var _loc_2:* = this.vNbItemXP - 1;
            _loc_1.vNbItemXP = _loc_2;
            if (this.vNbItemXP == 0)
            {
                if (this.vPreviousLevel != this.vNewLevel)
                {
                    this.animLevelUp(this.vNewLevel);
                }
                Global.vServer.vUser.vLevel = this.vNewLevel;
                Global.vServer.vUser.vXP = this.vNewXP;
                this.refresh();
                if (this.vNewGivenCardsArray == null)
                {
                    this.checkRewards();
                }
                return;
            }
            Global.vServer.vUser.vXP = Global.vServer.vUser.vXP + this.vNbIconPerXP;
            this.refresh();
            return;
        }// end function

        private function animLevelUp(param1:int = -1) : void
        {
            if (param1 == -1)
            {
                param1 = Global.vServer.vUser.vLevel;
            }
            var _loc_2:* = new XPIcon();
            _loc_2.x = this.vTopBar.mcXP.x;
            _loc_2.y = this.vTopBar.mcXP.y;
            this.vTopBar.addChild(_loc_2);
            TweenMax.to(_loc_2, 0.3, {scaleX:3, scaleY:3, alpha:0, ease:Linear.easeInOut, onComplete:this.removeXPIcon, onCompleteParams:[_loc_2]});
            Global.vSound.onGift();
            var _loc_3:* = Global.getText("txtLevelUpCongrats").replace(/#/, param1.toString());
            var _loc_4:* = new LevelXPGraf();
            _loc_4.gotoAndStop("StarOnly");
            _loc_4.txtLevel.htmlText = "<B>" + param1.toString() + "</B>";
            var _loc_5:* = 2;
            _loc_4.scaleY = 2;
            _loc_4.scaleX = _loc_5;
            new MsgBox(this, _loc_3, this.showNewCardGiven, MsgBox.TYPE_TextWithGraf, {graf:_loc_4});
            return;
        }// end function

        private function removeXPIcon(param1:XPIcon) : void
        {
            if (this.vTopBar.contains(param1))
            {
                this.vTopBar.removeChild(param1);
            }
            return;
        }// end function

        private function showNewCardGiven(param1:Object = null) : void
        {
            if (this.vNewGivenCardsArray != null)
            {
                new MsgBox(Global.vRoot.vMenu, "", this.afterNewCardsGiven, MsgBox.TYPE_NewCard, {cards:this.vNewGivenCardsArray});
                this.vNewGivenCardsArray = null;
            }
            return;
        }// end function

        private function afterNewCardsGiven(param1:String) : void
        {
            this.checkRewards();
            return;
        }// end function

        public function setNewTrophy(param1:int, param2:Point = null) : void
        {
            this.vNbIconPerTrophy = 2;
            var _loc_3:* = Math.ceil(param1 / this.vNbIconPerTrophy);
            while (_loc_3 > 15)
            {
                
                var _loc_7:* = this;
                var _loc_8:* = this.vNbIconPerTrophy + 1;
                _loc_7.vNbIconPerTrophy = _loc_8;
                _loc_3 = Math.ceil(param1 / this.vNbIconPerTrophy);
            }
            var _loc_4:* = new Point(Global.vSize.x / 2, Global.vSize.y / 2);
            var _loc_5:* = param2.clone();
            this.vNbItemTrophy = _loc_3;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_3)
            {
                
                new AddIcon(this, "icon_trophy", _loc_4, _loc_5, this.onTrophyReceived);
                _loc_6++;
            }
            this.vNewTrophy = Global.vServer.vUser.vTrophy;
            this.vNewTrophyFinal = this.vNewTrophy + param1;
            return;
        }// end function

        private function onTrophyReceived() : void
        {
            Global.vSound.onTrophy();
            var _loc_1:* = this;
            var _loc_2:* = this.vNbItemTrophy - 1;
            _loc_1.vNbItemTrophy = _loc_2;
            if (this.vNbItemTrophy == 0)
            {
                Global.vServer.vUser.vTrophy = this.vNewTrophyFinal;
            }
            else
            {
                this.vNewTrophy = this.vNewTrophy + this.vNbIconPerTrophy;
                if (this.vNewTrophy > this.vNewTrophyFinal)
                {
                    this.vNewTrophy = this.vNewTrophyFinal;
                }
                if (Global.vServer.vUser != null)
                {
                    Global.vServer.vUser.vTrophy = this.vNewTrophy;
                }
            }
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
            return;
        }// end function

        public function onGoldAdded(param1:int, param2:Point = null) : void
        {
            this.vNbIconPerGold = 1;
            var _loc_3:* = Math.ceil(param1 / this.vNbIconPerGold);
            while (_loc_3 > 30)
            {
                
                var _loc_7:* = this;
                var _loc_8:* = this.vNbIconPerGold + 1;
                _loc_7.vNbIconPerGold = _loc_8;
                _loc_3 = Math.ceil(param1 / this.vNbIconPerGold);
            }
            if (param2 == null)
            {
                param2 = new Point(Global.vSize.x / 2, Global.vSize.y / 2);
            }
            var _loc_4:* = param2;
            var _loc_5:* = new Point(this.vPosTopBar.x + this.vTopBar.mcGold.x + this.vTopBar.mcGold.mcIcon.x, this.vPosTopBar.y + this.vTopBar.mcXP.y + this.vTopBar.mcGold.mcIcon.y);
            this.vNbItemGold = _loc_3;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_3)
            {
                
                new AddIcon(Global.vRoot.layerParticle, "icon_gold", _loc_4, _loc_5, this.onGoldReceived, 1, 1, 0, 1, true);
                _loc_6++;
            }
            this.vNewGold = Global.vServer.vUser.vHardCurrency;
            this.vNewGoldFinal = Global.vServer.vUser.vHardCurrency + param1;
            return;
        }// end function

        private function onGoldReceived() : void
        {
            var _loc_1:* = this;
            var _loc_2:* = this.vNbItemGold - 1;
            _loc_1.vNbItemGold = _loc_2;
            Global.vSound.onCoin();
            if (this.vNbItemGold <= 0)
            {
                Global.vServer.vUser.vHardCurrency = this.vNewGoldFinal;
            }
            else
            {
                this.vNewGold = this.vNewGold + this.vNbIconPerGold;
                if (this.vNewGold > this.vNewGoldFinal)
                {
                    this.vNewGold = this.vNewGoldFinal;
                }
                Global.vServer.vUser.vHardCurrency = this.vNewGold;
            }
            if (Global.vTopBar != null)
            {
                Global.vTopBar.refresh();
            }
            return;
        }// end function

        public function forceGold(param1:int) : void
        {
            this.vNbItemGold = 0;
            this.vNewGoldFinal = param1;
            Global.vServer.vUser.vHardCurrency = param1;
            this.refresh();
            return;
        }// end function

        private function initSwipe() : void
        {
            return;
        }// end function

        private function onSwipe(event:TransformGestureEvent) : void
        {
            if (event.offsetY != 0)
            {
                return;
            }
            var _loc_2:* = this.vCurTab - event.offsetX;
            if (_loc_2 < 1)
            {
                return;
            }
            if (_loc_2 > 5)
            {
                return;
            }
            this.changeTab(_loc_2);
            return;
        }// end function

        public function checkPackWon() : void
        {
            if (this.vOpeningRunning)
            {
                return;
            }
            if (this.vPackWon != null)
            {
                this.openNextPack();
            }
            return;
        }// end function

        private function openNextPack(param1 = null) : void
        {
            var _loc_3:* = undefined;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            this.vOpeningRunning = true;
            if (this.vPackWon == null || this.vPackWon.length == 0)
            {
                Global.vServer.reloadUser(this.afterPackWon, Global.vServer.vUser.vUserId);
                return;
            }
            var _loc_2:* = this.vPackWon.shift();
            for (_loc_3 in _loc_2)
            {
                
                if (_loc_3 == "nbGold")
                {
                    _loc_5 = _loc_2[_loc_3];
                    _loc_4 = Global.getText("txtGoldBought").replace(/#/, _loc_5.toString());
                    new MsgBox(Global.vRoot, _loc_4, this.openNextPack, MsgBox.TYPE_SimpleText);
                    this.onGoldAdded(_loc_5);
                    Global.vSound.onGift();
                    _loc_6 = new Point(Global.vSize.x / 2, Global.vSize.y / 2);
                    Global.startParticles(Global.vRoot, _loc_6, Global.vImages["particle_line_1"], 20, 0, 20, 60, 1, false, 1, 0.25, 0, 6, -6, 6, -6, 0.99, "add", true, false);
                    continue;
                }
                if (_loc_3 == "Cards")
                {
                    _loc_7 = _loc_2[_loc_3];
                    if (_loc_7.length == 0)
                    {
                        this.openNextPack();
                    }
                    else
                    {
                        new MsgBox(this, Global.getText("txtNewCardsGiven"), this.openNextPack, MsgBox.TYPE_NewCard, {cards:_loc_7, direct:false, pack:true});
                    }
                    continue;
                }
                if (_loc_3 == "newChar")
                {
                    _loc_8 = _loc_5.code;
                    _loc_9 = _loc_5.name;
                    _loc_10 = Global.getText("txtNewChar").replace(/#/, _loc_9);
                    new MsgBox(this, _loc_10, this.openNextPack, MsgBox.TYPE_NewChar, {charId:_loc_8});
                    continue;
                }
                if (_loc_3 == "newShirt")
                {
                    _loc_11 = _loc_5.code;
                    new MsgBox(this, Global.getText("txtNewShirt"), this.openNextPack, MsgBox.TYPE_NewShirt, {code:_loc_11});
                    continue;
                }
                Global.addLogTrace("openNextPack unknown type : " + _loc_3, "TopBar");
                this.openNextPack();
            }
            return;
        }// end function

        private function afterPackWon() : void
        {
            this.vOpeningRunning = false;
            this.vPackWon = null;
            return;
        }// end function

    }
}
