package com.hurlant.crypto.tls
{
    import flash.utils.*;

    public interface IConnectionState
    {

        public function IConnectionState();

        function decrypt(param1:uint, param2:uint, param3:ByteArray) : ByteArray;

        function encrypt(param1:uint, param2:ByteArray) : ByteArray;

    }
}
