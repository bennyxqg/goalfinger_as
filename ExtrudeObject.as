package 
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.geom.*;

    public class ExtrudeObject extends Sprite
    {
        private var bdPic:BitmapData;
        private var v3DPointList:Vector.<Vector3D>;
        private var originalMatrix3D:Matrix3D;
        private var picWidth:Number;
        private var picHeight:Number;
        private var spSphere:Sprite;
        private var spSphereImage:Sprite;
        private var rad:Number;
        private var nMesh:Number;
        private var nMeshX:Number;
        private var nMeshY:Number;
        private var tilesNum:Number;
        private var vScale:Number;
        private var vMCModel:MovieClip;
        private var vTextureModel:MovieClip;
        private var vPointFront:Class;
        private var vUVFront:Class;
        private var vPointBack:Class;
        private var vUVBack:Class;
        private var vFrame:int;
        private var vPointList:Vector.<int>;
        private var vUVFrontPos:Vector.<Point>;
        private var vUVBackPos:Vector.<Point>;
        private var vFirstPointBack:int;

        public function ExtrudeObject(param1:MovieClip, param2:MovieClip, param3:int, param4:Class, param5:Class, param6:Class, param7:Class, param8:Number = 1, param9:Number = 0, param10:Number = 0, param11:Number = 0, param12:Number = 0, param13:Number = 0, param14:Number = 0, param15:Array = null)
        {
            var _loc_16:* = 0;
            this.vMCModel = param1;
            this.vTextureModel = param2;
            this.vFrame = param3;
            this.vPointFront = param4;
            this.vUVFront = param5;
            this.vPointBack = param6;
            this.vUVBack = param7;
            this.vPointList = new Vector.<int>(param15.length);
            _loc_16 = 0;
            while (_loc_16 < param15.length)
            {
                
                this.vPointList[_loc_16] = param15[_loc_16];
                _loc_16++;
            }
            this.vScale = param8;
            this.vTextureModel.gotoAndStop(param3);
            this.bdPic = new BitmapData(int(this.vTextureModel.width), int(this.vTextureModel.height), true, 0);
            this.bdPic.draw(this.vTextureModel, null, null, null, null, true);
            this.picWidth = this.bdPic.width * 0.5;
            this.picHeight = this.bdPic.height * 0.5;
            this.rad = Math.floor(120 / (Math.PI * 2));
            this.spSphere = new Sprite();
            this.spSphere.transform.matrix3D = new Matrix3D();
            this.spSphere.rotationX = param9;
            this.spSphere.rotationY = param10;
            this.spSphere.rotationZ = param11;
            this.originalMatrix3D = this.spSphere.transform.matrix3D.clone();
            this.spSphereImage = this;
            this.nMeshX = 9;
            this.nMeshY = 7;
            this.tilesNum = this.nMeshX * this.nMeshY;
            this.setv3DPointList(param12, param13, param14);
            this.rotateSphere(0, 0, 0);
            return;
        }// end function

        private function setv3DPointList(param1:Number = 0, param2:Number = 0, param3:Number = 0) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_11:* = null;
            this.vMCModel.gotoAndStop(this.vFrame);
            var _loc_6:* = new Vector.<MovieClip>(this.vMCModel.numChildren);
            var _loc_7:* = new Vector.<MovieClip>(this.vMCModel.numChildren);
            var _loc_8:* = new Vector.<MovieClip>(this.vMCModel.numChildren);
            _loc_4 = 0;
            while (_loc_4 < this.vMCModel.numChildren)
            {
                
                _loc_6[_loc_4] = null;
                _loc_7[_loc_4] = null;
                _loc_8[_loc_4] = null;
                _loc_4++;
            }
            this.vFirstPointBack = this.vMCModel.numChildren;
            _loc_4 = 0;
            while (_loc_4 < this.vMCModel.numChildren)
            {
                
                _loc_11 = this.vMCModel.getChildAt(_loc_4);
                if (_loc_11 is MovieClip)
                {
                    if (_loc_11 is this.vPointFront)
                    {
                        _loc_9 = Math.round(_loc_11.rotation);
                        _loc_10 = new MovieClip();
                        _loc_10.transform.matrix = MovieClip(_loc_11).transform.matrix.clone();
                        _loc_6[_loc_9] = _loc_10;
                    }
                    else if (_loc_11 is this.vUVFront)
                    {
                        _loc_9 = Math.round(_loc_11.rotation);
                        _loc_10 = new MovieClip();
                        _loc_10.transform.matrix = MovieClip(_loc_11).transform.matrix.clone();
                        _loc_7[_loc_9] = _loc_10;
                    }
                    else if (_loc_11 is this.vPointBack)
                    {
                        _loc_9 = Math.round(_loc_11.rotation);
                        _loc_10 = new MovieClip();
                        _loc_10.transform.matrix = MovieClip(_loc_11).transform.matrix.clone();
                        _loc_6[_loc_9] = _loc_10;
                        if (_loc_9 < this.vFirstPointBack)
                        {
                            this.vFirstPointBack = _loc_9;
                        }
                    }
                    else if (_loc_11 is this.vUVBack)
                    {
                        _loc_9 = Math.round(_loc_11.rotation);
                        _loc_10 = new MovieClip();
                        _loc_10.transform.matrix = MovieClip(_loc_11).transform.matrix.clone();
                        _loc_8[_loc_9] = _loc_10;
                    }
                }
                _loc_4++;
            }
            this.v3DPointList = new Vector.<Vector3D>;
            this.vUVFrontPos = new Vector.<Point>;
            this.vUVBackPos = new Vector.<Point>;
            _loc_4 = 0;
            while (_loc_4 < _loc_6.length)
            {
                
                if (_loc_6[_loc_4] != null)
                {
                    this.v3DPointList[this.v3DPointList.length] = new Vector3D(this.vScale * _loc_6[_loc_4].x + param1, this.vScale * (_loc_6[_loc_4].y - this.picHeight) + param2, this.vScale * ((-(_loc_6[_loc_4].scaleX - 1)) * 60) + param3);
                    if (_loc_7[_loc_4] == null)
                    {
                        this.vUVFrontPos[this.vUVFrontPos.length] = new Point(_loc_6[_loc_4].x + this.picWidth, _loc_6[_loc_4].y);
                    }
                    else
                    {
                        this.vUVFrontPos[this.vUVFrontPos.length] = new Point(_loc_7[_loc_4].x + this.picWidth, _loc_7[_loc_4].y);
                    }
                    if (_loc_8[_loc_4] == null)
                    {
                        this.vUVBackPos[this.vUVBackPos.length] = new Point(_loc_6[_loc_4].x + this.picWidth * 2, _loc_6[_loc_4].y);
                    }
                    else
                    {
                        this.vUVBackPos[this.vUVBackPos.length] = new Point(_loc_8[_loc_4].x + this.picWidth * 2, _loc_8[_loc_4].y);
                    }
                }
                _loc_4++;
            }
            return;
        }// end function

        public function rotateSphere(param1:Number, param2:Number, param3:Number) : void
        {
            var _loc_4:* = null;
            this.spSphere.transform.matrix3D.appendRotation(param1, Vector3D.X_AXIS);
            this.spSphere.transform.matrix3D.appendRotation(param2, Vector3D.Y_AXIS);
            this.spSphere.transform.matrix3D.appendRotation(param3, Vector3D.Z_AXIS);
            _loc_4 = this.spSphere.transform.matrix3D.clone();
            this.transformSphere(_loc_4);
            return;
        }// end function

        public function autoSpin(param1:Number) : void
        {
            var _loc_2:* = null;
            this.spSphere.transform.matrix3D.prependRotation(param1, Vector3D.Y_AXIS);
            _loc_2 = this.spSphere.transform.matrix3D.clone();
            this.transformSphere(_loc_2);
            return;
        }// end function

        public function AbsRotateSphere(param1:Number = 0, param2:Number = 0, param3:Number = 0) : void
        {
            this.spSphere.transform.matrix3D = this.originalMatrix3D.clone();
            if (param1 != 0)
            {
                this.spSphere.transform.matrix3D.prependRotation(param1, Vector3D.X_AXIS);
            }
            if (param2 != 0)
            {
                this.spSphere.transform.matrix3D.prependRotation(param2, Vector3D.Y_AXIS);
            }
            if (param3 != 0)
            {
                this.spSphere.transform.matrix3D.prependRotation(param3, Vector3D.Z_AXIS);
            }
            this.transformSphere(this.spSphere.transform.matrix3D.clone());
            return;
        }// end function

        private function transformSphere(param1:Matrix3D) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_18:* = 0;
            var _loc_19:* = 0;
            var _loc_20:* = 0;
            var _loc_22:* = 0;
            var _loc_5:* = [];
            var _loc_6:* = [];
            var _loc_7:* = [];
            var _loc_10:* = 0;
            var _loc_11:* = new Vector.<Number>;
            var _loc_12:* = new Vector.<int>;
            var _loc_13:* = new Vector.<Number>;
            var _loc_14:* = new Vector3D();
            var _loc_15:* = new Vector3D();
            var _loc_16:* = new Vector3D();
            var _loc_17:* = param1.clone();
            _loc_11 = new Vector.<Number>;
            _loc_12 = new Vector.<int>;
            _loc_13 = new Vector.<Number>;
            this.spSphereImage.graphics.clear();
            _loc_2 = 0;
            while (_loc_2 < this.v3DPointList.length)
            {
                
                _loc_7[_loc_2] = _loc_17.deltaTransformVector(this.v3DPointList[_loc_2]);
                _loc_2++;
            }
            _loc_4 = 0;
            while (_loc_4 < this.vPointList.length)
            {
                
                _loc_18 = this.vPointList[_loc_4] - 1;
                _loc_19 = this.vPointList[(_loc_4 + 1)] - 1;
                _loc_20 = this.vPointList[_loc_4 + 2] - 1;
                _loc_8 = (_loc_7[_loc_18].z + _loc_7[_loc_19].z + _loc_7[_loc_20].z) / 3;
                _loc_5.push([_loc_8, _loc_4]);
                _loc_4 = _loc_4 + 3;
            }
            _loc_5.sort(this.byDist);
            var _loc_21:* = 0;
            _loc_4 = 0;
            while (_loc_4 < this.vPointList.length)
            {
                
                _loc_22 = _loc_5[_loc_21][1];
                _loc_18 = this.vPointList[_loc_22] - 1;
                _loc_19 = this.vPointList[(_loc_22 + 1)] - 1;
                _loc_20 = this.vPointList[_loc_22 + 2] - 1;
                _loc_14 = _loc_7[_loc_18];
                _loc_15 = _loc_7[_loc_19];
                _loc_16 = _loc_7[_loc_20];
                _loc_11.push(_loc_14.x, _loc_14.y, _loc_15.x, _loc_15.y, _loc_16.x, _loc_16.y);
                _loc_12.push(_loc_10, (_loc_10 + 1), _loc_10 + 2);
                if (_loc_18 >= this.vFirstPointBack || _loc_19 >= this.vFirstPointBack || _loc_20 >= this.vFirstPointBack)
                {
                    _loc_13.push(this.vUVBackPos[_loc_18].x / this.bdPic.width, this.vUVBackPos[_loc_18].y / this.bdPic.height, this.vUVBackPos[_loc_19].x / this.bdPic.width, this.vUVBackPos[_loc_19].y / this.bdPic.height, this.vUVBackPos[_loc_20].x / this.bdPic.width, this.vUVBackPos[_loc_20].y / this.bdPic.height);
                }
                else
                {
                    _loc_13.push(this.vUVFrontPos[_loc_18].x / this.bdPic.width, this.vUVFrontPos[_loc_18].y / this.bdPic.height, this.vUVFrontPos[_loc_19].x / this.bdPic.width, this.vUVFrontPos[_loc_19].y / this.bdPic.height, this.vUVFrontPos[_loc_20].x / this.bdPic.width, this.vUVFrontPos[_loc_20].y / this.bdPic.height);
                }
                _loc_10 = _loc_10 + 3;
                _loc_21++;
                _loc_4 = _loc_4 + 3;
            }
            this.spSphereImage.graphics.beginBitmapFill(this.bdPic, null, true, true);
            this.spSphereImage.graphics.drawTriangles(_loc_11, _loc_12, _loc_13);
            this.spSphereImage.graphics.endFill();
            return;
        }// end function

        private function byDist(param1:Array, param2:Array) : Number
        {
            if (param1[0] > param2[0])
            {
                return -1;
            }
            if (param1[0] < param2[0])
            {
                return 1;
            }
            return 0;
        }// end function

        public function destroy() : void
        {
            this.spSphereImage.graphics.clear();
            this.spSphereImage = null;
            this.spSphere = null;
            if (this.bdPic != null)
            {
                this.bdPic.dispose();
            }
            this.bdPic = null;
            return;
        }// end function

    }
}
