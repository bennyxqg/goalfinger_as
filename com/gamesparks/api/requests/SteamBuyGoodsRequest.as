package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class SteamBuyGoodsRequest extends GSRequest
    {

        public function SteamBuyGoodsRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".SteamBuyGoodsRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : SteamBuyGoodsRequest
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

        public function setScriptData(param1:Object) : SteamBuyGoodsRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setOrderId(param1:String) : SteamBuyGoodsRequest
        {
            this.data["orderId"] = param1;
            return this;
        }// end function

        public function setUniqueTransactionByPlayer(param1:Boolean) : SteamBuyGoodsRequest
        {
            this.data["uniqueTransactionByPlayer"] = param1;
            return this;
        }// end function

    }
}
