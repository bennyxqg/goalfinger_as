package com.hurlant.crypto.cert
{
    import com.hurlant.crypto.hash.*;
    import com.hurlant.crypto.rsa.*;
    import com.hurlant.util.*;
    import com.hurlant.util.der.*;
    import flash.utils.*;

    public class X509Certificate extends Object
    {
        private var _loaded:Boolean;
        private var _param:Object;
        private var _obj:Object;

        public function X509Certificate(param1)
        {
            this._loaded = false;
            this._param = param1;
            return;
        }// end function

        private function load() : void
        {
            var _loc_2:* = null;
            if (this._loaded)
            {
                return;
            }
            var _loc_1:* = this._param;
            if (_loc_1 is String)
            {
                _loc_2 = PEM.readCertIntoArray(_loc_1 as String);
            }
            else if (_loc_1 is ByteArray)
            {
                _loc_2 = _loc_1;
            }
            if (_loc_2 != null)
            {
                this._obj = DER.parse(_loc_2, Type.TLS_CERT);
                this._loaded = true;
            }
            else
            {
                throw new Error("Invalid x509 Certificate parameter: " + _loc_1);
            }
            return;
        }// end function

        public function isSigned(param1:X509CertificateCollection, param2:X509CertificateCollection, param3:Date = null) : Boolean
        {
            this.load();
            if (param3 == null)
            {
                param3 = new Date();
            }
            var _loc_4:* = this.getNotBefore();
            var _loc_5:* = this.getNotAfter();
            if (param3.getTime() < _loc_4.getTime())
            {
                return false;
            }
            if (param3.getTime() > _loc_5.getTime())
            {
                return false;
            }
            var _loc_6:* = this.getIssuerPrincipal();
            var _loc_7:* = param2.getCertificate(_loc_6);
            var _loc_8:* = false;
            if (_loc_7 == null)
            {
                _loc_7 = param1.getCertificate(_loc_6);
                if (_loc_7 == null)
                {
                    return false;
                }
            }
            else
            {
                _loc_8 = true;
            }
            if (_loc_7 == this)
            {
                return false;
            }
            if (!(_loc_8 && _loc_7.isSelfSigned(param3)) && !_loc_7.isSigned(param1, param2, param3))
            {
                return false;
            }
            var _loc_9:* = _loc_7.getPublicKey();
            return this.verifyCertificate(_loc_9);
        }// end function

        public function isSelfSigned(param1:Date) : Boolean
        {
            this.load();
            var _loc_2:* = this.getPublicKey();
            return this.verifyCertificate(_loc_2);
        }// end function

        private function verifyCertificate(param1:RSAKey) : Boolean
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_2:* = this.getAlgorithmIdentifier();
            switch(_loc_2)
            {
                case OID.SHA1_WITH_RSA_ENCRYPTION:
                {
                    _loc_3 = new SHA1();
                    _loc_4 = OID.SHA1_ALGORITHM;
                    break;
                }
                case OID.MD2_WITH_RSA_ENCRYPTION:
                {
                    _loc_3 = new MD2();
                    _loc_4 = OID.MD2_ALGORITHM;
                    break;
                }
                case OID.MD5_WITH_RSA_ENCRYPTION:
                {
                    _loc_3 = new MD5();
                    _loc_4 = OID.MD5_ALGORITHM;
                    break;
                }
                default:
                {
                    return false;
                    break;
                }
            }
            var _loc_5:* = this._obj.signedCertificate_bin;
            var _loc_6:* = new ByteArray();
            param1.verify(this._obj.encrypted, _loc_6, this._obj.encrypted.length);
            _loc_6.position = 0;
            _loc_5 = _loc_3.hash(_loc_5);
            var _loc_7:* = DER.parse(_loc_6, Type.RSA_SIGNATURE);
            if (_loc_7.algorithm.algorithmId.toString() != _loc_4)
            {
                return false;
            }
            if (!ArrayUtil.equals(_loc_7.hash, _loc_5))
            {
                return false;
            }
            return true;
        }// end function

        private function signCertificate(param1:RSAKey, param2:String) : ByteArray
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            switch(param2)
            {
                case OID.SHA1_WITH_RSA_ENCRYPTION:
                {
                    _loc_3 = new SHA1();
                    _loc_4 = OID.SHA1_ALGORITHM;
                    break;
                }
                case OID.MD2_WITH_RSA_ENCRYPTION:
                {
                    _loc_3 = new MD2();
                    _loc_4 = OID.MD2_ALGORITHM;
                    break;
                }
                case OID.MD5_WITH_RSA_ENCRYPTION:
                {
                    _loc_3 = new MD5();
                    _loc_4 = OID.MD5_ALGORITHM;
                    break;
                }
                default:
                {
                    return null;
                    break;
                }
            }
            var _loc_5:* = this._obj.signedCertificate_bin;
            _loc_5 = _loc_3.hash(_loc_5);
            var _loc_6:* = new Sequence();
            _loc_6[0] = new Sequence();
            _loc_6[0][0] = new ObjectIdentifier(0, 0, _loc_4);
            _loc_6[0][1] = null;
            _loc_6[1] = new ByteString();
            _loc_6[1].writeBytes(_loc_5);
            _loc_5 = _loc_6.toDER();
            var _loc_7:* = new ByteArray();
            param1.sign(_loc_5, _loc_7, _loc_5.length);
            return _loc_7;
        }// end function

        public function getPublicKey() : RSAKey
        {
            this.load();
            var _loc_1:* = this._obj.signedCertificate.subjectPublicKeyInfo.subjectPublicKey as ByteArray;
            _loc_1.position = 0;
            var _loc_2:* = DER.parse(_loc_1, [{name:"N"}, {name:"E"}]);
            return new RSAKey(_loc_2.N, _loc_2.E.valueOf());
        }// end function

        public function getSubjectPrincipal() : String
        {
            this.load();
            return Base64.encodeByteArray(this._obj.signedCertificate.subject_bin);
        }// end function

        public function getIssuerPrincipal() : String
        {
            this.load();
            return Base64.encodeByteArray(this._obj.signedCertificate.issuer_bin);
        }// end function

        public function getAlgorithmIdentifier() : String
        {
            return this._obj.algorithmIdentifier.algorithmId.toString();
        }// end function

        public function getNotBefore() : Date
        {
            return this._obj.signedCertificate.validity.notBefore.date;
        }// end function

        public function getNotAfter() : Date
        {
            return this._obj.signedCertificate.validity.notAfter.date;
        }// end function

        public function getCommonName() : String
        {
            var _loc_1:* = this._obj.signedCertificate.subject;
            return (_loc_1.findAttributeValue(OID.COMMON_NAME) as PrintableString).getString();
        }// end function

    }
}
