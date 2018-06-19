package com.gamesparks.api.requests
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class RevokePurchaseGoodsRequest extends GSRequest
    {

        public function RevokePurchaseGoodsRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".RevokePurchaseGoodsRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : RevokePurchaseGoodsRequest
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
                    callback(new RevokePurchaseGoodsResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : RevokePurchaseGoodsRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setPlayerId(param1:String) : RevokePurchaseGoodsRequest
        {
            this.data["playerId"] = param1;
            return this;
        }// end function

        public function setStoreType(param1:String) : RevokePurchaseGoodsRequest
        {
            this.data["storeType"] = param1;
            return this;
        }// end function

        public function setTransactionIds(param1:Vector.<String>) : RevokePurchaseGoodsRequest
        {
            this.data["transactionIds"] = toArray(param1);
            return this;
        }// end function

    }
}
