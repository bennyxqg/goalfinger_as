package com.hurlant.crypto.tls
{
    import com.hurlant.crypto.hash.*;
    import com.hurlant.crypto.symmetric.*;
    import com.hurlant.crypto.tls.*;
    import com.hurlant.util.*;
    import flash.utils.*;

    public class TLSConnectionState extends Object implements IConnectionState
    {
        private var bulkCipher:uint;
        private var cipherType:uint;
        private var CIPHER_key:ByteArray;
        private var CIPHER_IV:ByteArray;
        private var cipher:ICipher;
        private var ivmode:IVMode;
        private var macAlgorithm:uint;
        private var MAC_write_secret:ByteArray;
        private var hmac:HMAC;
        private var seq_lo:uint;
        private var seq_hi:uint;

        public function TLSConnectionState(param1:uint = 0, param2:uint = 0, param3:uint = 0, param4:ByteArray = null, param5:ByteArray = null, param6:ByteArray = null)
        {
            this.bulkCipher = param1;
            this.cipherType = param2;
            this.macAlgorithm = param3;
            this.MAC_write_secret = param4;
            this.hmac = MACs.getHMAC(param3);
            this.CIPHER_key = param5;
            this.CIPHER_IV = param6;
            this.cipher = BulkCiphers.getCipher(param1, param5, 769);
            if (this.cipher is IVMode)
            {
                this.ivmode = this.cipher as IVMode;
                this.ivmode.IV = param6;
            }
            return;
        }// end function

        public function decrypt(param1:uint, param2:uint, param3:ByteArray) : ByteArray
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = null;
            if (this.cipherType == BulkCiphers.STREAM_CIPHER)
            {
                if (this.bulkCipher == BulkCiphers.NULL)
                {
                }
                else
                {
                    this.cipher.decrypt(param3);
                }
            }
            else
            {
                _loc_4 = new ByteArray();
                _loc_4.writeBytes(param3, param3.length - this.CIPHER_IV.length, this.CIPHER_IV.length);
                this.cipher.decrypt(param3);
                this.CIPHER_IV = _loc_4;
                this.ivmode.IV = _loc_4;
            }
            if (this.macAlgorithm != MACs.NULL)
            {
                _loc_5 = new ByteArray();
                _loc_6 = param3.length - this.hmac.getHashSize();
                _loc_5.writeUnsignedInt(this.seq_hi);
                _loc_5.writeUnsignedInt(this.seq_lo);
                _loc_5.writeByte(param1);
                _loc_5.writeShort(TLSSecurityParameters.PROTOCOL_VERSION);
                _loc_5.writeShort(_loc_6);
                if (_loc_6 != 0)
                {
                    _loc_5.writeBytes(param3, 0, _loc_6);
                }
                _loc_7 = this.hmac.compute(this.MAC_write_secret, _loc_5);
                _loc_8 = new ByteArray();
                _loc_8.writeBytes(param3, _loc_6, this.hmac.getHashSize());
                if (ArrayUtil.equals(_loc_7, _loc_8))
                {
                }
                else
                {
                    throw new TLSError("Bad Mac Data", TLSError.bad_record_mac);
                }
                param3.length = _loc_6;
                param3.position = 0;
            }
            var _loc_9:* = this;
            var _loc_10:* = this.seq_lo + 1;
            _loc_9.seq_lo = _loc_10;
            if (this.seq_lo == 0)
            {
                var _loc_9:* = this;
                var _loc_10:* = this.seq_hi + 1;
                _loc_9.seq_hi = _loc_10;
            }
            return param3;
        }// end function

        public function encrypt(param1:uint, param2:ByteArray) : ByteArray
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_3:* = null;
            if (this.macAlgorithm != MACs.NULL)
            {
                _loc_4 = new ByteArray();
                _loc_4.writeUnsignedInt(this.seq_hi);
                _loc_4.writeUnsignedInt(this.seq_lo);
                _loc_4.writeByte(param1);
                _loc_4.writeShort(TLSSecurityParameters.PROTOCOL_VERSION);
                _loc_4.writeShort(param2.length);
                if (param2.length != 0)
                {
                    _loc_4.writeBytes(param2, 0, param2.length);
                }
                _loc_3 = this.hmac.compute(this.MAC_write_secret, _loc_4);
                param2.position = param2.length;
                param2.writeBytes(_loc_3);
            }
            param2.position = 0;
            if (this.cipherType == BulkCiphers.STREAM_CIPHER)
            {
                if (this.bulkCipher == BulkCiphers.NULL)
                {
                }
                else
                {
                    this.cipher.encrypt(param2);
                }
            }
            else
            {
                this.cipher.encrypt(param2);
                _loc_5 = new ByteArray();
                _loc_5.writeBytes(param2, param2.length - this.CIPHER_IV.length, this.CIPHER_IV.length);
                this.CIPHER_IV = _loc_5;
                this.ivmode.IV = _loc_5;
            }
            var _loc_6:* = this;
            var _loc_7:* = this.seq_lo + 1;
            _loc_6.seq_lo = _loc_7;
            if (this.seq_lo == 0)
            {
                var _loc_6:* = this;
                var _loc_7:* = this.seq_hi + 1;
                _loc_6.seq_hi = _loc_7;
            }
            return param2;
        }// end function

    }
}
