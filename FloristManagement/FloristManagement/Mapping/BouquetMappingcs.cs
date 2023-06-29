using FloristManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FloristManagement.Mapping
{
    public class BouquetMappingcs
    {
        private FlowersEntities db = new FlowersEntities();
        public List<Bouquet> listOfBouquets(string searchTerm, string occasionID, decimal? minPrice, decimal? maxPrice)
        {
            int OccasionID = Convert.ToInt32(occasionID);
            if (OccasionID == 0)
            {
                return db.Bouquets.ToList();
            }
            var bouquets = db.Bouquets
            .Where(b =>
                (string.IsNullOrEmpty(occasionID) || b.OccasionID == OccasionID) &&
                (string.IsNullOrEmpty(searchTerm) || b.Name.Contains(searchTerm)) &&
                (minPrice == null || b.Price >= minPrice) &&
                (maxPrice == null || b.Price <= maxPrice))
            .ToList();

            return bouquets;
        }
        public List<Bouquet> listOfSameOccaionBouquets(int OccasionID, int BouquetID)
        {
            return db.Bouquets.Where(q => q.OccasionID == OccasionID && q.BouquetID != BouquetID).ToList();
        }
        public List<Bouquet> listRandom()
        {
            return db.Bouquets.Take(4).ToList();
        }
    }
}