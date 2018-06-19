package com.hurlant.crypto.hash
{
    import flash.utils.*;

    public interface IHMAC
    {

        public function IHMAC();

        function getHashSize() : uint;

        function compute(param1:ByteArray, param2:ByteArray) : ByteArray;

        function dispose() : void;

        function toString() : String;

    }
}
