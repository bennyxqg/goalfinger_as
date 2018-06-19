package globz
{
    import com.greensock.*;
    import com.greensock.easing.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;

    public class Toolz extends Object
    {
        public static var vSeed:Number = -1;
        private static var vChrono:int;

        public function Toolz()
        {
            return;
        }// end function

        public function randomInt(param1:Number, param2:Number) : Number
        {
            return param1 + Math.random() * (param2 - param1);
        }// end function

        public static function shuffleTab(param1:Array) : Array
        {
            var _loc_3:* = 0;
            var _loc_2:* = new Array();
            while (param1.length > 0)
            {
                
                _loc_3 = Math.floor(param1.length * Toolz.random());
                _loc_2.push(param1[_loc_3]);
                param1.splice(_loc_3, 1);
            }
            return _loc_2;
        }// end function

        public static function setSeed(param1:Number) : void
        {
            vSeed = param1;
            return;
        }// end function

        public static function random() : Number
        {
            if (vSeed == -1)
            {
                vSeed = Math.round(1000000 * Math.random());
            }
            vSeed = (vSeed * 9301 + 49297) % 233280;
            return Math.abs(vSeed / 233280);
        }// end function

        public static function limitAngle(param1:Number) : Number
        {
            while (param1 <= -180)
            {
                
                param1 = param1 + 360;
            }
            while (param1 > 180)
            {
                
                param1 = param1 - 360;
            }
            return param1;
        }// end function

        public static function diffAngle(param1:Number, param2:Number) : Number
        {
            var _loc_3:* = param2 - param1;
            while (_loc_3 <= -180)
            {
                
                _loc_3 = _loc_3 + 360;
            }
            while (_loc_3 > 180)
            {
                
                _loc_3 = _loc_3 - 360;
            }
            return _loc_3;
        }// end function

        public static function diffAngleRadian(param1:Number, param2:Number) : Number
        {
            var _loc_3:* = param2 - param1;
            while (_loc_3 <= Math.PI)
            {
                
                _loc_3 = _loc_3 + 2 * Math.PI;
            }
            while (_loc_3 > Math.PI)
            {
                
                _loc_3 = _loc_3 - 2 * Math.PI;
            }
            return _loc_3;
        }// end function

        public static function smoothRotation(param1:DisplayObject, param2:Number, param3:Number = 5) : void
        {
            if (param3 == 0)
            {
                return;
            }
            if (param2 > param1.rotation + 180)
            {
                param2 = param2 - 360;
            }
            if (param2 < param1.rotation - 180)
            {
                param2 = param2 + 360;
            }
            param1.rotation = param1.rotation + (param2 - param1.rotation) / param3;
            return;
        }// end function

        public static function trim(param1:String) : String
        {
            var _loc_2:* = 0;
            while (param1.charCodeAt(_loc_2) < 33)
            {
                
                _loc_2++;
            }
            if (_loc_2 == param1.length)
            {
                return "";
            }
            var _loc_3:* = param1.length - 1;
            while (param1.charCodeAt(_loc_3) < 33)
            {
                
                _loc_3 = _loc_3 - 1;
            }
            return param1.substring(_loc_2, (_loc_3 + 1));
        }// end function

        public static function lineIntersectLine(param1:Point, param2:Point, param3:Point, param4:Point, param5:Boolean = true) : Point
        {
            var _loc_6:* = null;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            var _loc_11:* = NaN;
            var _loc_12:* = NaN;
            _loc_7 = param2.y - param1.y;
            _loc_9 = param1.x - param2.x;
            _loc_11 = param2.x * param1.y - param1.x * param2.y;
            _loc_8 = param4.y - param3.y;
            _loc_10 = param3.x - param4.x;
            _loc_12 = param4.x * param3.y - param3.x * param4.y;
            var _loc_13:* = _loc_7 * _loc_10 - _loc_8 * _loc_9;
            if (_loc_7 * _loc_10 - _loc_8 * _loc_9 == 0)
            {
                return null;
            }
            _loc_6 = new Point();
            _loc_6.x = (_loc_9 * _loc_12 - _loc_10 * _loc_11) / _loc_13;
            _loc_6.y = (_loc_8 * _loc_11 - _loc_7 * _loc_12) / _loc_13;
            if (param5)
            {
                if (Math.pow(_loc_6.x - param2.x, 2) + Math.pow(_loc_6.y - param2.y, 2) > Math.pow(param1.x - param2.x, 2) + Math.pow(param1.y - param2.y, 2))
                {
                    return null;
                }
                if (Math.pow(_loc_6.x - param1.x, 2) + Math.pow(_loc_6.y - param1.y, 2) > Math.pow(param1.x - param2.x, 2) + Math.pow(param1.y - param2.y, 2))
                {
                    return null;
                }
                if (Math.pow(_loc_6.x - param4.x, 2) + Math.pow(_loc_6.y - param4.y, 2) > Math.pow(param3.x - param4.x, 2) + Math.pow(param3.y - param4.y, 2))
                {
                    return null;
                }
                if (Math.pow(_loc_6.x - param3.x, 2) + Math.pow(_loc_6.y - param3.y, 2) > Math.pow(param3.x - param4.x, 2) + Math.pow(param3.y - param4.y, 2))
                {
                    return null;
                }
            }
            return _loc_6;
        }// end function

        public static function roundPositions(param1:DisplayObjectContainer) : void
        {
            var _loc_3:* = null;
            if (!(param1 is Stage))
            {
                param1.x = Math.round(param1.x);
                param1.y = Math.round(param1.y);
            }
            var _loc_2:* = 0;
            while (_loc_2 < param1.numChildren)
            {
                
                _loc_3 = param1.getChildAt(_loc_2);
                if (_loc_3 is DisplayObjectContainer)
                {
                    roundPositions(_loc_3 as DisplayObjectContainer);
                }
                else
                {
                    _loc_3.x = Math.round(_loc_3.x);
                    _loc_3.y = Math.round(_loc_3.y);
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        public static function isValidEmail(param1:String) : Boolean
        {
            var _loc_2:* = /([a-z0-9._-]+?)@([a-z0-9.-]+)\.([a-z]{2,4})/i;
            return _loc_2.test(param1);
        }// end function

        public static function chronoStart() : void
        {
            vChrono = getTimer();
            return;
        }// end function

        public static function chronoTrace(param1:String = "") : String
        {
            var _loc_2:* = (getTimer() - vChrono) / 1000;
            var _loc_3:* = "[Chrono] " + param1 + " : " + _loc_2;
            return _loc_3;
        }// end function

        public static function getDate(param1:Boolean = true) : String
        {
            var _loc_3:* = 0;
            var _loc_2:* = new Date();
            var _loc_4:* = "";
            if (param1)
            {
                _loc_4 = _loc_4 + _loc_2.getFullYear().toString();
                _loc_4 = _loc_4 + "/";
                _loc_3 = _loc_2.getMonth() + 1;
                if (_loc_3 < 10)
                {
                    _loc_4 = _loc_4 + "0";
                }
                _loc_4 = _loc_4 + _loc_3.toString();
                _loc_4 = _loc_4 + "/";
                _loc_3 = _loc_2.getDate();
                if (_loc_3 < 10)
                {
                    _loc_4 = _loc_4 + "0";
                }
                _loc_4 = _loc_4 + _loc_3.toString();
                _loc_4 = _loc_4 + " ";
            }
            _loc_3 = _loc_2.getHours();
            if (_loc_3 < 10)
            {
                _loc_4 = _loc_4 + "0";
            }
            _loc_4 = _loc_4 + _loc_3.toString();
            _loc_4 = _loc_4 + ":";
            _loc_3 = _loc_2.getMinutes();
            if (_loc_3 < 10)
            {
                _loc_4 = _loc_4 + "0";
            }
            _loc_4 = _loc_4 + _loc_3.toString();
            _loc_4 = _loc_4 + ":";
            _loc_3 = _loc_2.getSeconds();
            if (_loc_3 < 10)
            {
                _loc_4 = _loc_4 + "0";
            }
            _loc_4 = _loc_4 + _loc_3.toString();
            return _loc_4;
        }// end function

        public static function doBump(param1:DisplayObject) : void
        {
            TweenMax.killTweensOf(param1);
            var _loc_2:* = 1;
            param1.scaleY = 1;
            param1.scaleX = _loc_2;
            TweenMax.to(param1, 0.2, {scaleX:1.2, scaleY:1.2, yoyo:true, repeat:5});
            return;
        }// end function

        public static function doBumpOnce(param1:DisplayObject) : void
        {
            TweenMax.killTweensOf(param1);
            var _loc_2:* = 1;
            param1.scaleY = 1;
            param1.scaleX = _loc_2;
            TweenMax.to(param1, 0.2, {scaleX:1.2, scaleY:1.2, yoyo:true, repeat:1});
            return;
        }// end function

        public static function doPulse(param1:DisplayObject) : void
        {
            if (param1.stage == null)
            {
                return;
            }
            TweenMax.to(param1, 0.1, {delay:1, scaleX:1.04, scaleY:1.04, ease:Quad.easeIn});
            TweenMax.to(param1, 0.4, {delay:1.2, scaleX:1, scaleY:1, ease:Quad.easeOut});
            TweenMax.to(param1, 2, {alpha:1, onComplete:doPulse, onCompleteParams:[param1]});
            return;
        }// end function

        public static function doPulseHeartBeat(param1:DisplayObject) : void
        {
            if (param1.stage == null)
            {
                return;
            }
            TweenMax.to(param1, 0.1, {delay:1, scaleX:1.06, scaleY:1.06, repeat:1, yoyo:true});
            TweenMax.to(param1, 0.1, {delay:2, scaleX:1.06, scaleY:1.06, repeat:3, yoyo:true});
            TweenMax.to(param1, 2, {alpha:1, onComplete:doPulseHeartBeat, onCompleteParams:[param1]});
            return;
        }// end function

        public static function stopPulse(param1:DisplayObject) : void
        {
            if (param1.stage == null)
            {
                return;
            }
            TweenMax.killTweensOf(param1);
            TweenMax.to(param1, 0.1, {scaleX:1, scaleY:1});
            return;
        }// end function

        public static function textReduce(param1:TextField) : void
        {
            var _loc_2:* = null;
            while (param1.maxScrollH > 0 || param1.maxScrollV > 1)
            {
                
                _loc_2 = param1.getTextFormat();
                _loc_2.size = parseInt(_loc_2.size.toString()) - 1;
                param1.setTextFormat(_loc_2);
                param1.y = param1.y + 0.5;
            }
            return;
        }// end function

        public static function traceObject(param1:Object, param2:String = "") : void
        {
            var _loc_3:* = "";
            if (param2 != "")
            {
                param2 = "[" + param2 + "] ";
            }
            traceObjectInside(param1, 2);
            return;
        }// end function

        public static function traceObjectInside(param1:Object, param2:int) : void
        {
            var _loc_5:* = undefined;
            var _loc_3:* = "";
            var _loc_4:* = 0;
            while (_loc_4 < param2)
            {
                
                _loc_3 = _loc_3 + " ";
                _loc_4++;
            }
            for (_loc_5 in param1)
            {
                
                if (typeof(_loc_7[_loc_5]) == "object")
                {
                    traceObjectInside(_loc_7[_loc_5], (param2 + 1));
                    continue;
                }
            }
            return;
        }// end function

    }
}
