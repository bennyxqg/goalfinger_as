package com.hurlant.crypto.hash
{
    import com.hurlant.crypto.hash.*;

    public class SHA256 extends SHABase implements IHash
    {
        protected var H:Array;
        static const k:Array = [1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993, 2453635748, 2870763221, 3624381080, 310598401, 607225278, 1426881987, 1925078388, 2162078206, 2614888103, 3248222580, 3835390401, 4022224774, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986, 2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711, 113926993, 338241895, 666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, 2177026350, 2456956037, 2730485921, 2820302411, 3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344, 430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779, 1955562222, 2024104815, 2227730452, 2361852424, 2428436474, 2756734187, 3204031479, 3329325298];

        public function SHA256()
        {
            this.H = [1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225];
            return;
        }// end function

        override public function getHashSize() : uint
        {
            return 32;
        }// end function

        override protected function core(param1:Array, param2:uint) : Array
        {
            var _loc_13:* = 0;
            var _loc_14:* = 0;
            var _loc_15:* = 0;
            var _loc_16:* = 0;
            var _loc_17:* = 0;
            var _loc_18:* = 0;
            var _loc_19:* = 0;
            var _loc_20:* = 0;
            var _loc_21:* = 0;
            var _loc_22:* = 0;
            var _loc_23:* = 0;
            var _loc_24:* = 0;
            var _loc_25:* = 0;
            param1[param2 >> 5] = param1[param2 >> 5] | 128 << 24 - param2 % 32;
            param1[(param2 + 64 >> 9 << 4) + 15] = param2;
            var _loc_3:* = [];
            var _loc_4:* = this.H[0];
            var _loc_5:* = this.H[1];
            var _loc_6:* = this.H[2];
            var _loc_7:* = this.H[3];
            var _loc_8:* = this.H[4];
            var _loc_9:* = this.H[5];
            var _loc_10:* = this.H[6];
            var _loc_11:* = this.H[7];
            var _loc_12:* = 0;
            while (_loc_12 < param1.length)
            {
                
                _loc_13 = _loc_4;
                _loc_14 = _loc_5;
                _loc_15 = _loc_6;
                _loc_16 = _loc_7;
                _loc_17 = _loc_8;
                _loc_18 = _loc_9;
                _loc_19 = _loc_10;
                _loc_20 = _loc_11;
                _loc_21 = 0;
                while (_loc_21 < 64)
                {
                    
                    if (_loc_21 < 16)
                    {
                        _loc_3[_loc_21] = param1[_loc_12 + _loc_21] || 0;
                    }
                    else
                    {
                        _loc_24 = this.rrol(_loc_3[_loc_21 - 15], 7) ^ this.rrol(_loc_3[_loc_21 - 15], 18) ^ _loc_3[_loc_21 - 15] >>> 3;
                        _loc_25 = this.rrol(_loc_3[_loc_21 - 2], 17) ^ this.rrol(_loc_3[_loc_21 - 2], 19) ^ _loc_3[_loc_21 - 2] >>> 10;
                        _loc_3[_loc_21] = _loc_3[_loc_21 - 16] + _loc_24 + _loc_3[_loc_21 - 7] + _loc_25;
                    }
                    _loc_22 = (this.rrol(_loc_4, 2) ^ this.rrol(_loc_4, 13) ^ this.rrol(_loc_4, 22)) + (_loc_4 & _loc_5 ^ _loc_4 & _loc_6 ^ _loc_5 & _loc_6);
                    _loc_23 = _loc_11 + (this.rrol(_loc_8, 6) ^ this.rrol(_loc_8, 11) ^ this.rrol(_loc_8, 25)) + (_loc_8 & _loc_9 ^ _loc_10 & ~_loc_8) + k[_loc_21] + _loc_3[_loc_21];
                    _loc_11 = _loc_10;
                    _loc_10 = _loc_9;
                    _loc_9 = _loc_8;
                    _loc_8 = _loc_7 + _loc_23;
                    _loc_7 = _loc_6;
                    _loc_6 = _loc_5;
                    _loc_5 = _loc_4;
                    _loc_4 = _loc_23 + _loc_22;
                    _loc_21 = _loc_21 + 1;
                }
                _loc_4 = _loc_4 + _loc_13;
                _loc_5 = _loc_5 + _loc_14;
                _loc_6 = _loc_6 + _loc_15;
                _loc_7 = _loc_7 + _loc_16;
                _loc_8 = _loc_8 + _loc_17;
                _loc_9 = _loc_9 + _loc_18;
                _loc_10 = _loc_10 + _loc_19;
                _loc_11 = _loc_11 + _loc_20;
                _loc_12 = _loc_12 + 16;
            }
            return [_loc_4, _loc_5, _loc_6, _loc_7, _loc_8, _loc_9, _loc_10, _loc_11];
        }// end function

        protected function rrol(param1:uint, param2:uint) : uint
        {
            return param1 << 32 - param2 | param1 >>> param2;
        }// end function

        override public function toString() : String
        {
            return "sha256";
        }// end function

    }
}
