package com.hurlant.crypto.symmetric
{
    import com.hurlant.util.*;
    import flash.utils.*;

    public class TripleDESKey extends DESKey
    {
        protected var encKey2:Array;
        protected var encKey3:Array;
        protected var decKey2:Array;
        protected var decKey3:Array;

        public function TripleDESKey(param1:ByteArray)
        {
            super(param1);
            this.encKey2 = generateWorkingKey(false, param1, 8);
            this.decKey2 = generateWorkingKey(true, param1, 8);
            if (param1.length > 16)
            {
                this.encKey3 = generateWorkingKey(true, param1, 16);
                this.decKey3 = generateWorkingKey(false, param1, 16);
            }
            else
            {
                this.encKey3 = encKey;
                this.decKey3 = decKey;
            }
            return;
        }// end function

        override public function dispose() : void
        {
            super.dispose();
            var _loc_1:* = 0;
            if (this.encKey2 != null)
            {
                _loc_1 = 0;
                while (_loc_1 < this.encKey2.length)
                {
                    
                    this.encKey2[_loc_1] = 0;
                    _loc_1 = _loc_1 + 1;
                }
                this.encKey2 = null;
            }
            if (this.encKey3 != null)
            {
                _loc_1 = 0;
                while (_loc_1 < this.encKey3.length)
                {
                    
                    this.encKey3[_loc_1] = 0;
                    _loc_1 = _loc_1 + 1;
                }
                this.encKey3 = null;
            }
            if (this.decKey2 != null)
            {
                _loc_1 = 0;
                while (_loc_1 < this.decKey2.length)
                {
                    
                    this.decKey2[_loc_1] = 0;
                    _loc_1 = _loc_1 + 1;
                }
                this.decKey2 = null;
            }
            if (this.decKey3 != null)
            {
                _loc_1 = 0;
                while (_loc_1 < this.decKey3.length)
                {
                    
                    this.decKey3[_loc_1] = 0;
                    _loc_1 = _loc_1 + 1;
                }
                this.decKey3 = null;
            }
            Memory.gc();
            return;
        }// end function

        override public function encrypt(param1:ByteArray, param2:uint = 0) : void
        {
            desFunc(encKey, param1, param2, param1, param2);
            desFunc(this.encKey2, param1, param2, param1, param2);
            desFunc(this.encKey3, param1, param2, param1, param2);
            return;
        }// end function

        override public function decrypt(param1:ByteArray, param2:uint = 0) : void
        {
            desFunc(this.decKey3, param1, param2, param1, param2);
            desFunc(this.decKey2, param1, param2, param1, param2);
            desFunc(decKey, param1, param2, param1, param2);
            return;
        }// end function

        override public function toString() : String
        {
            return "3des";
        }// end function

    }
}
