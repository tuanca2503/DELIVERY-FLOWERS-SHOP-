using FloristManagement.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Migrations;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;

namespace FloristManagement.Areas.Admin.Controllers
{
    public class OccasionsController : Controller
    {
        private FlowersEntities db = new FlowersEntities();

        // GET: Admin/Occasions
        public ActionResult Index()
        {
            return View(db.Occasions.ToList());
        }

        // GET: Admin/Occasions/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Occasion occasion = db.Occasions.Find(id);
            if (occasion == null)
            {
                return HttpNotFound();
            }
            return View(occasion);
        }

        // GET: Admin/Occasions/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Admin/Occasions/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        public ActionResult Create(Occasion occasion, HttpPostedFileBase ImageFile)
        {
            if (ModelState.IsValid)
            {
                if (ImageFile != null && ImageFile.ContentLength > 0)
                {
                    var fileName = Path.GetFileName(ImageFile.FileName);
                    var filePath = Path.Combine(Server.MapPath("~/Uploads/"), fileName);
                    ImageFile.SaveAs(filePath);
                    occasion.ImagePath = "~/Uploads/" + fileName;
                }

                db.Occasions.Add(occasion);
                db.SaveChanges();

                return RedirectToAction("Index");

            }

            return View(occasion);
        }

        // GET: Admin/Occasions/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Occasion occasion = db.Occasions.Find(id);
            if (occasion == null)
            {
                return HttpNotFound();
            }
            return View(occasion);
        }

        // POST: Admin/Occasions/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        public ActionResult Edit(Occasion occasion, HttpPostedFileBase ImageFile)
        {
            var existingProduct = db.Occasions.Find(occasion.OccasionID);

            existingProduct.Name = occasion.Name;

            if (ImageFile != null && ImageFile.ContentLength > 0)
            {
                var fileName = Path.GetFileName(ImageFile.FileName);
                var filePath = Path.Combine(Server.MapPath("~/Uploads/"), fileName);
                ImageFile.SaveAs(filePath);
                existingProduct.ImagePath = "~/Uploads/" + fileName;
            }

            db.Entry(existingProduct).State = EntityState.Modified;
            db.SaveChanges();

            return RedirectToAction("Index");

        }

        // GET: Admin/Occasions/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Occasion occasion = db.Occasions.Find(id);
            if (occasion == null)
            {
                return HttpNotFound();
            }
            return View(occasion);
        }

        // POST: Admin/Occasions/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Occasion occasion = db.Occasions.Find(id);
            db.Occasions.Remove(occasion);
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
