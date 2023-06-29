using FloristManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FloristManagement.Mapping
{
    public class OccasionMapping
    {
        private FlowersEntities db = new FlowersEntities();

        public List<Occasion> listOfOccaions()
        {
            return db.Occasions.ToList();
        }
    }
}