package com.gamesparks.api.responses
{
    import com.gamesparks.*;

    public class GetDownloadableResponse extends GSResponse
    {

        public function GetDownloadableResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getLastModified() : Date
        {
            if (data.lastModified != null)
            {
                return RFC3339toDate(data.lastModified);
            }
            return null;
        }// end function

        public function getShortCode() : String
        {
            if (data.shortCode != null)
            {
                return data.shortCode;
            }
            return null;
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
