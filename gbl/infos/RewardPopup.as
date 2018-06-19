package gbl.infos
{
    import com.greensock.*;
    import com.greensock.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.text.*;
    import gbl.*;
    import globz.*;
    import menu.game.*;
    import menu.tools.*;
    import sparks.*;
    import tools.*;

    public class RewardPopup extends MovieClip
    {
        private var vImages:Object;
        private var vCallback:Function;
        private var vType:int;
        private var vData:Object;
        private var vGraf:Sprite;
        private var vDone:Boolean = true;
        private var vPosCard:Point;
        private var vTweenMax:TweenMax;
        private var vNBExplosions:int;

        public function RewardPopup(param1:DisplayObjectContainer, param2:Object, param3:Function)
        {
            var _loc_4:* = 0;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_15:* = null;
            var _loc_16:* = NaN;
            var _loc_17:* = null;
            this.vData = param2;
            this.vCallback = param3;
            if (this.vData == null || Global.vServer == null || Global.vServer.vUser == null)
            {
                this.vCallback.call();
                return;
            }
            var _loc_5:* = new MsgboxBG();
            var _loc_18:* = 30;
            _loc_5.scaleY = 30;
            _loc_5.scaleX = _loc_18;
            addChild(_loc_5);
            _loc_5.addEventListener(MouseEvent.CLICK, this.onClickBG);
            x = Global.vSize.x / 2;
            y = Global.vSize.y / 2;
            param1.addChild(this);
            _loc_7 = new RewardPopupGraf();
            Global.vRewardAfterGame = new Object();
            var _loc_8:* = "";
            var _loc_9:* = "";
            if (this.vData.statusGame == null)
            {
                this.vData.statusGame = "cancelled";
            }
            if (this.vData.statusGame == "victory")
            {
                _loc_7.mcRibbon.gotoAndStop(1);
                _loc_6 = Global.getText("txtEndGameVictory");
                this.vNBExplosions = 30;
                this.launchParticles();
            }
            else if (this.vData.statusGame == "defeat")
            {
                _loc_7.mcRibbon.gotoAndStop(2);
                _loc_6 = Global.getText("txtEndGameDefeat");
            }
            else if (this.vData.statusGame == "cancelled")
            {
                _loc_7.mcRibbon.gotoAndStop(3);
                _loc_7.mcXPGraf.visible = false;
                _loc_7.txtXP.visible = false;
                _loc_7.mcTrophy.visible = false;
                _loc_7.txtTrophy.visible = false;
                _loc_7.mcRibbon.txtInfo.htmlText = "<B>" + Global.getText("txtEndGameNoReward") + "</B>";
                Global.vLang.checkSans(_loc_7.mcRibbon.txtInfo);
                Toolz.textReduce(_loc_7.mcRibbon.txtInfo);
                _loc_6 = Global.getText("txtEndGameCancel");
            }
            _loc_7.txtTitle.htmlText = "<B>" + _loc_6 + "</B>";
            Global.vLang.checkSans(_loc_7.txtTitle);
            Toolz.textReduce(_loc_7.txtTitle);
            _loc_4 = 1;
            while (_loc_4 <= 2)
            {
                
                _loc_9 = "";
                if (this.vData["statusScore" + _loc_4] == "forfeit")
                {
                    _loc_9 = Global.getText("txtEndGameForfeit");
                }
                else if (this.vData["statusScore" + _loc_4] == "leaver")
                {
                    _loc_9 = Global.getText("txtEndGameConnectionIssue");
                }
                if (GBL_Main.isReverse)
                {
                    _loc_15 = _loc_7["txtStatus" + (3 - _loc_4)];
                }
                else
                {
                    _loc_15 = _loc_7["txtStatus" + _loc_4];
                }
                _loc_15.htmlText = "<B>" + _loc_9 + "</B>";
                Global.vLang.checkSans(_loc_15);
                Toolz.textReduce(_loc_15);
                _loc_4++;
            }
            _loc_7.txtScore.htmlText = "<b>" + this.vData.vScore1 + " - " + this.vData.vScore2 + "</B>";
            if (Global.vServer.vSeat == 2)
            {
                _loc_16 = _loc_7.mcSeat1.x;
                _loc_7.mcSeat1.x = _loc_7.mcSeat2.x;
                _loc_7.mcSeat2.x = _loc_16;
            }
            if (this.vData.trophies == null)
            {
                this.vData.trophies = 0;
            }
            if (this.vData.trophies + Global.vServer.vUser.vTrophy < 0)
            {
                this.vData.trophies = -Global.vServer.vUser.vTrophy;
            }
            _loc_6 = this.vData.trophies.toString();
            if (this.vData.trophies > 0)
            {
                _loc_6 = "+" + _loc_6;
                Global.vRewardAfterGame.vNewTrophy = {add:this.vData.trophies};
            }
            else
            {
                Global.vServer.vUser.vTrophy = Global.vServer.vUser.vTrophy + this.vData.trophies;
            }
            _loc_7.txtTrophy.htmlText = "<B>" + _loc_6 + "</B>";
            Global.vLang.checkSans(_loc_7.txtTrophy);
            Toolz.textReduce(_loc_7.txtTrophy);
            _loc_4 = 1;
            while (_loc_4 <= 2)
            {
                
                _loc_7["mcSeat" + _loc_4].txtPlayer.htmlText = "<b>" + this.vData["name" + _loc_4] + "</b>";
                Global.vLang.checkSans(_loc_7["mcSeat" + _loc_4].txtPlayer);
                Toolz.textReduce(_loc_7["mcSeat" + _loc_4].txtPlayer);
                _loc_4++;
            }
            if (this.vData.xp != null)
            {
                _loc_7.txtXP.htmlText = "<B>" + "+" + this.vData.xp.toString() + "</B>";
                Global.vRewardAfterGame.vXP = {level:Global.vServer.vUser.vLevel, points:Global.vServer.vUser.vXP + this.vData.xp};
                if (this.vData.xpCard != null)
                {
                    Global.vRewardAfterGame.vXP.GivenCard = this.vData.xpCard;
                }
            }
            else
            {
                _loc_7.txtXP.htmlText = "<B>0</B>";
            }
            if (this.vData.consecutiveWins != null)
            {
                Global.vServer.vUser.vConsecutiveWins = this.vData.consecutiveWins;
            }
            if (this.vData.winnings != null)
            {
                this.vPosCard = new Point(_loc_7.mcCard.x, _loc_7.mcCard.y);
                Global.vRewardAfterGame.vWinnings = this.vData.winnings;
                this.vData.cards = null;
            }
            if (Matchmaking.vPrivatePass != "")
            {
                _loc_7.mcXPGraf.visible = false;
                _loc_7.txtXP.visible = false;
                _loc_7.mcTrophy.visible = false;
                _loc_7.txtTrophy.visible = false;
                _loc_7.txtFriendlyWarning.htmlText = Global.getText("txtPrivateGameNoReward");
                Global.vLang.checkSans(_loc_7.txtFriendlyWarning);
                Toolz.textReduce(_loc_7.txtFriendlyWarning);
            }
            else
            {
                _loc_7.txtFriendlyWarning.htmlText = "";
            }
            _loc_4 = 1;
            while (_loc_4 <= 3)
            {
                
                _loc_11 = Global.vServer.vUser.getPersoGraf(_loc_4, true);
                var _loc_18:* = 2.3;
                _loc_11.scaleY = 2.3;
                _loc_11.scaleX = _loc_18;
                _loc_11.x = _loc_7["mcPerso" + _loc_4].x;
                _loc_11.y = _loc_7["mcPerso" + _loc_4].y;
                _loc_7.addChild(_loc_11);
                _loc_4++;
            }
            _loc_4 = 1;
            while (_loc_4 <= 3)
            {
                
                _loc_10 = Global.vServer.vUser.getCharAtPosition(_loc_4);
                if (_loc_10.getEnergy() == 100)
                {
                    _loc_17 = new Date();
                    _loc_10.vEnergyTS = _loc_17.getTime() / 1000;
                    _loc_10.vEnergy = 100 - this.getEnergyLoss(_loc_10.vCharId);
                }
                else
                {
                    _loc_10.vEnergy = _loc_10.vEnergy - this.getEnergyLoss(_loc_10.vCharId);
                }
                new EnergyBar(_loc_10, _loc_7, _loc_7["mcEnergy" + _loc_4].x, _loc_7["mcEnergy" + _loc_4].y);
                _loc_4++;
            }
            var _loc_12:* = 0;
            _loc_4 = 1;
            while (_loc_4 <= 3)
            {
                
                _loc_10 = Global.vServer.vUser.getCharAtPosition(_loc_4);
                _loc_12 = -this.getEnergyLoss(_loc_10.vCharId);
                if (_loc_12 == 0)
                {
                    _loc_7["mcLoss" + _loc_4].visible = false;
                }
                else
                {
                    _loc_7["mcLoss" + _loc_4].txtLoss.text = _loc_12.toString();
                }
                _loc_4++;
            }
            Global.vRewardAfterGame.vRewardDone = true;
            this.vImages = new Object();
            var _loc_13:* = new mcToBitmapQueue();
            var _loc_14:* = new MovieClip();
            _loc_14.addChild(_loc_7);
            this.vImages["box"] = new mcToBitmapAS3(_loc_14, 0, Global.vResolution, true, null, 0, _loc_13);
            _loc_13.startConversion(this.initGameGrafDone);
            this.addEventListener(Event.REMOVED_FROM_STAGE, this.onStageRemoved);
            return;
        }// end function

        private function getEnergyLoss(param1:String) : int
        {
            if (this.vData.energyLoss == null)
            {
                return 0;
            }
            var _loc_2:* = 0;
            while (_loc_2 < this.vData.energyLoss.length)
            {
                
                if (this.vData.energyLoss[_loc_2].Code == param1)
                {
                    return this.vData.energyLoss[_loc_2].Loss;
                }
                _loc_2++;
            }
            return 0;
        }// end function

        private function onStageRemoved(event:Event) : void
        {
            var _loc_2:* = undefined;
            Global.addEventTrace("RewardPopup.onStageRemoved");
            this.removeEventListener(Event.REMOVED_FROM_STAGE, this.onStageRemoved);
            if (this.vImages != null)
            {
                for (_loc_2 in this.vImages)
                {
                    
                    _loc_4[_loc_2].destroyAll();
                    delete _loc_4[_loc_2];
                }
                this.vImages = null;
            }
            if (this.vTweenMax != null)
            {
                this.vTweenMax.kill();
            }
            this.vTweenMax = null;
            return;
        }// end function

        private function initGameGrafDone() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            this.vGraf = new Sprite();
            addChild(this.vGraf);
            var _loc_1:* = new bitmapClip(this.vImages["box"]);
            this.vGraf.addChild(_loc_1);
            if (this.vPosCard != null)
            {
                if (Global.vServer.vUser.vLevel >= 4)
                {
                    _loc_2 = Global.vServer.vUser.vConsecutiveWins - 1;
                    if (_loc_2 < 0)
                    {
                        _loc_2 = Global.vConsecutiveWins.length - 1;
                    }
                    _loc_3 = new ConsecutiveWinStep(_loc_2, true, false, true);
                    _loc_3.x = this.vPosCard.x;
                    _loc_3.y = this.vPosCard.y;
                    var _loc_6:* = 1.5;
                    _loc_3.scaleY = 1.5;
                    _loc_3.scaleX = _loc_6;
                    _loc_4 = new ButtonGrafBitmap(_loc_3);
                    this.vGraf.addChild(_loc_4);
                    if (Capabilities.isDebugger)
                    {
                        _loc_4.addEventListener(MouseEvent.MOUSE_DOWN, this.showConsecutiveWins);
                    }
                    else
                    {
                        _loc_4.addEventListener(TouchEvent.TOUCH_BEGIN, this.showConsecutiveWins);
                    }
                }
                else
                {
                    _loc_5 = new Card("Card", "?");
                    _loc_5.x = this.vPosCard.x;
                    _loc_5.y = this.vPosCard.y;
                    this.vGraf.addChild(_loc_5);
                }
            }
            this.addEventListener(MouseEvent.MOUSE_DOWN, this.onClick);
            TweenMax.from(this.vGraf, 0.3, {scaleX:0, scaleY:0, ease:Back.easeOut, onComplete:this.onMsgBoxReady});
            return;
        }// end function

        private function onClickBG(event:MouseEvent) : void
        {
            Global.addEventTrace("RewardPopup.onClickBG");
            return;
        }// end function

        private function showConsecutiveWins(event:MouseEvent) : void
        {
            Global.addEventTrace("RewardPopup.showConsecutiveWins");
            if (Global.vServer.vUser.vConsecutiveWins == 0)
            {
                Global.vServer.vUser.vConsecutiveWins = Global.vConsecutiveWins.length - 1;
            }
            else
            {
                var _loc_2:* = Global.vServer.vUser;
                var _loc_3:* = _loc_2.vConsecutiveWins - 1;
                _loc_2.vConsecutiveWins = _loc_3;
            }
            new MsgBox(this, "", this.afterConsecutiveWins, MsgBox.TYPE_ConsecutiveWins);
            event.stopImmediatePropagation();
            event.stopPropagation();
            Global.vSound.onButton();
            return;
        }// end function

        private function afterConsecutiveWins() : void
        {
            if (Global.vServer.vUser.vConsecutiveWins == (Global.vConsecutiveWins.length - 1))
            {
                Global.vServer.vUser.vConsecutiveWins = 0;
            }
            else
            {
                var _loc_1:* = Global.vServer.vUser;
                var _loc_2:* = _loc_1.vConsecutiveWins + 1;
                _loc_1.vConsecutiveWins = _loc_2;
            }
            return;
        }// end function

        private function onMsgBoxReady() : void
        {
            this.vDone = false;
            Global.vServer.rewardDisplayed();
            return;
        }// end function

        private function onClick(event:MouseEvent = null) : void
        {
            Global.addEventTrace("RewardPopup.onClick");
            if (this.vDone)
            {
                return;
            }
            this.vDone = true;
            Global.vSound.onButton();
            this.closeBox();
            return;
        }// end function

        private function closeBox() : void
        {
            TweenMax.to(this, 0.3, {scaleX:0, scaleY:0, ease:Back.easeIn, onComplete:this.boxClosed});
            return;
        }// end function

        private function boxClosed() : void
        {
            this.removeEventListener(MouseEvent.MOUSE_DOWN, this.onClick);
            if (this.parent)
            {
                if (this.parent.contains(this))
                {
                    this.parent.removeChild(this);
                }
            }
            this.vCallback.call();
            return;
        }// end function

        private function launchParticles() : void
        {
            if (this.vTweenMax != null)
            {
                this.vTweenMax.kill();
            }
            this.vTweenMax = null;
            Global.vSound.firework();
            Global.startParticles(this, new Point(Math.random() * Global.vSize.x - Global.vSize.x * 0.5, Math.random() * Global.vSize.y - Global.vSize.y * 0.5), Global.vImages["particle_confetti"], 2, 0, 20, 60, 0.25, true, 1, 0.1, 0.1, 10, -10, 10, -10, 0.98, "normal", true, false);
            var _loc_1:* = this;
            var _loc_2:* = this.vNBExplosions - 1;
            _loc_1.vNBExplosions = _loc_2;
            if (this.vNBExplosions > 0)
            {
                this.vTweenMax = TweenMax.delayedCall(0.3 + Math.random() * 0.3, this.launchParticles);
            }
            return;
        }// end function

    }
}
