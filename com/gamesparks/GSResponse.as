package com.gamesparks
{

    public class GSResponse extends GSData
    {

        public function GSResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function HasErrors() : Boolean
        {
            return data.hasOwnProperty("error");
        }// end function

        public function getScriptData() : Object
        {
            return data["scriptData"];
        }// end function

        public function getErrors() : Object
        {
            return data["error"];
        }// end function

    }
}
