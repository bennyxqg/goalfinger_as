package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class AmazonBuyGoodsRequest extends GSRequest
    {

        public function AmazonBuyGoodsRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".AmazonBuyGoodsRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : AmazonBuyGoodsRequest
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

        public function setScriptData(param1:Object) : AmazonBuyGoodsRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setAmazonUserId(param1:String) : AmazonBuyGoodsRequest
        {
            this.data["amazonUserId"] = param1;
            return this;
        }// end function

        public function setReceiptId(param1:String) : AmazonBuyGoodsRequest
        {
            this.data["receiptId"] = param1;
            return this;
        }// end function

        public function setUniqueTransactionByPlayer(param1:Boolean) : AmazonBuyGoodsRequest
        {
            this.data["uniqueTransactionByPlayer"] = param1;
            return this;
        }// end function

    }
}
