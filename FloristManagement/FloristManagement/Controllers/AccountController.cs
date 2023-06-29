using FloristManagement.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace FloristManagement.Controllers
{
    public class AccountController : Controller
    {
        // GET: Account
        FlowersEntities db = new FlowersEntities();
        public ActionResult ViewAccount()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            if (userId == 0)
            {
                return RedirectToAction("Login", "Home");
            }
            var user  = db.Users.SingleOrDefault(u => u.UserID == userId);
            if(user == null)
            {
                ViewBag.Message = "Please sign up your account";
                return RedirectToAction("Login", "Home");
            }
            return View(user);
        }
        [HttpPost]
        public ActionResult UpdateAccount(User user, HttpPostedFileBase ImageFile)
        {
            var existingProduct = db.Users.Find(user.UserID);

            existingProduct.Fullname = user.Fullname;
            existingProduct.Email = user.Email;
            existingProduct.PhoneNumber = user.PhoneNumber;
            existingProduct.Address = user.Address;

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

            return RedirectToAction("ViewAccount");
        }
    }
}