package com.hurlant.crypto.symmetric
{
    import com.hurlant.crypto.symmetric.*;
    import com.hurlant.crypto.tls.*;
    import flash.utils.*;

    public class SSLPad extends Object implements IPad
    {
        private var blockSize:uint;

        public function SSLPad(param1:uint = 0)
        {
            this.blockSize = param1;
            return;
        }// end function

        public function pad(param1:ByteArray) : void
        {
            var _loc_2:* = this.blockSize - (param1.length + 1) % this.blockSize;
            var _loc_3:* = 0;
            while (_loc_3 <= _loc_2)
            {
                
                param1[param1.length] = _loc_2;
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        public function unpad(param1:ByteArray) : void
        {
            var _loc_4:* = 0;
            var _loc_2:* = param1.length % this.blockSize;
            if (_loc_2 != 0)
            {
                throw new TLSError("SSLPad::unpad: ByteArray.length isn\'t a multiple of the blockSize", TLSError.bad_record_mac);
            }
            _loc_2 = param1[(param1.length - 1)];
            var _loc_3:* = _loc_2;
            while (_loc_3 > 0)
            {
                
                _loc_4 = param1[(param1.length - 1)];
                var _loc_5:* = param1;
                var _loc_6:* = _loc_5.length - 1;
                _loc_5.length = _loc_6;
                _loc_3 = _loc_3 - 1;
            }
            var _loc_5:* = param1;
            var _loc_6:* = _loc_5.length - 1;
            _loc_5.length = _loc_6;
            return;
        }// end function

        public function setBlockSize(param1:uint) : void
        {
            this.blockSize = param1;
            return;
        }// end function

    }
}
