package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class IOSBuyGoodsRequest extends GSRequest
    {

        public function IOSBuyGoodsRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".IOSBuyGoodsRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : IOSBuyGoodsRequest
        {
            this.timeoutSeconds = param1;
            return this;
        }// end function

        override public function send(param1:Function) : String
        {
            var callback:* = param1;
            return super.send(function (param1:Object) : void
            {
                if (callback != null)
                {
                    callback(new BuyVirtualGoodResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : IOSBuyGoodsRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setReceipt(param1:String) : IOSBuyGoodsRequest
        {
            this.data["receipt"] = param1;
            return this;
        }// end function

        public function setSandbox(param1:Boolean) : IOSBuyGoodsRequest
        {
            this.data["sandbox"] = param1;
            return this;
        }// end function

        public function setUniqueTransactionByPlayer(param1:Boolean) : IOSBuyGoodsRequest
        {
            this.data["uniqueTransactionByPlayer"] = param1;
            return this;
        }// end function

    }
}
