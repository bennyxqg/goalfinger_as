package com.hurlant.crypto.symmetric
{
    import com.hurlant.crypto.prng.*;
    import com.hurlant.util.*;
    import flash.utils.*;

    public class IVMode extends Object
    {
        protected var key:ISymmetricKey;
        protected var padding:IPad;
        protected var prng:Random;
        protected var iv:ByteArray;
        protected var lastIV:ByteArray;
        protected var blockSize:uint;

        public function IVMode(param1:ISymmetricKey, param2:IPad = null)
        {
            this.key = param1;
            this.blockSize = param1.getBlockSize();
            if (param2 == null)
            {
                param2 = new PKCS5(this.blockSize);
            }
            else
            {
                param2.setBlockSize(this.blockSize);
            }
            this.padding = param2;
            this.prng = new Random();
            this.iv = null;
            this.lastIV = new ByteArray();
            return;
        }// end function

        public function getBlockSize() : uint
        {
            return this.key.getBlockSize();
        }// end function

        public function dispose() : void
        {
            var _loc_1:* = 0;
            if (this.iv != null)
            {
                _loc_1 = 0;
                while (_loc_1 < this.iv.length)
                {
                    
                    this.iv[_loc_1] = this.prng.nextByte();
                    _loc_1 = _loc_1 + 1;
                }
                this.iv.length = 0;
                this.iv = null;
            }
            if (this.lastIV != null)
            {
                _loc_1 = 0;
                while (_loc_1 < this.iv.length)
                {
                    
                    this.lastIV[_loc_1] = this.prng.nextByte();
                    _loc_1 = _loc_1 + 1;
                }
                this.lastIV.length = 0;
                this.lastIV = null;
            }
            this.key.dispose();
            this.key = null;
            this.padding = null;
            this.prng.dispose();
            this.prng = null;
            Memory.gc();
            return;
        }// end function

        public function set IV(param1:ByteArray) : void
        {
            this.iv = param1;
            this.lastIV.length = 0;
            this.lastIV.writeBytes(this.iv);
            return;
        }// end function

        public function get IV() : ByteArray
        {
            return this.lastIV;
        }// end function

        protected function getIV4e() : ByteArray
        {
            var _loc_1:* = new ByteArray();
            if (this.iv)
            {
                _loc_1.writeBytes(this.iv);
            }
            else
            {
                this.prng.nextBytes(_loc_1, this.blockSize);
            }
            this.lastIV.length = 0;
            this.lastIV.writeBytes(_loc_1);
            return _loc_1;
        }// end function

        protected function getIV4d() : ByteArray
        {
            var _loc_1:* = new ByteArray();
            if (this.iv)
            {
                _loc_1.writeBytes(this.iv);
            }
            else
            {
                throw new Error("an IV must be set before calling decrypt()");
            }
            return _loc_1;
        }// end function

    }
}
