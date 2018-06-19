package globz
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class particleManager extends MovieClip
    {
        private var vParticlesList:Vector.<particles>;
        private var vActive:Boolean;
        private var vTimerDT:int;
        private var vFPS:Number;
        private var vRealFPS:Number;
        private var vFPSElastic:Number;
        private var vFPSCoef:Number;
        private var vFPSCoefElastic:Number;
        private var vCoef:Number = 1;
        private var vPause:Boolean;
        private var vTimersaved:int = 0;
        static var current:particleManager;

        public function particleManager() : void
        {
            this.vParticlesList = new Vector.<particles>;
            this.vActive = false;
            this.vFPS = 60;
            this.vRealFPS = 60;
            this.vFPSCoef = 1;
            this.vCoef = 1;
            this.vPause = false;
            return;
        }// end function

        final public function setParticlesCoef(param1:Number = 1) : void
        {
            this.vCoef = param1;
            return;
        }// end function

        final public function startParticles(param1:DisplayObjectContainer, param2, param3 = null, param4:int = 1, param5:int = 0, param6:int = 0, param7:int = 0, param8:Number = 0, param9 = true, param10:Number = 1, param11:Number = 0.5, param12:Number = 0, param13:Number = 0, param14:Number = 0, param15:Number = 0, param16:Number = 0, param17:Number = 0.98, param18:String = "normal", param19 = false, param20:Boolean = true) : particles
        {
            if (int(param4 * this.vCoef) == 0)
            {
                return null;
            }
            var _loc_21:* = new particles();
            this.vParticlesList[this.vParticlesList.length] = _loc_21;
            param1.addChild(_loc_21);
            _loc_21.startParticles(param1, param2, param3, param4 * this.vCoef, param5, param6 * this.vCoef, param7, param8, param9, param10, param11, param12, param13, param14, param15, param16, param17, param18, param19, param20);
            if (!this.vActive)
            {
                this.vActive = true;
                if (param1.stage)
                {
                    this.vFPS = param1.stage.frameRate;
                }
                this.vTimerDT = getTimer();
                this.addEventListener(Event.ENTER_FRAME, this.loop);
            }
            return _loc_21;
        }// end function

        final public function showParticles(param1:DisplayObjectContainer = null, param2 = null, param3 = null, param4:Number = 1, param5:int = -1, param6:Boolean = true, param7:Boolean = true, param8:Boolean = true, param9:Boolean = false, param10:Number = 1) : particles
        {
            param4 = param4 * this.vCoef;
            var _loc_11:* = 40 * param4;
            var _loc_12:* = 40 * param4;
            var _loc_13:* = 0;
            if (int(_loc_11 * 0.25) == 0)
            {
                return null;
            }
            var _loc_14:* = new particles();
            this.vParticlesList[this.vParticlesList.length] = _loc_14;
            param1.addChild(_loc_14);
            var _loc_15:* = 0;
            var _loc_16:* = 5 + 5 * param4;
            var _loc_17:* = -(5 + 5 * param4);
            if (param7)
            {
                if (param5 == 0)
                {
                    _loc_15 = 0.5;
                    _loc_16 = -(5 + 1 * param4);
                    _loc_17 = -(10 + 5 * param4);
                }
                else if (param5 == 1)
                {
                    _loc_15 = -0.5;
                    _loc_16 = 10 + 5 * param4;
                    _loc_17 = 5 + 1 * param4;
                }
            }
            var _loc_18:* = param8;
            if (param8 == false)
            {
                if (param5 == 0)
                {
                    _loc_18 = 0;
                }
                else if (param5 == 1)
                {
                    _loc_18 = 180;
                }
            }
            if (param9)
            {
                _loc_12 = -1;
                _loc_13 = 10 - 5 * this.vCoef;
            }
            if (param6)
            {
                _loc_14.startParticles(param1, param2, param3, _loc_11 * 0.25, _loc_13, _loc_12, 40 + 20 * param4, 0.5, true, 1, 0.25, _loc_15 * param10, (5 + 5 * param4) * param10, (-(5 + 5 * param4)) * param10, _loc_16 * param10, _loc_17 * param10, 0.98, "normal", _loc_18, false);
            }
            else
            {
                _loc_14.startParticles(param1, param2, param3, _loc_11 * 0.25, _loc_13, _loc_12, 50 + 30 * param4, 0.5, true, 1, 0.25, _loc_15 * 0.5 * param10, (5 + 5 * param4) * 0.5 * param10, (-(5 + 5 * param4)) * 0.5 * param10, _loc_16 * 0.5 * param10, _loc_17 * 0.5 * param10, 0.98, "normal", _loc_18, true);
            }
            if (!this.vActive)
            {
                this.vActive = true;
                if (param1.stage)
                {
                    this.vFPS = param1.stage.frameRate;
                }
                this.vTimerDT = getTimer();
                this.addEventListener(Event.ENTER_FRAME, this.loop);
            }
            return _loc_14;
        }// end function

        final public function destroy() : void
        {
            var _loc_1:* = 0;
            this.removeEventListener(Event.ENTER_FRAME, this.loop);
            this.vActive = false;
            if (this.vParticlesList && this.vParticlesList.length > 0)
            {
                _loc_1 = 0;
                while (_loc_1 < this.vParticlesList.length)
                {
                    
                    if (this.vParticlesList[_loc_1])
                    {
                        if (this.vParticlesList[_loc_1].vParent.contains(this.vParticlesList[_loc_1]))
                        {
                            this.vParticlesList[_loc_1].vParent.removeChild(this.vParticlesList[_loc_1]);
                        }
                        this.vParticlesList[_loc_1].destroy();
                        this.vParticlesList[_loc_1] = null;
                    }
                    _loc_1++;
                }
            }
            this.vParticlesList = new Vector.<particles>;
            return;
        }// end function

        public function stopParticles(param1:Boolean = true) : void
        {
            var _loc_2:* = 0;
            if (this.vParticlesList && this.vParticlesList.length > 0)
            {
                _loc_2 = 0;
                while (_loc_2 < this.vParticlesList.length)
                {
                    
                    if (this.vParticlesList[_loc_2])
                    {
                        this.vParticlesList[_loc_2].stopParticles(param1);
                    }
                    _loc_2++;
                }
            }
            return;
        }// end function

        final public function pause() : void
        {
            this.vPause = true;
            return;
        }// end function

        final public function resume() : void
        {
            this.vPause = false;
            return;
        }// end function

        final private function loop(event:Event) : void
        {
            var _loc_5:* = null;
            if (this.vPause)
            {
                return;
            }
            var _loc_2:* = 0;
            var _loc_3:* = getTimer();
            var _loc_4:* = (_loc_3 - this.vTimerDT) * 0.001;
            this.vFPSCoefElastic = (_loc_4 / (1 / this.vFPS) - this.vFPSCoef) * 0.5;
            this.vFPSCoef = this.vFPSCoef + this.vFPSCoefElastic;
            this.vFPSElastic = (this.vFPS / this.vFPSCoef - this.vRealFPS) * 0.1;
            this.vRealFPS = this.vRealFPS + this.vFPSElastic;
            this.vTimerDT = _loc_3;
            if (this.vParticlesList)
            {
                _loc_2 = 0;
                while (_loc_2 < this.vParticlesList.length)
                {
                    
                    _loc_5 = this.vParticlesList[_loc_2];
                    if (_loc_5 && _loc_5.vActive)
                    {
                        _loc_5.update(this.vFPSCoef, Math.round(this.vRealFPS) / this.vFPS);
                        _loc_2++;
                        continue;
                    }
                    if (_loc_5 && _loc_5.vParent)
                    {
                        if (_loc_5.vParent.contains(_loc_5))
                        {
                            _loc_5.vParent.removeChild(_loc_5);
                        }
                        _loc_5.destroy();
                    }
                    this.vParticlesList.splice(_loc_2, 1);
                }
            }
            if (this.vParticlesList == null || this.vParticlesList.length == 0)
            {
                this.vActive = false;
                this.removeEventListener(Event.ENTER_FRAME, this.loop);
            }
            return;
        }// end function

        public static function getInstance() : particleManager
        {
            if (current == null)
            {
                current = new particleManager;
            }
            return current;
        }// end function

    }
}
