using FloristManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.Entity;
using OfficeOpenXml;
using System.IO;

namespace FloristManagement.Areas.Admin.Controllers
{
    public class OrdersController : Controller
    {
        private FlowersEntities db = new FlowersEntities();
        // GET: Admin/Orders
        public ActionResult Index()
        {
            var orders = db.Orders
                .OrderByDescending(o => o.DeliveryDate)
                .Include(o => o.OrderDetails)
                .ToList();
            return View(orders);
        }
        [HttpPost]
        public ActionResult UpdateStatus(int orderId, string status)
        {
            var order = db.Orders.FirstOrDefault(o => o.OrderID == orderId);

            if (order != null)
            {
                order.Status = status;
                db.SaveChanges();
            }

            return RedirectToAction("Index");
        }
        public ActionResult ExportExcel()
        {
            var orderList = db.Orders.Include(b => b.Payment).Include(b => b.User).ToList(); // Get the data to be exported

            ExcelPackage excelPackage = new ExcelPackage();
            var worksheet = excelPackage.Workbook.Worksheets.Add("Bouquets");

            // Add header row
            worksheet.Cells[1, 1].Value = "ID";
            worksheet.Cells[1, 2].Value = "Name";
            worksheet.Cells[1, 3].Value = "Payment Method";
            worksheet.Cells[1, 4].Value = "Price";
            worksheet.Cells[1, 5].Value = "Phonenumber";
            worksheet.Cells[1, 5].Value = "Delivery Date";
            worksheet.Cells[1, 6].Value = "To Address";
            worksheet.Cells[1, 7].Value = "Status";



            // Add data rows
            int row = 2;
            foreach (var order in orderList)
            {
                worksheet.Cells[row, 1].Value = order.OrderID;
                worksheet.Cells[row, 2].Value = order.User.Fullname;
                worksheet.Cells[row, 3].Value = order.Payment.PaymentMethod;
                worksheet.Cells[row, 4].Value = order.TotalPrice;
                worksheet.Cells[row, 5].Value = order.PhonenNumber;
                worksheet.Cells[row, 5].Value = order.DeliveryDate;
                worksheet.Cells[row, 6].Value = order.DeliveryAddress;
                worksheet.Cells[row, 7].Value = order.Status;

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
            var fileName = "Orders - " +DateTime.Now.ToString("dd/MM/yyyy") + ".xlsx";

            return File(memoryStream, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName);
        }
    }
}