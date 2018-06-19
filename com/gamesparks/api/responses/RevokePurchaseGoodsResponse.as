package com.gamesparks.api.responses
{
    import com.gamesparks.*;

    public class RevokePurchaseGoodsResponse extends GSResponse
    {

        public function RevokePurchaseGoodsResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getRevokedGoods() : Object
        {
            if (data.revokedGoods != null)
            {
                return data.revokedGoods;
            }
            return null;
        }// end function

    }
}
