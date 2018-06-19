package gbl
{
    import __AS3__.vec.*;
    import flash.geom.*;

    public class GBL_Bot extends Object
    {
        private var vType:int;
        private var vSkill:int;
        private var vGame:GBL_Main;
        private var vGlobs:Vector.<GBL_Glob>;
        private var vTeam:int = 2;
        public var vFirstShootCoef:Number = 0.7;
        public var vBall:GBL_Glob;
        public var vSpecificDone:Object;
        private var vCantGoCount:int;
        public static const TYPE_TUTORIAL:int = 1;
        public static const TYPE_TRAINER:int = 2;
        public static const TYPE_BOT:int = 3;
        public static const TYPE_FAKE:int = 4;
        public static var vTrophyLimit:int = 200;

        public function GBL_Bot(param1:int, param2:int = 1)
        {
            this.vType = param1;
            this.vSkill = param2;
            return;
        }// end function

        public function getOrders(param1:GBL_Main) : String
        {
            var i:int;
            var lNbCount:int;
            var lCompute:GBL_Compute;
            var lCanGo:Boolean;
            var lCount:int;
            var lOrder:String;
            var lGlobs:Vector.<GBL_Glob>;
            var t:Array;
            var j:int;
            var pGame:* = param1;
            this.vGame = pGame;
            try
            {
                if (this.vGame.vNbRound == this.vGame.vLastRoundRestarted)
                {
                    return this.getEngagement();
                }
                this.vGlobs = new Vector.<GBL_Glob>;
                i;
                while (i < this.vGame.vTerrain.vGlobs.length)
                {
                    
                    this.vGlobs.push(this.vGame.vTerrain.vGlobs[i]);
                    i = (i + 1);
                }
                i;
                while (i < this.vGlobs.length)
                {
                    
                    if (this.vGlobs[i].vTeam == 3)
                    {
                        this.vBall = this.vGlobs[i];
                    }
                    i = (i + 1);
                }
                if (this.vBall == null)
                {
                    return "";
                }
                lNbCount;
                this.vCantGoCount = 0;
                lCount;
                while (lCount <= lNbCount)
                {
                    
                    this.calcOrders();
                    lCanGo;
                    lOrder;
                    i;
                    while (i < this.vGlobs.length)
                    {
                        
                        if (this.vGlobs[i].vTeam == this.vTeam)
                        {
                            if (lOrder != "")
                            {
                                lOrder = lOrder + "_";
                            }
                            lOrder = lOrder + this.vGlobs[i].vId + "," + this.vGlobs[i].getOrder();
                        }
                        i = (i + 1);
                    }
                    lGlobs = new Vector.<GBL_Glob>;
                    i;
                    while (i < this.vGlobs.length)
                    {
                        
                        lGlobs.push(this.vGlobs[i]);
                        i = (i + 1);
                    }
                    lCompute = new GBL_Compute(this.vGame, lGlobs, lOrder);
                    t = lCompute.getEvents(1);
                    j;
                    while (j < t.length)
                    {
                        
                        if (t[j].type == "winner" && t[j].args != null && t[j].args.winner == 1)
                        {
                            lCanGo;
                            var _loc_3:* = this;
                            var _loc_4:* = this.vCantGoCount + 1;
                            _loc_3.vCantGoCount = _loc_4;
                        }
                        j = (j + 1);
                    }
                    if (lCanGo)
                    {
                        lCount = lNbCount;
                    }
                    lCount = (lCount + 1);
                }
                return lOrder;
            }
            catch (e:Error)
            {
                Global.addLogTrace("Error during getOrders:" + e, "GBL_Bot");
                Global.addLogTrace("InstantReplay=" + vGame.getInstantReplayDesc(), "GBL_Bot");
            }
            return "3,0,0_4,0,0_5,0,0";
        }// end function

        public function calcOrders() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = new Array();
            this.vSpecificDone = {};
            _loc_1 = 0;
            while (_loc_1 < this.vGlobs.length)
            {
                
                if (this.vGlobs[_loc_1].vTeam == this.vTeam)
                {
                    _loc_4.push(this.vGlobs[_loc_1]);
                }
                _loc_1++;
            }
            _loc_4.sort(this.sortOnDistToBall);
            var _loc_5:* = 0;
            _loc_1 = 0;
            while (_loc_1 < _loc_4.length)
            {
                
                _loc_2 = _loc_4[_loc_1];
                if (_loc_2.vTeam == this.vTeam)
                {
                    if (_loc_2.canPlay())
                    {
                        _loc_5++;
                        _loc_3 = this.getSpecificOrder(_loc_2, _loc_5);
                        this.addSkillRandom(_loc_3);
                        if (this.vGame.vInterface.vScore2 == 1)
                        {
                            _loc_3.order.normalize(_loc_3.order.length * 0.85);
                        }
                        _loc_2.setArrowOrder(_loc_3.order);
                    }
                }
                _loc_1++;
            }
            return;
        }// end function

        private function addSkillRandom(param1:Object) : void
        {
            if (this.vSkill == 5)
            {
                return;
            }
            var _loc_2:* = (5 - this.vSkill) * 0.05;
            param1.order.x = param1.order.x + param1.order.x * _loc_2 * (Math.random() - 0.5);
            param1.order.y = param1.order.y + param1.order.y * _loc_2 * (Math.random() - 0.5);
            if (this.vSkill == 1)
            {
                param1.order.x = param1.order.x * 0.85;
                param1.order.y = param1.order.y * 0.85;
            }
            else if (this.vSkill == 2)
            {
                param1.order.x = param1.order.x * 0.93;
                param1.order.y = param1.order.y * 0.93;
            }
            return;
        }// end function

        private function sortOnDistToBall(param1:GBL_Glob, param2:GBL_Glob) : int
        {
            if (Point.distance(param1.vPos, this.vBall.vPos) < Point.distance(param2.vPos, this.vBall.vPos))
            {
                return -1;
            }
            if (Point.distance(param1.vPos, this.vBall.vPos) > Point.distance(param2.vPos, this.vBall.vPos))
            {
                return 1;
            }
            return 0;
        }// end function

        private function getSpecificOrder(param1:GBL_Glob, param2:int) : Object
        {
            var _loc_4:* = null;
            var _loc_6:* = null;
            var _loc_7:* = false;
            var _loc_8:* = false;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            var _loc_3:* = new Object();
            if (this.vType == TYPE_TUTORIAL)
            {
                if (param1.vPos.y < this.vBall.vPos.y - 20)
                {
                    _loc_4 = this.getArrowShoot(param1);
                    _loc_3.order = _loc_4;
                    _loc_3.type = "tuto";
                }
                else
                {
                    _loc_4 = new Point(300 * (Math.random() - 0.5), -350 - 100 * Math.random());
                    _loc_3.order = this.getArrowTo(param1, _loc_4);
                    _loc_3.type = "tuto";
                }
            }
            else if (this.vType == TYPE_BOT || this.vType == TYPE_TRAINER)
            {
                if (param1.vPos.y < this.vBall.vPos.y - 20)
                {
                    _loc_3.order = this.getArrowShoot(param1);
                    _loc_3.type = "bot_shoot";
                }
                else
                {
                    _loc_4 = new Point(0, 0);
                    _loc_4.x = this.vBall.vPos.x / 2 + 600 * (Math.random() - 0.5);
                    _loc_4.y = (this.vBall.vPos.y - 380) / 2;
                    _loc_3.order = this.getArrowTo(param1, _loc_4);
                    _loc_3.type = "bot_repos";
                }
            }
            else if (this.vType == TYPE_FAKE)
            {
                _loc_6 = this.getKillTarget(param1);
                if (this.vSkill == 1)
                {
                    _loc_6 = null;
                }
                if (_loc_6 != null)
                {
                    if (this.vSpecificDone.killAttempt == true || this.nearestGlobCanKill(param1, _loc_6))
                    {
                        _loc_6 = null;
                    }
                    else if (param1.vPos.y < this.vBall.vPos.y)
                    {
                        if (Point.distance(param1.vPos, this.vBall.vPos) < Point.distance(_loc_6.vPos, this.vBall.vPos))
                        {
                            _loc_6 = null;
                        }
                    }
                }
                if (_loc_6 != null && this.vSpecificDone.killAttempt != true)
                {
                    this.vSpecificDone.killAttempt = true;
                    _loc_3.order = this.killAttempt(param1, _loc_6);
                    _loc_3.type = "fake_killattempt";
                }
                else if (Math.abs(this.vBall.vPos.y) > 300 && this.vBall.vPos.length > 300)
                {
                    _loc_4 = new Point(0, 0);
                    _loc_7 = true;
                    if (this.vSpecificDone.corner == true)
                    {
                        _loc_7 = false;
                    }
                    if (this.vCantGoCount > 0)
                    {
                        if (this.vSkill > 2 && this.vCantGoCount >= param2)
                        {
                            _loc_7 = false;
                        }
                    }
                    if (!_loc_7)
                    {
                        if (this.vBall.vPos.y < 0)
                        {
                            _loc_4.x = this.vBall.vPos.x * (0.25 + 0.5 * Math.random());
                            _loc_4.y = -300 - 50 * Math.random();
                        }
                        else
                        {
                            _loc_4.x = this.vBall.vPos.x * (-0.25 + 1.5 * Math.random());
                            _loc_4.y = -50 + 200 * Math.random();
                        }
                        _loc_3.order = this.getArrowTo(param1, _loc_4);
                        _loc_3.type = "fake_cornerdef";
                    }
                    else
                    {
                        this.vSpecificDone.corner = true;
                        _loc_4.x = param1.vPos.x + 75 * (this.vBall.vPos.x - param1.vPos.x);
                        _loc_4.y = param1.vPos.y + 85 * (this.vBall.vPos.y - param1.vPos.y);
                        _loc_3.order = _loc_4;
                        _loc_3.type = "fake_cornerfull";
                    }
                }
                else if (param1.vPos.y < this.vBall.vPos.y + 5)
                {
                    _loc_8 = true;
                    if (this.vSpecificDone.shoot == true)
                    {
                        _loc_8 = false;
                    }
                    _loc_9 = Point.distance(param1.vPos, this.vBall.vPos);
                    if (this.vSkill > 2 && _loc_9 > 300 && this.getMinDist(1, this.vBall.vPos) < _loc_9 * 0.65)
                    {
                        _loc_8 = false;
                    }
                    if (_loc_8)
                    {
                        this.vSpecificDone.shoot = true;
                        _loc_3.order = this.getArrowShoot(param1);
                        _loc_3.type = "fake_shoot";
                    }
                    else
                    {
                        _loc_10 = Math.random();
                        if (this.vSkill <= 3)
                        {
                            _loc_10 = 0.8;
                        }
                        if (_loc_10 < 0.45)
                        {
                            _loc_4 = new Point(0, 0);
                            _loc_4.x = this.vBall.vPos.x / 2 + 400 * (Math.random() - 0.5);
                            _loc_4.y = (this.vBall.vPos.y - 380) / 2;
                            if (this.vBall.vPos.y > 0)
                            {
                                _loc_4.y = _loc_4.y + this.vBall.vPos.y * Math.random();
                                if (_loc_4.y < -400)
                                {
                                    _loc_4.y = -400;
                                }
                                else if (_loc_4.y > this.vBall.vPos.y)
                                {
                                    _loc_4.y = this.vBall.vPos.y - 500 * Math.random();
                                }
                            }
                            _loc_3.order = this.getArrowTo(param1, _loc_4);
                            _loc_3.type = "fake_defmove";
                        }
                        else if (_loc_10 < 0.7)
                        {
                            if (param1.vPos.x > 0)
                            {
                                _loc_3.order = new Point(100 + 200 * Math.random(), 200 * (Math.random() - 0.5));
                            }
                            else
                            {
                                _loc_3.order = new Point(-100 - 200 * Math.random(), 200 * (Math.random() - 0.5));
                            }
                            _loc_3.type = "fake_altsidemove";
                        }
                        else
                        {
                            _loc_3.order = this.getArrowShoot(param1, this.vBall.vPos);
                            _loc_3.order.y = _loc_3.order.y - 100 * Math.random();
                            if (_loc_3.order.y <= 10)
                            {
                                _loc_3.order.y = 50 * Math.random();
                            }
                            _loc_3.type = "fake_supportshoot";
                            if (Math.random() < 0.6)
                            {
                                _loc_3.order.normalize(param1.getArrowMax() * (0.3 + Math.random() * 0.5));
                                _loc_3.type = "fake_supportshoothalf";
                            }
                        }
                    }
                }
                else
                {
                    _loc_4 = new Point(0, 0);
                    if (this.vBall.vPos.x > 175)
                    {
                        _loc_4.x = 200 * Math.random();
                    }
                    else if (this.vBall.vPos.x < -175)
                    {
                        _loc_4.x = -200 * Math.random();
                    }
                    else
                    {
                        _loc_4.x = this.vBall.vPos.x / 2 + 800 * (Math.random() - 0.5);
                    }
                    _loc_4.y = (this.vBall.vPos.y - 380) / 2;
                    _loc_3.order = this.getArrowTo(param1, _loc_4);
                    _loc_3.type = "fake_repos";
                }
            }
            else
            {
                _loc_3.order = new Point(0, 0);
                _loc_3.type = "type_null";
            }
            var _loc_5:* = 1;
            if (this.vType == TYPE_TUTORIAL)
            {
                _loc_5 = 0.65;
            }
            else if (this.vType == TYPE_FAKE)
            {
                if (this.vSkill == 1)
                {
                    _loc_5 = 0.7;
                }
                else if (this.vSkill == 2)
                {
                    _loc_5 = 0.8;
                }
                else if (this.vSkill == 3)
                {
                    _loc_5 = 0.9;
                }
            }
            if (_loc_3.order.length > param1.getArrowMax() * _loc_5)
            {
                _loc_3.order.normalize(param1.getArrowMax() * _loc_5);
            }
            return _loc_3;
        }// end function

        private function getMinDist(param1:int, param2:Point) : Number
        {
            var _loc_3:* = null;
            var _loc_6:* = NaN;
            var _loc_4:* = 1000000;
            var _loc_5:* = 0;
            while (_loc_5 < this.vGlobs.length)
            {
                
                _loc_3 = this.vGlobs[_loc_5];
                if (_loc_3.canPlay())
                {
                    _loc_6 = Point.distance(_loc_3.vPos, param2);
                    if (_loc_6 < _loc_4)
                    {
                        _loc_4 = _loc_6;
                    }
                }
                _loc_5++;
            }
            return _loc_6;
        }// end function

        private function getArrowTo(param1:GBL_Glob, param2:Point) : Point
        {
            var _loc_5:* = 0;
            var _loc_3:* = new Point(0, 0);
            _loc_3.x = param2.x - param1.vPos.x;
            _loc_3.y = param2.y - param1.vPos.y;
            var _loc_4:* = 465 + 35 * param1.vAttributeSpeed;
            if (_loc_3.length > _loc_4)
            {
                return _loc_3;
            }
            _loc_5 = param1.getArrowMax();
            if (_loc_4 == 0)
            {
                _loc_3.normalize(0);
            }
            else
            {
                _loc_3.normalize(_loc_5 * _loc_3.length / _loc_4);
            }
            return _loc_3;
        }// end function

        private function getArrowShoot(param1:GBL_Glob, param2:Point = null) : Point
        {
            var _loc_10:* = NaN;
            var _loc_11:* = NaN;
            if (param2 == null)
            {
                param2 = new Point();
            }
            var _loc_3:* = new Point(0, 0);
            _loc_3.x = this.vBall.vPos.x + param2.x - param1.vPos.x;
            _loc_3.y = this.vBall.vPos.y + param2.y - param1.vPos.y;
            var _loc_4:* = param1.getArrowMax();
            _loc_3.normalize(param1.getArrowMax());
            var _loc_5:* = this.vBall.vPos.x + param2.x - param1.vPos.x;
            var _loc_6:* = this.vBall.vPos.y + param2.y - param1.vPos.y;
            if (this.vBall.vPos.y + param2.y - param1.vPos.y == 0)
            {
                _loc_6 = 1;
            }
            var _loc_7:* = (300 - this.vBall.vPos.y - param2.y) / _loc_6;
            var _loc_8:* = _loc_5 * _loc_7 / 3;
            var _loc_9:* = 10;
            if (_loc_8 > _loc_9)
            {
                _loc_8 = _loc_9;
            }
            else if (_loc_8 < -_loc_9)
            {
                _loc_8 = -_loc_9;
            }
            if (this.vBall.vPos.x + param2.x > 80)
            {
                _loc_8 = Math.abs(_loc_8);
            }
            else if (this.vBall.vPos.x + param2.x < -80)
            {
                _loc_8 = -Math.abs(_loc_8);
            }
            if (param1.vPos.y < this.vBall.vPos.y)
            {
                if (param1.vPos.y < this.vBall.vPos.y)
                {
                    _loc_10 = Point.distance(this.vBall.vPos, param1.vPos);
                    if (_loc_10 == 0)
                    {
                        _loc_10 = 1;
                    }
                    _loc_11 = (this.vBall.vPos.x - param1.vPos.x) / _loc_10;
                    if (_loc_11 < -0.95)
                    {
                        return new Point(-10000, (1 + _loc_11) * 45000);
                    }
                    if (_loc_11 > 0.95)
                    {
                        return new Point(10000, (1 - _loc_11) * 45000);
                    }
                }
            }
            _loc_3.x = _loc_3.x + _loc_8;
            return _loc_3;
        }// end function

        private function getEngagement() : String
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_1:* = new Array();
            if (this.vType == TYPE_TUTORIAL)
            {
                _loc_10 = "0,-573,-8982_1,1389,-8892_2,-214,-8997";
                _loc_3 = _loc_10.split("_");
                _loc_10 = "";
                _loc_9 = 0;
                while (_loc_9 < _loc_3.length)
                {
                    
                    _loc_4 = _loc_3[_loc_9].split(",");
                    if (_loc_9 > 0)
                    {
                        _loc_10 = _loc_10 + "_";
                    }
                    _loc_10 = _loc_10 + _loc_4[0].toString();
                    _loc_7 = 1;
                    while (_loc_7 < _loc_4.length)
                    {
                        
                        _loc_10 = _loc_10 + ",";
                        _loc_10 = _loc_10 + Math.round(this.vFirstShootCoef * _loc_4[_loc_7]).toString();
                        _loc_7++;
                    }
                    _loc_9++;
                }
                _loc_1.push(_loc_10);
            }
            else if (this.vType == TYPE_TRAINER || this.vType == TYPE_BOT || this.vType == TYPE_FAKE)
            {
                _loc_1.push("0,184,-8998_1,2199,-8623_2,-1478,-7781");
                _loc_1.push("0,-154,-8999_1,1385,-4692_2,-1092,-7330");
                _loc_1.push("0,498,-7735_1,456,-4579_2,-871,-4825");
                _loc_1.push("0,-217,-8997_1,1848,-5591_2,-2309,-8699");
                _loc_1.push("0,-80,-4848_1,556,-4601_2,-432,-5249");
                _loc_1.push("0,-148,-8999_1,1474,-10295_2,-1430,-8886");
            }
            if (this.vType == TYPE_FAKE)
            {
                if (this.vSkill == 1)
                {
                    _loc_1.length = 2;
                }
                else if (this.vSkill == 2)
                {
                    _loc_1.length = 3;
                }
                else if (this.vSkill == 3)
                {
                    _loc_1.length = 3;
                }
                else if (this.vSkill == 4)
                {
                    _loc_1.length = 4;
                }
            }
            var _loc_2:* = _loc_1[Math.floor(Math.random() * _loc_1.length)];
            _loc_3 = _loc_2.split("_");
            var _loc_8:* = "";
            _loc_9 = 0;
            while (_loc_9 < _loc_3.length)
            {
                
                _loc_5 = _loc_3[_loc_9].split(",");
                if (_loc_9 > 0)
                {
                    _loc_8 = _loc_8 + "_";
                }
                _loc_6 = parseInt(_loc_5[0]) + 3;
                _loc_8 = _loc_8 + _loc_6.toString();
                _loc_7 = 1;
                while (_loc_7 <= 2)
                {
                    
                    _loc_8 = _loc_8 + ",";
                    _loc_6 = -parseInt(_loc_5[_loc_7]) + 50 * (Math.random() - 0.5);
                    if (_loc_9 == 0 && _loc_7 == 1)
                    {
                        if (Math.random() < 0.5)
                        {
                            _loc_6 = -_loc_6;
                        }
                    }
                    _loc_8 = _loc_8 + _loc_6.toString();
                    _loc_7++;
                }
                _loc_9++;
            }
            return _loc_8;
        }// end function

        public function getKillTarget(param1:GBL_Glob) : GBL_Glob
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            _loc_2 = 0;
            while (_loc_2 < this.vGlobs.length)
            {
                
                _loc_3 = this.vGlobs[_loc_2];
                if (_loc_3.vTeam == 1 && _loc_3.vWounded)
                {
                    if (Point.distance(new Point(0, 250), _loc_3.vPos) < 140)
                    {
                        if (param1.vPos.y < _loc_3.vPos.y - 50 && param1.vPos.y > 0)
                        {
                            return _loc_3;
                        }
                    }
                    if (Point.distance(new Point(0, -250), _loc_3.vPos) < 140)
                    {
                        if (param1.vPos.y > _loc_3.vPos.y + 50 && param1.vPos.y < 0)
                        {
                            return _loc_3;
                        }
                    }
                }
                _loc_2++;
            }
            return null;
        }// end function

        public function killAttempt(param1:GBL_Glob, param2:GBL_Glob) : Point
        {
            var _loc_3:* = new Point(0, 0);
            _loc_3.x = param2.vPos.x + (-param1.vPos.x);
            _loc_3.y = param2.vPos.y + (-param1.vPos.y);
            var _loc_4:* = param1.getArrowMax();
            _loc_3.normalize(param1.getArrowMax());
            var _loc_5:* = param2.vPos.x + (-param1.vPos.x);
            var _loc_6:* = param2.vPos.y - param1.vPos.y;
            if (param2.vPos.y - param1.vPos.y == 0)
            {
                _loc_6 = 1;
            }
            var _loc_7:* = (400 - param2.vPos.y) / _loc_6;
            var _loc_8:* = _loc_5 * _loc_7 / 3;
            var _loc_9:* = 5;
            if (_loc_8 > _loc_9)
            {
                _loc_8 = _loc_9;
            }
            else if (_loc_8 < -_loc_9)
            {
                _loc_8 = -_loc_9;
            }
            _loc_3.x = _loc_3.x + _loc_8;
            return _loc_3;
        }// end function

        public function nearestGlobCanKill(param1:GBL_Glob, param2:GBL_Glob) : Boolean
        {
            var _loc_4:* = null;
            var _loc_3:* = 0;
            while (_loc_3 < this.vGlobs.length)
            {
                
                _loc_4 = this.vGlobs[_loc_3];
                if (_loc_4.vTeam == 2 && !_loc_4.vWounded && _loc_4 != param1)
                {
                    if (Point.distance(param1.vPos, param2.vPos) > Point.distance(_loc_4.vPos, param2.vPos))
                    {
                        return true;
                    }
                }
                _loc_3++;
            }
            return false;
        }// end function

    }
}
