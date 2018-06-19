package com.gamesparks.api.types
{
    import com.gamesparks.*;

    public class Boughtitem extends GSData
    {

        public function Boughtitem(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getQuantity() : Number
        {
            if (data.quantity != null)
            {
                return data.quantity;
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
