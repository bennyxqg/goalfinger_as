package com.hurlant.crypto.tls
{
    import com.hurlant.crypto.hash.*;
    import com.hurlant.crypto.prng.*;
    import com.hurlant.crypto.rsa.*;
    import com.hurlant.crypto.tls.*;
    import flash.utils.*;

    public class TLSSecurityParameters extends Object implements ISecurityParameters
    {
        private var cert:ByteArray;
        private var key:RSAKey;
        private var entity:uint;
        private var bulkCipher:uint;
        private var cipherType:uint;
        private var keySize:uint;
        private var keyMaterialLength:uint;
        private var IVSize:uint;
        private var macAlgorithm:uint;
        private var hashSize:uint;
        private var compression:uint;
        private var masterSecret:ByteArray;
        private var clientRandom:ByteArray;
        private var serverRandom:ByteArray;
        private var ignoreCNMismatch:Boolean = true;
        private var trustAllCerts:Boolean = false;
        private var trustSelfSigned:Boolean = false;
        private var tlsDebug:Boolean = false;
        public var keyExchange:uint;
        public static const COMPRESSION_NULL:uint = 0;
        public static var IGNORE_CN_MISMATCH:Boolean = true;
        public static var ENABLE_USER_CLIENT_CERTIFICATE:Boolean = false;
        public static var USER_CERTIFICATE:String;
        public static const PROTOCOL_VERSION:uint = 769;

        public function TLSSecurityParameters(param1:uint, param2:ByteArray = null, param3:RSAKey = null)
        {
            this.entity = param1;
            this.reset();
            this.key = param3;
            this.cert = param2;
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
            return;
        }// end function

        public function setCompression(param1:uint) : void
        {
            this.compression = param1;
            return;
        }// end function

        public function setPreMasterSecret(param1:ByteArray) : void
        {
            var _loc_2:* = new ByteArray();
            _loc_2.writeBytes(this.clientRandom, 0, this.clientRandom.length);
            _loc_2.writeBytes(this.serverRandom, 0, this.serverRandom.length);
            var _loc_3:* = new TLSPRF(param1, "master secret", _loc_2);
            this.masterSecret = new ByteArray();
            _loc_3.nextBytes(this.masterSecret, 48);
            if (this.tlsDebug)
            {
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
            var _loc_3:* = new ByteArray();
            var _loc_4:* = new MD5();
            if (this.tlsDebug)
            {
            }
            _loc_3.writeBytes(_loc_4.hash(param2), 0, _loc_4.getHashSize());
            var _loc_5:* = new SHA1();
            _loc_3.writeBytes(_loc_5.hash(param2), 0, _loc_5.getHashSize());
            if (this.tlsDebug)
            {
            }
            var _loc_6:* = new TLSPRF(this.masterSecret, param1 == TLSEngine.CLIENT ? ("client finished") : ("server finished"), _loc_3);
            var _loc_7:* = new ByteArray();
            _loc_6.nextBytes(_loc_7, 12);
            if (this.tlsDebug)
            {
            }
            _loc_7.position = 0;
            return _loc_7;
        }// end function

        public function computeCertificateVerify(param1:uint, param2:ByteArray) : ByteArray
        {
            var _loc_3:* = new ByteArray();
            var _loc_4:* = new MD5();
            _loc_3.writeBytes(_loc_4.hash(param2), 0, _loc_4.getHashSize());
            var _loc_5:* = new SHA1();
            _loc_3.writeBytes(_loc_5.hash(param2), 0, _loc_5.getHashSize());
            _loc_3.position = 0;
            var _loc_6:* = new ByteArray();
            this.key.sign(_loc_3, _loc_6, _loc_3.bytesAvailable);
            _loc_6.position = 0;
            return _loc_6;
        }// end function

        public function getConnectionStates() : Object
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            if (this.masterSecret != null)
            {
                _loc_1 = new ByteArray();
                _loc_1.writeBytes(this.serverRandom, 0, this.serverRandom.length);
                _loc_1.writeBytes(this.clientRandom, 0, this.clientRandom.length);
                _loc_2 = new TLSPRF(this.masterSecret, "key expansion", _loc_1);
                _loc_3 = new ByteArray();
                _loc_2.nextBytes(_loc_3, this.hashSize);
                _loc_4 = new ByteArray();
                _loc_2.nextBytes(_loc_4, this.hashSize);
                _loc_5 = new ByteArray();
                _loc_2.nextBytes(_loc_5, this.keyMaterialLength);
                _loc_6 = new ByteArray();
                _loc_2.nextBytes(_loc_6, this.keyMaterialLength);
                _loc_7 = new ByteArray();
                _loc_2.nextBytes(_loc_7, this.IVSize);
                _loc_8 = new ByteArray();
                _loc_2.nextBytes(_loc_8, this.IVSize);
                _loc_9 = new TLSConnectionState(this.bulkCipher, this.cipherType, this.macAlgorithm, _loc_3, _loc_5, _loc_7);
                _loc_10 = new TLSConnectionState(this.bulkCipher, this.cipherType, this.macAlgorithm, _loc_4, _loc_6, _loc_8);
                if (this.entity == TLSEngine.CLIENT)
                {
                    return {read:_loc_10, write:_loc_9};
                }
                return {read:_loc_9, write:_loc_10};
            }
            else
            {
            }
            return {read:new TLSConnectionState(), write:new TLSConnectionState()};
        }// end function

    }
}
