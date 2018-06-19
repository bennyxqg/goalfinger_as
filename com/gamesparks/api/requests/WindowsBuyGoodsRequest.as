package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class WindowsBuyGoodsRequest extends GSRequest
    {

        public function WindowsBuyGoodsRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".WindowsBuyGoodsRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : WindowsBuyGoodsRequest
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

        public function setScriptData(param1:Object) : WindowsBuyGoodsRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setPlatform(param1:String) : WindowsBuyGoodsRequest
        {
            this.data["platform"] = param1;
            return this;
        }// end function

        public function setReceipt(param1:String) : WindowsBuyGoodsRequest
        {
            this.data["receipt"] = param1;
            return this;
        }// end function

        public function setUniqueTransactionByPlayer(param1:Boolean) : WindowsBuyGoodsRequest
        {
            this.data["uniqueTransactionByPlayer"] = param1;
            return this;
        }// end function

    }
}
