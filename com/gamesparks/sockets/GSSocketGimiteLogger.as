package com.gamesparks.sockets
{
    import net.gimite.websocket.*;

    public class GSSocketGimiteLogger extends Object implements IWebSocketLogger
    {
        private var logger:Function;

        public function GSSocketGimiteLogger(param1:Function)
        {
            this.logger = param1;
            return;
        }// end function

        public function log(param1:String) : void
        {
            this.logger("log:" + param1);
            return;
        }// end function

        public function error(param1:String) : void
        {
            this.logger("err:" + param1.split("rror").join("rr"));
            return;
        }// end function

    }
}
