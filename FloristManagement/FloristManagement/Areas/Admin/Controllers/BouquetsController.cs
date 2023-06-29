using FloristManagement.Models;
using OfficeOpenXml;
using OfficeOpenXml.Drawing;
using PagedList;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;

namespace FloristManagement.Areas.Admin.Controllers
{
    public class BouquetsController : Controller
    {
        private FlowersEntities db = new FlowersEntities();

        [HttpPost]
        public ActionResult ImportExcel(HttpPostedFileBase file)
        {
            if (file != null && file.ContentLength > 0)
            {
                // Read data from Excel file using EPPlus
                using (var package = new ExcelPackage(file.InputStream))
                {
                    ExcelWorksheet worksheet = package.Workbook.Worksheets[0];
                    int rowCount = worksheet.Dimension.Rows;

                    for (int row = 2; row <= rowCount; row++)
                    {
                        // Read bouquet data from Excel
                        var name = worksheet.Cells[row, 1].Value?.ToString();
                        var price = decimal.Parse(worksheet.Cells[row, 2].Value.ToString());
                        var description = worksheet.Cells[row, 3].Value?.ToString();
                        var brand = worksheet.Cells[row, 4].Value?.ToString();
                        var occasionID = Convert.ToInt32(worksheet.Cells[row, 6].Value.ToString());
                        var imageFilePath = worksheet.Cells[row, 5].Value?.ToString();

                        // Check if bouquet already exists in database
                        Bouquet bouquet = db.Bouquets.FirstOrDefault(b => b.Name == name);

                        if (bouquet == null)
                        {
                            // Bouquet doesn't exist, create new record
                            bouquet = new Bouquet { Name = name, OccasionID = occasionID, Description = description, Price = price, Brand = brand, ImagePath = imageFilePath };
                            db.Bouquets.Add(bouquet);
                        }
                        else
                        {
                            // Bouquet already exists, update record
                            bouquet.Name = name;
                            bouquet.Brand = brand;
                            bouquet.OccasionID = occasionID;
                            bouquet.Description = description;
                            bouquet.Price = price;
                            bouquet.ImagePath = imageFilePath;
                        }

                        db.SaveChanges();
                    }
                }

            }

            return RedirectToAction("Index");
        }

        public ActionResult ExportExcel()
        {
            var bouquetList = db.Bouquets.Include(b => b.Occasion).ToList(); // Get the data to be exported

            ExcelPackage excelPackage = new ExcelPackage();
            var worksheet = excelPackage.Workbook.Worksheets.Add("Bouquets");

            // Add header row
            worksheet.Cells[1, 1].Value = "ID";
            worksheet.Cells[1, 2].Value = "Name";
            worksheet.Cells[1, 3].Value = "Description";
            worksheet.Cells[1, 4].Value = "Brand";
            worksheet.Cells[1, 5].Value = "Price";
            worksheet.Cells[1, 6].Value = "Occasion";
            worksheet.Cells[1, 7].Value = "Image";



            // Add data rows
            int row = 2;
            foreach (var bouquet in bouquetList)
            {
                worksheet.Cells[row, 1].Value = bouquet.BouquetID;
                worksheet.Cells[row, 2].Value = bouquet.Name;
                worksheet.Cells[row, 3].Value = bouquet.Description;
                worksheet.Cells[row, 4].Value = bouquet.Brand;
                worksheet.Cells[row, 5].Value = bouquet.Price;
                worksheet.Cells[row, 6].Value = bouquet.Occasion.Name;
                worksheet.Cells[row, 7].Value = bouquet.ImagePath;

                row++;
            }

            // Set column widths
            worksheet.Column(1).Width = 10;
            worksheet.Column(2).Width = 20;
            worksheet.Column(3).Width = 30;
            worksheet.Column(4).Width = 20;
            worksheet.Column(5).Width = 10;
            worksheet.Column(6).Width = 10;
            worksheet.Column(7).Width = 10;


            // Set response headers
            var memoryStream = new MemoryStream();
            excelPackage.SaveAs(memoryStream);
            memoryStream.Position = 0;
            var fileName = "Bouquets.xlsx";

            return File(memoryStream, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName);
        }

