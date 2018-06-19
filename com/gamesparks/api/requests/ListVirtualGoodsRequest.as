package com.gamesparks.api.requests
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class ListVirtualGoodsRequest extends GSRequest
    {

        public function ListVirtualGoodsRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".ListVirtualGoodsRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : ListVirtualGoodsRequest
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
                    callback(new ListVirtualGoodsResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : ListVirtualGoodsRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setIncludeDisabled(param1:Boolean) : ListVirtualGoodsRequest
        {
            this.data["includeDisabled"] = param1;
            return this;
        }// end function

        public function setTags(param1:Vector.<String>) : ListVirtualGoodsRequest
        {
            this.data["tags"] = toArray(param1);
            return this;
        }// end function

    }
}
