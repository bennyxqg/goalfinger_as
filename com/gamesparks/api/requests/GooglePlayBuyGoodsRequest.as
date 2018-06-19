package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class GooglePlayBuyGoodsRequest extends GSRequest
    {

        public function GooglePlayBuyGoodsRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".GooglePlayBuyGoodsRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : GooglePlayBuyGoodsRequest
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

        public function setScriptData(param1:Object) : GooglePlayBuyGoodsRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setSignature(param1:String) : GooglePlayBuyGoodsRequest
        {
            this.data["signature"] = param1;
            return this;
        }// end function

        public function setSignedData(param1:String) : GooglePlayBuyGoodsRequest
        {
            this.data["signedData"] = param1;
            return this;
        }// end function

        public function setUniqueTransactionByPlayer(param1:Boolean) : GooglePlayBuyGoodsRequest
        {
            this.data["uniqueTransactionByPlayer"] = param1;
            return this;
        }// end function

    }
}
