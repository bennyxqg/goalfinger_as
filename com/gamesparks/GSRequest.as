package com.gamesparks
{
    import flash.utils.*;

    public class GSRequest extends GSData
    {
        protected var timeoutSeconds:int = 5;
        var callback:Function = null;
        var requestId:String;
        var durable:Boolean = false;
        var durableRetryTicks:Number = 0;
        private var gs:GS;

        public function GSRequest(param1:GS, param2:Object = null)
        {
            if (param2 == null)
            {
                param2 = new Object();
            }
            super(param2);
            this.gs = param1;
            return;
        }// end function

        public function getData() : Object
        {
            return data;
        }// end function

        public function send(param1:Function) : String
        {
            this.callback = param1;
            var _loc_2:* = this.deepCopy();
            this.gs.send(_loc_2);
            return _loc_2.getData().requestId;
        }// end function

        public function hasCallback() : Boolean
        {
            if (this.callback != null)
            {
                return true;
            }
            return false;
        }// end function

        public function setCallback(param1:Function) : void
        {
            this.callback = param1;
            return;
        }// end function

        public function setDurable(param1:Boolean) : void
        {
            this.durable = param1;
            return;
        }// end function

        function getTimeoutSeconds() : int
        {
            return this.timeoutSeconds;
        }// end function

        protected function toArray(param1) : Array
        {
            var _loc_3:* = undefined;
            var _loc_2:* = [];
            for each (_loc_3 in param1)
            {
                
                _loc_2.push(_loc_3);
            }
            return _loc_2;
        }// end function

        private function deepCopy() : GSRequest
        {
            var _loc_1:* = new GSRequest(this.gs);
            var _loc_2:* = new ByteArray();
            _loc_2.writeObject(data);
            _loc_2.position = 0;
            _loc_1.data = _loc_2.readObject();
            _loc_1.timeoutSeconds = this.timeoutSeconds;
            _loc_1.callback = this.callback;
            _loc_1.durable = this.durable;
            return _loc_1;
        }// end function

    }
}
