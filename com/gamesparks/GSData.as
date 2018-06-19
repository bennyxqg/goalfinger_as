package com.gamesparks
{

    public class GSData extends Object
    {
        protected var data:Object;

        public function GSData(param1:Object)
        {
            this.data = new Object();
            this.data = param1;
            return;
        }// end function

        public function getAttribute(param1:String) : Object
        {
            return this.data[param1];
        }// end function

        public function setAttribute(param1:String, param2:Object) : GSData
        {
            this.data[param1] = param2;
            return this;
        }// end function

        protected function dateToRFC3339(param1:Date) : String
        {
            var _loc_2:* = (param1.getUTCMonth() + 1) < 10 ? ("0" + (param1.getUTCMonth() + 1)) : ("" + (param1.getUTCMonth() + 1));
            var _loc_3:* = param1.getUTCDate() < 10 ? ("0" + param1.getUTCDate()) : ("" + param1.getUTCDate());
            var _loc_4:* = param1.getUTCHours() < 10 ? ("0" + param1.getUTCHours()) : ("" + param1.getUTCHours());
            var _loc_5:* = param1.getUTCMinutes() < 10 ? ("0" + param1.getUTCMinutes()) : ("" + param1.getUTCMinutes());
            return param1.getUTCFullYear() + "-" + _loc_2 + "-" + _loc_3 + "T" + _loc_4 + ":" + _loc_5 + "Z";
        }// end function

        protected function RFC3339toDate(param1:String) : Date
        {
            var _loc_10:* = NaN;
            var _loc_12:* = 0;
            var _loc_13:* = null;
            var _loc_14:* = NaN;
            var _loc_2:* = param1.split("T");
            var _loc_3:* = _loc_2[0].split("-");
            var _loc_4:* = int(_loc_3[0]);
            var _loc_5:* = int((_loc_3[1] - 1));
            var _loc_6:* = int(_loc_3[2]);
            var _loc_7:* = _loc_2[1].split(":");
            var _loc_8:* = int(_loc_7[0]);
            var _loc_9:* = int(_loc_7[1]);
            var _loc_11:* = _loc_7[2];
            if (_loc_11.charAt((_loc_11.length - 1)) == "Z")
            {
                _loc_12 = 0;
                _loc_10 = parseFloat(_loc_11.slice(0, (_loc_11.length - 1)));
            }
            else
            {
                if (_loc_11.indexOf("+") != -1)
                {
                    _loc_13 = _loc_11.split("+");
                    _loc_12 = 1;
                }
                else if (_loc_11.indexOf("-") != -1)
                {
                    _loc_13 = _loc_11.split("-");
                    _loc_12 = -1;
                }
                else
                {
                    throw new Error("Invalid Format: cannot parse RFC3339 String.");
                }
                _loc_10 = parseFloat(_loc_13[0]);
                _loc_14 = 0;
                if (_loc_7[3])
                {
                    _loc_14 = parseFloat(_loc_13[1]) * 3600000;
                    _loc_14 = _loc_14 + parseFloat(_loc_7[3]) * 60000;
                }
                else
                {
                    _loc_14 = parseFloat(_loc_13[1]) * 60000;
                }
                _loc_12 = _loc_12 * _loc_14;
            }
            return new Date(Date.UTC(_loc_4, _loc_5, _loc_6, _loc_8, _loc_9, _loc_10) + _loc_12);
        }// end function

    }
}
