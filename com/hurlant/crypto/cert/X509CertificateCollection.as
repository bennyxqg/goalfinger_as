package com.hurlant.crypto.cert
{

    public class X509CertificateCollection extends Object
    {
        private var _map:Object;

        public function X509CertificateCollection()
        {
            this._map = {};
            return;
        }// end function

        public function addPEMCertificate(param1:String, param2:String, param3:String) : void
        {
            this._map[param2] = new X509Certificate(param3);
            return;
        }// end function

        public function addCertificate(param1:X509Certificate) : void
        {
            var _loc_2:* = param1.getSubjectPrincipal();
            this._map[_loc_2] = param1;
            return;
        }// end function

        public function getCertificate(param1:String) : X509Certificate
        {
            return this._map[param1];
        }// end function

    }
}
