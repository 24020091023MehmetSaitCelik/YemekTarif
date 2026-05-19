using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace TarifWeb
{
    public partial class Yonetim : System.Web.UI.Page
    {
        string baglantiYolu = ConfigurationManager.ConnectionStrings["TarifBaglantisi"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                MalzemeDropdownDoldur();
                GridDoldur();
            }
        }

        // Malzemeler tablosundaki verileri select elementine çeker
        private void MalzemeDropdownDoldur()
        {
            using (SqlConnection baglanti = new SqlConnection(baglantiYolu))
            {
                string sorgu = "SELECT MalzemeId, MalzemeAdi FROM Malzemeler";
                using (SqlCommand komut = new SqlCommand(sorgu, baglanti))
                {
                    baglanti.Open();
                    ddlMalzemeler.DataSource = komut.ExecuteReader();
                    ddlMalzemeler.DataTextField = "MalzemeAdi";
                    ddlMalzemeler.DataValueField = "MalzemeId";
                    ddlMalzemeler.DataBind();
                }
            }
            ddlMalzemeler.Items.Insert(0, new ListItem("--- Malzeme Seçin ---", "0"));
        }

        // GridView nesnesine kayıtlı yemekleri listeler (CRUD - Read)
        private void GridDoldur()
        {
            using (SqlConnection baglanti = new SqlConnection(baglantiYolu))
            {
                string sorgu = "SELECT YemekId, YemekAdi FROM Yemekler ORDER BY YemekId DESC";
                using (SqlDataAdapter da = new SqlDataAdapter(sorgu, baglanti))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    gvYemekler.DataSource = dt;
                    gvYemekler.DataBind();
                }
            }
        }

        // Kaydet butonu: Hem Ekleme hem Güncelleme yapar (CRUD - Create & Update)
        protected void btnKaydet_Click(object sender, EventArgs e)
        {
            using (SqlConnection baglanti = new SqlConnection(baglantiYolu))
            {
                baglanti.Open();

                if (string.IsNullOrEmpty(hfYemekId.Value))
                {
                    // VERİ EKLEME (Create)
                    string yemekSorgu = "INSERT INTO Yemekler (YemekAdi, TarifDetay, FotografYolu) VALUES (@YemekAdi, @TarifDetay, @FotografYolu); SELECT SCOPE_IDENTITY();";
                    int yeniYemekId = 0;

                    using (SqlCommand cmd = new SqlCommand(yemekSorgu, baglanti))
                    {
                        cmd.Parameters.AddWithValue("@YemekAdi", txtYemekAdi.Text);
                        cmd.Parameters.AddWithValue("@TarifDetay", txtTarifDetay.Text);
                        cmd.Parameters.AddWithValue("@FotografYolu", txtFotograf.Text);
                        yeniYemekId = Convert.ToInt32(cmd.ExecuteScalar()); // Yeni eklenen yemeğin ID'sini alırız
                    }

                    // Ara tabloya malzeme ilişkisini ekleme (Çoka Çok İlişki)
                    if (ddlMalzemeler.SelectedValue != "0")
                    {
                        string malzemeSorgu = "INSERT INTO YemekMalzeme (YemekId, MalzemeId, Miktar) VALUES (@YemekId, @MalzemeId, @Miktar)";
                        using (SqlCommand cmdMalzeme = new SqlCommand(malzemeSorgu, baglanti))
                        {
                            cmdMalzeme.Parameters.AddWithValue("@YemekId", yeniYemekId);
                            cmdMalzeme.Parameters.AddWithValue("@MalzemeId", ddlMalzemeler.SelectedValue);
                            cmdMalzeme.Parameters.AddWithValue("@Miktar", txtMiktar.Text);
                            cmdMalzeme.ExecuteNonQuery();
                        }
                    }

                    // Alışveriş listesine ekleme
                    if (!string.IsNullOrEmpty(txtAlisveris.Text))
                    {
                        string alisverisSorgu = "INSERT INTO AlisverisListesi (YemekId, Alinacaklar) VALUES (@YemekId, @Alinacaklar)";
                        using (SqlCommand cmdAlisveris = new SqlCommand(alisverisSorgu, baglanti))
                        {
                            cmdAlisveris.Parameters.AddWithValue("@YemekId", yeniYemekId);
                            cmdAlisveris.Parameters.AddWithValue("@Alinacaklar", txtAlisveris.Text);
                            cmdAlisveris.ExecuteNonQuery();
                        }
                    }
                }
                else
                {
                    // VERİ GÜNCELLEME (Update)
                    string guncelleSorgu = "UPDATE Yemekler SET YemekAdi=@YemekAdi, TarifDetay=@TarifDetay, FotografYolu=@FotografYolu WHERE YemekId=@YemekId";
                    using (SqlCommand cmd = new SqlCommand(guncelleSorgu, baglanti))
                    {
                        cmd.Parameters.AddWithValue("@YemekId", hfYemekId.Value);
                        cmd.Parameters.AddWithValue("@YemekAdi", txtYemekAdi.Text);
                        cmd.Parameters.AddWithValue("@TarifDetay", txtTarifDetay.Text);
                        cmd.Parameters.AddWithValue("@FotografYolu", txtFotograf.Text);
                        cmd.ExecuteNonQuery();
                    }
                }
            }

            FormuTemizle();
            GridDoldur();
        }

        // Grid üzerindeki Düzenle ve Sil butonlarının tetiklenmesi
        protected void gvYemekler_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int yemekId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Sil")
            {
                // VERİ SİLME (CRUD - Delete)
                using (SqlConnection baglanti = new SqlConnection(baglantiYolu))
                {
                    string silSorgu = "DELETE FROM Yemekler WHERE YemekId = @YemekId";
                    using (SqlCommand cmd = new SqlCommand(silSorgu, baglanti))
                    {
                        cmd.Parameters.AddWithValue("@YemekId", yemekId);
                        baglanti.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                GridDoldur();
                FormuTemizle();
            }
            else if (e.CommandName == "Sec")
            {
                // Düzenlemek için verileri form alanlarına doldurma
                using (SqlConnection baglanti = new SqlConnection(baglantiYolu))
                {
                    string secSorgu = "SELECT YemekId, YemekAdi, TarifDetay, FotografYolu FROM Yemekler WHERE YemekId = @YemekId";
                    using (SqlCommand cmd = new SqlCommand(secSorgu, baglanti))
                    {
                        cmd.Parameters.AddWithValue("@YemekId", yemekId);
                        baglanti.Open();
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                hfYemekId.Value = dr["YemekId"].ToString();
                                txtYemekAdi.Text = dr["YemekAdi"].ToString();
                                txtTarifDetay.Text = dr["TarifDetay"].ToString();
                                txtFotograf.Text = dr["FotografYolu"].ToString();

                                btnKaydet.Text = "Değişiklikleri Kaydet";
                                btnTemizle.Visible = true;
                            }
                        }
                    }
                }
            }
        }

        protected void btnTemizle_Click(object sender, EventArgs e)
        {
            FormuTemizle();
        }

        private void FormuTemizle()
        {
            hfYemekId.Value = "";
            txtYemekAdi.Text = "";
            txtTarifDetay.Text = "";
            txtFotograf.Text = "";
            txtMiktar.Text = "";
            txtAlisveris.Text = "";
            ddlMalzemeler.SelectedIndex = 0;
            btnKaydet.Text = "Tarifi Kaydet";
            btnTemizle.Visible = false;
        }
    }
}