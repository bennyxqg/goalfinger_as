package com.hurlant.crypto.tls
{
    import com.hurlant.crypto.hash.*;
    import com.hurlant.crypto.tls.*;
    import com.hurlant.util.*;
    import flash.utils.*;

    public class SSLSecurityParameters extends Object implements ISecurityParameters
    {
        private var entity:uint;
        private var bulkCipher:uint;
        private var cipherType:uint;
        private var keySize:uint;
        private var keyMaterialLength:uint;
        private var keyBlock:ByteArray;
        private var IVSize:uint;
        private var MAC_length:uint;
        private var macAlgorithm:uint;
        private var hashSize:uint;
        private var compression:uint;
        private var masterSecret:ByteArray;
        private var clientRandom:ByteArray;
        private var serverRandom:ByteArray;
        private var pad_1:ByteArray;
        private var pad_2:ByteArray;
        private var ignoreCNMismatch:Boolean = true;
        private var trustAllCerts:Boolean = false;
        private var trustSelfSigned:Boolean = false;
        public var keyExchange:uint;
        public static const COMPRESSION_NULL:uint = 0;
        public static const PROTOCOL_VERSION:uint = 768;

        public function SSLSecurityParameters(param1:uint, param2:ByteArray = null, param3:ByteArray = null)
        {
            this.entity = param1;
            this.reset();
            return;
        }// end function

        public function get version() : uint
        {
            return PROTOCOL_VERSION;
        }// end function

        public function reset() : void
        {
            this.bulkCipher = BulkCiphers.NULL;
            this.cipherType = BulkCiphers.BLOCK_CIPHER;
            this.macAlgorithm = MACs.NULL;
            this.compression = COMPRESSION_NULL;
            this.masterSecret = null;
            return;
        }// end function

        public function getBulkCipher() : uint
        {
            return this.bulkCipher;
        }// end function

        public function getCipherType() : uint
        {
            return this.cipherType;
        }// end function

        public function getMacAlgorithm() : uint
        {
            return this.macAlgorithm;
        }// end function

        public function setCipher(param1:uint) : void
        {
            this.bulkCipher = CipherSuites.getBulkCipher(param1);
            this.cipherType = BulkCiphers.getType(this.bulkCipher);
            this.keySize = BulkCiphers.getExpandedKeyBytes(this.bulkCipher);
            this.keyMaterialLength = BulkCiphers.getKeyBytes(this.bulkCipher);
            this.IVSize = BulkCiphers.getIVSize(this.bulkCipher);
            this.keyExchange = CipherSuites.getKeyExchange(param1);
            this.macAlgorithm = CipherSuites.getMac(param1);
            this.hashSize = MACs.getHashSize(this.macAlgorithm);
            this.pad_1 = new ByteArray();
            this.pad_2 = new ByteArray();
            var _loc_2:* = 0;
            while (_loc_2 < 48)
            {
                
                this.pad_1.writeByte(54);
                this.pad_2.writeByte(92);
                _loc_2++;
            }
            return;
        }// end function

        public function setCompression(param1:uint) : void
        {
            this.compression = param1;
            return;
        }// end function

        public function setPreMasterSecret(param1:ByteArray) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_2:* = new ByteArray();
            var _loc_3:* = new ByteArray();
            var _loc_8:* = new SHA1();
            var _loc_9:* = new MD5();
            var _loc_10:* = new ByteArray();
            _loc_2.writeBytes(param1);
            _loc_10.writeBytes(this.clientRandom);
            _loc_10.writeBytes(this.serverRandom);
            this.masterSecret = new ByteArray();
            var _loc_11:* = 65;
            _loc_6 = 0;
            while (_loc_6 < 3)
            {
                
                _loc_2.position = 0;
                _loc_7 = 0;
                while (_loc_7 < (_loc_6 + 1))
                {
                    
                    _loc_2.writeByte(_loc_11);
                    _loc_7++;
                }
                _loc_11 = _loc_11 + 1;
                _loc_2.writeBytes(_loc_10);
                _loc_4 = _loc_8.hash(_loc_2);
                _loc_3.position = 0;
                _loc_3.writeBytes(param1);
                _loc_3.writeBytes(_loc_4);
                _loc_5 = _loc_9.hash(_loc_3);
                this.masterSecret.writeBytes(_loc_5);
                _loc_6++;
            }
            _loc_10.position = 0;
            _loc_10.writeBytes(this.masterSecret);
            _loc_10.writeBytes(this.serverRandom);
            _loc_10.writeBytes(this.clientRandom);
            this.keyBlock = new ByteArray();
            _loc_2 = new ByteArray();
            _loc_3 = new ByteArray();
            _loc_11 = 65;
            _loc_6 = 0;
            while (_loc_6 < 16)
            {
                
                _loc_2.position = 0;
                _loc_7 = 0;
                while (_loc_7 < (_loc_6 + 1))
                {
                    
                    _loc_2.writeByte(_loc_11);
                    _loc_7++;
                }
                _loc_11 = _loc_11 + 1;
                _loc_2.writeBytes(_loc_10);
                _loc_4 = _loc_8.hash(_loc_2);
                _loc_3.position = 0;
                _loc_3.writeBytes(this.masterSecret);
                _loc_3.writeBytes(_loc_4, 0);
                _loc_5 = _loc_9.hash(_loc_3);
                this.keyBlock.writeBytes(_loc_5);
                _loc_6++;
            }
            return;
        }// end function

        public function setClientRandom(param1:ByteArray) : void
        {
            this.clientRandom = param1;
            return;
        }// end function

        public function setServerRandom(param1:ByteArray) : void
        {
            this.serverRandom = param1;
            return;
        }// end function

        public function get useRSA() : Boolean
        {
            return KeyExchanges.useRSA(this.keyExchange);
        }// end function

        public function computeVerifyData(param1:uint, param2:ByteArray) : ByteArray
        {
            var _loc_7:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_3:* = new SHA1();
            var _loc_4:* = new MD5();
            var _loc_5:* = new ByteArray();
            var _loc_6:* = new ByteArray();
            var _loc_8:* = new ByteArray();
            var _loc_11:* = new ByteArray();
            if (param1 == TLSEngine.CLIENT)
            {
                _loc_11.writeUnsignedInt(1129074260);
            }
            else
            {
                _loc_11.writeUnsignedInt(1397904978);
            }
            this.masterSecret.position = 0;
            _loc_5.writeBytes(param2);
            _loc_5.writeBytes(_loc_11);
            _loc_5.writeBytes(this.masterSecret);
            _loc_5.writeBytes(this.pad_1, 0, 40);
            _loc_7 = _loc_3.hash(_loc_5);
            _loc_6.writeBytes(this.masterSecret);
            _loc_6.writeBytes(this.pad_2, 0, 40);
            _loc_6.writeBytes(_loc_7);
            _loc_9 = _loc_3.hash(_loc_6);
            _loc_5 = new ByteArray();
            _loc_5.writeBytes(param2);
            _loc_5.writeBytes(_loc_11);
            _loc_5.writeBytes(this.masterSecret);
            _loc_5.writeBytes(this.pad_1);
            _loc_7 = _loc_4.hash(_loc_5);
            _loc_6 = new ByteArray();
            _loc_6.writeBytes(this.masterSecret);
            _loc_6.writeBytes(this.pad_2);
            _loc_6.writeBytes(_loc_7);
            _loc_10 = _loc_4.hash(_loc_6);
            _loc_8.writeBytes(_loc_10, 0, _loc_10.length);
            _loc_8.writeBytes(_loc_9, 0, _loc_9.length);
            var _loc_12:* = Hex.fromArray(_loc_8);
            _loc_8.position = 0;
            return _loc_8;
        }// end function

        public function computeCertificateVerify(param1:uint, param2:ByteArray) : ByteArray
        {
            return null;
        }// end function

        public function getConnectionStates() : Object
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            if (this.masterSecret != null)
            {
                _loc_1 = this.hashSize as Number;
                _loc_2 = this.keySize as Number;
                _loc_3 = this.IVSize as Number;
                _loc_4 = new ByteArray();
                _loc_5 = new ByteArray();
                _loc_6 = new ByteArray();
                _loc_7 = new ByteArray();
                _loc_8 = new ByteArray();
                _loc_9 = new ByteArray();
                this.keyBlock.position = 0;
                this.keyBlock.readBytes(_loc_4, 0, _loc_1);
                this.keyBlock.readBytes(_loc_5, 0, _loc_1);
                this.keyBlock.readBytes(_loc_6, 0, _loc_2);
                this.keyBlock.readBytes(_loc_7, 0, _loc_2);
                this.keyBlock.readBytes(_loc_8, 0, _loc_3);
                this.keyBlock.readBytes(_loc_9, 0, _loc_3);
                this.keyBlock.position = 0;
                _loc_10 = new SSLConnectionState(this.bulkCipher, this.cipherType, this.macAlgorithm, _loc_4, _loc_6, _loc_8);
                _loc_11 = new SSLConnectionState(this.bulkCipher, this.cipherType, this.macAlgorithm, _loc_5, _loc_7, _loc_9);
                if (this.entity == TLSEngine.CLIENT)
                {
                    return {read:_loc_11, write:_loc_10};
                }
                return {read:_loc_10, write:_loc_11};
            }
            else
            {
            }
            return {read:new SSLConnectionState(), write:new SSLConnectionState()};
        }// end function

    }
}
