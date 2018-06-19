package com.adobe.serialization.json
{

    final public class JSONToken extends Object
    {
        public var type:int;
        public var value:Object;
        static const token:JSONToken = new JSONToken;

        public function JSONToken(param1:int = -1, param2:Object = null)
        {
            this.type = param1;
            this.value = param2;
            return;
        }// end function

        static function create(param1:int = -1, param2:Object = null) : JSONToken
        {
            token.type = param1;
            token.value = param2;
            return token;
        }// end function

    }
}
