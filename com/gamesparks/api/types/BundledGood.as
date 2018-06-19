package com.gamesparks.api.types
{
    import com.gamesparks.*;

    public class BundledGood extends GSData
    {

        public function BundledGood(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getQty() : Number
        {
            if (data.qty != null)
            {
                return data.qty;
            }
            return NaN;
        }// end function

        public function getShortCode() : String
        {
            if (data.shortCode != null)
            {
                return data.shortCode;
            }
            return null;
        }// end function

    }
}
