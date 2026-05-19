using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace TarifWeb
{
    public partial class Default : System.Web.UI.Page
    {
        // Web.config'deki bağlantı dizesini çağırıyoruz
        string baglantiYolu = ConfigurationManager.ConnectionStrings["TarifBaglantisi"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                YemekleriGetir();
            }
        }

        private void YemekleriGetir()
        {
            using (SqlConnection baglanti = new SqlConnection(baglantiYolu))
            {
                string sorgu = "SELECT YemekId, YemekAdi, TarifDetay, FotografYolu, OlusturmaTarihi FROM Yemekler ORDER BY OlusturmaTarihi DESC";

                using (SqlCommand komut = new SqlCommand(sorgu, baglanti))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(komut))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        // Veriyi repeater nesnemize basıyoruz
                        rptYemekler.DataSource = dt;
                        rptYemekler.DataBind();
                    }
                }
            }
        }
    }
}