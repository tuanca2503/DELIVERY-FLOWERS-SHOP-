using FloristManagement.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace FloristManagement.Controllers
{
    public class HomeController : Controller
    {
        private FlowersEntities db = new FlowersEntities();
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
        public ActionResult Sitemap ()
        {
            return View();
        }

        public ActionResult Login()
        {
            if (Session["Email"] != null)
            {
                return RedirectToAction("Index");
            }
            return View();
        }

        [HttpPost]
        public ActionResult Signup(FloristManagement.Models.User user, HttpPostedFileBase ImageFile)
        {
            if (ModelState.IsValid)
            {
                if (ImageFile != null && ImageFile.ContentLength > 0)
                {
                    var fileName = Path.GetFileName(ImageFile.FileName);
                    var filePath = Path.Combine(Server.MapPath("~/Uploads/"), fileName);
                    ImageFile.SaveAs(filePath);
                    var check = db.Users.SingleOrDefault(m => m.Email == user.Email);
                    if (check == null)
                    {
                        user.ImagePath = "~/Uploads/" + fileName;
                        user.Password = FloristManagement.Areas.Admin.Controllers.HomeController.GetMD5(user.Password);
                        db.Users.Add(user);
                        db.SaveChanges();
                        return RedirectToAction("Login");
                    }
                    else
                    {
                        ViewBag.error = "Email already exists";
                        return View();
                    }
                    
                }                
            }

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Login(string Email, string Password)
        {
            if (Email == null || Password == null)
            {
                ViewBag.Message = "Username or Password can't be empty";
                return View();
            }
            var bcryptPassword = FloristManagement.Areas.Admin.Controllers.HomeController.GetMD5(Password);
            var user = db.Users.FirstOrDefault(y => y.Email == Email && y.Password == bcryptPassword);
            if (user != null)
            {
                Session["UserID"] = user.UserID;
                Session["Fullname"] = user.Fullname;
                Session["Address"] = user.Address;
                Session["Email"] = user.Email;
                Session["PhoneNumber"] = user.PhoneNumber;

                return Redirect("Index");
            }
            else
            {
                ViewBag.Message = "Account is not exited! please sign up! ";
                return View();
            }
        }
        public ActionResult Logout()
        {
            Session.Clear();

            return Redirect("Index");
        }
    }
}