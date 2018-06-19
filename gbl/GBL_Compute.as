package gbl
{
    import __AS3__.vec.*;
    import flash.geom.*;

    public class GBL_Compute extends Object
    {
        private var vGame:GBL_Main;
        private var vGlobs:Vector.<GBL_Glob>;
        private var vStep:int = 0;
        private var vMovie:Vector.<Object>;
        private var vEventsLastStep:Array;
        private var vReadEventStepDone:int = -1;
        public static var vStepDt:Number = 0.004;
        public static var vStepDamp:int = 105;
        public static var vStepTotal:int = 150;

        public function GBL_Compute(param1:GBL_Main, param2:Vector.<GBL_Glob>, param3:String)
        {
            var _loc_4:* = null;
            this.vGame = param1;
            this.vGlobs = new Vector.<GBL_Glob>;
            var _loc_5:* = 0;
            while (_loc_5 < param2.length)
            {
                
                _loc_4 = param2[_loc_5].clone();
                _loc_4.setGame(this.vGame);
                this.vGlobs.push(_loc_4);
                _loc_5++;
            }
            this.parseOrders(param3);
            this.computeRun();
            return;
        }// end function

        public function parseOrders(param1:String) : void
        {
            var _loc_4:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_2:* = param1.split("_");
            var _loc_3:* = param1.split("_");
            var _loc_5:* = new Point(0, 0);
            var _loc_6:* = 0;
            while (_loc_6 < _loc_2.length)
            {
                
                _loc_3 = _loc_2[_loc_6].split(",");
                if (_loc_3[0] == "extra")
                {
                    _loc_7 = 1;
                    while (_loc_7 < _loc_3.length)
                    {
                        
                        _loc_8 = _loc_3[_loc_7].split(":");
                        if (_loc_8[0] == "booster")
                        {
                            this.saveEvent("booster", {team:_loc_8[1], nul:_loc_8[2]});
                        }
                        _loc_7++;
                    }
                }
                else if (_loc_3[0] == "timer")
                {
                }
                else if (_loc_3[0] == "99")
                {
                }
                else
                {
                    _loc_4 = this.vGlobs[parseInt(_loc_3[0])];
                    _loc_5.x = GBL_Glob.unformatValue(_loc_3[1]);
                    _loc_5.y = GBL_Glob.unformatValue(_loc_3[2]);
                    _loc_4.addForce(_loc_5);
                }
                _loc_6++;
            }
            return;
        }// end function

        public function destroy() : void
        {
            this.vGame = null;
            this.vGlobs = null;
            this.vMovie = null;
            return;
        }// end function

        private function computeRun() : void
        {
            var _loc_1:* = 0;
            this.vGame.vCompute = this;
            _loc_1 = 0;
            while (_loc_1 < this.vGlobs.length)
            {
                
                this.vGlobs[_loc_1].vCanCollidePassive = false;
                if (this.vGlobs[_loc_1].vForce.length > 0)
                {
                    this.vGlobs[_loc_1].vCanCollidePassive = true;
                }
                _loc_1++;
            }
            this.vMovie = new Vector.<Object>;
            this.vStep = 0;
            var _loc_2:* = 0;
            this.saveStep();
            while (this.vStep < vStepTotal)
            {
                
                this.nextStep();
                this.saveStep();
                _loc_2 = this.vGame.vTerrain.getWinner(this.vGlobs);
                if (_loc_2 > 0)
                {
                    this.saveEventWinner(_loc_2);
                    this.vStep = vStepTotal;
                }
            }
            this.vGame.vCompute = null;
            return;
        }// end function

        private function nextStep() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            var _loc_3:* = false;
            var _loc_4:* = this;
            var _loc_5:* = this.vStep + 1;
            _loc_4.vStep = _loc_5;
            this.checkCollisions();
            _loc_1 = 0;
            while (_loc_1 < this.vGlobs.length)
            {
                
                _loc_2 = this.vGlobs[_loc_1];
                if (!_loc_2.isKilled)
                {
                    if (this.vStep > vStepDamp)
                    {
                        _loc_2.doDamp(vStepDt, 30);
                    }
                    _loc_2.beforeUpdate();
                    _loc_2.update(vStepDt);
                    _loc_2.afterUpdate();
                }
                else
                {
                    _loc_2.doDamp(vStepDt, 250);
                    _loc_2.update(vStepDt);
                }
                _loc_1++;
            }
            if (this.vStep == (vStepTotal - 1))
            {
                _loc_3 = false;
                _loc_1 = 0;
                while (_loc_1 < this.vGlobs.length)
                {
                    
                    if (this.vGame.vTerrain.checkWow(this.vGlobs[_loc_1]))
                    {
                        _loc_3 = true;
                    }
                    _loc_1++;
                }
                if (_loc_3)
                {
                    this.saveEvent("soundWow", {});
                }
            }
            return;
        }// end function

        private function checkCollisions() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            _loc_2 = 0;
            while (_loc_2 < this.vGlobs.length)
            {
                
                _loc_1 = this.vGlobs[_loc_2];
                if (_loc_1.vCanCollide && !_loc_1.isKilled)
                {
                    _loc_3 = _loc_2 + 1;
                    while (_loc_3 < this.vGlobs.length)
                    {
                        
                        if (this.vGlobs[_loc_3].vCanCollide)
                        {
                            if (_loc_1.vCanCollidePassive || this.vGlobs[_loc_3].vCanCollidePassive)
                            {
                                if (_loc_1.onSmoothCollision(this.vGlobs[_loc_3]))
                                {
                                    _loc_1.vCanCollidePassive = true;
                                    this.vGlobs[_loc_3].vCanCollidePassive = true;
                                }
                            }
                        }
                        _loc_3++;
                    }
                    if (_loc_1.vCanCollidePassive)
                    {
                        this.vGame.vTerrain.checkWalls(_loc_1);
                    }
                }
                _loc_2++;
            }
            return;
        }// end function

        private function saveStep() : void
        {
            var _loc_1:* = new Object();
            var _loc_2:* = new Vector.<Point>;
            var _loc_3:* = new Vector.<Number>;
            var _loc_4:* = new Vector.<Point>;
            var _loc_5:* = 0;
            while (_loc_5 < this.vGlobs.length)
            {
                
                _loc_2.push(this.vGlobs[_loc_5].vPos.clone());
                _loc_3.push(this.vGlobs[_loc_5].vCurOrientation - 90);
                _loc_4.push(new Point(this.vGlobs[_loc_5].vCompressAngle, this.vGlobs[_loc_5].vCompressRatio));
                _loc_5++;
            }
            _loc_1.pos = _loc_2;
            _loc_1.orientation = _loc_3;
            _loc_1.compress = _loc_4;
            _loc_1.events = this.vEventsLastStep;
            this.vEventsLastStep = null;
            this.vMovie.push(_loc_1);
            return;
        }// end function

        public function getPosAtPercentTime(param1:Number) : Object
        {
            var _loc_2:* = new Object();
            var _loc_3:* = Math.floor(param1 * vStepTotal);
            if (_loc_3 > (this.vMovie.length - 1))
            {
                _loc_3 = this.vMovie.length - 1;
            }
            if (++_loc_3 > vStepTotal)
            {
                ++_loc_3 = vStepTotal;
            }
            if (++_loc_3 > (this.vMovie.length - 1))
            {
                _loc_4 = this.vMovie.length - 1;
            }
            var _loc_5:* = param1 * vStepTotal - _loc_3;
            var _loc_6:* = 1 - _loc_5;
            var _loc_7:* = new Vector.<Point>;
            var _loc_8:* = new Vector.<int>;
            var _loc_9:* = new Vector.<Point>;
            var _loc_10:* = 0;
            while (_loc_10 < this.vGlobs.length)
            {
                
                _loc_7.push(new Point(this.vMovie[_loc_3].pos[_loc_10].x + _loc_5 * (this.vMovie[_loc_4].pos[_loc_10].x - this.vMovie[_loc_3].pos[_loc_10].x), this.vMovie[_loc_3].pos[_loc_10].y + _loc_5 * (this.vMovie[_loc_4].pos[_loc_10].y - this.vMovie[_loc_3].pos[_loc_10].y)));
                _loc_8.push(this.vMovie[_loc_3].orientation[_loc_10]);
                _loc_9.push(new Point(this.vMovie[_loc_3].compress[_loc_10].x, this.vMovie[_loc_3].compress[_loc_10].y + _loc_5 * (this.vMovie[_loc_4].compress[_loc_10].y - this.vMovie[_loc_3].compress[_loc_10].y)));
                _loc_10++;
            }
            _loc_2.pos = _loc_7;
            _loc_2.orientation = _loc_8;
            _loc_2.compress = _loc_9;
            return _loc_2;
        }// end function

        private function percentAngle(param1:Number, param2:Number, param3:Number) : Number
        {
            var _loc_4:* = NaN;
            if (param1 > param2)
            {
                _loc_4 = param1;
                param1 = param2;
                param2 = _loc_4;
                param3 = 1 - param3;
            }
            while (param1 < 0)
            {
                
                param1 = param1 + 360;
            }
            while (param2 < 0)
            {
                
                param2 = param2 + 360;
            }
            _loc_4 = param1 + (param2 - param1) * param3;
            while (_loc_4 >= 180)
            {
                
                _loc_4 = _loc_4 - 360;
            }
            return _loc_4;
        }// end function

        public function initResolution() : void
        {
            this.vReadEventStepDone = -1;
            return;
        }// end function

        public function saveEvent(param1:String, param2:Object) : void
        {
            var _loc_3:* = new Object();
            _loc_3.type = param1;
            _loc_3.step = this.vStep;
            _loc_3.args = param2;
            if (this.vEventsLastStep == null)
            {
                this.vEventsLastStep = new Array();
            }
            this.vEventsLastStep.push(_loc_3);
            return;
        }// end function

        public function saveEventWinner(param1:int) : void
        {
            var _loc_2:* = this;
            var _loc_3:* = this.vStep + 1;
            _loc_2.vStep = _loc_3;
            this.saveEvent("winner", {winner:param1});
            this.saveStep();
            return;
        }// end function

        public function getEvents(param1:Number) : Array
        {
            var _loc_6:* = 0;
            if (this.vMovie == null)
            {
                return new Array();
            }
            var _loc_2:* = Math.floor(param1 * vStepTotal);
            if (_loc_2 > (this.vMovie.length - 1))
            {
                _loc_2 = this.vMovie.length - 1;
            }
            var _loc_3:* = _loc_2 + 1;
            if (_loc_3 > vStepTotal)
            {
                _loc_3 = vStepTotal;
            }
            if (_loc_3 > this.vMovie.length)
            {
                _loc_3 = this.vMovie.length;
            }
            var _loc_4:* = new Array();
            var _loc_5:* = this.vReadEventStepDone + 1;
            while (_loc_5 < _loc_3)
            {
                
                if (this.vMovie[_loc_5].events != null)
                {
                    _loc_6 = 0;
                    while (_loc_6 < this.vMovie[_loc_5].events.length)
                    {
                        
                        _loc_4.push(this.vMovie[_loc_5].events[_loc_6]);
                        _loc_6++;
                    }
                }
                _loc_5++;
            }
            this.vReadEventStepDone = _loc_2;
            return _loc_4;
        }// end function

    }
}
