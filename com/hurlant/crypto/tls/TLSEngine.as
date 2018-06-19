package com.hurlant.crypto.tls
{
    import com.hurlant.crypto.cert.*;
    import com.hurlant.crypto.prng.*;
    import com.hurlant.util.*;
    import flash.events.*;
    import flash.utils.*;

    public class TLSEngine extends EventDispatcher
    {
        public var protocol_version:uint;
        private var _entity:uint;
        private var _config:TLSConfig;
        private var _state:uint;
        private var _securityParameters:ISecurityParameters;
        private var _currentReadState:IConnectionState;
        private var _currentWriteState:IConnectionState;
        private var _pendingReadState:IConnectionState;
        private var _pendingWriteState:IConnectionState;
        private var _handshakePayloads:ByteArray;
        private var _handshakeRecords:ByteArray;
        private var _iStream:IDataInput;
        private var _oStream:IDataOutput;
        private var _store:X509CertificateCollection;
        private var _otherCertificate:X509Certificate;
        private var _otherIdentity:String;
        private var _myCertficate:X509Certificate;
        private var _myIdentity:String;
        private var _packetQueue:Array;
        private var protocolHandlers:Object;
        private var handshakeHandlersServer:Object;
        private var handshakeHandlersClient:Object;
        private var _entityHandshakeHandlers:Object;
        private var _handshakeCanContinue:Boolean = true;
        private var _handshakeQueue:Array;
        private var sendClientCert:Boolean = false;
        private var _writeScheduler:uint;
        public static const SERVER:uint = 0;
        public static const CLIENT:uint = 1;
        private static const PROTOCOL_HANDSHAKE:uint = 22;
        private static const PROTOCOL_ALERT:uint = 21;
        private static const PROTOCOL_CHANGE_CIPHER_SPEC:uint = 20;
        private static const PROTOCOL_APPLICATION_DATA:uint = 23;
        private static const STATE_NEW:uint = 0;
        private static const STATE_NEGOTIATING:uint = 1;
        private static const STATE_READY:uint = 2;
        private static const STATE_CLOSED:uint = 3;
        private static const HANDSHAKE_HELLO_REQUEST:uint = 0;
        private static const HANDSHAKE_CLIENT_HELLO:uint = 1;
        private static const HANDSHAKE_SERVER_HELLO:uint = 2;
        private static const HANDSHAKE_CERTIFICATE:uint = 11;
        private static const HANDSHAKE_SERVER_KEY_EXCHANGE:uint = 12;
        private static const HANDSHAKE_CERTIFICATE_REQUEST:uint = 13;
        private static const HANDSHAKE_HELLO_DONE:uint = 14;
        private static const HANDSHAKE_CERTIFICATE_VERIFY:uint = 15;
        private static const HANDSHAKE_CLIENT_KEY_EXCHANGE:uint = 16;
        private static const HANDSHAKE_FINISHED:uint = 20;

        public function TLSEngine(param1:TLSConfig, param2:IDataInput, param3:IDataOutput, param4:String = null)
        {
            this._packetQueue = [];
            this.protocolHandlers = {23:this.parseApplicationData, 22:this.parseHandshake, 21:this.parseAlert, 20:this.parseChangeCipherSpec};
            this.handshakeHandlersServer = {0:this.notifyStateError, 1:this.parseHandshakeClientHello, 2:this.notifyStateError, 11:this.loadCertificates, 12:this.notifyStateError, 13:this.notifyStateError, 14:this.notifyStateError, 15:this.notifyStateError, 16:this.parseHandshakeClientKeyExchange, 20:this.verifyHandshake};
            this.handshakeHandlersClient = {0:this.parseHandshakeHello, 1:this.notifyStateError, 2:this.parseHandshakeServerHello, 11:this.loadCertificates, 12:this.parseServerKeyExchange, 13:this.setStateRespondWithCertificate, 14:this.sendClientAck, 15:this.notifyStateError, 16:this.notifyStateError, 20:this.verifyHandshake};
            this._handshakeQueue = [];
            this._entity = param1.entity;
            this._config = param1;
            this._iStream = param2;
            this._oStream = param3;
            this._otherIdentity = param4;
            this._state = STATE_NEW;
            this._entityHandshakeHandlers = this._entity == CLIENT ? (this.handshakeHandlersClient) : (this.handshakeHandlersServer);
            if (this._config.version == SSLSecurityParameters.PROTOCOL_VERSION)
            {
                this._securityParameters = new SSLSecurityParameters(this._entity);
            }
            else
            {
                this._securityParameters = new TLSSecurityParameters(this._entity, this._config.certificate, this._config.privateKey);
            }
            this.protocol_version = this._config.version;
            var _loc_5:* = this._securityParameters.getConnectionStates();
            this._currentReadState = _loc_5.read;
            this._currentWriteState = _loc_5.write;
            this._handshakePayloads = new ByteArray();
            this._store = new X509CertificateCollection();
            return;
        }// end function

        public function get peerCertificate() : X509Certificate
        {
            return this._otherCertificate;
        }// end function

        public function start() : void
        {
            if (this._entity == CLIENT)
            {
                try
                {
                    this.startHandshake();
                }
                catch (e:TLSError)
                {
                    handleTLSError(e);
                }
            }
            return;
        }// end function

        public function dataAvailable(param1 = null) : void
        {
            var e:* = param1;
            if (this._state == STATE_CLOSED)
            {
                return;
            }
            try
            {
                this.parseRecord(this._iStream);
            }
            catch (e:TLSError)
            {
                handleTLSError(e);
                ;
            }
            catch (e:Error)
            {
                _state = STATE_CLOSED;
                dispatchEvent(new Event(Event.CLOSE));
            }
            return;
        }// end function

        public function close(param1:TLSError = null) : void
        {
            if (this._state == STATE_CLOSED)
            {
                return;
            }
            var _loc_2:* = new ByteArray();
            if (param1 == null && this._state != STATE_READY)
            {
                _loc_2[0] = 1;
                _loc_2[1] = TLSError.user_canceled;
                this.sendRecord(PROTOCOL_ALERT, _loc_2);
            }
            _loc_2[0] = 2;
            if (param1 == null)
            {
                _loc_2[1] = TLSError.close_notify;
            }
            else
            {
                _loc_2[1] = param1.errorID;
            }
            this.sendRecord(PROTOCOL_ALERT, _loc_2);
            this._state = STATE_CLOSED;
            dispatchEvent(new Event(Event.CLOSE));
            return;
        }// end function

        private function parseRecord(param1:IDataInput) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            while (this._state != STATE_CLOSED && param1.bytesAvailable > 4)
            {
                
                if (this._packetQueue.length > 0)
                {
                    _loc_7 = this._packetQueue.shift();
                    _loc_2 = _loc_7.data;
                    if (param1.bytesAvailable + _loc_2.length >= _loc_7.length)
                    {
                        param1.readBytes(_loc_2, _loc_2.length, _loc_7.length - _loc_2.length);
                        this.parseOneRecord(_loc_7.type, _loc_7.length, _loc_2);
                        continue;
                    }
                    else
                    {
                        param1.readBytes(_loc_2, _loc_2.length, param1.bytesAvailable);
                        this._packetQueue.push(_loc_7);
                        continue;
                    }
                }
                _loc_3 = param1.readByte();
                _loc_4 = param1.readShort();
                _loc_5 = param1.readShort();
                if (_loc_5 > 16384 + 2048)
                {
                    throw new TLSError("Excessive TLS Record length: " + _loc_5, TLSError.record_overflow);
                }
                if (_loc_4 != this._securityParameters.version)
                {
                    throw new TLSError("Unsupported TLS version: " + _loc_4.toString(16), TLSError.protocol_version);
                }
                _loc_2 = new ByteArray();
                _loc_6 = Math.min(param1.bytesAvailable, _loc_5);
                param1.readBytes(_loc_2, 0, _loc_6);
                if (_loc_6 == _loc_5)
                {
                    this.parseOneRecord(_loc_3, _loc_5, _loc_2);
                    continue;
                }
                this._packetQueue.push({type:_loc_3, length:_loc_5, data:_loc_2});
            }
            return;
        }// end function

        private function parseOneRecord(param1:uint, param2:uint, param3:ByteArray) : void
        {
            param3 = this._currentReadState.decrypt(param1, param2, param3);
            if (param3.length > 16384)
            {
                throw new TLSError("Excessive Decrypted TLS Record length: " + param3.length, TLSError.record_overflow);
            }
            if (this.protocolHandlers.hasOwnProperty(param1))
            {
                while (param3 != null)
                {
                    
                    var _loc_4:* = this.protocolHandlers;
                    param3 = _loc_4[param1](param3);
                }
            }
            else
            {
                throw new TLSError("Unsupported TLS Record Content Type: " + param1.toString(16), TLSError.unexpected_message);
            }
            return;
        }// end function

        private function startHandshake() : void
        {
            this._state = STATE_NEGOTIATING;
            this.sendClientHello();
            return;
        }// end function

        private function parseHandshake(param1:ByteArray) : ByteArray
        {
            var _loc_6:* = null;
            if (param1.length < 4)
            {
                return null;
            }
            param1.position = 0;
            var _loc_2:* = param1;
            var _loc_3:* = _loc_2.readUnsignedByte();
            var _loc_4:* = _loc_2.readUnsignedByte();
            var _loc_5:* = _loc_2.readUnsignedByte() << 16 | _loc_2.readUnsignedShort();
            if ((_loc_2.readUnsignedByte() << 16 | _loc_2.readUnsignedShort()) + 4 > _loc_2.length)
            {
                return null;
            }
            if (_loc_3 != HANDSHAKE_FINISHED)
            {
                this._handshakePayloads.writeBytes(param1, 0, _loc_5 + 4);
            }
            if (this._entityHandshakeHandlers.hasOwnProperty(_loc_3))
            {
                if (this._entityHandshakeHandlers[_loc_3] is Function)
                {
                    var _loc_7:* = this._entityHandshakeHandlers;
                    _loc_7[_loc_3](_loc_2);
                }
            }
            else
            {
                throw new TLSError("Unimplemented or unknown handshake type!", TLSError.internal_error);
            }
            if (_loc_5 + 4 < _loc_2.length)
            {
                _loc_6 = new ByteArray();
                _loc_6.writeBytes(param1, _loc_5 + 4, _loc_2.length - (_loc_5 + 4));
                return _loc_6;
            }
            return null;
        }// end function

        private function notifyStateError(param1:ByteArray) : void
        {
            throw new TLSError("Invalid handshake state for a TLS Entity type of " + this._entity, TLSError.internal_error);
        }// end function

        private function parseClientKeyExchange(param1:ByteArray) : void
        {
            throw new TLSError("ClientKeyExchange is currently unimplemented!", TLSError.internal_error);
        }// end function

        private function parseServerKeyExchange(param1:ByteArray) : void
        {
            throw new TLSError("ServerKeyExchange is currently unimplemented!", TLSError.internal_error);
        }// end function

        private function verifyHandshake(param1:ByteArray) : void
        {
            var _loc_2:* = new ByteArray();
            if (this._securityParameters.version == SSLSecurityParameters.PROTOCOL_VERSION)
            {
                param1.readBytes(_loc_2, 0, 36);
            }
            else
            {
                param1.readBytes(_loc_2, 0, 12);
            }
            var _loc_3:* = this._securityParameters.computeVerifyData(1 - this._entity, this._handshakePayloads);
            if (ArrayUtil.equals(_loc_2, _loc_3))
            {
                this._state = STATE_READY;
                dispatchEvent(new TLSEvent(TLSEvent.READY));
            }
            else
            {
                throw new TLSError("Invalid Finished mac.", TLSError.bad_record_mac);
            }
            return;
        }// end function

        private function parseHandshakeHello(param1:ByteArray) : void
        {
            if (this._state != STATE_READY)
            {
                return;
            }
            this._handshakePayloads = new ByteArray();
            this.startHandshake();
            return;
        }// end function

        private function parseHandshakeClientKeyExchange(param1:ByteArray) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            if (this._securityParameters.useRSA)
            {
                _loc_2 = param1.readShort();
                _loc_3 = new ByteArray();
                param1.readBytes(_loc_3, 0, _loc_2);
                _loc_4 = new ByteArray();
                this._config.privateKey.decrypt(_loc_3, _loc_4, _loc_2);
                this._securityParameters.setPreMasterSecret(_loc_4);
                _loc_5 = this._securityParameters.getConnectionStates();
                this._pendingReadState = _loc_5.read;
                this._pendingWriteState = _loc_5.write;
            }
            else
            {
                throw new TLSError("parseHandshakeClientKeyExchange not implemented for DH modes.", TLSError.internal_error);
            }
            return;
        }// end function

        private function parseHandshakeServerHello(param1:IDataInput) : void
        {
            var _loc_2:* = param1.readShort();
            if (_loc_2 != this._securityParameters.version)
            {
                throw new TLSError("Unsupported TLS version: " + _loc_2.toString(16), TLSError.protocol_version);
            }
            var _loc_3:* = new ByteArray();
            param1.readBytes(_loc_3, 0, 32);
            var _loc_4:* = param1.readByte();
            var _loc_5:* = new ByteArray();
            if (_loc_4 > 0)
            {
                param1.readBytes(_loc_5, 0, _loc_4);
            }
            this._securityParameters.setCipher(param1.readShort());
            this._securityParameters.setCompression(param1.readByte());
            this._securityParameters.setServerRandom(_loc_3);
            return;
        }// end function

        private function parseHandshakeClientHello(param1:IDataInput) : void
        {
            var _loc_2:* = null;
            var _loc_14:* = 0;
            var _loc_15:* = 0;
            var _loc_16:* = 0;
            var _loc_17:* = null;
            var _loc_3:* = param1.readShort();
            if (_loc_3 != this._securityParameters.version)
            {
                throw new TLSError("Unsupported TLS version: " + _loc_3.toString(16), TLSError.protocol_version);
            }
            var _loc_4:* = new ByteArray();
            param1.readBytes(_loc_4, 0, 32);
            var _loc_5:* = param1.readByte();
            var _loc_6:* = new ByteArray();
            if (_loc_5 > 0)
            {
                param1.readBytes(_loc_6, 0, _loc_5);
            }
            var _loc_7:* = [];
            var _loc_8:* = param1.readShort();
            var _loc_9:* = 0;
            while (_loc_9 < _loc_8 / 2)
            {
                
                _loc_7.push(param1.readShort());
                _loc_9 = _loc_9 + 1;
            }
            var _loc_10:* = [];
            var _loc_11:* = param1.readByte();
            _loc_9 = 0;
            while (_loc_9 < _loc_11)
            {
                
                _loc_10.push(param1.readByte());
                _loc_9 = _loc_9 + 1;
            }
            _loc_2 = {random:_loc_4, session:_loc_6, suites:_loc_7, compressions:_loc_10};
            var _loc_12:* = 2 + 32 + 1 + _loc_5 + 2 + _loc_8 + 1 + _loc_11;
            var _loc_13:* = [];
            if (_loc_12 < length)
            {
                _loc_14 = param1.readShort();
                while (_loc_14 > 0)
                {
                    
                    _loc_15 = param1.readShort();
                    _loc_16 = param1.readShort();
                    _loc_17 = new ByteArray();
                    param1.readBytes(_loc_17, 0, _loc_16);
                    _loc_14 = _loc_14 - (4 + _loc_16);
                    _loc_13.push({type:_loc_15, length:_loc_16, data:_loc_17});
                }
            }
            _loc_2.ext = _loc_13;
            this.sendServerHello(_loc_2);
            this.sendCertificate();
            this.sendServerHelloDone();
            return;
        }// end function

        private function sendClientHello() : void
        {
            var _loc_1:* = new ByteArray();
            _loc_1.writeShort(this._securityParameters.version);
            var _loc_2:* = new Random();
            var _loc_3:* = new ByteArray();
            _loc_2.nextBytes(_loc_3, 32);
            this._securityParameters.setClientRandom(_loc_3);
            _loc_1.writeBytes(_loc_3, 0, 32);
            _loc_1.writeByte(32);
            _loc_2.nextBytes(_loc_1, 32);
            var _loc_4:* = this._config.cipherSuites;
            _loc_1.writeShort(2 * _loc_4.length);
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4.length)
            {
                
                _loc_1.writeShort(_loc_4[_loc_5]);
                _loc_5++;
            }
            _loc_4 = this._config.compressions;
            _loc_1.writeByte(_loc_4.length);
            _loc_5 = 0;
            while (_loc_5 < _loc_4.length)
            {
                
                _loc_1.writeByte(_loc_4[_loc_5]);
                _loc_5++;
            }
            _loc_1.position = 0;
            this.sendHandshake(HANDSHAKE_CLIENT_HELLO, _loc_1.length, _loc_1);
            return;
        }// end function

        private function findMatch(param1:Array, param2:Array) : int
        {
            var _loc_4:* = 0;
            var _loc_3:* = 0;
            while (_loc_3 < param1.length)
            {
                
                _loc_4 = param1[_loc_3];
                if (param2.indexOf(_loc_4) > -1)
                {
                    return _loc_4;
                }
                _loc_3++;
            }
            return -1;
        }// end function

        private function sendServerHello(param1:Object) : void
        {
            var _loc_2:* = this.findMatch(this._config.cipherSuites, param1.suites);
            if (_loc_2 == -1)
            {
                throw new TLSError("No compatible cipher found.", TLSError.handshake_failure);
            }
            this._securityParameters.setCipher(_loc_2);
            var _loc_3:* = this.findMatch(this._config.compressions, param1.compressions);
            if (_loc_3 == 1)
            {
                throw new TLSError("No compatible compression method found.", TLSError.handshake_failure);
            }
            this._securityParameters.setCompression(_loc_3);
            this._securityParameters.setClientRandom(param1.random);
            var _loc_4:* = new ByteArray();
            _loc_4.writeShort(this._securityParameters.version);
            var _loc_5:* = new Random();
            var _loc_6:* = new ByteArray();
            _loc_5.nextBytes(_loc_6, 32);
            this._securityParameters.setServerRandom(_loc_6);
            _loc_4.writeBytes(_loc_6, 0, 32);
            _loc_4.writeByte(32);
            _loc_5.nextBytes(_loc_4, 32);
            _loc_4.writeShort(param1.suites[0]);
            _loc_4.writeByte(param1.compressions[0]);
            _loc_4.position = 0;
            this.sendHandshake(HANDSHAKE_SERVER_HELLO, _loc_4.length, _loc_4);
            return;
        }// end function

        private function setStateRespondWithCertificate(param1:ByteArray = null) : void
        {
            this.sendClientCert = true;
            return;
        }// end function

        private function sendCertificate(param1:ByteArray = null) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_2:* = this._config.certificate;
            var _loc_5:* = new ByteArray();
            if (_loc_2 != null)
            {
                _loc_3 = _loc_2.length;
                _loc_4 = _loc_2.length + 3;
                _loc_5.writeByte(_loc_4 >> 16);
                _loc_5.writeShort(_loc_4 & 65535);
                _loc_5.writeByte(_loc_3 >> 16);
                _loc_5.writeShort(_loc_3 & 65535);
                _loc_5.writeBytes(_loc_2);
            }
            else
            {
                _loc_5.writeShort(0);
                _loc_5.writeByte(0);
            }
            _loc_5.position = 0;
            this.sendHandshake(HANDSHAKE_CERTIFICATE, _loc_5.length, _loc_5);
            return;
        }// end function

        private function sendCertificateVerify() : void
        {
            var _loc_1:* = new ByteArray();
            var _loc_2:* = this._securityParameters.computeCertificateVerify(this._entity, this._handshakePayloads);
            _loc_2.position = 0;
            this.sendHandshake(HANDSHAKE_CERTIFICATE_VERIFY, _loc_2.length, _loc_2);
            return;
        }// end function

        private function sendServerHelloDone() : void
        {
            var _loc_1:* = new ByteArray();
            this.sendHandshake(HANDSHAKE_HELLO_DONE, _loc_1.length, _loc_1);
            return;
        }// end function

        private function sendClientKeyExchange() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (this._securityParameters.useRSA)
            {
                _loc_1 = new ByteArray();
                _loc_1.writeShort(this._securityParameters.version);
                _loc_2 = new Random();
                _loc_2.nextBytes(_loc_1, 46);
                _loc_1.position = 0;
                _loc_3 = new ByteArray();
                _loc_3.writeBytes(_loc_1, 0, _loc_1.length);
                _loc_3.position = 0;
                this._securityParameters.setPreMasterSecret(_loc_3);
                _loc_4 = new ByteArray();
                this._otherCertificate.getPublicKey().encrypt(_loc_3, _loc_4, _loc_3.length);
                _loc_4.position = 0;
                _loc_5 = new ByteArray();
                if (this._securityParameters.version > 768)
                {
                    _loc_5.writeShort(_loc_4.length);
                }
                _loc_5.writeBytes(_loc_4, 0, _loc_4.length);
                _loc_5.position = 0;
                this.sendHandshake(HANDSHAKE_CLIENT_KEY_EXCHANGE, _loc_5.length, _loc_5);
                _loc_6 = this._securityParameters.getConnectionStates();
                this._pendingReadState = _loc_6.read;
                this._pendingWriteState = _loc_6.write;
            }
            else
            {
                throw new TLSError("Non-RSA Client Key Exchange not implemented.", TLSError.internal_error);
            }
            return;
        }// end function

        private function sendFinished() : void
        {
            var _loc_1:* = this._securityParameters.computeVerifyData(this._entity, this._handshakePayloads);
            _loc_1.position = 0;
            this.sendHandshake(HANDSHAKE_FINISHED, _loc_1.length, _loc_1);
            return;
        }// end function

        private function sendHandshake(param1:uint, param2:uint, param3:IDataInput) : void
        {
            var _loc_4:* = new ByteArray();
            _loc_4.writeByte(param1);
            _loc_4.writeByte(0);
            _loc_4.writeShort(param2);
            param3.readBytes(_loc_4, _loc_4.position, param2);
            this._handshakePayloads.writeBytes(_loc_4, 0, _loc_4.length);
            this.sendRecord(PROTOCOL_HANDSHAKE, _loc_4);
            return;
        }// end function

        private function sendChangeCipherSpec() : void
        {
            var _loc_1:* = new ByteArray();
            _loc_1[0] = 1;
            this.sendRecord(PROTOCOL_CHANGE_CIPHER_SPEC, _loc_1);
            this._currentWriteState = this._pendingWriteState;
            this._pendingWriteState = null;
            return;
        }// end function

        public function sendApplicationData(param1:ByteArray, param2:uint = 0, param3:uint = 0) : void
        {
            var _loc_4:* = new ByteArray();
            var _loc_5:* = param3;
            if (param3 == 0)
            {
                _loc_5 = param1.length;
            }
            while (_loc_5 > 16384)
            {
                
                _loc_4.position = 0;
                _loc_4.writeBytes(param1, param2, 16384);
                _loc_4.position = 0;
                this.sendRecord(PROTOCOL_APPLICATION_DATA, _loc_4);
                _loc_4.length = 0;
                param2 = param2 + 16384;
                _loc_5 = _loc_5 - 16384;
            }
            _loc_4.position = 0;
            _loc_4.writeBytes(param1, param2, _loc_5);
            _loc_4.position = 0;
            this.sendRecord(PROTOCOL_APPLICATION_DATA, _loc_4);
            return;
        }// end function

        private function sendRecord(param1:uint, param2:ByteArray) : void
        {
            param2 = this._currentWriteState.encrypt(param1, param2);
            this._oStream.writeByte(param1);
            this._oStream.writeShort(this._securityParameters.version);
            this._oStream.writeShort(param2.length);
            this._oStream.writeBytes(param2, 0, param2.length);
            this.scheduleWrite();
            return;
        }// end function

        private function scheduleWrite() : void
        {
            if (this._writeScheduler != 0)
            {
                return;
            }
            this._writeScheduler = setTimeout(this.commitWrite, 0);
            return;
        }// end function

        private function commitWrite() : void
        {
            clearTimeout(this._writeScheduler);
            this._writeScheduler = 0;
            if (this._state != STATE_CLOSED)
            {
                dispatchEvent(new ProgressEvent(ProgressEvent.SOCKET_DATA));
            }
            return;
        }// end function

        private function sendClientAck(param1:ByteArray) : void
        {
            if (this._handshakeCanContinue)
            {
                if (this.sendClientCert)
                {
                    this.sendCertificate();
                }
                this.sendClientKeyExchange();
                if (this._config.certificate != null)
                {
                    this.sendCertificateVerify();
                }
                this.sendChangeCipherSpec();
                this.sendFinished();
            }
            return;
        }// end function

        private function loadCertificates(param1:ByteArray) : void
        {
            var _loc_7:* = false;
            var _loc_8:* = 0;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_2:* = param1.readByte();
            var _loc_3:* = _loc_2 << 16 | param1.readShort();
            var _loc_4:* = [];
            while (_loc_3 > 0)
            {
                
                _loc_2 = param1.readByte();
                _loc_8 = _loc_2 << 16 | param1.readShort();
                _loc_9 = new ByteArray();
                param1.readBytes(_loc_9, 0, _loc_8);
                _loc_4.push(_loc_9);
                _loc_3 = _loc_3 - (3 + _loc_8);
            }
            var _loc_5:* = null;
            var _loc_6:* = 0;
            while (_loc_6 < _loc_4.length)
            {
                
                _loc_10 = new X509Certificate(_loc_4[_loc_6]);
                this._store.addCertificate(_loc_10);
                if (_loc_5 == null)
                {
                    _loc_5 = _loc_10;
                }
                _loc_6++;
            }
            if (this._config.trustAllCertificates)
            {
                _loc_7 = true;
            }
            else if (this._config.trustSelfSignedCertificates)
            {
                _loc_7 = _loc_5.isSelfSigned(new Date());
            }
            else
            {
                _loc_7 = _loc_5.isSigned(this._store, this._config.CAStore);
            }
            if (_loc_7)
            {
                if (this._otherIdentity == null || this._config.ignoreCommonNameMismatch)
                {
                    this._otherCertificate = _loc_5;
                }
                else
                {
                    _loc_11 = _loc_5.getCommonName();
                    _loc_12 = new RegExp(_loc_11.replace(/[\^\\\-$.[\]|()?+{}]/g, "\\$&").replace(/\*/g, "[^.]+"), "gi");
                    if (_loc_12.exec(this._otherIdentity))
                    {
                        this._otherCertificate = _loc_5;
                    }
                    else if (this._config.promptUserForAcceptCert)
                    {
                        this._handshakeCanContinue = false;
                        dispatchEvent(new TLSEvent(TLSEvent.PROMPT_ACCEPT_CERT));
                    }
                    else
                    {
                        throw new TLSError("Invalid common name: " + _loc_5.getCommonName() + ", expected " + this._otherIdentity, TLSError.bad_certificate);
                    }
                }
            }
            else if (this._config.promptUserForAcceptCert)
            {
                this._handshakeCanContinue = false;
                dispatchEvent(new TLSEvent(TLSEvent.PROMPT_ACCEPT_CERT));
            }
            else
            {
                throw new TLSError("Cannot verify certificate", TLSError.bad_certificate);
            }
            return;
        }// end function

        public function acceptPeerCertificate() : void
        {
            this._handshakeCanContinue = true;
            this.sendClientAck(null);
            return;
        }// end function

        public function rejectPeerCertificate() : void
        {
            throw new TLSError("Peer certificate not accepted!", TLSError.bad_certificate);
        }// end function

        private function parseAlert(param1:ByteArray) : void
        {
            this.close();
            return;
        }// end function

        private function parseChangeCipherSpec(param1:ByteArray) : void
        {
            param1.readUnsignedByte();
            if (this._pendingReadState == null)
            {
                throw new TLSError("Not ready to Change Cipher Spec, damnit.", TLSError.unexpected_message);
            }
            this._currentReadState = this._pendingReadState;
            this._pendingReadState = null;
            return;
        }// end function

        private function parseApplicationData(param1:ByteArray) : void
        {
            if (this._state != STATE_READY)
            {
                throw new TLSError("Too soon for data!", TLSError.unexpected_message);
            }
            dispatchEvent(new TLSEvent(TLSEvent.DATA, param1));
            return;
        }// end function

        private function handleTLSError(param1:TLSError) : void
        {
            this.close(param1);
            return;
        }// end function

    }
}
