package gbl
{
    import flash.display.*;
    import flash.geom.*;
    import gbl.perso.*;
    import globz.*;

    public class GBL_Glob extends Dyna
    {
        public var vTeam:int;
        public var vName:String;
        public var vPosition:int = 0;
        public var vAttributeForce:int;
        public var vAttributeSpeed:int;
        public var vAttributeVitality:int;
        public var vCategory:String = "";
        public var vCharCode:String = "";
        public var vShirtCode:String = "";
        public var vCanCollide:Boolean = true;
        public var vCanCollidePassive:Boolean = true;
        public var vEnergyStats:Object;
        public var vShape:Shape;
        public var vGame:GBL_Main;
        public var vPerso:GBL_Perso;
        public var vCurOrientation:Number = 0;
        private var vBallSpeedMax:int = 1500;
        private var vLabel:GrafSimpleText;
        private var vArrow:MovieClip;
        private var vArrowLine:bitmapClip;
        private var vArrowEnd:bitmapClip;
        private var vArrowOutline:MovieClip;
        private var vArrowOutlineLine:bitmapClip;
        private var vArrowOutlineEnd:bitmapClip;
        private var vArrowOrder:Point;
        private var vArrowLengthMax:int = 100;
        public var vHP:int;
        public var vHPMax:int;
        public var vHPRegen:int;
        private var vHitFrom:Object;
        public var vWounded:Boolean = false;
        private var vCoefHeavyVsLight:Number = 2.2;
        public static var BALL_SIZE_COEF:Number = 0.6;

        public function GBL_Glob(param1:int, param2:int = 0, param3:int = 0, param4:int = 0)
        {
            this.vArrowOrder = new Point(0, 0);
            this.vHitFrom = new Object();
            this.vTeam = param1;
            vPos = new Point(0, 0);
            this.vAttributeForce = param2;
            this.vAttributeSpeed = param3;
            this.vAttributeVitality = param4;
            setAttributeForce(this.vAttributeForce);
            setAttributeSpeed(this.vAttributeSpeed);
            setAttributeVitality(this.vAttributeVitality);
            if (this.vTeam == 3)
            {
            }
            return;
        }// end function

        public function clone() : GBL_Glob
        {
            var _loc_1:* = new GBL_Glob(this.vTeam, this.vAttributeForce, this.vAttributeSpeed, this.vAttributeVitality);
            _loc_1.vId = vId;
            _loc_1.vPosition = this.vPosition;
            _loc_1.vAttributeForce = this.vAttributeForce;
            _loc_1.vAttributeSpeed = this.vAttributeSpeed;
            _loc_1.vAttributeVitality = this.vAttributeVitality;
            _loc_1.vName = this.vName;
            _loc_1.setAttributeForce(this.vAttributeForce);
            _loc_1.setAttributeSpeed(this.vAttributeSpeed);
            _loc_1.setAttributeVitality(this.vAttributeVitality);
            _loc_1.isKilled = isKilled;
            _loc_1.vCategory = this.vCategory;
            _loc_1.vCharCode = this.vCharCode;
            _loc_1.vShirtCode = this.vShirtCode;
            _loc_1.vPos = vPos.clone();
            _loc_1.setRadius(vRadius);
            _loc_1.vCurOrientation = this.vCurOrientation;
            _loc_1.vHP = this.vHP;
            _loc_1.vHPMax = this.vHPMax;
            _loc_1.vHPRegen = this.vHPRegen;
            _loc_1.vCanCollidePassive = this.vCanCollidePassive;
            _loc_1.vCanCollide = this.vCanCollide;
            _loc_1.vEnergyStats = this.vEnergyStats;
            return _loc_1;
        }// end function

        override public function toString() : String
        {
            return "[GBL_Glob vTeam=" + this.vTeam + " vPosition=" + this.vPosition + " vId=" + vId + "]";
        }// end function

        public function getEnergyTrace() : String
        {
            if (this.vEnergyStats == null)
            {
                return "";
            }
            var _loc_1:* = "ArrowSum=" + Math.round(100 * this.vEnergyStats.ordersTotal);
            _loc_1 = _loc_1 + "\n" + "ArrowNorm=" + Math.round(100 * this.vEnergyStats.ordersNorm);
            _loc_1 = _loc_1 + "\n" + "KO=" + this.vEnergyStats.nbKos;
            _loc_1 = _loc_1 + "\n" + "Kill=" + this.vEnergyStats.nbKilled;
            return _loc_1;
        }// end function

        public function setGame(param1:GBL_Main) : void
        {
            this.vGame = param1;
            return;
        }// end function

        public function getPersoGraf(param1:Boolean = false) : GBL_Perso
        {
            var _loc_2:* = null;
            if (this.vGame == null)
            {
                Global.onError("GBL_Glob.getPersoGraf vGame=null", true);
                return new GBL_Perso();
            }
            if (this.vPerso == null)
            {
                if (this.vTeam == 3)
                {
                    this.vPerso = new GBL_Perso_Simple(this.vGame, true);
                }
                else
                {
                    _loc_2 = Global.vPersoTab[Global.vPersoType];
                    this.vPerso = new _loc_2(this.vGame, true);
                }
                this.vPerso.init(this);
                this.refresh();
            }
            return this.vPerso;
        }// end function

        public function destroyPersoGraf() : void
        {
            if (this.vPerso != null)
            {
                this.vPerso.destroy();
                this.vPerso = null;
            }
            return;
        }// end function

        override protected function isKillInside(param1:Boolean = false) : void
        {
            if (this.vGame != null)
            {
                if (this.vGame.vCompute != null)
                {
                    this.vGame.vCompute.saveEvent("killed", {id:vId});
                }
            }
            if (this.vPerso == null)
            {
                return;
            }
            this.vPerso.doKill(param1);
            return;
        }// end function

        public function setOrientation(param1:Number, param2:Number = 0) : void
        {
            param1 = param1 + 90;
            while (param1 > 180)
            {
                
                param1 = param1 - 360;
            }
            while (param1 <= -180)
            {
                
                param1 = param1 + 360;
            }
            if (this.vPerso != null)
            {
                this.vPerso.setOrientation(param1, param2);
            }
            this.vCurOrientation = param1;
            return;
        }// end function

        public function beforeUpdate() : void
        {
            if (this.vTeam == 3)
            {
                if (vSpeed.length > this.vBallSpeedMax)
                {
                    vSpeed.normalize(this.vBallSpeedMax);
                }
            }
            return;
        }// end function

        public function afterUpdate() : void
        {
            var _loc_1:* = NaN;
            if (vSpeed.length > 1)
            {
                _loc_1 = Math.atan2(vSpeed.y, vSpeed.x) * 180 / Math.PI;
                if (this.vGame != null)
                {
                    if (GBL_Main.isReverse)
                    {
                        _loc_1 = _loc_1 + 180;
                    }
                }
                if (vSpeed.length > 300)
                {
                    this.setOrientation(_loc_1);
                }
            }
            if (this.vGame != null)
            {
                if (Global.vHitPoints)
                {
                    if (this.vGame.vAction == null)
                    {
                        this.onStepUpdateHit();
                    }
                }
            }
            return;
        }// end function

        public function showLabel(param1:String) : void
        {
            if (this.vLabel != null)
            {
                this.vPerso.removeChild(this.vLabel);
                this.vLabel = null;
            }
            this.vLabel = new GrafSimpleText();
            this.vLabel.txtTitle.text = param1;
            this.vPerso.addChild(this.vLabel);
            return;
        }// end function

        public function canPlay() : Boolean
        {
            if (isKilled)
            {
                return false;
            }
            if (!Global.vHitPoints)
            {
                return true;
            }
            if (this.vHP > 0)
            {
                return true;
            }
            return false;
        }// end function

        public function showArrow(param1:Point, param2:Boolean = true) : void
        {
            if (this.vPerso == null)
            {
                Global.onError("GBL_Glob.showArrow vPerso=Null");
                return;
            }
            if (this.vArrow == null)
            {
                this.vArrow = new MovieClip();
                this.vGame.layerPlayers.addChild(this.vArrow);
                this.vArrowLine = new bitmapClip(this.vGame.vImages["arrow_line"]);
                this.vArrow.addChild(this.vArrowLine);
                this.vArrowEnd = new bitmapClip(this.vGame.vImages["arrow_end"]);
                this.vArrow.addChild(this.vArrowEnd);
                if (this.vGame.vReplay)
                {
                    if (GBL_Main.isReverse)
                    {
                        this.vArrowLine.gotoAndStop(3 - this.vTeam);
                        this.vArrowEnd.gotoAndStop(3 - this.vTeam);
                    }
                    else
                    {
                        this.vArrowLine.gotoAndStop(this.vTeam);
                        this.vArrowEnd.gotoAndStop(this.vTeam);
                    }
                }
                else if (this.vTeam != this.vGame.vCurTeam)
                {
                    this.vArrowLine.gotoAndStop(2);
                    this.vArrowEnd.gotoAndStop(2);
                }
                this.vArrowOutline = new MovieClip();
                this.vArrowOutline.visible = false;
                this.vGame.layerPlayers.addChild(this.vArrowOutline);
                this.vArrowOutlineLine = new bitmapClip(this.vGame.vImages["arrow_line"]);
                this.vArrowOutline.addChild(this.vArrowOutlineLine);
                this.vArrowOutlineEnd = new bitmapClip(this.vGame.vImages["arrow_end"]);
                this.vArrowOutline.addChild(this.vArrowOutlineEnd);
                this.vArrowOutlineLine.gotoAndStop("Outline");
                this.vArrowOutlineEnd.gotoAndStop("Outline");
            }
            this.vGame.layerPlayers.setChildIndex(this.vArrow, (this.vGame.layerPlayers.numChildren - 1));
            this.vGame.layerPlayers.setChildIndex(this.vPerso, (this.vGame.layerPlayers.numChildren - 1));
            this.vArrow.x = this.vPerso.x;
            this.vArrow.y = this.vPerso.y;
            this.vArrow.rotation = 0;
            var _loc_3:* = Point.distance(this.getGrafPos(), param1);
            var _loc_4:* = this.getArrowMax();
            if (_loc_3 > _loc_4)
            {
                _loc_3 = _loc_4;
            }
            this.vArrowLine.width = _loc_3;
            this.vArrowEnd.x = _loc_3 - 2;
            this.vArrow.rotation = Math.atan2(param1.y - this.vPerso.y, param1.x - this.vPerso.x) * 180 / Math.PI;
            this.vArrowOrder.x = param1.x - this.vPerso.x;
            this.vArrowOrder.y = param1.y - this.vPerso.y;
            if (this.vArrowOrder.length > _loc_4)
            {
                this.vArrowOrder.normalize(_loc_4);
            }
            this.vArrowOrder.x = Math.round(100 * this.vArrowOrder.x) / 100;
            this.vArrowOrder.y = Math.round(100 * this.vArrowOrder.y) / 100;
            this.vArrow.rotation = 0;
            this.vArrowLine.width = this.vArrowOrder.length;
            this.vArrow.rotation = Math.atan2(this.vArrowOrder.y, this.vArrowOrder.x) * 180 / Math.PI;
            this.showArrowOutline();
            if (GBL_Main.isReverse)
            {
                this.vArrowOrder.x = this.vArrowOrder.x * -1;
                this.vArrowOrder.y = this.vArrowOrder.y * -1;
            }
            if (this.vArrowOrder.length > 1)
            {
                this.setOrientation(this.vArrow.rotation, 0);
                this.vArrow.visible = true;
            }
            else
            {
                this.vArrow.visible = false;
            }
            if (param2)
            {
                this.vPerso.setHighlight(true);
            }
            return;
        }// end function

        public function getArrowMax() : Number
        {
            return this.vArrowLengthMax * vCoefInput;
        }// end function

        public function hideArrow() : void
        {
            if (this.vArrow != null)
            {
                this.vArrow.visible = false;
            }
            this.hideArrowOutline();
            return;
        }// end function

        public function hideArrowOutline() : void
        {
            if (this.vArrowOutline != null)
            {
                this.vArrowOutline.visible = false;
            }
            return;
        }// end function

        public function showArrowOutline() : void
        {
            if (this.vArrow == null)
            {
                if (this.vArrowOutline != null)
                {
                    this.vArrowOutline.visible = false;
                }
                return;
            }
            if (this.vArrowOutline != null)
            {
                if (this.vArrow.visible == false)
                {
                    this.vArrowOutline.visible = false;
                }
                else
                {
                    this.vGame.layerPlayers.setChildIndex(this.vArrowOutline, (this.vGame.layerPlayers.numChildren - 1));
                    this.vArrowOutline.x = this.vArrow.x;
                    this.vArrowOutline.y = this.vArrow.y;
                    this.vArrowOutlineLine.width = this.vArrowLine.width - 3;
                    this.vArrowOutlineEnd.x = this.vArrowEnd.x;
                    this.vArrowOutline.rotation = this.vArrow.rotation;
                    this.vArrowOutline.visible = true;
                    if (this.vArrowLine.width < 3)
                    {
                        this.vArrowOutline.visible = false;
                    }
                }
            }
            return;
        }// end function

        public function onEndArrow() : void
        {
            if (this.vPerso == null)
            {
                return;
            }
            Global.vSound.onButton();
            this.vPerso.setHighlight(false);
            if (this.vArrow != null)
            {
                this.vGame.layerPlayers.setChildIndex(this.vArrow, 0);
            }
            this.vGame.vTerrain.refreshZOrder();
            return;
        }// end function

        public function setArrowOrder(param1:Point) : void
        {
            this.vArrowOrder = param1.clone();
            return;
        }// end function

        public function getArrowOrder() : Point
        {
            return this.vArrowOrder.clone();
        }// end function

        public function getOrder() : String
        {
            if (this.vArrowOrder == null)
            {
                return "0,0";
            }
            return formatValue(this.vArrowOrder.x) + "," + formatValue(this.vArrowOrder.y);
        }// end function

        public function setArrowCoef(param1:Number) : void
        {
            this.vArrowOrder.x = this.vArrowOrder.x * param1;
            this.vArrowOrder.y = this.vArrowOrder.y * param1;
            return;
        }// end function

        public function previewArrow(param1:Point) : void
        {
            if (isKilled)
            {
                return;
            }
            var _loc_2:* = new Point(param1.x + vPos.x, param1.y + vPos.y);
            if (GBL_Main.isReverse)
            {
                _loc_2.x = -_loc_2.x;
                _loc_2.y = -_loc_2.y;
            }
            this.showArrow(_loc_2, false);
            return;
        }// end function

        public function setHitPoints(param1:int, param2:int) : void
        {
            this.vHP = param1;
            this.vHPMax = param1;
            this.vHPRegen = param2;
            this.vHitFrom = new Object();
            this.refreshHP();
            return;
        }// end function

        public function refreshHP() : void
        {
            if (this.vPerso != null)
            {
                this.vPerso.showHitPoints(this.vHP, this.vHPMax);
            }
            return;
        }// end function

        public function removeHP(param1:GBL_Glob) : Boolean
        {
            if (this.vHitFrom[param1.vId] != null)
            {
                return false;
            }
            this.vHitFrom[param1.vId] = 10;
            if (this.vHP == 0)
            {
                return false;
            }
            var _loc_2:* = this;
            var _loc_3:* = this.vHP - 1;
            _loc_2.vHP = _loc_3;
            this.refreshHP();
            if (this.vGame.vCompute != null)
            {
                this.vGame.vCompute.saveEvent("setHP", {id:vId, hp:this.vHP});
            }
            return true;
        }// end function

        public function onStepUpdateHit() : void
        {
            var _loc_1:* = undefined;
            for (_loc_1 in this.vHitFrom)
            {
                
                var _loc_4:* = this.vHitFrom;
                var _loc_5:* = _loc_1;
                var _loc_6:* = _loc_3[_loc_1] - 1;
                _loc_4[_loc_5] = _loc_6;
                if (_loc_3[_loc_1] == 0)
                {
                    delete _loc_3[_loc_1];
                }
            }
            return;
        }// end function

        public function checkWound() : void
        {
            if (isKilled)
            {
                return;
            }
            if (this.vWounded)
            {
                this.vHP = this.vHPRegen;
                this.vWounded = false;
                this.refreshHP();
                Global.setTint(this.vPerso, 0, 0);
            }
            else if (this.vHP == 0)
            {
                this.vWounded = true;
                Global.setTint(this.vPerso, 6198029, 0.75);
                GBL_Perso_Puppet(this.vPerso).anim("ko");
                if (!GBL_Main.vGameJoining)
                {
                    Global.startParticles(this.vGame.layerPlayers, this.vPerso, Global.vImages["particle_smoke"], 5, 0, 5, 30 / GBL_Resolution.vSpeedCoef, 1, true, 0.75, 0.1, 0, 0, 0, -1, -4, 0.98, "normal", true, false);
                    Global.vSound.koSFX();
                }
                if (this.vEnergyStats != null)
                {
                    var _loc_1:* = this.vEnergyStats;
                    var _loc_2:* = _loc_1.nbKos + 1;
                    _loc_1.nbKos = _loc_2;
                }
            }
            return;
        }// end function

        public function reset() : void
        {
            this.vArrowOrder = new Point(0, 0);
            if (!isKilled)
            {
                this.unCompress();
                resetSpeed();
                this.refreshHP();
            }
            return;
        }// end function

        public function setPosInit(param1:Point) : void
        {
            isKilled = false;
            if (this.vPerso != null)
            {
                Global.setTint(this.vPerso, 0, 0);
                this.vPerso.onPosInit();
            }
            setPos(param1.x, param1.y);
            this.reset();
            this.refresh();
            return;
        }// end function

        public function getGrafPos() : Point
        {
            if (this.vPerso == null)
            {
                return new Point(0, 0);
            }
            return new Point(this.vPerso.x, this.vPerso.y);
        }// end function

        override public function refresh() : void
        {
            if (this.vPerso == null)
            {
                return;
            }
            this.vPerso.x = vPos.x;
            this.vPerso.y = vPos.y;
            if (GBL_Main.isReverse)
            {
                this.vPerso.x = this.vPerso.x * -1;
                this.vPerso.y = this.vPerso.y * -1;
            }
            this.vPerso.onRefreshPos();
            return;
        }// end function

        override protected function updateEnd(param1:Number) : void
        {
            if (vId == 2)
            {
            }
            return;
        }// end function

        override protected function getKickCoef(param1:Dyna, param2:Dyna) : Number
        {
            var _loc_5:* = NaN;
            var _loc_3:* = param1 as GBL_Glob;
            var _loc_4:* = param2 as GBL_Glob;
            if (Global.vKick)
            {
                if (_loc_4.vTeam == 3)
                {
                    return 8;
                }
                if (_loc_3.vTeam == 3)
                {
                    return 3;
                }
            }
            if (_loc_3.vTeam != 3 && _loc_4.vTeam != 3)
            {
                _loc_5 = 2 * this.convertAttribute(_loc_3.vAttributeForce) / (this.convertAttribute(_loc_3.vAttributeForce) + this.convertAttribute(_loc_4.vAttributeForce));
                _loc_5 = 1 - this.vCoefHeavyVsLight * (1 - _loc_5);
                if (_loc_5 < 0.2)
                {
                    _loc_5 = 0.2;
                }
                if (_loc_5 > 1.8)
                {
                    _loc_5 = 1.8;
                }
                return _loc_5;
            }
            return 1;
        }// end function

        private function convertAttribute(param1:int) : int
        {
            return 100 + 5 * param1;
        }// end function

        override public function compress(param1:Number, param2:Number) : void
        {
            vCompressAngle = param1;
            vCompressRatio = param2;
            vIsCompressed = true;
            if (this.vPerso == null)
            {
                return;
            }
            if (param2 < 0.1)
            {
                param2 = 0.1;
            }
            this.unCompress();
            this.vPerso.compress(param1, param2);
            return;
        }// end function

        override public function resetCompress() : void
        {
            vCompressAngle = 0;
            vCompressRatio = 1;
            return;
        }// end function

        override public function unCompress() : void
        {
            if (this.vPerso == null)
            {
                return;
            }
            this.vPerso.unCompress();
            return;
        }// end function

        public function getInstantPos() : String
        {
            var _loc_1:* = "";
            _loc_1 = _loc_1 + vPos.x + "," + vPos.y;
            _loc_1 = _loc_1 + ",";
            if (isKilled)
            {
                _loc_1 = _loc_1 + "1";
            }
            else
            {
                _loc_1 = _loc_1 + "0";
            }
            _loc_1 = _loc_1 + ",";
            if (this.vWounded)
            {
                _loc_1 = _loc_1 + "1";
            }
            else
            {
                _loc_1 = _loc_1 + "0";
            }
            _loc_1 = _loc_1 + ",";
            _loc_1 = _loc_1 + this.vHP;
            return _loc_1;
        }// end function

        public function setInstantPos(param1:String) : void
        {
            var _loc_2:* = param1.split(",");
            this.setPosInit(new Point(_loc_2[0], _loc_2[1]));
            if (_loc_2[2] == "1")
            {
                kill();
            }
            if (_loc_2[3] == "1")
            {
                this.vWounded = false;
                this.vHP = 0;
                this.checkWound();
            }
            this.vHP = _loc_2[4];
            this.refreshHP();
            return;
        }// end function

        public static function formatValue(param1:Number) : String
        {
            return Math.round(param1 * 100).toString();
        }// end function

        public static function unformatValue(param1:String) : Number
        {
            return parseInt(param1) / 100;
        }// end function

    }
}
