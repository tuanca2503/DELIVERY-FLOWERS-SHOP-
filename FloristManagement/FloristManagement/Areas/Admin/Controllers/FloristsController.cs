using FloristManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace FloristManagement.Areas.Admin.Controllers
{
    public class FloristsController : Controller
    {
        private FlowersEntities db = new FlowersEntities();
        // GET: Admin/Florists
        public ActionResult Index()
        {
            if (Session["Username"] == null)
            {
                return Redirect("~/Admin/Home/Login");
            }
            var florists = db.Admins.Where(t => t.Role == 2).ToList();
            return View(florists);
        }
        public ActionResult Delete(int? id)
        {
            // Retrieve the item to be deleted based on the id
            var itemToDelete = db.Admins.Find(id);

            if (itemToDelete == null)
            {
                // Handle the case when the item doesn't exist
                return HttpNotFound();
            }

            // Delete the item from the data source
            db.Admins.Remove(itemToDelete);
            db.SaveChanges();

            // Redirect the user to a relevant page after deletion
            return RedirectToAction("Index");
        }
    }
}