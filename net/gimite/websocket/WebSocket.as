package net.gimite.websocket
{
    import com.adobe.net.proxies.*;
    import com.gsolo.encryption.*;
    import com.hurlant.crypto.tls.*;
    import com.hurlant.util.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;

    public class WebSocket extends EventDispatcher
    {
        private var onPong:Function;
        private var id:int;
        private var url:String;
        private var scheme:String;
        private var host:String;
        private var port:uint;
        private var path:String;
        private var origin:String;
        private var requestedProtocols:Array;
        private var cookie:String;
        private var headers:String;
        private var proxyHost:String;
        private var proxyPort:int;
        private var rawSocket:Socket;
        private var tlsSocket:TLSSocket;
        private var tlsConfig:TLSConfig;
        private var socket:Socket;
        private var secureSocket:SecureSocket;
        private var acceptedProtocol:String;
        private var expectedDigest:String;
        private var buffer:ByteArray;
        private var fragmentsBuffer:ByteArray = null;
        private var headerState:int = 0;
        private var readyState:int = 0;
        private var logger:IWebSocketLogger;
        private var useFlashSecureSocket:Boolean = false;
        private static const WEB_SOCKET_GUID:String = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";
        private static const CONNECTING:int = 0;
        private static const OPEN:int = 1;
        private static const CLOSING:int = 2;
        private static const CLOSED:int = 3;
        private static const OPCODE_CONTINUATION:int = 0;
        private static const OPCODE_TEXT:int = 1;
        private static const OPCODE_BINARY:int = 2;
        private static const OPCODE_CLOSE:int = 8;
        private static const OPCODE_PING:int = 9;
        private static const OPCODE_PONG:int = 10;
        private static const STATUS_NORMAL_CLOSURE:int = 1000;
        private static const STATUS_NO_CODE:int = 1005;
        private static const STATUS_CLOSED_ABNORMALLY:int = 1006;
        private static const STATUS_SOCKET_ERROR:int = 2031;
        private static const STATUS_CONNECTION_ERROR:int = 5000;

        public function WebSocket(param1:int, param2:String, param3:Array, param4:String, param5:String, param6:int, param7:String, param8:String, param9:IWebSocketLogger, param10:Boolean)
        {
            var proxySocket:RFC2817Socket;
            var id:* = param1;
            var url:* = param2;
            var protocols:* = param3;
            var origin:* = param4;
            var proxyHost:* = param5;
            var proxyPort:* = param6;
            var cookie:* = param7;
            var headers:* = param8;
            var logger:* = param9;
            var useFlashSecureSocket:* = param10;
            this.buffer = new ByteArray();
            this.logger = logger;
            this.id = id;
            this.url = url;
            var m:* = url.match(/^(\w+):\/\/([^\/:]+)(:(\d+))?(\/.*)?(\?.*)?$/);
            if (!m)
            {
                this.fatal("SYNTAX_ERR: invalid url: " + url);
            }
            this.scheme = m[1];
            this.host = m[2];
            var defaultPort:* = this.scheme == "wss" ? (443) : (80);
            this.port = parseInt(m[4]) || defaultPort;
            this.path = (m[5] || "/") + (m[6] || "");
            this.origin = origin;
            this.requestedProtocols = protocols;
            this.cookie = cookie;
            this.proxyHost = proxyHost;
            this.proxyPort = proxyPort;
            this.useFlashSecureSocket = useFlashSecureSocket;
            Security.loadPolicyFile("xmlsocket://" + this.host + ":" + this.port);
            Security.loadPolicyFile("xmlsocket://gamesparksbetabinaries.blob.core.windows.net");
            this.headers = headers;
            if (proxyHost != null && proxyPort != 0)
            {
                if (this.scheme == "wss")
                {
                    this.fatal("wss with proxy is not supported");
                }
                proxySocket = new RFC2817Socket();
                proxySocket.setProxyInfo(proxyHost, proxyPort);
                proxySocket.addEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
                var _loc_12:* = proxySocket;
                this.socket = proxySocket;
                this.rawSocket = _loc_12;
            }
            else
            {
                this.rawSocket = new Socket();
                if (this.scheme == "wss")
                {
                    if (!useFlashSecureSocket)
                    {
                        this.tlsConfig = new TLSConfig(TLSEngine.CLIENT, null, null, null, null, null, TLSSecurityParameters.PROTOCOL_VERSION);
                        this.tlsConfig.trustAllCertificates = true;
                        this.tlsConfig.ignoreCommonNameMismatch = true;
                        this.tlsSocket = new TLSSocket();
                        this.tlsSocket.addEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
                        this.socket = this.tlsSocket;
                    }
                    else
                    {
                        this.secureSocket = new SecureSocket();
                        this.secureSocket.addEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
                        var _loc_12:* = this.secureSocket;
                        this.socket = this.secureSocket;
                        this.rawSocket = _loc_12;
                    }
                }
                else
                {
                    this.rawSocket.addEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
                    this.socket = this.rawSocket;
                }
            }
            this.rawSocket.addEventListener(Event.CLOSE, this.onSocketClose);
            this.rawSocket.addEventListener(Event.CONNECT, this.onSocketConnect);
            this.rawSocket.addEventListener(IOErrorEvent.IO_ERROR, this.onSocketIoError);
            this.rawSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSocketSecurityError);
            try
            {
                this.rawSocket.connect(this.host, this.port);
            }
            catch (e:Error)
            {
                logger.error("Error on connect: " + e);
            }
            return;
        }// end function

        public function getId() : int
        {
            return this.id;
        }// end function

        public function getReadyState() : int
        {
            return this.readyState;
        }// end function

        public function getAcceptedProtocol() : String
        {
            return this.acceptedProtocol;
        }// end function

        public function send(param1:String) : int
        {
            var data:String;
            var frame:WebSocketFrame;
            var encData:* = param1;
            try
            {
                data = decodeURIComponent(encData);
            }
            catch (ex:URIError)
            {
                logger.error("SYNTAX_ERR: URIError in send()");
                return 0;
            }
            var dataBytes:* = new ByteArray();
            dataBytes.writeUTFBytes(data);
            if (this.readyState == OPEN)
            {
                frame = new WebSocketFrame();
                frame.opcode = OPCODE_TEXT;
                frame.payload = dataBytes;
                if (this.sendFrame(frame))
                {
                    return -1;
                }
                return dataBytes.length;
            }
            else
            {
                if (this.readyState == CLOSING || this.readyState == CLOSED)
                {
                    return dataBytes.length;
                }
                this.fatal("invalid state");
                return 0;
            }
        }// end function

        public function close(param1:int = 1005, param2:String = "", param3:String = "client") : void
        {
            var frame:WebSocketFrame;
            var fireErrorEvent:Boolean;
            var wasClean:Boolean;
            var eventCode:int;
            var code:* = param1;
            var reason:* = param2;
            var origin:* = param3;
            if (code != STATUS_NORMAL_CLOSURE && code != STATUS_NO_CODE && code != STATUS_CONNECTION_ERROR)
            {
                this.logger.error("Fail connection by " + origin + ": code=" + code + " reason=" + reason);
            }
            var closeConnection:* = code == STATUS_CONNECTION_ERROR || origin == "server";
            try
            {
                if (this.readyState == OPEN && code != STATUS_CONNECTION_ERROR)
                {
                    frame = new WebSocketFrame();
                    frame.opcode = OPCODE_CLOSE;
                    frame.payload = new ByteArray();
                    if (origin == "client" && code != STATUS_NO_CODE)
                    {
                        frame.payload.writeShort(code);
                        frame.payload.writeUTFBytes(reason);
                    }
                    this.sendFrame(frame);
                }
                if (closeConnection)
                {
                    this.socket.close();
                }
            }
            catch (ex:Error)
            {
                logger.error("Error: " + ex.message);
            }
            if (closeConnection)
            {
                fireErrorEvent = this.readyState != CONNECTING && code == STATUS_CONNECTION_ERROR;
                this.readyState = CLOSED;
                if (fireErrorEvent)
                {
                    dispatchEvent(new WebSocketEvent("error"));
                }
                wasClean = code != STATUS_CLOSED_ABNORMALLY && code != STATUS_CONNECTION_ERROR;
                eventCode = code == STATUS_CONNECTION_ERROR ? (STATUS_CLOSED_ABNORMALLY) : (code);
                this.dispatchCloseEvent(wasClean, eventCode, reason);
            }
            else
            {
                this.readyState = CLOSING;
            }
            return;
        }// end function

        private function onSocketConnect(event:Event) : void
        {
            if (this.scheme == "wss")
            {
                if (!this.useFlashSecureSocket)
                {
                    this.tlsSocket.startTLS(this.rawSocket, this.host, this.tlsConfig);
                }
            }
            var _loc_2:* = this.scheme == "wss" ? (443) : (80);
            var _loc_3:* = this.host + (this.port == _loc_2 ? ("") : (":" + this.port));
            var _loc_4:* = this.generateKey();
            SHA1.b64pad = "=";
            this.expectedDigest = SHA1.b64_sha1(_loc_4 + WEB_SOCKET_GUID);
            var _loc_5:* = "";
            if (this.requestedProtocols.length > 0)
            {
                _loc_5 = _loc_5 + ("Sec-WebSocket-Protocol: " + this.requestedProtocols.join(",") + "\r\n");
            }
            if (this.headers)
            {
                _loc_5 = _loc_5 + this.headers;
            }
            var _loc_6:* = "GET " + this.path + " HTTP/1.1\r\n" + "Host: " + _loc_3 + "\r\n" + "Upgrade: websocket\r\n" + "Connection: Upgrade\r\n" + "Sec-WebSocket-Key: " + _loc_4 + "\r\n" + "Origin: " + this.origin + "\r\n" + "Sec-WebSocket-Version: 13\r\n" + "Cookie: " + this.cookie + "\r\n" + _loc_5 + "\r\n";
            this.socket.writeUTFBytes(_loc_6);
            this.socket.flush();
            return;
        }// end function

        private function onSocketClose(event:Event) : void
        {
            this.readyState = CLOSED;
            this.dispatchCloseEvent(false, STATUS_CLOSED_ABNORMALLY, "");
            return;
        }// end function

        private function onSocketIoError(event:IOErrorEvent) : void
        {
            var _loc_2:* = null;
            if (this.readyState == CONNECTING)
            {
                _loc_2 = "cannot connect to Web Socket server at " + this.url + " (IoError: " + event.text + ")";
            }
            else
            {
                _loc_2 = "error communicating with Web Socket server at " + this.url + " (IoError: " + event.text + ")";
            }
            this.onConnectionError(_loc_2);
            if ((event.errorID == STATUS_SOCKET_ERROR || event.text.indexOf("2048") >= 0) && this.useFlashSecureSocket == true)
            {
                this.useFlashSecureSocket = false;
                if (this.secureSocket != null)
                {
                    this.logger.error("Server Certificate Status: " + this.secureSocket.serverCertificateStatus);
                }
            }
            return;
        }// end function

        private function onSocketSecurityError(event:SecurityErrorEvent) : void
        {
            var _loc_2:* = null;
            if (this.readyState == CONNECTING)
            {
                _loc_2 = "cannot connect to Web Socket server at " + this.url + " (SecurityError: " + event.text + ")\n" + "make sure the server is running and Flash socket policy file is correctly placed";
            }
            else
            {
                _loc_2 = "error communicating with Web Socket server at " + this.url + " (SecurityError: " + event.text + ")";
            }
            this.onConnectionError(_loc_2);
            return;
        }// end function

        private function onConnectionError(param1:String) : void
        {
            if (this.readyState == CLOSED)
            {
                return;
            }
            this.logger.error(param1);
            this.close(STATUS_CONNECTION_ERROR);
            return;
        }// end function

        private function onSocketData(event:ProgressEvent) : void
        {
            var headerStr:String;
            var frame:WebSocketFrame;
            var code:int;
            var reason:String;
            var pongEvent:WebSocketEvent;
            var data:String;
            var event:* = event;
            var pos:* = this.buffer.length;
            this.socket.readBytes(this.buffer, pos);
            while (pos < this.buffer.length)
            {
                
                if (this.headerState < 4)
                {
                    if ((this.headerState == 0 || this.headerState == 2) && this.buffer[pos] == 13)
                    {
                        var _loc_3:* = this;
                        var _loc_4:* = this.headerState + 1;
                        _loc_3.headerState = _loc_4;
                    }
                    else if ((this.headerState == 1 || this.headerState == 3) && this.buffer[pos] == 10)
                    {
                        var _loc_3:* = this;
                        var _loc_4:* = this.headerState + 1;
                        _loc_3.headerState = _loc_4;
                    }
                    else
                    {
                        this.headerState = 0;
                    }
                    if (this.headerState == 4)
                    {
                        headerStr = this.readUTFBytes(this.buffer, 0, (pos + 1));
                        if (!this.validateHandshake(headerStr))
                        {
                            return;
                        }
                        this.removeBufferBefore((pos + 1));
                        pos;
                        this.readyState = OPEN;
                        this.dispatchEvent(new WebSocketEvent("open"));
                    }
                }
                else
                {
                    frame = this.parseFrame();
                    if (frame)
                    {
                        this.removeBufferBefore(frame.length);
                        pos;
                        if (frame.rsv != 0)
                        {
                            this.close(1002, "RSV must be 0.");
                        }
                        else if (frame.mask)
                        {
                            this.close(1002, "Frame from server must not be masked.");
                        }
                        else if (frame.opcode >= 8 && frame.opcode <= 15 && frame.payload.length >= 126)
                        {
                            this.close(1004, "Payload of control frame must be less than 126 bytes.");
                        }
                        else
                        {
                            switch(frame.opcode)
                            {
                                case OPCODE_CONTINUATION:
                                {
                                    if (this.fragmentsBuffer == null)
                                    {
                                        this.close(1002, "Unexpected continuation frame");
                                    }
                                    else
                                    {
                                        this.fragmentsBuffer.writeBytes(frame.payload);
                                        if (frame.fin)
                                        {
                                            data = this.readUTFBytes(this.fragmentsBuffer, 0, this.fragmentsBuffer.length);
                                            try
                                            {
                                                this.dispatchEvent(new WebSocketEvent("message", data));
                                            }
                                            catch (ex:URIError)
                                            {
                                                close(1007, "URIError while encoding the received data.");
                                            }
                                            this.fragmentsBuffer = null;
                                        }
                                    }
                                    break;
                                }
                                case OPCODE_TEXT:
                                {
                                    if (frame.fin)
                                    {
                                        data = this.readUTFBytes(frame.payload, 0, frame.payload.length);
                                        try
                                        {
                                            this.dispatchEvent(new WebSocketEvent("message", data));
                                        }
                                        catch (ex:URIError)
                                        {
                                            close(1007, "URIError while encoding the received data.");
                                        }
                                    }
                                    else
                                    {
                                        this.fragmentsBuffer = new ByteArray();
                                        this.fragmentsBuffer.writeBytes(frame.payload);
                                    }
                                    break;
                                }
                                case OPCODE_BINARY:
                                {
                                    this.close(1003, "Received binary data, which is not supported.");
                                    break;
                                }
                                case OPCODE_CLOSE:
                                {
                                    code = STATUS_NO_CODE;
                                    reason;
                                    if (frame.payload.length >= 2)
                                    {
                                        frame.payload.endian = Endian.BIG_ENDIAN;
                                        frame.payload.position = 0;
                                        code = frame.payload.readUnsignedShort();
                                        reason = this.readUTFBytes(frame.payload, 2, frame.payload.length - 2);
                                    }
                                    this.close(code, reason, "server");
                                    break;
                                }
                                case OPCODE_PING:
                                {
                                    this.sendPong(frame.payload);
                                    break;
                                }
                                case OPCODE_PONG:
                                {
                                    pongEvent = new WebSocketEvent("pong");
                                    pongEvent.payload = frame.payload;
                                    dispatchEvent(pongEvent);
                                    break;
                                }
                                default:
                                {
                                    this.close(1002, "Received unknown opcode: " + frame.opcode);
                                    break;
                                    break;
                                }
                            }
                        }
                    }
                }
                pos = (pos + 1);
            }
            return;
        }// end function

        public function sendPing(param1:ByteArray) : Boolean
        {
            var _loc_2:* = new WebSocketFrame();
            _loc_2.opcode = OPCODE_PING;
            _loc_2.payload = param1;
            return this.sendFrame(_loc_2);
        }// end function

        private function trim(param1:String) : String
        {
            if (param1 == null)
            {
                return "";
            }
            var _loc_2:* = 0;
            while (this.isWhitespace(param1.charAt(_loc_2)))
            {
                
                _loc_2++;
            }
            var _loc_3:* = param1.length - 1;
            while (this.isWhitespace(param1.charAt(_loc_3)))
            {
                
                _loc_3 = _loc_3 - 1;
            }
            if (_loc_3 >= _loc_2)
            {
                return param1.slice(_loc_2, (_loc_3 + 1));
            }
            return "";
        }// end function

        private function isWhitespace(param1:String) : Boolean
        {
            switch(param1)
            {
                case " ":
                case "\t":
                case "\r":
                case "\n":
                case "\f":
                {
                    return true;
                }
                default:
                {
                    return false;
                    break;
                }
            }
        }// end function

        private function validateHandshake(param1:String) : Boolean
        {
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_2:* = param1.split(/\r\n/);
            if (!_loc_2[0].match(/^HTTP\/1.1 101 /))
            {
                this.onConnectionError("bad response: " + _loc_2[0]);
                return false;
            }
            var _loc_3:* = {};
            var _loc_4:* = {};
            var _loc_5:* = 1;
            while (_loc_5 < _loc_2.length)
            {
                
                if (_loc_2[_loc_5].length == 0)
                {
                }
                else
                {
                    _loc_7 = _loc_2[_loc_5].match(/^(\S+):(.*)$/);
                    if (!_loc_7)
                    {
                        this.onConnectionError("failed to parse response header line: " + _loc_2[_loc_5]);
                        return false;
                    }
                    _loc_8 = _loc_7[1].toLowerCase();
                    _loc_9 = this.trim(_loc_7[2]);
                    _loc_3[_loc_8] = _loc_9;
                    _loc_4[_loc_8] = _loc_9.toLowerCase();
                }
                _loc_5++;
            }
            if (_loc_4["upgrade"] != "websocket")
            {
                this.onConnectionError("invalid Upgrade: " + _loc_3["Upgrade"]);
                return false;
            }
            if (_loc_4["connection"] != "upgrade")
            {
                this.onConnectionError("invalid Connection: " + _loc_3["Connection"]);
                return false;
            }
            if (!_loc_4["sec-websocket-accept"])
            {
                this.onConnectionError("The WebSocket server speaks old WebSocket protocol, " + "which is not supported by web-socket-js. " + "It requires WebSocket protocol HyBi 10. " + "Try newer version of the server if available.");
                return false;
            }
            var _loc_6:* = _loc_3["sec-websocket-accept"];
            if (_loc_3["sec-websocket-accept"] != this.expectedDigest)
            {
                this.onConnectionError("digest doesn\'t match: " + _loc_6 + " != " + this.expectedDigest);
                return false;
            }
            if (this.requestedProtocols.length > 0)
            {
                this.acceptedProtocol = _loc_3["sec-websocket-protocol"];
                if (this.requestedProtocols.indexOf(this.acceptedProtocol) < 0)
                {
                    this.onConnectionError("protocol doesn\'t match: \'" + this.acceptedProtocol + "\' not in \'" + this.requestedProtocols.join(",") + "\'");
                    return false;
                }
            }
            return true;
        }// end function

        private function sendPong(param1:ByteArray) : Boolean
        {
            var _loc_2:* = new WebSocketFrame();
            _loc_2.opcode = OPCODE_PONG;
            _loc_2.payload = param1;
            return this.sendFrame(_loc_2);
        }// end function

        private function sendFrame(param1:WebSocketFrame) : Boolean
        {
            var frame:* = param1;
            var plength:* = frame.payload.length;
            var mask:* = new ByteArray();
            var i:int;
            while (i < 4)
            {
                
                mask.writeByte(this.randomInt(0, 255));
                i = (i + 1);
            }
            var header:* = new ByteArray();
            header.writeByte((frame.fin ? (128) : (0)) | frame.rsv << 4 | frame.opcode);
            if (plength <= 125)
            {
                header.writeByte(128 | plength);
            }
            else if (plength > 125 && plength < 65536)
            {
                header.writeByte(128 | 126);
                header.writeShort(plength);
            }
            else if (plength >= 65536 && plength < 4294967296)
            {
                header.writeByte(128 | 127);
                header.writeUnsignedInt(0);
                header.writeUnsignedInt(plength);
            }
            else
            {
                this.fatal("Send frame size too large");
            }
            header.writeBytes(mask);
            var maskedPayload:* = new ByteArray();
            maskedPayload.length = frame.payload.length;
            i;
            while (i < frame.payload.length)
            {
                
                maskedPayload[i] = mask[i % 4] ^ frame.payload[i];
                i = (i + 1);
            }
            try
            {
                this.socket.writeBytes(header);
                this.socket.writeBytes(maskedPayload);
                this.socket.flush();
            }
            catch (ex:Error)
            {
                logger.error("Error while sending frame: " + ex.message);
                setTimeout(function () : void
            {
                if (readyState != CLOSED)
                {
                    close(STATUS_CONNECTION_ERROR);
                }
                return;
            }// end function
            , 0);
                return false;
            }
            return true;
        }// end function

        private function parseFrame() : WebSocketFrame
        {
            var _loc_4:* = 0;
            var _loc_1:* = new WebSocketFrame();
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            _loc_2 = 2;
            if (this.buffer.length < _loc_2)
            {
                return null;
            }
            _loc_1.fin = (this.buffer[0] & 128) != 0;
            _loc_1.rsv = (this.buffer[0] & 112) >> 4;
            _loc_1.opcode = this.buffer[0] & 15;
            _loc_1.mask = (this.buffer[1] & 128) != 0;
            _loc_3 = this.buffer[1] & 127;
            if (_loc_3 == 126)
            {
                _loc_2 = 4;
                if (this.buffer.length < _loc_2)
                {
                    return null;
                }
                this.buffer.endian = Endian.BIG_ENDIAN;
                this.buffer.position = 2;
                _loc_3 = this.buffer.readUnsignedShort();
            }
            else if (_loc_3 == 127)
            {
                _loc_2 = 10;
                if (this.buffer.length < _loc_2)
                {
                    return null;
                }
                this.buffer.endian = Endian.BIG_ENDIAN;
                this.buffer.position = 2;
                _loc_4 = this.buffer.readUnsignedInt();
                _loc_3 = this.buffer.readUnsignedInt();
                if (_loc_4 != 0)
                {
                    this.fatal("Frame length exceeds 4294967295. Bailing out!");
                    return null;
                }
            }
            if (this.buffer.length < _loc_2 + _loc_3)
            {
                return null;
            }
            _loc_1.length = _loc_2 + _loc_3;
            _loc_1.payload = new ByteArray();
            this.buffer.position = _loc_2;
            this.buffer.readBytes(_loc_1.payload, 0, _loc_3);
            return _loc_1;
        }// end function

        private function dispatchCloseEvent(param1:Boolean, param2:int, param3:String) : void
        {
            var _loc_4:* = new WebSocketEvent("close");
            _loc_4.wasClean = param1;
            _loc_4.code = param2;
            _loc_4.reason = param3;
            dispatchEvent(_loc_4);
            return;
        }// end function

        private function removeBufferBefore(param1:int) : void
        {
            if (param1 == 0)
            {
                return;
            }
            var _loc_2:* = new ByteArray();
            this.buffer.position = param1;
            this.buffer.readBytes(_loc_2);
            this.buffer = _loc_2;
            return;
        }// end function

        private function generateKey() : String
        {
            var _loc_1:* = new ByteArray();
            _loc_1.length = 16;
            var _loc_2:* = 0;
            while (_loc_2 < _loc_1.length)
            {
                
                _loc_1[_loc_2] = this.randomInt(0, 127);
                _loc_2++;
            }
            return Base64.encodeByteArray(_loc_1);
        }// end function

        private function readUTFBytes(param1:ByteArray, param2:int, param3:int) : String
        {
            param1.position = param2;
            var _loc_4:* = "";
            var _loc_5:* = param2;
            while (_loc_5 < param2 + param3)
            {
                
                if (param1[_loc_5] == 0)
                {
                    _loc_4 = _loc_4 + (param1.readUTFBytes(_loc_5 - param1.position) + "");
                    param1.position = _loc_5 + 1;
                }
                _loc_5++;
            }
            _loc_4 = _loc_4 + param1.readUTFBytes(param2 + param3 - param1.position);
            return _loc_4;
        }// end function

        private function randomInt(param1:uint, param2:uint) : uint
        {
            return param1 + Math.floor(Math.random() * (Number(param2) - param1 + 1));
        }// end function

        private function fatal(param1:String) : void
        {
            this.logger.error(param1);
            throw param1;
        }// end function

    }
}
