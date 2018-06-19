package com.gamesparks.sockets
{

    public interface GSSocket
    {

        public function GSSocket();

        function Dispose() : void;

        function Connect(param1:String, param2:Function, param3:Function, param4:Function, param5:Function) : Boolean;

        function Send(param1:String, param2:Boolean = false) : void;

        function Connected() : Boolean;

        function Disconnect() : void;

        function EnablePing() : void;

        function GetName() : String;

        function IsExternal() : Boolean;

    }
}
