package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class BuyVirtualGoodsRequest extends GSRequest
    {

        public function BuyVirtualGoodsRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".BuyVirtualGoodsRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : BuyVirtualGoodsRequest
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

        public function setScriptData(param1:Object) : BuyVirtualGoodsRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setCurrencyType(param1:Number) : BuyVirtualGoodsRequest
        {
            this.data["currencyType"] = param1;
            return this;
        }// end function

        public function setQuantity(param1:Number) : BuyVirtualGoodsRequest
        {
            this.data["quantity"] = param1;
            return this;
        }// end function

        public function setShortCode(param1:String) : BuyVirtualGoodsRequest
        {
            this.data["shortCode"] = param1;
            return this;
        }// end function

    }
}
