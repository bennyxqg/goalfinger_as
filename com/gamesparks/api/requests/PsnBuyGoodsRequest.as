package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class PsnBuyGoodsRequest extends GSRequest
    {

        public function PsnBuyGoodsRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".PsnBuyGoodsRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : PsnBuyGoodsRequest
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

        public function setScriptData(param1:Object) : PsnBuyGoodsRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setAuthorizationCode(param1:String) : PsnBuyGoodsRequest
        {
            this.data["authorizationCode"] = param1;
            return this;
        }// end function

        public function setEntitlementLabel(param1:String) : PsnBuyGoodsRequest
        {
            this.data["entitlementLabel"] = param1;
            return this;
        }// end function

        public function setRedirectUri(param1:String) : PsnBuyGoodsRequest
        {
            this.data["redirectUri"] = param1;
            return this;
        }// end function

        public function setUniqueTransactionByPlayer(param1:Boolean) : PsnBuyGoodsRequest
        {
            this.data["uniqueTransactionByPlayer"] = param1;
            return this;
        }// end function

        public function setUseCount(param1:Number) : PsnBuyGoodsRequest
        {
            this.data["useCount"] = param1;
            return this;
        }// end function

    }
}
