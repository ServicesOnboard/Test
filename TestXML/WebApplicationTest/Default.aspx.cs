using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplicationTest
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string ss = "<h1>Hello world</h1>";//your html string
            HyperLink hl = new HyperLink();
            hl.ID = "hl_test";
            hl.InnerHtml = ss;
        }
    }
}