package gbl
{
    import flash.geom.*;

    public class Dyna extends Object
    {
        public var vId:int;
        public var vPos:Point;
        public var vSpeed:Point;
        public var vForce:Point;
        public var vRadius:Number;
        public var vMass:Number;
        public var vDamp:Number;
        public var vSpringLength:Number;
        public var vSpringStrength:Number;
        public var vSlideStrength:Number;
        public var vTunnelSpring:Number;
        public var vForceInput:Number;
        public var vSpeedMax:Number;
        public var vBounceCoef:Number;
        public var vRunning:Boolean = false;
        public var vCoefMass:Number = 1;
        public var vCoefInput:Number = 1;
        public var vCoefInitiative:Number = 1;
        public var isKilled:Boolean = false;
        private const lPi:Number;
        protected var vIsCompressed:Boolean = false;
        public var vCompressAngle:Number = 0;
        public var vCompressRatio:Number = 1;

        public function Dyna()
        {
            this.lPi = Math.round(1000 * 180 / Math.PI) / 1000;
            this.setRadius(17);
            this.vDamp = 0.2;
            if (GBL_Main.vWeatherCoef == 0)
            {
                this.vDamp = 0.2;
            }
            else if (GBL_Main.vWeatherCoef > 0)
            {
                if (GBL_Main.vWeatherCoef > 100)
                {
                    GBL_Main.vWeatherCoef = 100;
                }
                this.vDamp = 0.2 - 0.2 * GBL_Main.vWeatherCoef / 100;
            }
            else if (GBL_Main.vWeatherCoef < 0)
            {
                if (GBL_Main.vWeatherCoef < -100)
                {
                    GBL_Main.vWeatherCoef = -100;
                }
                this.vDamp = 0.2 - 0.8 * GBL_Main.vWeatherCoef / 100;
            }
            this.vForceInput = 80;
            this.vSpringStrength = 5;
            this.vSlideStrength = 0;
            this.vTunnelSpring = 100;
            this.vMass = 5;
            this.vSpeedMax = 20000;
            this.vBounceCoef = 1;
            this.vPos = new Point(0, 0);
            this.vSpeed = new Point(0, 0);
            this.vForce = new Point(0, 0);
            return;
        }// end function

        public function setRadius(param1:Number) : void
        {
            this.vRadius = param1;
            this.vSpringLength = 2 * this.vRadius;
            return;
        }// end function

        public function toString() : String
        {
            return "[Dyna vId=" + this.vId + "]";
        }// end function

        public function setAttributeForce(param1:int = 100) : void
        {
            param1 = 100 + 5 * param1;
            param1 = 100 + (param1 - 100) * 70 / 50;
            this.vCoefMass = param1 / 100;
            return;
        }// end function

        public function setAttributeSpeed(param1:int = 100) : void
        {
            param1 = 100 + 5 * param1;
            param1 = 90 + (param1 - 100) * 70 / 50;
            this.vCoefInput = param1 / 100;
            return;
        }// end function

        public function setAttributeVitality(param1:int = 100) : void
        {
            param1 = 100 + 5 * param1;
            this.vCoefInitiative = param1 / 100;
            return;
        }// end function

        public function setPos(param1:Number, param2:Number) : void
        {
            this.vPos.x = param1;
            this.vPos.y = param2;
            fround(this.vPos);
            return;
        }// end function

        public function doDamp(param1:Number, param2:Number = 1) : void
        {
            this.vSpeed.x = this.vSpeed.x * (1 - param2 * this.vDamp * param1);
            this.vSpeed.y = this.vSpeed.y * (1 - param2 * this.vDamp * param1);
            fround(this.vSpeed);
            return;
        }// end function

        public function update(param1:Number) : void
        {
            this.updateStart(param1);
            this.vSpeed.x = this.vSpeed.x + this.vForce.x / this.vMass;
            this.vSpeed.y = this.vSpeed.y + this.vForce.y / this.vMass;
            if (this.vSpeed.length > this.vSpeedMax)
            {
                this.vSpeed.normalize(this.vSpeedMax);
            }
            fround(this.vSpeed);
            this.vSpeed.x = this.vSpeed.x - 10 * this.vDamp * param1 * this.vSpeed.x;
            this.vSpeed.y = this.vSpeed.y - 10 * this.vDamp * param1 * this.vSpeed.y;
            fround(this.vSpeed);
            if (this.vSpeed.length < 1)
            {
                this.vSpeed.x = 0;
                this.vSpeed.y = 0;
            }
            this.vForce.x = 0;
            this.vForce.y = 0;
            this.vPos.x = this.vPos.x + this.vSpeed.x * param1;
            this.vPos.y = this.vPos.y + this.vSpeed.y * param1;
            fround(this.vPos);
            if (!this.vIsCompressed)
            {
                this.resetCompress();
                this.unCompress();
            }
            this.vIsCompressed = false;
            this.updateEnd(param1);
            this.refresh();
            return;
        }// end function

        protected function updateStart(param1:Number) : void
        {
            return;
        }// end function

        protected function updateEnd(param1:Number) : void
        {
            return;
        }// end function

        public function resetSpeed() : void
        {
            this.vSpeed.x = 0;
            this.vSpeed.y = 0;
            this.vForce.x = 0;
            this.vForce.y = 0;
            return;
        }// end function

        public function addForce(param1:Point, param2:Number = 1) : void
        {
            this.vForce.x = this.vForce.x + param2 * param1.x * this.vForceInput;
            this.vForce.y = this.vForce.y + param2 * param1.y * this.vForceInput;
            return;
        }// end function

        public function refresh() : void
        {
            return;
        }// end function

        public function onSolidCollision(param1:Dyna) : void
        {
            var _loc_4:* = null;
            var _loc_2:* = this;
            var _loc_3:* = Point.distance(_loc_2.vPos, param1.vPos) - (_loc_2.vRadius * _loc_2.vCoefMass + param1.vRadius * param1.vCoefMass);
            if (_loc_3 < 0)
            {
                _loc_4 = _loc_2.vPos.subtract(param1.vPos);
                _loc_4.normalize(-_loc_3);
                _loc_2.addForce(_loc_4, param1.vBounceCoef);
                param1.addForce(_loc_4, -_loc_2.vBounceCoef);
                _loc_2.isHit(_loc_4);
                param1.isHit(_loc_4);
            }
            return;
        }// end function

        public function onSmoothCollision(param1:Dyna) : Boolean
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            var _loc_11:* = NaN;
            var _loc_12:* = NaN;
            if (this.isKilled)
            {
                return false;
            }
            if (param1.isKilled)
            {
                return false;
            }
            var _loc_2:* = param1.vPos.x - this.vPos.x;
            var _loc_3:* = param1.vPos.y - this.vPos.y;
            var _loc_4:* = (this.vSpringLength * this.vCoefMass + param1.vSpringLength * param1.vCoefMass) / 2;
            var _loc_5:* = Math.sqrt(_loc_2 * _loc_2 + _loc_3 * _loc_3);
            if (Math.sqrt(_loc_2 * _loc_2 + _loc_3 * _loc_3) < _loc_4)
            {
                _loc_6 = this;
                _loc_7 = param1;
                _loc_8 = new Point(_loc_2, _loc_3);
                _loc_9 = (_loc_6.vSpringStrength + _loc_7.vSpringStrength) / 2;
                _loc_10 = this.getAngle(_loc_8.x, _loc_8.y);
                _loc_8.x = _loc_8.x * ((_loc_5 - _loc_4) * _loc_9 / _loc_5);
                _loc_8.y = _loc_8.y * ((_loc_5 - _loc_4) * _loc_9 / _loc_5);
                _loc_11 = _loc_7.vCoefMass - _loc_6.vCoefMass;
                Global.vGame.onImpact(_loc_6 as GBL_Glob, _loc_7 as GBL_Glob, _loc_8);
                _loc_6.addForce(_loc_8, (1 + _loc_11 * 0.5) * this.getKickCoef(_loc_7, _loc_6));
                _loc_7.addForce(_loc_8, (-1 + _loc_11 * 0.5) * this.getKickCoef(_loc_6, _loc_7));
                _loc_12 = _loc_5 / (_loc_6.vRadius * _loc_6.vCoefMass + _loc_7.vRadius * _loc_7.vCoefMass);
                _loc_6.compress(_loc_10, _loc_12);
                _loc_7.compress(_loc_10 + 180, _loc_12);
                return true;
            }
            return false;
        }// end function

        protected function getKickCoef(param1:Dyna, param2:Dyna) : Number
        {
            return 1;
        }// end function

        public function onTunnelCollision(param1:Number, param2:Number, param3:Number) : void
        {
            var _loc_7:* = NaN;
            var _loc_4:* = Math.sqrt(param1 * param1 + param2 * param2);
            if (param3 > this.vRadius * this.vCoefMass)
            {
                this.vPos.x = this.vPos.x + (param3 - this.vRadius * this.vCoefMass) * param1;
                this.vPos.y = this.vPos.y + (param3 - this.vRadius * this.vCoefMass) * param2;
                param3 = this.vRadius * this.vCoefMass;
            }
            if (Math.abs(param3) > 5)
            {
                if (Global.vGame != null)
                {
                    if (Global.vGame.vCompute != null)
                    {
                        _loc_7 = (Math.abs(param3) - 5) / 5;
                        if (_loc_7 < 0)
                        {
                            _loc_7 = 0;
                        }
                        else if (_loc_7 > 1)
                        {
                            _loc_7 = 1;
                        }
                        Global.vGame.vCompute.saveEvent("soundWall", {coef:_loc_7});
                    }
                }
            }
            this.vForce.x = this.vForce.x - param3 * param1 * this.vTunnelSpring;
            this.vForce.y = this.vForce.y - param3 * param2 * this.vTunnelSpring;
            this.doDamp(GBL_Main.vStepDt, 30);
            var _loc_5:* = (this.vRadius * this.vCoefMass - param3 / 2) / (this.vRadius * this.vCoefMass);
            if ((this.vRadius * this.vCoefMass - param3 / 2) / (this.vRadius * this.vCoefMass) < 0.1)
            {
                _loc_5 = 0.1;
            }
            if (_loc_5 > 1)
            {
                _loc_5 = 2 - _loc_5;
            }
            var _loc_6:* = this.getAngle(param1, param2);
            this.compress(_loc_6, _loc_5);
            return;
        }// end function

        public function isHit(param1:Point) : void
        {
            return;
        }// end function

        public function kill(param1:Boolean = false) : void
        {
            this.isKilled = true;
            this.isKillInside(param1);
            return;
        }// end function

        protected function isKillInside(param1:Boolean = false) : void
        {
            return;
        }// end function

        private function getAngle(param1:Number, param2:Number) : Number
        {
            return Math.atan2(param2, param1) * this.lPi;
        }// end function

        private function getAnglePi(param1:Number, param2:Number) : Number
        {
            return Math.atan2(param2, param1);
        }// end function

        public function compress(param1:Number, param2:Number) : void
        {
            this.vCompressAngle = param1;
            this.vCompressRatio = param2;
            return;
        }// end function

        public function resetCompress() : void
        {
            return;
        }// end function

        public function unCompress() : void
        {
            return;
        }// end function

        public static function fround(param1:Point) : void
        {
            param1.x = Math.round(100 * param1.x) / 100;
            param1.y = Math.round(100 * param1.y) / 100;
            return;
        }// end function

    }
}
