package com.hurlant.crypto.hash
{
    import flash.utils.*;

    public interface IHash
    {

        public function IHash();

        function getInputSize() : uint;

        function getHashSize() : uint;

        function hash(param1:ByteArray) : ByteArray;

        function toString() : String;

        function getPadSize() : int;

    }
}