        public ActionResult ImportExcel()
        {
            return View();
        }

        // GET: Admin/Bouquets
        public ActionResult Index(int? page)
        {
            if (Session["Username"] == null)
            {
                return Redirect("~/Admin/Home/Login");
            }
            int pageSize = 10;
            int pageNumber = (page ?? 1);

            var bouquets = db.Bouquets.Include(b => b.Occasion).ToList();

            return View(bouquets.ToPagedList(pageNumber, pageSize));
        }

        // GET: Admin/Bouquets/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Bouquet bouquet = db.Bouquets.Find(id);
            if (bouquet == null)
            {
                return HttpNotFound();
            }
            return View(bouquet);
        }

        // GET: Admin/Bouquets/Create
        public ActionResult Create()
        {
            if (Session["Username"] == null)
            {
                return Redirect("~/Admin/Home/Login");
            }
            ViewBag.OccasionID = new SelectList(db.Occasions, "OccasionID", "Name");
            return View();
        }

        // POST: Admin/Bouquets/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        public ActionResult Create(Bouquet bouquet, HttpPostedFileBase ImageFile)
        {
            if (ModelState.IsValid)
            {
                if (ImageFile != null && ImageFile.ContentLength > 0)
                {
                    var fileName = Path.GetFileName(ImageFile.FileName);
                    var filePath = Path.Combine(Server.MapPath("~/Uploads/"), fileName);
                    ImageFile.SaveAs(filePath);
                    bouquet.ImagePath = "~/Uploads/" + fileName;
                }

                db.Bouquets.Add(bouquet);
                db.SaveChanges();

                return RedirectToAction("Index");
            }

            ViewBag.OccasionID = new SelectList(db.Occasions, "OccasionID", "Name", bouquet.OccasionID);
            return View(bouquet);
        }

        // GET: Admin/Bouquets/Edit/5
        public ActionResult Edit(int? id)
        {
            if (Session["Username"] == null)
            {
                return Redirect("~/Admin/Home/Login");
            }
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Bouquet bouquet = db.Bouquets.Find(id);
            if (bouquet == null)
            {
                return HttpNotFound();
            }
            ViewBag.OccasionID = new SelectList(db.Occasions, "OccasionID", "Name", bouquet.OccasionID);
            return View(bouquet);
        }

        // POST: Admin/Bouquets/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        public ActionResult Edit(Bouquet bouquet, HttpPostedFileBase ImageFile)
        {
            var existingProduct = db.Bouquets.Find(bouquet.BouquetID);

            existingProduct.Name = bouquet.Name;
            existingProduct.Description = bouquet.Description;
            existingProduct.Brand = bouquet.Brand;
            existingProduct.Price = bouquet.Price;
            existingProduct.OccasionID = bouquet.OccasionID;

            if (ImageFile != null && ImageFile.ContentLength > 0)
            {
                var fileName = Path.GetFileName(ImageFile.FileName);
                var filePath = Path.Combine(Server.MapPath("~/Uploads/"), fileName);
                ImageFile.SaveAs(filePath);
                existingProduct.ImagePath = "~/Uploads/" + fileName;
            }

            /*            db.Entry(existingProduct).State = EntityState.Modified;
            */
            db.SaveChanges();

            return RedirectToAction("Index");
        }

        // GET: Admin/Bouquets/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Bouquet bouquet = db.Bouquets.Find(id);
            if (bouquet == null)
            {
                return HttpNotFound();
            }
            return View(bouquet);
        }

        // POST: Admin/Bouquets/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Bouquet bouquet = db.Bouquets.Find(id);
            db.Bouquets.Remove(bouquet);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
