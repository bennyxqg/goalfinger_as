package globz
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;

    public class BitmapSphere extends Sprite
    {
        private var bdPic:BitmapData;
        private var vertsVec:Vector.<Vector.<Vector3D>>;
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
        private var vSpotList:Array;
        private var spSphere2:Sprite;

        public function BitmapSphere(param1:MovieClip, param2:Number = 1, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:Number = 0, param8:Number = 0, param9:MovieClip = null)
        {
            var _loc_10:* = 0;
            var _loc_11:* = null;
            var _loc_12:* = null;
            this.vScale = param2;
            this.bdPic = new BitmapData(int(1024), int(512), true, 0);
            this.bdPic.draw(param1, null, null, null, null, true);
            this.picWidth = this.bdPic.width;
            this.picHeight = this.picWidth / 2;
            this.rad = 50 * this.vScale;
            this.spSphere = new Sprite();
            this.spSphere.transform.matrix3D = new Matrix3D();
            this.spSphere.rotationX = param3;
            this.spSphere.rotationY = param4;
            this.spSphere.rotationZ = param5;
            this.transform.perspectiveProjection = new PerspectiveProjection();
            this.transform.perspectiveProjection.focalLength = 100000;
            this.transform.perspectiveProjection.projectionCenter = new Point(0, 0);
            this.originalMatrix3D = this.spSphere.transform.matrix3D.clone();
            this.spSphereImage = this;
            this.nMeshX = 20;
            this.nMeshY = 10;
            this.tilesNum = this.nMeshX * this.nMeshY;
            this.vertsVec = new Vector.<Vector.<Vector3D>>(this.nMeshX);
            this.setVertsVec(param6, param7, param8);
            this.rotateSphere(0, 0, 0);
            this.spSphere2 = new Sprite();
            this.spSphere2.transform.matrix3D = this.spSphere.transform.matrix3D.clone();
            this.vSpotList = new Array();
            if (param9 != null)
            {
                _loc_10 = 0;
                while (_loc_10 < param9.numChildren)
                {
                    
                    _loc_11 = param9.getChildAt(_loc_10);
                    _loc_12 = getClass(_loc_11);
                    this.vSpotList[_loc_10] = new _loc_12 as MovieClip;
                    var _loc_13:* = _loc_11.scaleX;
                    this.vSpotList[_loc_10].scaleY = _loc_11.scaleX;
                    this.vSpotList[_loc_10].scaleX = _loc_13;
                    this.vSpotList[_loc_10].x = 0;
                    this.vSpotList[_loc_10].y = 0;
                    this.vSpotList[_loc_10].z = this.rad;
                    this.vSpotList[_loc_10].transform.matrix3D.appendRotation((-(_loc_11.y - 256)) * 90 / 256, Vector3D.X_AXIS, new Vector3D(0, 0, 0));
                    this.vSpotList[_loc_10].transform.matrix3D.appendRotation((-(_loc_11.x - 512)) * 180 / 512, Vector3D.Y_AXIS, new Vector3D(0, 0, 0));
                    this.spSphere2.addChild(this.vSpotList[_loc_10]);
                    _loc_10++;
                }
            }
            this.addChild(this.spSphere2);
            return;
        }// end function

        private function setVertsVec(param1:Number = 0, param2:Number = 0, param3:Number = 0) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            _loc_6 = 2 * Math.PI / this.nMeshX;
            _loc_7 = Math.PI / this.nMeshY;
            var _loc_8:* = 1;
            var _loc_9:* = 1;
            _loc_4 = 0;
            while (_loc_4 <= this.nMeshX)
            {
                
                this.vertsVec[_loc_4] = new Vector.<Vector3D>(this.nMesh);
                _loc_5 = 0;
                while (_loc_5 <= this.nMeshY)
                {
                    
                    this.vertsVec[_loc_4][_loc_5] = new Vector3D(this.rad * Math.sin(_loc_6 * _loc_4) * Math.sin(_loc_7 * _loc_5) * _loc_8 + param1, (-this.rad) * Math.cos(_loc_7 * _loc_5) + param2, (-this.rad) * Math.cos(_loc_6 * _loc_4) * Math.sin(_loc_7 * _loc_5) * _loc_8 * _loc_9 + param3);
                    _loc_5++;
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
            var _loc_4:* = 0;
            var _loc_5:* = NaN;
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
            this.spSphere2.transform.matrix3D = this.spSphere.transform.matrix3D.clone();
            _loc_4 = 0;
            while (_loc_4 < this.vSpotList.length)
            {
                
                _loc_5 = this.vSpotList[_loc_4].transform.getRelativeMatrix3D(this).position.z;
                if (_loc_5 > 0)
                {
                    this.vSpotList[_loc_4].visible = false;
                }
                else
                {
                    this.vSpotList[_loc_4].visible = true;
                }
                _loc_4++;
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
            var _loc_5:* = [];
            var _loc_6:* = [];
            var _loc_7:* = [];
            var _loc_10:* = 0;
            var _loc_11:* = new Vector.<Number>;
            var _loc_12:* = new Vector.<int>;
            var _loc_13:* = new Vector.<Number>;
            var _loc_14:* = new Point();
            var _loc_15:* = new Point();
            var _loc_16:* = new Point();
            var _loc_17:* = new Point();
            var _loc_18:* = param1.clone();
            _loc_11 = new Vector.<Number>;
            _loc_12 = new Vector.<int>;
            _loc_13 = new Vector.<Number>;
            this.spSphereImage.graphics.clear();
            _loc_2 = 0;
            while (_loc_2 <= this.nMeshX)
            {
                
                _loc_7[_loc_2] = [];
                _loc_3 = 0;
                while (_loc_3 <= this.nMeshY)
                {
                    
                    _loc_7[_loc_2][_loc_3] = _loc_18.deltaTransformVector(this.vertsVec[_loc_2][_loc_3]);
                    _loc_3++;
                }
                _loc_2++;
            }
            _loc_2 = 0;
            while (_loc_2 < this.nMeshX)
            {
                
                _loc_3 = 0;
                while (_loc_3 < this.nMeshY)
                {
                    
                    _loc_8 = (_loc_7[_loc_2][_loc_3].z + _loc_7[(_loc_2 + 1)][_loc_3].z + _loc_7[_loc_2][(_loc_3 + 1)].z + _loc_7[(_loc_2 + 1)][(_loc_3 + 1)].z) / 4;
                    _loc_9 = _loc_8;
                    _loc_5.push([_loc_9, _loc_2, _loc_3]);
                    _loc_3++;
                }
                _loc_2++;
            }
            _loc_5.sort(this.byDist);
            _loc_2 = 0;
            while (_loc_2 <= this.nMeshX)
            {
                
                _loc_6[_loc_2] = [];
                _loc_3 = 0;
                while (_loc_3 <= this.nMeshY)
                {
                    
                    _loc_6[_loc_2][_loc_3] = new Point(_loc_7[_loc_2][_loc_3].x, _loc_7[_loc_2][_loc_3].y);
                    _loc_3++;
                }
                _loc_2++;
            }
            _loc_4 = 0;
            while (_loc_4 < this.tilesNum)
            {
                
                _loc_2 = _loc_5[_loc_4][1];
                _loc_3 = _loc_5[_loc_4][2];
                _loc_14 = _loc_6[_loc_2][_loc_3].clone();
                _loc_15 = _loc_6[(_loc_2 + 1)][_loc_3].clone();
                _loc_16 = _loc_6[(_loc_2 + 1)][(_loc_3 + 1)].clone();
                _loc_17 = _loc_6[_loc_2][(_loc_3 + 1)].clone();
                if ((_loc_15.x - _loc_14.x) * (_loc_17.y - _loc_14.y) - (_loc_15.y - _loc_14.y) * (_loc_17.x - _loc_14.x) >= 0)
                {
                    _loc_11.push(_loc_14.x, _loc_14.y, _loc_15.x, _loc_15.y, _loc_16.x, _loc_16.y, _loc_17.x, _loc_17.y);
                    _loc_12.push(_loc_10, (_loc_10 + 1), _loc_10 + 3, (_loc_10 + 1), _loc_10 + 2, _loc_10 + 3);
                    _loc_13.push(_loc_2 / this.nMeshX, _loc_3 / this.nMeshY, (_loc_2 + 1) / this.nMeshX, _loc_3 / this.nMeshY, (_loc_2 + 1) / this.nMeshX, (_loc_3 + 1) / this.nMeshY, _loc_2 / this.nMeshX, (_loc_3 + 1) / this.nMeshY);
                    _loc_10 = _loc_10 + 4;
                }
                _loc_4++;
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
            var _loc_1:* = 0;
            this.spSphereImage.graphics.clear();
            this.spSphereImage = null;
            this.spSphere = null;
            this.spSphere2 = null;
            if (this.vSpotList != null && this.vSpotList.length > 0)
            {
                _loc_1 = 0;
                while (_loc_1 < this.vSpotList.length)
                {
                    
                    this.vSpotList[_loc_1] = null;
                    _loc_1++;
                }
            }
            this.vSpotList = null;
            if (this.bdPic != null)
            {
                this.bdPic.dispose();
            }
            this.bdPic = null;
            return;
        }// end function

        private static function getClass(param1:Object) : Class
        {
            return Class(getDefinitionByName(getQualifiedClassName(param1)));
        }// end function

    }
}
