package com.gamesparks.api.responses
{
    import com.gamesparks.*;

    public class GetUploadedResponse extends GSResponse
    {

        public function GetUploadedResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getSize() : Number
        {
            if (data.size != null)
            {
                return data.size;
            }
            return NaN;
        }// end function

        public function getUrl() : String
        {
            if (data.url != null)
            {
                return data.url;
            }
            return null;
        }// end function

    }
}
