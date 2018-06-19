package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class ListVirtualGoodsResponse extends GSResponse
    {

        public function ListVirtualGoodsResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getVirtualGoods() : Vector.<VirtualGood>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<VirtualGood>;
            if (data.virtualGoods != null)
            {
                _loc_2 = data.virtualGoods;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new VirtualGood(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

    }
}
