package com.hurlant.crypto.hash
{

    public class SHA224 extends SHA256
    {

        public function SHA224()
        {
            H = [3238371032, 914150663, 812702999, 4144912697, 4290775857, 1750603025, 1694076839, 3204075428];
            return;
        }// end function

        override public function getHashSize() : uint
        {
            return 28;
        }// end function

        override public function toString() : String
        {
            return "sha224";
        }// end function

    }
}
